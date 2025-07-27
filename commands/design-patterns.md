## Design Patterns

コードベースに適用可能なデザインパターンを提案し、SOLID 原則の遵守状況を評価します。

### 使い方

```bash
/design-patterns [分析対象] [オプション]
```

### オプション

- `--suggest` : 適用可能なパターンを提案（デフォルト）
- `--analyze` : 既存パターンの使用状況を分析
- `--refactor` : リファクタリング案を生成
- `--solid` : SOLID 原則の遵守状況をチェック
- `--anti-patterns` : アンチパターンを検出
- `--rails-patterns` : Rails 固有のパターンを分析

### 基本例

```bash
# プロジェクト全体のパターン分析
/design-patterns

# 特定ファイルへのパターン提案
/design-patterns app/services/user_service.rb --suggest

# SOLID 原則チェック
/design-patterns --solid

# Rails アンチパターン検出
/design-patterns --anti-patterns --rails-patterns

# モデル層のパターン分析
/design-patterns app/models/ --suggest
```

### 分析カテゴリ

#### 1. 生成に関するパターン（Ruby/Rails 特化）

- **Factory Pattern**: オブジェクト生成の抽象化（FactoryBot との併用）
- **Builder Pattern**: 複雑なオブジェクトの段階的構築
- **Singleton Pattern**: インスタンスの一意性保証（Rails での適切な使用）
- **Abstract Factory**: 関連オブジェクト群の生成

#### 2. 構造に関するパターン（Rails MVC 対応）

- **Adapter Pattern**: 外部 API との統合
- **Decorator Pattern**: モデルの表示ロジック分離
- **Facade Pattern**: 複雑なサービス群の簡略化
- **Proxy Pattern**: Active Record の遅延読み込み

#### 3. 振る舞いに関するパターン（Rails アクション）

- **Observer Pattern**: Active Record コールバックとの連携
- **Strategy Pattern**: 複数のアルゴリズム実装
- **Command Pattern**: バックグラウンドジョブとの統合
- **Template Method**: Rails の継承パターン活用

#### 4. Rails 固有のパターン

- **Service Object Pattern**: ビジネスロジックの分離
- **Form Object Pattern**: 複雑なフォーム処理
- **Query Object Pattern**: 複雑なクエリの分離
- **Policy Object Pattern**: 認可ロジックの管理
- **Presenter/Decorator Pattern**: ビュー層の責務分離

### SOLID 原則チェック項目（Ruby/Rails 特化）

```
S - Single Responsibility Principle (単一責任の原則)
    Rails: Fat Model/Controller の回避
O - Open/Closed Principle (開放閉鎖の原則)
    Rails: モジュールと継承の適切な使用
L - Liskov Substitution Principle (リスコフの置換原則)
    Ruby: ダックタイピングとポリモーフィズム
I - Interface Segregation Principle (インターフェース分離の原則)
    Ruby: モジュールによる責務分離
D - Dependency Inversion Principle (依存性逆転の原則)
    Rails: 依存性注入とインターフェース抽象化
```

### 出力例

