class Province < ApplicationRecord
  has_many :citys

  def childs
    citys
  end

  def parent_citys
    citys.where("parent_id is null")
  end



end
