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

get "/" do
    @users = User.all.collect do |user|
        User.to_hash(user)
    end
    erb :index, locals: { users_json: @users.to_json }
end

get "/users" do
    users = User.all.collect do |user|
        User.to_hash(user)
    end
    users.to_json
end

post "/users" do
    return nil unless params.size == 5
    user = User.create(params)
    User.to_hash(user).to_json
end

post "/sign_in" do
    user = User.all.filter { |user| user.email == params['email'] && user.password == params['password']}.first
    return status 401 unless user
    session[:user_id] = user.id
    User.to_hash(user).to_json
end

put "/users" do
    return status 401 unless session[:user_id]
    user = User.update(session[:user_id], :password, params['password'])
    User.to_hash(user).to_json
end

delete "/sign_out" do
    return status 401 unless session[:user_id]
    session[:user_id] = nil
    status 204
end

delete "/users" do
    return status 401 unless session[:user_id]
    # User.destroy(session[:user_id])
    session[:user_id] = nil
    status 204
end