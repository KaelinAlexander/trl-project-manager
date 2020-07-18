require './config/environment'

class EditorsController < ApplicationController

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/editors' do
    not_logged_in_redirect
    @editors = Editor.all
      if !@editors.empty?
        erb :'/editors/index'
      else
        erb :'/editors/exception'
      end
  end

  get '/editors/new' do
  not_logged_in_redirect
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

  get '/editors/rescue' do
    erb :'/editors/rescue'
  end

  get '/editors/included' do
    erb :'/editors/included'
  end

  get '/editors/:id/reassign' do
    not_logged_in_redirect
    @editor = Editor.find_by_id(params[:id])
    if @editor
      erb :'/editors/reassign'
    else
      redirect :'/editors/new'
    end
  end

  get '/editors/:id' do
    not_logged_in_redirect
    @editor = Editor.find_by_id(params[:id])
    if @editor
      erb :'/editors/show'
    else
      redirect '/editors'
    end
  end

  get '/editors/:id/edit' do
    not_logged_in_redirect
    @editor = Editor.find_by_id(params[:id])
    if @editor
      erb :'/editors/edit'
    else
      redirect '/editors'
    end
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
    not_logged_in_redirect
    @editor = Editor.find_by_id(params[:id])
    if @editor
      erb :'/editors/delete'
    else
      redirect '/editors'
    end
  end

  delete '/editors/:id' do
    @editor = Editor.find_by_id(params[:id])
    if Editor.count < 2
      redirect "/editors/rescue"
    elsif @editor && !@editor.tasks.empty? && logged_in
      redirect "/editors/#{@editor.id}/reassign"
    else @editor && logged_in
      @editor.destroy
      redirect "/editors"
    end
  end

  patch '/editors/:id/reassign' do
    @new_tasks = params[:project][:tasks]
    @new_tasks.each do |task|
      reassign = Task.find_by_id(task[:id])
      if task[:name]
        new_editor = Editor.find_by(name: task[:name])
          if reassign.editors.include?(new_editor)
            redirect "/editors/included"
          else
            reassign.editors << new_editor
            reassign.save
          end
      else
        redirect "/editors/#{params[:id]}/reassign"
      end
    end
    @drop = Editor.find_by_id(params[:id])
    @drop.destroy
      redirect "/editors"
  end

end
