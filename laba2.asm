.model SMALL
.stack 100h

;**************************EQU************************************************************************************** 
max_length_buffer EQU 201  
cr EQU 0Ah
lf EQU 0Dh
 
 
;**************************DATA*************************************************************************************
.data      

 
;--------------------------MESSAGES---------------------------------------------------------------------------------
message_task db "Task 12.Insert another specified word in the line before the specified word.",lf,cr,'$'
message_remark db "Remark: string length + inserted word length<=198 symbols.",lf,cr,'$'
message_input_str db "Input string:",lf,cr,'$'
message_input_word_from_string db "Enter the word from string before which you want to insert the word:",lf,cr,'$'
message_input_word_which_insert db "Enter the word,which you want to insert:",lf,cr,'$'
message_enter_the_word db "Enter the word:",lf,cr,'$'
message_invalid_input db "Invalid_input.",lf,cr,'$'
message_void_input db "You have not entered anything.",lf,cr,'$'
message_repeat db "Want to repeat(Y/N)?",lf,cr,'$'
message_word_not_found db "Word not found.",lf,cr,'$'
message_your_string db "Your string:",lf,cr,'$' 
message_not_place_for_word db "There is no place to insert a word.",'$'

;--------------------------Variables--------------------------------------------------------------------------------
crlf db lf,cr,'$'


;--------------------------Variables for string---------------------------------------------------------------------
buffer_str db max_length_buffer 
length_str db ?
str db 201 dup ('$') 


;--------------------------Variables for word from string-----------------------------------------------------------
length_word_from_string db ?
buffer_for_word db 201 dup ('$')
addres_word_from_string dw ?

;--------------------------Variables for insert word----------------------------------------------------------------
length_word_insert db ? 


;**************************End DATA*********************************************************************************


              
;**************************MACROS*********************************************************************************** 
output_message MACRO message   ;;Output message 
        mov dx,offset message
        mov ah,9
        int 21h
ENDM 

    
;-------------------------------------------------------------------------------------------------------------------
input_str MACRO max_length_str ;;Input string 
        mov dx,offset max_length_str  
        mov ah,0Ah
        int 21h
        mov di,offset max_length_str	
ENDM


;---------------------------------------------------------------------------------------------------------------------
input_word MACRO max_symbols,address_buffer ;;Input word
    LOCAL Input_word,Input_letter,Repeat_input_word,Exit_input_word,Word_void_check,Invalid_input,Repeat_input 
        jmp Input_word 
    Repeat_input:
        call crlf_str
        output_message message_enter_the_word
    
    Input_word:
         
        xor cx,cx 
        mov cl,max_symbols
        mov bx,address_buffer
    
    
    Input_letter: 
    
        mov ah,01h  ;;Input letter
        int 21h
    
    
        call Check_symbol  ;;The procedure checks the entered symbol. 
                           ;;If the character is Enter, then ah = 02h.
                           ;;If the character is a other symbols, then ah = 01h.
                           ;;If the character is not a letter, then ah = 00h. 
        cmp ah,00h
        je Invalid_input
        cmp ah,02h
        je Word_void_check 
        
        
        mov byte ptr [bx],al  ;; Writing letters to the buffer
        inc bx
        LOOP Input_letter 
        
        ;;Input word is finished
        jmp Exit_input_word   
        
        
    Invalid_input:
        call crlf_str
        output_message message_invalid_input
        
        
    Repeat_input_word:
        output_message message_repeat
        
        mov ah,01h ;;input letter
        int 21h 
        cmp al,'Y'
        je Repeat_input
        cmp al,'N'
        je Output_str 
        
        call crlf_str 
        output_message message_invalid_input 
        jmp Repeat_input_word 
    
    
    Word_void_check: 
        cmp bx,address_buffer
        jne Exit_input_word
        output_message message_void_input
        je Repeat_input_word:

    Exit_input_word: 
ENDM 


;-------------------------------------------------------------------------------------------------------------------
Check_symbol_for_letter MACRO
        call Check_symbol
        cmp ah,01h
        je Continue_searching
ENDM


;*************************END MACROS********************************************************************************



  
;**************************CODE*************************************************************************************
.code 


    Main:  
        mov ax,@data
        mov ds,ax 
        mov es,ax


        output_message message_task
        output_message message_remark


    Input_string:
        ;Input string
        output_message message_input_str 
        input_str buffer_str
        
        
        ;Check string for void
        mov al,length_str
        cmp al,00h
        je  Void_string
        
        
        ;Check string buffer for full
        mov bl,buffer_str
        sub bl,03h       ;The minimum number of characters to insert a word=
                         ;= 3 (' '+1(minimum word length)+'$'(end string))  
        cmp al,bl        
        ja Not_place_for_word 


    Input_word_from_string:
        ;Input word from string
        
        call crlf_str      ;;Go to a new line
        output_message message_input_word_from_string
        
        
        mov si,offset buffer_for_word
        input_word length_str, si
         
         
        ;Word from string length calculation
        mov ax,bx
        sub ax,offset buffer_for_word
        mov length_word_from_string,al 
        
        
        ;Search word in string and record of his address
        call Search_word_in_string
        dec dx
        mov addres_word_from_string,dx
        

    Input_word_to_insert:
        ;The word is written at the end of the line.
        
        
        call crlf_str      ;;Go to a new line
        output_message message_input_word_which_insert
        
        
        ;Calculation of the maximum length of the inserted word
        mov al,buffer_str
        sub al,02h
        sub al,length_str
        mov length_word_insert,al
        
        
        ;Calculation of the last address of a string + 1
        xor ax,ax
        mov al,length_str 
        mov bx,offset str 
        add bx,ax
        mov si,bx
        
        
        input_word length_word_insert,si ;Write a word to the end of a string
        
        
        ;Calculating the length of the entered word
        mov ax,bx
        sub ax,si
        mov length_word_insert,al
        
        
        
        mov byte ptr [bx],' ' ; Write ' ' to the end of a word
        inc length_word_insert  ;Increase in word length (+1)
        
        
        ;Calculating the length of a string with an inserted word
        mov al,length_word_insert
        add length_str,al
        
        ;Insert the entered word with ' ' before the word from string 
        call Insert_word
        jmp Output_str
        
    Not_place_for_word: 
        call crlf_str
        output_message message_not_place_for_word
        
    Output_str: 
        call crlf_str
        output_message message_your_string 
        call Output_string 
        jmp Exit_programm 
        
    Void_string:
      output_message message_void_input

 

    Exit_programm:
        mov ax,4c00h
        int 21h         
        
             
