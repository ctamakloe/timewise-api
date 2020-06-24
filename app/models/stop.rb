class Stop < ApplicationRecord
  belongs_to :train_schedule

  def departure_time
    return unless self.departs_at
    self.departs_at.strftime('%H:%M')
  end

  def arrival_time
    return unless self.arrives_at
    self.arrives_at.strftime('%H:%M')
  end
end
