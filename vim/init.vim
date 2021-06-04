set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching brackets.
set ignorecase              " case insensitive matching
set mouse=v                 " middle-click paste with mouse
set hlsearch                " highlight search results
set tabstop=2               " number of columns occupied by a tab character
set softtabstop=2           " see multiple spaces as tabstops so <BS> does the
                            " right thing
set expandtab               " converts tabs to white space
set shiftwidth=2            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set smartindent             " indent based on syntax
set number                  " add line numbers
set relativenumber          " set relative line numbers. easier navigation
                            " using navigation keys
set wildmode=longest,list   " get bash-like tab completions
set cc=80                   " set an 80 column border for good coding style
syntax on                   " syntax highlighting
set background=dark         " dark background
set lbr wrap nolist         " breaks line whenever needed/on resize
set cursorline              " highlight cursorline
set splitbelow splitright   " new windows below and right of the current one
set foldmethod=indent       " fold syntax based on indentation

"au BufRead,BufNewFile *.md set textwidth=80   " wrap lines exceeding 80 chars
"au BufRead,BufNewFile *.txt set textwidth=80   " wrap lines exceeding 80 chars

autocmd FileType scss setl iskeyword+=@-@
autocmd FileType sass setl iskeyword+=@-@

let g:mapleader = ','       " keybinding leader


call plug#begin('~/.config/nvim/plug')

Plug 'vim-airline/vim-airline'                    " airline (bottom bar)
Plug 'ayu-theme/ayu-vim'                          " nord
"Plug 'drewtempelmeyer/palenight.vim'              " palenight
Plug 'chrisbra/Colorizer'                         " highlight colorcodes and names

Plug 'preservim/nerdtree'                         " file manager plugin
Plug 'preservim/nerdcommenter'                    " comments
Plug 'ryanoasis/vim-devicons'                     " add filetype icons

Plug 'neoclide/coc.nvim', {'branch': 'release'}   " Language Server
Plug 'mattn/emmet-vim'                            " Emmet for Vim
Plug 'sheerun/vim-polyglot'                       " language pack
Plug 'dense-analysis/ale'                         " async lint engine
Plug 'editorconfig/editorconfig-vim'              " editorconfig support for vim

Plug 'airblade/vim-gitgutter'                     " git events visualised
Plug 'tpope/vim-fugitive'                         " Git Wrapper

Plug 'vimwiki/vimwiki'                            " vimwiki
"Plug 'abdus/accueil.vim'                          " handles some common tasks
Plug 'Raimondi/delimitMate'                       " close brackets, quotes etc

Plug 'junegunn/fzf'                               " fzf latest binary
Plug 'junegunn/fzf.vim'                           " wrapper for vim-fzf

call plug#end()




"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"         Configs
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" >- Colors and AirLine
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if (has("termguicolors"))
  " set Vim-specific sequences for RGB colors. not required for neovim
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

"colorscheme palenight                         " color theme
"let g:palenight_terminal_italics=1
"let g:airline_theme = "palenight"             " airline theme

let ayucolor="mirage" " dark
colorscheme ayu
let g:airline_theme = "ayu"

"colorscheme nord
"let g:airline_theme = "nord"

" indent line
let g:indentLine_char = ''
let g:indentLine_first_char = ''
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_setColors = 0


