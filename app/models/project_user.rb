class ProjectUser < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :sender, :class_name => 'User'
  has_many :invitees, :class_name => "User"

  before_create :generate_token


  private
  def generate_token
    self.token = Digest::SHA1.hexdigest([Time.now,rand].join)
  end
end
