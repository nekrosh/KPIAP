    .model small
    .stack 100h 
    

    .data    
;**************************EQU************************************************************************************** 
columns EQU 78  
lines EQU 24
One EQU 1
Four EQU 4
Five EQU 5 
Seven EQU 7
Nine EQU 9
Ten EQU 10 
Fourteen EQU 14
twenty_six EQU 26
milliseconds EQU 32000

address_upper_left_corner EQU 00A2h
address_bottom_left_corner EQU 0F02h   
address_upper_right_corner EQU 013Ch
address_bottom_right_corner EQU 0F9Ch 
adress_plus_ten EQU 0864h

address_blocks EQU 0144h
max_blocks_in_lines EQU 19  ;below equal 19
max_lines EQU 4;below equal 6        
next_color EQU 1100h 
symbol_block EQU 08h


next_line EQU 0A0h 
one_byte EQU 02h 


lenth_platform EQU 24
speedPlatform EQU 6          

 
z_keyboard EQU 44
c_keyboard EQU 46 
Esc_keyboard EQU 01
space_keyboard EQU 57 



length EQU 46


    
adress_started_ball EQU 0E10h

;**************************Variables************************************************************************************** 
black_block dw 0020h
blue_block dw 1130h
green_block dw 22DBh
brown_block dw 55DBh
gray_block dw 702Fh
block dw 0000h

ball dw 66DBh  
address_ball dw adress_started_ball
X dw one_byte
Y dw next_line


flag db 00h



address_left_edge_platform dw 0E98h
address_right_edge_platform dw 0EC6h 


blocks_in_lines dw max_blocks_in_lines
address_for_blocks dw address_blocks                               
number_of_lines_with_blocks dw max_lines 

                          
number_of_blocks dw 00h 


score dw 00h
address_score dw length*one_byte+one_byte*one_byte
information db 'E',0Fh,'x',0Fh,'i',0Fh,'t',0Fh,':',0Fh,' ',0Fh,'P',0Fh,'r',0Fh,'e',0Fh,'s',0Fh,'s',0Fh,' ',0Fh, 'E',8Fh,'s',8Fh,'c',8Fh,'a',8Fh,'p',8Fh,'e',8Fh,' ',0Fh,' ',0Fh,'S',0Fh,'t',0Fh,'a',0Fh,'r',0Fh,'t',0Fh,':',0Fh,' ',0Fh,'P',0Fh,'r',0Fh,'e',0Fh,'s',0Fh,'s',0Fh,' ',0Fh, 'S',8Fh,'p',8Fh,'a',8Fh,'c',8Fh,'e',8Fh,' ',0Fh,' ',0Fh,'S',0CH,'c',0Ch,'o',0Ch,'r',0Ch,'e',0Ch,':',0Ch
symbol_color dw 0C00h
symbol_print dw 0000h
  
plus_ten1 dw 0020h,0020h,0020h,020h,0FFDBh,0020h,0020h,0FFDBh,0020h                     ;9*4
plus_ten2 dw 0020h,0FFDBh,0020h,0020h,0FFDBh,0020h,0FFDBh,0020h,0FFDBh
plus_ten3 dw 0FFDBh,0FFDBh,0FFDBh,0020h, 0FFDBh,0020h,0FFDBh,0020h,0FFDBh
plus_ten4 dw 0020h,0FFDBh,0020h,0020h,0FFDBh,0020h,0020h,0FFDBh,0020h 
clear_plus_ten1 dw 0020h,0020h,0020h,0020h,0020h,0020h,0020h,0020h,0020h 
clear_plus_ten2 dw 0020h,0020h,0020h,0020h,0020h,0020h,0020h,0020h,0020h 
clear_plus_ten3 dw 0020h,0020h,0020h,0020h,0020h,0020h,0020h,0020h,0020h 
clear_plus_ten4 dw 0020h,0020h,0020h,0020h,0020h,0020h,0020h,0020h,0020h

 
address_win_lose dw adress_plus_ten-Fourteen
you_win1 dw 0FFDBh,0020h,0FFDBh,0020h,0020h,0FFDBh,0020h,0020h,0FFDBh,0020h,0FFDBh,0020h,0FFDBh,0020h,0020h,0020h,0FFDBh,0020h,0FFDBh,0FFDBh,0FFDBh,0020h,0FFDBh,0020h,0020h,0FFDBh
you_win2 dw 0020h,0FFDBh,0020h,0020h,0FFDBh,0020h,0FFDBh,0020h,0FFDBh,0020h,0FFDBh,0020h,0FFDBh,0020h,0020h,0020h,0FFDBh,0020h,0020h,0FFDBh,0020h,0020h,0FFDBh,0FFDBh,0020h,0FFDBh
you_win3 dw 0020h,0FFDBh,0020h,0020h,0FFDBh,0020h,0FFDBh,0020h,0FFDBh,0020h,0FFDBh,0020h,0FFDBh,0020h,0FFDBh,0020h,0FFDBh,0020h,0020h,0FFDBh,0020h,0020h,0FFDBh,0020h,0FFDBh,0FFDBh   ;26*4
you_win4 dw 0020h,0FFDBh,0020h,0020h,0020h,0FFDBh,0020h,0020h,0020h,0FFDBh,0020h,0020h,0020h,0FFDBh,0020h,0FFDBh,0020h,0020h,0FFDBh,0FFDBh,0FFDBh,0020h,0FFDBh,0020h,0020h,0FFDBh

