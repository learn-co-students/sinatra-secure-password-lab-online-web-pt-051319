require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    user = User.new(:username => params[:username], :password => params[:password])
    if user.save
      session[:user_id] = user.id
      redirect to('/login')
    else
      redirect to('/failure')
    end

  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end

  post '/account/deposit' do
    @user = User.find(session[:user_id])
    @user.deposit(params[:amount])
    redirect to('/account')
  end

  post '/account/withdrawl' do
    @user = User.find(session[:user_id])
    @amount = params[:amount].to_f
    if @user.funds_available?(@amount)
      @user.withdrawl(@amount)
      
      redirect to('/account')
    else
      erb :nsf
    end
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(:username => params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to('/account')
    else
      redirect to('/failure')
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
