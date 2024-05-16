org 0x7c00  ; sets the orgin of the code to 0x7c00 (loaded by BIOS at this address)
bits 16 ; We are still in 16 bit Real Mode

start:
    cli ; clear all interrupts
    hlt ; halt the system

times 510 - ($ - $$) db 0   ; we have to be 512 bytes, clear the rest of the bytes with 0 (510)
dw 0xaa55   ; boot signature