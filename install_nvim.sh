#!/bin/bash

# 遇到错误立即停止脚本执行
set -e

# 定义颜色变量
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # 恢复默认颜色

echo -e "${BLUE}========================================================${NC}"
echo -e "${GREEN}  🚀 开始为 WSL 准备 Neovim (LazyVim) 完美运行环境${NC}"
echo -e "${BLUE}========================================================${NC}"

# 确保 ~/.local/bin 目录存在 (存放 win32yank 和 fd 软链接)
mkdir -p ~/.local/bin

# 1. 更新系统软件包列表
echo -e "\n🔄 ${YELLOW}[1/8] 更新系统软件包源...${NC}"
sudo apt update -y

# 2. 安装基础工具与 C 编译器 (Treesitter 需要)
echo -e "\n📦 ${YELLOW}[2/8] 安装基础依赖 (Git, GCC, Make, Unzip 等)...${NC}"
# [🌟 本次修改]: 在这里加入了 lua5.1，消除 checkhealth 中 lazy 提示的警告
sudo apt install -y curl wget git unzip tar build-essential lua5.1

# 3. 安装 Telescope 搜索依赖与 WSL 专属剪贴板 (win32yank)
echo -e "\n🔍 ${YELLOW}[3/8] 安装 ripgrep, fd, fzf, sqlite3 并配置 win32yank...${NC}"
# [🌟 本次修改]: 在这里加入了 fzf, sqlite3, libsqlite3-dev，消除搜索和 frecency 警告
sudo apt install -y ripgrep fd-find fzf sqlite3 libsqlite3-dev
# Ubuntu 的 fd 叫 fdfind，做一个软链接让 Neovim 能直接调用 `fd`
ln -sf /usr/bin/fdfind ~/.local/bin/fd

# 下载 win32yank.exe (WSL1/2 通用跨系统剪贴板神器)
echo "   -> 正在下载 win32yank.exe..."
cd /tmp
curl -LO https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip
# 解压并覆盖放入 ~/.local/bin 目录
unzip -o win32yank-x64.zip win32yank.exe -d ~/.local/bin/
chmod +x ~/.local/bin/win32yank.exe

# 4. 安装 Python 环境
echo -e "\n🐍 ${YELLOW}[4/8] 安装 Python3, venv 及 Neovim Python 接口...${NC}"
sudo apt install -y python3 python3-pip python3-venv python3-pynvim
# [🌟 本次修改]: 增加 pip 升级命令，确保 pynvim 是最新版，消除 Python Provider 警告
python3 -m pip install --user --upgrade pynvim

# 5. 安装较新版本的 Node.js (LSP 和 Copilot 需要)
echo -e "\n🟢 ${YELLOW}[5/8] 安装 Node.js 20.x (LTS 版本)...${NC}"
sudo apt remove -y nodejs npm || true
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
# 注意: NodeSource 的 nodejs 包已经包含了 npm，不需要再额外 apt install npm
sudo apt install -y nodejs

# 6. 安装稳定版 tree-sitter-cli 与 Neovim Node 接口
echo -e "\n🌳 ${YELLOW}[6/8] 全局安装 tree-sitter-cli 和 Neovim Node 接口...${NC}"
# 锁定 v0.22.6 版本，完美避开最新版在旧系统上的 GLIBC_2.39 报错问题
#sudo npm install -g tree-sitter-cli@latest
sudo npm install -g tree-sitter-cli@0.22.6
sudo npm install -g neovim

# 7. 安装最新稳定版 Neovim
echo -e "\n📝 ${YELLOW}[7/8] 下载并安装最新稳定版 Neovim...${NC}"
cd /tmp
# 删除可能残留的错误下载文件
rm -f nvim-linux*.tar.gz
# 使用官方 stable 版本的正确路径
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz

# 清理旧版目录并解压
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
# 创建系统全局命令
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

# 8. 安装 LazyVim 官方模板
echo -e "\n💤 ${YELLOW}[8/8] 开始安装 LazyVim...${NC}"
# 备份旧的配置和缓存数据（防止冲突）
echo "   -> 正在备份旧配置和缓存 (如果有的话)..."
mv ~/.config/nvim ~/.config/nvim.bak_$(date +%s) 2>/dev/null || true
mv ~/.local/share/nvim ~/.local/share/nvim.bak_$(date +%s) 2>/dev/null || true
mv ~/.local/state/nvim ~/.local/state/nvim.bak_$(date +%s) 2>/dev/null || true
mv ~/.cache/nvim ~/.cache/nvim.bak_$(date +%s) 2>/dev/null || true

# 克隆官方 Starter 模板
echo "   -> 正在从 GitHub 克隆 LazyVim Starter..."
git clone https://github.com/LazyVim/starter ~/.config/nvim
# 删除 .git 文件夹，这样你可以把它变成你自己的配置仓库
rm -rf ~/.config/nvim/.git

# 尝试后台启动一次 nvim 触发 LazyVim 的初始下载 (可选项)
echo "   -> 正在后台触发 LazyVim 初始配置..."
nvim --headless "+q" || true

echo -e "\n${BLUE}========================================================${NC}"
echo -e "${GREEN}  🎉 环境与 LazyVim 安装全部完成！${NC}"
echo -e "${BLUE}========================================================${NC}"
echo "Neovim 版本 :" $(nvim --version | head -n 1)
echo -e "\n${YELLOW}👉 接下来你需要做的事情：${NC}"
echo -e "1. 确保 ${GREEN}~/.local/bin${NC} 在你的环境变量 PATH 中。"
echo "   (如果不确定，可以在 ~/.bashrc 或 ~/.zshrc 中添加: export PATH=\"\$HOME/.local/bin:\$PATH\")"
echo "2. 如果不想看到 Perl/Ruby 的警告，记得在 ~/.config/nvim/lua/config/options.lua 里加上:"
echo "   vim.g.loaded_perl_provider = 0"
echo "   vim.g.loaded_ruby_provider = 0"
echo "3. 在终端输入 \`nvim\` 启动！第一次启动会自动下载大量插件，请耐心等待读条结束。"
echo "4. 插件下载完毕后，输入 ${GREEN}:checkhealth${NC}，你将看到一个完美的面板！"
