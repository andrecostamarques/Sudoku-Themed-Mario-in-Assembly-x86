.model small
.stack 100h
.data

    linha equ 3
    coluna equ 3

    matriz1 db linha dup(coluna dup(''))
    matriz2 db linha dup(coluna dup(''))
    matrizresultado db linha dup(coluna dup(''))

    offsetm1 dw ?
    offsetm2 dw ?
    offsetresultado dw ?
    
.code
main PROC
    mov ax,@data
    mov ds,dx

    lea bx,matriz1
    call ler

    
main ENDP

ler PROC
    
    mov cx,linha ;(funciona como loop)
    mov ah,01 ;pega valor
    pulalinha:
    xor si,si ;reseta si
    mov di,coluna ;manda coluna pra di
    pulacoluna:
    int 21h; recebe o valor em al
    add al,30h ;transforma em char
    mov [bx][si],al ;manda oq ta em al 
    inc si ;aumenta o valor da coluna
    dec di ;decrementa o contador de coluna
    jnz pulacoluna
    add bx,coluna
    loop pulalinha;
    ret

ler ENDP

soma PROC
    
soma ENDP
END main