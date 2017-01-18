class StatusController < ApplicationController
  NUMBER_OF_CURRENT_ITEMS_TO_DISPLAY = 1
  NUMBER_OF_PREVIOUS_ITEMS_TO_DISPLAY = 10
  NUMBER_OF_ITEMS_TO_DISPLAY = NUMBER_OF_CURRENT_ITEMS_TO_DISPLAY + NUMBER_OF_PREVIOUS_ITEMS_TO_DISPLAY

  def index
    previous_state_items = StatusItem.order(:updated_at).last(NUMBER_OF_ITEMS_TO_DISPLAY)
    @current_status = previous_state_items.last
    @previous_statuses = (previous_state_items - [@current_status]).reverse
  end

  def create
    @status_item = StatusItem.new state: params[:state], message: params[:message]
    if @status_item.save
      render json: {status: 200, status_item: @status_item}.to_json
    else
      render json: {status: 500}.to_json
    end
  end

  def update
    status_item = StatusItem.find(params[:id])
    if status_item.update fields_to_update(params)
      render json: {status: 200, status_item: status_item}.to_json
    else
      render json: {status: 500}.to_json
    end
  end

  private

  def fields_to_update(params)
    result = {}
    result[:state] = params[:state] if params[:state].present?
    result[:message] = params[:message] if params[:message].present?
    result
  end
end
