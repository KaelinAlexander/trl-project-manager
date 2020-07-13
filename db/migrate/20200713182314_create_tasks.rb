class CreateTasks < ActiveRecord::Migration

  def change
    create_table :tasks do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.boolean :inquired
      t.boolean :assigned
      t.boolean :transmitted
      t.boolean :completed
      t.boolean :invoiced
      t.boolean :paid
    end
  end

end
