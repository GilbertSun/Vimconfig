" File: _vimrc/.vimrc
" Author: GilbertSun<szb4321@gmail.com>
" Description: GilbertSun's personal vim config file(reference by mingcheng[https://github.com/feelinglucky/vimrc] and yuest[https://github.com/undozen/vimsettings]).
" Last Modified: $Id: _vimrc 467 2013-03-18 13:38:05Z i.feelinglucky $
" Blog: http://www.gcore.net.cn/
" Since: 2013-03-18
" [+]new feature  [*]improvement  [!]change  [x]bug fix
" 
" [+] 2013-03-18
"       初始化版本，由于家里和公司的Vim环境不够统一，因此需要统一设置后通过git来
"       实现迁移，配置文件参考mingcheng和yuest的git库，地址见文件头

" vimrc文件修改后可以立即显现效果
autocmd! bufwritepost _vimrc source %
autocmd! bufwritepost _gvimrc source %

" 确认vim的版本
if v:version < 703
    echoerr 'This _vimrc requires Vim 7.3 or later.'
    quit
endif


" 获取当前目录
func! GetPWD()
    return substitute(getcwd(), "", "", "g")
endf

" 跳过页头注释，到首行实际代码
func! GotoFirstEffectiveLine()
    let l:c = 0
    while l:c<line("$") && (
                \ getline(l:c) =~ '^\s*$'
                \ || synIDattr(synID(l:c, 1, 0), "name") =~ ".*Comment.*"
                \ || synIDattr(synID(l:c, 1, 0), "name") =~ ".*PreProc$"
                \ )
        let l:c = l:c+1
    endwhile
    exe "normal ".l:c."Gz\<CR>"
endf

" 匹配配对的字符
func! MatchingQuotes()
    inoremap ( ()<left>
    inoremap [ []<left>
    inoremap { {}<left>
    inoremap " ""<left>
    inoremap ' ''<left>
endf

" 返回当前时期
func! GetDateStamp()
    return strftime('%Y-%m-%d')
endf

" 全选
func! SelectAll()
    let s:current = line('.')
    exe "norm gg" . (&slm == "" ? "VG" : "gH\<C-O>G")
endf

" From an idea by Michael Naumann
func! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunc

" ============
" Environment
" ============

" 保留历史记录
set history=500

" 行控制
set linebreak "折行不断词，让英文阅读更舒服些
"set nolinebreak "这是为了适应中文换行
set nocompatible
set wrap

" 标签页
set showtabline=2
nmap <C-Tab> <C-w><C-w>
nmap <C-h> <C-w>h
nmap <C-l> <C-w>l
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-t> :tabnew<cr>
nmap <C-p> :tabprevious<cr>
nmap <C-n> :tabnext<cr>
nmap <C-q> ZZ

" 控制台响铃
set noerrorbells
set novisualbell
set t_vb= "close visual bell

" 行号和标尺ruler不会显示会被状态行替代掉
set number
set ruler
set rulerformat=%15(%c%V\ %p%%%)
set scrolloff=5 "光标碰到第五行、倒数第五行时就上下卷屏

" 命令行于状态行显示的信息很完整包括行和列的信息
set ch=1
set stl=\ [File]\ %F%m%r%h%y[%{&fileformat},%{&fileencoding}]\ %w\ \ [PWD]\ %r%{GetPWD()}%h\ %=\ [Line]%l/%v/%L\ %=\[%P]
set ls=2 " 始终显示状态行
set wildmenu "命令行补全以增强模式运行
set showcmd

" 高亮所在行、列
set cursorline
set cursorcolumn

" 定义 <Leader> 为逗号
let mapleader = ","
let maplocalleader = ","

" Search Option
set hlsearch  " Highlight search things
set magic     " Set magic on, for regular expressions
set showmatch " Show matching bracets when text indicator is over them
set mat=2     " How many tenths of a second to blink
set incsearch
set smartcase

" 制表符使用4个空格进行缩进而不是tab
set tabstop=4
set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4

" 缩进
set autoindent
set smartindent

"粘贴代码专用
set pastetoggle=<F7>

" 自动重新读入
set autoread

" 插入模式下使用 <BS>、<Del> <C-W> <C-U>
set backspace=indent,eol,start "让 Backspace 键可以删除换行

" 备份和缓存
"set nobackup
"set noswapfile

" 代码折叠
set foldmethod=marker

" 快速编译快捷键暂时包括node 和
map <f3> :w\|!node %<cr>
map <f4> :w\|!python -i %<cr>