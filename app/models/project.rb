class Project < ActiveRecord::Base
  validates :author, presence: true
  validates :title, presence: true
  belongs_to :user
  has_many :tasks, dependent: :destroy

end
