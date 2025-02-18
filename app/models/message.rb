class Message < ApplicationRecord
  belongs_to :room
  belongs_to :user
  # Messagesテーブルのレコードと画像を,各レコードとファイルを1対1の関係で紐づけるためにhas_one_attachedというメソッドを利用します。
  # :ファイル名には、添付するファイルがわかる名前をつけましょう。この記述により、モデル.ファイル名で、添付されたファイルにアクセスできるようになります。
  # また、このファイル名は、そのモデルが紐づいたフォームから送られるパラメーターのキーにもなります
  has_one_attached :image
  # このとき、messagesテーブルにカラムを追加する必要はありません

  # 値が空の場合送信できないようにバリデーションを設定しましょう
  validates :content, presence: true
end

