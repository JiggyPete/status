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

  Status = Struct.new(:state, :message, :created_at)

  def new_status
    Status.new('UP', 'All systems are fully operational.', Time.now)
  end
end
