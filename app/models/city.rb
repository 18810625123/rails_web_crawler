class City < ApplicationRecord
  belongs_to :province
  has_many :streets

  def childs
    City.where("parent_id = #{id}")
  end

  def parent
    if parent_id
      City.find parent_id
    else
      nil
    end
  end

  def owner
    parent
  end

end

