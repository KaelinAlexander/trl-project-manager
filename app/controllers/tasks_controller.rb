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
    not_logged_in_redirect
    @tasks = Task.all
    @needs = Task.all.select{ |task| task.editors.empty? }
    if !@tasks.empty?
      erb :'/tasks/index'
    else
      erb :'/tasks/exception'
    end
  end

  get '/:id/tasks/new' do
    not_logged_in_redirect
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
      if @project && task[:name] && task[:name] != ""
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
    not_logged_in_redirect
    @task = Task.find_by_id(params[:id])
    if @task
      @project = Project.find_by_id(@task.project_id)
      if @project
        erb :'/tasks/show'
      else
        redirect '/projects'
      end
    else
        redirect '/tasks'
    end
  end

  get '/tasks/:id/edit' do
    not_logged_in_redirect
    @task = Task.find_by_id(params[:id])
    if @task
      @project = Project.find_by_id(@task.project_id)
      erb :'/tasks/edit'
    else
      redirect '/tasks'
    end
  end

  patch '/tasks/:id/edit' do
    @task = Task.find_by_id(params[:id])
    @project = Project.find_by_id(@task.project_id)
    @editor = Editor.find_by(name: params[:editor])
      if logged_in
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
          redirect "/tasks"
      else
        redirect "/tasks/#{@task.id}/edit"
      end
    end

    get '/tasks/:id/delete' do
      not_logged_in_redirect
      @task = Task.find_by_id(params[:id])
      if @task
        erb :'/tasks/delete'
      else
        redirect '/tasks'
      end
    end

    delete '/tasks/:id' do
      @task = Task.find_by_id(params[:id])
      @project = Project.find_by_id(@task.project_id)
      if @task && logged_in
        @task.destroy
      end
        redirect "/projects"
    end

end
