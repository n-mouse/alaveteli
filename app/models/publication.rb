class Publication < ActiveRecord::Base

  include PgSearch
  pg_search_scope :search, against: [:title, :body], using: {tsearch: {dictionary: "russian"}}

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
    
        acts_as_xapian :texts => [ :title, :body ],
        :values => [
             [ :created_at_numeric, 1, "created_at", :number  ] # for sorting
        ],
        :terms => [ [ :variety, 'V', "variety" ]
        ]
     def variety
       "publication"
     end
  
  
      def created_at_numeric
        # format it here as no datetime support in Xapian's value ranges
        created_at.strftime("%Y%m%d%H%M%S")
    end
end
