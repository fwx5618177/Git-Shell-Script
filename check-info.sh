#!/bin/bash

###############################################
# File Name: check-info.sh
# Author: Hyou
# Created Time: 2019-08-15 16:00:00
# Description:
#   1. 查看日志中的某个人的提交记录
#   2. 修改log里提交记录的人名和邮箱
# Usage:
#   - sh check-info.sh <旧作者名字> <新作者名字> <新作者邮箱>
###############################################

# 从命令行参数获取旧作者和新作者的信息
old_author="$1"
new_author_name="$2"
new_author_email="$3"

# 检查参数是否提供完整
if [ -z "$old_author" ] || [ -z "$new_author_name" ] || [ -z "$new_author_email" ]; then
  echo "用法: ./check-info.sh <旧作者名字> <新作者名字> <新作者邮箱>"
  exit 1
fi

# 查找所有匹配的提交
matching_commits=$(git log --author="$old_author" --format="%H")

# 循环遍历每个匹配的提交并修改
for commit in $matching_commits
do
  git rebase -i $commit~1
  sed -i "s/^\(pick\|edit\) \(.*\)$/\1 $commit/" $(git rev-parse --git-dir)/rebase-*
  git commit --amend --author="$new_author_name <$new_author_email>"
  git rebase --continue
done

# 推送修改后的提交(慎重)
# git push --force

