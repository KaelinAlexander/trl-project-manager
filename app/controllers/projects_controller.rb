require './config/environment'

class ProjectsController < ApplicationController

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/projects' do
    not_logged_in_redirect
    @projects = Project.all
    if @projects
      erb :'/projects/index'
    else
      redirect '/projects/new'
    end
  end

  get '/projects/completed' do
    not_logged_in_redirect
    @projects = Project.all
    erb :'/projects/completed'
  end

  post '/projects' do
    if logged_in
      @project = current_user.projects.build(params)
      if @project.save
        redirect '/projects'
      else
        redirect '/projects/new'
      end
    else

    end
  end

  get '/projects/new' do
    erb :'/projects/new'
  end

  get '/projects/:id' do
    not_logged_in_redirect
    @project = Project.find_by_id(params[:id])
    if @project
      erb :'/projects/show'
    else
      redirect '/projects'
    end
  end

  get '/projects/:id/edit' do
    not_logged_in_redirect
    @project = Project.find_by_id(params[:id])
    if @project
      erb :'/projects/edit'
    else
      redirect '/projects'
    end
  end

  patch '/projects/:id/edit' do
    not_logged_in_redirect
    @project = Project.find_by_id(params[:id])
      if logged_in && @project.user_id == current_user.id
        @project.author = params[:author]
        @project.title = params[:title]
        @project.notes = params[:notes]
        @project.complete = params[:complete]
        @project.save
          redirect '/projects'
      else
        redirect "/projects/#{@project.id}/edit"
      end
  end

  get '/projects/:id/delete' do
    not_logged_in_redirect
    @project = Project.find_by_id(params[:id])
    if @project
      erb :'/projects/delete'
    else
      redirect '/projects'
    end
  end

  delete '/projects/:id' do
    @project = Project.find_by_id(params[:id])
    if logged_in && @project.user_id == current_user.id
      @project.destroy
    end
      redirect '/projects'
  end

end
