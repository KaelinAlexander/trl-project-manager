require './config/environment'

class TasksController < ApplicationController

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    erb :index
  end

  get '/:id/tasks/new' do
    @project = Project.find_by_id(params[:id])
    @default_tasks = task_list
    erb :'/tasks/new'
  end

  post '/:id/tasks/new' do
    @project = Project.find_by_id(params[:id])
    @tasks = params[:tasks]
    @tasks.each do |task|
      if task[:name]
          @project.tasks << Task.create(name: task[:name], start_date: task[:start_date], end_date: task[:end_date])
      end
    end
  end

  get '/tasks/:id/edit' do
    @task = Task.find_by_id(params[:id])
    erb :'/tasks/edit'
  end

  patch '/tasks/:id/edit' do
    @task = Task.find_by_id(params[:id])
    @project = Project.find_by_id(@task.project_id)
      if @project.user_id == current_user.id
        @task.name = params[:name]
        @task.start_date = params[:start_date]
        @task.end_date = params[:end_date]
        @task.inquired = params[:inquired]
        @task.assigned = params[:assigned]
        @task.transmitted = params[:transmitted]
        @task.completed = params[:completed]
        @task.invoiced = params[:invoiced]
        @task.paid = params[:params]
        @task.save
          redirect "/projects/#{@task.project_id}"
      else
        redirect "/tasks/#{@task.id}/edit"
      end
    end

    get '/tasks/:id/delete' do
      @task = Task.find_by_id(params[:id])
      erb :'/tasks/delete'
    end

    delete '/tasks/:id' do
      @task = Task.find_by_id(params[:id])
      @project = Project.find_by_id(@task.project_id)
      if @task && logged_in && @project.user_id == current_user.id
        @task.destroy
      end
        redirect "/projects/#{@project.id}"
    end

end
