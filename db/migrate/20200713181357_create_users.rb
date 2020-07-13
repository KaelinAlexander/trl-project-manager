class CreateUsers < ActiveRecord::Migration

  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :title
      t.integer :project_id
    end
  end

end
