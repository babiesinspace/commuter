class Commute < ApplicationRecord
  acts_as_schedulable :schedule
  has_one :location,
  inverse_of: :locatable,
  foreign_key: :locatable_id,
  dependent: :destroy,
  as: :locatable
  accepts_nested_attributes_for :location 
  after_create :generate_daily_on_create
  has_many :reminders

  def generate_daily_on_create
    today = self.generate_daily
    previous = self.schedule.previous_occurrence(Time.now)
    if today.first.start_time == previous.to_time
      previous = previous - 1.week
    end
    previous_reminder = Reminder.create(commute_id: self.id, start_time: previous.to_time)
    reminders = today.push(previous_reminder)
    times = reminders.map { |r| r.duration_in_seconds }
    commute_time = (times.reduce(:+) / times.length)
    conservative_estimate = commute_time + (commute_time / 10)
    self.update(duration: conservative_estimate)
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
  end

  def generate_daily
    times = self.schedule.occurrences_between(Date.today.beginning_of_day, (Date.today.beginning_of_day + 2.days))
    times.map { |time| Reminder.create(commute_id: self.id, start_time: time.to_time) }
  end 

  def create_benchmark

  end 

end
