class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end

  begin
  @user = User.from_omniauth(request.env['omniauth.auth'])
  session[:user_id] = @user.id
  flash[:success] = "Welcome, #{@user.name}!"
  rescue
 flash[:warning] = "There was an error while trying to authenticate you..."
  end

  def auth_failure
  redirect_to root_path
  end

end
