class CreateStatus < ActiveRecord::Migration
  def change
    create_table :status_items do |t|
      t.string :state
      t.text :message
      t.timestamps
    end
  end
end
