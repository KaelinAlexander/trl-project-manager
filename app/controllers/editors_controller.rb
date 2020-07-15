require './config/environment'

class EditorsController < ApplicationController

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/editors' do
    erb :'/editors/index'
  end

  get '/editors/new' do
    erb :'/editors/new'
  end

  post '/editors' do

  end

  get '/editors/:id' do
    @editor = Editor.find_by_id(params[:id])
    erb :'/editors/show'
  end

  get '/editors/:id/edit' do
    @editor = Editor.find_by_id(params[:id])
    erb :'/editors/edit'
  end

  get '/editors/:id/delete' do
    @editor = Editor.find_by_id(params[:id])
    erb :'/editors/delete'
  end

end
