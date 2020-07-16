class Image < ActiveRecord::Base

  has_attached_file :file, styles: { thumb: "150x70" }
 
  belongs_to :publication
  validates_attachment_content_type :file, content_type: ['image/jpeg', 'image/png', 'application/pdf']

end
