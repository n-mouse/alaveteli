class Category < ActiveRecord::Base

  has_many :publications
  validates :name, :presence => true
  
      extend FriendlyId
  friendly_id :name_en, use: :slugged

end
