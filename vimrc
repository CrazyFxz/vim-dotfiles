" 设置 Leader 键为空格
let mapleader = "\<Space>"

" ========剪贴板基础配置===================
" 让 Vim 的默认寄存器与系统剪贴板 (+ 和 *) 关联
" 这样直接用 y, d, p 就能操作系统剪贴板，不需要输入 "+y
if has('unnamedplus')
    set clipboard=unnamedplus,unnamed
endif

" ====WSL 特有的剪贴板桥接 (关键步骤)======
" WSL 不自带剪贴板转发，我们需要手动把内容管道传输给 Windows 的 clip.exe
if executable('clip.exe')
    augroup WSLClipboard
        autocmd!
        " 当你在 Vim 中 yank (复制) 之后，自动把内容发给 Windows 的 clip.exe
        " autocmd TextYankPost * if v:event.operator == 'y' | call system('clip.exe', @0) | endif
        " 在传给 clip.exe 之前，将 UTF-8 转码为 GBK，彻底解决 Windows 粘贴乱码
        " autocmd TextYankPost * if v:event.operator == 'y' | call system('clip.exe', iconv(@0, 'utf-8', 'gbk')) | endif
        autocmd TextYankPost *
            \ if v:event.regname != '_' |
            \   call system('clip.exe', iconv(join(v:event.regcontents, "\n"), 'utf-8', 'gbk')) |
            \ endif
    augroup END
endif

" =========粘贴时的性能优化================
set pastetoggle=<F2>    " 避免在粘贴大量内容时产生缩进混乱

" =========真彩终端========================
set termguicolors
" 强制 Vim 使用终端的真色彩转义序列 (专门针对 Windows Terminal 优化)
if !has('nvim')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" 配置字符样式：
" trail:· 表示行尾多余的空格显示为 ·
" tab:→\  表示制表符显示为 →
" extends:> 和 precedes:< 用于行过长时不自动换行时的提示
set listchars=space:·,tab:→\ ,trail:·,extends:>,precedes:<
set nolist " 默认不开启
" 按 F4 键一键切换显示/隐藏不可见字符（你可以把 <F4> 换成你喜欢的键）
nnoremap <F4> :set list!<CR>
" 开启不可见字符的显示
" set list

" ======基础设置 (Basic Settings)==========

" 禁用所有中间文件、备份文件和交换文件
set noswapfile      " 禁止生成临时交换文件 (.swp)
set nobackup        " 禁止生成备份文件 (*~)
set nowritebackup   " 禁止在保存时生成临时备份文件
set nocompatible            " 禁用兼容模
set wrap                    " 自动换行
syntax on                   " 开启语法高亮
set number              " 显示行号
" set relativenumber      " 开启相对行号
set cursorline          " 突出显示当前行
set tabstop=4           " Tab宽度为4
set showcmd                 " 显示不完整的命令
set wildmenu                " 命令模式下底部显示补全状态
set shiftwidth=4        " 缩进宽度为4
set expandtab           " 将Tab替换为空格
set autoindent          " 自动缩进
set mouse=a             " 支持鼠标
set ignorecase          " 搜索时忽略大小写
set smartcase           " 搜索时如果包含大写字母则区分大小写
set updatetime=300      " 减少更新时间，加快Coc和GitGutter的响应速度
set signcolumn=yes      " 始终显示侧边标志列，防止屏幕闪烁
set clipboard=unnamedplus
set incsearch           " 开启实时搜索（边输入边匹配当前字符）
set hlsearch            " 高亮所有搜索匹配到的结果

" ==========================================
" Buffer 与撤销 (Undo) 行为管理
" ==========================================
" 1. 允许在未保存修改的情况下切换 Buffer (隐藏当前 Buffer 而不是关闭它)
" 它的附带神级效果：因为 Buffer 只是被隐藏在内存中，所以切回来后，无限撤销 (u) 依然有效！
set hidden
" 2. 明确禁用撤销文件持久化 (防止跨 Vim 会话保留撤销记录)
" 默认其实就是关闭的，但写上这一句可以防止其他插件篡改。
" 这样保证了你关闭工程重新打开 Vim 时，是一个干净的状态，不能撤销上一次的修改。
set noundofile