;**************************Procedures********************************************************************************
crlf_str PROC                  ;Go to a new line
        mov dx, offset crlf
        mov ah, 9h
        int 21h  
        ret
crlf_str ENDP


;--------------------------------------------------------------------------------------------------------------------
Check_symbol PROC   ;The procedure checks the entered symbol. 
                    ;If the character is Enter, then ah = 02h.
                    ;If the character is a other symbols, then ah = 01h. 
                    ;If the character is not a letter, then ah = 00h.
        mov ah,01h
        
         
        cmp al,0dh
        je End_word
        cmp al,'A'
        jb Invalid_input_letter
        cmp al,'Z'
        jbe Output_from_PROC
        cmp al,'a'
        jb Invalid_input_letter
        cmp al,'z'
        jbe Output_from_PROC 
        
           
    Invalid_input_letter:
        mov ah,00h
        jmp Output_from_PROC
        
         
    End_word:
        mov ah,02h
        
         
    Output_from_PROC:
        ret 
Check_symbol ENDP

    
;---------------------------------------------------------------------------------------------------------------
Search_word_in_string PROC
        
        xor cx,cx
        lea dx,str
        mov bl,length_str
        
        
    Continue_searching:
        cld 
        
        cmp bl,00h
        je  Word_not_found
        
        
        lea di,dx ;  
        mov al,byte ptr buffer_for_word  ;Writing the first symbol of the inserted word
         
        mov cl,bl  ;cl=lenght string
        
        repne SCASB    ;Search for the first symbol of the inserted word
        jne Word_not_found
        
        mov dx,di ;Storing the address of the found symbol +1
        mov bl,cl ;Storing the number of unread symbols in a string 
        
        
        
        sub di,1           ;Checking beginning
        cmp di,offset str  ;of string
        je  Comparison_with_insert_word              
        mov al,byte ptr [di-1] ;Checking the symbol for a letter.If the character is a letter
                               ;it is not the beginning of the word
        Check_symbol_for_letter 
    
    
     Comparison_with_insert_word:
        cld
        mov cl,length_word_from_string
        mov si,offset buffer_for_word
        repe CMPSB
        jne Continue_searching
    
    
      
    Check_for_word:
        mov al,byte ptr [di] ;Checking the symbol for a letter.If the character is a letter
                             ;it is not the end of the word
        Check_symbol_for_letter
        jmp  Output_from_PROCEDURE


    Word_not_found: 
        call crlf_str
        output_message message_word_not_found 
        
        
    Repeat_input_word:
        output_message message_repeat
        mov ah,01h
        int 21h 
        cmp al,'Y'
        je Input_word_from_string:
        cmp al,'N'
        je Output_str   
        call crlf_str 
        output_message message_invalid_input 
        jmp Repeat_input_word
              
    Output_from_PROCEDURE:       
    ret
Search_word_in_string ENDP


;-------------------------------------------------------------------------------------------------------------
Insert_word PROC  ;Insert the entered word befor addres_word_from_string 
    xor cx,cx 
    xor ax,ax
    mov di,addres_word_from_string
     
     
    ;Calculating the number of symbols before addres_word_from_string
    mov dx,offset str
    mov al,length_str
    add dx,ax
    sub dx,di  
    ;dl = the number of symbols before addres_word_from_string
    mov dh,length_word_insert  
    
    
    
    Loop2:
    ;Address of the last character of the string
    mov si, offset str
    mov al,length_str
    add si,ax
    dec si
    
    
    
    mov al,byte ptr [si] ;Record symbol from insert word
    mov cl,dl ;The number of symbols before addres_word_from_string
              ;which must be presented by one byte
    
    
    loop1: ;Symbol offset one byte to the right
    dec si
    mov bl, byte ptr [si]
    inc si 
    mov  [si],bl
    dec si
    loop loop1
    
     
    mov  byte ptr [di],al ;Record symbol from insert word before addres_word_from_string
     
    mov cl,dh ;The remaining number of characters of the inserted word
    dec dh    
    loop Loop2
    
     
    ret
Insert_word ENDP

;--------------------------------------------------------------------------------------------------------------------
Output_string PROC 
    xor cx,cx
    mov cl,length_str
    mov bx,offset str
    
    
    Output_symbol:
    mov ah,02h
    mov dl,[bx]
    int 21h
    inc bx
    loop Output_symbol
    ret
Output_string ENDP


;**********************************END PROCEDURE***********************************************************************


END Main   




 





