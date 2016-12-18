class StatusController < ApplicationController
  NUMBER_OF_CURRENT_ITEMS_TO_DISPLAY = 1
  NUMBER_OF_PREVIOUS_ITEMS_TO_DISPLAY = 10
  NUMBER_OF_ITEMS_TO_DISPLAY = NUMBER_OF_CURRENT_ITEMS_TO_DISPLAY + NUMBER_OF_PREVIOUS_ITEMS_TO_DISPLAY

  def index
    previous_state_items = StatusItem.order(:updated_at).last(NUMBER_OF_ITEMS_TO_DISPLAY)
    @current_status = previous_state_items.last
    @previous_statuses = (previous_state_items - [@current_status]).reverse
  end
end
