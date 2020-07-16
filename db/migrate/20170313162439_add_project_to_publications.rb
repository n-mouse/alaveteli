class AddProjectToPublications < ActiveRecord::Migration
  def change
    add_column :publications, :project, :string
  end
end
