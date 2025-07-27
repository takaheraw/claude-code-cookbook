## PR Review - Ruby/Rails

Pull Request の体系的レビューでコード品質とアーキテクチャの健全性を確保します。

### 使い方

```bash
# PR の包括的レビュー
gh pr view 123 --comments
「この PR を体系的にレビューしてコード品質、セキュリティ、アーキテクチャの観点からフィードバックしてください」

# セキュリティ特化レビュー
gh pr diff 123
「Railsのセキュリティリスクと脆弱性に焦点を当ててレビューしてください」

# アーキテクチャ観点のレビュー
gh pr checkout 123 && find . -name "*.rb" | head -10
「MVCアーキテクチャ、レイヤー分離、Rails Way の観点からアーキテクチャを評価してください」
```

### 基本例

```bash
# コード品質の数値的評価
find . -name "*.rb" -exec wc -l {} + | sort -rn | head -5
"メソッドの複雑度、クラスサイズ、重複度を評価して改善点を指摘してください"

# セキュリティ脆弱性チェック
grep -r "password\|secret\|token\|api_key" . --include="*.rb" | head -10
"機密情報の漏洩、ハードコーディング、認証バイパスのリスクをチェックしてください"

# Rails規約違反の検出
grep -r "User\.find" . --include="*.rb"
"N+1クエリ、SQL注入、ActiveRecord の不適切な使用を評価してください"

# アーキテクチャ違反の検出
find . -name "*.rb" -exec grep -l "require.*\.\./" {} \;
"MVCの責務分離、循環依存、結合度の問題を評価してください"
```

### コメント分類体系

```
🔴 critical.must: 致命的問題
├─ セキュリティ脆弱性（SQL注入、XSS、CSRF）
├─ データ整合性問題
└─ システム障害リスク

🟡 high.imo: 高優先度改善
├─ 機能不全のリスク
├─ パフォーマンス問題（N+1クエリ）
└─ 保守性の大幅低下

🟢 medium.imo: 中優先度改善
├─ 可読性の向上
├─ Rails規約準拠
└─ テスト品質向上

🟢 low.nits: 軽微な指摘
├─ Rubocopスタイル統一
├─ タイポ修正
└─ コメント追加

🔵 info.q: 質問・情報提供
├─ 実装意図の確認
├─ 設計判断の背景
└─ Rails ベストプラクティスの共有
```

### レビュー観点

#### 1. コード正確性

- **ロジックエラー**: 境界値、nil チェック、例外処理
- **データ整合性**: 型安全性、ActiveRecord バリデーション
- **エラーハンドリング**: rescue の適切な使用、カスタム例外

#### 2. セキュリティ

- **認証・認可**: Devise, CanCan の適切な使用
- **Strong Parameters**: 適切なパラメータ許可
- **SQL インジェクション**: 生SQLの回避、パラメータ化クエリ
- **XSS対策**: HTMLエスケープ、CSRFトークン
- **機密情報**: credentials.yml.enc の使用、ログ出力禁止

#### 3. パフォーマンス

- **N+1クエリ**: includes, joins の適切な使用
- **データベース**: インデックス最適化、重いクエリの回避
- **キャッシュ**: Rails.cache, fragment cache の活用
- **メモリ効率**: 大量データ処理時のfind_each使用

#### 4. Rails アーキテクチャ

- **MVC分離**: Controller の責務、Fat Model 回避
- **Service Object**: 複雑なビジネスロジックの分離
- **ActiveRecord**: 適切な関連定義、scope の活用
- **Rails Way**: 規約に従った実装、gem の適切な使用

#### 5. Ruby コードスタイル

- **メソッド設計**: 単一責任、適切な長さ
- **クラス設計**: SOLID原則、モジュール化
- **例外処理**: 適切なrescue、ensure の使用
- **Rubocop**: スタイルガイド準拠

### レビューフロー

