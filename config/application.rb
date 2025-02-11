require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ChatApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    
    
#     rails gコマンドでコントローラーを作成すると、以下のようなファイルが自動生成されます。

# 生成したファイルに対応したスタイルシート
# 生成したファイルに対応したヘルパー
# 生成したファイルに対応したJavaScriptファイル
# アプリケーションをテストするためのファイル
# 今回作成するChatAppでは、必要のないファイルですので、設定を変更して生成させないようにします。
    
    
    config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.test_framework false
    end
  end
end