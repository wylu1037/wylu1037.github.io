#!/bin/bash

# 获取用户输入的提交消息
commit_message="$1"

# 如果用户没有提供提交消息，则提示用户输入
if [ -z "$commit_message" ]; then
    read -p "请输入提交消息: " commit_message
fi

# 添加所有文件并提交到本地仓库
git add .
git commit -m "$commit_message"

# 推送代码到 GitHub
if git push origin main; then 
    echo "🎉 代码推送完成"
else
    echo "❌ 推送失败，请检查错误信息"
fi

# 推送代码到 GitLab
# git push gitlab main
