Rails.application.routes.draw do
  devise_for :users
  get 'messages/index'
  # ルートパスを先ほど作成したrooms/index.html.erbに変更します
  # これで現在「メッセージ一覧画面」がルートパスの表示だったものが変更され、「チャットルーム一覧画面」がルートとして表示されます。
  # このコードを変更します  root to: "messages#index"
  root to: "rooms#index"
  # 本章でダウンロードしたusers/edit.html.erbを表示するために必要な、ルーティングとコントローラーを実装します
  # 編集画面への遷移には、edit,updateアクション
  resources :users, only: [:edit, :update]
  # rails routes でコントローラーedit,updateアクションを一応確認
  
  # 新規チャットルームの作成で動くアクションは「new」と「create」のみ
  # room削除機能追加destroy
  resources :rooms, only: [:new, :create, :destroy] do
  # 普段通りのルーティングだと、パスの中にどのツイートへのコメントなのかを示す情報がありません。メッセージには必ずメッセージ先となるroomが存在しているはずです。
  # メッセージを投稿する際には、どのroomに対するmessageなのかをパスから判断できるようにしたいので、ここではルーティングのネストという方法を使っていきます。
  # ルーティングをネストさせる一番の理由は、アソシエーション先のレコードのidをparamsに追加してコントローラーに送るため
    resources :messages, only: [:index, :create]
    # この記述によって、「あるroomに対してmessages」という親子関係を表現したパスが、message投稿に必要なリクエストのパスになります。
    # rails routesで確認するとネストによってmessages#indexのURLは/rooms/:room_id/messagesとなっています。これはメッセージに紐付いているチャットルームのid
  end
end
