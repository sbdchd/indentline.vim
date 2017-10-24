# indentline.vim
> Sublime indent lines for vim

`indentline.vim` is a fork of [indentLine][0] with a focus on having as few
features and config options as possible.

## Install

```viml
Plug 'sbdchd/indentline.vim'
```

## Usage

Note: indentline is enabled by default

```
:IndentlineEnable
:IndentlineDisable
:IndentlineRefresh
```

## Config

```viml
" config vars with default values
let g:indentline_ignored_filetypes = ['help', 'man']
let g:indentline_ignored_buftypes = ['terminal']
let g:indentline_char = '¦'
let g:indentline_max_indent_level = 20
```

[0]: https://github.com/Yggdroot/indentLine

## License

MIT
