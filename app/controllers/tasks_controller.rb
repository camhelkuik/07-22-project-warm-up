class TasksController < ApplicationController  
  def index
    @task = Task.all
  end
  
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path
  end
  
  def show
    @task = Task.find(params[:id])
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = Task.new(task_params)
    
    if @task.save
      redirect_to tasks_path
    else
      render "new"
    end
  end
  
  def edit
    @task = Task.find(params[:id])
  end
  
  def update
    @task = Task.find(params[:id])
    
    if @task.update_attributes(task_params)
      redirect_to tasks_path
    else
      render "edit"
    end
  end
  
  private
  
  def task_params
    params[:task].permit(:user_id, :description)
  end
end
  
