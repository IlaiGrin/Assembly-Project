IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
Address dw ?
x_frame dw ?
y_frame dw ?
x_green dw 160
y_green dw 170
x_red1 dw 312
x_red2 dw 12
x_red3 dw 312
x_red4 dw 12
x_red dw 300
x_coin dw 100
y_red dw ?
y_red1 dw ?
y_red2 dw ?
y_red3 dw ?
y_red4 dw ?
y_coin dw 100
coin dw 0
red_direction dw 0
red_direction1 dw -2
red_direction2 dw 2
red_direction3 dw -2
red_direction4 dw 2
color dw 2		;green
len db 10
ten db 10
Level db "Level:$"
LevelNumUnits dw 1
LevelNumTens dw 0
LevelNum dw 1
ScoreNum dw 0
HeartColor db 4
HeartNum db 3
lost_string db "press r to restart$"
score_string db "Score:$"
open1 db "Don't Touch The Red Squar$"
open2 db "By Ilai Grinberg$"
open3 db "Press Space To Start$"
CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
mov ax, 13h		;graphic mode
int 10h

mov bh, 0
mov dh, 2 		; Row number
mov dl, 8      ; Column number
mov ah, 2 
int 10h

mov dx, offset open1
mov ah, 9h
int 21h

mov bh, 0
mov dh, 5 		; Row number
mov dl, 12      ; Column number
mov ah, 2 
int 10h

mov dx, offset open2
mov ah, 9h
int 21h

mov bh, 0
mov dh, 8 		; Row number
mov dl, 10      ; Column number
mov ah, 2 
int 10h

mov dx, offset open3
mov ah, 9h
int 21h

get_Space:
mov ah, 1h		;קליטת תו מהמקלדת
int 16h
jz get_Space
mov ah, 0h		;קריאת תו מהמקלדת
int 16h
cmp al, 32
je start_Game
jmp get_Space

start_Game:
mov ax, 13h		;graphic mode
int 10h

mov [HeartNum], 3
mov [LevelNumUnits], 1
mov [LevelNumTens], 0
mov [LevelNum], 1
mov [ScoreNum], 0
new_Level:
mov [coin], -1
; put segment number in 
; register es
mov ax, 40h
mov es, ax
mov ax, [es:6Ch]
; מכבה את הביט האחרון כדי שיתקבל התחום הרצוי
and ax, 00011111b
add ax, 30

mov [y_red1], ax
cmp [y_red1], 90
ja redsAbove
mov [y_red2], ax
add [y_red2], 25

mov [y_red3], ax
add [y_red3], 50

mov [y_red4], ax
add [y_red4], 75

jmp get_Coin
redsAbove:
mov [y_red2], ax
sub [y_red2], 25

mov [y_red3], ax
sub [y_red3], 50

mov [y_red4], ax
sub [y_red4], 75

get_Coin:
inc [coin]
mov [color], 0
call draw_coin
; put segment number in 
; register es
mov ax, 40h
mov es, ax
mov al, [es:6Ch]
cmp ax, 300
ja sub_xcoin
cmp ax, 20
jb add_xcoin
jmp xcoin
sub_xcoin:
sub ax, 10
jmp xcoin
add_xcoin:
add ax, 10
xcoin:
mov [x_coin], ax
;המיקום של המטבע צריך להיות בין המיקום האנכי של האדומים
and ax, 00111111b
cmp [y_red1], 90
ja add_y4
add ax, [y_red1]
jmp con11
add_y4:
add ax, [y_red4]
con11:
mov [y_coin], ax
jmp Game

delete_Heart:
mov bh, 0
mov dh, 4 		; Row number
mov dl, [HeartNum]      ; Column number
mov ah, 2 
int 10h
mov [HeartColor], 0
mov ah, 9		;interrupt code 
mov al, 3		;character to display  - asci code
mov	bh,0h		;Page - always 0
mov bl, [HeartColor]	;BL =  Foreground 
mov cx, 1		;number of times to write character 
int 10h
call draw_Frame
cmp [HeartNum], 0
jnz Game
jmp fin
Game:

print_Hearts:
mov bh, 0
mov dh, 4 		; Row number
mov dl, 0      ; Column number
mov ah, 2 
int 10h
mov [HeartColor], 4
xor cx, cx
mov ah, 9		;interrupt code 
mov al, 3		;character to display  - asci code
mov	bh,0		;Page - always 0
mov bl, [HeartColor]	;BL =  Foreground 
mov cl, [HeartNum]		;number of times to write character 
int 10h	

