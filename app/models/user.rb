class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # 「name」カラムに、presence: trueを設けることで、空の場合はDBに保存しないというバリデーションを設定しています。
  # つまり、ユーザー登録時に「name」を空欄にして登録しようとすると、エラーが発生します。
  validates :name, presence: true

  # has_manyメソッドのthroughオプションは、モデルに多対多の関連を定義するときに利用
  has_many :room_users
  has_many :rooms, through: :room_users
  has_many :messages

end