you_lose1 dw 0FFDBh,0020h,0FFDBh,0020h,0020h,0FFDBh,0020h,0020h,0FFDBh,0020h,0FFDBh,0020h,0FFDBh,0020h,0020h,0020h,0020h,0FFDBh,0020h,0020h,0020h,0FFDBh,0FFDBh,0020h,0FFDBh,0FFDBh 
you_lose2 dw 0020h,0FFDBh,0020h,0020h,0FFDBh,0020h,0FFDBh,0020h,0FFDBh,0020h,0FFDBh,0020h,0FFDBh,0020h,0020h,0020h,0FFDBh,0020h,0FFDBh,0020h,0FFDBh,0F5Fh,0020h,0020h,0FFDBh,0F5Fh
you_lose3 dw 0020h,0FFDBh,0020h,0020h,0FFDBh,0020h,0FFDBh,0020h,0FFDBh,0020h,0FFDBh,0020h,0FFDBh,0020h,0020h,0020h,0FFDBh,0020h,0FFDBh,0020h,0020h,0020h,0FFDBh,0020h,0FFDBh,0020h
you_lose4 dw 0020h,0FFDBh,0020h,0020h,0020h,0FFDBh,0020h,0020h,0020h,0FFDBh,0020h,0020h,0FFDBh,0FFDBh,0FFDBh,0020h,,0020h,0FFDBh,0020h,0020h,0FFDBh,0FFDBh,0020h,0020h,0FFDBh,0FFDBh

final_score db 'S',8CH,'c',8Ch,'o',8Ch,'r',8Ch,'e',8Ch,':',8Ch,' ',8Ch
;------------------------------------------Platform-----------------------------------------------------
platform MACRO address_platform
    LOCAL Metka3  
   
    mov di,address_platform  
    mov cx,lenth_platform
Metka3:
    push cx
    draw_block di,blue_block
    pop cx
loop Metka3

ENDM


platform_movement_left MACRO
    Local End_macro,Speed_platform 
    
    mov cx,speedPlatform
    
    
Speed_platform:
    push cx 
    mov bx,address_bottom_left_corner
    sub bx,next_line-one_byte  
    
    
    cmp address_left_edge_platform,bx
    je  End_macro   
    
    
    sub address_left_edge_platform,one_byte
    
    
    draw_block address_right_edge_platform,black_block   
    draw_block address_left_edge_platform,blue_block

            
    sub address_right_edge_platform,one_byte
    pop cx
    loop Speed_platform
    
            
END_macro:
ENDM  
    

platform_movement_right MACRO
    Local End_macro,Speed_platform 
    mov cx,speedPlatform
Speed_platform:
    push cx
    mov bx,address_bottom_right_corner
    sub bx,next_line+one_byte
    
    
    cmp address_right_edge_platform,bx
    je  End_macro
    
    add address_right_edge_platform,one_byte
    
      
    draw_block address_left_edge_platform,black_block 
    draw_block address_right_edge_platform,blue_block
    
    
    add address_left_edge_platform,one_byte
    pop cx
    loop Speed_platform
    
      
End_macro:      
ENDM 


;-------------------------------------------BALL--------------------------------------------------------
draw_ball MACRO address 
    mov di,address
    lea si,ball
    mov cx,One
    cld 
    movsw 
    
ENDM 


movement_boll MACRO
    draw_block address_ball,black_block
    mov di,address_ball
    sub di,Y
    add di,X
    mov address_ball,di
    draw_ball address_ball
    
ENDM 

;-------------------------------------------Blocks--------------------------------------------------------
draw_block MACRO address,color 
    mov di,address
    lea si,color
    mov cx,One
    cld 
    movsw 
    
ENDM

draw_block_big MACRO address,color
    LOCAL Metka
    mov cx,04h
    mov di,address
    
    Metka:
    push cx
    draw_block di,color
    add di,next_line-one_byte
    draw_block di,color
    sub di,next_line 
    pop cx
    loop Metka
               
               
