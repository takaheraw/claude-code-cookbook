## Check Fact

プロジェクト内のコードベース、ドキュメント（docs/、README.md など）を参照し、与えられた情報の正誤を確認するためのコマンド。

### 使い方

```bash
# 基本的な使い方
/check-fact "Rails アプリでは Devise を使用して認証を実装している"

# 複数の情報を一度に確認
/check-fact "このプロジェクトは GraphQL を使用し、Sidekiq でバックグラウンドジョブを管理している"

# 特定の技術仕様について確認
/check-fact "データベースは PostgreSQL を使用し、Redis をキャッシュストアとして使っている"
```

### 確認プロセス

1. **情報源の優先順位**
   - コードベース（最も信頼性が高い）
   - Gemfile、config/ 内設定ファイル
   - README.md、docs/ 内ドキュメント
   - マイグレーションファイル、ルーティング
   - Issue、Pull Request の議論履歴

2. **判定結果の分類**
   - `✅ 正しい` - 情報がコードベースと完全に一致
   - `❌ 誤り` - 情報が明確に間違っている
   - `⚠️ 一部正しい` - 部分的に正確だが不完全
   - `❓ 判断不可` - 確認に必要な情報が不足

3. **根拠の明示**
   - 該当ファイル名と行番号
   - 関連するコードスニペット
   - 設定ファイルの該当箇所

### 報告形式

```
## ファクトチェック結果

### 検証対象
「[ユーザーが提供した情報]」

### 結論
[✅/❌/⚠️/❓] [判定結果]

### 根拠
- **ファイル**: `app/models/user.rb:15`
- **内容**: [該当するコード/設定]
- **補足**: [追加説明]

### 詳細説明
[誤りの場合は正しい情報を提示]
[一部正しいの場合は正確でない部分を指摘]
[判断不可の場合は不足している情報を説明]
```

### 基本例

```bash
# プロジェクト技術スタック確認
/check-fact "このアプリは Rails + PostgreSQL + Redis + Sidekiq の構成になっている"

# 実装状況確認  
/check-fact "ユーザー認証は Devise で実装済みで、OAuth2 による SNS ログインに対応している"

# アーキテクチャ確認
/check-fact "API は GraphQL で実装されており、REST エンドポイントは使用していない"

# セキュリティ実装確認
/check-fact "パスワードは bcrypt で暗号化され、JWT トークンを使用してセッション管理している"
```

### Rails 固有の確認項目

#### 1. Gem 依存関係の確認

```bash
# Gemfile の確認
cat Gemfile
cat Gemfile.lock

# 例: 認証ライブラリの確認
/check-fact "認証には Devise を使用している"
# → Gemfile 内の `gem 'devise'` を確認
```

#### 2. データベース設定の確認

```bash
# データベース設定
cat config/database.yml

# マイグレーションファイル
ls -la db/migrate/

# 例: データベースの確認
/check-fact "データベースには PostgreSQL を使用している"
# → database.yml の adapter 設定を確認
```

#### 3. ルーティング設定の確認

```bash
# ルーティング確認
cat config/routes.rb
bundle exec rails routes

# 例: API エンドポイントの確認
/check-fact "API エンドポイントは /api/v1 prefix で設計されている"
# → routes.rb の namespace 設定を確認
```

#### 4. 設定ファイルの確認

```bash
# Rails 設定
ls -la config/environments/
cat config/application.rb

# 例: キャッシュ設定の確認
/check-fact "Redis をキャッシュストアとして使用している"
# → config/environments/production.rb の cache_store 設定を確認
```

### Claude との連携

