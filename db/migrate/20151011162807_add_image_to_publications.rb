class AddImageToPublications < ActiveRecord::Migration
  def up
    add_attachment :publications, :image
  end

  def down
    remove_attachment :publications, :image
  end
end
