TITLE ANDRE MARQUES 22001640 ENZO SOUZA 22006135

.model small
.stack 100h

pushall MACRO
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI
    
ENDM

popall MACRO
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX

ENDM

linha MACRO xl,yl,taml,corl
    LOCAL VOLTAL
    pushall
    MOV BX, tamL
    INC BX
    MOV CX, xl  
    MOV DX, yl 
    MOV AL, corl 
    VOLTAL:
        pixels AL, CX, DX
        INC CX  
        dec BX
        jnz VOLTAL
    popall
ENDM

coluna MACRO xc, yc, tamc, corc
    LOCAL VOLTAC
    pushall
    MOV BX, tamc 
    INC BX
    MOV CX, xc
    MOV DX, yc
    MOV AL, corc
    VOLTAC:
        pixels AL, CX, DX
        INC DX
        DEC BX
        JNZ VOLTAC 

    popall
ENDM

dly MACRO tempo
    LOCAL DELAYVOLTA 

    PUSH AX
    MOV AX, tempo
    DELAYVOLTA:
        CALL DELAY
        DEC AX
        JNZ DELAYVOLTA

    POP AX
ENDM

sobe MACRO
    LOCAL CONTINUAL, FIMLS
    lepixelL
    cmp res, 0
    JZ CONTINUAL
    JMP FIMLS
    CONTINUAL:
    ADD gy, 15
    LINHA gx, gy, 15, 0
    SUB gy, 16
    pixelart gx, gy, gtam, cogu2, gvezes

    FIMLS:
ENDM

desce MACRO 
    LINHA gx, gy, 15, 0
    INC gy
    pixelart gx, gy, gtam, cogu2, gvezes
ENDM

andadireita MACRO
    LOCAL FIMAD, CONTINUAAD
    lepixelcd
    cmp res, 0
    JZ CONTINUAAD
    JMP FIMAD 

    CONTINUAAD:
        coluna gx, gy, 15, 0
        INC gx
        pixelart gx, gy, gtam, cogu2, gvezes

    FIMAD:
ENDM

andaesquerda MACRO
    LOCAL FIMAE, CONTINUAAE
    lepixelce
    cmp res, 0
    JZ CONTINUAAE
    JMP FIMAE

    CONTINUAAE:
        ADD gx, 15
        coluna gx, gy, 15, 0
        SUB gx, 16
        pixelart gx, gy, gtam, cogu2, gvezes
    FIMAE:
ENDM

pixelart MACRO xa,ya,tama,pixdata,vezes
    LOCAL ARTCOLUNA, ARTLINHA, RETORNA

    pushall
    limpall
    MOV AX, tama
    MOV CX, xa
    MUL AX 
    MOV DI, AX
    MOV DX, ya

    ARTCOLUNA:
        PUSH DI 
        MOV DI, vezes 
        ARTLINHA:
            MOV AX, vezes
            RETORNA:
                pixels pixdata[BX][SI], CX, DX
                INC CX 
                DEC AX
                JNZ RETORNA
                INC SI
                CMP SI, tama
                JB ARTLINHA
                INC DX 
                MOV CX, xa
                XOR SI, SI
                DEC DI
                JNZ ARTLINHA

                POP DI 

                ADD BX, tama
                CMP BX, DI
                JB ARTCOLUNA
    popall
ENDM

pixels MACRO corpix, xp, yp
    pushall
    PUSH BX

    MOV AH, 0CH 
    MOV BH, 0
    MOV AL, corpix 
    MOV CX, xp
    MOV DX, yp
    int 10H

    POP BX 

    popall
ENDM

m MACRO
    PUSH AX
    PUSH BX
    MOV AX, 5
    MOV BX, 0
    INT 33H

    CMP BX, 0
    JZ FIMM
    JMP FIMMARIO
    FIMM: 
    POP BX
    POP AX

ENDM

limpall MACRO 
    XOR AX, AX
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX
    XOR SI, SI
    XOR DI, DI
ENDM




interface MACRO xi,yi,tami,cori

    pushall
    MOV AX, tami 
    MOV CL, 9
    DIV CL 

    MOV BL, AL
    MOV CX, xi
    MOV DX, yi
    MOV AH, 10
    MOV AL, cori

    pushall
    COLUNAI:
        PUSH BX
        MOV BX, tami 
        coluna CX, DX, BX, AL
        POP BX
        ADD CX, BX
        DEC AH
        JNZ COLUNAI
    popall

    pushall 
    LINHAI:
        PUSH BX
        MOV BX, tami 
        linha CX, DX, BX, AL
        POP BX
        ADD DX, BX
        DEC AH
        JNZ LINHAI

    popall
ENDM 

lepixel MACRO
    LOCAL LEPVOLTA, FIMLP, PASSA
    pushall
    limpall 
    MOV res1, 0
    MOV AH, 0DH
    MOV BH, 0

    MOV CX, gx
    MOV DX, gy

    ADD DX, 16
    MOV BL, 15

    LEPVOLTA:
        INT 10H
        CMP AL, 0
        JE PASSA
        MOV res1, 1
        JMP FIMLP
        PASSA:
        INC CX
        DEC BL
        JNZ LEPVOLTA
        
    FIMLP:

    popall
