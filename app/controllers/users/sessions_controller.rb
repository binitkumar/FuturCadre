class Users::SessionsController < Devise::SessionsController
	
	def destroy
		$role = current_user.role
		super
	end
end