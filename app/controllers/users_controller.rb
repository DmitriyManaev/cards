class UsersController < ApplicationController
  def new
    if current_user
      redirect_to root_path
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to root_path, notice: t(:user_created_successfully_notice)
    else
      render :new
    end
  end
  
  def edit
  end

  def update
    if current_user.update(user_params)
      flash[:notice] = t(:profile_updated_successfully_notice)
      redirect_to edit_user_path
    else
      respond_with current_user
    end
  end

  def destroy
    current_user.destroy
    redirect_to login_path, notice: t(:user_deleted_notice)
  end

  private

  def user_params
    params.require(:user).permit(:email, 
                                 :password, 
                                 :password_confirmation, 
                                 :locale)
  end
end