cmp [coin], 1
je print_Level
mov [color], 6
call draw_coin

print_Level:
cmp [LevelNumUnits], 10
jb Single_digit
double_digit:
cmp [LevelNumUnits], 10
je level_tens
jmp con10
level_tens:
inc [LevelNumTens]
mov [LevelNumUnits], 0
con10:
mov  dl, 6   ;Column
mov  dh, 0   ;Row
mov  bh, 0    ;Display page
mov  ah, 02h  ;SetCursorPosition
int  10h
mov ax, [LevelNumTens]
div [ten]				
add ax, '00'		
mov dx, ax
mov ah, 2h
mov dl, dh
int 21h
Single_digit:
mov  dl, 7   ;Column
mov  dh, 0   ;Row
mov  bh, 0    ;Display page
mov  ah, 02h  ;SetCursorPosition
int  10h
mov ax, [LevelNumUnits]
div [ten]				
add ax, '00'		
mov dx, ax
mov ah, 2h
mov dl, dh
int 21h

mov bh, 0
mov dh, 0 		; Row number
mov dl, 0      ; Column number
mov ah, 2 
int 10h
;print the word "Level"
mov dx, offset Level
mov ah, 9h
int 21h

mov bh, 0
mov dh, 2 		; Row number
mov dl, 0      ; Column number
mov ah, 2 
int 10h
;print the word "Score"
mov dx, offset score_string
mov ah, 9h
int 21h
print_score:
mov  dl, 6   ;Column
mov  dh, 2   ;Row
mov  bh, 0    ;Display page
mov  ah, 02h  ;SetCursorPosition
int  10h
mov ax, [ScoreNum]
div [ten]				
add ax, '00'		
mov dx, ax
mov ah, 2h
mov dl, dh
int 21h

call draw_Frame
RedSquarMoves:
push [y_red1]
push [x_red1]
mov [color], 4		;red
call draw_RedSquar
push [y_red2]
push [x_red2]
mov [color], 4
call draw_RedSquar
push [y_red3]
push [x_red3]
mov [color], 4
call draw_RedSquar
push [y_red4]
push [x_red4]
mov [color], 4
call draw_RedSquar
mov cx, 0h
mov dx, 2710h
mov ah, 86h
push [x_green]		;שומר את ערכו של x_green
int 15h			;wait 0.01 seconds
pop [x_green]		;משחזר את ערכו של x_green
mov [color], 0
push [y_red1]
push [x_red1]
call draw_RedSquar
push [y_red2]
push [x_red2]
call draw_RedSquar
push [y_red3]
push [x_red3]
call draw_RedSquar
push [y_red4]
push [x_red4]
call draw_RedSquar
; בודק אם הריבוע האדום הגיע לקצוות
mov ax, [red_direction1]
add [x_red1], ax
mov ax, [red_direction2]
add [x_red2], ax
mov ax, [red_direction3]
add [x_red3], ax
mov ax, [red_direction4]
add [x_red4], ax

push [x_red1]
call Red_Direction0
cmp [red_direction], 0
jz skip1
mov ax, [red_direction]
mov [red_direction1], ax
skip1:
push [x_red2]
call Red_Direction0
cmp [red_direction],0
jz skip2
mov ax, [red_direction]
mov [red_direction2], ax
skip2:
push [x_red3]
call Red_Direction0
cmp [red_direction],0
jz skip3
mov ax, [red_direction]
mov [red_direction3], ax
skip3:
push [x_red4]
call Red_Direction0
cmp [red_direction],0
jz GreenSquarMoves
mov ax, [red_direction]
mov [red_direction4], ax

GreenSquarMoves:
mov [color], 2
call draw_GreenSquar
checkIfGreenTouchRed:
; בודק שהריבוע לא נגע בריבוע האדום
push [y_red1]
push [x_red1]
call Check
push [y_red2]
push [x_red2]
call Check
push [y_red3]
push [x_red3]
call Check
push [y_red4]
push [x_red4]
call Check

; בודק אם הריבוע אסף את המטבע
push [y_coin]
push [x_coin]
call Check

