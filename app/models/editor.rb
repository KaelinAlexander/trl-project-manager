class Editor < ActiveRecord::Base
  validates :name, presence: true
  has_many :assigned_tasks, dependent: :destroy
  has_many :tasks, through: :assigned_tasks

end
