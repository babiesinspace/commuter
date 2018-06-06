class Location < ApplicationRecord
  geocoded_by :address
  before_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
  belongs_to :locatable, polymorphic: true 
end
