class Book < ApplicationRecord
  has_one_attached :image
  belongs_to :user
#コメント機能
  has_many :book_comments, dependent: :destroy
#いいね機能
  has_many :favorites, dependent: :destroy
#過去一週間でいいねの多い順に投稿
  has_many :favorited_users, through: :favorites, source: :user

    #週刊ランキングについて
  def self.last_week # メソッド名は何でも良いです
    Book.joins(:favorites).where(favorites: { created_at:　0.days.ago.prev_week..0.days.ago.prev_week(:sunday)}).group(:id).order("count(*) desc")
  end


  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end



  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end


end
