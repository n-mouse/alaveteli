class CreateCategories < ActiveRecord::Migration
  def up
      create_table :categories do |t|
      t.string     :name
      t.string :slug
      t.timestamps
      end
          add_index :categories, :slug, unique: true
  end

  def down
  end
end