" ==========================================
" 终极编码配置：解决所有中文乱码问题
" ==========================================
" 1. Vim 内部使用的字符编码，统一使用 utf-8
set encoding=utf-8
" 2. 终端使用的编码（保持和内部一致即可）
set termencoding=utf-8
" 3. 默认新建文件的编码设为 utf-8
set fileencoding=utf-8
" 4. 【核心】Vim 打开文件时的“猜测清单” (严格按顺序匹配)
" ucs-bom: 带BOM的UTF-8
" utf-8: 国际标准
" cp936 / gb18030: Windows 下的简体中文编码 (解决大部分乱码的功臣)
" big5: 繁体中文
" latin1: 兜底用的英文字符集
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

" ==========================================
" 插件管理 (Vim-Plug)
" ==========================================
call plug#begin('~/.vim/plugged')

" 主题和高亮
Plug 'morhetz/gruvbox'               " Gruvbox 主题
Plug 'sheerun/vim-polyglot'          " 强大的多语言语法高亮集合

" 核心：LSP 与 补全引擎
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" 模糊搜索工具 (FZF)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" 底部状态栏
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'  " 可选，提供各种配色

" 智能注释代码
Plug 'tpope/vim-commentary'

Plug 'preservim/tagbar'

Plug 'voldikss/vim-floaterm'

Plug 'lfv89/vim-interestingwords'

Plug 'easymotion/vim-easymotion'
" 增强 Vim 的原生增量搜索体验
Plug 'haya14busa/incsearch.vim'
" 将增量搜索和 EasyMotion 完美结合
Plug 'haya14busa/incsearch-easymotion.vim'

" 安装 Git 侧边栏提示插件
Plug 'airblade/vim-gitgutter'
call plug#end()

" ==========================================
" 3. 插件配置
" ==========================================

" --- 主题配置 ---
autocmd vimenter * ++nested silent! colorscheme gruvbox
set background=dark



" --- FZF 全局搜索配置 ---
" <C-p> 查找文件
nnoremap <C-p> :Files<CR>
" <Leader>f 查找文件内容（依赖 ripgrep）
nnoremap <leader>f :Rg<CR>
" 绑定 Ctrl + F 在当前 buffer 中模糊搜索并跳转
nnoremap <C-f> :BLines<CR>
" 【fzf全局搜索】选中文字后，按 leader + f 直接全局搜索该文字
" 原理：将选中的文字复制到 z 寄存器（"zy），然后执行 :Rg 并在命令行粘贴 z 寄存器的内容（<C-R>z）
vnoremap <leader>f "zy:Rg <C-R>=escape(@z, '#%\')<CR><CR>
" 【fzf当前文件搜索】选中文字后，按 Ctrl + f 直接在当前文件搜索该文字
vnoremap <C-f> "zy:BLines <C-R>=escape(@z, '#%\')<CR><CR>

let g:fzf_layout = { 'down': '40%' }
" let g:fzf_preview_window = ['right:50%', 'ctrl-/']



" --- Coc.nvim LSP 配置 ---
" 设置首次启动时自动安装的 Coc 插件包（这保证了配置的可移植性）
let g:coc_global_extensions =[
  \ 'coc-clangd',
  \ 'coc-pyright',
  \ 'coc-explorer',
  \ 'coc-json',
  \ 'coc-snippets',
  \ 'coc-pairs'
  \ ]

" 使用 Tab 和 Shift-Tab 在补全列表中上下选择
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" 回车键确认补全
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" --- 增强版：安全代码跳转 (防止光标在括号边缘时跳错) ---
function! SafeCocJump(action) abort
  " 获取当前光标下的字符
  let l:char = matchstr(getline('.'), '\%' . col('.') . 'c.')
  " \k 代表有效的变量字符 (字母、数字、下划线)
  " 如果当前光标不在有效字符上（比如停在 '('、'<' 或 空格 上）
  if l:char !~# '\k'
    " 自动向左查找并移动到最近的一个有效变量字符上
    " 'c'代表允许光标原地匹配，'b'代表向后(左)查找，'W'代表不换行
    call search('\k', 'cbW')
  endif
  " 坐标修正完毕后，触发 Coc 的跳转动作
  call CocActionAsync(a:action)
endfunction
" 重新绑定快捷键
" nnoremap <silent> gd :call SafeCocJump('jumpDefinition')<CR>
" nnoremap <silent> gy :call SafeCocJump('jumpTypeDefinition')<CR>
" nnoremap <silent> gi :call SafeCocJump('jumpImplementation')<CR>
" nnoremap <silent> gr :call SafeCocJump('jumpReferences')<CR>

" ⚠️ 修改为下面的写法（加上 m' 强制记录跳转位置）：
nmap <silent> gd m'<Plug>(coc-definition)
nmap <silent> gy m'<Plug>(coc-type-definition)
nmap <silent> gi m'<Plug>(coc-implementation)
nmap <silent> gr m'<Plug>(coc-references)

