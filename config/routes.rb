Rails.application.routes.draw do
  devise_for :users
  get 'messages/index'
  root to: "messages#index"
  # 本章でダウンロードしたusers/edit.html.erbを表示するために必要な、ルーティングとコントローラーを実装します
  # 編集画面への遷移には、edit,updateアクション
  resources :users, only: [:edit, :update]
  # rails routes でコントローラーedit,updateアクションを一応確認
end