"let g:airline_section_b = '%{getcwd()}'           " display cwd in sec-2 of the statusline
let g:airline_powerline_fonts = 1                 " use powerline fonts in airline
let g:airline#extensions#tabline#enabled = 1      " enable upper tabline
let g:airline#extensions#tabline#fnamemod = ':t'  " no idea what this does
let g:airline#extensions#tabline#show_tab_count = 0 " tab count next to filename
let g:airline#extensions#tabline#tab_min_count = 2 " show tabline when >= 2 tabs are open
let g:airline#extensions#tabline#show_splits = 1  " enable the buffer name that displays on the right of the tabline
let g:airline#extensions#tabline#show_tab_nr = 0  " disable tab numbers
let g:airline#extensions#tabline#show_close_button = 0 " remove 'X' at the end of the tabline
let g:airline#extensions#tabline#tabs_label = ''  " can put text here like BUFFERS to denote buffers (I clear it so nothing is shown)
let g:airline#extensions#tabline#formatter =
      \'unique_tail_improved' " upper tabline filename formatter



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" >- Rust
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rustfmt_autosave = 1                    " rust format on save



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" >- polyglot.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:polyglot_disabled = ['']                " disable languages



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-markdown (via polyglot.vim)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vim_markdown_frontmatter = 1      " highlight yaml frontmatter
let g:vim_markdown_toml_frontmatter = 1 " highlight toml frontmatter
let g:vim_markdown_json_frontmatter = 1 " highlight json frontmatter



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" >- ALE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_fixers = {}
let g:ale_fixers.html = ['prettier']
let g:ale_fixers.css = ['prettier']
let g:ale_fixers.markdown = ['prettier']
let g:ale_fixers.json = ['prettier']
let g:ale_fixers.javascript = ['prettier', 'eslint']
let g:ale_fixers.javascriptreact = ['prettier', 'eslint']
let g:ale_fixers.typescript = ['prettier', 'eslint']
let g:ale_fixers.typescriptreact = ['prettier', 'eslint']
let g:ale_fixers.rust = ['rustfmt']
let g:ale_fixers.sh = ['shfmt']
let g:ale_fixers['*'] = ['remove_trailing_lines', 'trim_whitespace']

"let g:ale_linters_ignore = {'javascript': ['eslint']}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" >- vim-wiki.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let wiki_default = {}
let wiki_default.ext = ".md"
let wiki_default.path = "~/vimwiki/"
let wiki_default.syntax = "markdown"
let wiki_default.path_html = "/tmp/vimwiki_html"
let wiki_default.template_ext = ".tpl"
let wiki_default.template_path = "~/vimwiki/templates/"
let wiki_default.template_default = "default"
let wiki_default.custom_wiki2html = "vimwiki_markdown"

let g:vimwiki_list = [wiki_default]
let g:vimwiki_global_ext = 0



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" >- fzf.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:fzf_preview_window = 'right:60%'
let g:fzf_buffers_jump = 1              " jump to existing buffer if possible


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" >- NERDTree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let NERDTreeShowLineNumbers = 1
autocmd FileType nerdtree setlocal relativenumber
:let g:NERDTreeWinSize=40



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" >- Presistent Undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('persistent_undo')
  let storage_dir = expand('~/.cache/vim-presistent-undo/')

  if !isdirectory(storage_dir)
    call system('mkdir -p ' . storage_dir)
  endif

  " point vim to the defined undo dir
  let &undodir = storage_dir

  set undofile
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" >- Autosave Sessions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" create a session based on currently opened directory and save it on vim exit
fu! SessionSave()
  if filewritable(expand('.vim-session.vim'))
    execute 'mksession! .vim-session.vim'
  endif
endfunction

fu! SessionCreate()
  "if !isdirectory(expand("~/.vim/sessions"))
    "execute "call mkdir(expand('~/.vim/sessions', 'p'))"
  "endif
  execute 'mksession .vim-session.vim'
endfunction

fu! SessionRestore()
  let l:session_file = '.vim-session.vim'
  if filereadable(expand(session_file))
    echo session_file
    execute 'source .vim-session.vim'

    if bufexists(1)
      for l in range(1, bufnr('$'))
        if bufwinnr(l) == -1
          exec 'sbuffer ' . l
        endif
      endfor
    endif
  endif
endfunction