" 1. 必须开启鼠标支持 (如果你的配置里没写过这一行)
" #set mouse=a
" 2. 绑定 Ctrl + 鼠标左键
" <LeftMouse> 的作用是先让光标跳到你点击的位置
" 然后调用我们之前的 SafeCocJump 函数实现精准跳转
nnoremap <silent> <C-LeftMouse> <LeftMouse>:call SafeCocJump('jumpDefinition')<CR>
" 3. (可选) 绑定 Ctrl + 鼠标右键 跳转到引用 (References)
nnoremap <silent> <C-RightMouse> <LeftMouse>:call SafeCocJump('jumpReferences')<CR>

" 比如用 Alt + 鼠标左键 跳回上一个位置
nnoremap <M-LeftMouse> <C-o>

" 查看函数/类的文档注释 (按大写 K)
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" 重命名变量 (类似 VSCode 的 F2)
nmap <leader>rn <Plug>(coc-rename)

" --- Coc-Explorer (文件树) ---
" 按空格+e 打开/关闭侧边栏文件树
nnoremap <leader>e :CocCommand explorer<CR>
" 使用 <leader>th (Space + t + h) 来开关 Inlay Hints
nnoremap <silent> <leader>th :CocCommand document.toggleInlayHint<CR>




" ----tpope/vim-commentary 配合-----
" 普通模式 Ctrl+/ 注释当前行
nmap <C-_> gcc
" 视觉模式 Ctrl+/ 注释选中块
vmap <C-_> gc

" 针对 C 和 C++ 文件，将默认注释修改为 //
augroup CppCommentary
    autocmd!
    autocmd FileType c,cpp setlocal commentstring=//\ %s
augroup END



" -------- vim-airline Buffer/Tab 标签页显示配置---------
" 开启 tabline (顶部显示已打开的文件)
let g:airline#extensions#tabline#enabled = 1
" 让顶部显示 buffer 而不是 vim tabs
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tabs = 0 " 强制隐藏原生 Tab，避免冲突
" 只显示文件名，不显示长长的路径（像 VS Code 一样简洁）
let g:airline#extensions#tabline#formatter = 'unique_tail'
" 让顶部 tabline 显示连续的序号（1, 2, 3...）而不是真实的 Buffer ID
let g:airline#extensions#tabline#buffer_idx_mode = 1
" 显示 buffer 的编号（方便快速跳转）
" let g:airline#extensions#tabline#buffer_nr_show = 1
" 设置 tabline 的分隔符（可选，根据你的字体是否有特殊符号决定）
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
" 设置状态栏配色（推荐用 molokai 或 dark）
let g:airline_theme='dark'
" 按 leader + b (buffer) 弹出一个搜索框，只搜当前已经打开的所有文件
nnoremap <leader>b :Buffers<CR>



" ------tagbar 配置-----------------------
" 将 F8 或 Leader+o 映射为开关大纲面板
nmap <F8> :TagbarToggle<CR>
nmap <leader>o :TagbarToggle<CR>
" 0 表示按文件里的出现顺序排列，1 表示按字母表顺序排列（默认）
let g:tagbar_sort = 0
" 让大纲面板在打开文件时自动开启（可选，看你喜好）
" autocmd VimEnter * nested :call tagbar#autoopen(1)
"
" 当你的光标在右侧的 Tagbar 面板里时，直接按下键盘上的 s 键。
" 按一次 s：变成按字母顺序排列（底部会提示 Sorted alphabetically）。
" 再按一次 s：变回按文件出现顺序排列（底部会提示 Sorted by file order）。



" ----vim-floaterm 终端配置---------------
" 按快捷键 F11 彻底杀掉终端
let g:floaterm_keymap_kill = '<F10>'
" 按 F12 随时呼出/隐藏 悬浮终端
let g:floaterm_keymap_toggle = '<F12>'
" 1. 设置终端在屏幕的位置为底部 ('bottom')
let g:floaterm_position = 'bottom'
" 2. 设置终端的宽度（1.0 表示占满全屏的 100%，0.9 表示占 90%）
" 强烈建议设为 1.0，这样看起来就像 VSCode 的底部面板
let g:floaterm_width = 1.0
" 3. 设置终端的高度（0.3 表示占屏幕高度的 30%）
" 根据你自己的喜好调整，比如 0.4 或 0.2
let g:floaterm_height = 0.3

