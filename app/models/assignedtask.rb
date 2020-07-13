class AssignedTask < ActiveRecord::Base
  belongs_to :editor
  belongs_to :task

end