```
Ruby/Rails デザインパターン分析レポート
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

現在使用中のパターン
├─ Active Record Pattern: User, Post, Comment (標準実装)
├─ Observer Pattern: UserObserver, PostObserver (3 箇所)
├─ Service Object Pattern: UserRegistrationService (5 箇所)
├─ Strategy Pattern: PaymentProcessor (3 strategies)
└─ Decorator Pattern: UserDecorator, PostDecorator (Draper gem)

推奨パターン
├─ [HIGH] Repository Pattern
│  └─ 対象: app/models/*.rb
│  └─ 理由: データアクセスロジックの分離、テスタビリティ向上
│  └─ 例:
│      class UserRepository
│        def self.find_active_users
│          User.where(active: true).includes(:profile)
│        end
│        
│        def self.find_by_email(email)
│          User.find_by(email: email)
│        end
│      end
│
├─ [HIGH] Form Object Pattern
│  └─ 対象: app/controllers/users_controller.rb
│  └─ 理由: 複雑なフォーム処理とバリデーションの分離
│  └─ 例:
│      class UserRegistrationForm
│        include ActiveModel::Model
│        include ActiveModel::Attributes
│        
│        attribute :email, :string
│        attribute :password, :string
│        attribute :profile_attributes, :hash
│        
│        validates :email, presence: true
│        
│        def save
│          return false unless valid?
│          User.transaction do
│            # 複雑な保存処理
│          end
│        end
│      end
│
├─ [MED] Query Object Pattern
│  └─ 対象: app/models/post.rb
│  └─ 理由: 複雑なクエリロジックの分離
│  └─ 例:
│      class PostQuery
│        def self.published_in_range(start_date, end_date)
│          Post.published
│              .where(created_at: start_date..end_date)
│              .includes(:author, :tags)
│        end
│      end
│
└─ [LOW] Policy Object Pattern
   └─ 対象: app/controllers/admin/*.rb
   └─ 理由: 認可ロジックの一元管理
   └─ 例:
       class PostPolicy
         def initialize(user, post)
           @user = user
           @post = post
         end
         
         def update?
           @user.admin? || @post.author == @user
         end
       end

Rails アンチパターン検出
├─ [CRITICAL] Fat Model: User.rb (234 lines, 23 public methods)
├─ [HIGH] Fat Controller: PostsController (15 actions, complex logic)
├─ [HIGH] N+1 Query: PostsController#index (posts.each { |p| p.author.name })
├─ [MED] God Object: ApplicationHelper (127 methods)
└─ [LOW] Magic Numbers: User.rb (ハードコードされた定数)

SOLID 原則違反
├─ [S] UserService: 認証、プロフィール更新、通知送信を担当
├─ [S] Post モデル: ビジネスロジック、バリデーション、検索機能が混在
├─ [O] PaymentController: 新決済手段追加時に修正必要
├─ [D] EmailService: ActionMailer クラスに直接依存
├─ [I] AdminUser: 使用されないメソッドを継承
└─ [L] VipUser: User の期待される振る舞いを変更

Rails 固有の改善提案
1. User モデルを複数の Concern に分割
2. PostsController に Service Object を導入
3. Payment Strategy パターンの実装
4. EmailService にインターフェースを定義
5. AdminUser の責務を Policy Object で分離
6. N+1 クエリに includes/preload を適用
```

### 高度な使用例

```bash
# Rails パターンの影響分析
/design-patterns --impact-analysis "Service Object" --rails-patterns

# 特定パターンの Rails 実装例生成
/design-patterns --generate "Form Object" --for app/models/User.rb

# Rails アーキテクチャパターンの評価
/design-patterns --architecture "Hexagonal" --rails-patterns

# Active Record パターンの最適化提案
/design-patterns app/models/ --optimize-active-record
```

### Rails パターン適用例

#### Before (Fat Controller の問題)

```ruby
class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    
    if @user.save
      # 複雑なビジネスロジック
      @user.update(activation_token: SecureRandom.hex)
      UserMailer.welcome_email(@user).deliver_later
      
      # ポイント付与
      @user.create_loyalty_points(initial_points: 100)
      
      # サードパーティAPI連携
      ThirdPartyService.register_user(@user)
      
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
```

#### After (Service Object Pattern 適用)

```ruby
# app/services/user_registration_service.rb
class UserRegistrationService
  def initialize(params)
    @params = params
  end
  
  def call
    User.transaction do
      create_user
      setup_user_account
      send_welcome_email
      register_with_third_party
    end
    
    Result.new(success: true, user: @user)
  rescue StandardError => e
    Result.new(success: false, error: e.message)
  end
  
  private
  
  attr_reader :params
  
  def create_user
    @user = User.create!(user_params)
  end
  
  def setup_user_account
    @user.update!(activation_token: SecureRandom.hex)
    @user.create_loyalty_points(initial_points: 100)
  end
  
  def send_welcome_email
    UserMailer.welcome_email(@user).deliver_later
  end
  
  def register_with_third_party
    ThirdPartyService.register_user(@user)
  end
  
  def user_params
    @params.require(:user).permit(:name, :email, :password)
  end
end

# app/controllers/users_controller.rb (リファクタリング後)
class UsersController < ApplicationController
  def create
    result = UserRegistrationService.new(params).call
    
    if result.success?
      redirect_to result.user, notice: 'User was successfully created.'
    else
      @user = User.new(user_params)
      @user.errors.add(:base, result.error)
      render :new
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
```

#### Query Object Pattern の実装

