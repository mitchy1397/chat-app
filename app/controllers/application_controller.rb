class ApplicationController < ActionController::Base
  # authenticate_user!メソッドで、ユーザーがログインされなければログイン画面に遷移する。
  # before_actionで呼び出すことで、アクションを実行する前にログインしていなければログイン画面に遷移させられます。
  before_action :authenticate_user!

  # deviseはあらかじめDBに保存できるカラムが決められています。
  # したがって、他のカラム情報をDBに保存する場合は、ストロングパラメーターの設定が別途必要です
  # application_controllerにbefore_actionを使用しているため、全てのアクションが実行される前に、 
  # before_action :configure_permitted_parameters, if: :devise_controller?が実行されることになります。
  before_action :configure_permitted_parameters, if: :devise_controller? 

  # ここでconfigure_permitted_parametersメソッドの定義を行なっています。
  # deviseをインストールすることでdevise_parameter_sanitizerメソッドが使えるようになります。
  # deviseでユーザー登録をする場合に使用でき、「特定のカラムを許容する」メソッドです。
  # 今回は「nameカラム」を追加したので、このメソッドを使用し、「name」キーの内容の保存をpermitメソッドで許可しています。
  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