checkFrame:
; בודק שהריבוע לא יצא מהמסך
cmp [y_green], 5		
je jmpRestart2
cmp [y_green], 200 
je jmpRestart2
cmp [x_green], 320
je jmpRestart2
cmp [x_green], 10
je jmpRestart2

mov ah, 1h		;קליטת תו מהמקלדת
int 16h
jz JmpGame
mov [color], 0		; draw black rectangle
call draw_GreenSquar
mov ah, 0h		;קריאת תו מהמקלדת
int 16h
cmp al, 119		;תו w
je suby
cmp al, 115		;תו s
je addy
cmp al, 100 	;תו d
je addx
cmp al, 97 		;תו a
je subx
jmp Game
jmpRestart2:
jmp restart

JmpGame:
jmp Game

addy:
add [y_green], 5
mov [color], 2
call draw_GreenSquar
jmp Game

suby:
sub [y_green], 5
mov [color], 2
call draw_GreenSquar
jmp Game

addx:
add [x_green], 5
mov [color], 2
call draw_GreenSquar
jmp Game

subx:
sub [x_green], 5
mov [color], 2
call draw_GreenSquar
jmp Game

restart:
cmp [y_green], 5
je pass1
jmp end_restart
pass1:
cmp [x_green], 167
jb pass2
jmp end_restart
pass2:
cmp [x_green], 153
ja next_Level
jmp end_restart
next_Level:
add [LevelNum], 1
add [LevelNumUnits], 1
mov [color], 0		; draw black rectangle
call draw_GreenSquar
call draw_Frame
mov [y_green], 170
mov [x_green], 160
jmp new_Level
end_restart:
mov [color], 0		; draw black rectangle
call draw_GreenSquar
call draw_Frame
mov [y_green], 170
mov [x_green], 160
jmp Game

jmpRestart:
jmp restart

JmpGame2:
jmp Game

collect_coin:
inc [ScoreNum]
cmp [ScoreNum], 3
je extra_life
jmp get_Coin
extra_life:
mov [ScoreNum], 0
inc [HeartNum]
jmp get_Coin

touchRed:
cmp [y_green], 170
je JmpGame2
pop ax
cmp ax, [x_coin]
je collect_coin
mov [color], 0		; draw black rectangle
call draw_GreenSquar
call draw_Frame
mov [y_green], 170
mov [x_green], 160
dec [HeartNum]
jmp delete_Heart

fin:
mov cx, 07h
mov dx, 0a120h
mov ah, 86h
int 15h

mov  dl, 10   ;Column
mov  dh, 10   ;Row
mov  bh, 0    ;Display page
mov  ah, 02h  ;SetCursorPosition
int  10h
mov dx, offset lost_string
mov ah, 9h
int 21h
getR:
mov ah, 0h		;קריאת תו מהמקלדת
int 16h
cmp al, 114		;תו r
jne getR
jmp start_Game

jmpTouchRed: 
jmp touchRed
exit:
	mov ax, 4c00h
	int 21h

proc Check
pop [Address]
pop [x_red]
pop [y_red]
push [x_red]		;כדי לבדוק בהמשך אם זה היה המטבע או ריבוע אדום
checkX:
mov ax, [x_red]	
mov cx, 10
loopCheckX1:
cmp [x_green], ax   
je checkY
dec ax
loop loopCheckX1
mov ax, [x_green]
mov cx, 10
loopCheckX2:
cmp [x_red], ax   
je checkY
dec ax
loop loopCheckX2
jmp return2
checkY:
mov ax, [y_red]
mov cx, 10
loopCheckY1:
cmp [y_green], ax   
je jmpTouchRed
dec ax
loop loopCheckY1
mov ax, [y_green]
mov cx, 10
loopCheckY2:
cmp [y_red], ax   
je jmpTouchRed
dec ax
loop loopCheckY2
return2:
push [Address]
ret
endp Check	

proc Red_Direction0
pop [Address]
pop [x_red]
mov [red_direction], 0
cmp [x_red], 312
je red_left1
cmp [x_red], 12
je red_right1
jmp return

red_left1:
cmp [LevelNum], 5
ja red_left2
mov [red_direction], -2
jmp return
red_right1:
cmp [LevelNum], 5
ja red_right2
mov [red_direction], 2
jmp return

red_left2:
cmp [LevelNum], 10
ja red_left3
mov [red_direction], -3
jmp return
red_right2:
cmp [LevelNum], 10
ja red_right3
mov [red_direction], 3
jmp return

