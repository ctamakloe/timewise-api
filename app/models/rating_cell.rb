class RatingCell < ApplicationRecord
  belongs_to :train_schedule

  validates_uniqueness_of :stops_at

  def stop_time
    self.stops_at
  end
end
