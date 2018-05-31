class Commute < ApplicationRecord
  acts_as_schedulable :schedule
  has_one :location,
  inverse_of: :locatable,
  foreign_key: :locatable_id,
  dependent: :destroy,
  as: :locatable
  accepts_nested_attributes_for :location 
  after_save :generate_weekly
  has_many :events

  def generate_weekly
    times = self.schedule.occurrences_between(Date.today.beginning_of_week, (Date.today.beginning_of_week + 1.weeks))
    times.map { |time| Reminder.create(commute_id: self.id, start_time: time.to_local) }
  end 

end
