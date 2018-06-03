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
  after_create :generate_daily_on_create, :next_occurrence

  def generate_daily_on_create
    benchmark = self.create_benchmark
    self.update(duration: benchmark)
  end

  def generate_daily
    times = self.schedule.occurrences_between(Date.today.beginning_of_day, (Date.today.end_of_day))
    times.map { |time| Reminder.create(commute_id: self.id, start_time: time.to_time) }
  end 

  #break this out, find a way to update it as they continue to use. 
  def create_benchmark
    times = self.schedule.occurrences_between(Date.today.beginning_of_day, (Date.today.end_of_day + 1.days))
    today = times.map { |time| Reminder.create(commute_id: self.id, start_time: time.to_time) }
    previous = self.schedule.previous_occurrence(Time.now)
    
    if today.first.start_time == previous.to_time
      previous = previous - 1.week
    end    

    previous_reminder = Reminder.create(commute_id: self.id, start_time: previous.to_time)
    reminders = today.push(previous_reminder)

    commute_times = reminders.map { |r| r.duration_in_seconds }
    avg_commute_time = (commute_times.reduce(:+) / commute_times.length)
    conservative_estimate = avg_commute_time + (avg_commute_time / 10)
  end 

  def next_occurrence
    next_reminder = self.schedule.next_occurrence
    self.update(next_reminder_date: next_reminder)
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
