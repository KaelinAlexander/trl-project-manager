require './config/environment'

class TasksController < ApplicationController

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    erb :index
  end

  get '/tasks/new' do
    erb :'/tasks/new'
  end

end
