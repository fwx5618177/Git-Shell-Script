#!/bin/bash

###############################################
# File Name: check-branch-source.sh
# Author: Hyou
# Created Time: 2019-08-15 16:00:00
# Description:
#   1. 检查当前分支是否是从允许的基础分支中创建的
#   2. 指定允许的基础分支列表
# Usage:
#   - sh check-branch-source.sh
###############################################

# 定义允许的父分支列表
allowed_parent_branches=("pre" "online")

# 设置颜色代码
green='\033[0;32m' # 绿色背景
red='\033[0;41m'   # 红色背景
reset='\033[0m'    # 重置颜色

# 获取当前分支的名字
current_branch=$(git branch --show-current)

# 获取当前分支的来源信息
origin_info=$(git reflog show --pretty=format:"%gd %gs" "$current_branch" | grep "Created")

echo "分支 '$current_branch' 的来源信息: $origin_info"

# 获取当前分支的来源分支名称
origin_branch=$(echo "$origin_info" | awk '{print $5}')

echo "分支 '$current_branch' 的来源分支: $origin_branch"

# 检查当前分支是否是从允许的父分支中的一个创建的
if [[ " ${allowed_parent_branches[@]} " =~ " ${origin_branch} " ]]; then
  echo "${green}当前分支 ($current_branch) 是从 $origin_branch 创建的。${reset}"
else
  echo "${red}当前分支 ($current_branch) 不是从允许的父分支中的一个创建的，而是: $origin_branch 。${reset}"
  exit 1
fi

# 显示分支图
# git log --oneline --decorate --graph --all
