## Smart Review

現在の状況を分析し、最適なロール・アプローチを自動提案するコマンド。

### 使い方

```bash
/smart-review                    # 現在のディレクトリを分析
/smart-review <ファイル/ディレクトリ> # 特定対象を分析
```

### 自動判定ロジック

### ファイル拡張子による判定

- `package.json`, `*.tsx`, `*.jsx`, `*.css`, `*.scss` → **frontend**
- `Gemfile`, `*.rb`, `config/routes.rb`, `app/` → **rails** ⭐️ **NEW**
- `Dockerfile`, `docker-compose.yml`, `*.yaml` → **architect**
- `*.test.js`, `*.spec.ts`, `test/`, `__tests__/`, `spec/` → **qa**
- `*.rs`, `Cargo.toml`, `performance/` → **performance**

### Rails特有ファイル検出 ⭐️ **NEW**

- `app/models/`, `app/controllers/`, `app/views/` → **rails**
- `config/routes.rb`, `config/application.rb` → **rails + architect**
- `app/controllers/*_controller.rb` → **rails** (Fat Controller 検出推奨)
- `app/models/*.rb` → **rails** (Fat Model 検出推奨)
- `db/migrate/`, `db/schema.rb` → **rails + architect**
- `config/initializers/`, `config/environments/` → **rails + architect**

### セキュリティ関連ファイル検出

- `auth.js`, `security.yml`, `.env`, `config/auth/` → **security**
- `app/controllers/sessions_controller.rb`, `app/models/user.rb` → **rails + security** ⭐️ **NEW**
- `config/initializers/devise.rb`, `app/controllers/application_controller.rb` → **rails + security** ⭐️ **NEW**
- `login.tsx`, `signup.js`, `jwt.js` → **security + frontend**
- `api/auth/`, `middleware/auth/` → **security + architect**

### Rails特有の複合判定パターン ⭐️ **NEW**

- `app/controllers/` + `large controller files` → **rails + reviewer** (Fat Controller リファクタリング)
- `app/models/` + `complex associations` → **rails + architect** (モデル設計見直し)
- `app/services/`, `app/concerns/` → **rails + architect** (Service Object/Concern 設計)
- `spec/`, `test/` + `*.rb` → **rails + qa** (RSpec/Rails テスト戦略)
- `config/routes.rb` + `RESTful patterns` → **rails + architect** (API 設計)
- `db/migrate/` + `performance concerns` → **rails + performance** (DB 最適化)

### 複合判定パターン

- `mobile/` + `*.swift`, `*.kt`, `react-native/` → **mobile**
- `webpack.config.js`, `vite.config.js`, `large-dataset/` → **performance**
- `components/` + `responsive.css` → **frontend + mobile**
- `api/` + `auth/` → **security + architect**

### Rails特有のエラー・問題分析 ⭐️ **NEW**

- `N+1 query`, `bullet gem output`, `slow queries` → **rails + performance**
- `Strong Parameters error`, `Mass Assignment` → **rails + security**
- `Routing Error`, `ActionController::RoutingError` → **rails + architect**
- `ActiveRecord validation errors` → **rails + reviewer**
- `Rails server crash`, `Puma worker timeout` → **rails + analyzer**

### エラー・問題分析

- スタックトレース、`error.log`, `crash.log` → **analyzer**
- `memory leak`, `high CPU`, `slow query` → **performance + analyzer**
- `SQL injection`, `XSS`, `CSRF` → **security + analyzer**

### 提案パターン

### Rails単一ロール提案 ⭐️ **NEW**

```bash
$ /smart-review app/models/user.rb
→ 「📍 Rails Model を検出しました」
→ 「rails ロールでの分析を推奨します」
→ 「実行しますか？ [y]es / [n]o / [m]ore options」

$ /smart-review app/controllers/users_controller.rb
→ 「🎮 Rails Controller を検出しました」
→ 「Fat Controller チェックを含む rails 分析を推奨します」
→ 「実行しますか？ [y]es / [n]o / [m]ore options」
```

### Rails複数ロール提案 ⭐️ **NEW**

```bash
$ /smart-review app/controllers/sessions_controller.rb
→ 「🔒🚂 Rails 認証コントローラーを検出」
→ 「推奨アプローチ:」
→ 「[1] rails ロール単体 (Rails Way チェック)」
→ 「[2] security ロール単体 (セキュリティ特化)」
→ 「[3] multi-role rails,security (Rails セキュリティ統合)」
→ 「[4] role-debate rails,security (実装方針議論)」

$ /smart-review db/migrate/
→ 「🗄️🚂 Rails マイグレーションを検出」
→ 「推奨アプローチ:」
→ 「[1] rails ロール単体」
→ 「[2] architect ロール単体」
→ 「[3] multi-role rails,architect (DB設計統合)」
→ 「[4] role-debate rails,performance (パフォーマンス考慮)」
```

### 単一ロール提案

```bash
$ /smart-review src/auth/login.js
→ 「認証ファイルを検出しました」
→ 「security ロールでの分析を推奨します」
→ 「実行しますか？ [y]es / [n]o / [m]ore options」
```

