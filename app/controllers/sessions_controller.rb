class SessionsController < ApplicationController

	def new
	end

	def create
		render 'new'	

		def create
		  user = User.find_by_email(params[:session][:email].downcase)
		  if user && user.authenticate(params[:session][:password])
	 		# Sign the user in and redirect to the user's page
	 		sign_in user
	 		redirect_to user
	 		
		  else
		    # Create an error message and re-render the signin form... use flash to stop
		    # the message from appearing on redirect (since redirect is not a new request)
		   	flash.now[:error] = 'Opps... Invalid email/password combination'

		    render 'new'
		  end
		end

	end

	def destroy
		sign_out
		redirect_to root_url
	end
	
end