ENDM
lepixelL MACRO
    LOCAL LEPVOLTAL, FIMLPL, PASSAL
    pushall
    MOV res, 0
    MOV AH, 0DH
    MOV BH, 0

    MOV CX, gx
    MOV DX, gy

    DEC DX 
    MOV BL, 16

    LEPVOLTAL:
        INT 10H
        CMP AL, 0
        JE PASSAL
        MOV res, 1
        JMP FIMLPL
        PASSAL:
        INC CX
        DEC BL
        JNZ LEPVOLTAL
        
    FIMLPL:

    popall
ENDM

printasudoku MACRO matsudoku, xps, yps, corsu
    LOCAL VOLTAPS1, VOLTAPS2, PULAPS
    pushall
    XOR SI,SI
    MOV CH, yps
    MOV CL, xps
    MOV AL, 9
    VOLTAPS1:
        MOV AH, 9
        ADD Ch, 2
        MOV Cl, xps
        VOLTAPS2:
            posicursor CH, CL
            CMP matsudoku[SI], 'F'
            JE PULAPS
            printacaracter corsu, matsudoku[SI]
            PULAPS:
            ADD CL, 2
            INC SI
            DEC AH
            JNZ VOLTAPS2
            DEC AL
            JNZ VOLTAPS1
    popall 
ENDM


lepixelCD MACRO 
    LOCAL LEPVOLTAC, PASSAC, FIMLPC
    pushall
    MOV res, 0
    MOV AH, 0DH
    MOV BH, 0

    MOV CX, gx
    MOV DX, gy

    ADD CX, 16
    MOV BL, 16

    LEPVOLTAC:
        INT 10H
        CMP AL, 0
        JE PASSAC
        MOV res, 1
        JMP FIMLPC
        PASSAC:
        INC DX
        DEC BL
        JNZ LEPVOLTAC
        
    FIMLPC:

    popall
ENDM

lepixelCE MACRO 
    LOCAL LEPVOLTACE, PASSACE, FIMLPCE
    pushall
    MOV res, 0
    MOV AH, 0DH
    MOV BH, 0

    MOV CX, gx
    MOV DX, gy

    DEC CX 
    MOV BL, 16

    LEPVOLTACE:
        INT 10H
        CMP AL, 0
        JE PASSACE
        MOV res, 1
        JMP FIMLPCE
        PASSACE:
        INC DX
        DEC BL
        JNZ LEPVOLTACE
        
    FIMLPCE:

    popall
ENDM

posicursor MACRO xcu, ycu
    pushall
    MOV AH, 02H
    MOV BH, 0
    MOV DH, xcu
    MOV DL, ycu
    INT 10H
    popall
ENDM

printacaracter MACRO corl, letra
    pushall

    MOV AL, letra
    MOV AH, 09
    MOV BL, corl
    XOR BH, BH
    MOV CX, 1
    INT 10H
    popall
ENDM

string MACRO str, tamstr, xstr,ystr,corstr
    LOCAL STRINGVOLTA
    pushall
    MOV CH, ystr
    MOV CL, xstr
    MOV DL, tamstr
    LEA BX, str
    STRINGVOLTA:
        
        posicursor CH, CL

        MOV AL, [BX]

        printacaracter corstr, AL

        INC BX 

        INC CL

        DEC DL
        JNZ STRINGVOLTA

    popall
ENDM

limpainicio MACRO 
    string newg, 6, 27, 10,0
    string bonus, 6, 7, 10,0
    string cred, 9, 16, 10,0
    pixelart 64, 149, 16,limpa, 2
    pixelart 144, 149, 16,limpa, 2
    pixelart 224, 149, 16,limpa, 2
    linha 0, 180, 320, 8      

ENDM

cai MACRO 
    LOCAL CONTIDESCE, DESCEVOLTA, PROSSEGUEDESCE, FIMCIMA, CONTINUACAI
    pushall 
    XOR AX, AX
    XOR BX, BX
    CONTIDESCE:
            MOV AL, BL
            DESCEVOLTA:
                lepixel
                CMP res1, 0
                JZ CONTINUACAI
                JMP FIMCIMA
                CONTINUACAI:
                desce
                INC AL
                CMP AL, BL
                JNB PROSSEGUEDESCE
                JMP DESCEVOLTA

            PROSSEGUEDESCE:
                INC BL
                JMP CONTIDESCE 

    FIMCIMA: 
    popall 
ENDM

