class EmployerProfile < ActiveRecord::Base
  belongs_to :profile
  belongs_to :user
  belongs_to :employer, :polymorphic => true
end
