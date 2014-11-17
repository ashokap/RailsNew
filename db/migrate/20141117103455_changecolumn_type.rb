class ChangecolumnType < ActiveRecord::Migration
  def change
    change_column :calendars, :timezone, :text
  end
end