conferenum MACRO
    LOCAL SIMNUM
    CMP AL, '1'
    JE SIMNUM
    CMP AL, '2'
    JE SIMNUM
    CMP AL, '3'
    JE SIMNUM
    CMP AL, '4'
    JE SIMNUM
    CMP AL, '5'
    JE SIMNUM
    CMP AL, '6'
    JE SIMNUM
    CMP AL, '7'
    JE SIMNUM
    CMP AL, '8'
    JE SIMNUM
    CMP AL, '9'
    JE SIMNUM
    JMP NAONUM

    SIMNUM:
    JMP SIMNUM2
    NAONUM:
    string numinv, 15, 2, 18, 0CH
    string numinv1, 15,2, 19, 0CH 

    JMP @VOLTASU
    SIMNUM2:

ENDM


nota macro freqe, tempoe
    LOCAL FIMM
    PUSH AX
    PUSH BX
    MOV AX, 5
    MOV BX, 0
    INT 33H

    ;call pegar_si; pegue o si daqui

    CMP BX, 0
    JZ FIMM

    SHR CX, 1
    POP BX
    POP AX
    JMP @FIMMARIO
    FIMM: 
    POP BX
    POP AX
    mov   dx, freqe
    mov   si,tempoe

    call note

endm

pausa macro
    nota 0,1
endm

printaerro MACRO erroN
    pushall
    string erros, 6, 3, 11, 8 
    posicursor 11, 10
    printacaracter 8, erroqnt
    string erros2, 2, 11, 11, 8 


ENDM

telainicio MACRO 
    pixelart 64, 149, 16, cano, 2
    pixelart 224, 149, 16, cano, 2
    linha 0, 180, 320, 8
    linha 0, 181, 320, 0AH
    linha 0, 182, 320, 0AH
    linha 0, 183, 320, 8
    MOV AX, 183
    MOV CL, 16
    TERRAVOLTA:
        INC AX
        linha 0, AX, 320, 6
        DEC CL
        JNZ TERRAVOLTA

    string newg, 6, 27, 10, 9
    string bonus, 6, 7, 10, 9
ENDM
botaom MACRO corbot, xbi,ybi, xbf,ybf
    LOCAL VOLTABOTAO2
    pushall
    MOV CX, xbi
    MOV DX, ybi
    VOLTABOTAO2:
        pixels corbot, CX, DX
        INC CX 
        CMP CX, xbf
        JBE VOLTABOTAO2
        INC DX
        MOV CX, xbi
        CMP DX, ybf
        JBE VOLTABOTAO2


    popall 
ENDM 

esperavalor MACRO xev, yev
    
