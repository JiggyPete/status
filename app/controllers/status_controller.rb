class StatusController < ApplicationController
  def index
    @current_status = new_status
    @previous_statuses = [
      new_status,
      new_status,
      new_status,
      new_status,
      new_status,
      new_status,
      new_status,
      new_status,
      new_status,
      new_status,
      new_status
    ]
  end

  private

  def new_status
    StatusItem.new(state: 'UP', message: 'All systems are fully operational.', created_at: Time.now, updated_at: Time.now)
  end
end
