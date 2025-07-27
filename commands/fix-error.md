## Error Fix

エラーメッセージから根本原因を特定し、実証済みの解決策を提案します。

### 使い方

```bash
/fix-error [オプション]
```

### オプション

- なし : 標準的なエラー分析
- `--deep` : 深層分析モード（依存関係・環境要因を含む）
- `--preventive` : 予防策重視の分析
- `--quick` : 即座に適用可能な修正のみ提示
- `--rails` : Rails 固有エラーの専門分析

### 基本例

```bash
# 標準的なエラー分析
bundle exec rails server 2>&1
/fix-error
「サーバー起動エラーを分析して修正方法を提示して」

# 深層分析モード  
bundle exec rspec 2>&1
/fix-error --deep
「テストエラーの根本原因を環境要因も含めて分析して」

# 即座の修正重視
bundle exec rails db:migrate 2>&1
/fix-error --quick
「マイグレーションエラーをすぐに修正できる方法を提示して」

# Rails 固有の分析
bundle exec rails console 2>&1
/fix-error --rails --preventive
「Rails コンソールエラーの修正と今後の予防策を提示して」
```

### Claude との連携

```bash
# Rails ログの分析
tail -100 log/development.log
/fix-error --rails
「Rails アプリケーションエラーの根本原因を特定し、修正方法を提案して」

# Gem インストールエラー
bundle install 2>&1
/fix-error --quick
「bundle install の失敗を分析し、即座に適用できる修正案を提示して」

# Active Record エラーの解析
bundle exec rails console 2>&1
/fix-error --deep
「Active Record の SQL エラーから問題箇所を特定して環境要因も含めて分析して」

# 複数のエラーをまとめて解決
grep -E "ERROR|FATAL|WARN" log/production.log | tail -30
/fix-error --rails
「これらの Rails エラーと警告を優先度順に分類し、それぞれの解決方法を提案して」
```

### Ruby/Rails エラー分析の優先度

#### 🔴 緊急度: 高（即座の対応必須）

- **アプリケーション停止**: サーバークラッシュ、無限ループ、メモリ不足
- **データベースエラー**: マイグレーション失敗、データ破損、接続エラー
- **セキュリティ脆弱性**: Mass Assignment、SQL Injection、認証バイパス
- **本番環境影響**: デプロイ失敗、500エラー、サービス停止

#### 🟡 緊急度: 中（早期対応推奨）

- **パフォーマンス問題**: N+1クエリ、メモリリーク、レスポンス遅延
- **部分的機能不全**: 特定アクションのエラー、バリデーション失敗
- **開発効率低下**: テスト失敗、ビルドエラー、デバッグ困難

#### 🟢 緊急度: 低（計画的対応）

- **Deprecation 警告**: Rails バージョン非互換、Gem 警告
- **開発環境限定**: ローカル環境のみの問題、設定不備
- **コード品質**: RuboCop 警告、未使用変数、長いメソッド

### Ruby/Rails 特有のエラー分析プロセス

#### Phase 1: Ruby/Rails エラー情報収集

```bash
🔴 必須実行:
- 完全なスタックトレースの取得
- Rails ログ（development.log、production.log）の確認
- Gemfile.lock のバージョン確認

🟡 Rails 早期実行:
- Rails バージョンと Ruby バージョンの確認
- database.yml 設定の検証
- config/application.rb の設定確認
- 最近のマイグレーション履歴

🟢 Rails 追加実行:
- Redis/Sidekiq の状態確認
- Active Storage の設定
- Action Cable の接続状態
- 外部 API との通信状態
```

#### Phase 2: Rails 固有の根本原因分析

1. **MVC レイヤー別の問題特定**
   - Model: Active Record、バリデーション、アソシエーション
   - View: ERB テンプレート、ヘルパーメソッド、アセット
   - Controller: ルーティング、アクション、フィルター

2. **Rails 固有の深層原因**
   - 設定の不整合（database.yml、routes.rb）
   - Gem 依存関係の競合
   - Rails 規約違反
   - 環境変数の未設定

3. **データベース関連の問題**
   - マイグレーション状態の確認
   - スキーマの整合性
   - インデックスの不足
   - 外部キー制約違反

### Rails エラータイプ別の分析手法

