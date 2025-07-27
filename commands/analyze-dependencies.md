## Dependency Analysis

プロジェクトの依存関係を分析し、アーキテクチャの健全性を評価します。

### 使い方

```bash
/dependency-analysis [オプション]
```

### オプション

- `--visual` : 依存関係を視覚的に表示
- `--circular` : 循環依存のみを検出
- `--depth <数値>` : 分析の深さを指定（デフォルト: 3）
- `--focus <パス>` : 特定のクラス/モジュールに焦点

### 基本例

```bash
# プロジェクト全体の依存関係分析
/dependency-analysis

# 循環依存の検出
/dependency-analysis --circular

# 特定モデルの詳細分析
/dependency-analysis --focus app/models/user.rb --depth 5

# サービス層の分析
/dependency-analysis --focus app/services
```

### 分析項目

#### 1. 依存関係マトリックス

クラス・モジュール間の依存関係を数値化して表示：

- 直接依存（require, include, extend）
- 間接依存（継承チェーン）
- 依存の深さ
- ファンイン/ファンアウト

#### 2. アーキテクチャ違反検出

- レイヤー違反（ドメインロジックがビュー層に依存）
- 循環依存
- 過度な結合（高い依存度）
- 孤立したクラス

#### 3. Rails アーキテクチャ準拠チェック

- Fat Model/Controller の検出
- サービスオブジェクトの適切な分離
- Active Record の依存関係
- Concern の使用状況

### 出力例

```
依存関係分析レポート
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 メトリクス概要
├─ 総クラス数: 127
├─ 平均依存数: 4.3
├─ 最大依存深度: 7
└─ 循環依存: 3 件検出

⚠️  アーキテクチャ違反
├─ [HIGH] User < ActiveRecord::Base → PaymentService
│  └─ モデルがサービス層に直接依存
├─ [MED] OrdersController ⟲ Order ⟲ OrderItem
│  └─ 循環依存を検出
└─ [LOW] ApplicationHelper → 15 classes
   └─ 過度なファンアウト

✅ 推奨アクション
1. PaymentService を Concern として抽出
2. Order/OrderItem の関係を再設計
3. ApplicationHelper を機能別に分割

📈 依存関係グラフ
User
├── UserProfileService
├── NotificationService
└── PaymentProvider
    ├── StripeAdapter
    └── PaypalAdapter

ActiveRecord Models: 25
Services: 12
Controllers: 18
Concerns: 8
```

### 高度な使用例

```bash
# CI/CD パイプラインでの自動チェック
/dependency-analysis --circular --fail-on-violation

# Rails アーキテクチャルールの定義と検証
/dependency-analysis --rules .rails-dependency-rules.yml

# 時系列での依存関係の変化を追跡
/dependency-analysis --compare HEAD~10

# Gem 依存関係も含めた分析
/dependency-analysis --include-gems

# テストファイルを含めた分析
/dependency-analysis --include-tests
```

### 設定ファイル例 (.rails-dependency-rules.yml)

```yaml
rules:
  - name: "Model Independence"
    source: "app/models/**"
    forbidden: 
      - "app/controllers/**"
      - "app/views/**"
      - "app/services/**"
    allowed:
      - "app/models/concerns/**"

  - name: "Controller Constraints"
    source: "app/controllers/**"
    allowed: 
      - "app/models/**"
      - "app/services/**"
      - "app/helpers/**"
    forbidden: 
      - "lib/external_apis/**"

  - name: "Service Layer"
    source: "app/services/**"
    allowed:
      - "app/models/**"
      - "lib/**"
    forbidden:
      - "app/controllers/**"
      - "app/views/**"

thresholds:
  max_dependencies: 10
  max_depth: 5
  coupling_threshold: 0.8
  fat_model_methods: 20
  fat_controller_actions: 15

ignore:
  - "spec/**"
  - "test/**"
  - "app/assets/**"
  - "db/migrate/**"

rails_specific:
  check_fat_models: true
  check_fat_controllers: true
  analyze_concerns: true
  validate_associations: true
```

### 統合ツール

- `ruby_parser` : Ruby AST 解析
- `reek` : コード品質と依存関係の分析
- `flog` : 複雑度メトリクス
- `rails_best_practices` : Rails 固有のアンチパターン検出
- `bundler-audit` : Gem セキュリティ分析

### Claude との連携

```bash
# Gemfile を含めた分析
cat Gemfile
cat Gemfile.lock
/dependency-analysis
「このRailsプロジェクトの依存関係の問題点を分析して」

# 特定モデルのソースコードと組み合わせ
cat app/models/user.rb
/dependency-analysis --focus app/models/user.rb
「Userモデルの依存関係を詳細に評価して」

# Rails アプリケーション全体の構造把握
ls -la app/
/dependency-analysis --visual
「Rails アプリケーションのアーキテクチャ問題を指摘して」

# routes.rb と組み合わせた分析
cat config/routes.rb
/dependency-analysis --focus app/controllers
「ルーティングとコントローラーの依存関係を確認して」
```

### Rails 固有の分析ポイント

#### 1. Active Record 関連
```ruby
# 検出される問題例
class User < ApplicationRecord
  has_many :orders
  
  def total_spent
    PaymentService.new(self).calculate_total  # ← サービス層への直接依存
  end
end
```

#### 2. Controller の責務
```ruby
# 検出される問題例
class OrdersController < ApplicationController
  def create
    @order = Order.new(order_params)
    PaymentProcessor.charge(@order.amount)    # ← ビジネスロジックがController内
    NotificationService.send_email(@order)   # ← 複数の責務
  end
end
```

#### 3. Concern の適切な使用
```ruby
# 良い例
module Timestampable
  extend ActiveSupport::Concern
  
  included do
    scope :recent, -> { where('created_at > ?', 1.week.ago) }
  end
end
```

### 注意事項

- **前提条件**: Rails プロジェクトルートでの実行が必要
- **制限事項**: 大規模 Rails アプリでは分析に時間がかかる場合があります
- **推奨事項**: 循環依存が発見された場合は即座に対処を検討してください
- **Rails 版本**: Rails 6.0+ での動作を想定

### ベストプラクティス

1. **定期的な分析**: スプリント毎に依存関係の健全性をチェック
2. **Rails Way 準拠**: Rails の規約に従った依存関係を維持
3. **段階的改善**: 大規模なリファクタリングは避け、漸進的に改善
4. **テスト駆動**: 依存関係の変更時は必ずテストを実行
5. **Concern の活用**: 共通機能は適切に Concern として抽出

### Rails アーキテクチャパターン

#### 1. Service Objects
```ruby
# 推奨パターン
class CreateOrderService
  def initialize(user, params)
    @user = user
    @params = params
  end
  
  def call
    # ビジネスロジック
  end
end
```

#### 2. Form Objects
```ruby
# 複雑なフォーム処理
class UserRegistrationForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  
  attribute :email, :string
  attribute :password, :string
end
```

#### 3. Decorator Pattern
```ruby
# プレゼンテーション層の分離
class UserDecorator < SimpleDelegator
  def full_name
    "#{first_name} #{last_name}"
  end
end
```
