class SubPermission < ActiveRecord::Base

  has_and_belongs_to_many :roles
  belongs_to :permission
end
