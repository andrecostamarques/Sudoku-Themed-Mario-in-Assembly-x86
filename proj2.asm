.model small
LINHA MACRO x,y,tam,cor
    LOCAL LINHAV

    MOV BL, tam
    MOV AH, 0CH
    MOV AL, cor
    MOV CX, x
    PUSH CX
    MOV DX, y
    PUSH DX
    LINHAV:
        int 10H
        INC CX
        DEC BL
        JNZ LINHAV
    
    POP DX
    POP CX

    ENDM

COLUNA MACRO xc,yc,tamc,corc
    LOCAL COLUNAV
    MOV BL, tamc
    MOV AH, 0CH
    MOV AL, corc
    MOV CX, xc
    PUSH CX
    MOV DX, yc
    PUSH DX
    COLUNAV:
        int 10H
        INC DX
        DEC BL
        JNZ COLUNAV
    
    POP DX
    POP CX

ENDM





INTERFACE MACRO xmais, ymais,color
    LOCAL PRINTAL, PRINTAC
    MOV CX, xmais
    MOV DX, ymais

    ADD CX, 170
    ADD DX, 15
    PUSH CX
    PUSH DX

    PRINTAL:
        LINHA CX, DX, 135, color
        ADD DX, 15
        CMP DX, 165
        JB PRINTAL

    POP DX
    POP CX

    PRINTAC:
        COLUNA CX, DX, 135, color
        ADD CX, 15                                                                                                                                                                                                                                                                                       
        CMP CX, 320
        JB PRINTAC
    
ENDM
        


.stack 100h
.data
    x dw 0
    y dw 0
    xmais dw 0
    ymais dw 0
    tam db 0
    cor db 0

.code
    main PROC
        MOV AH, 0
        MOV AL, 13
        INT 10H 

        MOV AH, 0BH
        MOV BH, 0
        MOV BL, 0FH
        INT 10H

        MOV AH, 0CH
        MOV AL, 8

        INTERFACE 0,0,8

        MOV AH, 4CH
        INT 21H

    main ENDP

delay proc
    PUSH CX
    MOV CX, 035H
    REPETE: 
        PUSH CX
        MOV CX, 0F90H
    DECREMENTA: 
            DEC CX
            JNZ DECREMENTA
            POP CX
            DEC CX
            JNZ REPETE
            POP CX
    RET
        
delay endp


end main