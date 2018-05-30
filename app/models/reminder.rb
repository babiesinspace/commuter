class Reminder < ApplicationRecord
  belongs_to :commute

  # Returns ActiveRecord::Relation with reminders
  def self.grab_daily
    self.where(start_time: Date.today.all_day)
  end 

  def format_for_google
    # Reminder.find(self.id).joins(commute: [:location, :user]).pluck(:start_time, :latitude, :longitude, :home_latitude, :home_longitude)
    info_array = Reminder.where(id: self.id).joins(commute: [:location]).pluck(:start_time, :latitude, :longitude).first
    {start_time: info_array[0].to_i, latitude: info_array[1], longitude: info_array[2]}
  end

  def transit_data
    formatted_hash = self.format_for_google
    #plus sign or comma between lat and long?
    HTTParty.get("https://maps.googleapis.com/maps/api/directions/json?&mode=transit&origin=540+saint+johns+place+brooklyn+ny+11238&destination=#{formatted_hash[:latitude]}+#{formatted_hash[:longitude]}&arrival_time=#{formatted_hash[:start_time].to_s}&key=#{ENV['GOOGLE_ROUTES_API_KEY']}")
  end

  #routes holds an array of route options. MVP will have no alternatives, just the google first choice, so always grab the first
  #legs holds an array of 'legs' of the journey. if no waypoints are specified, this will only every hold one. MVP will not take way points, so only grab the first for now. 
  def format_text
    response = self.transit_data
    #change this post-MVP, see above notes
    response = response["routes"][0]["legs"][0]
  end

end