ENDM
.data 



    cogu2 DB 5 DUP (0), 6 DUP (8), 5 DUP (0)
          DB 3 DUP (0), 3 DUP (8), 0FH, 2 DUP (0CH), 0FH, 3 DUP (8), 3 DUP (0)
          DB 2 DUP (0), 2 DUP (8), 3 DUP (0FH), 2 DUP (0CH), 3 DUP (0FH), 2 DUP (8), 2 DUP (0)
          DB 0, 2 DUP (8), 0CH, 2 DUP (0FH), 4 DUP (0CH), 2 DUP (0FH), 0CH, 2 DUP (8), 0
          DB 0, 8, 0FH, 10 DUP (0CH), 0FH, 8, 0
          DB 2 DUP (8), 2 DUP(0FH), 2 DUP (0CH), 4 DUP (0FH), 2 DUP (0CH), 2 DUP (0FH), 2 DUP (8)
          DB 8, 3 DUP (0FH), 0CH, 6 DUP (0FH), 0CH, 3 DUP (0FH), 8
          DB 8, 3 DUP (0FH), 0CH, 6 DUP (0FH), 0CH, 3 DUP (0FH), 8
          DB 8, 3 DUP (0FH), 0CH, 6 DUP (0FH), 0CH, 3 DUP (0FH), 8
          DB 8, 2 DUP (0FH), 2 DUP (0CH), 6 DUP (0FH), 2 DUP (0CH), 2 DUP (0FH), 8
          DB 8, 5 DUP (0CH), 4 DUP (0FH), 5 DUP (0CH), 8
          DB 8, 2 DUP (0CH), 10 DUP (8), 2 DUP (0CH), 8
          DB 4 DUP (8), 2 DUP (0FH), 8, 2 DUP (0FH), 8, 2 DUP (0FH), 4 DUP (8)
          DB 0, 2 DUP (8), 3 DUP (0FH), 8, 2 DUP (0FH), 8, 3 DUP (0FH), 2 DUP (8), 0
          DB 2 DUP (0), 2 DUP (8), 8 DUP (0FH), 2 DUP (8), 2 DUP (0)
          DB 3 DUP (0), 10 DUP (8), 3 DUP (0) 

    cano DB 16 DUP (8)
         DB 8, 14 DUP (0DH), 8
         DB 8, 0DH, 0DH, 2 DUP (0FH), 3 DUP (0DH), 3 DUP (2), 0DH, 2, 0DH, 2, 8
         DB 8, 0DH, 0DH, 0FH, 0FH, 2 DUP (0DH), 0DH, 2, 2, 0DH, 2, 2 DUP (0DH), 2, 8
         DB 8, 0DH, 0DH, 0FH, 0FH, 2 DUP (0DH), 0DH, 2, 2, 2, 0DH, 2, 0DH, 2, 8
         DB 8, 0DH, 0DH, 0FH, 0FH, 2 DUP (0DH), 0DH, 2, 2, 0DH, 2, 2 DUP (0DH), 2, 8
         DB 16 DUP (8)
         DB 0, 14 DUP (8), 0
         DB 2 DUP (0),8, 0DH, 0FH, 0FH, 0DH, 3 DUP (2), 0DH, 0DH, 2, 8, 2 DUP(0)
         DB 2 DUP (0),8, 0DH, 0FH, 0FH, 0DH, 2 DUP (2), 0DH, 2, 0DH, 2, 8, 2 DUP(0)
         DB 2 DUP (0),8, 0DH, 0FH, 0FH, 0DH, 3 DUP (2), 0DH, 0DH, 2, 8, 2 DUP(0)
         DB 2 DUP (0),8, 0DH, 0FH, 0FH, 0DH, 2 DUP (2), 0DH, 2, 0DH, 2, 8, 2 DUP(0)
         DB 2 DUP (0),8, 0DH, 0FH, 0FH, 0DH, 3 DUP (2), 0DH, 0DH, 2, 8, 2 DUP(0)
         DB 2 DUP (0),8, 0DH, 0FH, 0FH, 0DH, 2 DUP (2), 0DH, 2, 0DH, 2, 8, 2 DUP(0)
         DB 2 DUP (0),8, 0DH, 0FH, 0FH, 0DH, 3 DUP (2), 0DH, 0DH, 2, 8, 2 DUP(0)
         DB 2 DUP (0), 12 DUP (8), 2 DUP (0)

    gabarito2   DB '5','9','1','3','6','2','8','4','7'
                DB '3','6','4','8','9','7','1','2','5'
                DB '7','2','8','1','4','5','9','6','3'
                DB '4','7','6','5','1','9','3','8','2'
                DB '2','3','9','4','7','8','5','1','6'
                DB '8','1','5','6','2','3','4','7','9'
                DB '9','5','7','2','8','4','6','3','1'
                DB '1','4','2','9','3','6','7','5','8'
                DB '6','8','3','7','5','1','2','9','4'

    matrizprov2 DB '5','F','F','F','6','2','F','F','F'
                 DB '3','6','4','F','F','F','1','2','5'
                 DB '7','2','F','F','F','F','F','F','3'
                 DB 'F','F','F','F','1','F','3','F','F'
                 DB '2','F','9','4','F','8','F','F','F'
                 DB '8','1','F','6','F','F','F','F','9'
                 DB 'F','F','F','2','8','F','F','F','F'
                 DB 'F','F','F','9','3','6','7','F','F'
                 DB 'F','F','3','F','F','1','F','9','4'

    gabarito3   DB '4','7','8','3','9','2','6','5','1'
                DB '6','9','3','7','1','5','4','2','8'
                DB '5','2','1','4','6','8','3','9','7'
                DB '1','6','5','8','2','4','7','3','9'
                DB '3','4','9','1','5','7','2','8','6'
                DB '7','8','2','6','3','9','5','1','4'
                DB '2','5','6','9','4','1','8','7','3'
                DB '8','1','4','2','7','3','9','6','5'
                DB '9','3','7','5','8','6','1','4','2'

    matrizprov3 DB 'F','7','8','F','F','F','F','5','F'
                DB '6','F','3','F','1','5','F','F','8'
                DB 'F','2','F','4','6','F','F','9','7'
                DB '1','F','F','F','F','4','F','F','F'
                DB 'F','F','F','1','5','F','2','F','6'
                DB '7','F','2','6','F','F','5','F','F'
                DB 'F','5','F','F','F','1','F','7','3'
                DB '8','F','4','F','F','3','F','F','F'
                DB '9','F','F','F','8','F','1','F','2'

    gabarito1   DB '8','3','6','5','9','4','7','1','2'
                DB '2','5','7','3','6','1','4','8','9'
                DB '9','1','4','7','8','2','3','6','5'
                DB '7','9','2','4','3','8','1','5','6'
                DB '1','6','8','2','5','7','9','3','4'
                DB '5','4','3','9','1','6','8','2','7'
                DB '4','2','5','8','7','3','6','9','1'
                DB '6','8','9','1','4','5','2','7','3'
                DB '3','7','1','6','2','9','5','4','8'

    matrizagr DB 0
    matrizanot DB 81 DUP ('F')
    corbu DB 4
    espera DB 256 DUP (9)

    erroqnt db 48
    erros db 'ERROS '
    erros2 DB '/5'

    numinv DB 'NUMERO INVALIDO'
    numinv1 DB 'TENTE NOVAMENTE'
    botaoverm DB 16 DUP (16 DUP(2))
    botaoverd DB 16 DUP (16 DUP (0AH))
    botao db 0

    limpa DB 16 DUP (16 DUP (0))
    sdk DB 'SUDOKU'

    tamg DW 0
    cannum dw 0
    sec db 0
    gx dw 0
    gy dw 0
    gtam dw 0

    conta dw 0

    qix dw 0
    qiy dw 0 

    res db 0
    res1 db 0
    gvezes dw 0

    newg DB 'JOGAR!'

    cred DB 'CREDITOS!'

    ant DB 'anotacoes'

    bonus DB 'BONUS!'
    strc DW 0

    do1   dw 9121
    dos1  dw 8609
    re1    dw 8126
    resus1  dw 7670
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
    main PROC
        MOV AX, @DATA
        MOV DS, AX
        
        limpall

        MOV AX, 13
        INT 10H 

        MOV AH, 0BH
        MOV BL, 0BH
        INT 10H

        MOV AX, 1
        MOV CX, 16 
        DIV CX

        MOV gx, 228
        MOV gy, 100
        MOV gtam, 16
        MOV gvezes, 1

        telainicio
        limpall

        
    
        MOVI:
            cai
            pixelart gx, gy, gtam, cogu2, gvezes
            MOV AH, 07
            INT 21H

            COMPARA:
                cai
                CMP AL, 'd'
                JE DIREITA
                CMP AL, 'w'
                JE CIMA
                CMP AL, 'a'
                JE ESQUERDA
                CMP AL, 's'
                JE BAIXOU
                JMP MOVI
            
            CIMA:
                CALL ciman
                JMP MOVI

            DIREITA:
                CALL anda
                MOV AH, 2CH
                INT 21H
                MOV sec, DH
                MOV AH, 07
                INT 21H
                CMP AL, 's'
                JE BAIXOU
                CMP AL, 'w'
                JE DIAGONALD
                JMP COMPARA
            
            ESQUERDA:
                CALL anda2
                MOV AH, 2CH
                INT 21H
                MOV sec, DH
                MOV AH, 07
                INT 21H
                CMP AL, 's'
                JE BAIXOU
                CMP AL, 'w'
                JE DIAGONALE 
                JMP COMPARA

            DIAGONALD:
                MOV AH, 2CH
                INT 21H
                CMP sec, DH
                JNE CIMA

                CALL diagonaldp
                JMP MOVI

            DIAGONALE:
                MOV AH, 2CH
                INT 21H
                CMP sec, DH
                JNE CIMA

                CALL diagonalep
                JMP MOVI


            BAIXOU:
                CMP gx, 67
                JA BAIXO1
                JMP MOVI
            BAIXO1:
                MOV cannum, 64
                CMP gx, 147
                JA BAIXO2
                CMP gx, 74
                JB DESCECANO
                JMP MOVI
            BAIXO2:
                MOV cannum, 144
                CMP gx, 227
                JA BAIXO3
                CMP GX, 154
                JB DESCECANO
                JMP MOVI
            BAIXO3:
                MOV cannum,224
                CMP gx, 234
                JB DESCECANO
                JMP MOVI
            DESCECANO:
                CALL descer
                limpainicio
                MOV gy, 0
                cai
            CMP cannum, 64
            JE MUSICA
            CMP cannum, 224
            JE SUDOKU
            JMP FIM



            MUSICA:

            SUDOKU:
                interface 155,11, 144, 0CH
                printasudoku matrizprov2, 20,0, 9
                string sdk,6,5,2,9
                string ant, 9, 4, 6, 8

                @VOLTASU:
                    botaom corbu, 10, 40, 26, 56
                    printasudoku matrizanot, 20, 0, 8
                    printasudoku matrizprov2, 20,0, 9
                    printaerro
                    MOV CL, erroqnt 
                    XOR BX, BX
                    XOR CX, CX
                    XOR DX, DX

                    CALL mario

                    string numinv, 15, 2, 18, 0
                    string numinv1, 15,2, 19, 0
                    CMP CX, 156
                    JNB CONTINUASU
                    JMP FORATAB
                    CONTINUASU:
                    CMP DX, 12
                    JNB CONTINUASU1
                    JMP FORATAB
                    CONTINUASU1:
                    CMP CX, 299
                    JNA CONTINUASU2
                    JMP FORATAB 
                    CONTINUASU2:
                    CMP DX, 156
                    JNA CONTINUASU3

                    JMP FORATAB 

                    CONTINUASU3:
                    SUB CX, 155
                    SHR CX, 4
                    MOV SI, CX
                    SUB DX, 11
                    SHR DX, 4
                    MOV AX, 9
                    MUL DX
                    MOV BX, AX
                    CMP matrizprov2[BX][SI], 'F'
                    JE DIGITANUM
                    JMP @VOLTASU

                    DIGITANUM:
                        esperavalor BX, SI 
                        MOV AH, 07
                        INT 21H
                        conferenum

                        CMP corbu, 4
                        JE ADICIONASUDOKU
                        MOV matrizanot[BX][SI], AL
                        JMP @VOLTASU

                        ADICIONASUDOKU:
                            CMP AL, gabarito2[BX][SI]
                            JE NOTERRO
                            INC erroqnt
                            MOV matrizanot[BX][SI], 'F'
                            CALL somerro
                            CMP erroqnt, 53
                            JA DERROTA
                            JMP @VOLTASU
                        NOTERRO:
                            MOV matrizprov2[BX][SI], AL
                            JMP @VOLTASU
                            

                FORATAB:
                    CMP CX, 11
                    JNA ANOTSAI
                    CMP DX, 41
                    JNA ANOTSAI
                    CMP CX, 26
                    JNB ANOTSAI
                    CMP DX, 56
                    JNB ANOTSAI

                    CMP corbu, 4
                    JE BOTVERDE

                    MOV corbu, 4
                    JMP @VOLTASU
                    BOTVERDE:
                    MOV corbu, 0AH
                    JMP @VOLTASU

                    ANOTSAI:
                        JMP @VOLTASU
                
            DERROTA:


            FIM:


        MOV AH, 4CH
        INT 21H

    main ENDP


