## Refactor - Ruby/Rails

安全で段階的なコードリファクタリングを実施し、SOLID 原則の遵守状況を評価します。

### 使い方

```bash
# 複雑なコードの特定とリファクタリング計画
find . -name "*.rb" -exec wc -l {} + | sort -rn | head -10
「大きなファイルをリファクタリングして複雑度を削減してください」

# 重複コードの検出と統合
grep -r "def process_user" . --include="*.rb"
「重複したメソッドを Extract Method で共通化してください」

# SOLID 原則違反の検出
grep -r "class.*Service" . --include="*.rb" | head -10
「これらのクラスが単一責任の原則に従っているか評価してください」
```

### 基本例

```bash
# 長いメソッドの検出
find . -name "*.rb" -exec awk '/def /{f=1; start=NR} f && /^end$/{print FILENAME":"start"-"NR" ("(NR-start+1)" lines)"; f=0}' {} \; | sort -t'(' -k2 -nr
"30 行以上のメソッドを Extract Method で分割してください"

# Fat Controller の検出
find app/controllers -name "*.rb" -exec wc -l {} + | sort -rn
"100 行以上のControllerをService Object で改善してください"

# Fat Model の検出
find app/models -name "*.rb" -exec wc -l {} + | sort -rn
"200 行以上のModelを concern で分割してください"

# 条件分岐の複雑度
grep -r "if.*elsif.*elsif" . --include="*.rb"
"ネストした条件文を Polymorphism や State パターンで改善してください"

# コードの臭いの検出
grep -r "TODO\|FIXME\|HACK" . --include="*.rb" --exclude-dir=vendor
"技術的負債となっているコメントを解決してください"
```

### Rails特有のリファクタリング技法

#### Extract Service Object（Controllerの肥大化解消）

```ruby
# Before: Fat Controller
class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.welcome_email(@user).deliver_later
      NotificationService.notify_admin(@user)
      AnalyticsService.track_signup(@user)
      redirect_to @user
    else
      render :new
    end
  end
end

# After: Service Object
class UserCreationService
  def initialize(user_params)
    @user_params = user_params
  end

  def call
    user = User.new(@user_params)
    if user.save
      send_welcome_email(user)
      notify_admin(user)
      track_signup(user)
    end
    user
  end

  private

  def send_welcome_email(user)
    UserMailer.welcome_email(user).deliver_later
  end

  def notify_admin(user)
    NotificationService.notify_admin(user)
  end

  def track_signup(user)
    AnalyticsService.track_signup(user)
  end
end

# Controller
class UsersController < ApplicationController
  def create
    @user = UserCreationService.new(user_params).call
    if @user.persisted?
      redirect_to @user
    else
      render :new
    end
  end
end
```

#### Extract Concern（Modelの共通機能分離）

```ruby
# Before: 重複した機能
class User < ApplicationRecord
  def full_name
    "#{first_name} #{last_name}"
  end

  def initials
    "#{first_name[0]}#{last_name[0]}"
  end
end

class Author < ApplicationRecord
  def full_name
    "#{first_name} #{last_name}"
  end

  def initials
    "#{first_name[0]}#{last_name[0]}"
  end
end

# After: Concern
module Nameable
  extend ActiveSupport::Concern

  def full_name
    "#{first_name} #{last_name}"
  end

  def initials
    "#{first_name[0]}#{last_name[0]}"
  end
end

class User < ApplicationRecord
  include Nameable
end

class Author < ApplicationRecord
  include Nameable
end
```

#### Replace Conditional with Polymorphism

```ruby
# Before: 条件分岐
class OrderCalculator
  def calculate_price(order)
    case order.customer_type
    when 'premium'
      order.amount * 0.8
    when 'regular'
      order.amount
    when 'vip'
      order.amount * 0.6
    end
  end
end

# After: Polymorphism
class PremiumCustomer
  def calculate_price(amount)
    amount * 0.8
  end
end

class RegularCustomer
  def calculate_price(amount)
    amount
  end
end

class VipCustomer
  def calculate_price(amount)
    amount * 0.6
  end
end

class Order < ApplicationRecord
  def customer_strategy
    "#{customer_type.capitalize}Customer".constantize.new
  end

  def calculate_price
    customer_strategy.calculate_price(amount)
  end
end
```

#### Extract Query Object（複雑なクエリの分離）

```ruby
# Before: 複雑なスコープ
class User < ApplicationRecord
  scope :active_premium_users_with_recent_orders, -> {
    joins(:orders)
      .where(active: true, premium: true)
      .where(orders: { created_at: 1.month.ago.. })
      .group('users.id')
      .having('COUNT(orders.id) > ?', 2)
  }
end

# After: Query Object
class ActivePremiumUsersWithRecentOrdersQuery
  def initialize(relation = User.all)
    @relation = relation
  end

  def call
    @relation
      .joins(:orders)
      .where(active: true, premium: true)
      .where(orders: { created_at: 1.month.ago.. })
      .group('users.id')
      .having('COUNT(orders.id) > ?', 2)
  end
end

# 使用例
ActivePremiumUsersWithRecentOrdersQuery.new.call
```

