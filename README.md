# `intero-neovim`

Currently provides (primitive) type at point, evaluation, and module loading.
I have no idea what I am doing with vimscript, so if you know what's up, let's
collaborate! PRs, issues, and random feedback are all welcome.

## Installing

This plugin should be pathogen, vundle, etc. compatible. However, while that's
the case, I recommend cloning this repository and managing it yourself. It's
not stable at all, and you don't want this changing out from under you.

After you've installed the plugin, it'll keep your `intero` installs setup for
you. I recommend adding `intero-0.1.16` to your `stack.yaml` build-depends to
ensure you get the newer version.

![Demo of Installation](demo-install-lo.gif)

## Usage

This plugin provides an integration with Intero via Neovim's terminal and
asynchronous job control. You might like the following shortcuts:

```
" Process management:
nnoremap <Leader>hio :InteroOpen<CR>
nnoremap <Leader>hik :InteroKill<CR>
nnoremap <Leader>hic :InteroHide<CR>
nnoremap <Leader>hil :InteroLoadCurrentModule<CR>

" REPL commands
nnoremap <Leader>hie :InteroEval<CR>
nnoremap <Leader>hit :InteroType<CR>
nnoremap <Leader>hit :InteroGenericType<CR>
nnoremap <Leader>hii :InteroInfo<CR>
```

![REPL demo](demo-repl-lo.gif)

The following commands are available:

### `InteroEval`

This prompts the user to input a string, which gets sent to the REPL and
evaluated by Intero.

### `InteroResponse`

This retrieves the last thing that was evaluated by `intero`.

### `InteroGenericType`

This gets the type at the current point.

### `InteroType`

This gets the type at the current point without generalizing the term.

### `InteroLoadCurrentModule`

This loads the current module. Should not be necessary if you're using 0.1.16 version of Intero.

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