anda PROC
    
    andadireita  
    andadireita
    ret
anda ENDP

ciman PROC  
    mov BL, 10
    CIMAVOLTA:
        MOV AL, BL
        SOBEVOLTA:
            sobe
            DEC AL
            JZ PROSSEGUECIMA
            JMP SOBEVOLTA 
        PROSSEGUECIMA:
            DEC BL
            JZ CONTIDESCE1 
            JMP CIMAVOLTA

        CONTIDESCE1:
    ret 
ciman ENDP 

anda2 PROC
    
    andaesquerda
    andaesquerda 
    ret
anda2 ENDP

mario PROC
    

    MARIOINFINITO:

    nota mi3,3
    pausa
    nota mi3,6
    pausa
    nota mi3,6
    pausa
    nota do3,3
    pausa
    nota mi3,7
    pausa
    nota sol3,15
    pausa
    nota sol1,15
    ;introducao acabou
    pausa
    pausa
    nota do3,10
    pausa
    nota sol2,10
    pausa
    nota mi2,10
    pausa
    pausa
    nota la2,6
    pausa
    nota si2,6
    pausa
    nota las2,3
    pausa
    nota la2,7
    pausa
    nota sol2,5
    nota mi3,6
    nota sol3,3
    pausa
    nota la3,6
    pausa
    nota fa3,3
    pausa 
    nota sol3,7
    pausa
    nota mi3,7
    pausa
    nota do3,3
    pausa
    nota re3,3
    pausa 
    nota si2,10
    pausa
    ;finalizacao do primeira parte
    pausa
    nota do3,10
    pausa
    nota sol2,10
    pausa
    nota mi2,10
    pausa
    pausa
    nota la2,6
    pausa
    nota si2,6
    pausa
    nota las2,3
    pausa
    nota la2,7
    pausa
    nota sol2,5
    nota mi3,6
    nota sol3,3
    pausa
    nota la3,6
    pausa
    nota fa3,3
    pausa 
    nota sol3,7
    pausa
    nota mi3,7
    pausa
    nota do3,3
    pausa
    nota re3,3
    pausa 
    nota si2,15
    pausa
    ;comeca segunda parte
    pausa
    pausa 
    pausa
    pausa 
    nota sol3,3
    pausa
    nota fas3,3
    pausa
    nota fa3,3
    pausa 
    nota res3,6
    pausa 
    nota mi3,8

    nota sols1,4
    nota la1,4
    nota do2,7
    pausa
    nota la1,4
    nota do2,4
    nota re2,7
    pausa
    pausa
    nota sol3,3
    pausa
    nota fas3,3
    pausa
    nota fa3,3
    pausa 
    nota res3,6
    pausa 
    nota mi3,8
    pausa
    nota do4,5
    pausa
    nota do4,5
    pausa
    nota do4,10
    pausa
    nota sol1,4
    nota do1,8
    pausa
    nota sol3,3
    pausa
    nota fas3,3
    pausa
    nota fa3,3
    pausa 
    nota res3,6
    pausa 
    nota mi3,8

    nota sols1,4
    nota la1,4
    nota do2,7
    pausa
    nota la1,4
    nota do2,4
    nota re2,7
    pausa
    pausa
    nota res2,10
    pausa
    nota re2,10
    pausa
    nota do2,14
    pausa
    pausa
    pausa
    pausa 
    pausa 
    pausa
    pausa
    pausa
    pausa 
    nota sol3,3
    pausa
    nota fas3,3
    pausa
    nota fa3,3
    pausa 
    nota res3,6
    pausa 
    nota mi3,8

    nota sols1,4
    nota la1,4
    nota do2,7
    pausa
    nota la1,4
    nota do2,4
    nota re2,7
    pausa
    pausa
    nota sol3,3
    pausa
    nota fas3,3
    pausa
    nota fa3,3
    pausa 
    nota res3,6
    pausa 
    nota mi3,8
    pausa
    nota do4,5
    pausa
    nota do4,5
    pausa
    nota do4,10
    pausa
    nota sol1,4
    nota do1,7
    pausa 
    nota sol3,3
    pausa
    nota fas3,3
    pausa
    nota fa3,3
    pausa 
    nota res3,6
    pausa 
    nota mi3,8

    nota sols1,4
    nota la1,4
    nota do2,7
    pausa
    nota la1,4
    nota do2,4
    nota re2,7
    pausa
    pausa
    nota res2,10
    pausa
    nota re2,10
    pausa
    nota do2,10
    pausa
    pausa 
    pausa 
    pausa 
    pausa 
    pausa 
    pausa
    pausa
    pausa
    pausa 
    ;comeca a penultima parte
    nota do2,4
    pausa
    nota do2,5
    pausa 
    nota do2,7
    pausa
    nota do2,4
    nota re2,7
    pausa
    nota mi2,4
    nota do2,6
    pausa
    nota la1,5
    nota sol1,10
    pausa
    pausa
    pausa 
    pausa 
    pausa
    nota do2,4
    pausa
    nota do2,5
    pausa 
    nota do2,7
    pausa
    nota do2,4
    nota re2,6
    pausa
    nota mi2, 8
    pausa 
    nota sol1,14
    pausa
    pausa 
    pausa
    pausa
    pausa 
    nota do2,4
    pausa
    nota do2,5
    pausa 
    nota do2,7
    pausa
    nota do2,4
    nota re2,7
    pausa
    nota mi2,4
    nota do2,6
    pausa
    nota la1,5
    nota sol1,10
    pausa
    pausa 
    nota mi2,5
    pausa
    nota mi2,5
    pausa
    nota mi2,5
    pausa
    nota do2,5
    nota mi2,7
    pausa
    nota sol2,8
    pausa
    pausa
    pausa
    pausa
    nota sol1,10
    pausa
    pausa
    pausa

   nota do2,4
    pausa
    nota do2,5
    pausa 
    nota do2,7
    pausa
    nota do2,4
    nota re2,7
    pausa
    nota mi2,4
    nota do2,6
    pausa
    nota la1,5
    nota sol1,10
    pausa
    pausa
    pausa 
    pausa 
    pausa
    nota do2,4
    pausa
    nota do2,5
    pausa 
    nota do2,7
    pausa
    nota do2,4
    nota re2,6
    pausa
    nota mi2, 8
    pausa 
    nota sol1,14
    pausa
    pausa 
    pausa
    pausa
    pausa 
    nota do2,4
    pausa
    nota do2,5
    pausa 
    nota do2,7
    pausa
    nota do2,4
    nota re2,7
    pausa
    nota mi2,4
    nota do2,6
    pausa
    nota la1,5
    nota sol1,10
    pausa
    pausa 
    nota mi2,5
    pausa
    nota mi2,5
    pausa
    nota mi2,5
    pausa
    nota do2,5
    nota mi2,7
    pausa
    nota sol2,8
    pausa
    pausa
    pausa
    pausa
    nota sol1,10
    ;inicio da ultima parte

    pausa

    nota do3,10
    pausa
    nota sol2,10
    pausa
    nota mi2,10
    pausa
    pausa
    nota la2,6
    pausa
    nota si2,6
    pausa
    nota las2,3
    pausa
    nota la2,7
    pausa
    nota sol2,5
    nota mi3,6
    nota sol3,3
    pausa
    nota la3,6
    pausa
    nota fa3,3
    pausa 
    nota sol3,7
    pausa
    nota mi3,7
    pausa
    nota do3,3
    pausa
    nota re3,3
    pausa 
    nota si2,10
    pausa
