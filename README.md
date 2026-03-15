# vim-dotfiles
vim配置

将配置目录上传到个人github
cd ~/vim-dotfiles
git init
git add .
git commit -m "My Vim IDE config"
git remote add origin <你的Git仓库地址>
git push -u origin master

在新设备上
cd ~
git clone <你的Git仓库地址> vim-dotfiles
cd vim-dotfiles
./install.sh

LSP 补充
对于python（coc-pyright）:
如果是单文件，直接写代码就有补全。如果大工程，并且使用虚拟环境，建议在根目录下创建一个prightconfig.json，告诉LSP虚拟环境在哪：
{
  "venvPath": ".",
  "venv": "venv"
}

对于C/C++（clangd）
必须知道代码怎么编译的，才能提供准确的报错和跳转和报错。需要在根据下有一个compile_commands.json文件
cmake项目：
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -B build
ln -s build/compile_commands.json .
makefile项目：
bear -- make


clangd工程配置
解决交叉编译问题
在vim中输入:CocConfig配置全局clagnd启动参数
:CocConfig

{
  "clangd.arguments":[
    "--background-index",
    "--compile-commands-dir=.",
    "--query-driver=/opt/gcc-arm-none-eabi-10.3-2021.10/bin/arm-none-eabi-gcc",
    "--query-driver=**/*gcc,**/*g++",
    "--header-insertion=never",
    "--clang-tidy"
  ],

  "explorer.file.showHiddenFiles": true,
  "inlayHint.enable": false
}

软链接compile_commands.json
在根目录下：
ln -s out/board_a/compile_commands.json .

clipboard补充提示 (针对 WSL 环境)：
在 WSL 中，Vim 的系统剪贴板 ("+y) 有时无法直接复制到 Windows 宿主机。如果发现复制失效，你可以下载一个 win32yank.exe 放在 WSL 的 PATH 下（比如 /usr/local/bin/），Vim 的 clipboard=unnamedplus 就能直接和 Windows 剪贴板互通了。


Tagbar大纲插件
需要额外安装universal-ctags，可以加到install.sh中
sudo apt install universal-ctags
6626 .clangd 
CompileFlags:
  Add: [
    "-mcpu=cortex-m4",       # 根据实际芯片改
    "-mfloat-abi=soft"       # 如果 MCU 没有硬件 FPU
  ]

Diagnostics:
  UnusedIncludes: None   # 禁止 include-cleaner 警告
