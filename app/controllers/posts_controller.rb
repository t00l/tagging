class PostsController < ApplicationController

  before_action :authenticate_user!, except: [:index]

  def index
    if params[:tag]
      @posts = Post.tagged_with(params[:tag])
    else
      @posts = Post.all
    end
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @user = current_user 
    respond_to do |format|
      if @post.save
        format.js # Will search for create.js.erb
      else
        format.html { render root_path }
      end
    end
  end

  private

    def post_params
      params.require(:post).permit(:name, :content, :all_tags)
    end
end
