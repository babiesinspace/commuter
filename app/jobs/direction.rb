class DirectionJob < ApplicationJob
  @queue = :get_directions

  def self.perform(time)
    get_directions(time)
  end

end