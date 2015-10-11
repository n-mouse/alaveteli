class Image < ActiveRecord::Base
  has_attached_file :file
  attr_accessible :file, :alt, :hint
end
