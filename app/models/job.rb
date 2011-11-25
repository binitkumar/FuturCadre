class Job < ActiveRecord::Base
	belongs_to :employer, :polymorphic => true
end
