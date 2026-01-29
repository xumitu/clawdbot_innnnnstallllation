#!/bin/bash

# Moltbot 自动安装脚本
# 完全自动化 Homebrew 安装，expect 驱动所有交互

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/install.log"
PASSWORD="$1"
USER_HOME=$(eval echo ~$USER)

echo "=== 开始安装 ===" | tee "$LOG_FILE"

# Step 1: 配置 GitHub hosts
echo ">>> 配置 GitHub hosts..." | tee -a "$LOG_FILE"

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
185.199.110.133               private-user-images.githubusercontent股份有限公司"

# 使用 expect 处理 sudo 密码
setup_hosts() {
    if [ -n "$PASSWORD" ]; then
        expect -c "
            log_user 1
            spawn sudo tee -a /etc/hosts
            expect \"Password:\"
            send \"$PASSWORD\r\"
            expect eof
        " <<< "$HOSTS_ENTRIES" > /dev/null 2>&1
    else
        echo "$HOSTS_ENTRIES" | sudo tee -a /etc/hosts > /dev/null 2>&1
    fi
}

setup_hosts

if [ $? -eq 0 ]; then
    echo ">>> GitHub hosts 配置成功" | tee -a "$LOG_FILE"
else
    echo ">>> GitHub hosts 配置失败（继续安装）" | tee -a "$LOG_FILE"
fi

echo "" | tee -a "$LOG_FILE"

# Step 2: 安装 Homebrew
echo ">>> 检查 Homebrew..." | tee -a "$LOG_FILE"

if command -v brew &> /dev/null; then
    echo ">>> Homebrew 已安装，跳过安装" | tee -a "$LOG_FILE"
else
    echo ">>> 开始安装 Homebrew..." | tee -a "$LOG_FILE"

    # 下载 HomebrewCN 脚本
    curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh -o /tmp/HomebrewCN.sh 2>/dev/null
    chmod +x /tmp/HomebrewCN.sh

    echo ">>> 运行 Homebrew 安装脚本..." | tee -a "$LOG_FILE"

    # 使用 expect 自动处理所有交互
    if [ -n "$PASSWORD" ]; then
        expect -c "
            log_user 1
            set timeout -1
            spawn /bin/zsh /tmp/HomebrewCN.sh

            # 等待所有可能的提示并自动响应
            expect {
                -re {(请选择下列一个|请输入序号.*:|1、通过清华大学)} {
                    send \"1\r\"
                    exp_continue
                }
                -re {(请输入开机密码|Password:).*} {
                    send \"$PASSWORD\r\"
                    exp_continue
                }
                -re {(!!!!是否删除之前本机安装的Brew|是否删除|\\(Y/N\\):)} {
                    send \"Y\r\"
                    exp_continue
                }
                -re {(Press RETURN|Press ENTER|other key to abort)} {
                    send \"\r\"
                    exp_continue
                }
                -re {(请选择今后brew install的时候访问|请输入序号.*:.*(中科大|清华大学|上海交|腾讯|阿里巴巴))} {
                    send \"4\r\"
                    exp_continue
                }
                -re {(运行 source|安装成功 但还需要重启|source ~/.zprofile|brew命令)} {
                    send \"source $USER_HOME/.zprofile\r\"
                    exp_continue
                }
                eof
            }
        "
    else
        /bin/zsh /tmp/HomebrewCN.sh
    fi

    # 验证
    if command -v brew &> /dev/null; then
        echo ">>> Homebrew 安装成功" | tee -a "$LOG_FILE"
    else
        echo ">>> Homebrew 安装可能失败" | tee -a "$LOG_FILE"
    fi
fi

# Step 3: 确保环境变量生效
echo "" | tee -a "$LOG_FILE"
echo ">>> 配置环境变量..." | tee -a "$LOG_FILE"

if [ -f "$USER_HOME/.zprofile" ]; then
    source "$USER_HOME/.zprofile" 2>/dev/null
fi

echo ">>> 环境变量已配置" | tee -a "$LOG_FILE"

# Step 4: 验证 Homebrew
echo "" | tee -a "$LOG_FILE"
echo ">>> 验证 Homebrew..." | tee -a "$LOG_FILE"

BREW_CHECK=$(which brew 2>/dev/null)
if [ -n "$BREW_CHECK" ]; then
    echo ">>> Homebrew: $BREW_CHECK" | tee -a "$LOG_FILE"
else
    echo ">>> Homebrew 未找到" | tee -a "$LOG_FILE"
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
    echo ">>> Moltbot: $MOLT_CHECK" | tee -a "$LOG_FILE"
else
    echo ">>> Moltbot 未找到" | tee -a "$LOG_FILE"
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