## Update Doc String - Ruby/Rails

多言語対応の YARD ドキュメントを体系的に管理し、高品質なドキュメントを維持します。

### 使い方

```bash
# 言語を自動検出して実行
「YARD ドキュメントがないクラス・メソッドに追加し、基準を満たさないコメントを更新してください」

# 言語を指定して実行
/update-doc-string --lang en
「Ruby ファイルの YARD ドキュメントを Ruby スタイルガイド準拠で更新してください」

# 特定ディレクトリのドキュメント整備
「app/models/ 配下のクラス・メソッドに YARD ドキュメントを追加してください」
```

### オプション

- `--lang <en|ja>` : ドキュメントの記述言語（デフォルト: 既存コメントから自動判定、なければ en）
- `--style <yard|rdoc>` : ドキュメントスタイル（デフォルト: yard）
- `--marker <true|false>` : Claude マーカーを付与するか（デフォルト: true）
- `--rails <true|false>` : Rails固有のタグを使用するか（デフォルト: 自動判定）

### 基本例

```bash
# 1. 対象ファイルの分析
find . -type f -name "*.rb" | grep -v -E "(test|spec|vendor)" 
「YARD ドキュメントが不足している要素（コメント行数 0 または 30 文字未満）を特定してください」

# 2. ドキュメント追加（言語自動判定）
「特定された要素に Ruby/Rails 固有の必須要素を含む YARD ドキュメントを追加してください」
# → 既存コメントに日本語があれば日本語で、なければ英語で記述

# 3. ドキュメント追加（明示的に英語指定）
/update-doc-string --lang en
「Add YARD documentation with required elements to the identified Ruby elements」

# 4. Rails特化モード
/update-doc-string --rails true
「Rails固有のタグ（@route、@render等）を含むドキュメントを追加してください」

# 5. マーカー確認
「追加・更新したすべての YARD ドキュメントに Claude マーカーがあることを確認してください」
```

### 実行手順

#### 1. 対象要素の優先順位

1. 🔴 **最優先**: YARD ドキュメントがない要素（コメント行数 0）
2. 🟡 **次優先**: 基準を満たさない要素（30 文字未満または必須要素欠如）
3. 🟢 **確認対象**: Claude マーカーがない既存コメント

**対象要素（Ruby/Rails）**:

- Class/クラス定義
- Module/モジュール定義
- Method/メソッド定義（public, protected, private）
- Concern/Rails Concern
- Controller Action/コントローラーアクション
- ActiveRecord Model/モデルクラス

#### 2. Ruby/Rails記述ルール

**標準Rubyクラス/メソッド (YARD)**:

```ruby
# 日本語版（デフォルト）
##
# ユーザーアカウントを管理するサービスクラスです。（30-60 文字）
#
# ユーザーの作成、更新、削除の操作を統一的に処理し、
# 関連するメール送信やログ記録も自動で実行します。（50-200 文字）
#
# @example ユーザー作成の例
#   service = UserAccountService.new
#   result = service.create_user(name: "太郎", email: "taro@example.com")
#
# @since 1.0.0
# @author Claude 🤖
#
class UserAccountService

  ##
  # 新しいユーザーを作成します。（30-60 文字）
  #
  # 指定されたパラメータでユーザーを作成し、
  # ウェルカムメールの送信とログ記録を行います。（50-200 文字）
  #
  # @param name [String] ユーザー名
  # @param email [String] メールアドレス
  # @param options [Hash] 追加オプション
  # @option options [Boolean] :send_email メール送信フラグ（デフォルト: true）
  #
  # @return [User] 作成されたユーザーオブジェクト
  # @return [nil] 作成に失敗した場合
  #
  # @raise [ArgumentError] 必須パラメータが不正な場合
  # @raise [ValidationError] バリデーションエラーの場合
  #
  # @example
  #   user = service.create_user(name: "太郎", email: "taro@example.com")
  #   puts user.name  # => "太郎"
  #
  # @since 1.0.0
  # @author Claude 🤖
  #
  def create_user(name:, email:, **options)
```

```ruby
# 英語版（--lang en）
##
# Service class for managing user accounts. (30-60 chars)
#
# Handles user creation, update, and deletion operations
# with automatic email sending and logging. (50-200 chars)
#
# @example Creating a user
#   service = UserAccountService.new
#   result = service.create_user(name: "John", email: "john@example.com")
#
# @since 1.0.0
# @author Claude 🤖
#
class UserAccountService

  ##
  # Creates a new user. (30-60 chars)
  #
  # Creates a user with the specified parameters and
  # sends welcome email with logging. (50-200 chars)
  #
  # @param name [String] User name
  # @param email [String] Email address
  # @param options [Hash] Additional options
  # @option options [Boolean] :send_email Email sending flag (default: true)
  #
  # @return [User] Created user object
  # @return [nil] If creation failed
  #
  # @raise [ArgumentError] If required parameters are invalid
  # @raise [ValidationError] If validation fails
  #
  # @example
  #   user = service.create_user(name: "John", email: "john@example.com")
  #   puts user.name  # => "John"
  #
  # @since 1.0.0
  # @author Claude 🤖
  #
  def create_user(name:, email:, **options)
```