ENDM

Clean_block_up_down MACRO  
    Local Clean,Exit_clean,Next                   
    mov cx,symbol_block
    
Clean:
    push cx
    
     
    cmp word ptr es:di,dx
    jne Next
    
    
    draw_block_big di,black_block
    pop cx 
    jmp Exit_clean
    
      
Next:
    add di,one_byte
    pop cx  
    
    
    loop Clean
Exit_clean:    
        
ENDM 




Clean_block_left_right MACRO  
    Local Clean,Exit_clean,Next
    
    
Clean:
    cmp word ptr es:di,dx
    jne Next
     
     
    draw_block_big di,black_block
    jmp Exit_clean
    
    
Next:
    add di,next_line
    jmp Clean 
    
    
Exit_clean:  
     
ENDM


blocks MACRO 
    LOCAL Next_block,Metka ,Exit,Half_block_down,Half_block_up
    mov cx,blocks_in_lines
    mov ax,address_for_blocks
    push ax 
    mov bx, green_block
    mov block,bx
    mov di,address_for_blocks 
Next_block:
    push cx 
    
    draw_block_big di,block
    inc number_of_blocks     
     
    mov dx,brown_block
    cmp block,dx
    jne Color_next
    mov bx,green_block
    mov block,bx
    jmp Exit
    
    
Color_next:  
    add block,next_color
    
    
Exit:
     pop cx
loop Next_block


    pop ax
    add ax,next_line+next_line+symbol_block
    mov address_for_blocks,ax 
    
ENDM



horizontal_wall MACRO address_horizontal_wall
    LOCAL Metka1
    
    mov cx,columns 
    mov di,address_horizontal_wall 
    
Metka1:
    push cx
    draw_block di,gray_block
    pop cx  
loop Metka1 


ENDM



vertical_wall MACRO address_vertical_wall
    LOCAL Metka2  
    mov cx,lines
    mov di,address_vertical_wall
Metka2:
    push cx
    draw_block di,gray_block 
    add di,next_line-one_byte 
    pop cx 
loop Metka2
ENDM  




;---------------------------------------------------------------------------------------

draw_ten MACRO address_,line,length_line,number 
    LOCAL LOOP_line 
    mov di,address_
    lea si,line
    mov cx,number 
LOOP_line:
    push cx    
    push di
    mov cx,length_line
    cld 
    rep movsw
    
    pop di
    add di,next_line   
    pop cx
    loop LOOP_line
    
ENDM    


delay MACRO 
    mov cx,0
    mov dx,milliseconds
    mov ah,86h
    int 15h
ENDM



counter MACRO 
    Local Bonus,Not_bonus,End_counter 
    dec number_of_blocks
    mov ax,number_of_blocks
    mov bl,Five
    div bl 
    cmp ah,00h
    je Bonus 
    add score,One
    jmp End_counter
Bonus:
    add score,Ten
    draw_ten adress_plus_ten, plus_ten1,Nine,Four   
    delay
    delay 
    draw_ten adress_plus_ten,clear_plus_ten1,Nine,Four
    jmp End_counter
Not_bonus:
    add score,One
End_counter:
    call refresh_score  
    cmp number_of_blocks,00h
    je Winner
ENDM 


;-----------------------------------------------------------------------------------------------------
    .code
Main:
    mov ax,@data
    mov ds,ax

    mov ax,0003h
    int 10h
    cld
    
    mov ax,0B800h
    mov es,ax    
    
    horizontal_wall address_upper_left_corner
    horizontal_wall address_bottom_left_corner
    vertical_wall address_upper_left_corner
    vertical_wall address_upper_right_corner 
    draw_ten one_byte,information,length,One
level:  
    blocks
    sub blocks_in_lines,02h 
    mov cx,number_of_lines_with_blocks
    dec number_of_lines_with_blocks
loop level


    platform address_left_edge_platform
    
       
Main_cycle: 
    delay 
    delay
    
 

    
    cmp Flag,One
    jne Metka:
    mov di,address_ball
    cmp di,0E62h
    jae Lose_game
    call Check_Ball
    movement_boll 
    
Metka:    
    mov ah,01h
    int 16h
    jz Main_cycle
    
    xor ah,ah
    int 16h
    
    cmp ah,Esc_keyboard
    je Exit_game           
    
    cmp ah,z_keyboard
    je  z_keyboard_pressed
    
    cmp ah,c_keyboard
    je c_keyboard_pressed 
    
    cmp ah,space_keyboard
    je Start_game
    
    jmp Main_cycle 

