class MessagesController < ApplicationController
  def index
    # Message.newで生成した、Messageモデルのインスタンス情報を代入します。
    @message = Message.new 
    # find(params[:room_id])と記述することで、paramsに含まれているroom_idを代入します
    # ルーティングをネストしているため/rooms/:room_id/messagesといったパスになり,パスにroom_idが含まれているため、
    # paramsというハッシュオブジェクトの中に、room_idという値が存在しています。そのため、params[:room_id]と記述することでroom_idを取得できます。
    @room = Room.find(params[:room_id])
  end

  # form_withでビューファイルからコントローラーに値を送信する準備はできたので
  # 次は、コントローラー側で、送られてきた値（パラメーター）を受け取り、保存する処理を実装します。
  def create
    # room_idから、特定のレコードを取得
    @room = Room.find(params[:room_id])
    # 下記は、直前で取得した@roomに紐づくmessageモデルのインスタンスを生成しています。
    # has_manyのアソシエーションを組んでいれば、親モデルのインスタンス.子モデルの複数形（小文字）.newという記述方法で、親モデルのインスタンスに紐づく子モデルのインスタンスを生成できます。
    # @room.messages.newでチャットルームに紐づいたメッセージのインスタンスを生成し、message_paramsを引数にして、privateメソッドを呼び出します。
    @message = @room.messages.new(message_params)
    # saveメソッドでメッセージの内容をmessagesテーブルに保存します。
    # if文を用いて、DBに値が保存された場合と失敗した場合で条件分岐します。保存が成功していれば、投稿したメッセージ一覧画面に遷移するように実装しましょう
    if @message.save
      # @message.saveでメッセージの保存に成功した場合、redirect_toメソッドを用いてmessagesコントローラーのindexアクションに再度リクエストを送信し、
      # 新たにインスタンス変数を生成します。これによって保存後の情報に更新されます。
      redirect_to room_messages_path(@room)
    else
      render :index, status: :unprocessable_entity
    end
  end


  # privateメソッドとしてmessage_paramsを定義し、メッセージの内容contentをmessagesテーブルへ保存できるようにします
  private
# パラメーターの中に、ログインしているユーザーのidと紐付いている、メッセージの内容contentを受け取れるように許可します。
  def message_params
    params.require(:message).permit(:content).merge(user_id: current_user.id)
  end 

end

