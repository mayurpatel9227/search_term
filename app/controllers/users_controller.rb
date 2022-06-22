class UsersController < ApplicationController
  before_action :set_user, only: %i[ show ]

  # for show all users list
  def index
    if @current_user.present?
      if params[:search].present?
        @users = User.where("name like ? or description like ? or web_url like ? or title like ?","%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
        @users = @users.where.not(id:session[:user_id])

        @users.each do |user|
          client = Bitly::API::Client.new(token: '1e2cb2330ead6709376565e28ed2b163c2aa003c')
          bitlink = client.shorten(long_url: user.web_url)
          user.web_url = bitlink.link
        end
      end
      respond_to do |format|
        format.html { render :index, notice: "search result is billow" }
        format.json { head :@users }
      end
    else
    flash[:danger] = "Please login first!"
    render login_page
    end
  end

  #this api is use for show user's profile
  def show
    # byebug
    
  end

  #for show users friends
  def users_friends_list
    users_friends = Friendship.users_friends(session[:user_id])
    @friend_name = []

    users_friends.each do |user_friends|
      if user_friends.user_id.to_s != session[:user_id].to_s
        user_friend = user_friends.users_friend
        client = Bitly::API::Client.new(token: '1e2cb2330ead6709376565e28ed2b163c2aa003c')
        bitlink = client.shorten(long_url: user_friend.web_url)
        user_friend.web_url = bitlink.link
        @friend_name << user_friend
      else
        user_friend = user_friends.friend
        client = Bitly::API::Client.new(token: '1e2cb2330ead6709376565e28ed2b163c2aa003c')
        bitlink = client.shorten(long_url: user_friend.web_url)
        user_friend.web_url = bitlink.link
        @friend_name << user_friend
      end
    end

  end

  def users_list
    @users = User.all
  end

  # create new user
  def new
    @user = User.new
  end

  # update user
  def edit
  end

  # create new user
  def create
    @user = User.new(user_params)
    @user.is_active = 1
    @user.is_deleted = 0
    @user.friends_count = 0
    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to '/users', notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def login_page 

  end

  def login_user
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      respond_to do |format|
        format.html { redirect_to '/users', notice: "You have successfully logged in" }
      end
    else
    flash[:danger] = "There was something wrong with your login information"
    render 'login_page'
    end

  end

  def add_friends
    @friendship = Friendship.new(user_id: session[:user_id], friend_id: params[:friend_id])

    ids = []
    ids << session[:user_id]
    ids << params[:friend_id]
    users = User.where(id: ids)
    respond_to do |format|
      if @friendship.save
        users.each do |users|
          if users.friends_count.nil?
            friends_count = 1
          else
            friends_count = users.friends_count + 1
          end
          users_friends = users.update(friends_count: friends_count)
        end
        format.html { redirect_to users_url, notice: "Friendship was successfully created." }
        format.json { render :show, status: :created, location: @friendship }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  def remove_friends
    @friendship = Friendship.find_by(user_id: session[:user_id], friend_id: params[:friend_id])
    if @friendship.present?
      ids = []
      ids << session[:user_id]
      ids << params[:friend_id]
      users = User.where(id: ids)
      respond_to do |format|
        if @friendship.present?
          @friendship.destroy
          users.each do |users|
            friends_count = users.friends_count - 1
            users_friends = users.update(friends_count: friends_count)
          end
          format.html { redirect_to users_url, notice: "Friendship was successfully deleted." }
          format.json { render :show, status: :created, location: @friendship }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @friendship.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to friends_url, notice: "this friend is request to you for friendship so you can't remove it!" }
      end
    end
  end

  def search
    @users = User.where("name like ? or description like ? or web_url like ? or title like ?","%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
    respond_to do |format|
      format.html { render :users, notice: "search result is billow" }
      format.json { head :@users }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      session[:user_id] = params[:id] if params[:id].present?
      @user = User.find(session[:user_id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :web_url, :title, :description, :is_active, :is_deleted, :friends_count, :password, :email)
    end
end
