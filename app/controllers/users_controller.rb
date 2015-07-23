class UsersController < ApplicationController
  
  def login
    attempted_password = params["user"]["password"]
    @user = User.where("email" => params["user"]["email"])
    
    actual_password = BCrypt::Password.new(@user[0].password)
  
    session[:user_id] = @user[0].id

    if actual_password == attempted_password
      redirect_to profile_path
    else
      @user.errors << "Invalid login."
    
      render "index"
    end
      
  end
  
  def sign_up
    the_password = BCrypt::Password.create(params["user"]["password"])
    new_user = User.create({"email" => params["user"]["email"], "password" => the_password})
  
    if new_user.errors.messages.length == 0

      session[:user_id] = new_user.id

      redirect_to profile_path
    else
      @errors = "Invalid Login"
      render "index"
    end
  end
  
  def index
    
  end
  
  def destroy
    @user = User.find(session[:user_id])
    @user.destroy
    session.clear
    redirect_to users_path
  end
  
  def show
    @user = User.find(session[:user_id])
    @task = Task.where("user_id" => session[:user_id])
  end
  
  def edit
    @user = User.find(session[:user_id])
  end
  
  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(user_params)
      redirect_to profile_path
    else
      render "edit"
    end
  end
 
  def logout
    session.clear
    redirect_to users_path
  end
  
  private
  
  def user_params
    params[:user].permit(:email, :password)
  end
end
