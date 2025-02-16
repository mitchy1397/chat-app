class Room < ApplicationRecord
  # has_manyメソッドのthroughオプションは、モデルに多対多の関連を定義するときに利用
  has_many :room_users
  has_many :users, through: :room_users

  # チャットルームを新規作成するにあたって「ルーム名」は必ず必要なので、
  # 下記のバリデーションは「ルーム名が存在（presence）している場合のみ作成可（true）」という意味です。
  validates :name, presence: true

end
