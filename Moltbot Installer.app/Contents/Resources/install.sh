#!/bin/bash

# Moltbot 自动安装脚本
# 简化版，输出清晰的状态信息供 GUI 解析

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/install.log"
PASSWORD="$1"
USER_HOME=$(eval echo ~$USER)

echo "=== 开始安装 ===" | tee "$LOG_FILE"

# Step 1: 配置 GitHub hosts
echo ">>> 配置 GitHub hosts..." | tee -a "$LOG_FILE"
echo ">>> 配置 GitHub hosts..." 

HOSTS_ENTRIES="
# GitHub hosts - $(date)
140.82.114.25                 alive.github.com
20.205.243.168                api.github.com
140.82.113.22                 api.individual.githubcopilot.com
185.199.110.133               avatars.githubusercontent.com
185.199.110.133               avatars0.githubusercontent.com
185.199.110.133               avatars1.githubusercontent.com
185.199.110.133               avatars2.githubusercontent.com
185.199.110.133               avatars3.githubusercontent.com
185.199.110.133               avatars4.githubusercontent.com
185.199.110.133               avatars5.githubusercontent.com
185.199.110.133               camo.githubusercontent.com
140.82.114.22                 central.github.com
185.199.110.133               cloud.githubusercontent.com
20.205.243.165                codeload.github.com
140.82.113.21                 collector.github.com
185.199.110.133               desktop.githubusercontent.com
185.199.110.133               favicons.githubusercontent.com
20.205.243.166                gist.github.com
16.15.199.187                 github-cloud.s3.amazonaws.com
16.182.108.105                github-com.s3.amazonaws.com
52.216.210.201                github-production-release-asset-2e65be.s3.amazonaws.com
3.5.25.166                    github-production-repository-file-5c1aeb.s3.amazonaws.com
16.15.223.55                  github-production-user-asset-6210df.s3.amazonaws.com
192.0.66.2                    github.blog
20.205.243.166                github.com
140.82.114.17                 github.community
185.199.108.154               github.githubassets.com
151.101.193.194               github.global.ssl.fastly.net
185.199.109.153               github.io
185.199.110.133               github.map.fastly.net
185.199.109.153               githubstatus.com
140.82.114.25                 live.github.com
185.199.110.133               media.githubusercontent.com
185.199.110.133               objects.githubusercontent.com
13.107.42.16                  pipelines.actions.githubusercontent.com
185.199.110.133               raw.githubusercontent.com
185.199.110.133               user-images.githubusercontent.com
140.82.113.21                 education.github.com
185.199.110.133               private-user-images.githubusercontent.com"

echo "$HOSTS_ENTRIES" | sudo tee -a /etc/hosts > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo ">>> GitHub hosts 配置成功"
else
    echo ">>> GitHub hosts 配置失败（继续安装）"
fi

echo "" | tee -a "$LOG_FILE"
echo ">>> 等待输入密码..." | tee -a "$LOG_FILE"

# Step 2: 安装 Homebrew
echo "" | tee -a "$LOG_FILE"
echo ">>> 检查 Homebrew..." | tee -a "$LOG_FILE"

if command -v brew &> /dev/null; then
    echo ">>> Homebrew 已安装，跳过安装"
else
    echo ">>> 开始安装 Homebrew..." | tee -a "$LOG_FILE"
    
    # 下载脚本
    curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh -o /tmp/HomebrewCN.sh 2>/dev/null
    
    echo ">>> 安装脚本已下载，启动安装..."
    echo ">>> 请在终端中完成以下步骤："
    echo ">>> 1. 输入 1 选择清华大学"
    echo ">>> 2. 输入密码"
    echo ">>> 3. 输入 Y"
    echo ">>> 4. 按回车"
    echo ">>> 5. 输入 4 选择腾讯源"
    
    # 运行安装脚本
    /bin/zsh /tmp/HomebrewCN.sh
    
    # 验证
    if command -v brew &> /dev/null; then
        echo ">>> Homebrew 安装成功"
    else
        echo ">>> Homebrew 安装可能失败"
    fi
fi

# Step 3: 配置环境变量
echo "" | tee -a "$LOG_FILE"
echo ">>> 配置环境变量..." | tee -a "$LOG_FILE"

USER_ZPROFILE="$USER_HOME/.zprofile"

if [ -f "$USER_ZPROFILE" ]; then
    if ! grep -q "HOMEBREW_BREW_GIT_REMOTE" "$USER_ZPROFILE" 2>/dev/null; then
        {
            echo ""
            echo "# Set non-default Git remotes for Homebrew/brew and Homebrew/homebrew-core."
            echo 'export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"'
            echo 'export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"'
        } >> "$USER_ZPROFILE"
    fi
    source "$USER_ZPROFILE" 2>/dev/null
else
    {
        echo "# Set non-default Git remotes for Homebrew/brew and Homebrew/homebrew-core."
        echo 'export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"'
        echo 'export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"'
    } > "$USER_ZPROFILE"
    source "$USER_ZPROFILE" 2>/dev/null
fi

echo ">>> 环境变量已配置"

# Step 4: 验证 Homebrew
echo "" | tee -a "$LOG_FILE"
echo ">>> 验证 Homebrew..." | tee -a "$LOG_FILE"

BREW_CHECK=$(which brew 2>/dev/null)
if [ -n "$BREW_CHECK" ]; then
    echo ">>> Homebrew: $BREW_CHECK"
else
    echo ">>> Homebrew 未找到"
fi

# Step 5: 安装 Moltbot
echo "" | tee -a "$LOG_FILE"
echo ">>> 开始安装 Moltbot..." | tee -a "$LOG_FILE"

curl -fsSL https://molt.bot/install.sh | /bin/bash

# Step 6: 验证 Moltbot
echo "" | tee -a "$LOG_FILE"
echo ">>> 验证 Moltbot..." | tee -a "$LOG_FILE"

MOLT_CHECK=$(which molt 2>/dev/null || which moltbot 2>/dev/null)
if [ -n "$MOLT_CHECK" ]; then
    echo ">>> Moltbot: $MOLT_CHECK"
else
    echo ">>> Moltbot 未找到"
fi

# 最终验证
echo "" | tee -a "$LOG_FILE"
echo "=== 最终验证 ===" | tee -a "$LOG_FILE"
echo "Homebrew: $(which brew 2>/dev/null || echo '未安装')" | tee -a "$LOG_FILE"
echo "Moltbot: $(which molt 2>/dev/null || which moltbot 2>/dev/null || echo '未安装')" | tee -a "$LOG_FILE"
echo "===================" | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "=== 安装完成 ===" | tee -a "$LOG_FILE"

exit 0