1. **事前確認**: PR 情報、変更差分、関連 Issue、Railsバージョン
2. **体系的チェック**: セキュリティ → 正確性 → パフォーマンス → アーキテクチャ → スタイル
3. **建設的フィードバック**: 具体的な改善案とRuby/Railsコード例
4. **フォローアップ**: 修正確認、RSpec実行、最終承認

### 効果的なコメント例

**セキュリティ問題**

```markdown
**critical.must.** Strong Parameters が不適切です

```ruby
# 現在のコード（危険）
def user_params
  params[:user]
end

# 修正案
def user_params
  params.require(:user).permit(:name, :email, :role)
end
```

Mass Assignment 攻撃を防ぐため、明示的なパラメータ許可が必須です。
```

**N+1クエリ問題**
```markdown
**high.imo.** N+1クエリ問題が発生します

```ruby
# 問題のあるコード
@users.each { |user| user.posts.count }

# 改善案: Eager Loading
@users = User.includes(:posts)
@users.each { |user| user.posts.size }
```

クエリ数を大幅に削減できます。
```

**Rails アーキテクチャ違反**
```markdown
**high.must.** Controllerが肥大化しています

```ruby
# 改善案: Service Object の導入
class UserRegistrationService
  def initialize(user_params)
    @user_params = user_params
  end

  def call
    user = User.new(@user_params)
    if user.save
      UserMailer.welcome_email(user).deliver_later
      # その他の処理...
    end
    user
  end
end

# Controller
def create
  @user = UserRegistrationService.new(user_params).call
  # ...
end
```

ビジネスロジックをServiceオブジェクトに分離してください。
```

**Ruby スタイル問題**
```markdown
**medium.imo.** Rubyらしい書き方ではありません

```ruby
# 現在のコード
if !user.nil? && user.active == true
  # ...
end

# 改善案
if user&.active?
  # ...
end
```

安全なナビゲーション演算子とpredicateメソッドを使用してください。
```

**テスト関連**
```markdown
**medium.imo.** RSpecのテストが不十分です

```ruby
# 追加推奨テスト
describe 'POST #create' do
  context 'with valid parameters' do
    it 'creates a new user' do
      expect {
        post :create, params: { user: valid_attributes }
      }.to change(User, :count).by(1)
    end

    it 'sends welcome email' do
      expect(UserMailer).to receive(:welcome_email)
      post :create, params: { user: valid_attributes }
    end
  end

  context 'with invalid parameters' do
    it 'does not create a user' do
      expect {
        post :create, params: { user: invalid_attributes }
      }.not_to change(User, :count)
    end
  end
end
```

正常系・異常系の両方をテストしてください。
```

**データベース設計**
```markdown
**high.imo.** マイグレーションにインデックスが不足しています

```ruby
# db/migrate/xxx_add_index_to_users.rb
class AddIndexToUsers < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :email, unique: true
    add_index :posts, [:user_id, :created_at]
  end
end
```

検索で使用されるカラムにインデックスを追加してください。
```

### Rails特有のチェックポイント

#### Gemfile & Dependencies
- セキュリティ上問題のあるgemの使用
- 不要なgemの追加
- バージョン固定の妥当性

#### Routes
- RESTful設計への準拠
- ネストが深すぎるroutes
- 不要なroutesの定義

#### Models
- バリデーションの適切性
- 関連（association）の正確性
- scopeの適切な使用
- callbackの乱用

#### Controllers
- before_actionの適切な使用
- 責務の分離
- セキュリティフィルターの確認

#### Views
- HTMLエスケープの確認
- パーシャル化の適切性
- ヘルパーメソッドの使用

### 注意事項

- **Rails Way**: Rails の規約と哲学に準拠した実装を推奨
- **セキュリティ**: Rails特有の脆弱性（CSRF、SQL注入等）に注意
- **パフォーマンス**: ActiveRecordの特性を理解した最適化
- **テスト**: RSpec/Minitestでの適切なテストカバレッジ
- **継続改善**: Rubocop、Brakeman等の静的解析ツールの活用
