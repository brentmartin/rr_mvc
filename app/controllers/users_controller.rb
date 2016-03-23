class UsersController < ApplicationController
  def index
    render Users.new.all_users.to_json
  end

  def show
    id = params[:id].to_i
    all_users = Users.new.all_users
    if id > all_users.length-1
      render "Error 404 user error!"
    else
      user = all_users[id]
      render user.to_json
    end
  end
end
