class Editor < ActiveRecord::Base
  has_many :assigned_tasks, dependent: :destroy
  has_many :tasks, through: :assigned_tasks

end
