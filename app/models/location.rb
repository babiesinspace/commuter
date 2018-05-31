class Location < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
  belongs_to :locatable, polymorphic: true 
end
