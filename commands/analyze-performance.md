## Analyze Performance

アプリケーションのパフォーマンス問題を分析し、技術的負債の観点から改善策を提案します。

### 使い方

```bash
# パフォーマンス問題の包括的分析
find . -name "*.rb" | xargs wc -l | sort -rn | head -10
「大きなファイルとパフォーマンス問題を特定して改善案を提示して」

# N+1クエリ問題の検出
grep -r "\.each.*\.\(find\|where\)" app/ --include="*.rb"
「N+1 クエリ問題とデータベースボトルネックを分析して」

# メモリリークの可能性
grep -r "@@\|Class.new\|define_method" . --include="*.rb" | grep -v "test\|spec"
「メモリリークのリスクと対策を評価して」
```

### 基本例

```bash
# Gemfileと依存関係のパフォーマンス影響
cat Gemfile && bundle outdated
"依存関係がパフォーマンスに与える影響を評価して"

# データベースパフォーマンス
grep -r "includes\|joins\|preload" app/models/ | head -20
"データベースクエリの最適化ポイントを分析して"

# アセットとビューの最適化
find app/assets -name "*.scss" -o -name "*.js" | xargs ls -lh
find app/views -name "*.erb" | xargs grep -l "render.*collection"
"アセットとビューレンダリングの改善点を特定して"
```

### 分析観点

#### 1. コードレベルの問題

- **N+1 クエリ**: ActiveRecord の非効率なクエリパターン
- **非効率なループ**: 大量データに対する不適切な処理
- **重複クエリ**: 同じデータの複数回取得
- **メモリリーク**: クラス変数やグローバル変数の不適切使用

#### 2. Rails アーキテクチャレベルの問題

- **Fat Controller**: コントローラーでの重い処理
- **Fat Model**: モデルでの過度な責務集中
- **インデックス不足**: データベースクエリの最適化不足
- **キャッシュ戦略**: Fragment/Russian Doll キャッシュの未活用

#### 3. 技術的負債による影響

- **レガシーGem**: 古いライブラリによる性能劣化
- **設計の問題**: Single Responsibility Principle 違反
- **テスト不足**: パフォーマンス回帰の検出漏れ
- **監視不足**: Rails のパフォーマンス監視体制

### 改善優先度

```
🔴 Critical: システム障害リスク
├─ N+1 クエリ (データベース負荷)
├─ メモリリーク (サーバークラッシュ)
└─ 同期処理 (リクエストタイムアウト)

🟡 High: ユーザー体験影響
├─ ページロード時間 (ビューレンダリング)
├─ データベースインデックス (クエリ速度)
└─ アセット最適化 (初回ロード)

🟢 Medium: 運用効率
├─ Gem 依存関係更新 (セキュリティ)
├─ コード重複 (保守性)
└─ バックグラウンドジョブ (スループット)
```

### 測定とツール

#### Rails アプリケーション

```bash
# パフォーマンス計測
bundle exec rails s -e production
bundle exec rails runner 'puts Rails.application.config.cache_classes'

# プロファイリング (development)
gem install ruby-prof stackprof
bundle exec ruby-prof --printer=flat bin/rails runner 'User.includes(:posts).limit(100)'

# メモリ使用量
gem install derailed_benchmarks
bundle exec derailed bundle:mem

# N+1 クエリ検出
gem install bullet  # Gemfile に追加後
```

#### データベース

```ruby
# クエリ分析 (Rails console)
ActiveRecord::Base.logger = Logger.new(STDOUT)
User.includes(:posts).where(active: true).limit(10).to_a

# スロークエリ分析
# config/database.yml での設定
# slow_query_log: true
# long_query_time: 0.1
```

#### フロントエンド (Rails)

```bash
# アセット分析
bundle exec rails assets:precompile RAILS_ENV=production
find public/assets -name "*.js" -o -name "*.css" | xargs ls -lh

# ビューパフォーマンス
grep -r "render.*partial" app/views/ | wc -l
grep -r "link_to\|button_to" app/views/ | head -10
```

