---
title: 'VIM Configuration'
media_order: 'asm.vim,grb256.vim,cSyntaxAfter.vim,nasm.vim'
process:
    markdown: true
    twig: true
author: 'M. Kasim'
---

I am using the VIM editor while writing small codes. If you are using VIM as well, the following syntax highlighting and compiler output configurations might be useful. **If you do not use the VIM editor, skip this**.

## Syntax Highlighting
_[grb256.vim](grb256.vim)_
This file contains some color labels to be used in the syntax files. Save this file to `~./vim/colors`.

_[cSyntaxAfter.vim](cSyntaxAfter.vim)_
This file contains some syntax highlighting options for C based languages such as C/++ and java. Save this file to `~/.vim/plugin`.

_[asm.vim](asm.vim)_
This file contains some basic highlighting for assembling in the intel syntax in NASM. Save this file to `~./vim/after/syntax`.


## Syntastic
Syntastic is the plugin which highlightens compiler errors on save within the VIM editor. This helps alot for debugging and saves the trouble to manually run the compiler after each edit just to look for compiler errors. The following steps are taken from the `readme.markdown` file in [vim-syntastic@github](https://github.com/vim-syntastic/syntastic).

### Step 1: Install pathogen.vim
Run the following command in the CLI
```sh
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
```


### Step 2: Install syntastic as a Pathogen bundle
You now have pathogen installed and can put syntastic into `~/.vim/bundle` like
this:
```sh
cd ~/.vim/bundle && \
git clone --depth=1 https://github.com/vim-syntastic/syntastic.git
```
Quit vim and start it back up to reload it, then type:
```vim
:Helptags
```
If you get an error when you do this, then you probably didn't install
[Pathogen][pathogen] right. Go back to [Step 1](#step1) and make sure you did the
following:

1. Created both the `~/.vim/autoload` and `~/.vim/bundle` directories.
2. Added the `execute pathogen#infect()` line to your `~/.vimrc` file
3. Did the `git clone` of syntastic inside `~/.vim/bundle`
4. Have permissions to access all of these directories.


### Enable NASM Checker
Now we will enable NASM to be used as the checker for `.asm` files. To do so, I have just copied the syntax checker in `~/.vim/bundle/syntastic/syntax_checkers/nasm` edited it to the resulting `nasm.vim` below.

_[nasm.vim](nasm.vim)_
This file is the `.asm` syntax checker for Syntastic. Save this file into `~/.vim/bundle/syntastic/syntax_checkers/asm/`.

!!! NOTE: If you are compiling for another system than x86 Linux, you might want to change the line `'args_after': '-f elf -X gnu'` to match your system.

## vimrc Configuration
Now open the `.vimrc` config file with the following command:
```sh
$ vim ~/.vimrc
```

Then add the following lines to the file:

```vim
execute pathogen#infect()

colorscheme grb256
autocmd! FileType c,cpp,php call CSyntaxAfter()

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

let g:syntastic_c_checkers = ['gcc']
let g:syntastic_asm_checkers = ['nasm']
```


## Comments
You may leave comments and/or suggestions here.
{{ jscomments()|raw }}




