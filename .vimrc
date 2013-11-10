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
"
" [+!] 2013-05-06
" 添加了php等的自动完成(alt+/)，修改了viminfo的参数不保存缓存区
"
" [+] 2013-05-30
" 添加了对coffee-script的支持，以submodule的形式加入的，所以可以单独更新
" 添加了coffee-script的快捷键，添加了执行命令行的插件conque
"
" [+]2013-06-06
" 添加了matrix插件，主要是闲着无聊为了好玩 :Matrix
"
" [+]2013-06-09
" 添加了检测ejs文件类型的选项，并且设置markdown的fdm为marker
"
" [+]2013-06-15
" 通过K可以查询PHP的内建函数，主要是修改了keywordprg
"
" [+]2013-08-26
" 添加matchit插件
" 修改alt+/为匹配字典的功能
" 
" [!]2013-09-09
" change the formatingoption of file
"
" [!]2013-09-13
" 为了解决自己的一些疑惑，做了一些小的修改
autocmd! bufwritepost .vimrc source %
autocmd! bufwritepost .gvimrc source %

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

" 关闭快捷键兼容
set nocompatible

" 保留历史记录
set history=500

" 行控制
set linebreak "折行不断词，让英文阅读更舒服些
"set nolinebreak "这是为了适应中文换行
set wrap
set textwidth=80

" 标签页
set showtabline=1

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
set nobackup
"set noswapfile
set hidden "让切换 buffer 保持 undo 记录
set viminfo='1000,f1,<500,h "持久保存文件光标位置等信息

" 代码折叠
set foldmethod=manual

" =====================
" 多语言环境
"    默认为 UTF-8 编码
" =====================
if has("multi_byte")
    set encoding=utf-8
    " English messages only
    "language messages zh_CN.utf-8
    
    if has('win32')
        language english
        let &termencoding=&encoding
    endif

    set fencs=utf-8,gbk,chinese,latin1
    set formatoptions+=mM
    set nobomb " 不使用 Unicode 签名

    if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
        set ambiwidth=double
    endif
else
    echoerr "Sorry, this version of (g)vim was not compiled with +multi_byte"
endif

" 永久撤销，Vim7.3 新特性
if has('persistent_undo')
    set undofile

    " 设置撤销文件的存放的目录
    if has("unix")
        set undodir=/tmp/,~/tmp,~/Temp
    else
        set undodir=d:/temp/
    endif
    set undolevels=1000
    set undoreload=10000
endif

" Use pathogen to easily modify the runtime path to include all
" plugins under the ~/.vim/bundle directory
" http://www.vim.org/scripts/script.php?script_id=2332
call pathogen#infect()

" =========
" AutoCmd
" =========
if has("autocmd")
    " 打开文件类型检测
    filetype plugin indent on

    " Auto Check Syntax 需要jslint等以后添加
    " au BufWritePost,FileWritePost *.js,*.php call CheckSyntax(1)


    " 给各语言文件添加 Dict
    if has('win32')
        let s:dict_dir = $VIM.'\vimfiles\dict\'
    else
        let s:dict_dir = $HOME."/.vim/dict/"
    endif
    let s:dict_dir = "setlocal dict+=".s:dict_dir

    au FileType php exec s:dict_dir."php_funclist.dict"
    au FileType css exec s:dict_dir."css.dict"
    au FileType javascript exec s:dict_dir."javascript.dict"


    " 将指定文件的换行符转换成 UNIX 格式
    au FileType php,javascript,html,css,python,vim,vimwiki set ff=unix


    au BufRead,BufNewFile *.ejs,*.j2,*.mustache set filetype=html
    au BufRead,BufNewFile *.k set filetype=javascript
    au BufRead,BufNewFile *.sibilant set filetype=scheme
	au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn}   set filetype=mkd
    au FileType html,jade,scheme,css,less setlocal shiftwidth=2 tabstop=2 softtabstop=2
    au FileType javascript,coffee setlocal shiftwidth=4 tabstop=4 softtabstop=4
"    au FileType javascript setlocal fo+=t
    au FileType css,less,html setlocal fo-=t
    au BufRead,BufNewFile jquery*.js set ft=javascript syntax=jquery
    au BufRead,BufNewFile *.json set ft=json
endif

