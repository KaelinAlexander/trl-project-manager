require './config/environment'

class TasksController < ApplicationController

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    erb :index
  end

  get '/tasks' do
    @needs = Task.all.select{ |task| task.editors.empty? }
    erb :'/tasks/index'
  end

  get '/:id/tasks/new' do
    @project = Project.find_by_id(params[:id])
    @default_tasks = task_list
    @editors = Editor.all
    if @project
      erb :'/tasks/new'
    else
      redirect '/projects/index'
    end
  end

  post '/:id/tasks/new' do
    @project = Project.find_by_id(params[:id])
    @new_tasks = params[:project][:tasks]
    @new_tasks.each do |task|
      if task[:name] && task[:name] != ""
          new_task = Task.create(name: task[:name], start_date: task[:start_date], end_date: task[:end_date], inquired: FALSE, assigned: FALSE, transmitted: FALSE, completed: FALSE, invoiced: FALSE, paid: FALSE)
          if task[:editor]
            new_task.editors << Editor.find_by(name: task[:editor])
            @project.tasks << new_task
          else
            @project.tasks << new_task
          end
      end
    end
    redirect to "/projects/#{@project.id}"
  end

  get '/tasks/:id' do
    @task = Task.find_by_id(params[:id])
    @project = Project.find_by_id(@task.project_id)
    erb :'/tasks/show'
  end

  get '/tasks/:id/edit' do
    @task = Task.find_by_id(params[:id])
    @project = Project.find_by_id(@task.project_id)
    erb :'/tasks/edit'
  end

  patch '/tasks/:id/edit' do
    @task = Task.find_by_id(params[:id])
    @project = Project.find_by_id(@task.project_id)
    @editor = Editor.find_by(name: params[:editor])
      if @project.user_id == current_user.id
        @task.name = params[:name]
        @task.start_date = params[:start_date]
        @task.end_date = params[:end_date]
        if params[:inquired]
          @task.inquired = params[:inquired]
        else
          @task.inquired = FALSE
        end
        if params[:assigned]
          @task.assigned = params[:assigned]
        else
          @task.assigned = FALSE
        end
        if params[:transmitted]
          @task.transmitted = params[:transmitted]
        else
          @task.transmitted = FALSE
        end
        if params[:completed]
          @task.completed = params[:completed]
        else
          @task.completed = FALSE
        end
        if params[:invoiced]
          @task.invoiced = params[:invoiced]
        else
          @task.invoiced = FALSE
        end
        if params[:paid]
          @task.paid = params[:paid]
        else
          @task.paid = FALSE
        end
        @task.save
        if params[:editor]
          @editor = Editor.find_by(name: params[:editor])
          @task.editors << @editor
          @task.save
        end
          redirect "/tasks/#{@task.id}"
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
