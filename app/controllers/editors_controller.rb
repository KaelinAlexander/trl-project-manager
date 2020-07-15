require './config/environment'

class EditorsController < ApplicationController

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/editors' do
    @editors = Editor.all
    erb :'/editors/index'
  end

  get '/editors/new' do
    erb :'/editors/new'
  end

  post '/editors' do
    editor = Editor.new(params)
      if editor.save
        redirect "/editors/#{editor.id}"
      else
        redirect '/editors/new'
      end
  end

  get '/editors/:id' do
    @editor = Editor.find_by_id(params[:id])
    @my_tasks = my_tasks(params[:id])
    erb :'/editors/show'
  end

  get '/editors/:id/edit' do
    @editor = Editor.find_by_id(params[:id])
    erb :'/editors/edit'
  end

  patch '/editors/:id/edit' do
    @editor = Editor.find_by_id(params[:id])
        @editor.name = params[:name]
        @editor.email = params[:email]
        @editor.phone = params[:phone]
        @editor.website = params[:website]
        @editor.notes = params[:notes]
      if @editor.save
          redirect "/editors/#{@editor.id}"
      else
        redirect "/editors/#{@editor.id}/edit"
      end
    end

  get '/editors/:id/delete' do
    @editor = Editor.find_by_id(params[:id])
    erb :'/editors/delete'
  end

  delete '/editors/:id' do
    @editor = Editor.find_by_id(params[:id])
    @my_tasks = my_tasks(params[:id])
    if @editor && @my_tasks && logged_in
      @my_tasks.each do |assignment|
        assignment.editor_id = nil
        assignment.save
        end
      @editor.destroy
      redirect "/tasks/reassign"
    elsif @editor && logged_in
      @editor.destroy
      redirect "/editors"
    end
  end

end
