if exists("g:loaded_cool")
    finish
endif
let g:loaded_cool = 1

let s:save_cpo = &cpo
set cpo&vim

augroup Cool
    autocmd!
augroup END

" toggle coolness when hlsearch is toggled
autocmd Cool OptionSet hlsearch call <SID>PlayItCool(v:option_old, v:option_new)

function! s:StartHL()
    let current_mode_not_normal = luaeval('require("cool").current_mode_not_normal()')
    if !v:hlsearch || current_mode_not_normal
        return
    endif
    let pos = winsaveview()
    let rpos = getpos('.')
    silent! exe "keepjumps go".(line2byte('.')+col('.')-(v:searchforward ? 2 : 0))
    try
        silent keepjumps norm! n
        if getpos('.') != rpos
            throw 0
        endif
    catch /^\%(0$\|Vim\%(\w\|:Interrupt$\)\@!\)/
        call <SID>StopHL()
        return
    finally
        call winrestview(pos)
    endtry
endfunction

function! s:StopHL()
    let current_mode_not_normal = luaeval('require("cool").current_mode_not_normal()')
    if !v:hlsearch || current_mode_not_normal
        return
    endif

    silent call feedkeys("\<Plug>(StopHL)", 'm')
endfunction

function! s:PlayItCool(old, new)
    if a:old == 0 && a:new == 1
        " nohls --> hls
        "   set up coolness
        call luaeval('require("cool").set_mapping()')
        noremap! <expr> <Plug>(StopHL) execute('nohlsearch')[-1]

        autocmd Cool CursorMoved * call <SID>StartHL()
        autocmd Cool InsertEnter * call <SID>StopHL()
    elseif a:old == 1 && a:new == 0
        " hls --> nohls
        "   tear down coolness
        nunmap <Plug>(StopHL)
        unmap! <expr> <Plug>(StopHL)

        autocmd! Cool CursorMoved
        autocmd! Cool InsertEnter
    else
        " nohls --> nohls
        "   do nothing
        return
    endif
endfunction

" play it cool
call <SID>PlayItCool(0, &hlsearch)

let &cpo = s:save_cpo

" vim: shiftwidth=4