```bash
# Gemfile とコードベース全体の分析後に確認
cat Gemfile && find app/ -name "*.rb" | head -20
/check-fact "このプロジェクトで使用している主要な Gem は..."

# 特定機能の実装状況確認
grep -r "devise" . --include="*.rb"
grep -r "authenticate" app/controllers/
/check-fact "認証機能は Devise でカスタマイズして実装している"

# ドキュメントとの整合性確認
cat README.md
bundle exec rails routes
/check-fact "README に記載されている API エンドポイントは全て実装済み"

# モデルの関連性確認
cat app/models/user.rb
cat app/models/post.rb
/check-fact "User と Post は has_many/belongs_to の関係で設計されている"
```

### Rails 特有の検証パターン

#### 1. 認証・認可システム

```ruby
# app/models/user.rb での確認
class User < ApplicationRecord
  devise :database_authenticatable, :registerable  # Devise 使用確認
end

# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :authenticate_user!  # 認証必須確認
end
```

#### 2. データベースモデル関係

```ruby
# app/models/user.rb
class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
end

# app/models/post.rb  
class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
end
```

#### 3. API 実装の確認

```ruby
# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      resources :posts
    end
  end
end

# app/controllers/api/v1/users_controller.rb
class Api::V1::UsersController < ApplicationController
  respond_to :json
  # JSON API 実装確認
end
```

#### 4. バックグラウンドジョブ

```ruby
# Gemfile での確認
gem 'sidekiq'

# app/jobs/email_job.rb
class EmailJob < ApplicationJob
  queue_as :default
  
  def perform(user_id)
    # Sidekiq ジョブ実装確認
  end
end
```

### 設定ファイル別の確認項目

#### 1. config/database.yml

```yaml
production:
  adapter: postgresql      # ← PostgreSQL 使用確認
  database: myapp_production
  pool: 5
```

#### 2. config/environments/production.rb

```ruby
config.cache_store = :redis_cache_store  # ← Redis キャッシュ確認
config.active_job.queue_adapter = :sidekiq  # ← Sidekiq 確認
```

#### 3. config/application.rb

```ruby
config.api_only = true  # ← API only モード確認
config.middleware.use ActionDispatch::Cors  # ← CORS 設定確認
```

### 活用シーン

- **技術仕様書作成時**: Rails アプリの構成要素確認
- **プロジェクト引き継ぎ時**: 既存の Rails 実装の理解確認
- **クライアント報告前**: 機能実装状況の事実確認
- **技術ブログ執筆時**: Rails プロジェクトの記事内容検証
- **面接・説明資料作成時**: Rails アプリの技術スタック正確性確認
- **セキュリティ監査時**: 認証・認可実装の検証
- **パフォーマンス改善前**: 現在の技術構成把握

### Rails 固有の注意事項

- **Gemfile vs 実際の使用**: Gem がインストールされていても実際に使用されていない場合がある
- **Environment 別設定**: development、test、production で異なる設定の可能性
- **マイグレーション履歴**: データベース構造の変遷を考慮
- **Rails バージョン**: Rails のバージョンによる機能差異
- **設定の継承**: application.rb から各環境への設定継承

### 検証コマンド例

```bash
# Rails 環境の基本確認
bundle exec rails -v
cat config/application.rb | grep "Application"

# 使用中の Gem 確認
bundle list | grep -E "(devise|sidekiq|redis|pg)"

# データベース構造確認
bundle exec rails db:schema:dump
cat db/schema.rb | head -50

# ルーティング確認
bundle exec rails routes | grep -E "(api|users|posts)"

# 設定確認
find config/ -name "*.rb" -exec grep -l "redis\|sidekiq\|devise" {} \;
```

### よくある検証項目

1. **認証システム**: Devise vs Custom vs OAuth
2. **データベース**: PostgreSQL vs MySQL vs SQLite
3. **キャッシュ**: Redis vs Memcached vs File
4. **バックグラウンドジョブ**: Sidekiq vs DelayedJob vs ActiveJob
5. **API 形式**: REST vs GraphQL vs JSON:API
6. **フロントエンド**: Rails Views vs SPA vs API only
7. **テストフレームワーク**: RSpec vs Minitest
8. **デプロイ**: Heroku vs AWS vs Docker
