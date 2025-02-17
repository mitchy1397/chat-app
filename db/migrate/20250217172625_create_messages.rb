class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|

      t.string  :content
      # room_idとuser_idは、roomsテーブルとusersテーブルのidが主キーであり、messagesテーブルと関連性を持つ場合に必要なカラムです。
      # そのidで判別できるレコードに関連付けを行う場合に使用するものが、外部キー制約です。
      # roomとuserには、foreign_key: trueの制約をつけましょう
      # 外部キー（今回であればroom_idとuser_id）がないとDBに保存できないようにします。
      # もしこの制約をつけなかった場合、room_idカラムとuser_idカラムが空になったり、そこに意図しない値が保存されてしまう可能性があります。
      # そうなるとエラーが起こってしまいます。
      t.references :room, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
