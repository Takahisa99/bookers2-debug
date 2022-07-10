class BooksController < ApplicationController
  before_action :correct_user, only: [:edit,:update]

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @books = Book.new
    @book_comment = BookComment.new
    @book_detail = Book.find(params[:id])
     unless ViewCount.find_by(user_id: current_user.id, book_id: @book_detail.id)
      current_user.view_counts.create(book_id: @book_detail.id)
     end
  end

  def index
    @books = Book.all
    @book = Book.new
    @user = current_user
    @books = Book.includes(:favorited_users).sort {|a,b| b.favorited_users.size <=> a.favorited_users.size}


  end

  def create
    @books = Book.all
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice]= "You have created book successfully."
      redirect_to book_path(@book)
    else
       @user = current_user

      render :index
    end
  end

#週刊ランキングについて
  def weekly_rank
    @ranks = Cook.last_week
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      @books = Book.all
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :image)
  end

  def correct_user
    @book = Book.find(params[:id])
    @user = @book.user
    redirect_to(books_path) unless @user == current_user
  end



end