#### Active Record エラー

```ruby
# ActiveRecord::RecordNotFound
必須確認（高）:
- find vs find_by の使い分け
- id の存在確認
- スコープの適用状況

# ActiveRecord::RecordInvalid  
必須確認（高）:
- バリデーションルールの確認
- Strong Parameters の設定
- before_validation コールバック
```

#### ルーティングエラー

```ruby
# ActionController::RoutingError
必須確認（高）:
- routes.rb の設定
- リソースルーティングの記述
- namespace/scope の構成
- constraints の適用
```

#### テンプレートエラー

```ruby
# ActionView::Template::Error
必須確認（高）:
- ERB 構文の確認
- インスタンス変数の定義
- ヘルパーメソッドの存在
- パーシャルのパス
```

#### データベース関連エラー

```ruby
# ActiveRecord::PendingMigrationError
必須確認（高）:
- rails db:migrate の実行
- マイグレーションファイルの順序
- rollback が必要な場合の特定

# ActiveRecord::StatementInvalid
必須確認（高）:
- SQL クエリの構文
- カラム名の存在確認
- データ型の不整合
```

### 出力例

```
🚨 Ruby/Rails エラー分析レポート
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📍 エラー概要
├─ 種別: [ActiveRecord/ActionController/ActionView/Gem/Environment]
├─ 緊急度: 🔴 高 / 🟡 中 / 🟢 低  
├─ 影響範囲: [Model/View/Controller/全体]
├─ Rails バージョン: 7.0.4
├─ Ruby バージョン: 3.1.0
└─ 再現性: [100% / 断続的 / 特定条件]

🔍 根本原因
├─ 直接原因: NoMethodError - undefined method `name` for nil:NilClass
├─ 発生箇所: app/views/users/show.html.erb:15
├─ 背景要因: @user インスタンス変数が nil
└─ トリガー: 存在しないユーザーID でのアクセス

💡 解決策
🔴 即座の対処:
1. コントローラーで存在確認を追加:
   ```ruby
   def show
     @user = User.find(params[:id])
   rescue ActiveRecord::RecordNotFound
     redirect_to users_path, alert: 'User not found'
   end
   ```

2. ビューでの安全な参照:
   ```erb
   <%= @user&.name || 'Unknown User' %>
   ```

🟡 根本的解決:
1. find_by を使用してより安全な実装:
   ```ruby
   def show
     @user = User.find_by(id: params[:id])
     return redirect_to users_path, alert: 'User not found' unless @user
   end
   ```

2. before_action フィルターで共通化:
   ```ruby
   before_action :set_user, only: [:show, :edit, :update]
   
   private
   
   def set_user
     @user = User.find_by(id: params[:id])
     redirect_to users_path, alert: 'User not found' unless @user
   end
   ```

🟢 予防策:
1. 統一的なエラーハンドリング:
   ```ruby
   # app/controllers/application_controller.rb
   rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
   
   private
   
   def record_not_found
     redirect_to root_path, alert: 'Record not found'
   end
   ```

2. テストケースの追加:
   ```ruby
   # spec/controllers/users_controller_spec.rb
   describe 'GET #show' do
     context 'when user does not exist' do
       it 'redirects with error message' do
         get :show, params: { id: 999 }
         expect(response).to redirect_to(users_path)
         expect(flash[:alert]).to eq('User not found')
       end
     end
   end
   ```

3. 監視設定:
   ```ruby
   # config/application.rb
   config.exceptions_app = self.routes
   ```

📝 検証手順
1. テストサーバーでの動作確認:
   ```bash
   bundle exec rails server
   # 存在しないユーザーIDでアクセステスト
   ```

2. テスト実行:
   ```bash
   bundle exec rspec spec/controllers/users_controller_spec.rb
   ```

3. ログでのエラー確認:
   ```bash
   tail -f log/development.log
   ```
```

### Rails 固有のエラーパターンと解決策

#### 1. Gem 関連エラー

```bash
# Bundler エラー
Bundler::GemNotFound: Could not find gem 'devise'

解決策:
1. Gemfile に追加: gem 'devise'
2. bundle install 実行
3. devise:install ジェネレーター実行

# バージョン競合
Bundler could not find compatible versions for gem "activesupport"

解決策:
1. bundle update activesupport
2. Gemfile でバージョン範囲を調整
3. bundle exec gem dependency [gem名] で依存関係確認
```