autocmd VimLeave * :tabdo NERDTreeClose        " just close that damn thing
autocmd VimLeave * call SessionSave()
autocmd VimEnter * nested call SessionRestore()
command SessCreate call SessionCreate()
set sessionoptions-=options " dont save options


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" >- vim-header
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:header_field_author = 'Abdus S. Azad'
let g:header_field_author_email = 'abdus@abdus.net'
let g:header_auto_add_header = 0 " stop auto-inserting header
let g:header_max_size = 20
let g:header_field_timestamp_format = '%d %B, %Y %H:%M'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" >- coc.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" >- coc.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:GitAddCommit()
    exe "G add %"
    exe "G diff --staged"
    exe "only"
    exe "G commit"
endfunction
:command! GitAddCommit :call s:GitAddCommit()
nnoremap gic :GitAddCommit<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" >- set go template page type
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function DetectGoHtmlTmpl()
    if expand('%:e') == "html" && search("{{") != 0
        set filetype=gohtmltmpl 
    endif
endfunction

augroup filetypedetect
    au! BufRead,BufNewFile * call DetectGoHtmlTmpl()
augroup END





"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"          KEY MAPPING
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" >- Editor
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
inoremap <C-CR> <CR><Esc>kA<CR>|    " indented newline on Ctrl + Enter
inoremap ii <esc>|                  " use ii to exit modes
" inoremap <C-b> <esc>lce

nnoremap
      \ <silent><expr> <Leader>H
      \ (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"| " toggle highlight


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" >- Buffer and Tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <F5> :bp<CR>|                           " move to previous buffer
map <F6> :bn<CR>|                           " move to next buffer
map <Leader>bd :bdelete<CR>|                " delete current buffer

map <F7> :tabp<CR>|                         " move to previous tab
map <F8> :tabn<CR>|                         " move to next tab
map <Leader>tc :tabclose<CR>|               " close current tab


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" >- moving around
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" >- Emmet
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType html,css imap <expr> <Tab> emmet#expandAbbrIntelligent("\<tab>")



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" >- ALE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <Leader>a :ALEFix<CR>



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" >- Disable Arrow keys and PageUp PageDown
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <left>  :echo "press 'h'"<CR>
nnoremap <right> :echo "press 'l'"<CR>
nnoremap <up>    :echo "press 'k'"<CR>
nnoremap <down>  :echo "press 'j'"<CR>
nnoremap <PageDown> :echo "ctrl f = 1 pg down       ctrl d = 1/2 pg down"<CR>
nnoremap <PageUp>   :echo "ctrl b = 1 pg up         ctrl u = 1/2 pg up"<CR>

vnoremap <left>  :echo "press 'h'"<CR>
vnoremap <right> :echo "press 'l'"<CR>
vnoremap <up>    :echo "press 'k'"<CR>
vnoremap <down>  :echo "press 'j'"<CR>
vnoremap <PageDown> :echo "ctrl f = 1 pg down       ctrl d = 1/2 pg down"<CR>
vnoremap <PageUp>   :echo "ctrl b = 1 pg up         ctrl u = 1/2 pg up"<CR>

inoremap <left>  <nop>
inoremap <right> <nop>
inoremap <up>    <nop>
inoremap <down>  <nop>
inoremap <PageDown> <esc>:echo "ctrl f = 1 pg down       ctrl d = 1/2 pg down"<CR>
inoremap <PageUp>   <esc>:echo "ctrl b = 1 pg up         ctrl u = 1/2 pg up"<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" >- Text Operations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap vA ggVG|               " select all
nnoremap <S-s> <esc>:w<CR>|     " quick save



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" >- NERDTree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <C-n> :NERDTreeToggle<CR>|    " Opens up NerdTree
map <C-m> :NERDTreeMirror<CR>|    " mirror available nerdtree instance



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" >- FZF
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <space>F :FZF<CR>|             " open fuzzy search
nnoremap <space>f :Filetypes<CR>|       " open filetype window
nnoremap <space><space> :Buffers<CR>|   " open fuzzy search



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" >- coc.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"typescript.validate.enable": false,
"javascript.validate.enable": false,



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" >- Others
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <Leader>n :set relativenumber!<CR>|    " toggle relative numbers
