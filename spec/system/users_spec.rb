require 'rails_helper'

RSpec.describe 'ユーザーログイン機能', type: :system do
  it 'ログインしていない状態でトップページにアクセスした場合、サインインページに移動する' do
    # トップページに遷移する
      ## visit 〇〇のページへ遷移することを表現
    visit root_path
    # ログインしていない場合、サインインページに遷移していることを確認する
      ## page  visitで訪れた先のページの見える分だけの情報が格納されています
      ## 今いるページのパスがトップページであることを確かめたいです。その時に使用するものがhave_current_pathで,pageのURLを確認するマッチャです。
    expect(page).to have_current_path(new_user_session_path)
      ## ログインしていない状態のユーザーがトップページにアクセスした場合はサインインページに遷移されることが期待されますので、
      ## have_current_path（new_user_session_path）により現在のページがnew_user_session_path（サインインページ）であることを確認しています。
  end

  it 'ログインに成功し、トップページに遷移する' do
    # 予め、ユーザーをDBに保存する
      ##buildとほぼ同じ働きをしますが、createの場合はテスト用のDBに値が保存されます。
    @user = FactoryBot.create(:user)
    # サインインページへ移動する
    visit new_user_session_path
    # ログインしていない場合、サインインページに遷移していることを確認する
    expect(page).to have_current_path(new_user_session_path)
    # すでに保存されているユーザーのemailとpasswordを入力する
      ## 「ユーザー情報を入力する」では、実際にブラウザ上で文字列を入力することを再現する必要があり,fill_inを使用。fill_in 'フォームの名前', with: '入力する文字列'
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    # ログインボタンをクリックする
      ##  click_onメソッド引数に文字列（テキストリンクやvalue属性の値を持ったbutton要素）を取り、一致するテキストなどを持った要素をクリックできるメソット
      ##  保存に時間がかかることを想定して、sleep 1と1秒間待つための処理を入れています。 
    click_on('Log in')
    sleep 1
    # トップページに遷移していることを確認する
    expect(page).to have_current_path(root_path)

  end

  it 'ログインに失敗し、再びサインインページに戻ってくる' do
    # 予め、ユーザーをDBに保存する
    @user = FactoryBot.create(:user)
    # トップページに遷移する
    visit root_path
    # ログインしていない場合、サインインページに遷移していることを確認する
    expect(page).to have_current_path(new_user_session_path)
    # 誤ったユーザー情報を入力する
    fill_in 'user_email', with: 'test'
    fill_in 'user_password', with: 'test'
    # ログインボタンをクリックする
    click_on('Log in')
    # サインインページに戻ってきていることを確認する
    expect(page).to have_current_path(new_user_session_path)
  end
end