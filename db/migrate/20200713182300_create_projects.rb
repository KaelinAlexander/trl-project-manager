class CreateProjects < ActiveRecord::Migration

  def change
    create_table :projects do |t|
      t.string :author
      t.string :title
      t.text :notes
      t.boolean :complete
      t.integer :user_id
    end
  end

end