" 可选：修改边框样式
" 选项有：'single' (单线), 'double' (双线), 'rounded' (圆角), 'none' (无边框)
let g:floaterm_borderchars = '─│─│╭╮╯╰'
" 如果你想彻底去掉边框，让它完全像一个底部分屏：
" let g:floaterm_borderchars = '        '



" -----------vim-interestingwords 高亮配置----------------
" 按下 <Leader> n ?? 跳转到该单词的下一个位置。
" 按下 <Leader> N ?? 跳转到该单词的上一个位置。
" GUI 或开启了 TrueColor 终端下的颜色（十六进制）
let g:interestingWordsGUIColors = ['#8CCBEA', '#A4E57E', '#FFDB72', '#FF7272', '#FFB3FF', '#9999FF', '#40E0D0', '#FFA500', '#DDA0DD', '#32CD32', '#F08080', '#87CEFA']
" 普通 256 色终端下的颜色编号
let g:interestingWordsTermColors = ['154', '121', '211', '137', '214', '222', '118', '208', '219', '203', '170', '45']



" 自动跳转到上一次退出文件时的光标位置
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif



" ------ vim-easymotion 配置-----------
" 开启 EasyMotion 的智能大小写匹配
let g:EasyMotion_smartcase = 1
" 将 s 键映射为：增量搜索 + EasyMotion 跳转
map s <Plug>(incsearch-easymotion-/)



" --------vim-gitgutter git 配置---------
" (可选) 自定义侧边栏的符号，看起来更直观
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = '~-'
nmap <Leader>hc :pc<CR>
" 使用 <Leader>gd 来预览差异 (Git Diff)
nnoremap <Leader>hd :GitGutterDiffOrig<CR>



" ==========================================
" 设置与快捷键
" ==========================================

" 鼠标双击左键：高亮全局相同单词，并保持当前单词被选中 (Visual 模式)
nnoremap <silent> <2-LeftMouse> :let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'<CR>:set hlsearch<CR>viw
" 原理解释：
" :let @/ = ...：把当前光标下的单词（<cword>）安全转义后，强行塞进 Vim 的 / 搜索记录中。
" :set hlsearch：打开搜索高亮（此时全屏相同的单词都会变黄）。
" viw：进入 Visual 模式并选中当前单词（保留了你双击选中的物理直觉）。 (提示：如果你觉得高亮太刺眼，可以配合上一个回答中提到的双击 Esc 取消高亮配置使用)

" ==========================================
" 纯净删除方案：x, d, c 不再污染剪贴板
" ==========================================
" 1. 让 x (删除单个字符) 直接进黑洞
nnoremap x "_x
vnoremap x "_x
" 2. 让 d (删除) 直接进黑洞。包含 dd, dw, diw 以及 Visual 模式下的选中删除
nnoremap d "_d
vnoremap d "_d
" 3. (强烈推荐) 让 c (修改) 也进黑洞。比如 cw 修改单词时，原单词不会覆盖剪贴板
nnoremap c "_c
vnoremap c "_c
" 4. 让大写的 D 和 C 也进黑洞 (删除/修改至行尾)
nnoremap D "_D
nnoremap C "_C
" ⚠️ 【核心补充】：既然 d 被改成了纯删除，如果你真的想“剪切”文字怎么办？
" 设置 Leader + d 作为真正的“剪切”快捷键（会存入剪贴板）
nnoremap <leader>d d
vnoremap <leader>d d

" -----------------------------------------
" 1. 分屏基本行为 (像 VS Code 一样)
" -----------------------------------------
" Vim 默认新窗口在左边或上边，很反直觉。改为在右边和下边打开。
set splitright
set splitbelow
" -----------------------------------------
" 2. 快速创建与关闭分屏
" -----------------------------------------
" 使用 leader + \ 创建垂直分屏 (左右并排，\ 的形状像一条竖线)
nnoremap <leader>\ :vsplit<CR>
" 使用 leader + - 创建水平分屏 (上下堆叠，- 的形状像一条横线)
nnoremap <leader>- :split<CR>
" 快速关闭当前窗口 (类似 VS Code 的 Ctrl+W)
nnoremap <leader>w :close<CR>
" -----------------------------------------
" 3. 丝滑的窗口跳转 (抛弃 Ctrl+w)
" -----------------------------------------
" 直接按 Ctrl + h/j/k/l 即可在不同窗口间穿梭
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" -----------------------------------------
" 4. 调整窗口大小 (化废为宝的箭头键)
" -----------------------------------------
" Vim 老手通常不用上下左右箭头移动光标，我们把它用来调整窗口大小！
" 按下箭头键，当前窗口就会向对应方向拉伸或收缩
nnoremap <C-Up> :resize +2<CR>
nnoremap <C-Down> :resize -2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>
" 按 leader + = 让所有窗口瞬间恢复等大平衡
nnoremap <leader>= <C-w>=
" -----------------------------------------
" 5. 像 VS Code 标签页一样切换文件 (Buffers)
" -----------------------------------------
" Vim 理念中不用 Tab 栏，而是用 Buffer。
" 直接按 Tab 键切换到下一个文件，Shift+Tab 切换到上一个文件
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
" 关闭当前文件，但不破坏窗口布局 (非常重要！)
nnoremap <leader>c :bdelete<CR>

