class Event < ActiveRecord::Base
  belongs_to :user

  has_many :donations, as: :donatable
  has_many :votes, as: :votable
  has_many :comments

  def vote_by!(user)
    # create a new vote associating user and photo
    raise "Already voted" if voted_by?(user)
    votes.find_or_create_by!(voter: user)
  end

  def unvote_by!(user)
    raise "Not yet voted" unless voted_by?(user)
    votes.where(voter: user).first.destroy
  end

  def voted_by?(user)
    votes.exists?(voter: user)
  end

  def vote_count
    votes.size
  end
end
