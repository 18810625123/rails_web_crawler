class Crawler::Website < ApplicationRecord
  has_many :works
  has_many :plans
  belongs_to :website_type
end
