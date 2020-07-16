class Commentary < ActiveRecord::Base
  
  belongs_to :info_request
  belongs_to :user
  has_many :info_request_events, dependent: :destroy
  
  validates_presence_of :content, :message => "Напишіть щось!"

end 
