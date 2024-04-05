* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*
*               OPTIMIZED integer DIVISION with decimal
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

d1      equ 1000
d2      equ 3

        org $4000
        put equ

*<bp>
*<sym>
beginning
        nop                     ; print divident and divisor
        ldx #<d1
        stx dividend
        lda #>d1
        sta dividend+1
        jsr printax
        lda #" "
        jsr cout 

        ldx #<d2
        stx divisor
        lda #>d2
        sta divisor+1  
        jsr printax
        jsr crout
        jsr crout
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *    
*<bp>                                                           *
        jsr divide      ; call to optimized division            *
*                                                               *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *  
*
        lda #"$"                ; print rsult (integer part)
        jsr cout
        ldx dividend
        lda dividend+1
        jsr printax

        jsr crout

        lda #"$"                ; print remainder
        jsr cout
        ldx remainder
        lda remainder+1
        jsr printax

        jsr crout               ; print rsult (decimal part)
        lda #"$"
        jsr cout
        ldx decimal
        lda decimal+1
        jsr printax

*<sym>
end_of_program
        rts     

* $35E (862) cycles routine without decimal (including final RTS)
* $76F (1903) cycles routine  with decimal (including final RTS)
*<sym>
divide	
	lda #0	        ;preset remainder to 0
	sta remainder
	sta remainder+1
	ldx #16	        ;repeat for each bit: ...

*<sym>
divloop	asl dividend	;dividend lb & hb*2, msb -> Carry
	rol dividend+1	
	rol remainder	;remainder lb & hb * 2 + msb from carry
	rol remainder+1

	lda remainder
	sec
	sbc divisor	;substract divisor to see if it fits in
	tay	        ;lb result -> Y, for we may need it later
	lda remainder+1
	sbc divisor+1
	bcc skip	;if carry=0 then divisor didn't fit in yet

	sta remainder+1	;else save substraction result as new remainder,
	sty remainder	
	inc result	;and INCrement result cause divisor fit in 1 times

*<sym>
skip	dex
	bne divloop	

        lda remainder
        ora remainder+1
        bne doDecimal
	rts

*<sym>
doDecimal
        lda #0
        sta decimal
        sta decimal+1

        ldx #16
*<sym>
divloopdec                      ; on entry, remainder < divisor
        asl remainder           ; remainder = remainder * 2
        rol remainder+1

        sec
        lda remainder           ; A / Y = remainder - divisor
        sbc divisor
        tay
        lda remainder+1
        sbc divisor+1
        php                     ; save carry. 
                                ; carry is set if remainder >= divisor 
                                ; (ie. substraction result is >= 0)
                                ; 
        rol decimal             ; result shifted left, carry enters right
        rol decimal+1           ; if carry clear, 0 enters in result
                                ; if carry set, 1 enters in result
        plp                     ; restore carry
        bcc skipdec             ; if carry clear (<=> remainder < divisor) then loop

        sta remainder+1         ; else, remainder = remainder
        sty remainder

*<sym>
skipdec 

        dex                     ; next loop
        bne divloopdec
        rts

*
* * * * * * * * * * * * * * * 
*            DATA           *
* * * * * * * * * * * * * * * 
*
*<m2>
*<sym>
decimal         ds 2
*<sym>
divisor         ds 2
*<m1>
*<sym>
dividend        ds 2
*<m2>
*<sym>
remainder       ds 2
result = dividend
