#!/bin/bash
set -e

# 1. .env 파일 경로 받기 (없으면 기본값: ./app.env)
ENV_FILE=${1:-./app.env}

if [ ! -f "$ENV_FILE" ]; then
  echo "❌ Env file not found: $ENV_FILE"
  echo "Usage: ./setup.sh [path-to-env-file]"
  exit 1
fi

# 2. .env 파일 읽어서 환경변수로 설정
export $(grep -v '^#' "$ENV_FILE" | xargs)

# 3. 변수 확인
echo "🚀 Setting up project..."
echo " -> APP_TYPE=$APP_TYPE"
echo " -> APP_NAME=$APP_NAME"
echo " -> BUNDLE_ID=$BUNDLE_ID"

# 4. 경로 변수 정의
SRC_DIR="Targets/TuistTemplate/Sources"
TEMPLATE_DIR="$SRC_DIR/template/HomeMainViewController"
TARGET_FILE="$SRC_DIR/HomeMainViewController.swift"

# 5. 타입에 맞는 HomeMainViewController 선택
if [ "$APP_TYPE" == "webview" ]; then
  cp "$TEMPLATE_DIR/HomeMainViewController+WebView.swift" "$TARGET_FILE"
elif [ "$APP_TYPE" == "native" ]; then
  cp "$TEMPLATE_DIR/HomeMainViewController+Native.swift" "$TARGET_FILE"
else
  echo "❌ Unknown APP_TYPE: $APP_TYPE"
  exit 1
fi

# 6. 불필요한 파일 및 템플릿 디렉토리 삭제
rm -rf "$TEMPLATE_DIR"

# $1 is project name 
sed -i '' "s/TuistTemplate/APP_NAME/g" Sources/*.swift
sed -i '' "s/TuistTemplate/APP_NAME/g" Sources/*/*.swift

echo "✅ Setup completed for $APP_NAME"
