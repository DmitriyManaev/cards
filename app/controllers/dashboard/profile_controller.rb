class Dashboard::ProfileController < Dashboard::BaseController

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to edit_profile_path, notice: t(:profile_updated_successfully_notice)
    else
      respond_with current_user
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :locale)
  end
end
