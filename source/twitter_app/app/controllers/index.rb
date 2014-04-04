
get '/' do
  if current_user
    # @user = current_user
    erb :user_page #logged in home page
  else
    erb :index #login/createaccount page
  end
end

post '/users/login' do
  @user = User.find_by_email(params[:email])
  # p "___________________________________________"
  # p @user
  #   p "___________________________________________"
  if @user
   if @user.password == params[:password]
    session[:user_id] = @user.id
    @logged_in_user = current_user
      # p "Password is correct"
      redirect '/'
    end

  end
  # redirect to '/'
end

get '/users/:id' do
  @user = User.find(params[:id])

  erb :profile
end

get '/follow/:id' do
  @user = User.all.find(params[:id])
  @logged_in_user = current_user
  @logged_in_user.follow!(@user)


  redirect "/users/#{@user.id}"

end

get '/unfollow/:id' do
  @user = User.all.find(params[:id])
  @logged_in_user = current_user
  @logged_in_user.unfollow!(@user)


  redirect "/users/#{@user.id}"

end

post '/users/new' do
  @user = User.new(params)
  @user.password = params[:password]
  @user.save!
  session[:user_id] = @user.id
  redirect to '/'
end

get '/logout' do
  session[:user_id] = nil
  redirect to '/'
end

post '/tweets/new' do
  Tweet.create(params)
  redirect '/'
end

get '/search/*' do
  @search_term = params[:user_name]
  user_name = "%" + params[:user_name] + "%"
  @potential_users = User.where('user_name like ?', user_name )
  p @search_term
  erb :search
end


# get "/:tweet_id/new" do

# end

post "/tweets/:id/retweets/:retweet_id" do
  @og_tweet = Tweet.find(params[:id])
  @retweet = Tweet.new (params message: @og_tweet[:message])
  @retweet[:retweet_id] = @og_tweet[:id]
  @user = User.find(:tweet_id == @retweet.id)
  @retweet.save!
  redirect "/users/<%= @user.id %>"
end
