class DirectionJob < ApplicationJob
  @queue = :get_directions

  def self.perform
    occurring_today = Commute.where(next_reminder_date: Date.today.all_day)
    occurring_today.each {|c| c.generate_daily }
  end

end