require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'secret to everyone'
  end

  get "/" do
    erb :index
  end

  get '/signup' do
    logged_in_redirect
    erb :'users/new'
  end

  post '/signup' do
    user = User.new(params)
      if user.save
        session[:user_id] = user.id
        redirect '/projects'
      else
        redirect '/signup'
      end
    end

  get '/login' do
    if logged_in
      redirect '/projects'
    else
      erb :'sessions/new'
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/projects'
    else
      redirect '/login'
    end
  end

  get '/logout' do
    session.clear
    redirect '/login'
  end

    helpers do
      def logged_in_redirect
        redirect '/projects' if logged_in
      end

      def not_logged_in_redirect
        redirect '/login' unless logged_in
      end

      def logged_in
        !!session[:user_id]
      end

      def not_logged_in
        !!!session[:user_id]
      end

      def current_user
        User.find_by_id(session[:user_id])
      end

      def task_list
        base_tasks = ["Reader Report", "Developmental Edit", "Copyedit", "Proofread", "Cover Design", "Interior Design"]
        base_tasks
      end

      # def my_tasks(searcher)
      #   Just use editor.tasks or task.editors // task.editors.first.name
          # finder = searcher.to_i
      #   my_tasks = []
      #   @all_at = AssignedTask.all
      #   @all_at.each do |task|
      #     if task[:editor_id] == finder
      #       my_tasks << task
      #     end
      #   end
      #   my_tasks
      # end

    end

end