;     ;finalizacao do primeira parte
    nota do3,10
    pausa
    nota sol2,10
    pausa
    nota mi2,10
    pausa
    pausa
    nota la2,6
    pausa
    nota si2,6
    pausa
    nota las2,3
    pausa
    nota la2,7
    pausa
    nota sol2,5
    nota mi3,6
    nota sol3,3
    pausa
    nota la3,6
    pausa
    nota fa3,3
    pausa 
    nota sol3,7
    pausa
    nota mi3,7
    pausa
    nota do3,3
    pausa
    nota re3,3
    pausa 
    nota si2,10
    pausa
    nota mi2,6
    nota do2,7
    nota sol1,9
    pausa
    nota fas1,5
    pausa 
    nota sol1,5
    nota fa2,5
    pausa
    nota fa2,5
    nota sol1,8
    pausa
    pausa
    pausa 
    nota si1,6
    pausa
    nota la2,6
    pausa
    nota la2,4
    pausa
    nota la2,4
    pausa
    nota sol2,4
    pausa
    nota fa2,4
    nota mi2,5
    pausa 
    nota do2,4
    pausa
    nota la1,4
    nota sol1,7
    pausa
    nota mi2,6
    nota do2,7
    nota sol1,9
    pausa
    nota sols1,7
    pausa 
    nota do2,5
    nota fa2,5
    pausa
    nota fa2,5
    nota la1,7
    pausa
    nota si1,5
    pausa
    nota la2,5
    pausa
    nota la2,5
    pausa 
    nota la2,5
    nota mi2,5
    nota re2,5
    nota sol1,5
    nota mi1,5
    pausa
    nota mi1,5
    nota do1,5
    pausa
    
    nota mi2,5
    nota do2,7
    nota sol1,9
    pausa
    nota fas1,5
    nota sol1,6
    nota fa2,5
    pausa
    nota fa2,5
    nota sol1,5
    pausa
    nota si1,5
    pausa
    nota la2,4
    pausa
    nota la2,4
    pausa
    nota la2,4
    pausa
    nota sol2,4
    nota fa2,5
    nota mi2,5
    nota do2,7
    pausa
    nota la1,5
    nota sol1,7
    pausa
    nota mi2,5
    nota do2,7
    nota sol1,9
    pausa
    nota sols1,7
    nota do2,5
    nota fa2,5
    pausa
    nota fa2,5
    nota la1,7
    pausa
    nota si1,5
    pausa
    nota la2,5
    pausa
    nota la2,5
    pausa 
    nota la2,5
    nota mi2,5
    nota re2,5
    nota sol1,5
    nota mi1,5
    pausa
    nota mi1,5
    nota do1,5
    pausa
    ;fim
    nota la1,8
    nota si1,8
    nota la1,8
    nota sols1,8
    nota las1,8
    nota la1,8
    nota mi1,8
    nota do1,8
    nota mi1,12
    JMP MARIOINFINITO
    @FIMMARIO:

    ret

    ret
