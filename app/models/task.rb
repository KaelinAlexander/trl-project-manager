class Task < ActiveRecord::Base
  belongs_to :project
  has_many :assigned_tasks
  has_many :editors, through: :assigned_tasks

end
