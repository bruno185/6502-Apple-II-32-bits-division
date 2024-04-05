*
* unsigned 32 bit fixed-point division  
*
*
        org $4000
        put equ
*<bp>
*<sym>
beginning

        jsr loadnumbers
        jsr initvar
        jsr prndivid
        jsr crout
        jsr Dodivide              ; integer part
        jsr prndivid
        jsr crout
        jsr prnrem
        jsr doDecimal           ; decimal part
        jsr prndecim
*<sym>
end_of_program
        rts
*
*
*
*
*<sym>
*<bp>
Dodivide
	ldx #32	        ;repeat for each bit: ...
*<sym>
divloop
        asl dividend
        rol dividend+1
        rol dividend+2
        rol dividend+3
*<sym>
rolrem
        rol remainder
        rol remainder+1
        rol remainder+2
        rol remainder+3

        sec
        lda remainder
        sbc divisor
        sta tempo
        lda remainder+1
        sbc divisor+1
        sta tempo+1
        lda remainder+2
        sbc divisor+2
        sta tempo+2
        lda remainder+3
        sbc divisor+3
        sta tempo+3

        bcc skip

        ldy #3
*<sym>
m43
        lda tempo,y 
        sta remainder,y 
        dey
        bpl m43

        inc result

*<sym>
skip
        dex
        bne divloop
        rts             ; end of division


**************
*<sym>
doDecimal

        ldx #32
*<sym>
divloopdec                      ; on entry, remainder < divisor
        asl remainder           ; remainder = remainder * 2
        rol remainder+1
        rol remainder+2
        rol remainder+3        

        sec
        lda remainder           ; A / Y = remainder - divisor
        sbc divisor
        sta tempo
        lda remainder+1
        sbc divisor+1
        sta tempo+1
        lda remainder+2
        sbc divisor+2
        sta tempo+2
        lda remainder+3
        sbc divisor+3 
        sta tempo+3       
        php                     ; save carry. 
                                ; carry is set if remainder >= divisor 
                                ; (ie. substraction result is >= 0)
                                ; 
        rol decimal             ; result shifted left, carry enters right
        rol decimal+1           ; if carry clear, 0 enters in result
        rol decimal+2           ; if carry set, 1 enters in result
        rol decimal+3
        plp                     ; restore carry
        bcc skipdec             ; if carry clear (<=> remainder < divisor) then loop


        sta remainder+3         ; else, remainder = remainder
        lda tempo+2
        sta remainder+2
        lda tempo+1
        sta remainder+1
        lda tempo
        sta remainder

*<sym>
skipdec 

        dex                     ; next loop
        bne divloopdec
        rts
**************

* * * * * * * * * * * * * * * * * * * * 
*               Functions
* * * * * * * * * * * * * * * * * * * * 
*<sym>
loadnumbers

        ldx #3
*<sym>
m4
        lda val1,x
        sta dividend,x
        dex
        bpl m4

        ldx #3
*<sym>
m42
        lda val2,x
        sta divisor,x
        dex
        bpl m42
        rts

*<sym>
initvar 
        lda #0
        sta decimal
        sta decimal+1
        sta decimal+2
        sta decimal+3

        sta remainder
        sta remainder+1
        sta remainder+2
        sta remainder+3
        rts

*<sym>
prndivid

        lda #"$"
        jsr cout

        lda dividend+3
        jsr prbyte
        lda dividend+2
        jsr prbyte
        lda dividend+1
        jsr prbyte
        lda dividend
        jsr prbyte 
        rts

*<sym>
prndecim
        lda #" "
        jsr cout
        lda #"$"
        jsr cout 
        lda decimal+3
        jsr prbyte
        lda decimal+2
        jsr prbyte
        lda decimal+1
        jsr prbyte
        lda decimal
        jsr prbyte 
        rts

*<sym>
prnrem
        jsr crout        
        lda #"$"
        jsr cout

        lda remainder+3
        jsr prbyte
        lda remainder+2
        jsr prbyte
        lda remainder+1
        jsr prbyte
        lda remainder
        jsr prbyte
        rts

* * * * * * * * * * * * * * * * * * * * 
*                  Data
* * * * * * * * * * * * * * * * * * * * 
*<sym>
val1    
*hex 002D3101            ; 20 000 000 
        hex 64235d65    ; $655d2364 = 1700602724
*<sym>
val2    hex 0F000000            ; 15

*<sym>
decimal         ds 4

*<m1>
*<sym>
dividend        ds 4

*<m2>
*<sym>
remainder       ds 4
*<sym>
divisor         ds 4
*<sym>
tempo           ds 4

result = dividend


