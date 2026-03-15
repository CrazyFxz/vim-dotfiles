# vim-dotfiles vim配置

## 将配置目录上传到个人github

```bash
cd ~/vim-dotfiles
git init
git add .
git commit -m "My Vim IDE config"
git remote add origin <你的Git仓库地址>
git push -u origin master
```

## 在新设备上

```bash
cd ~
git clone <你的Git仓库地址> vim-dotfiles
cd vim-dotfiles
./install.sh
```

## LSP 补充

对于python（coc-pyright）:
如果是单文件，直接写代码就有补全。如果大工程，并且使用虚拟环境，建议在根目录下创建一个prightconfig.json，告诉LSP虚拟环境在哪：

```json
{
  "venvPath": ".",
  "venv": "venv"
}
```

对于C/C++（clangd）
必须知道代码怎么编译的，才能提供准确的报错和跳转和报错。需要在根据下有一个compile_commands.json文件
cmake项目：

```json
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -B build
ln -s build/compile_commands.json .
```

makefile项目：
bear -- make

### clangd工程配置

解决交叉编译问题
在vim中输入:CocConfig配置全局clagnd启动参数
:CocConfig

```json
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
```

### 软链接compile_commands.json
在根目录下：
ln -s out/board_a/compile_commands.json .

## clipboard补充提示 (针对 WSL 环境)：

在 WSL 中，Vim 的系统剪贴板 ("+y) 有时无法直接复制到 Windows 宿主机。如果发现复制失效，你可以下载一个 win32yank.exe 放在 WSL 的 PATH 下（比如 /usr/local/bin/），Vim 的 clipboard=unnamedplus 就能直接和 Windows 剪贴板互通了。


## Tagbar大纲插件

需要额外安装universal-ctags，可以加到install.sh中
sudo apt install universal-ctags

## 6626 .clangd

```bash
CompileFlags:
  Add: [
    "-mcpu=cortex-m4",       # 根据实际芯片改
    "-mfloat-abi=soft"       # 如果 MCU 没有硬件 FPU
  ]

Diagnostics:
  UnusedIncludes: None   # 禁止 include-cleaner 警告
```

## 快捷键

| 快捷键 | 作用 |
|:------------------|:---------------------------------------------------------------------|
| 空格 | leader |
| F4 | 切换显示或者隐藏不可见字符（空格等） |
| F8或者<leader>o | tagbar大纲显示或者隐藏 |
| F10 | 彻底关闭杀死floaterm终端 |
| F12 | 显示或者隐藏floaterm终端 |
| <C-p> | fzf-查找文件 |
| <leader>f | fzf-rg-全局搜索文件内容 |
| <C-f> | 在当前buffer中搜索内容 |
|  <TAB>/<S-TAB> | 补全列表上下选择 |
| gd | 跳转定义 |
| gy | 跳转类型 |
| gi | 跳转实现 |
| gr | 跳转引用 |
| <C-LeftMouse> | 跳转定义 |
| <C-RightMouse> | 跳转引用 |
| <M-LeftMouse>（alt+鼠标左键） | <C-o> |
| K | 查看函数/文档注释 |
| <leader>rn | 重命名 |
| <leader>e | 打开侧边文件树 |
| <leader>th | toggler Inlay Hints |
| Ctrl+/ | 注释当前行或块 |
| <leader>b | 弹出当前已经打开的所有buffer |
| 光标在右侧的 Tagbar 面板里时，直接按下键盘上的 s 键 | 按字母顺序排列或者按文件出现顺序排列 |
| <leader>k | 高亮或者取消高亮当前选择 |
| <leader>K | 取消所有高亮 |
| <leader>n | 跳转下一个高亮 |
| <leader>N | 跳转上一个高亮 |
| s+搜索+enter | easymotion跳转 |
| ]c | gitgutter-下一个被修改的代码块 |
| [c | gitgutter-上一个被修改的代码块 |
| <leader>hp | gitgutter-预览代码修改之前的样子 |
| <leader>hu | gitgutter-修改成未修改的状态 |
| <leader>hs | gitgutter-将当前广播所在代码加入暂存区，相当于对这一小块代码git add |
| <leaderhd> | gitgutter-文件修改前后对比 |
| <leaderhc> | gitgutter-关闭预览窗口 |
| 双击左键 | 高亮全局相同单词 |
| x/d/c/D | 不污染剪切板 |
| <leader>d | 真正的剪切 |
| <leader>\ | 垂直分屏 |
| <leader>- | 水平分屏 |
| <leader>w | 关闭当前分屏 |
| Ctrl + h/j/k/l | 不同窗口间穿梭 |
| Ctrl + 上下左右箭头 | 调整窗口大小 |
| <leader>= | 所有窗口瞬间恢复等大平衡 |
| <Tab> | normal模式下，切换到下一个buffer |
| <S-Tab> | normal模式下，切换到上一个buffer |
| <leader>c | 关闭当前buffer |
| <leader>w | 保存 |
| <leader>q | 退出 |
| <leader>wq | 保存退出 |
| jj/jk | 退出插入模式 |
| <leader><CR>/<Esc><Esc> | 取消搜索高亮 |
| :CleanExtraSpaces | 一键清理行尾多余空格 |
| gh | 跳到行首（非空字符） |
| gl | 跳到行尾 |
| <C-s> | 保存 |
|  |  |
|  |  |
|  |  |
