class PopulationDay < ApplicationRecord
  has_many :population_hours, dependent: :destroy
  belongs_to :population_spec
end
