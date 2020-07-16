class AddPublishedToPublications < ActiveRecord::Migration
  def change
    add_column :publications, :published, :boolean
  end
end
