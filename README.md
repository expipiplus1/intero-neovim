# `intero-neovim`

Currently provides (primitive) type at point, evaluation, and module loading.
I have no idea what I am doing with vimscript, so if you know what's up, let's
collaborate!

## Installing

This plugin should be pathogen, vundle, etc. compatible.

## Usage

This plugin provides an integration with Intero via Neovim's terminal and
asynchronous job control. You might like the following shortcuts:

```
nnoremap <Leader>hio :InteroOpen<CR>
nnoremap <Leader>hik :InteroKill<CR>
nnoremap <Leader>hic :InteroHide<CR>
nnoremap <Leader>hil :InteroLoadCurrentModule<CR>
nnoremap <Leader>hie :InteroEval<CR>
nnoremap <Leader>hit :InteroType<CR>
```

The following commands are available:

### `InteroEval`

This prompts the user to input a string, which gets sent to the REPL and
evaluated by Intero.

### `InteroType`

This gets the type at the current point.

### `InteroLoadCurrentModule`

This loads the current module.

### `InteroOpen`

Opens the Intero terminal buffer.

### `InteroHide`

Hides the Intero buffer without killing the process.

### `InteroStart`

This starts an Intero process connected to a `terminal` buffer. It's hidden at
first.

### `InteroKill`

Kills the Intero process and buffer.

## License

[BSD3 License](http://www.opensource.org/licenses/BSD-3-Clause), the same license as ghcmod-vim.
