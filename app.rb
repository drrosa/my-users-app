require "sinatra"
require_relative "my_user_model"

set :bind, "0.0.0.0"
set :port, 8080
# https://web-b7e6845db-af6f.docode.us.qwasar.io

get "/" do
    erb :welcome
end

get "/hello" do
    "Hello World!"
end