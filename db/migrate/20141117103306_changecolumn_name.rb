class ChangecolumnName < ActiveRecord::Migration
  def change
    rename_column :calendars, :endtime, :timezone
  end
end
