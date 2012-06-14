class Package < ActiveRecord::Base
  has_many :users
  has_many :package_users
  #has_many :users, :through => :packages_users
end
