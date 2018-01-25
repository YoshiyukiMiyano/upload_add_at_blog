class BlogsController < ApplicationController
  before_action :set_blog, only: [:show, :edit, :update, :destroy]
  before_action :require_login, only: [:index, :new, :edit, :show]


  def index
    @blogs = Blog.all
  end

  def new
    if params[:back]
      @blog = Blog.new(blog_params)
    else
      @blog = Blog.new
    end
  end

  def create
    @blog = Blog.new(blog_params)
    @blog.user_id = current_user.id #現在ログインしているuserのidをblogのuser_idカラムに挿入する。
    @semail = User.find(@blog.user_id).email
    if @blog.save
      ContactMailer.contact_mail(current_user.email).deliver
      redirect_to blogs_path, notice: "ブログを作成しました！"
    else
      render 'new'
    end
  end

  def show
    @favorite = current_user.favorites.find_by(blog_id: @blog.id)
  end
  
  def edit
#    @blog.edit
  end

  def update
#    @blog.update
    if @blog.update(blog_params)
      redirect_to blogs_path, notice: "ブログを編集しました！"
    else
      render 'edit'
    end
  end
  
  def destroy
    @blog.destroy
    redirect_to blogs_path, notice:"ブログを削除しました！"
  end

  def confirm
    @blog = Blog.new(blog_params)
    render :new if @blog.invalid?
  end

  private
  def blog_params
    params.require(:blog).permit(:title, :content)
  end
  
  # idをキーとして値を取得するメソッド
    def set_blog
      @blog = Blog.find(params[:id])
    end
    
  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to new_user_url # halts request cycle
    end
  end

end
