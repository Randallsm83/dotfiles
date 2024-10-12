" ============================================
"                 Vim-Plug Setup
" ============================================

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Automatically run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Define plugin installation location
call plug#begin('~/.vim/plugged')

" ----- Language Support Plugins -----
Plug 'othree/html5.vim'
Plug 'othree/html5-syntax.vim'
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'leafgarland/typescript-vim'
Plug 'vim-perl/vim-perl'
Plug 'digitaltoad/vim-pug'

" ----- Code Styling and Formatting Plugins -----
Plug 'dense-analysis/ale'
Plug 'prettier/vim-prettier'
Plug 'editorconfig/editorconfig-vim'
Plug 'ntpeters/vim-better-whitespace'

" ----- Editor Enhancements Plugins -----
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdcommenter'
Plug 'Raimondi/delimitMate'

" ----- File Navigation and Management Plugins -----
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'majutsushi/tagbar'

" ----- Git Integration Plugins -----
Plug 'tpope/vim-fugitive'

" ----- Tmux Integration Plugins -----
Plug 'christoomey/vim-tmux-navigator'
Plug 'tmux-plugins/vim-tmux'

" ----- Visual Enhancements Plugins -----
Plug 'bling/vim-airline'
Plug 'edkolev/tmuxline.vim'
Plug 'dracula/vim', { 'as': 'dracula' }

call plug#end()

" ============================================
"              Custom Functions
" ============================================

" Function to check for file existence in multiple locations
function! FileReadableInPaths(filename)
    let s:base_paths = ['/ndn', expand('~/ndn'), expand('~/projects/ndn')]
    let s:subdirs = ['', 'etc', 'perl/bin']

    for base in s:base_paths
        for subdir in s:subdirs
            let l:full_path = expand(base . (empty(subdir) ? '' : '/' . subdir) . '/' . a:filename)
            if filereadable(l:full_path)
                return l:full_path
            endif
        endfor
    endfor
    return ''
endfunction

" Function to run ALEFix on a selection range using a temporary buffer
function! ALEFixRange() range
    try
        " Save current window view and position
        let l:winview = winsaveview()

        " Yank selected text to register a
        silent execute a:firstline.','.a:lastline.'yank a'

        " Open a new temporary buffer
        new
        setlocal buftype=nofile bufhidden=hide noswapfile

        " Set filetype same as original buffer
        let &filetype = getbufvar(bufnr('#'), '&filetype')

        " Paste the yanked text
        silent put a

        " Remove the first blank line
        silent 1delete _

        " Run ALEFix on temporary buffer
        ALEFix

        " Wait for ALE to finish
        while ale#engine#IsCheckingBuffer(bufnr('%'))
            sleep 100m
        endwhile

        " Extra wait time for final processing
        sleep 500m

        " Yank the fixed text
        silent %yank a

        " Close temporary buffer and replace selected text
        bdelete!
        silent execute a:firstline.','.a:lastline.'delete _'
        silent execute a:firstline - 1 . 'put a'

        " Restore window view
        call winrestview(l:winview)

    catch
        " Display error if it occurs
        let l:error_message = "Error: " . v:exception
        echohl ErrorMsg
        echom l:error_message
        echohl None
    endtry
endfunction

" ============================================
"             General Editor Settings
" ============================================

" Backup and swap settings
" Create backup and swap directories if they don't exist
let s:vim_swp = expand('$HOME/.vim/swp')
let s:vim_cache = expand('$HOME/.vim/backup')

if filewritable(s:vim_swp) == 0 && exists("*mkdir")
    call mkdir(s:vim_swp, "p", 0700)
endif
if filewritable(s:vim_cache) == 0 && exists("*mkdir")
    call mkdir(s:vim_cache, "p", 0700)
endif

execute 'set backupdir=' . s:vim_cache . '//'
execute 'set directory=' . s:vim_swp . '//'

set backup
set swapfile

" UI and Navigation settings
set showcmd              " Show incomplete command in the last line
set mouse=a              " Enable mouse support
set showmatch            " Highlight matching parentheses
set incsearch            " Incremental search, shows matches as you type
set hlsearch             " Highlight all search matches
set splitright           " Split windows to the right
set scrolloff=8          " Keep 8 lines visible above and below the cursor when scrolling
set wrap                 " Enable line wrapping
set cindent              " Enable C-like indentation
set number               " Show absolute line numbers
set relativenumber       " Show relative line numbers
set ignorecase           " Case-insensitive search
set smartcase            " Case-sensitive if uppercase characters are in search pattern
set wildmenu             " Enable enhanced command-line completion (shows matches in a menu)
set wildignorecase       " Case-insensitive matching in wildmenu
set backspace=indent,eol,start " Allow backspacing over indentation, line breaks, and insert start
set wildmode=longest:full,full " Command-line completion mode

