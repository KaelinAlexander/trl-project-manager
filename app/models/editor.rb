class Editor < ActiveRecord::Base
  has_many :assigned_tasks
  has_many :tasks, through: :assigned_tasks

end
