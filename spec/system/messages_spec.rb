require 'rails_helper'

RSpec.describe 'メッセージ投稿機能', type: :system do
      ## beforeの処理により、テスト実行時にチャット画面まで遷移することは実装できています。
  before do  
    # 中間テーブルを作成して、usersテーブルとroomsテーブルのレコードを作成する
      ## beforeの処理内容ですが、まずは以下の1文により、中間テーブルのレコード及びそこに紐づいているuserとroomのレコードを生成できます。
      ## このような書き方ができるのは、room_users.rbに定義したFactoryBotのassociationメソッドによるものです。associationを利用すると、associationで定義したインスタンスも一緒に生成されます。
    @room_user = FactoryBot.create(:room_user)
  end
    

  context '投稿に失敗したとき' do
    it '送る値が空の為、メッセージの送信に失敗する' do
      # サインインする
        ## @room_userに紐づくuserが生成されているため、@room_user.userというアソシエーションの記述で取得できる
      sign_in(@room_user.user)  

      # 作成されたチャットルームへ遷移する
        ## 最終的にnameカラムの値を取得しclick_onメソッドの引数にして、チャットルームの名前のリンクをクリックしている
      click_on(@room_user.room.name)  

      # DBに保存されていないことを確認する
        ## チャットルームに入りメッセージを送信する際に、何も入力せずに送信したため、送信が失敗している挙動を確認します。
      expect {
        ## find('クリックしたい要素').clickと記述することで、実際にクリックができます
        ## メッセージを送信するために、findメソッドを使用して、送信ボタンの「input[name="commit"]」要素を取得して、クリックします。
        find('input[name="commit"]').click
        ## しかし、何も入力を行っていないので、データベースのmessageモデルのカウントが増えていないことを確認しています。
      }.not_to change { Message.count } 

      # 元のページに戻ってくることを確認する
      expect(page).to have_current_path(room_messages_path(@room_user.room))
    end
  end

  context '投稿に成功したとき' do
    it 'テキストの投稿に成功すると、投稿一覧に遷移して、投稿した内容が表示されている' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # 値をテキストフォームに入力する
        ## 変数postに「テスト」という文字列を代入します。ここで変数に代入するのは、この後の工程で再度この文字列を使用するからです。fill_inメソッドを使って、変数postの内容をフォームに入力します
      post = 'テスト'
      fill_in 'message_content', with: post

      # 送信した値がDBに保存されていることを確認する
      expect {
        find('input[name="commit"]').click
        sleep 1
        ## ユーザーが登録されてレコードが1つ増えることを確認します。その時に用いるものが、changeマッチャです。
        ## expect{ 何かしらの動作 }.to change { モデル名.count }.by(1)と記述することによって、モデルのレコードの数がいくつ変動するのかを確認できます。
        ## changeマッチャでモデルのカウントをする場合のみ、expect()ではなくexpect{}となります。
      }.to change { Message.count }.by(1)

      # 投稿一覧画面に遷移していることを確認する
      expect(page).to have_current_path(room_messages_path(@room_user.room))

      # 送信した値がブラウザに表示されていることを確認する
        ## 一覧画面の中に変数postに格納されている文字列があるかどうかを確認しています。
        ## expect(page).to have_content('X')と記述すると、visitで訪れたpageの中に、Xという文字列があるかどうかを判断するマッチャです。
      expect(page).to have_content(post)
    end

    it '画像の投稿に成功すると、投稿一覧に遷移して、投稿した画像が表示されている' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # 添付する画像を定義する
        ## Rails.root.join('public/images/test_image.png')という記述によって前のカリキュラムで作成したテスト用の画像のパスを生成しています。
        ## Rails.rootとすると、このRailsアプリケーションのトップ階層のディレクトリまでの絶対パスを取得できます。パスの情報に対してjoinメソッドを利用することで、引数として渡した文字列でのパス情報を、Rails.rootのパスの情報につけることができます。
      image_path = Rails.root.join('public/images/test_image.png')

      # 画像選択フォームに画像を添付する
        ## タイプがfileのinput要素、つまり画像などのアップロード用のinput要素に、画像投稿のテスト用の画像を添付（アタッチ）できるメソッドです
        ## 第一引数に画像をアップロードするinput要素のname属性の値、第二引数にアップロードする画像のパス、第三引数以降にはオプション
        ## attach_fileメソッドを 使用して、画像をアップロードします。make_visible: trueを付けることで非表示になっている要素も一時的に hidden でない状態になります。
      attach_file('message[image]', image_path, make_visible: true)

      # 送信した値がDBに保存されていることを確認する
      expect{
        find('input[name="commit"]').click
        sleep 1
      }.to change { Message.count }.by(1) 

      # 投稿一覧画面に遷移していることを確認する
      expect(page).to have_current_path(room_messages_path(@room_user.room))

      # 送信した画像がブラウザに表示されていることを確認する
        ## 投稿した画像が一覧表示されているかをhave_selectorで取得して、確認しています。
      expect(page).to have_selector('img')
    end

    it 'テキストと画像の投稿に成功する' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')

      # 画像選択フォームに画像を添付する
      attach_file('message[image]', image_path, make_visible: true)

      # 値をテキストフォームに入力する
      post = 'テスト'
      fill_in 'message_content', with: post

      # 送信した値がDBに保存されていることを確認する
      expect{
        find('input[name="commit"]').click
        sleep 1
      }.to change { Message.count }.by(1)

      # 送信した値がブラウザに表示されていることを確認する
      expect(page).to have_content(post)

      # 送信した画像がブラウザに表示されていることを確認する
      expect(page).to have_selector('img')

    end
  end
end