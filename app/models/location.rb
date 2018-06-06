class Location < ApplicationRecord
  geocoded_by :address
  before_create :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
  belongs_to :locatable, polymorphic: true, optional: true 
end
