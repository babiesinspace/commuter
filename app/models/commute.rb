class Commute < ApplicationRecord
  acts_as_schedulable :schedule, occurrences: :commute_occurrences
  has_one :location,
  inverse_of: :locatable,
  foreign_key: :locatable_id,
  dependent: :destroy,
  as: :locatable
  accepts_nested_attributes_for :location 
end
