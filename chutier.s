        lda remainder
        sta dividend
        lda remainder+1
        sta dividend+1

	lda #0	        ;preset remainder to 0
	sta remainder
	sta remainder+1
        sta decimal
        sta decimal+1
	ldx #16	        ;repeat for each bit: ...       

*<bp>
*<sym>
divloopdec
	asl dividend	;dividend lb & hb*2, msb -> Carry
	rol dividend+1	
	rol remainder	;remainder lb & hb * 2 + msb from carry
	rol remainder+1
*<sym>
	lda remainder
	sec
	sbc divisor	;substract divisor to see if it fits in
	tay	        ;lb result -> Y, for we may need it later
	lda remainder+1
	sbc divisor+1
	bcc skipdec	;if carry=0 then divisor didn't fit in yet

	sta remainder+1	;else save substraction result as new remainder,
	sty remainder	
	inc result	;and INCrement result cause divisor fit in 1 times

*<sym>
skipdec	dex
	bne divloopdec
        rts	