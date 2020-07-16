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
    @editors = Editor.all
    erb :'/tasks/new'
  end

  post '/:id/tasks/new' do
    @project = Project.find_by_id(params[:id])
    @new_tasks = params[:project][:tasks]
    @new_tasks.each do |task|
      if task[:name]
          new_task = Task.create(name: task[:name], start_date: task[:start_date], end_date: task[:end_date])
          @project.tasks << new_task
          AssignedTask.create(task_id: new_task.id, editor_id: task[:editor])
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
    @assigned = AssignedTask.find_by(task_id: @task.id)
    @editor = Editor.find_by(name: params[:editor])
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
        if @assigned
          @assigned.editor_id = @editor.id
          @assigned.save
        else
          @new = AssignedTask.create(editor_id: @editor.id, task_id: @task.id)
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
