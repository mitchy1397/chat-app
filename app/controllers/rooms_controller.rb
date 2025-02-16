class RoomsController < ApplicationController

  # ルートパスを先ほど作成したrooms/index.html.erbに変更します
  # これで現在「メッセージ一覧画面」がルートパスの表示だったものが変更され、「チャットルーム一覧画面」がルートとして表示されます。
  def index
  end 

  # チャットルームの新規作成なので「new」アクションを定義します。
  # また、form_withに渡す引数として、値が空のRoomインスタンスを@roomに代入しています。
  def new
    @room = Room.new
  end 

  # フォームから送信されるparamsを確認するため、binding.pryを記述します。
  # 以下のようにcreateアクションを定義しましょう。
  def create
    # params確認したため削除  binding.pry
    @room = Room.new(room_params)
    if @room.save
      # 成功した場合はredirect_toメソッドでルートパスにリダイレクトし、失敗した場合はrenderメソッドでrooms/new.html.erbのページを表示しています。
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Railsではセキュリティ対策として、保存する前にストロングパラメーターを使い、許可するパラメーターを指定してから、データを保存するよう推奨されています。
  # バリューが配列で送られてきているため、配列の保存を許可するためのストロングパラメーターが必要になります
  private

  def room_params
    # user_ids: []という記述があります。このように、配列に対して保存を許可したい場合は、キーに対し[]を値として記述します。
    params.require(:room).permit(:name, user_ids: [])
  end

end