#### 2. マイグレーション関連エラー

```ruby
# PendingMigrationError の解決
ActiveRecord::PendingMigrationError: 
Migrations are pending. To resolve this issue, run: bin/rails db:migrate

解決策:
1. bundle exec rails db:migrate
2. 必要に応じて rails db:migrate:status で状態確認
3. 開発環境リセット: rails db:drop db:create db:migrate db:seed

# マイグレーション衝突の解決
ActiveRecord::DuplicateMigrationVersionError:
Multiple migrations have the version number 20231201120000

解決策:
1. rails db:migrate:status で重複確認
2. 新しいマイグレーションファイルの生成: rails generate migration FixDuplicateVersion
3. 重複するマイグレーションの削除または rename
```

#### 3. ルーティングエラー

```ruby
# No route matches エラー
ActionController::RoutingError: No route matches [GET] "/users/new"

解決策:
1. routes.rb の確認:
   ```ruby
   Rails.application.routes.draw do
     resources :users  # new アクションが含まれる
   end
   ```

2. ルート確認: bundle exec rails routes | grep users
3. link_to の引数確認: <%= link_to 'New User', new_user_path %>
```

#### 4. Strong Parameters エラー

```ruby
# ForbiddenAttributesError
ActiveModel::ForbiddenAttributesError

解決策:
1. Strong Parameters の実装:
   ```ruby
   private
   
   def user_params
     params.require(:user).permit(:name, :email, :age)
   end
   ```

2. ネストしたパラメータの許可:
   ```ruby
   def user_params
     params.require(:user).permit(:name, :email, profile_attributes: [:bio, :avatar])
   end
   ```
```

#### 5. Asset Pipeline エラー

```ruby
# Asset not precompiled エラー
ActionView::Template::Error: Asset was not declared to be precompiled

解決策:
1. config/application.rb または config/environments/production.rb に追加:
   ```ruby
   config.assets.precompile += %w( admin.css admin.js )
   ```

2. アセットの再コンパイル:
   ```bash
   bundle exec rails assets:precompile RAILS_ENV=production
   ```
```

### Rails 環境別のエラー対応

#### Development 環境

```bash
# よくある開発環境エラー
1. Database configuration error
   - database.yml の設定確認
   - データベースサーバーの起動確認
   - bundle exec rails db:create

2. Redis connection error (Sidekiq使用時)
   - Redis サーバーの起動: redis-server
   - config/redis.yml の設定確認

3. Node.js/Yarn エラー (Webpacker使用時)
   - Node.js バージョン確認: node -v
   - パッケージ再インストール: yarn install
```

#### Production 環境

```bash
# 本番環境特有のエラー
1. Secret key base not set
   - Rails.application.credentials の設定
   - 環境変数 SECRET_KEY_BASE の設定

2. Database connection pool error
   - database.yml の pool 設定調整
   - コネクション数の監視

3. Asset serving error
   - config.public_file_server.enabled = true
   - Nginx/Apache の設定確認
```

### Rails のベストプラクティス

#### 1. エラーハンドリング

```ruby
# アプリケーションコントローラーでの共通処理
class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  
  private
  
  def not_found
    render 'errors/404', status: :not_found
  end
  
  def unprocessable_entity(exception)
    render json: { errors: exception.record.errors }, status: :unprocessable_entity
  end
end
```

#### 2. ログ出力の改善

```ruby
# カスタムロガーの設定
Rails.logger.info "User #{current_user.id} performed action: #{action_name}"

# Structured logging
Rails.logger.info({
  user_id: current_user.id,
  action: action_name,
  params: filtered_params,
  timestamp: Time.current
}.to_json)
```

#### 3. テスト環境でのエラー対策

```ruby
# spec/rails_helper.rb
RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  
  # Database cleaning
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
end
```

### 関連コマンド

- `/design-patterns --rails` : Rails アーキテクチャの問題分析
- `/tech-debt` : 技術的負債の観点からエラーの根本原因を分析
- `/analyze-performance` : パフォーマンス起因のエラー分析
