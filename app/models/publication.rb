class Publication < ActiveRecord::Base

  is_impressionable

  belongs_to :user
  belongs_to :category
  has_many :images, :dependent => :destroy
  accepts_nested_attributes_for :images, :allow_destroy => true
  
  attr_accessor :remove_image

  scope :published, -> { where(published: true) }
  scope :chosen, -> { where(edchoice: true) }

  
  validates :category_id, :presence => true
  validates :title, :presence => true
  validates :summary, :presence => true
  validates :body, :presence => true
  
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]
  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize(transliterations: :ukrainian).to_s
  end
  
  has_attached_file :image, styles: { medium: "310x200", thumb: "100x35>" }

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  
  before_validation { image.clear if remove_image == '1' }
    
  acts_as_xapian :texts => [ :title, :body ],
        :values => [
             [ :created_at_numeric, 1, "created_at", :number  ] 
        ],
        :terms => [ [ :variety, 'V', "variety" ]
        ], :if => :indexed_by_search?
        
  PROJECTS = ["Хто відповідає", "Юридичні коментарі", "COVID19"]
        
  def variety
    "publication"
  end  
  
  def created_at_numeric
    created_at.strftime("%Y%m%d%H%M%S")
  end
    
  def fulltext
    Sanitize.clean(body)
  end
    
  def indexed_by_search?
    if !self.published || self.created_at > Time.now
      return false
    end
    return true
  end
end