" =========
" GUI
" =========
if has('gui_running')
    " 只显示菜单
    " set guioptions=mcr

    " 高亮所在行、列
    set cursorline
    set cursorcolumn

    if has("win32")
        " Windows 兼容配置
        source $VIMRUNTIME/mswin.vim

        " f11 最大化
        nmap <f11> :call libcallnr('fullscreen.dll', 'ToggleFullScreen', 0)<cr>
        nmap <Leader>ff :call libcallnr('fullscreen.dll', 'ToggleFullScreen', 0)<cr>

        " 自动最大化窗口
        au GUIEnter * simalt ~x

        " 给 Win32 下的 gVim 窗口设置透明度
        "au GUIEnter * call libcallnr("vimtweak.dll", "SetAlpha", 250)

        " 字体配置
        exec 'set guifont='.iconv('Courier_New', &enc, 'gbk').':h10:cANSI'
        "exec 'set guifontwide='.iconv('Microsoft\ YaHei', &enc, 'gbk').':h10'
    endif

    " Under Mac 我还没有mac不进行设置
    if has("gui_macvim")
        " MacVim 下的字体配置
        set guifont=Source\ Code\ Pro\ Light:h12
        set guifontwide=微软雅黑:h12

        " 半透明和窗口大小
        set transparency=2
        set lines=40 columns=100

        " 使用 MacVim 原生的全屏幕功能
        let s:lines=&lines
        let s:columns=&columns

        func! FullScreenEnter()
            set lines=999 columns=999
            set fu
        endf

        func! FullScreenLeave()
            let &lines=s:lines
            let &columns=s:columns
            set nofu
        endf

        func! FullScreenToggle()
            if &fullscreen
                call FullScreenLeave()
            else
                call FullScreenEnter()
            endif
        endf

        set guioptions+=e
        " Mac 下，按 <Leader>ff 切换全屏
        nmap <f11> :call FullScreenToggle()<cr>
        nmap <Leader>ff  :call FullScreenToggle()<cr>

        " I like TCSH :^)
        set shell=/bin/tcsh

        " Set input method off
        set imdisable

        " Set QuickTemplatePath
        let g:QuickTemplatePath = $HOME.'/.vim/templates/'

        " 如果为空文件，则自动设置当前目录为桌面
        " lcd ~/Desktop/
    endif

    " Under Linux/Unix etc.
    if has("unix") && !has('gui_macvim')
        set guifont=Courier\ 10\ Pitch\ 11
    endif
endif

" =============
" Key Shortcut
" =============

" 快速编译快捷键暂时包括node 和
map <f3> :w\|!node %<cr>
map <f6> :w\|!coffee -c %<cr>

" 搜索相关快捷键
nmap <silent> <leader>/ :nohlsearch<CR>
noremap <silent> <Space> :silent noh<CR>

" tab页相关快捷键
nmap <C-Tab> <C-w><C-w>
nmap <C-h> <C-w>h
nmap <C-l> <C-w>l
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-t> :tabnew<cr>
nmap <C-p> :tabprevious<cr>
nmap <C-n> :tabnext<cr>
nmap <C-q> ZZ 

" insert mode shortcut
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
inoremap <C-d> <Delete>
imap <A-/> <C-x><C-k>

"for i in range(1, &tabpagemax)
"    exec 'nmap <A-'.i.'> '.i.'gt'
"endfor

" 插件快捷键
nmap <C-d> :NERDTree<cr>
nmap <C-e> :BufExplorer<cr>
nmap <f2>  :BufExplorer<cr>
nmap <F10> :NERDTreeToggle<cr>

" 插入模式按 F4 插入当前时间
imap <f4> <C-r>=GetDateStamp()<cr>

" 直接查看第一行生效的代码
nmap <Leader>gff :call GotoFirstEffectiveLine()<cr>

" 按下 Q 不进入 Ex 模式，而是退出
nmap Q :x<cr>

" =============
" Color Scheme
" =============
if has('syntax')

    " http://ethanschoonover.com/solarized
    ""colorscheme solarized

    " 默认编辑器配色
    au BufNewFile,BufRead,BufEnter,WinEnter * colo desert

    " 各不同类型的文件配色不同
    au BufNewFile,BufRead,BufEnter,WinEnter *.wiki colo lucius

    " 保证语法高亮
    syntax on
endif

" =================
" Plugin Configure
" =================
" don't let NERD* plugin add to the menu
let g:NERDMenuMode = 0

" Emmet 方便写HTML
"let g:user_zen_leader_key = '<c-i>'
let g:user_emmet_settings = {
\  'indentation' : '  ',
\  'perl' : {
\    'aliases' : {
\      'req' : 'require '
\    },
\    'snippets' : {
\      'use' : "use strict\nuse warnings\n\n",
\      'warn' : "warn \"|\";",
\    }
\  }
\}

" vim-snimate

let g:snipMate = {}
let g:snipMate.scope_aliases = {}
let g:snipMate.scope_aliases['javascript'] = 'javascript,javascript-jquery'
let g:snipMate.scope_aliases['less'] = 'css'
