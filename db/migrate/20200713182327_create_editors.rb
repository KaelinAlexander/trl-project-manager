class CreateEditors < ActiveRecord::Migration

  def change
    create_table :editors do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :website
      t.text :notes
    end
  end

end
