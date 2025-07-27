#!/bin/bash
# トリガーベースのコメントチェック（Rails/Ruby用）

input="$CLAUDE_TOOL_INPUT"
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')
[ -z "$file_path" ] || [ ! -f "$file_path" ] && exit 0

# ファイル拡張子を取得
extension="${file_path##*.}"

# Ruby/Railsファイルかチェック
is_ruby_file() {
  case "$extension" in
    rb|rake|gemspec) return 0 ;;
    *) return 1 ;;
  esac
}

# ファイルタイプに応じたメッセージを生成
get_documentation_message() {
  local tool_type="$1"
  
  if is_ruby_file; then
    case "$tool_type" in
      "Write")
        echo "新規Rubyファイルを作成しました。以下のドキュメント追加を検討してください：
• YARDコメント（@param、@return、@example等）
• クラス・モジュールの概要説明
• メソッドの説明とサンプルコード"
        ;;
      "MultiEdit")
        echo "複数の編集を行いました。以下のドキュメント更新が必要か確認してください：
• YARDコメントの更新
• APIドキュメントとの同期
• サンプルコードの修正"
        ;;
    esac
  else
    # 汎用的なメッセージ
    case "$tool_type" in
      "Write")
        echo "新規ファイルを作成しました。適切なドキュメント（コメント、説明）の追加を検討してください。"
        ;;
      "MultiEdit")
        echo "複数の編集を行いました。変更に合わせてドキュメントの更新が必要か確認してください。"
        ;;
    esac
  fi
}

# 新規ファイル作成時のチェック
if echo "$input" | jq -e '.tool == "Write"' >/dev/null; then
  message=$(get_documentation_message "Write")
  jq -n --arg msg "$message" '{decision: "block", reason: $msg}'
fi

# 大幅な編集時（MultiEdit 使用時）のチェック
if echo "$input" | jq -e '.tool == "MultiEdit"' >/dev/null; then
  message=$(get_documentation_message "MultiEdit")
  jq -n --arg msg "$message" '{decision: "block", reason: $msg}'
fi
