class AddSubjectToCommentary < ActiveRecord::Migration
  def change
    add_column :commentaries, :subject, :string
  end
end