mario ENDP
somerro PROC 
    pausa
    pausa
    nota fas2, 8
    nota fa2, 8
    nota mi2, 8
    pausa
    pausa
    ret
somerro ENDP
limpatela PROC
    pushall

    mov ah,06h	;clear screen instruction
    mov al,00h	;number of lines to scroll
    mov bh,0Bh	;display attribute - colors
    mov ch,00d	;start row
    mov cl,00d	;start col
    mov dh,24d	;end of row
    mov dl,79d	;end of col
    int 10h		;BIOS interrupt
    popall
    ret
limpatela ENDP

diagonaldp PROC 
    MOV BL, 8
    DGDVOLTA:
        MOV AL, BL
        DIAGDVOLTA:
            sobe
            DEC AL
            JZ PROSSEGUEDGD
            JMP DIAGDVOLTA 
        PROSSEGUEDGD:
        
            andadireita
            andadireita
            DEC BL
            JZ DESCEDGD
            JMP DGDVOLTA
        DESCEDGD:
            XOR AL, AL
        DIAGDESCEVOLTAD:
            desce
            pushall
            MOV AH, 0DH
            MOV BH, 0

            MOV CX, gx
            MOV DX, gy

            ADD DX, 16
            MOV BL, 15

            LEPVOLTA2:
                INT 10H
                CMP AL, 0
                JE PASSA2
                popall
                RET
                PASSA2:
                INC CX
                DEC BL
                JNZ LEPVOLTA2

            popall
            INC AL
            CMP AL, BL
            JA PROSSEGUEDESCEGD
            JMP DIAGDESCEVOLTAD 
        PROSSEGUEDESCEGD:
            andadireita
            andadireita
            INC BL
            CMP BL, 8
            JAE DESCEDGDFIM
            JMP DESCEDGD
        DESCEDGDFIM:
    RET 
