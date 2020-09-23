class PopulationSpec < ApplicationRecord
  has_many :population_days, dependent: :destroy
  belongs_to :station
end
