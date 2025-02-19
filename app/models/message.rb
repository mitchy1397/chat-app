class Message < ApplicationRecord
  # アソシエーションでbelongs_toを指定した場合は、外部キー（今回はuser_id）が存在するというバリデーションは不要です。
  # validates :user_id presence: true ←不要
  # 外部キーに対して「空ではないか」というpresence: trueのバリデーションを記載しないように注意しましょう。
  belongs_to :room
  belongs_to :user
  # Messagesテーブルのレコードと画像を,各レコードとファイルを1対1の関係で紐づけるためにhas_one_attachedというメソッドを利用します。
  # :ファイル名には、添付するファイルがわかる名前をつけましょう。この記述により、モデル.ファイル名で、添付されたファイルにアクセスできるようになります。
  # また、このファイル名は、そのモデルが紐づいたフォームから送られるパラメーターのキーにもなります
  has_one_attached :image
  # このとき、messagesテーブルにカラムを追加する必要はありません

  # 値が空の場合送信できないようにバリデーションを設定しましょう
  # 現在のバリデーションは、テキストと画像の両方がなければ、メッセージを送信できない仕様です。このバリデーションを変更し、画像かテキストどちらかが存在していれば、メッセージを送信できるように実装します。
  # unlessオプションにメソッド名を指定することで、「メソッドの返り値がfalseならばバリデーションによる検証を行う」という条件を作っています。
  validates :content, presence: true, unless: :was_attached?

  # was_attached?メソッドは、self.image.attached?という記述によって、画像があればtrue、なければfalseを返す仕組みです。
  def was_attached?
    self.image.attached?
  end
  # 画像が存在しなければテキストが必要となり、画像があればテキストは不要になりました
end

