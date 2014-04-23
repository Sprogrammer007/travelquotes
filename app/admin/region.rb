ActiveAdmin.register Region do

	include_import

	 menu :if => proc{ current_admin_user.email == "stevenag006@hotmail.com" }
end
