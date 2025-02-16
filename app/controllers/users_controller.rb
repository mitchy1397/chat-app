class UsersController < ApplicationController

  # rails g controller usersコマンドで編集機能の実装に必要なUsersコントローラーを作成したら、
  # users_controller.rbに、editアクションを定義します。
  # editアクションでは、ビューファイルを表示するだけなので、アクションの定義のみになります。
  def edit
  end 

  # Userモデルの更新を行うupdateアクションをusersコントローラーに定義
  # updateアクションは、編集するだけで、ビューにツイート情報を受け渡す必要ないため、インスタンス変数ではなくただの変数として置き、updateメソッドを使用します。
  def update
    # データの保存ができた場合、できなかった場合で処理を分岐する必要があります。
    # ユーザー情報の更新に成功した場合、チャット画面に遷移するように実装し、「更新に失敗するとeditページに戻ってくる」必要があります。その際は、コントローラー内でrenderメソッドを使います。
    # ログイン中のユーザーが持つidを取得するには、current_userメソッドで現在ログインしているユーザーの情報を取得できます
    if current_user.update(user_params)
      # redirect_to（実行するとビューが表示）の場合は、新たなリクエストを送信されたときと同じ動きになるので、再度コントローラーを経由してビューが表示されます。
      redirect_to root_path
    else
      # renderは、呼び出すビューファイルを指定するメソッドです。renderメソッドには、コントローラーで使用するものとビューで使用するものがあります
      # renderの場合は、新たにリクエストされることなくそのままビューが表示されます。よって、元のインスタンス変数の値が上書きされるかどうかが違います。
      # 多くの場合renderメソッドはデータの保存や更新などに失敗した場合に使用されます。そのため、以下のように発生したエラーを指定して使用します。
      render :edit, status: :unprocessable_entity
      # ここで指定している「:unprocessable_entity」が、発生したエラーの種類を示すもので、「何らかの処理に失敗した」という汎用的な指定方法になります。
      # 特にエラーの種類を限定したい場合以外は、この「:unprocessable_entity」を使用すると覚えておいて問題ありません。
    end
  end 

  # ○○アクションはフォームで送られてきたデータを元に、レコードを保存しますが、意図しないデータの読み書きを防ぐためストロングパラメータ
  # ストロングパラメーターの定義には、requireメソッドと、permitメソッドを組み合わせて使用

  private

  # user_paramsというストロングパラメータの中でpermitメソッドを使用し、モデルuserの「name」と「email」の編集を許可します。
  def user_params
    params.require(:user).permit(:name, :email)
  end

end