**Rails Controller**:

```ruby
##
# ユーザー管理を行うコントローラーです。（30-60 文字）
#
# ユーザーの一覧表示、詳細表示、作成、更新、削除の
# 標準的なCRUD操作を提供します。（50-200 文字）
#
# @route GET /users
# @route GET /users/:id
# @route POST /users
# @route PATCH /users/:id
# @route DELETE /users/:id
#
# @since 1.0.0
# @author Claude 🤖
#
class UsersController < ApplicationController

  ##
  # ユーザー一覧を表示します。（30-60 文字）
  #
  # ページネーション付きでユーザー一覧を表示し、
  # 検索やソート機能も提供します。（50-200 文字）
  #
  # @route GET /users
  # @render users/index
  #
  # @param page [String] ページ番号（オプション）
  # @param search [String] 検索キーワード（オプション）
  #
  # @return [void]
  #
  # @example
  #   GET /users?page=2&search=田中
  #
  # @since 1.0.0
  # @author Claude 🤖
  #
  def index
```

**ActiveRecord Model**:

```ruby
##
# ユーザー情報を管理するモデルです。（30-60 文字）
#
# 認証機能付きのユーザーアカウント情報を管理し、
# プロフィール情報と投稿との関連を持ちます。（50-200 文字）
#
# @!attribute [rw] name
#   @return [String] ユーザー名
# @!attribute [rw] email
#   @return [String] メールアドレス
# @!attribute [rw] created_at
#   @return [DateTime] 作成日時
#
# @example ユーザー作成
#   user = User.create(name: "太郎", email: "taro@example.com")
#
# @see Post
# @since 1.0.0
# @author Claude 🤖
#
class User < ApplicationRecord
  devise :database_authenticatable, :registerable

  has_many :posts, dependent: :destroy
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true

  ##
  # ユーザーのフルネームを返します。（30-60 文字）
  #
  # 姓と名を組み合わせてフルネームとして返します。
  # 姓または名が空の場合は片方のみを返します。（50-200 文字）
  #
  # @return [String] フルネーム
  #
  # @example
  #   user.full_name  # => "山田 太郎"
  #
  # @since 1.0.0
  # @author Claude 🤖
  #
  def full_name
    "#{last_name} #{first_name}".strip
  end
end
```

**Rails Concern**:

```ruby
##
# 検索機能を提供するConcernです。（30-60 文字）
#
# ActiveRecordモデルに対して共通の検索機能を追加し、
# キーワード検索とフィルタリング機能を提供します。（50-200 文字）
#
# @example Userモデルでの使用
#   class User < ApplicationRecord
#     include Searchable
#   end
#   
#   User.search("太郎")  # => 名前に"太郎"を含むユーザー
#
# @since 1.0.0
# @author Claude 🤖
#
module Searchable
  extend ActiveSupport::Concern

  included do
    scope :search, ->(keyword) { where("name ILIKE ?", "%#{keyword}%") }
  end

  class_methods do
    ##
    # 複数フィールドを対象とした検索を行います。（30-60 文字）
    #
    # 指定されたキーワードを名前とメールアドレスの
    # 両方のフィールドで検索します。（50-200 文字）
    #
    # @param keyword [String] 検索キーワード
    # @return [ActiveRecord::Relation] 検索結果
    #
    # @example
    #   User.advanced_search("田中")
    #
    # @since 1.0.0
    # @author Claude 🤖
    #
    def advanced_search(keyword)
      where("name ILIKE ? OR email ILIKE ?", "%#{keyword}%", "%#{keyword}%")
    end
  end
end
```

#### 3. 既存コンテンツ保持ルール

1. **既存コメントが基準を満たす場合**: そのまま保持（新規追加しない）
   - 基準: 30 文字以上かつ必須要素（概要・詳細・マーカー）を含む
2. **既存コメントが基準を満たさない場合**: 完全に置き換え（重複させない）
3. **既存コメントがない場合**: 新しいコメントを追加

**保持すべき重要情報**:

- URL やリンク: `@see`, `@link` など
- TODO コメント: `@todo`, `# TODO:` 形式
- 注意事項: `@note`, `@warning` など
- 使用例: `@example` など
- 既存のパラメータ・戻り値説明: `@param`, `@return`
- Rails固有タグ: `@route`, `@render`, `@redirect_to`

### Rails特有のYARDタグ

```ruby
# Controller用タグ
# @route GET /users/:id
# @route POST /users
# @render users/show
# @redirect_to users_path
# @flash_notice "ユーザーが作成されました"
# @before_action :authenticate_user!
# @authorize User

# Model用タグ
# @!attribute [rw] name
# @validates :email, presence: true
# @has_many :posts
# @belongs_to :user
# @scope :active, -> { where(active: true) }

# View用タグ（Helperメソッド）
# @helper ApplicationHelper
# @partial users/user
# @layout application
```

