class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.date :starttime
      t.date :endtime
      t.text :summary

      t.timestamps
    end
  end
end