### SOLID 原則チェック（Rails コンテキスト）

```
S - Single Responsibility
├─ Controller: HTTP リクエスト処理のみ
├─ Model: データとビジネスルールのみ
├─ Service: 単一のビジネス処理
└─ Helper: View ロジックのみ

O - Open/Closed
├─ Concern での機能拡張
├─ Decorator パターンの活用
├─ Strategy パターンでの柔軟性
└─ Gem による機能追加

L - Liskov Substitution
├─ 継承関係の適切性
├─ ActiveRecord の継承
├─ Polymorphic Association
└─ Interface の一貫性

I - Interface Segregation
├─ 役割特化の Module
├─ 必要最小限の public メソッド
├─ API の適切な粒度
└─ Concern の責務分離

D - Dependency Inversion
├─ 依存性注入の活用
├─ Interface を通じた疎結合
├─ Configuration による外部依存管理
└─ Factory パターンの使用
```

### Rails特有のリファクタリング手順

1. **現状分析**
   - Controller の行数チェック
   - Model の複雑度測定
   - N+1 クエリの検出
   - 循環的複雑度の測定

2. **段階的実行**
   - RSpec テストの確認・追加
   - 小さなステップでの変更
   - 各変更後の `bundle exec rspec` 実行
   - 頻繁なコミット

3. **品質確認**
   - SimpleCov でのカバレッジ確認
   - Bullet での N+1 検出
   - Rubocop でのスタイルチェック
   - Brakeman でのセキュリティチェック

### よくあるRailsコードの臭い

- **Fat Controller**: 100行を超える Controller
- **Fat Model**: 200行を超える Model
- **God Object**: 過度に多くの責務を持つクラス
- **Long Method**: 30行を超える長いメソッド
- **Callback Hell**: 過度なActiveRecord callback
- **N+1 Query**: includes を使わない関連データアクセス
- **Hard-coded Values**: マジックナンバーや文字列
- **Deep Nesting**: 3層を超えるネスト

### Rails特有の自動化支援

```bash
# 静的解析
bundle exec rubocop
bundle exec reek
bundle exec flog app/
bundle exec flay app/

# セキュリティチェック
bundle exec brakeman

# テスト実行
bundle exec rspec
bundle exec rspec --format documentation

# カバレッジ確認
COVERAGE=true bundle exec rspec

# N+1クエリ検出
# config/environments/development.rb に Bullet 設定

# パフォーマンス測定
bundle exec stackprof
```

### Rails特有の品質メトリクス

```bash
# Controllerの複雑度チェック
find app/controllers -name "*.rb" | xargs wc -l | sort -nr

# Modelの複雑度チェック
find app/models -name "*.rb" | xargs wc -l | sort -nr

# Serviceオブジェクトの確認
find app/services -name "*.rb" 2>/dev/null | wc -l

# Concernの使用状況
find app/models/concerns app/controllers/concerns -name "*.rb" 2>/dev/null | wc -l

# テストカバレッジ
grep -r "def " app/ --include="*.rb" | wc -l
grep -r "def " spec/ --include="*.rb" | wc -l
```

### Rails Best Practices

#### Controller のリファクタリング
```ruby
# Before: Fat Controller
class PostsController < ApplicationController
  def create
    # 50行のビジネスロジック
  end
end

# After: Thin Controller
class PostsController < ApplicationController
  def create
    result = PostCreationService.new(post_params, current_user).call
    
    if result.success?
      redirect_to result.post
    else
      @post = result.post
      render :new
    end
  end
end
```

#### Model のリファクタリング
```ruby
# Before: Fat Model
class User < ApplicationRecord
  # 200行のメソッド定義
end

# After: Concern 使用
class User < ApplicationRecord
  include Nameable
  include Searchable
  include Authenticatable
  
  # 核となるUserロジックのみ
end
```

#### View のリファクタリング
```ruby
# Before: Helper メソッドなし
<% if user.premium? && user.active? && user.orders.any? %>
  <!-- 複雑な条件 -->
<% end %>

# After: Helper メソッド使用
<% if show_premium_content?(user) %>
  <!-- 簡潔な条件 -->
<% end %>

# app/helpers/application_helper.rb
def show_premium_content?(user)
  user.premium? && user.active? && user.orders.any?
end
```

### 注意事項

- **Rails Way**: Rails の規約に従ったリファクタリング
- **テストファースト**: RSpec でのテスト追加・確認
- **段階的アプローチ**: 一度に大きな変更をしない
- **継続的検証**: 各ステップでの `bundle exec rspec` 実行
- **パフォーマンス**: N+1 クエリやメモリ使用量の監視
- **セキュリティ**: Strong Parameters やSQLインジェクション対策の維持
