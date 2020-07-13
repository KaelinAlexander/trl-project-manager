class CreateAssignedTasks < ActiveRecord::Migration

  def change
    create_table :assigned_tasks do |t|
      t.integer :task_id
      t.integer :editor_id
    end
  end

end
