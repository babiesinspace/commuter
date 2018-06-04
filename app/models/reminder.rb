class Reminder < ApplicationRecord
  belongs_to :commute
  delegate :user, to: :commute
  delegate :duration, to: :commute
  after_save :generate_text_time

  # Returns ActiveRecord::Relation with reminders.. needed?
  def self.grab_daily
    self.where(text_time: Date.today.all_day)
  end 

  def self.grab_hourly
    Reminder.where(text_time: (Time.now.utc.beginning_of_hour..Time.now.utc.end_of_hour))
  end

  def format_for_google
    # Reminder.find(self.id).joins(commute: [:location, :user]).pluck(:start_time, :latitude, :longitude, :home_latitude, :home_longitude)
    info_array = Reminder.where(id: self.id).joins(commute: [:location]).pluck(:start_time, :latitude, :longitude).first
    {start_time: info_array[0].to_i, latitude: info_array[1], longitude: info_array[2]}
  end

  def transit_data
    formatted_hash = self.format_for_google
    #plus sign or comma between lat and long?
    response = HTTParty.get("https://maps.googleapis.com/maps/api/directions/json?&mode=transit&origin=540+saint+johns+place+brooklyn+ny+11238&destination=#{formatted_hash[:latitude]}+#{formatted_hash[:longitude]}&arrival_time=#{formatted_hash[:start_time].to_s}&key=#{ENV['GOOGLE_ROUTES_API_KEY']}")
    response
  end

  #this returns an array of transit-specific direction objects returned by google api
  def just_transit(response)
    response["steps"].map {|step| step if step["travel_mode"] == "TRANSIT" }.compact #.compact will remove the nil values
  end 

  def format_transit(response)
    transit_directions = self.just_transit(response)
    transit_directions.map.with_index(1) do |direction, direction_number|
      transit_mode = direction["transit_details"]["line"]["vehicle"]["name"]
      transit_mode == "Subway" ? transit_mode = "train" : transit_mode
      transit_line = direction["transit_details"]["line"]["short_name"]
      starting_stop = direction["transit_details"]["departure_stop"]["name"]
      starting_stop_depart_time = direction["transit_details"]["departure_time"]["text"]
      ending_stop = direction["transit_details"]["arrival_stop"]["name"]
      ending_stop_arrival_time = direction["transit_details"]["arrival_time"]["text"]
      info_string = "Take the #{transit_line} #{transit_mode} LEAVING at #{starting_stop_depart_time} from #{starting_stop}, gets in to #{ending_stop} at #{ending_stop_arrival_time}"
      if transit_directions.length == 1
        direction = info_string
      else
        direction = "#{direction_number.to_s} - " + info_string
      end
      direction
    end
  end

  def format_basic_info(response)
    arrival_time = response["arrival_time"]["text"]
    departure = response["departure_time"]["text"]
    duration_string = response["duration"]["text"]
    duration_seconds = response["duration"]["value"]
    generate_text_time(duration_seconds)
    start_address = response["start_address"]
    end_address = response["end_address"]
    "You need to leave from #{start_address} at #{departure}. It will take you #{duration_string} to get to #{end_address} at #{arrival_time} \n "
  end

  #routes holds an array of route options. MVP will have no alternatives, just the google first choice, so always grab the first
  #legs holds an array of 'legs' of the journey. if no waypoints are specified, this will only every hold one. MVP will not take way points, so only grab the first for now. 
  def format_text
    response = self.transit_data
    #change this post-MVP, see above notes
    response = response["routes"][0]["legs"][0]
    basic = self.format_basic_info(response)
    instructions = self.format_transit(response).join("\n")
    return (basic + instructions)
  end

  def duration_in_seconds
    response = self.transit_data
    #change this post-MVP, see above notes
    response = response["routes"][0]["legs"][0]
    response["duration"]["value"]
  end

  #method call to send text
  def reminder
    @twilio_number = ENV['TWILIO_NUMBER']
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    @client = Twilio::REST::Client.new account_sid, ENV['TWILIO_AUTH_TOKEN']
    reminder = self.format_text
    send_to = self.user.phonenumber
    message = @client.api.account.messages.create(
      from: @twilio_number,
      to: send_to,
      body: reminder
    )
  end

  #doesn't work yet
  #set to nil for on create and use Commute's duration, otherwise update it when calling Google (necessary?)
  def generate_text_time(duration=nil)
    start = self.start_time
    if duration == nil
      duration = self.commute.duration
    end
    time_to_send = (start - duration.seconds - 15.minutes)
    #if reminder 
    if (time_to_send >= Time.now.utc) && (start >= Time.now.utc)
      self.text_time = time_to_send
    elsif start >= Time.now.utc
      self.text_time = Time.now
    else
      Reminder.find(self.id).destroy
      return nil
    end
  end



end