```ruby
# app/queries/user_search_query.rb
class UserSearchQuery
  def initialize(relation = User.all)
    @relation = relation
  end
  
  def by_name(name)
    return @relation if name.blank?
    @relation.where("name ILIKE ?", "%#{name}%")
  end
  
  def active
    @relation.where(active: true)
  end
  
  def with_posts
    @relation.joins(:posts).distinct
  end
  
  def recent(days = 30)
    @relation.where("created_at > ?", days.days.ago)
  end
  
  def call
    @relation
  end
end

# 使用例
users = UserSearchQuery.new
          .by_name(params[:name])
          .active
          .with_posts
          .recent(7)
          .call
```

### Rails アンチパターン検出

#### Fat Model の検出

```ruby
# 悪い例 - Fat Model
class User < ApplicationRecord
  # 200+ lines of code
  
  def send_welcome_email; end
  def calculate_loyalty_points; end
  def sync_with_crm; end
  def generate_reports; end
  def process_payments; end
  # ... 多数のメソッド
end

# 改善案 - Concern による分離
module User::Emailable
  extend ActiveSupport::Concern
  
  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end
end

module User::Loyalty
  extend ActiveSupport::Concern
  
  def calculate_loyalty_points
    # ポイント計算ロジック
  end
end
```

#### N+1 クエリの検出と修正

```ruby
# 悪い例 - N+1 クエリ
def index
  @posts = Post.all
  # ビューで posts.each { |post| post.author.name } が実行される
end

# 改善案 - eager loading
def index
  @posts = Post.includes(:author).all
end

# Query Object を使った改善
class PostQuery
  def self.with_authors
    Post.includes(:author, :comments => :user)
  end
end
```

### Rails 固有のベストプラクティス

#### 1. Service Object の実装パターン

```ruby
# app/services/application_service.rb
class ApplicationService
  def self.call(*args)
    new(*args).call
  end
  
  def call
    raise NotImplementedError
  end
end

# 具体的な Service Object
class OrderProcessingService < ApplicationService
  def initialize(order, payment_params)
    @order = order
    @payment_params = payment_params
  end
  
  def call
    ActiveRecord::Base.transaction do
      process_payment
      update_inventory
      send_confirmation
    end
  rescue PaymentError => e
    Result.failure(e.message)
  end
  
  private
  
  # ...
end
```

#### 2. Form Object の実装

```ruby
class UserRegistrationForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations
  
  attribute :email, :string
  attribute :password, :string
  attribute :password_confirmation, :string
  attribute :terms_accepted, :boolean
  
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8 }
  validates :password_confirmation, presence: true
  validates :terms_accepted, acceptance: true
  validate :passwords_match
  
  def save
    return false unless valid?
    
    User.create!(
      email: email,
      password: password
    )
  end
  
  private
  
  def passwords_match
    return if password == password_confirmation
    errors.add(:password_confirmation, "doesn't match password")
  end
end
```

#### 3. Presenter/Decorator Pattern

```ruby
# Draper gem を使用した例
class UserDecorator < Draper::Decorator
  delegate_all
  
  def full_name
    "#{first_name} #{last_name}".strip
  end
  
  def avatar_image
    if avatar.attached?
      h.image_tag avatar, class: 'user-avatar'
    else
      h.image_tag 'default-avatar.png', class: 'user-avatar'
    end
  end
  
  def formatted_created_at
    created_at.strftime("%B %d, %Y")
  end
end

# Plain Ruby Decorator
class UserPresenter
  def initialize(user, view_context)
    @user = user
    @view_context = view_context
  end
  
  def display_name
    @user.name.presence || "Anonymous User"
  end
  
  def avatar_tag
    if @user.avatar.attached?
      @view_context.image_tag @user.avatar
    else
      @view_context.content_tag :div, "No Avatar", class: 'no-avatar'
    end
  end
end
```

### 継続的改善とモニタリング

```bash
# 定期的なパターン分析
/design-patterns --analyze --output report.md

# コードメトリクス分析
/design-patterns --metrics --threshold complexity:10

# リファクタリング優先度
/design-patterns --prioritize --impact high
```

### ベストプラクティス

1. **Rails Way の尊重**: Rails の規約を優先し、必要な場合のみパターンを適用
2. **段階的リファクタリング**: 一度に多くのパターンを導入しない
3. **テスト駆動**: パターン適用前後でテストを実行
4. **チーム教育**: パターンの意図と利益をチームで共有
5. **定期的な見直し**: コードベースの成長に合わせてパターンを再評価
6. **Gem の活用**: 既存の Gem（Draper、Pundit等）を活用してパターンを実装
