require './config/environment'

class ProjectsController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/projects' do
    erb :'projects/index'
  end

  get '/projects/new' do
    erb :'/projects/new'
  end

  get 'projects/show' do
    @project = Project.find_by_id(params[:id])
    erb :'projects/show'
  end

  get 'projects/:id' do
    not_logged_in_redirect
    @project = Project.find_by_id(params[:id])
    erb '/projects/show'

end
