class CreatePublications < ActiveRecord::Migration
  def up
      create_table :publications do |t|
        t.string :title
        t.text :body
        t.string :image
        t.string :slug, :null => false
        t.string :category
        t.string :status
        t.integer :user_id
        t.string :summary
        t.timestamps
    end
    add_index :publications, :slug, unique: true
  end

  def down
  end
end
