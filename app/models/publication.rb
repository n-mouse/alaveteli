class Publication < ActiveRecord::Base

  belongs_to :user
  
  attr_accessor :remove_image
  
  scope :published, where(:published=>true)
  scope :news, where(:category=>"новина")
  scope :stories, where(:category=>"історія")
  scope :videos, where(:category=>"відео")
  scope :digest, where(:category=>"дайджест")
  scope :blogs, where(:category=>"блоги")
  scope :chosen, where(:edchoice=>true)
  attr_accessible :title, :user_id, :body, :category, :slug, :published, :image, :edchoice, :remove_image, :author
  

  validates :category, :presence => true
  validates :title, :presence => true

  
    extend FriendlyId
  friendly_id :title, use: :slugged
    def normalize_friendly_id(input)
     input.to_s.to_slug.normalize(transliterations: :ukrainian).to_s
  end
  
  has_attached_file :image, styles: { medium: "310x200", thumb: "100x35>" }
  attr_accessible :image, :alt, :hint
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  
  
    before_validation { image.clear if remove_image == '1' }
  
end