### Ruby/Rails 固有のパフォーマンス問題

#### 1. ActiveRecord N+1 問題

```ruby
# 悪い例
@users = User.all
@users.each do |user|
  puts user.posts.count  # N+1 クエリ発生
end

# 良い例
@users = User.includes(:posts)
@users.each do |user|
  puts user.posts.size  # メモリ内で計算
end
```

#### 2. 非効率なスコープ

```ruby
# 悪い例
class User < ApplicationRecord
  scope :active_with_posts, -> { 
    where(active: true).select { |u| u.posts.any? }
  }
end

# 良い例
class User < ApplicationRecord
  scope :active_with_posts, -> { 
    joins(:posts).where(active: true).distinct
  }
end
```

#### 3. ビューでのパフォーマンス問題

```erb
<!-- 悪い例 -->
<% @users.each do |user| %>
  <% if user.posts.published.any? %>  <!-- N+1 -->
    <%= user.name %>
  <% end %>
<% end %>

<!-- 良い例 -->
<% @users_with_published_posts.each do |user| %>
  <%= user.name %>
<% end %>
```

#### 4. キャッシュ戦略

```ruby
# Fragment キャッシュ
# app/views/users/_user.html.erb
<% cache user do %>
  <div class="user">
    <%= user.name %>
    <%= user.email %>
  </div>
<% end %>

# Russian Doll キャッシュ
# app/views/posts/show.html.erb
<% cache [@post, @post.comments.maximum(:updated_at)] do %>
  <!-- ポストとコメントの内容 -->
<% end %>
```

### パフォーマンス監視の設定

#### 1. Rails アプリケーション監視

```ruby
# config/application.rb
config.log_level = :info
config.cache_store = :redis_cache_store

# Gemfile
gem 'newrelic_rpm'  # または 'skylight'
gem 'rack-mini-profiler', group: :development
gem 'bullet', group: :development
```

#### 2. データベース監視

```yaml
# config/database.yml
development:
  adapter: postgresql
  slow_query_log: true
  long_query_time: 0.1
  log_queries_not_using_indexes: true
```

#### 3. メモリ監視

```ruby
# config/puma.rb
preload_app!

before_fork do
  # データベース接続を切断
  ActiveRecord::Base.connection_pool.disconnect!
end

on_worker_boot do
  # ワーカープロセスでデータベース接続を再確立
  ActiveRecord::Base.establish_connection
end
```

### 継続的改善

- **定期監査**: スプリント毎のパフォーマンステスト実行
- **メトリクス収集**: レスポンス時間、メモリ使用量、DB クエリ数の追跡
- **アラート設定**: APM ツールでの閾値超過アラート
- **チーム共有**: Rails パフォーマンスベストプラクティスの文書化

### Rails 固有のベストプラクティス

#### 1. データベース最適化

```ruby
# インデックスの適切な設定
class AddIndexToUsers < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :email, unique: true
    add_index :posts, [:user_id, :published_at]
    add_index :comments, [:post_id, :created_at]
  end
end
```

#### 2. バックグラウンド処理

```ruby
# 重い処理は非同期で実行
class EmailNotificationJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    UserMailer.welcome_email(user).deliver_now
  end
end

# コントローラーから呼び出し
EmailNotificationJob.perform_later(user.id)
```

#### 3. 設定最適化

```ruby
# config/environments/production.rb
config.cache_classes = true
config.eager_load = true
config.consider_all_requests_local = false
config.action_controller.perform_caching = true
config.public_file_server.headers = {
  'Cache-Control' => 'public, max-age=31557600'
}
```

### パフォーマンステストの自動化

```ruby
# spec/performance/user_performance_spec.rb
require 'rails_helper'
require 'benchmark'

RSpec.describe 'User Performance', type: :request do
  it 'loads user index within acceptable time' do
    create_list(:user, 100)
    
    time = Benchmark.realtime do
      get users_path
    end
    
    expect(time).to be < 0.5  # 500ms 以内
    expect(response).to have_http_status(:success)
  end
end
```
