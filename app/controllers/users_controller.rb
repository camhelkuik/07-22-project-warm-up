class UsersController < ApplicationController
  
  def login
    attempted_password = params["user"]["password"]
    @user = User.where("email" => params["user"]["email"])
    
    actual_password = BCrypt::Password.new(@user[0].password)
  
    session[:user_id] = @user[0].id

    if actual_password == attempted_password
      redirect_to task_path(session[:user_id])
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

      redirect_to task_path(new_user.id)
    else
      @errors = "Invalid Login"
      render "index"
    end
  end
  
  def index
    
  end
  
  def destroy
    @user = User.find(session[:id])
    @user.destroy
    session.clear
    redirect_to users_path
  end
  
  def show
    @user = User.find(params[:id])
  
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      redirect_to users_path
    else
      render "new"
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(user_params)
      redirect_to task_path(session[:user_id])
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
