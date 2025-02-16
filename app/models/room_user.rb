class RoomUser < ApplicationRecord
  # 中間テーブルのアソシエーション
  belongs_to :room
  belongs_to :user
end
