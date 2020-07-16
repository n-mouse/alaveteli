class CreateCommentaries < ActiveRecord::Migration
  def up
      create_table :commentaries do |t|
        t.text :content
        t.integer :info_request_id
        t.integer :user_id
        t.timestamps
      end   
      execute "ALTER TABLE commentaries ADD CONSTRAINT fk_commentaries_user FOREIGN KEY (user_id) REFERENCES users(id)"
      execute "ALTER TABLE commentaries ADD CONSTRAINT fk_commentaries_info_request FOREIGN KEY (info_request_id) REFERENCES info_requests(id)"

      add_column :info_request_events, :commentary_id, :integer
      execute "ALTER TABLE info_request_events ADD CONSTRAINT fk_info_request_events_commentary_id FOREIGN KEY (commentary_id) REFERENCES commentaries(id)"
  end

  def down
    drop_table :commentaries
  end
end