diagonaldp ENDP 

diagonalep PROC
    MOV BL, 8
    DGEVOLTA:
        MOV AL, BL
        DIAGEVOLTA:
            sobe
            DEC AL
            JZ PROSSEGUEDGE
            JMP DIAGEVOLTA 
        PROSSEGUEDGE:
            andaesquerda
            andaesquerda
            DEC BL
            JZ DESCEDGE
            JMP DGEVOLTA
        DESCEDGE:
            XOR AL, AL
        DIAGDESCEVOLTAE:
            desce
            pushall
            MOV AH, 0DH
            MOV BH, 0

            MOV CX, gx
            MOV DX, gy

            ADD DX, 16
            MOV BL, 15

            LEPVOLTA3:
                INT 10H
                CMP AL, 0
                JE PASSA3
                popall 
                RET
                PASSA3:
                INC CX
                DEC BL
                JNZ LEPVOLTA3

            popall
            INC AL
            CMP AL, BL
            JA PROSSEGUEDESCEGE
            JMP DIAGDESCEVOLTAE
        PROSSEGUEDESCEGE:
            andaesquerda
            andaesquerda
            INC BL
            CMP BL, 8
            JAE DESCEDGEFIM
            JMP DESCEDGE
        DESCEDGEFIM:
    RET 
diagonalep ENDP

delay proc
    PUSH CX
    MOV CX, 01H
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

descer PROC
    MOV AL, 16

    ANIMADESCE:
        CALL delay
        desce
        pixelart cannum, 149, 16, cano, 2

        DEC AL
        JZ FIMDESCER
        JMP ANIMADESCE

        FIMDESCER:
    ret 
descer ENDP


note proc
    pushall
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


    popall
    ret
note endp


end main