### 品質チェックリスト

- ✅ **文字数**: 概要 30-60 文字、詳細 50-200 文字を厳守
- ✅ **必須要素**: 概要・詳細説明・Claude マーカーの 3 要素を必ず含む
- ✅ **完全性**: 役割・使用コンテキスト・注意点を記載
- ✅ **YARD規約**: YARD タグの正しい使用
- ✅ **Rails規約**: Rails固有のパターンに対応
- ✅ **例外**: エラー・例外の説明（該当する場合）
- ✅ **正確性**: 実装を分析し、事実に基づいた記述のみ

### 注意事項

**🔴 絶対禁止事項**:

- ❌ ドキュメントコメント以外のコード変更
- ❌ 実装詳細に関する推測（事実のみ記載）
- ❌ YARD規約に反するフォーマット
- ❌ 既存の型アノテーション（Sorbet等）の削除・変更
- ❌ 既存コメントとの重複
- ❌ テストファイル（spec/, test/）への文字数基準未満のコメント

### Ruby/Rails固有の設定

```yaml
# 言語別デフォルト設定
ruby:
  style: "yard"  # yard, rdoc
  indent: 2
  prefix: "##"
  tags:
    - "@param"
    - "@return"
    - "@raise"
    - "@example"
    - "@since"
    - "@author"

rails:
  additional_tags:
    - "@route"
    - "@render"
    - "@redirect_to"
    - "@before_action"
    - "@validates"
    - "@has_many"
    - "@belongs_to"
    - "@scope"
```

### 実行と検証

```bash
# 実行結果の記録
ADDED_COMMENTS=0
UPDATED_COMMENTS=0
ERRORS=0

# 既存コメントから言語を自動判定
# 日本語文字（ひらがな・カタカナ・漢字）を検出したら ja、それ以外は en
DOC_LANGUAGE="en"  # デフォルト
if grep -r '[ぁ-んァ-ヶー一-龠]' --include="*.rb" . 2>/dev/null | head -n 1; then
  DOC_LANGUAGE="ja"
fi

# Rails環境の自動判定
RAILS_PROJECT=false
if [ -f "Gemfile" ] && grep -q "rails" Gemfile; then
  RAILS_PROJECT=true
fi

# Ruby静的解析とドキュメント生成
if command -v rubocop >/dev/null; then
  bundle exec rubocop --only Style/Documentation
fi

if command -v yard >/dev/null; then
  bundle exec yard doc
  if [ $? -eq 0 ]; then
    echo "✅ YARD ドキュメント生成成功"
  else
    echo "🔴 YARD ドキュメント生成失敗"
    ERRORS=$((ERRORS + 1))
  fi
fi

# YARDカバレッジチェック
if command -v yard >/dev/null; then
  bundle exec yard stats --list-undoc
fi

# 実行サマリーの出力
echo "📊 実行結果:"
echo "- ドキュメント言語: $DOC_LANGUAGE"
echo "- Rails プロジェクト: $RAILS_PROJECT"
echo "- 追加したコメント: $ADDED_COMMENTS 件"
echo "- 更新したコメント: $UPDATED_COMMENTS 件"
echo "- エラー発生数: $ERRORS 件"
```

### 実行成功基準

1. **完了判定**: 以下をすべて満たす場合に成功
   - Rubocop Documentation チェックが PASSED
   - YARD ドキュメント生成が成功
   - エラー発生数が 0
   - 追加・更新したコメントがすべて基準を満たす

2. **部分成功**: 以下の場合
   - エラー発生数が 5 件未満
   - 全体の 90% 以上が基準を満たす

3. **失敗**: 以下の場合
   - Rubocop Documentation チェックが FAILED
   - YARD ドキュメント生成が失敗
   - エラー発生数が 5 件以上

### Claude との連携

```bash
# プロジェクト全体の分析（言語・Rails自動判定）
find . -type f -name "*.rb" | grep -v -E "(test|spec|vendor)"
/update-doc-string
「このRuby/RailsプロジェクトのYARDドキュメントをベストプラクティスに従って更新して」
# → 既存コメントに日本語があれば ja、なければ en で実行
# → Railsプロジェクトなら Rails固有タグも自動で使用

# 明示的に英語ドキュメントで実行
/update-doc-string --lang en
"Update YARD documentation following Ruby/Rails best practices"

# 明示的に日本語ドキュメントで実行
/update-doc-string --lang ja
「このRuby/RailsプロジェクトのYARDドキュメントをベストプラクティスに従って更新して」

# Rails固有タグ強制使用
/update-doc-string --rails true
「Rails固有のYARDタグ（@route、@renderなど）を含むドキュメントを追加してください」

# マーカーなしで実行（言語自動判定）
/update-doc-string --marker false
"Improve existing YARD documentation without adding Claude markers"

# 英語ドキュメント、マーカーなし
/update-doc-string --lang en --marker false
"Improve existing YARD documentation without adding Claude markers"
```
