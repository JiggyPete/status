class StatusItem < ActiveRecord::Base
  STATE_VALUES = ["UP", "DOWN"]

  validates_inclusion_of :state, in: STATE_VALUES
  validates :message, presence: true
end
