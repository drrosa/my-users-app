require "sinatra"
require_relative "my_user_model"

set :bind, "0.0.0.0"
set :port, 8080

enable :sessions

# https://web-b7e6845db-af6f.docode.us.qwasar.io
# curl localhost:8080/users
# curl -X POST localhost:8080/users -d firstname=gg -d lastname=GG -d age=43 -d password=pass12r -d email=gg@gg.com
# curl -X POST localhost:8080/sign_in -d email=gg@gg.com -d password=pass12r
# curl -X PUT localhost:8080/users -d email=gg@gg.com -d password=pass12r
# curl -c cookies.txt -X POST localhost:8080/sign_in -d email=gg@gg.com -d password=pass12r
# curl -b cookies.txt -X PUT localhost:8080/users -d email=gg@gg.com -d password=changedpass
# curl -b cookies.txt -X DELETE localhost:8080/sign_out
# curl -b cookies.txt -X DELETE localhost:8080/users

# GET on / (index).
# This action will render the index view.
get "/" do
    @users = User.all.collect do |user|
        User.to_hash(user)
    end
    erb :index, locals: { users_json: @users.to_json }
end

# GET on /users.
# This action will return all users (without their passwords).
get "/users" do
    users = User.all.collect do |user|
        User.to_hash(user)
    end
    users.to_json
end

# POST on /users.
# Receiving firstname, lastname, age, password and email.
# It will create a user and store in your database and
# returns the user created (without password).
post "/users" do
    return nil unless params.size == 5
    user = User.create(params)
    User.to_hash(user).to_json
end

# POST on /sign_in.
# Receiving email and password.
# It will add a session containing the user_id in order to be logged in
# and returns the user created (without password).
post "/sign_in" do
    user = User.all.filter { |user| user.email == params['email'] && user.password == params['password']}.first
    return status 401 unless user
    session[:user_id] = user.id
    User.to_hash(user).to_json
end

# PUT on /users.
# This action require a user to be logged in.
# It will receive a new password and will update it.
# It returns the user created (without password).
put "/users" do
    return status 401 unless session[:user_id]
    user = User.update(session[:user_id], :password, params['password'])
    User.to_hash(user).to_json
end

# DELETE on /sign_out.
# This action require a user to be logged in.
# It will sign_out the current user.
# It returns nothing (code 204 in HTTP).
delete "/sign_out" do
    return status 401 unless session[:user_id]
    session[:user_id] = nil
    status 204
end

# DELETE on /users.
# This action require a user to be logged in.
# It will sign_out the current user and it will destroy the current user.
# It returns nothing (code 204 in HTTP).
delete "/users" do
    return status 401 unless session[:user_id]
    User.destroy(session[:user_id])
    session[:user_id] = nil
    status 204
end