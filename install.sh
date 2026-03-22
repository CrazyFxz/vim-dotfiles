#!/bin/bash

echo ">>> 开始配置 Vim IDE 环境..."

# 1. 更新包列表并安装系统依赖
# clangd: C/C++ LSP 后端
# ripgrep: 极速文件内容搜索工具 (为 FZF 提供支持)
# bear: 生成 compile_commands.json 的工具
sudo apt update
sudo apt install -y vim git curl build-essential cmake clangd ripgrep bear python3-venv universal-ctags clang-format

# 2. 安装 Node.js (Coc.nvim 的强依赖，Ubuntu 22.04 默认源太旧，这里使用 NodeSource 源 v20)
if ! command -v node &> /dev/null; then
    echo ">>> 正在安装 Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt install -y nodejs
fi

# 3. 创建配置文件软链接 (将我们写的 vimrc 链接到 ~/.vimrc)
echo ">>> 创建 .vimrc 软链接..."
ln -sf ~/vim-dotfiles/vimrc ~/.vimrc

# 4. 安装 Vim-Plug (Vim 插件管理器)
if [ ! -f ~/.vim/autoload/plug.vim ]; then
    echo ">>> 正在安装 vim-plug..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# 5. 自动下载安装 Vim 插件
echo ">>> 正在安装 Vim 插件..."
vim +PlugInstall +qall

echo ">>> Vim 基础环境安装完成！首次打开 Vim 时，Coc 会在后台自动安装 C++ 和 Python 的 LSP 支持包，请稍候片刻即可使用。"
