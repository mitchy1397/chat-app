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
  resources :rooms, only: [:new, :create]
end