### 複数ロール提案

```bash
$ /smart-review src/mobile/components/
→ 「📱🎨 モバイル + フロントエンド要素を検出」
→ 「推奨アプローチ:」
→ 「[1] mobile ロール単体」
→ 「[2] frontend ロール単体」  
→ 「[3] multi-role mobile,frontend」
→ 「[4] role-debate mobile,frontend」
```

### Rails問題分析時の提案 ⭐️ **NEW**

```bash
$ /smart-review rails_error.log
→ 「🚂 Rails エラーログを検出しました」
→ 「Rails特有の問題分析を開始します」
→ 「[自動実行] /role rails」

$ /smart-review "N+1クエリが発生している"
→ 「🐌🚂 Rails パフォーマンス問題を検出」
→ 「推奨: [1]/role rails [2]/multi-role rails,performance [3]/role-debate rails,performance」

$ /smart-review "Strong Parameters エラー"
→ 「🔒🚂 Rails セキュリティ問題を検出」
→ 「推奨: [1]/role rails [2]/multi-role rails,security」
```

### 問題分析時の提案

```bash
$ /smart-review error.log
→ 「⚠️ エラーログを検出しました」
→ 「analyzer ロールで根本原因分析を開始します」
→ 「[自動実行] /role analyzer」

$ /smart-review slow-api.log
→ 「🐌 パフォーマンス問題を検出」
→ 「推奨: [1]/role performance [2]/role-debate performance,analyzer」
```

### Rails設計決定時の提案 ⭐️ **NEW**

```bash
$ /smart-review "Service Object vs Fat Model"
→ 「🏗️🚂 Rails アーキテクチャ設計を検出」
→ 「Rails Way の観点からの議論を推奨します」
→ 「[推奨] /role-debate rails,architect」
→ 「[代替] /multi-role rails,architect」

$ /smart-review "API設計とセキュリティ"
→ 「🔒🚂⚡ Rails API + セキュリティ + パフォーマンス要素検出」
→ 「複雑な設計決定のため、議論形式を推奨します」
→ 「[推奨] /role-debate rails,security,performance」
→ 「[代替] /multi-role rails,security,performance」
```

### 複雑な設計決定時の提案

```bash
$ /smart-review architecture-design.md
→ 「🏗️🔒⚡ アーキテクチャ + セキュリティ + パフォーマンス要素検出」
→ 「複雑な設計決定のため、議論形式を推奨します」
→ 「[推奨] /role-debate architect,security,performance」
→ 「[代替] /multi-role architect,security,performance」
```

### 提案ロジックの詳細

### 優先度判定（Rails対応更新） ⭐️ **UPDATED**

1. **Security** - 認証・認可・暗号化関連は最優先
2. **Rails Security** - Strong Parameters・CSRF・SQLインジェクション対策 ⭐️ **NEW**
3. **Critical Errors** - システム停止・データ損失は緊急
4. **Rails Errors** - Rails特有エラー（ルーティング・ActiveRecord等） ⭐️ **NEW**
5. **Architecture** - 大規模変更・技術選定は慎重検討
6. **Rails Architecture** - MVC分離・Service Object設計 ⭐️ **NEW**
7. **Performance** - ユーザー体験に直結
8. **Rails Performance** - N+1クエリ・DB最適化 ⭐️ **NEW**
9. **Frontend/Mobile** - UI/UX 改善
10. **QA** - 品質保証・テスト関連

### Rails特有の議論推奨条件 ⭐️ **NEW**

- Rails Way vs 他のアプローチのトレードオフがある場合
- ActiveRecord vs SQL のパフォーマンス議論が必要な場合
- Controller vs Service Object の責務分離が必要な場合
- Rails セキュリティ vs 開発効率のバランスが必要な場合
- Rails API vs GraphQL の技術選定が含まれる場合

### 議論推奨条件

- 3 つ以上のロールが関連する場合
- セキュリティ vs パフォーマンスのトレードオフがある場合
- アーキテクチャの大幅変更が含まれる場合
- モバイル + Web の両方に影響がある場合

### 基本例

```bash
# 現在のディレクトリを分析（Rails対応）
/smart-review
「最適なロールとアプローチを提案して」

# Rails特定ファイルを分析
/smart-review app/models/user.rb
「このRailsモデルに最適なレビュー方法を提案して」

# Rails エラーログを分析
/smart-review rails_server.log
「このRailsエラーの解決に最適なアプローチを提案して」
```

### 実際例

### Rails プロジェクト全体の分析 ⭐️ **NEW**

