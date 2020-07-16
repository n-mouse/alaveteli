class AddPublicationIdToImage < ActiveRecord::Migration
  def change
    add_column :images, :publication_id, :integer
  end
end
