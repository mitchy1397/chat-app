require 'rails_helper'

# 「どの機能に対してのテストを行うか」をdescribeでグループ分け
RSpec.describe User, type: :model do
  # れぞれのテストコードを実行する前に、セットアップを行うことができます
  # 変数を受け渡す際は、beforeに定義する変数はインスタンス変数にする必要があります
  before do
    @user = FactoryBot.build(:user)   #Userのインスタンス生成
  end

  describe 'ユーザー新規登録' do
  # 新規登録がうまくいく場合とうまくいかない場合が、1つのdescribeの中に混在するのを解消するためcontextメソッドを使用。
  # contextは、特定の条件を指定してグループを分けます。
  # 使用方法はdescribeと同じですが、describeには何についてのテストなのかを指定するのに対し、contextには特定の条件を指定します。
  # describeのグループの中でcontextメソッドを用い、新規登録の可否によってさらに細かくグループ分けしましょう。
    context '新規登録できる場合' do
      # itの場合はより詳細に、「describeメソッドに記述した機能において、どのような状況のテストを行うか
      # itで分けたグループのことをexampleと呼び、itに記述した内容のことを指す場合もあります。
      it "nameとemail,passwordとpassword_confirmationが存在すれば登録できる" do
        # 正常系テストのエクスペクテーションには、be_validマッチャを用います。
        # be_validとは、valid?メソッドの返り値が、trueであることを期待するマッチャで,expectの引数に指定されたインスタンスが、バリデーションでエラーにならないものであれば、valid?の返り値はtrueとなりテストは成功
        expect(@user).to be_valid
      end
    end

    context '新規登録できない場合' do
      it "nameが空では登録できない" do
        @user.name = '' 
        # valid?は、バリデーションを実行させて、エラーがあるかどうかを判断するメソッドです。エラーがない場合はtrueを、ある場合はfalseを返します。
        @user.valid?
        # 想定した挙動」と「アプリの実際の挙動」を確認します。この確認をテストコードに落とし込んだものをexpectationといい、検証で得られた挙動が想定通りなのかを確認する構文のことです。expect().to matcher()
        # matcherは、「expectの引数」と「想定した挙動」が一致しているかどうかを判断,代表的な2つのincludeとeqマッチャがある
        # expectの引数には検証で得られた挙動を指定したいため、valid?メソッドを使用した後のインスタンスのエラーメッセージを指定しましょう。すなわち、expect(user.errors.full_messages)となります。
        # さらに、full_messagesの返り値は配列であるため、includeマッチャを用いて、配列にどのようなエラーが含まれていればよいか指定します。nicknameでpresence: trueによるエラーが起こるはずであるため、想定するエラーメッセージは"Nickname can't be blank"が適切です。
        expect(@user.errors.full_messages).to include("Name can't be blank")
        # もしDBに保存されない場合のエラーメッセージは、「Name can't be blank（nameを入力してください）」となります。
      end
      it "emailが空では登録できない" do
        @user.email = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Email can't be blank")
      end
      it "passwordが空では登録できない" do
        @user.password = ''
        @user.valid?
        # binding.pry
        expect(@user.errors.full_messages).to include("Password can't be blank")
      end
      
      it "passwordが5文字以下では登録できない" do
        @user.password = '12345'
        @user.password_confirmation = '12345'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')        
      end
      
      it "passwordが129文字以上では登録できない" do
        @user.password = Faker::Internet.password(min_length: 129, max_length: 150)
        @user.password_confirmation = @user.password
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is too long (maximum is 128 characters)")
      end

      it "passwordとpassword_confirmationが不一致では登録できない" do
        @user.password = "123456"
        @user.password_confirmation = "1234567"
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end

      it "重複したemailが存在する場合は登録できない" do
        # user情報をデータベースに保存した後、FactoryBotを用いて新たなインスタンスを生成しています。
        @user.save
        another_user = FactoryBot.build(:user, email: @user.email)
        another_user.valid?
        expect(another_user.errors.full_messages).to include('Email has already been taken')     
      end

      it "emailは@を含まないと登録できない" do
        @user.email = 'testmail'
        @user.valid?
        expect(@user.errors.full_messages).to include('Email is invalid')
      end
    end
  end
end
