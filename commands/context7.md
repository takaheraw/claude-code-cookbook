## Context7

技術ドキュメントを MCP の Context7 で検索します。

### 使い方

```bash
# Claude に依頼する形式
「context7 で [検索キーワード] について検索して」
```

### 基本例

```bash
# Rails の機能調査
「context7 で Rails Active Record について検索して」

# Ruby エラー解決方法の検索
「context7 で Ruby の NoMethodError について調べて」

# Gem の使い方調査
「context7 で Devise の設定方法について検索して」
```

### Ruby/Rails 固有の検索例

#### 1. Rails コア機能

```bash
# Active Record の詳細調査
「context7 で Active Record アソシエーションについて検索して」

# Action Controller の使い方
「context7 で Rails コントローラーのベストプラクティスを調べて」

# Active Job の実装方法
「context7 で Rails バックグラウンドジョブについて検索して」

# Rails ルーティングの詳細
「context7 で Rails routing の複雑な設定について調べて」
```

#### 2. Ruby 言語機能

```bash
# Ruby のメタプログラミング
「context7 で Ruby メタプログラミングについて検索して」

# Ruby の並行性
「context7 で Ruby Fiber と Thread の違いについて調べて」

# Ruby のパフォーマンス
「context7 で Ruby メモリ最適化について検索して」
```

#### 3. よく使用される Gem

```bash
# 認証 Gem
「context7 で Devise の高度な設定について検索して」

# API 開発
「context7 で Grape API framework について調べて」

# テストフレームワーク
「context7 で RSpec の書き方とベストプラクティスを検索して」

# バックグラウンドジョブ
「context7 で Sidekiq の設定とモニタリングについて調べて」
```

### Claude との連携

#### 1. Rails 開発での技術調査

```bash
# Rails アーキテクチャの理解
「context7 で Rails MVC アーキテクチャについて調べて、初心者向けに解説して」

# パフォーマンス最適化
「context7 で Rails パフォーマンス最適化のベストプラクティスを探して」

# セキュリティ対策
「context7 で Rails セキュリティガイドラインについて検索して、重要なポイントを説明して」
```

#### 2. Ruby プログラミングの深掘り

```bash
# Ruby の設計思想
「context7 で Ruby の設計哲学と Matz の思想について調べて」

# Ruby 3.x の新機能
「context7 で Ruby 3 の新機能について検索して、実用例とともに説明して」

# Ruby のメモリ管理
「context7 で Ruby ガベージコレクションについて調べて、パフォーマンスへの影響を説明して」
```

#### 3. エラー解決とデバッグ

```bash
# 一般的なエラーの解決
「context7 で Rails の一般的なエラーと解決方法について検索して」

# デバッグ手法
「context7 で Ruby デバッグツールの使い方について調べて」

# パフォーマンス問題
「context7 で Rails N+1 問題の検出と解決について検索して」
```

### 詳細例

#### 1. Rails 特定機能の深掘り

```bash
# Active Record の高度な使い方
「context7 で Active Record について以下の観点で調べて：
1. 複雑なクエリの書き方とパフォーマンス
2. カスタムバリデーションの実装方法
3. コールバックの適切な使用方法
4. スコープと関連付けの最適化」

# Rails API 開発
「context7 で Rails API 開発について以下を調査して：
1. API only モードの設定と利点
2. JSON シリアライゼーションのベストプラクティス
3. 認証・認可の実装パターン
4. バージョニング戦略」
```

#### 2. Ruby 言語仕様の理解

```bash
# Ruby のオブジェクト指向
「context7 で Ruby のオブジェクト指向について調べて：
1. クラス、モジュール、ミックスインの使い分け
2. 継承と委譲のパターン
3. プライベートメソッドとアクセス制御
4. メタクラスと特異メソッド」

# Ruby の関数型プログラミング
「context7 で Ruby の関数型プログラミング要素について検索して：
1. ブロック、Proc、Lambda の違い
2. 高階関数の実装パターン
3. イミュータブルデータ構造の作り方」
```

#### 3. Rails エコシステム

