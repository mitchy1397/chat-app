class Room < ApplicationRecord
  # has_manyメソッドのthroughオプションは、モデルに多対多の関連を定義するときに利用
  # チャットルームの削除を試みた場合、所属先（外部キーの参照先）を持たないメンバーとメッセージを生み出してしまうため、エラーとなり、チャットルームの削除自体が行えません。
  # dependentオプションは親モデルを削除した時に、親モデルと関連している子モデルに対する挙動を指定するオプションです。
  # たとえば、dependentオプションに:destroyを指定したときは、親モデルが削除されたとき、それに紐付ている子モデルも一緒に削除されます。
  has_many :room_users, dependent: :destroy
  has_many :users, through: :room_users
  has_many :messages, dependent: :destroy

  # チャットルームを新規作成するにあたって「ルーム名」は必ず必要なので、
  # 下記のバリデーションは「ルーム名が存在（presence）している場合のみ作成可（true）」という意味です。
  validates :name, presence: true

end