red_left3:
cmp [LevelNum], 12
ja red_left4
mov [red_direction], -4
jmp return
red_right3:
cmp [LevelNum], 12
ja red_right4
mov [red_direction], 4
jmp return

red_left4:
mov [red_direction], -6
jmp return
red_right4:
mov [red_direction], 6


return:
push [Address]
ret
endp Red_Direction0

proc draw_GreenSquar

mov [len], 10
loopDrawSquar1:
mov si, 10
loopDrawLine1:
xor bh, bh
mov cx, [x_green]
mov dx, [y_green]
mov ax, [color]
mov ah, 0ch
int 10h
dec si
dec [x_green]
cmp si,0
jnz loopDrawLine1
dec [len]
dec [y_green]
add [x_green], 10
cmp [len], 0
jnz loopDrawSquar1
add [y_green], 10
push [x_green]		;שומר את הערכים של x y
push [y_green]
;print the eyes
mov [color], 0
sub [y_green], 6
sub [x_green], 1
xor bh, bh
mov cx, [x_green]
mov dx, [y_green]
mov ax, [color]
mov ah, 0ch
int 10h

sub [x_green], 6
xor bh, bh
mov cx, [x_green]
mov dx, [y_green]
mov ax, [color]
mov ah, 0ch
int 10h

pop [y_green]
pop [x_green]
mov [color], 2
ret
endp draw_GreenSquar

proc draw_RedSquar
pop [Address]
pop [x_red]
pop [y_red]

mov [len], 10
loopDrawSquar2:
mov si, 10
loopDrawLine2:
xor bh, bh
mov cx, [x_red]
mov dx, [y_red]
mov ax, [color]
mov ah, 0ch
int 10h
dec si
dec [x_red]
cmp si,0
jnz loopDrawLine2
dec [len]
dec [y_red]
add [x_red], 10
cmp [len], 0
jnz loopDrawSquar2
add [y_red], 10

mov [color], 0
push [x_red]		;שומר את הערכים של x y
push [y_red]
;print the eyes
mov [color], 0
sub [y_red], 6
sub [x_red], 1
xor bh, bh
mov cx, [x_red]
mov dx, [y_red]
mov ax, [color]
mov ah, 0ch
int 10h

sub [x_red], 6
xor bh, bh
mov cx, [x_red]
mov dx, [y_red]
mov ax, [color]
mov ah, 0ch
int 10h

pop [y_red]
pop [x_red]

push [Address]
ret
endp draw_RedSquar

proc draw_coin
push ax 

mov [len], 10
loopDrawSquar3:
mov si, 10
loopDrawLine3:
xor bh, bh
mov cx, [x_coin]
mov dx, [y_coin]
mov ax, [color]
mov ah, 0ch
int 10h
dec si
dec [x_coin]
cmp si,0
jnz loopDrawLine3
dec [len]
dec [y_coin]
add [x_coin], 10
cmp [len], 0
jnz loopDrawSquar3
add [y_coin], 10

pop ax
ret
endp draw_coin

proc draw_Frame
mov [color], 9		;blue
mov [x_frame], 0
mov [y_frame], 0
left:
xor bh, bh
mov cx, [x_frame]
mov dx, [y_frame]
mov ax, [color]
mov ah, 0ch
int 10h
inc [y_frame]
cmp [y_frame], 199
jnz left
down:
xor bh, bh
mov cx, [x_frame]
mov dx, [y_frame]
mov ax, [color]
mov ah, 0ch
int 10h
inc [x_frame]
cmp [x_frame], 319
jnz down
right:
xor bh, bh
mov cx, [x_frame]
mov dx, [y_frame]
mov ax, [color]
mov ah, 0ch
int 10h
dec [y_frame]
cmp [y_frame], 0
jnz right
up_right:
xor bh, bh
mov cx, [x_frame]
mov dx, [y_frame]
mov ax, [color]
mov ah, 0ch
int 10h
dec [x_frame]
cmp [x_frame], 166
jnz up_right
mov [x_frame], 144
up_left:
xor bh, bh
mov cx, [x_frame]
mov dx, [y_frame]
mov ax, [color]
mov ah, 0ch
int 10h
dec [x_frame]
cmp [x_frame], 0
jnz up_left
ret
endp draw_Frame
END start

