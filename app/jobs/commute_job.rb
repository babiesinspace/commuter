class CommuteJob < ApplicationJob
  @queue = :get_commuters

  def perform
    occurring_today = Commute.where(next_reminder_date: Date.today.all_day)
    occurring_today.each do |c| 
      c.generate_daily
      c.next_occurrence
    end
  end

end