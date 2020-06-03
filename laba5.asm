.model SMALL

.stack 100h 

a db "a.txt",0
cr EQU 0Ah
lf EQU 0Dh
Ten EQU 10
max_size_name EQU 126

offset_cmd_lenght EQU 0080h
offset_cmd_line EQU 0081h
space EQU 20h
ASCII_zero EQU 30h

.data
args db 0
buffer_for_name_file db max_size_name dup ('$')
buffer db 8 dup ('$'),
message_void_cmd db "Cmd is void.",lf,cr,'$'
message_first_file_size db "First file size: " ,'$',
message_second_file_size db "Second file size: ",'$'
message_file_not_founded db "File not founded.",lf,cr,'$'
message_files_not_founded db "Files not founded.",lf,cr,'$'
message_file_path_not_founded db "File path is not founded.",lf,cr,'$'
message_many_open_files db "Many open files.",lf,cr,'$'
message_access_denied db "Access denied",lf,cr,'$'
message_invalid_access_mode db "Invalid access mode",lf,cr,'$' 
message_file_first_equal_file_second db "File first = file second.",lf,cr,'$'
message_file_first_below_file_second db "File first < file second.",lf,cr,'$'
message_file_first_above_file_second db "File first > file second.",lf,cr,'$'
file_number dw ?
size_first_file dd -1
size_second_file dd -1
crlf db lf,cr,'$'
output_message MACRO message   ;;Output message 
        mov dx,offset message
        mov ah,9
        int 21h
ENDM


Size_to_string MACRO  number
LOCAL Calculate1,Out_put1,Calculate,Out_put
    mov bx,word ptr number[2]
    push bx 
    mov bx,word ptr number
    push bx  
    xor cx, cx 
    xor si,si
    mov cx, TEN 
    mov di, offset buffer
Calculate:
    xor dx,dx 
    mov ax,word ptr number[2]
    div cx
    mov word ptr number[2],ax
    mov ax,byte ptr number
    div cx
    mov word ptr number,ax
    push dx
    inc si
    cmp number[2],00h
    jne Calculate
    cmp number,00h
    jne Calculate
    mov cx,si  
Out_put:
    pop dx
    push cx
    add dl,'0'
    mov byte ptr [di],dl
    inc di
    
    pop cx
    loop Out_put
    pop bx
    mov word ptr number ,bx
    pop bx 
    mov word ptr number[2],bx
      
        
ENDM 

.code 

Main:
    mov ax,@data
    mov ds,ax 
 
;***************************************CMD*********************************************   
     mov ax,word ptr size_second_file
    mov dx,word ptr size_second_file[2]
    
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
    je Open_files
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
Open_files: 
    cmp args,0
    je  Files_not_open   
    
    call switch_ds_es
    pop cx
    pop si 
    sub cx,si 
    mov di, offset buffer_for_name_file
    rep movsb
    
    mov es:di,0
    call switch_ds_es
    output_message buffer_for_name_file
    
  
    
    
    mov al,00h
    mov ah, 3Dh
    lea dx,buffer_for_name_file
    int 21h
    
    jc Faild_open_file
Metka:     
    mov file_number,ax
    
    
    
    
;******************************Size_file***************************************
Size_file:

    
        
    xor cx,cx
    xor dx,dx
    mov ah,42h
    mov al,02h
    mov bx,file_number
    int 21h
   
    
    cmp args,02h
    je Second_file

Firs_file:
    mov word ptr size_first_file,ax
    mov word ptr size_first_file[2],dx
    
    
    mov ah,3Eh
    mov bx,file_number
    int 21h
    output_message message_first_file_size 
    Size_to_string size_first_file
    output_message buffer  
    call crlf_str 

    jmp Comparison    
    
    
Second_file:

 
    mov word ptr size_second_file,ax
    mov word ptr size_second_file[2],dx 
    
    mov ah,3Eh
    mov bx,file_number
    int 21h

    output_message message_second_file_size 
    Size_to_string size_second_file
    output_message buffer 
    dec args  
    call crlf_str
    
    jmp Open_files


Comparison:
    mov ax,word ptr size_second_file
    mov dx,word ptr size_second_file[2]
    
    
    
    
     
    cmp word ptr size_second_file,0
    jnl Comparison1  
    cmp word ptr size_second_file[2],0
    jnl Comparison1 
    jmp End_programm
Comparison1:
    mov ax,word ptr size_second_file[2] 
    cmp word ptr size_first_file[2],ax
    jb File_first_below_file_second
    ja File_first_above_file_second
    
    mov ax,word ptr size_second_file
    cmp word ptr size_first_file,ax
    jb File_first_below_file_second
    ja File_first_above_file_second
    
    output_message message_file_first_equal_file_second
    jmp End_programm
File_first_below_file_second:
    output_message message_file_first_below_file_second
    jmp End_programm 
File_first_above_file_second:
    output_message message_file_first_above_file_second
    jmp End_programm


Faild_open_file:
  
    dec args
    cmp ax,0Ch
    je Invalid_access_mode
    
    cmp ax,03h
    je File_path_not_founded
    
    cmp ax,04h
    je Many_open_files 
    
    cmp ax,05h
    je Access_denied
    
    output_message message_file_not_founded
    jmp Open_files 

Invalid_access_mode:
    output_message message_invalid_access_mode
    jmp Open_files
    
File_path_not_founded:
    output_message message_file_path_not_founded
    jmp Open_files
    
     
Many_open_files:
    output_message message_many_open_files
    jmp Open_files
    
         
Access_denied:
    output_message message_access_denied
    jmp Open_files 
    
    
        
Files_not_open:
    output_message message_files_not_founded   
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
END Main




 