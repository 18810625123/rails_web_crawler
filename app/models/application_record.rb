class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def print type = :relations
    @@project ||= Ld::Project.new
    @@project.print self.class.to_s.underscore, type
    self
  end

end
