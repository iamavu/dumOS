org     0x7c00  ; sets the orgin of the code to 0x7c00 (loaded by BIOS at this address)
bits    16 ; We are still in 16 bit Real Mode

start: 
    jmp loader

;*************************************************;
;	 OEM Parameter Block
;*************************************************;

times 0Bh-$+start DB 0

bpbBytesPerSector:  	DW 512
bpbSectorsPerCluster: 	DB 1
bpbReservedSectors: 	DW 1
bpbNumberOfFATs: 	    DB 2
bpbRootEntries: 	    DW 224
bpbTotalSectors: 	    DW 2880
bpbMedia: 	            DB 0xF0
bpbSectorsPerFAT: 	    DW 9
bpbSectorsPerTrack: 	DW 18
bpbHeadsPerCylinder: 	DW 2
bpbHiddenSectors: 	    DD 0
bpbTotalSectorsBig:     DD 0
bsDriveNumber: 	        DB 0
bsUnused: 	            DB 0
bsExtBootSignature: 	DB 0x29
bsSerialNumber:	        DD 0xa0a1a2a3
bsVolumeLabel: 	        DB "MOS FLOPPY "
bsFileSystem: 	        DB "FAT12   "

msg	db	"welcome to dumOS", 0

Print:
    lodsb   ; load the byte pointed to by SI into AL
    or      al, al ; check if the byte is 0
    jz      PrintDone ; if it is, jump to PrintDone
    mov     ah, 0x0e ; set the ah register to 0x0e (teletype)
    int     0x10 ; interrupt 0x10 (teletype)
    jmp     Print ; loop

PrintDone:
    ret ; return

;*************************************************;
;	Bootloader Entry Point
;*************************************************;

loader:
    xor     ax, ax ; set segment registers to 0 as we have org as 0x7c00
    mov     ds, ax ; this means all addresses are from 0x7c00:0 
    mov     es, ax ; as data segments are within same code segment, we need to nullify them
    
    mov     si, msg ; set source index to msg
    call    Print ; call the print function
    
    cli ; clear all interrupts
    hlt ; halt the system

times 510 - ($ - $$) db 0   ; we have to be 512 bytes, clear the rest of the bytes with 0 (510)
dw  0xaa55   ; boot signature