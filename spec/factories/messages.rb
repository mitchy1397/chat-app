FactoryBot.define do
  factory :message do
    content {Faker::Lorem.sentence}
    association :user
    association :room

    # afterというメソッドを用いて、インスタンス生成後に画像が保存されるようにしましょう。
# afterメソッドは任意の処理の後に指定の処理を実行することができます。例えば、after(:build) とすることで、インスタンスがbuildされた後に指定の処理を実行できます。
    after(:build) do |message|
      # io: File.openで設定したパスのファイル（public/images/test_image.png）を、test_image.pngというファイル名で保存をしています。
      message.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
    end
  end
end

# FactoryBotで値を生成する準備が完了しました。
# しかし、このままではテストを実行するまで、本当に値が生成できるのかを確認することができません。
# そこで、Railsコンソールを用いて事前にFactoryBotの挙動を確認します。
