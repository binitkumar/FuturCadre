class Group < ActiveRecord::Base

  acts_as_commentable
  #has_and_belongs_to_many :members,  :class_name => "User"
  has_and_belongs_to_many :jobs
  has_one :photo, :as => :imageable
  has_many :group_users
  has_many :users, :through => :group_users
  belongs_to :owner, :class_name => "User"
  belongs_to :group_type
  has_and_belongs_to_many :school_categories
  has_many :questions
  has_one :rating, :as => :rateable
  belongs_to :manager, :class_name => "User"
  has_many :events


  def new_salary(params)
    sal = (self.mean_salary.to_i + params)/2
    return sal
  end


  def is_manager(member)
    if self.manager_id == member.id
      return true
    end
  end

  protected
  def set_user_rating(rate)
    new_rating = self.rating.rate
    new_rating = (new_rating.to_i + rate.to_i)/2
    set_rating = self.rating.update_attributes(:rate => new_rating)
    return set_rating
  end
end