Start_game:
    cmp Flag,One
    je Main_cycle
    mov Flag,One
    mov bx,address_left_edge_platform
    sub bx,next_line
    add bx,lenth_platform
    mov address_ball,bx 
    draw_ball address_ball
    
    
    delay
    
    
    movement_boll
    jmp Main_cycle
    
z_keyboard_pressed:
    platform_movement_left
    jmp Main_cycle
    
    
c_keyboard_pressed:    
    platform_movement_right
    jmp Main_cycle
         
Winner:
draw_ten address_win_lose,you_win1,twenty_six,Four
jmp Score_game

Lose_game:
draw_ten address_win_lose,you_lose1,twenty_six,Four

Score_game: 
mov ax,address_win_lose
add ax,next_line*Four
draw_ten ax,Final_score,Seven,One
add ax,Seven
add ax,Seven
mov address_score,ax
call refresh_score 
    
Exit_game:  
    mov ax,4c00h
    int 21h   

    


;----------------------------------------------------------------------------
Check_Ball PROC  
Up:
    mov di,address_ball
    sub di,next_line
     
    cmp byte ptr es:di,0DBh
    jne NOT_Block1
    
     
    mov dx,word ptr es:di
    sub di,next_line+06h
    Clean_block_up_down
    
    
    counter
    
     
    mov ax,01h
    neg Y 
    
    jmp Down
    
NOT_Block1:    
    cmp byte ptr es:di,2Fh
    je Wall_up 


Down:
    mov di,address_ball
    add di,next_line 
     
    cmp byte ptr es:di,0DBh
    jne NOT_Block4
    
    mov dx,word ptr es:di
    sub di,06h
    Clean_block_up_down 
    
    
    counter
    
     
    mov ax,01h
    neg Y 
    jmp Left

   
NOT_Block4:        
    cmp byte ptr es:di,2Fh
    je Wall_up 
    
    
    cmp byte ptr es:di,30h
    je Platforma
      
     
Left: 
    mov di,address_ball
    sub di,02h 
    
    
    cmp byte ptr es:di,0DBh
    jne NOT_Block2
    
     
    mov dx,word ptr es:di
    sub di,next_line+06h
    Clean_block_left_right 
       
       
   counter
    
    
    mov ax,01h
    neg X
    
    jmp Right
   
NOT_Block2:    
    cmp byte ptr es:di,2Fh
    je Wall
    
    
     
     
Right:
    mov di,address_ball
    add di,02h 
    
    
    cmp byte ptr es:di,0DBh
    jne NOT_Block3  
    
    mov dx,word ptr es:di
    sub di,next_line
    Clean_block_left_right 
    
    
   counter
    
    
    mov ax,01h
    neg X 
    
     
NOT_Block3:     
    cmp byte ptr es:di,2Fh
    je Wall

     
    cmp ax,01h
    je Exit_Proc 
    
         
      
Left_up:
    mov di,address_ball
    sub di,Y
    add di,X
    cmp byte ptr es:di,0DBh
    jne Exit_proc  
    
    
    cmp X,one_byte
    je Right_up
    cmp Y,next_line
    jne Left_down
     
    sub di,next_line+06h
    draw_block_big di,black_block
    counter 
    neg Y 
    neg X 
    jmp Exit_proc
    
 
Left_down:

    sub di,06h
    
    draw_block_big di,black_block
    
    
   counter
    
    
    neg Y
    neg X 
    jmp Exit_proc
    
Right_up:
    cmp Y,next_line
    jne Right_down
    
    add di,next_line
    draw_block_big di,black_block
    counter
    neg Y
    neg X 
    jmp Exit_proc 
       
Right_down:

    draw_block_big di,black_block
    counter
    neg Y
    neg X 
    jmp Exit_proc
       

Wall_up:
    neg Y
    jmp Left
Wall:
    neg X 
    jmp Exit_Proc
Platforma:
    neg Y
    sub di,one_byte
    cmp byte ptr es:di,2Fh
    je Wall
    add di,one_byte+one_byte
    cmp byte ptr es:di,2Fh
    je Wall 
    jmp Exit_Proc
    

Exit_Proc:
  
ret
Check_ball ENDP   



refresh_score PROC 
   
    xor cx, cx 
    xor si,si
    mov cx, TEN 
    mov ax,score
    mov di,address_score
Calculate:
    xor dx,dx 
    div cx

    push dx
    inc  si
    cmp ax,00h
    jne Calculate
    mov cx,si
Out_put:
    
    pop dx
    push cx
    add dl, '0'
    add dx,symbol_color
    mov symbol_print,dx
    
    draw_block di,symbol_print
    pop cx
    loop Out_put
    
ret    
refresh_score ENDP    

end Main


       