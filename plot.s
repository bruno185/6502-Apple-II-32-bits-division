
                org $4000
                put equ

*<bp>
                ldx #3
                jsr HCOLOR

loop
                ldx x1
                ldy x1+1
                lda y1
plot            jsr HPLOT

                lda x2
                ldx x2+1
                ldy y2
                jsr HLIN

*<bp>
                clc
                inc y1
                inc y2
                lda y2 
                cmp #150
                bcc loop

                rts  

x1              dw 10
*<m1>
y1              db 10
x2              dw 90
*<m2>
y2              db 40

