class Room < ApplicationRecord
  # has_manyメソッドのthroughオプションは、モデルに多対多の関連を定義するときに利用
  has_many :room_users
  has_many :users, through: :room_users

end
