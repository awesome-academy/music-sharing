class Lyric < ApplicationRecord
  belongs_to :user
  belongs_to :song
  delegate :name, to: :song, allow_nil: true, prefix: :song
  delegate :name, to: :user, allow_nil: true, prefix: :user
  scope :accepted, -> {where accepted: true}
  scope :load_data, -> {
    select :id, :content, :accepted, :user_id, :song_id, :created_at
  }
  scope :order_date, -> {order created_at: :desc}
  validates :content, presence: true

  def accept_lyric check
    update accepted: check
  end
end