```bash
$ /smart-review
→ 「📊 プロジェクト分析中...」
→ 「🚂 Ruby on Rails プロジェクトを検出」
→ 「MVC構造 + 認証機能 + API + テストを確認」
→ 「」
→ 「💡 推奨ワークフロー:」
→ 「1. rails で全体的なRails Way チェック」
→ 「2. security で認証・セキュリティ評価」
→ 「3. performance で N+1クエリ・DB最適化確認」
→ 「4. qa で RSpec テスト戦略レビュー」
→ 「」
→ 「自動実行しますか？ [y]es / [s]elect role / [c]ustom」

$ /smart-review app/
→ 「🚂 Rails app ディレクトリを検出」
→ 「Fat Controller (150+ lines): 3 files」
→ 「Fat Model (200+ lines): 2 files」
→ 「N+1 query 可能性: app/controllers/users_controller.rb」
→ 「」
→ 「優先対応推奨:」
→ 「[1] /role rails (Fat Controller/Model リファクタリング)」
→ 「[2] /multi-role rails,performance (N+1クエリ最適化)」
→ 「[3] /role-debate rails,architect (Service Object 導入議論)」
```

### プロジェクト全体の分析

```bash
$ /smart-review
→ 「📊 プロジェクト分析中...」
→ 「React + TypeScript プロジェクトを検出」
→ 「認証機能 + API + モバイル対応を確認」
→ 「」
→ 「💡 推奨ワークフロー:」
→ 「1. security で認証系チェック」
→ 「2. frontend で UI/UX 評価」
→ 「3. mobile でモバイル最適化確認」
→ 「4. architect で全体設計レビュー」
→ 「」
→ 「自動実行しますか？ [y]es / [s]elect role / [c]ustom」
```

### Rails特定問題の分析 ⭐️ **NEW**

```bash
$ /smart-review "Active Record の関連をどう最適化すべきか"
→ 「🤔🚂 Rails ActiveRecord 設計判断を検出」
→ 「複数の専門観点が必要な問題です」
→ 「」
→ 「推奨アプローチ:」
→ 「/role-debate rails,performance,architect」
→ 「理由: Rails Way・パフォーマンス・アーキテクチャのバランスが重要」

$ /smart-review "Strong Parameters vs フレキシブルなAPI"
→ 「🔒🚂 Rails セキュリティ vs 柔軟性のトレードオフを検出」
→ 「」
→ 「推奨アプローチ:」
→ 「/role-debate rails,security,frontend」
→ 「理由: Rails規約・セキュリティ・API使いやすさの議論が必要」
```

### 特定問題の分析

```bash
$ /smart-review "JWT の有効期限をどう設定すべきか"
→ 「🤔 技術的な設計判断を検出」
→ 「複数の専門観点が必要な問題です」
→ 「」
→ 「推奨アプローチ:」
→ 「/role-debate security,performance,frontend」
→ 「理由: セキュリティ・パフォーマンス・ UX のバランスが重要」
```

### Claude との連携

```bash
# Rails ファイル内容と組み合わせた分析
cat app/models/user.rb
/smart-review
「このRailsモデルの内容を含めてRails Way観点で分析して」

# Rails エラーと組み合わせた分析
rails server 2>&1 | tee rails-error.log
/smart-review rails-error.log
「Rails サーバーエラーの解決方法を提案して」

# Rails 設計相談
/smart-review
「Service Object と Concern のどちらを使うべきか Rails Way の観点で議論して」

# ファイル内容と組み合わせた分析
cat src/auth/middleware.js
/smart-review
「このファイルの内容を含めてセキュリティ観点で分析して」

# エラーと組み合わせた分析
npm run build 2>&1 | tee build-error.log
/smart-review build-error.log
「ビルドエラーの解決方法を提案して」

# 設計相談
/smart-review
「React Native と Progressive Web App のどちらを選ぶべきか議論して」
```

### Rails特有の判定例 ⭐️ **NEW**

```bash
# Rails Model 分析
$ /smart-review app/models/
→ rails ロール推奨 (Fat Model 検出・ActiveRecord最適化)

# Rails Controller 分析  
$ /smart-review app/controllers/
→ rails + reviewer (Fat Controller リファクタリング)

# Rails 認証分析
$ /smart-review app/controllers/sessions_controller.rb
→ rails + security (Rails認証ベストプラクティス)

# Rails Migration 分析
$ /smart-review db/migrate/
→ rails + architect + performance (DB設計・インデックス最適化)

# Rails Routes 分析
$ /smart-review config/routes.rb  
→ rails + architect (RESTful API設計)

# Rails Test 分析
$ /smart-review spec/
→ rails + qa (RSpec・Rails特有テスト戦略)

# Rails Service 分析
$ /smart-review app/services/
→ rails + architect (Service Object設計パターン)

# Rails Performance 分析
$ /smart-review "N+1 query detected"
→ rails + performance (ActiveRecord最適化)

# Rails Security 分析
$ /smart-review "Strong Parameters bypass"
→ rails + security (Rails セキュリティ対策)
```

### 注意事項

- 提案は参考情報です。最終的な判断はユーザーが行ってください
- **Rails プロジェクト**: Rails Way を重視した分析を優先推奨 ⭐️ **NEW**
- 複雑な問題ほど議論形式（role-debate）を推奨します
- 単純な問題は single role で十分な場合が多いです
- セキュリティ関連は必ず専門ロールでの確認を推奨します
- **Rails 特有の問題**: rails ロール単体または他ロールとの組み合わせが効果的 ⭐️ **NEW**
