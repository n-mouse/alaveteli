class AddEdchoiceToPublications < ActiveRecord::Migration
  def change
    add_column :publications, :edchoice, :boolean
  end
end
