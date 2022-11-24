.model small
.stack 100h
.data
    do1   dw 9121
    dos1  dw 8609
    re1    dw 8126
    res1  dw 7670
    mi1   dw 7239
    fa1   dw 6833
    fas1  dw 6449
    sol1   dw 6087
    sols1  dw 5746
    la1   dw 5423
    las1  dw 5119
    si1   dw 4831
    do2   dw 4560
    dos2  dw 4304
    re2   dw 4063
    res2  dw 3834
    mi2   dw 3619
    fa2   dw 3416
    fas2  dw 3224
    sol2   dw 3043
    sols2  dw 2873
    la2   dw 2711
    las2  dw 2559
    si2   dw 2415
    do3   dw 2280
    dos3  dw 2152
    re3   dw 2031
    res3  dw 1917
    mi3   dw 1809
    fa3   dw 1715
    fas3  dw 1612
    sol3   dw 1521
    sols3  dw 1436
    la3   dw 1355
    las3  dw 1292
    si3   dw 1207
    do4   dw 1140
    contador db ?


.code

nota macro freqe, tempoe

    mov   dx, freqe
    mov   si,tempoe

    call note

endm

pausa macro
    nota 0,1
endm

main proc
    ;printar linha (de qlq ponto a qualquer ponto)
    ;printar quadrado
    ;printar quadrado vazio
    ;printar circulo
    ;printar circulo vazio

    mov ax,@data
    mov ds,ax
    xor ax,ax   ;inicializa a data
    
    ;a partir daqui é só dar call nas musicas que quer

    call zelda
    call megalovania

    mov  ah,4CH
    int  21h


main endp

note proc
    ;transformar em macro mov al,182  ;manda o codigo de speaker para al
    out  43h, al      ;manda o codigo do speaker para o a porta 43h
    mov  ax,dx        ;envia a frequencia em decimal do numero pra ser output

    out  42h,al       ;transformar em macro
    mov  al,ah        ;manda valor da frequencia para a porta 42h
    out  42h,AL       ;manda o high bit de ax pra porta do speaker

    in   al,61h       ;a porta 61 é enviada para ser input 

    or   al,03h         ;manda bits com valores de 1 para al para que ele toque
    out  61h,AL         ;manda o novo valor de al para que toque
    mov  bx,si          ;duracao da nota 

pause1:
    mov  cx,65535       ;contador de clocks para quantidade de tempo que o beep vai tocar indefinidamente
pause2:
    dec  cx             ;decrementa o contador
    jne  pause2
    dec  bx             ;decremnta o contador do timing que a gnt definiu
    jne  pause1         ;se o nosso contador esvaziar vai parar o bit
    in   al,61h         ;continua tocando o bit

    xor  al,0FH         ;para o contador
    out  61h,al         ;tem output de valor 0

    ret

note endp


megalovania proc

    mov contador,2

volta:
        nota re2,3
        pausa
        nota re2,4
        nota re3,7
        pausa
        nota la2,10
        pausa
        nota sols2,7
        nota sol2,7
        nota fa2,7
        nota re2,4
        nota fa2,3
        nota sol2,3

        nota do2,3
        pausa
        nota do2,4
        nota re3,7
        pausa
        nota la2,10
        pausa
        nota sols2,7
        nota sol2,7
        nota fa2,7
        nota re2,4
        nota fa2,3
        nota sol2,3

        nota si1,3   
        pausa
        nota si1,4
        nota re3,7
        pausa
        nota la2,10
        pausa
        nota sols2,7
        nota sol2,7
        nota fa2,7
        nota re2,4
        nota fa2,3
        nota sol2,3

        nota las1,3
        pausa
        nota las1,4
        nota re3,7
        pausa
        nota la2,10
        pausa
        nota sols2,7
        nota sol2,7
        nota fa2,7
        nota re2,4
        nota fa2,3
        nota sol2,3

    dec contador
    cmp contador,0

    jne not_equal
    ret

    not_equal:
    jmp volta

megalovania endp
zelda proc

   mov contador,2

volta1:
    nota la1,15
    nota mi1,10
    pausa
    nota la1,5
    pausa
    nota la1,5
    nota si1,3
    nota dos2,3
    nota re2,3
    nota mi2,15
    pausa
    nota mi2,5
    pausa
    nota mi2,5
    nota fa2,5
    nota sol2,3
    nota la2,13
    pausa
    nota la2,5
    pausa 
    nota la2,5 ;comeca a descer
    nota sol2,3
    nota fa2,3
    nota sol2,3
    pausa
    nota fa2,5
    pausa
    nota mi2,20
    pausa
    nota mi2,5
    pausa 
    nota mi2,5
    nota re2,5
    pausa 
    nota re2,5
    nota mi2,3
    nota fa2,15
    nota mi2,5
    nota re2,5
    nota do2,4
    pausa
    nota do2,5
    nota re2,5
    nota mi2,10
    pausa
    nota re2,5
    nota do2,5
    nota si1,5
    pausa
    nota si1,3
    pausa
    nota si1,5
    nota dos2,5
    nota res2,10
    nota fas2,13
    nota mi2,10
    nota mi1,3
    pausa
    nota mi1,3
    pausa
    nota mi1,3
    pausa
    nota mi1,3
    pausa
    nota mi1,1
    pausa
    nota mi1,15
    pausa

    dec contador
    cmp contador,0

    jne not_equal1
    ret

    not_equal1:
    jmp volta1

zelda endp

end main