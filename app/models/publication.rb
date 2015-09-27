class Publication < ActiveRecord::Base

  belongs_to :user
  
  scope :published, where(:published=>true)
  scope :news, where(:status=>"новина")
  scope :stories, where(:status=>"історія")
  scope :videos, where(:status=>"відео")
  scope :chosen, where(:edchoice=>true)
  attr_accessible :title, :user_id, :body, :category, :slug, :published, :image, :edchoice
  
  

  validates :category, :presence => true
  validates :title, :presence => true

  
    extend FriendlyId
  friendly_id :title, use: :slugged
    def normalize_friendly_id(input)
     input.to_s.to_slug.normalize(transliterations: :ukrainian).to_s
  end
  
    mount_uploader :image, ImageUploader
end
