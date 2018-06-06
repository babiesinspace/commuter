class Commute < ApplicationRecord
  belongs_to :user
  acts_as_schedulable :schedule
  has_one :location,
  inverse_of: :locatable,
  foreign_key: :locatable_id,
  dependent: :destroy,
  as: :locatable
  accepts_nested_attributes_for :location 
  has_many :reminders
#  before_create :build_location
  after_create :create_benchmark
  after_save :next_occurrence

  # def generate_daily_on_create
  #   byebug
  #   benchmark = self.create_benchmark
  #   self.update(duration: benchmark)
  # end

  def generate_daily
    times = self.schedule.occurrences_between(Date.today.beginning_of_day, (Date.today.end_of_day))
    times.map { |time| Reminder.create(commute_id: self.id, start_time: time.to_time) }
  end 

  #break this out, find a way to update it as they continue to use. 
  def create_benchmark
    self.next_occurrence
    r = Reminder.create(commute_id: self.id, start_time: self.next_reminder_date.to_time)
    text_time_in_seconds = (r.text_time + 15.minutes).to_i
    start_time_in_seconds = r.start_time.to_i
    commute_time = start_time_in_seconds - text_time_in_seconds
    conservative_estimate = commute_time + (commute_time / 10)
    self.update_column(:duration, conservative_estimate)
    # times = self.schedule.occurrences_between(Date.today.beginning_of_day, (Date.today.end_of_day + 1.days))
    # today = times.map { |time| Reminder.create(commute_id: self.id, start_time: time.to_time) }
    # previous = self.schedule.previous_occurrence(Time.now)
    
    # if today.first.start_time == previous.to_time
    #   previous = previous - 1.week
    # end    

    # previous_reminder = Reminder.create(commute_id: self.id, start_time: previous.to_time)
    # reminders = today.push(previous_reminder)

    # commute_times = reminders.map { |r| r.duration_in_seconds }
    # avg_commute_time = (commute_times.reduce(:+) / commute_times.length)
    # conservative_estimate = travel_duration + (travel_duration / 10)
    # self.duration = conservative_estimate
  end 

  def next_occurrence
    next_reminder = self.schedule.next_occurrence
    self.update_column(:next_reminder_date, next_reminder)
  end 

end


# next_event = self.next_reminder_date
# #if this happened already
# if !(next_event >= Date.today.end_of_day)



    # times = self.schedule.occurrences_between(Date.today.beginning_of_day, (Date.today.beginning_of_day + 1.days))
    # if times.any?
    #   times.map do |time| 
    #       Reminder.create(commute_id: self.id, start_time: time.to_time)
    #       #create an array of commute_times and get the average?
    #       commute_time = r.duration_in_seconds
    #   end
    # else 
    #   previous = self.schedule.previous_occurrence(Time.now)
    #   first = self.schedule.first
    # end
