class Case < ActiveRecord::Base

  attr_accessor :remove_image
    
  scope :published, -> { where(published: true) }
  
  validates :title, :presence => true
  validates :body, :presence => true
  
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]
  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize(transliterations: :ukrainian).to_s
  end
  
  has_attached_file :image, styles: { medium: "300x185#", thumb: "100x35>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  
  before_validation { image.clear if remove_image == '1' }

end