```bash
# Rails の周辺技術
「context7 で Rails エコシステムについて調査して：
1. 主要な Gem とその用途
2. フロントエンド統合の方法（Stimulus、Hotwire）
3. デプロイメント戦略（Docker、Heroku、AWS）
4. モニタリングとログ管理」

# Rails のテスト戦略
「context7 で Rails テスティングについて検索して：
1. RSpec vs Minitest の比較
2. FactoryBot の効果的な使い方
3. 統合テストとシステムテストの書き方
4. テストデータベースの管理」
```

### Rails 開発でよくある検索パターン

#### 1. 機能実装の調査

```bash
# 認証システム
「context7 で Rails 認証システムの実装について調べて」

# ファイルアップロード
「context7 で Active Storage の使い方について検索して」

# リアルタイム機能
「context7 で Action Cable WebSocket の実装について調べて」

# 国際化対応
「context7 で Rails i18n の設定と使い方について検索して」
```

#### 2. パフォーマンス改善

```bash
# データベース最適化
「context7 で Rails データベース最適化について調べて」

# キャッシュ戦略
「context7 で Rails キャッシング戦略について検索して」

# バックグラウンド処理
「context7 で Rails バックグラウンドジョブの最適化について調べて」
```

#### 3. セキュリティとベストプラクティス

```bash
# セキュリティ対策
「context7 で Rails セキュリティベストプラクティスについて検索して」

# コード品質
「context7 で Rails コード品質向上の方法について調べて」

# アーキテクチャパターン
「context7 で Rails Clean Architecture の実装について検索して」
```

### Gem 固有の検索例

#### 1. 認証・認可

```bash
「context7 で Devise のカスタマイズ方法について調べて」
「context7 で CanCanCan の権限管理について検索して」
「context7 で Pundit ポリシーの書き方について調べて」
```

#### 2. API 開発

```bash
「context7 で Grape API の実装パターンについて検索して」
「context7 で fast_jsonapi の使い方について調べて」
「context7 で GraphQL Ruby の実装について検索して」
```

#### 3. フロントエンド統合

```bash
「context7 で Stimulus の使い方について調べて」
「context7 で Hotwire Turbo の実装について検索して」
「context7 で ViewComponent の活用方法について調べて」
```

#### 4. データベース・ORM

```bash
「context7 で Sequel ORM の使い方について検索して」
「context7 で ROM Ruby の実装パターンについて調べて」
「context7 で Active Record の代替 ORM について検索して」
```

### 特定バージョンでの調査

```bash
# Rails 7 の新機能
「context7 で Rails 7 の新機能について検索して、Import Maps の使い方を中心に説明して」

# Ruby 3.x の機能
「context7 で Ruby 3.2 の新機能について調べて、パターンマッチングの実用例を示して」

# レガシーバージョンの対応
「context7 で Rails 6 から Rails 7 へのアップグレードについて検索して」
```

### デプロイ・運用の調査

```bash
# デプロイメント
「context7 で Rails アプリケーションのデプロイについて調べて：
1. Heroku での Rails デプロイ
2. AWS での Rails 運用
3. Docker を使った Rails コンテナ化
4. CI/CD パイプラインの構築」

# 監視・パフォーマンス
「context7 で Rails 本番環境の監視について検索して：
1. APM ツールの活用
2. ログ管理のベストプラクティス
3. エラー追跡の実装
4. パフォーマンス測定方法」
```

### 注意事項

Context7 で情報が見つからない場合は、Claude が自動的に Web 検索など他の方法を提案します。Ruby/Rails に特化した情報源として以下も活用されます：

- Ruby 公式ドキュメント
- Rails ガイド
- RubyGems ドキュメント
- Rails API ドキュメント
- Ruby コミュニティの技術記事

### 検索のコツ

1. **具体的なキーワード**: 「Rails Active Record belongs_to」など具体的に
2. **バージョン指定**: 「Rails 7」「Ruby 3.2」など必要に応じてバージョンを明記
3. **用途の明確化**: 「本番環境での」「テスト時の」など文脈を含める
4. **問題の詳細**: エラーメッセージや状況を具体的に記載
