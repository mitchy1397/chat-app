class CreateRoomUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :room_users do |t|
      # データベース設計では、別テーブルのカラムを参照する「外部キー」という型があり,外部キーを使用する際はreferencesを使用。
      # references型Railsで外部キーのカラムを追加する際に、用いる型のことです
      # foreign_key: trueという記述を加えることで、外部キー制約を設定
      t.references :room, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
