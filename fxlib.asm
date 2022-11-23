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


.code

nota macro freqe, tempoe

                mov   dx, freqe
                mov   si,tempoe

                call note

endm

main proc
    ;printar linha (de qlq ponto a qualquer ponto)
    ;printar quadrado
    ;printar quadrado vazio
    ;printar circulo
    ;printar circulo vazio

        mov ax,@data
        mov ds,ax
        xor ax,ax
        volta:
           nota re2,3
           nota 0,1
           nota re2,4
           nota re3,7
           nota 0,1
           nota la2,10
           nota 0,1
           nota sols2,7
           nota sol2,7
           nota fa2,7
           nota re2,4
           nota fa2,3
           nota sol2,3

           nota do2,3
           nota 0,1
           nota do2,4
           nota re3,7
           nota 0,1
           nota la2,10
           nota 0,1
           nota sols2,7
           nota sol2,7
           nota fa2,7
           nota re2,4
           nota fa2,3
           nota sol2,3

           nota si1,3
           nota 0,1
           nota si1,4
           nota re3,7
           nota 0,1
           nota la2,10
           nota 0,1
           nota sols2,7
           nota sol2,7
           nota fa2,7
           nota re2,4
           nota fa2,3
           nota sol2,3

           nota las1,3
           nota 0,1
           nota las1,4
           nota re3,7
           nota 0,1
           nota la2,10
           nota 0,1
           nota sols2,7
           nota sol2,7
           nota fa2,7
           nota re2,4
           nota fa2,3
           nota sol2,3
           jmp volta


          



           mov  ah,4CH
           int  21h


main endp
note proc
    ;transformar em macro mov al,182  ;manda o codigo de speaker para al
           out  43h, al      ;manda o codigo do speaker para o a porta 43h
           mov  ax,dx        ;envia a frequencia em decimal do numero pra ser output

           out  42h,al       ;transformar em macro
           mov  al,ah        ;manda valor da frequencia para a porta 42h
           out  42h,AL

           in   al,61h

           or   al,011b
           out  61h,AL
           mov  bx,si

    pause1:
           mov  cx,65535
    pause2:
           dec  cx
           jne  pause2
           dec  bx
           jne  pause1
           in   al,61h

           xor  al,0FH
           out  61h,al

           ret
    
note endp
end main