" ============================================
"               Key Mappings
" ============================================

" Set mapleader key (using comma as leader key)
let mapleader=','

" <Space> toggle search highlighting
nnoremap <silent> <Space> :set hlsearch!<CR>

" Ctrl-N and Ctrl-P to navigate between buffers
nnoremap <C-n> :bnext<CR>
nnoremap <C-p> :bprevious<CR>

" : Shortcut for command-line mode
nnoremap ; :

" j/k navigate wrapped lines
nnoremap j gj
nnoremap k gk
inoremap <up> <c-o>gk
inoremap <down> <c-o>gj

" F1 to Escape
inoremap <F1> <ESC>
nnoremap <F1> <ESC>

" Q for formatting instead of Ex mode
map Q gq

" ,af ALE mapping for fixing
nnoremap <Leader>af :ALEFix<CR>
vnoremap <Leader>af :call ALEFixRange()<CR>

" Disable shift+arrow keys in insert mode
inoremap <S-Up> <nop>
inoremap <S-Down> <nop>

" ============================================
"               Language Settings
" ============================================

" Default indentation and tab settings
set tabstop=4            " Set width of a <Tab> to 4 spaces
set shiftwidth=4         " Use 4 spaces for auto-indent
set softtabstop=4        " Insert 4 spaces when <Tab> is pressed
set textwidth=120        " Wrap text at 120 characters
set expandtab            " Convert tabs to spaces

" Enable filetype plugin and indentation detection
filetype plugin indent on

" Language-specific indentation settings
augroup language_settings
  autocmd!

  " HTML and CSS
  autocmd FileType html,css setlocal ts=2 sw=2 sts=2 expandtab

  " JavaScript, TypeScript, JSX, and Pug
  autocmd FileType javascript,typescript,jsx,pug setlocal ts=2 sw=2 sts=2 expandtab

  " JSON
  autocmd FileType json setlocal ts=4 sw=4 sts=4 expandtab

  " Perl
  autocmd FileType perl setlocal ts=4 sw=4 sts=0 noexpandtab

  " Python
  autocmd FileType python setlocal ts=4 sw=4 sts=4 expandtab textwidth=79
  autocmd FileType python setlocal formatoptions+=croq
  autocmd FileType python setlocal softtabstop=4
  autocmd FileType python setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class,with

  " Ruby
  autocmd FileType ruby setlocal ts=2 sw=2 sts=2 expandtab

  " Markdown
  autocmd FileType markdown setlocal textwidth=80 wrap spell

  " YAML
  autocmd FileType yaml setlocal ts=2 sw=2 sts=2 expandtab

  " Shell scripts
  autocmd FileType sh setlocal ts=2 sw=2 sts=2 expandtab

  " Vim script
  autocmd FileType vim setlocal ts=2 sw=2 sts=2 expandtab
augroup END

" ============================================
"               Colorscheme Settings
" ============================================

" Set terminal colors
set t_Co=256             " Use 256 colors
if has("termguicolors")
    set termguicolors    " Enable true color support
endif

" Dracula theme settings
let g:dracula_bold = 1
let g:dracula_italic = 1
let g:dracula_italic_comment = 1
let g:dracula_underline = 1
let g:dracula_high_contrast = 1
let g:dracula_colorterm = 1
colorscheme dracula

" ============================================
"             Plugin Configurations
" ============================================

" ALE Configuration
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\   'pug': ['puglint', 'eslint'],
\   'perl': ['perltidy'],
\}
let g:ale_linters = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\   'pug': ['puglint', 'eslint'],
\   'perl': ['perlcritic'],
\}
" \   'vim': ['vint'],
" let g:ale_vim_vint_executable = expand('$HOME/.vim/plugged/vint/bin/vint')

let g:ale_fix_on_save = 0        " Auto-fix on save
let g:ale_completion_enabled = 1 " Enable completion via ALE
let g:ale_linters_explicit = 1   " Use only explicitly configured linters
let g:ale_lint_on_enter = 0      " Do not lint on entering buffer
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'
let g:ale_history_log_output = 1
let g:ale_virtualtext_cursor = 'current'
let g:ale_lint_on_text_changed = 'never'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" Vim-airline
let g:airline_theme='dracula'
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1

" Vim-better-whitespace
let g:better_whitespace_enabled=1
let g:better_whitespace_ctermcolor=255
let g:better_whitespace_guicolor='#FFFFFF'
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0

" JSX Plugin Configuration
let g:jsx_ext_required = 0

" Tagbar
nnoremap <silent> <F3> :TagbarToggle<CR>

" NERDTree Configuration
let NERDTreeShowHidden=1
map <F4> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" NERDCommenter
let g:NERDSpaceDelims = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
