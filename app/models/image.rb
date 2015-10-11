class Image < ActiveRecord::Base
  has_attached_file :file
  attr_accessible :file, :alt, :hint
  validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/
end