" =========================================
" 光标形状设置 (类似 VS Code)
" =========================================
" 1. 进入插入模式 (Insert mode) 变为闪烁的竖线 (和 VS Code 一模一样)
let &t_SI = "\<Esc>[5 q"
" 2. 进入替换模式 (Replace mode) 变为闪烁的下划线
let &t_SR = "\<Esc>[3 q"
" 3. 退回普通模式 (Normal mode) 变回实心方块 (强烈建议保留方块)
let &t_EI = "\<Esc>[2 q"
" (可选) 如果你真的非常固执，希望普通模式也是竖线，把上面那行删掉，换成这行：
" let &t_EI = "\<Esc>[5 q"

hi link CocSem_comment Comment
hi link CocSem_inactiveCode Comment

" 如果补全菜单可见且选中了某项，回车表示确认补全
" 否则，回车就是普通换行
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" 1. 快速保存和退出 (再也不用敲 :w 和 :q 了)
" 按下 空格 + w 就可以保存
noremap <leader>w :w<CR>
noremap <leader>q :q<CR>
noremap <leader>wq :wq<CR>
" 2. 快速退出插入模式 (拯救你的小指)
" 连按两下 j 或者 jk 退出插入模式，比伸手按 Esc 快 10 倍
inoremap jj <Esc>
inoremap jk <Esc>
" 3. 一键取消搜索高亮
" Vim 搜索完后那些高亮词一直亮着很烦，按 空格 + 回车 瞬间清空高亮
noremap <leader><CR> :nohlsearch<CR>
" 按两下 Esc 键清除搜索高亮
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
" 4. 处理长句子（自动换行）的移动
" 当一行很长自动换行时，按 j 和 k 是跳过整段。改成 gj 和 gk 可以按视觉行上下移动
noremap j gj
noremap k gk
" 5. 代码缩进后保持选中状态 (极速缩进)
" 在 Visual (v) 模式下，按 < 或 > 缩进代码后，原生 Vim 会取消选中
" 加了这两句，缩进后依然保持选中，可以一直按 >>>> 连续缩进
vnoremap < <gv
vnoremap > >gv
" Normal (普通模式) 下 Ctrl+a 全选
nnoremap <C-a> ggVG
" Insert (插入模式/打字状态) 下 Ctrl+a 全选
inoremap <C-a> <Esc>ggVG
" Visual (可视/选中模式) 下 Ctrl+a 扩大到全选
vnoremap <C-a> <Esc>ggVG

" ==========================================
" 一键清理行尾多余空格 (无痕版), :CleanExtraSpaces
" ==========================================
function! CleanExtraSpaces()
    " 1. 保存当前光标位置和屏幕滚动状态
    let save_view = winsaveview()
    " 2. 保存当前的搜索记录（防止清理空格后破坏你原本的搜索高亮）
    let save_search = @/

    " 3. 静默执行：查找并删除所有行尾空格
    silent! %s/\s\+$//e

    " 4. 恢复之前的搜索记录和光标位置
    let @/ = save_search
    call winrestview(save_view)
endfunction

" 【自定义命令】输入 :CleanExtraSpaces 即可调用
command! CleanExtraSpaces call CleanExtraSpaces()
" （可选）如果你觉得哪怕按 Tab 补全也有点长，还可以再起一个小名，比如 :Trim
command! Trim call CleanExtraSpaces()


" noremap 会同时在 正常模式(Normal)、可视模式(Visual)、操作符等待模式(Operator-pending) 下生效
" gh: 跳到行首 (使用 ^ 跳到第一个非空字符，如果你想跳到绝对行首，把 ^ 改成 0)
noremap gh ^
" gl: 跳到行尾 (跳到最后一个字符)
noremap gl $





" ctrl s 保存
nnoremap <C-s> :w<CR>
inoremap <C-s> <C-o>:w<CR>
vnoremap <C-s> <C-c>:w<CR>
