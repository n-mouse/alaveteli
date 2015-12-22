class Publication < ActiveRecord::Base

  is_impressionable

  belongs_to :user
  belongs_to :category
  
  attr_accessor :remove_image
  
  scope :published, where(:published=>true)
  scope :chosen, where(:edchoice=>true)
  attr_accessible :title, :user_id, :body, :category, :slug, :summary, :published, :image, :edchoice, :remove_image, :author, :category_id
  

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
  attr_accessible :image, :alt, :hint
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  
  
    before_validation { image.clear if remove_image == '1' }
    
    acts_as_xapian :texts => [ :title, :body ],
        :values => [
             [ :created_at_numeric, 1, "created_at", :number  ] 
        ],
        :terms => [ [ :variety, 'V', "variety" ]
        ]
     def variety
       "publication"
     end
  
  
    def created_at_numeric
        created_at.strftime("%Y%m%d%H%M%S")
    end
    
    def fulltext
       Sanitize.clean(body)
    end
end
