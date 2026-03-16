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
    // "--query-driver=/opt/gcc-arm-none-eabi-10.3-2021.10/bin/arm-none-eabi-gcc",
    "--query-driver=**/*gcc,**/*g++",
    "--header-insertion=never",
    "--clang-tidy"
  ],

  "explorer.file.showHiddenFiles": true,
  "inlayHint.enable": false,
  "semanticTokens.enable": true,
  "suggest.noselect": true,
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
|-------|------|
| `Space` | Leader 键 |
| `F4` | 切换显示/隐藏不可见字符 |
| `F8` / `<leader>o` | 显示或隐藏 Tagbar 大纲 |
| `F10` | 彻底关闭 Floaterm 终端 |
| `F12` | 显示或隐藏 Floaterm 终端 |
| `<C-p>` | FZF 查找文件 |
| `<leader>f` | FZF + ripgrep 全局搜索 |
| `<C-f>` | 当前 buffer 内搜索 |
| `<Tab>` / `<S-Tab>` | 补全列表上下选择 |
| `gd` | 跳转到定义 |
| `gy` | 跳转到类型定义 |
| `gi` | 跳转到实现 |
| `gr` | 跳转到引用 |
| `<C-LeftMouse>` | 跳转定义 |
| `<C-RightMouse>` | 跳转引用 |
| `<M-LeftMouse>` | 相当于 `<C-o>` 返回 |
| `K` | 查看函数/文档注释 |
| `<leader>rn` | 重命名符号 |
| `<leader>e` | 打开侧边文件树 |
| `<leader>th` | Toggle Inlay Hints |
| `Ctrl + /` | 注释当前行或代码块 |
| `<leader>b` | 列出当前打开的 buffer |
| `s + 搜索 + Enter` | EasyMotion 跳转 |
| `]c` | GitGutter 跳转到下一个修改块 |
| `[c` | GitGutter 跳转到上一个修改块 |
| `<leader>hp` | 预览修改前代码 |
| `<leader>hu` | 撤销当前修改 |
| `<leader>hs` | 暂存当前代码块 (`git add`) |
| `<leader>hd` | 查看文件 diff |
| `<leader>hc` | 关闭预览窗口 |
| 双击左键 | 高亮全局相同单词 |
| `x / d / c / D` | 删除但不污染剪切板 |
| `<leader>d` | 真正剪切 |
| `<leader>\` | 垂直分屏 |
| `<leader>-` | 水平分屏 |
| `<leader>w` | 保存文件 |
| `<leader>q` | 退出 |
| `<leader>wq` | 保存并退出 |
| `<leader>c` | 关闭当前 buffer |
| `Ctrl + h/j/k/l` | 在窗口间移动 |
| `Ctrl + ↑↓←→` | 调整窗口大小 |
| `<leader>=` | 平衡所有窗口大小 |
| `<Tab>` | 切换到下一个 buffer |
| `<S-Tab>` | 切换到上一个 buffer |
| `jj` / `jk` | 退出插入模式 |
| `<leader><CR>` / `<Esc><Esc>` | 取消搜索高亮 |
| `:CleanExtraSpaces` | 清理行尾多余空格 |
| `gh` | 跳到行首（非空字符） |
| `gl` | 跳到行尾 |
| `<C-s>` | 保存 |
