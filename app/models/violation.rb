class Violation < ActiveRecord::Base
  
  has_attached_file :req
  has_attached_file :resp
  
  validates :name, :presence => true
  validates :description, :presence => true
  validates :email, :presence => true
  #validates :req, :presence => true
  #validates :resp, :presence => true
  
  validates_attachment_content_type :req, content_type: ['image/jpeg', 'image/png', 'application/pdf','application/vnd.ms-word','application/vnd.openxmlformats-officedocument.wordprocessingml.document']
  #validates_attachment_content_type :resp, content_type: ['image/jpeg', 'image/png', 'application/pdf']

end

        
