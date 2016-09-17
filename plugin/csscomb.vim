"=============================================================================
" File: csscomb.vim
" Author: Aleksandr Batsuev (alex@batsuev.com)
" WebPage: https://github.com/batsuev/csscomb-vim
" License: MIT

let g:CSScombPluginDir = fnamemodify(expand("<sfile>"), ":h")

function! g:CSScomb(count, line1, line2)
    let content = getline(a:line1, a:line2)

    let tempFile = tempname() . '.' . &filetype
    call writefile(content, tempFile)
    let systemOutput = system('csscomb -c ~/.csscomb.json ' . shellescape(tempFile))
    if len(systemOutput)
        echoerr split(systemOutput, "\n")[1]
    else
        let lines = readfile(tempFile)
        if len(lines)<a:line2
            let dline = len(lines)+1
            exec dline.','.a:line2.'d_'
        endif
        call setline(a:line1, lines)
    endif
endfunction

command! -nargs=? -range=% CSScomb :call g:CSScomb(<count>, <line1>, <line2>, <f-args>)
