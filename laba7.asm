.model SMALL

.stack 100h 


.data
crlf db lf,cr,'$'

cr EQU 0Ah
lf EQU 0Dh
Ten EQU 10
max_size_name EQU 126
number EQU 19h
offset_cmd_lenght EQU 0080h
offset_cmd_line EQU 0081h
space EQU 20h
ASCII_zero EQU 30h


;*************************************** 
buffer_for_args_cmd db max_size_name dup ('$')

args db 0
number_of_program_starts db 0
number_of_digits_in_number db 0 
address dw 0000h 

epb      dw 0
cmd_off  dw ?
cmd_seg  dw ?
fcb1     dd 0            
fcb2     dd 0



message_void_cmd db "Cmd is void.",lf,cr,'$'
message_overflow db "Overflow.",lf,cr,'$'
message_invalid_input db "Invalid_input.",lf,cr,'$'
message_file_not_founded db "File not found.",lf,cr,'$'
message_file_access_denied db "File access denied.",lf,cr,'$'
message_wrong_format db "Wrong format.",lf,cr,'$' 
message_out_of_memory db "Out of memory."
message_out_wrong_surroundings db "Wrong surroundings.",lf,cr,'$'
message_ES_contains_an_invalid_address db "ES contains an invalid address.",lf,cr,'$'
message_memory_control_unit_destroyed  db "Memory control unit destroyed.",lf,cr,'$'
;******************************************
output_message MACRO message   ;;Output message 
        mov dx,offset message
        mov ah,9
        int 21h
ENDM
data_segment_size=$-crlf


.code 

Main:
    mov ax,@data
    mov ds,ax 
 
;***************************************CMD*********************************************   
    
     cld 
Writing_args_command_line:
    xor cx,cx 
    mov cl,es:offset_cmd_lenght
    cmp cl,1
    jle Void_cmd 
      
     
    mov cx,-1
    mov di,offset_cmd_line
Find_parametres: 
    cmp args,02h
    je Read_cmd
    mov al,space
    repz scasb
     
    
    dec di
    push di
    inc args
     
    
    mov si,di
    
    call switch_ds_es
    
    
Scan_parametrs:
    lodsb 
    
    cmp al,lf
    je Switch
    
    
    
    cmp al,space   
    jne Scan_parametrs  


    mov di,si
    
    dec si
    push si
     
    call switch_ds_es 
    
    jmp Find_parametres
    
    
   
Void_cmd:
    output_message message_void_cmd  
    jmp End_programm
;************************************Open files*************************************************
Switch:
    dec si
    push si
    call switch_ds_es
Read_cmd: 
    cmp args,02h
    jb End_programm
    
    
    
    
    call switch_ds_es
    pop cx 
    mov es:address,cx

    pop si
     
    sub cx,si
    call switch_ds_es
    cmp cx,03h
    ja Overflow
    call switch_ds_es
    push cx 
    mov di, offset buffer_for_args_cmd
    rep movsb 
    call switch_ds_es
    
    
String_to_int:
    xor ax,ax 
    pop cx
    lea si,buffer_for_args_cmd 
    xor bx,bx
    mov bl,10
Number_calculation:  
        mov dl,byte ptr[si]
        cmp dl,'0'
        jb Not_number
        cmp dl,'9'
        ja Not_number  
        sub dl,ASCII_zero
        
        
        cmp cl,01h
        je Last_digit 
    
        add al,dl
        jc Overflow 
        cmp ax,number
        ja Overflow
        mul bl
        jc Overflow 
        inc si  
        Last_digit:
    
         
        loop Number_calculation  
        
        
        add al,dl
        jc Overflow
        cmp ax,0h
        je Not_number
        mov number_of_program_starts,al
        jmp Name_programm
        
        
        
Not_number:
    call crlf_str
    output_message message_invalid_input     
    jmp End_programm
    
    
Overflow:
    call crlf_str
    output_message message_overflow     
    jmp End_programm 
    
    
        
        
Name_programm:        
    call crlf_str 
    call switch_ds_es
    pop cx
    pop si 
    sub cx,si 
    mov di, offset buffer_for_args_cmd
    rep movsb  
    mov es:di,0
    call switch_ds_es
    
;------------------------------------------------------------------------------------------------------------
    
    mov ah,4Ah      
    mov bx,((segment_code_size/16)+1)+256/16+((data_segment_size/16)+1)+256/16;
    int 21h
    jc Error_resizing_memory_block
    jmp Open_programm 
     
     
Error_resizing_memory_block:
    cmp ax,07
    je Memory_control_unit_destroyed 
    cmp ax,08 
    je Out_of_memory1
    cmp ax,09 
    je ES_contains_an_invalid_address    


Memory_control_unit_destroyed:
    output_message message_memory_control_unit_destroyed
    jmp End_programm
    
    
Out_of_memory1:    
   output_message message_out_of_memory
   jmp End_programm
   
       
ES_contains_an_invalid_address:
   output_message message_ES_contains_an_invalid_address 
   jmp End_programm 
   
   
   
       
Open_programm:         
    xor cx,cx
    mov cl,number_of_program_starts
     
Cycle_open_programm:
    push cx       
    mov dx,address
    sub dx,offset_cmd_line
    mov cl,es:offset_cmd_lenght
    sub cl,dl
    mov di,address
    dec di
    mov es:di,cl  
    mov cmd_off,di
    mov cmd_seg,es
    
    
    push es 
    mov ax,@data
    mov es,ax
    
    
    mov ax,4b00h        
    lea dx,buffer_for_args_cmd       
    lea bx,epb     
    int 21h
    jc Error_starting_and_executing_a_program
    
    
        
    pop es
    pop cx
    loop Cycle_open_programm
    jmp End_programm 

Error_starting_and_executing_a_program:
   cmp ax,02h
   je File_not_found
   cmp ax,05h
   je File_access_denied
   cmp ax,08h
   je Out_of_memory
   cmp ax,0Ah
   je Wrong_surroundings
   cmp ax,0Bh
   je Wrong_format
File_not_found:
   output_message message_file_not_founded
   jmp End_programm
   
   
File_access_denied:
   output_message message_file_access_denied
   jmp End_programm
   
    
Out_of_memory:    
   output_message message_out_of_memory
   jmp End_programm
   
   
Wrong_surroundings:
   output_message message_out_wrong_surroundings
   jmp End_programm 
   
   
Wrong_format:
   output_message message_wrong_format 
   jmp End_programm


End_programm:

     mov ax,4c00h
     int 21h 




crlf_str PROC                  ;Go to a new line
        mov dx, offset crlf
        mov ah, 9h
        int 21h  
        ret
crlf_str ENDP 



switch_ds_es PROC 
    mov ax,ds
    mov bx,es
    mov ds,bx
    mov es,ax
    ret
switch_ds_es   ENDP


segment_code_size=$-Main   
END Main
