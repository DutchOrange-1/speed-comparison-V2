; Now running 64 bits 
; 1e9 itterations take about 1.086s 

extern printf
global main
;global _start

section .data
    itterations dd     1000000000               ; Number of itterations - each itteration is actually 8 itterations
    nume        dq     1.0 , -1.0  , 1.0 , -1.0        ;Numerator temp   ; ymm3
    denom       dq     0.0 , 1.0 , 2.0 , 3.0        ;Denominator temp  ; ymm4 ; currently k
    result      dq     0.0696969                    ; Result 
    
    ; Caculation values
    four            dq 4.0 ; Last caculation
    float_one       dq 1.0
    float_min_one   dq -1.0
    dd_one          dq 1.0, 1.0, 1.0, 1.0
    dd_eight        dq 4.0, 4.0, 4.0, 4.0
    fmt             db "%.16f", 10, 0

section .text


main:
    mov rbp, rsp; for correct debugging
    mov rcx , [itterations] ; How many counts
    shr rcx , 2 ; Divide by 4
    xor rax, rax            ; Just clearing it. 
    xor rdx, rdx

    vxorpd ymm0, ymm0 ; WREG
    vxorpd ymm1, ymm1 ; ones
    vxorpd ymm2, ymm2 ; fours
    vxorpd ymm3, ymm3 ; ; Numerator
    vxorpd ymm4, ymm4 ; Denpminator
    vxorpd ymm5, ymm5; Counter
    vxorpd ymm6, ymm6; Result
    vxorpd ymm7, ymm7; FINAL Result
    vxorpd ymm8, ymm8
    vxorpd ymm9, ymm9


    ; Set start point of registers 
    vmovupd ymm3, [nume]
    vmovupd ymm4, [denom]
    vmovupd ymm5, [denom] ; Used for counting - k - Vector operations are done on this and saved into ymm4
    
    vmovupd ymm1, [dd_one]
    vmovupd ymm2, [dd_eight]
    
    .loop:
    ; Re-set vairables:
    vmovupd ymm3, [nume]
    
    ; denom = 2k + 1
    vmovapd ymm4, ymm5
    vaddpd  ymm4, ymm4, ymm4   ; *2
    vaddpd  ymm4, ymm4, ymm1   ; +1

    ; term = num / denom
    vdivpd  ymm3, ymm3, ymm4 ; Most time costing caculation. 
    
    ; sum
    vaddpd  ymm0, ymm0, ymm3

    ; k += 8
    vaddpd  ymm5, ymm5, ymm2

    dec rcx
    jnz .loop
   
    Print_and_exit:
        ; ymm6 contains 8 terms
        vhaddpd ymm0, ymm0, ymm0  ; Add the results 
        vextractf128 xmm1, ymm0, 1 ; Get High bit
        vaddpd xmm0, xmm0, xmm1 
        
        addpd xmm0, xmm0  ; Multiply 
        addpd xmm0, xmm0
        
        ; ret
        push rbp
        mov rdi, fmt
        mov rax, 1
        call printf      ; Call the C library function
        
        xor rax, rax     ; Return 0 from main
        pop rbp          ; Restore stack
        
        ret
    