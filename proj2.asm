.model small
.stack 100h
.data
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

        MOV BL, 180

        MOV CX, 70
        MOV DX, 10

        
        VOLTACIMA:
            CALL delay



            INT 10H
            PUSH DX
            TESTE:

                INT 10H

                ADD DX, 20

                CMP DX, 180
                JB TESTE

            POP DX

            INC CX
            DEC BL 
            JNZ VOLTACIMA

        MOV BL, 180

        MOV CX, 250
        MOV DX, 10
        VOLTADIREITA:
            CALL delay
            INT 10H
            INC DX
            DEC BL 
            JNZ VOLTADIREITA

        MOV BL, 180

        MOV CX, 250
        MOV DX, 190
        VOLTABAIXO:
            CALL delay
            INT 10H
            DEC CX
            DEC BL 
            JNZ VOLTABAIXO

        MOV BL, 181

        MOV CX, 70
        MOV DX, 190
        VOLTAESQUERDA:
            CALL delay
            INT 10H
            PUSH CX
            TESTE2:
                INT 10H
                ADD CX, 20

                CMP CX, 260
                JB TESTE2
            
            POP CX


            DEC DX
            DEC BL 
            JNZ VOLTAESQUERDA

        



        MOV AH, 4CH
        INT 21H

    main ENDP

delay proc
    PUSH CX
    MOV CX, 03H
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

pixel_art proc




















pixel_art endp



end main