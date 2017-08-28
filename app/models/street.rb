class Street < ApplicationRecord
  belongs_to :city

  def owner
    city
  end

end
