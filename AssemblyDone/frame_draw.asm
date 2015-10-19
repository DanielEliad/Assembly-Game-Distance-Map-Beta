      ;.486                                      ; create 32 bit code
          .XMM
      .model flat, stdcall                      ; 32 bit memory model
      option casemap :none                      ; case sensitive
	 
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\gdi32.inc
include \masm32\include\Advapi32.inc
;include \masm32\include\masm32rt.inc
include \masm32\include\winmm.inc
include \masm32\include\comctl32.inc
;include \masm32\include\commctrl.inc

includelib \masm32\lib\winmm.lib
      include \masm32\include\dialogs.inc       ; macro file for dialogs
      include \masm32\macros\macros.asm         ; masm32 macro file
          includelib \masm32\lib\gdi32.lib
     includelib \masm32\lib\user32.lib
      includelib \masm32\lib\kernel32.lib
      includelib \masm32\lib\Comctl32.lib
      includelib \masm32\lib\comdlg32.lib
      includelib \masm32\lib\shell32.lib
      includelib \masm32\lib\oleaut32.lib
      includelib \masm32\lib\ole32.lib
      includelib \masm32\lib\msvcrt.lib
	  include \masm32\include\msvcrt.inc

	  include \masm32\include\Ws2_32.inc
includelib \masm32\lib\Ws2_32.lib
 
 include \masm32\include\ntoskrnl.inc
 includelib \masm32\lib\ntoskrnl.lib

 ;include \masm32\include\win32k.inc
 ;includelib \masm32\lib\win32k.lib

 COMMENT @
 To Do List:

 1. Animate player with sprite
 2. Put hitting sounds for player and zombie
 3. Put Options!!
 4. Put You Lose screen when player dies
 5. Put a selection of characters with different abillities
 6. Make new shop background and to be able to actually buy guns with different attributes
 7. ".	.	."




 IMPORTANT:
 Shorten Zombies
 Shorten Bullets
 Make Online Not Laggy
 Make SAVESTATUS To know what to go back to
 Make Store Good
 @
.const
WM_SOCKET equ WM_USER+100
JMP_HEIGHT equ 50
JMP_SPEED equ 8
VEL_X equ 6
VEL_Y equ 6
RECT_WIDTH_BACKUP       equ     60
RECT_HEIGHT_BACKUP    equ     40
WINDOW_WIDTH    equ     1000
WINDOW_HEIGHT   equ     650
RIGHT   equ     1
DOWN    equ     2
LEFT    equ     3
UP      equ     4
VELpos  equ     3
VELneg  equ -3
MAIN_TIMER_ID equ 0
ShootingTime equ 1
ZombieTime      equ     2
ZombieAdjust equ 3
RoundEnded	equ	4
secondtimer	equ	5
Zombie_Height equ 50
Zombie_Width equ 40
Bullet_Height equ 25
Bullet_Width equ 50
Coin_Height	equ	30
Coin_Width	equ	30
Health_Pack_Width	equ	50
Health_Pack_Height	equ	65
ChanceToDropHealthPack	equ	15
Space_Between_Player_Width	equ 64
Space_Between_Player_Height	equ	52
LengthofLeaf equ 12
Distance_Between_Zombie_And_Player equ 300

.data
myFirstLoad BYTE TRUE
expectingip	db 'I am now expecting IP',0

PlayerInformation	STRUCT
x	DWORD	  200	
y	DWORD     400
CURRENTFACING	DWORD	130
CURRENTSTEP	DWORD	0
TimeStepShouldDisappear	DWORD	?
Time_Between_Steps_P	DWORD	75;In MilliSeconds
CURRENTACTION	HBITMAP	?
CURRENTACTIONMASK	HBITMAP	?
speed	DWORD	6
PlayerInformation ENDS

Player	PlayerInformation<>
Player2	PlayerInformation<400,400,?,?,?,?,?,?,?>
 deadmsg BYTE "You Have Been Eaten By My Lovely Zombies",0dh,0ah,0dh,0dh,0dh,"You Tried	 .	 .	 .",0dh,0ah,0dh,"That's Something	.	.	.",0
 deadcaption BYTE "Game Over",0
 Found	DWORD	0
 FoundForSound	DWORD	0
 Number_To_Spawn DWORD	1
 zombiebr	HBITMAP	0
RECT_WIDTH       DWORD    40
RECT_HEIGHT       DWORD    60
RECT_WIDTH2       DD     30
RECT_HEIGHT2       DD     20
PlayerX DWORD   200
PlayerX2 DWORD   600
PlayerY DWORD   400
PlayerY2 DWORD   400
ClassName       DB      "TheClass",0
windowTitle     DB      "A Game!",0
msgB db "I GOT INTO HERE",0
caption db "HELP MEH!",0
jmpingDown db 0
jmpingDown2 db 0
jmpingUp db 0
jmpingUp2 db 0
StartY DWORD ?
StartY2 DWORD ?
dstY DWORD ?
dstY2 DWORD ?
path db "IDB_myimg",0
bullets DWORD 1000 dup(-999)
enemybullets	DWORD 1000 dup(-999)
zombies DWORD 2000 dup(-999)
coins DWORD	1000	dup(-999)
Packs	DWORD	1000	dup(-999)
Zombie_Spawning_Time DWORD 1000
BulletX DWORD   ?
BulletY DWORD   ?
ZombieX DWORD   ?
ZombieY DWORD   ?
ShootX  DWORD   ?
ShootY  DWORD   ?
VELFINALX       DWORD   ?
VELFINALY       DWORD   ?
buffer DWORD 20 dup(0)
buffer2 DWORD 3 dup(0)
 VEL REAL4 10.0
 VELZ REAL4 4.0
 BACKUPVELZ REAL4 4.0
 ADDINGZ REAL4 0.2
 threepointzero	REAL4	30.0
 WINPLACE WINDOWPLACEMENT       <>
 Player_Life	DWORD 500
 randombuffer   DWORD   ?
 ZombStartY DWORD       ?
 ZombStartX DWORD       ?
 savingnewzombieplace   DWORD   ?
 icursor	HCURSOR		?
 hCoinColour	HBITMAP ?
 hCoinMask	HBITMAP	?
 hHealthPackColour	HBITMAP	?
 hHealthPackMask	HBITMAP	?
 Money	DWORD	0
 NewGame	HBITMAP	?
 NewGameMasked	HBITMAP	?
 Options	HBITMAP	?
 OptionsMasked	HBITMAP	?
 Exiting	HBITMAP	?
 ExitingMasked	HBITMAP	?
 StartScreenBK HBITMAP	?
 StartScreenState	DWORD	1
 HighlightBIT	HBITMAP	?
 HighlightBITMasked HBITMAP	?
 Highlight	DWORD	0
 FramesSinceLastClick	DWORD	0
 SoundPath	BYTE	"shootsound.wav",0
 ;SoundPathBite	BYTE	"bite.wav",0
 volume	DWORD	003f003fh
 ;volumebite	DWORD 5fff5fffh
 Time_Between_Steps	DWORD	500;In Milliseconds
 Store	DWORD	0
 TimeTillRoundEnds	DWORD	120000
 cost	HBITMAP	?
 costMasked	HBITMAP	?
 StoreBK	HBITMAP	?
 score	HBITMAP	?
 scoreMasked	HBITMAP	?
 scoreNum	DWORD	0
 MyFont	HFONT	?
 scoreBuffer	BYTE	100 dup(0)
 timeBuffer BYTE	100	dup(0)
 doubledot BYTE	":",0
 realtimetillend	DWORD	10;120
 AnimClassName	BYTE	"ANIMATE_CLASS",0
 AnimWindowName	BYTE	"theAnimWinName",0
 angle DWORD 2 dup(?)
 realangle	DWORD	?
 anglePlayer	DWORD	2 dup(?)
 realanglePlayer	DWORD	?
 selectedimgz HBITMAP	?
 selectedimgzMask	HBITMAP	?
 selectedimg	DWORD	?
 Leftz HBITMAP	?
 LeftzMask	HBITMAP	?
  Rightz HBITMAP	?
 RightzMask	HBITMAP	?
  Frontz HBITMAP	?
 FrontzMask	HBITMAP	?
  Backz HBITMAP	?
 BackzMask	HBITMAP	?
 hWalk	HBITMAP	?
 hWalkMask	HBITMAP	?
 OptionScreenhbitmap HBITMAP ?
 sprintmeter	DWORD	500
 OptionsBOOL	BYTE	0
 STATUS	BYTE	0
 offsetToEndofArray	dword	?
 leaf STRUCT
 location POINT <0,0>
 priority dd	?
 leaf ENDS

queueArr DWORD (((((WINDOW_WIDTH/4)*(WINDOW_HEIGHT/4))*2)*3)+3) dup(0)


sin sockaddr_in <>
clientsin sockaddr_in <>
IPAddress db "212.179.222.94",0 
Port dd 30001                    
text db "placeholder",0
textoffset DWORD ?
pleaseconnectus db "please connect us!!!",0
doyouwanttoconnect db "Yes do you want to connect with your friend?",0
yesiamsure db "yes i am sure",0
get_ready_for_ip db "Get ready for IP.",0
expecting_IP db FALSE
expecting_PORT db FALSE
wsadata WSADATA <>
clientip db 20 dup(0)
clientport dd 0





infobuffer db 1024 dup(0)
hMemory db 100 dup(0)                ; handle to memory block 
buffer_for_sock db 1024 dup(0)                       ; address of the memory block 
available_data db 1024 dup(0)        ; the amount of data available from the socket 
actual_data_read db 1024 dup(0)    ; the actual amount of data read from the socket 
connected_to_friend db FALSE
sock DWORD ?
captionyesiwanttoconnect	db 'yes i am sure',0
host	db	FALSE
you_are_host db 'You are the host!!!',0
you_are_not_host db 'You are not the host!!!',0
iamhost db 'I am the host',0
iamnothost db 'I am NOT the host',0
recievingzombies db 'I am RECIEVING zombies',0
sendingzombies db 'I am SENDING zombies',0
recievingbullets db 'I am RECIEVING bullets',0
recievingxy db 'I am RECIEVING xy',0
connectedtopeer db 'I am now CONNECTED TO PEER',0
irecievedsomething db 'I recieved SOMETHING',0
createbulleting db 'I am creating a bullet',0
sendingxy	db 'I am SENDING xy'
buffer_for_strings db 100 dup(0)
buffer_for_FPU db 1000 dup(0)
player2_health_to_add DWORD 0
Online HBITMAP	?
OnlineMask HBITMAP	?
two_Players BYTE FALSE
not_two_players db 'Other player disconnected',0
Waiting_cut_x DWORD 0
Waiting_zomb_x DWORD 50
Waiting_zomb_y DWORD 200
Time_Between_Steps_waiting DWORD 75 ;In milliseconds
Time_Step_Should_End DWORD ?
WaitingScreenBMP HBITMAP ?
WaitingScreenBMPMask HBITMAP ?
Waiting_player_x DWORD -Distance_Between_Zombie_And_Player
Waiting_player_cut_x DWORD 0
Waiting_player_y DWORD 200
Time_Step_Should_End_Player DWORD ?
Time_Between_Steps_waiting_player DWORD 75
xForm XFORM <>
sin_angle_world REAL4 0.866
cos_angle_world	REAL4 0.5
minus_sin_angle_world REAL4 -0.5
ZeroPointZero REAL4 0.0
OnePointZero REAL4 1.0
normal_xForm XFORM <>
Minus1 REAL4 -1.0
ArrowBMP HBITMAP ?
ArrowBMPMask HBITMAP ?
playshootsound db 'play Arrowshootsound.mp3 from 1',0
MechanicsS HBITMAP ?
MechanicsSMask HBITMAP ?
MechanicsP HBITMAP ?
Vectors HBITMAP ?
VectorsMask HBITMAP ?
Rotation HBITMAP	?
RotationMask HBITMAP ?
OnlineF HBITMAP	?
OnlineFMask HBITMAP ?
STATUS_INMECH BYTE 0
VectorsP HBITMAP ?
RotationP HBITMAP ?
OnlineP HBITMAP ?
rotatePT POINT<WINDOW_WIDTH-250,WINDOW_HEIGHT-150>
rotate_xForm XFORM<>
Adding_Angle REAL4 0.05
Current_Angle REAL4 ?

Volume HBITMAP ?
VolumeMask HBITMAP ?
VolumeBar HBITMAP ?
VolumeBarMask HBITMAP ?
Circle HBITMAP ?
CircleMask HBITMAP ?
CircleX dword 50+100
playbk db "play backgroundmusic.mp3 repeat",0
Paused HBITMAP ?
Resume HBITMAP ?
ResumeMask HBITMAP ?
OptionsPaused HBITMAP ?
OptionsPausedMask HBITMAP ?
MainMenu HBITMAP ?
MainMenuMask HBITMAP ?
SAVESTATUS BYTE ?
YouLost HBITMAP ?
NewGameDead HBITMAP ?
NewGameDeadMask HBITMAP ?
h25hp HBITMAP ?
h25hpMask HBITMAP ?
h75hp HBITMAP ?
h75hpMask HBITMAP ?
h150hp HBITMAP ?
h150hpMask HBITMAP ?
MoneyBuffer BYTE 100 dup (0)
h30d HBITMAP ?
h30dMask HBITMAP ?
h80d HBITMAP ?
h80dMask HBITMAP ?
h150d HBITMAP ?
h150dMask HBITMAP ?
deadzcount DWORD 0
amountofzombiesneeded DWORD 15
limit_for_spawning_time DWORD 300 ;in milliseconds
limit_amount_of_zombies_to_spawn DWORD 1
NextWave HBITMAP ?
NextWaveMask HBITMAP ?
TOP_VELZ REAL4 7.0
MoneyToAdd DWORD 0
wave BYTE 0


DistanceMap byte ((WINDOW_WIDTH/4)*(WINDOW_HEIGHT/4))*8 dup(-10)

tempDistanceMap byte ((WINDOW_WIDTH/4)*(WINDOW_HEIGHT/4))*8 dup(-1)

obs dword 1000 dup(WINDOW_WIDTH*WINDOW_HEIGHT)


.code



Restart PROC,hWnd:HWND

mov ebx,offset zombies
mov ecx,50
loopingzombies:
mov dword ptr [ebx],-999
add ebx,36
loop loopingzombies

mov ebx,offset bullets
mov ecx,48
loopingbullets:
mov dword ptr [ebx],-999
add ebx,40
loop loopingbullets


mov ebx,offset enemybullets
mov ecx,48
loopingbullets2:
mov dword ptr [ebx],-999
add ebx,40
loop loopingbullets2

mov ebx,offset coins
mov ecx,50
loopingcoins:
mov dword ptr [ebx],-999
add ebx,12
loop loopingcoins

mov ebx,offset Packs
mov ecx,10
loopingpacks:
mov dword ptr [ebx],-999
add ebx,16
loop loopingpacks

mov Player.x,200
mov Player.y,400
mov Player_Life,500
mov TimeTillRoundEnds,60000
invoke SetTimer, hWnd, RoundEnded, TimeTillRoundEnds, NULL ;Set the time til the store
mov eax,TimeTillRoundEnds
mov ecx,1000
xor edx,edx
idiv ecx
mov realtimetillend,eax
mov scoreNum,0
mov Money,0
movss xmm0,BACKUPVELZ
movss VELZ,xmm0
mov Time_Between_Steps,500
mov limit_for_spawning_time,500
mov amountofzombiesneeded,25
mov limit_amount_of_zombies_to_spawn,1
mov Zombie_Spawning_Time,1000
mov Number_To_Spawn,1
mov deadzcount,0
mov sprintmeter,500
mov offsetToEndofArray,LengthofLeaf
ret
Restart ENDP





NextWaveP PROC,hWnd:HWND

inc wave
mov ebx,offset zombies
mov ecx,50
loopingzombies:
mov dword ptr [ebx],-999
add ebx,36
loop loopingzombies

mov ebx,offset bullets
mov ecx,48
loopingbullets:
mov dword ptr [ebx],-999
add ebx,40
loop loopingbullets


mov ebx,offset enemybullets
mov ecx,48
loopingbullets2:
mov dword ptr [ebx],-999
add ebx,40
loop loopingbullets2

mov ebx,offset coins
mov ecx,50
loopingcoins:
mov dword ptr [ebx],-999
add ebx,12
loop loopingcoins

mov ebx,offset Packs
mov ecx,10
loopingpacks:
mov dword ptr [ebx],-999
add ebx,16
loop loopingpacks

mov Player.x,200
mov Player.y,400
add TimeTillRoundEnds,30000
invoke SetTimer, hWnd, RoundEnded, TimeTillRoundEnds, NULL ;Set the time til the store

mov eax,TimeTillRoundEnds
mov ecx,1000
xor edx,edx
idiv ecx
mov realtimetillend,eax
movss xmm0,BACKUPVELZ
movss VELZ,xmm0
mov Time_Between_Steps,500
sub limit_for_spawning_time,75
sub amountofzombiesneeded,2
cmp amountofzombiesneeded,0
jg noreset
mov amountofzombiesneeded,1
noreset:
cmp wave,3
jng noinc
inc limit_amount_of_zombies_to_spawn
noinc:
mov Zombie_Spawning_Time,1000
mov Number_To_Spawn,1
mov deadzcount,0
mov sprintmeter,500
movss xmm0,TOP_VELZ
addss xmm0,ADDINGZ
movss TOP_VELZ,xmm0
mov offsetToEndofArray,LengthofLeaf
ret
NextWaveP ENDP

getValue PROC, x:DWORD, y:DWORD,lp_map:DWORD
;----------------------------------------------------------------------------
 cmp x, 0
 jl obstacle
 cmp y, 0
 jl obstacle
 cmp x, (WINDOW_WIDTH/4)
 jg obstacle
 cmp y, (WINDOW_HEIGHT/4)
 jg obstacle
 xor edx, edx
 
 mov eax, y
 mov ecx, WINDOW_WIDTH/4
 xor edx,edx
 imul ecx
 add eax,x
 shl eax,2
 mov ebx, lp_map
 add ebx, eax
 xor eax, eax
 mov eax, dword ptr[ebx]
 noendgame:
 jmp endofgetValue
obstacle:
 mov eax, 2147483647
 endofgetValue:
 ret
;============================================================================
getValue ENDP


setValue PROC, x:DWORD, y:DWORD,d:DWORD,lp_map:DWORD
;----------------------------------------------------------------------------

mov eax,y
mov ecx,WINDOW_WIDTH/4
xor edx,edx
imul ecx
add eax,x
shl eax,2
mov ebx,lp_map
add ebx,eax
mov eax,d
mov dword ptr [ebx],eax

mov eax,TRUE
;============================================================================
ret
setValue ENDP





 sendlocation PROC, paramter:DWORD
	local send_what:BYTE
	mov send_what,0
	again:
	cmp two_Players,FALSE
	je notagain
	mov ebx, offset infobuffer
	cmp send_what,0
	jne nosendplayer

	

	mov byte ptr [ebx],0
	inc ebx

	
	mov eax, Player.x
	mov [ebx], eax
	add ebx, 4

	mov eax, Player.y
	mov [ebx], eax
	add ebx, 4

	mov eax,Player.CURRENTFACING
	mov [ebx], eax
	add ebx, 4
	
	mov eax,Player.CURRENTSTEP
	mov [ebx], eax
	add ebx, 4
	
	mov eax,Player.CURRENTACTION
	mov [ebx], eax
	add ebx, 4

	mov eax,Player.CURRENTACTIONMASK
	mov [ebx], eax
	add ebx,4

	push ebx
	invoke RtlMoveMemory,ebx,offset bullets,24*40
	pop ebx
	add ebx,24*40

	cmp host,FALSE
	je nosend_health_and_score

	mov eax,scoreNum
	mov [ebx],eax
	add ebx,4

	mov eax,MoneyToAdd
	mov [ebx],eax
	add ebx,4

	mov eax,player2_health_to_add
	mov dword ptr [ebx],eax
	mov player2_health_to_add,0
	nosend_health_and_score:
		
	invoke sendto,sock, offset infobuffer, 1024, 0, offset clientsin, sizeof clientsin
	jmp endofsendlocation
	nosendplayer:

	cmp send_what,1
	jne nosendbullets

	
	mov byte ptr [ebx],1
	inc ebx
	push ebx
	mov esi,offset bullets
	add esi,24*40
	invoke RtlMoveMemory ,ebx,esi,24*40
	invoke sendto,sock, offset infobuffer, 1024, 0, offset clientsin, sizeof clientsin
	pop ebx
	jmp endofsendlocation

	nosendbullets:

	cmp host,FALSE
	je nosendzombies
	cmp send_what,2
	jne nosendzombies

	mov byte ptr [ebx],2
	inc ebx
	invoke RtlMoveMemory ,ebx,offset zombies,25*36
	invoke sendto,sock, offset infobuffer, 1024, 0, offset clientsin, sizeof clientsin
	;invoke MessageBox,0,offset sendingzombies,offset sendingzombies,MB_OK
	
	jmp endofsendlocation
	nosendzombies:

	cmp host,FALSE
	je nosendzombies2
	cmp send_what,3
	jne nosendzombies2
	mov byte ptr [ebx],3
	inc ebx
	mov esi,offset zombies
	add esi,25*36
	invoke RtlMoveMemory,ebx,esi,25*36
	invoke sendto,sock, offset infobuffer, 1024, 0, offset clientsin, sizeof clientsin
	


	jmp endofsendlocation
	nosendzombies2:
	

	cmp host,FALSE
	je nosendpacks
	cmp send_what,4
	jne nosendpacks

	mov byte ptr [ebx],4
	inc ebx

	invoke RtlMoveMemory,ebx,offset coins,50*12
	add ebx,50*12
	invoke RtlMoveMemory,ebx,offset Packs,10*16
	invoke sendto,sock, offset infobuffer, 1024, 0, offset clientsin, sizeof clientsin
	jmp endofsendlocation
	nosendpacks:

	endofsendlocation:
	cmp host,FALSE
	je different_inc
	;---------increment-----------------
	inc send_what
	cmp send_what,4
	jng no_need_to_reset1
	mov send_what,0
	no_need_to_reset1:
	;---------increment-----------------
	jmp real_endofsendlocation
	different_inc:
	;---------increment-----------------
	inc send_what
	cmp send_what,1
	jng no_need_to_reset2
	mov send_what,0
	no_need_to_reset2:
	;---------increment-----------------

	real_endofsendlocation:
	invoke Sleep,3
	jmp again
	notagain:
	ret
sendlocation ENDP

getParent PROC,index:DWORD
;--------------------------------------------------------------------------------
mov eax,index
mov ebx,LengthofLeaf
xor edx,edx
idiv ebx
mov ebx,2
xor edx,edx
idiv ebx
mov ebx,LengthofLeaf
imul ebx
;================================================================================
ret
getParent ENDP

getLeftChild	PROC,index:DWORD
;--------------------------------------------------------------------------------
mov eax,index
mov ebx,2
imul ebx
;================================================================================
ret
getLeftChild ENDP

getRightChild	PROC,index:DWORD
;--------------------------------------------------------------------------------
mov eax,index
mov ebx,2
imul ebx
add eax,LengthofLeaf
;================================================================================
ret
getRightChild	ENDP

switch_leafs PROC,to:DWORD,from:DWORD
;--------------------------------------------------------------------------------
local temp:DWORD
local tempto:DWORD
local tempfrom:DWORD
mov ebx,offset queueArr
add ebx,to

mov esi,offset queueArr
add esi,from


mov eax,[ebx]
mov temp,eax
mov eax,[esi]
mov [ebx],eax
mov eax,temp
mov [esi],eax

mov eax,[ebx+4]
mov temp,eax
mov eax,[esi+4]
mov [ebx+4],eax
mov eax,temp
mov [esi+4],eax

mov eax,[ebx+8]
mov temp,eax
mov eax,[esi+8]
mov [ebx+8],eax
mov eax,temp
mov [esi+8],eax

;================================================================================
ret
switch_leafs ENDP

insertPriority PROC,x:DWORD,y:DWORD,priority:DWORD
;--------------------------------------------------------------------------------
mov ebx,offsetToEndofArray
mov eax,x
mov [queueArr+ebx],eax
mov eax,y
mov [queueArr+ebx+4],eax
mov eax,priority
mov [queueArr+ebx+8],eax

checkagainifparentsmaller: 
cmp ebx,LengthofLeaf
jle  noswitch
push ebx
invoke getParent,ebx
pop ebx
mov ecx,[queueArr+eax+8]
mov esi,priority
cmp ecx,esi;if parent_priority<=priority_inserted ==> noswitch:
jle noswitch

push eax
invoke switch_leafs,eax,ebx
pop eax
mov ebx,eax
jmp checkagainifparentsmaller
noswitch:
add offsetToEndofArray,LengthofLeaf
;================================================================================
ret
insertPriority	ENDP
removeMax	PROC,lppt:DWORD
;--------------------------------------------------------------------------------

cmp offsetToEndofArray,LengthofLeaf
je endofremoveMax
mov esi,LengthofLeaf
mov eax,[queueArr+esi]
mov ebx,lppt
mov dword ptr [ebx],eax
mov eax,[queueArr+esi+4]
mov dword ptr [ebx+4],eax

pusha
mov esi,offsetToEndofArray
sub esi, LengthofLeaf
invoke switch_leafs,LengthofLeaf,esi
popa
mov esi,offsetToEndofArray
sub esi,LengthofLeaf
mov queueArr[esi],0
mov queueArr[esi+4],0
mov queueArr[esi+8],0
sub offsetToEndofArray,LengthofLeaf

mov esi,LengthofLeaf

checkagain:
invoke getLeftChild,esi
cmp eax,offsetToEndofArray
jge endofremoveMax
mov edi,eax
mov ebx,offset queueArr
add ebx,edi
mov ebx,[ebx+8]
push ebx
push edi
invoke getRightChild,esi
cmp eax,offsetToEndofArray
jge leftissmaller;jge endofremoveMax
pop edi
pop ebx
mov ecx,[queueArr+eax+8]
cmp ebx,ecx
jl leftissmaller

rightissmaller:
pusha
mov esi,dword ptr [queueArr+esi+8]
cmp esi,[queueArr+eax+8]
jle endofremoveMax_withpopa;maybe jl
popa
push eax
invoke switch_leafs,esi,eax
pop eax
mov esi,eax
cmp esi,offsetToEndofArray
jge endofremoveMax
jmp checkagain

leftissmaller:
pusha
mov esi,dword ptr [queueArr+esi+8]
cmp esi,[queueArr+edi+8]
jle endofremoveMax_withpopa;maybe jl
popa
pusha
invoke switch_leafs,esi,edi
popa
mov esi,edi
cmp esi,offsetToEndofArray
jl checkagain
endofremoveMax_withpopa:
popa
endofremoveMax:
;================================================================================
ret
removeMax ENDP

set_obs PROC

local x:DWORD
local y:DWORD

mov x,((WINDOW_WIDTH/3)/4)


mov ecx,10
incingx:
mov y,((WINDOW_HEIGHT/3)/4)
push ecx
mov ecx,70
incingy:
push ecx
invoke setValue,x,y,2147483647,offset tempDistanceMap
inc y
pop ecx
loop incingy
inc x
pop ecx
loop incingx


mov y,((WINDOW_HEIGHT/3)/4)


mov ecx,10
incingy2:
mov x,((WINDOW_WIDTH/3)/4)
push ecx
mov ecx,70
incingx2:
push ecx
invoke setValue,x,y,2147483647,offset tempDistanceMap
inc x
pop ecx
loop incingx2
inc y
pop ecx
loop incingy2

ret
set_obs ENDP


real_mark PROC
;----------------------------------------------------------------------------
local pt:POINT
local d:DWORD
local newd:DWORD

invoke removeMax,addr pt
invoke getValue,pt.x,pt.y,offset tempDistanceMap
 mov d,eax
 inc eax
 mov newd,eax




checkup:
 mov eax,pt.y
 dec eax
 invoke getValue,pt.x,eax,offset tempDistanceMap
 cmp eax,2147483647
 je checkright
setup:
 cmp eax,-1
 jne comparingup
 

 mov eax,pt.y
 dec eax

 push eax

 invoke setValue,pt.x,eax,newd,offset tempDistanceMap;d+1

 pop eax
 invoke insertPriority,pt.x,eax,newd
 jmp checkright

comparingup:
 
 cmp eax,newd
 jle checkright
 mov eax,pt.y
 dec eax

 push eax

 invoke setValue,pt.x,eax,newd,offset tempDistanceMap;d+1

 pop eax
 invoke insertPriority,pt.x,eax,newd





checkright:
 mov eax,pt.x
 inc eax
 invoke getValue,eax,pt.y,offset tempDistanceMap
 cmp eax,2147483647
 je checkdown
setright:
 cmp eax,-1
 jne comparingright

  mov eax,pt.x
 inc eax

 push eax

 invoke setValue,eax,pt.y,newd,offset tempDistanceMap;d+1
 
 pop eax
 invoke insertPriority,eax,pt.y,newd
 jmp checkdown

comparingright:
 cmp eax,newd
 jle checkdown
 mov eax,pt.x
 inc eax
 push eax
 
 invoke setValue,eax,pt.y,newd,offset tempDistanceMap;d+1

 pop eax
 invoke insertPriority,eax,pt.y,newd




checkdown:
 mov eax,pt.y
 inc eax
 invoke getValue,pt.x,eax,offset tempDistanceMap
 cmp eax,2147483647
 je checkleft
setdown:
 cmp eax,-1
 jne comparingdown

 mov eax,pt.y
 inc eax
 push eax
 
 invoke setValue,pt.x,eax,newd,offset tempDistanceMap;d+1
 
 pop eax
 invoke insertPriority,pt.x,eax,newd
 jmp checkleft
comparingdown:

 cmp eax,newd
 jle checkleft
 mov eax,pt.y
 inc eax
 push eax
 
 invoke setValue,pt.x,eax,newd,offset tempDistanceMap;d+1
 
 pop eax
 invoke insertPriority,pt.x,eax,newd




checkleft:
 mov eax,pt.x
 dec eax
 invoke getValue,eax,pt.y,offset tempDistanceMap
 cmp eax,2147483647
 je returntolast
setleft:
 cmp eax,-1
 jne comparingleft
 mov eax,pt.x
 dec eax
 push eax
 
 invoke setValue,eax,pt.y,newd,offset tempDistanceMap;d+1
 
 pop eax
 invoke insertPriority,eax,pt.y,newd
 jmp returntolast
comparingleft:

 cmp eax,newd
 jle returntolast
 mov eax,pt.x
 dec eax
 push eax
 
 invoke setValue,eax,pt.y,newd,offset tempDistanceMap;d+1
 
 pop eax
 invoke insertPriority,eax,pt.y,newd
returntolast:

;============================================================================
ret
real_mark ENDP



my_mark PROC,x:DWORD,y:DWORD,d:DWORD
;----------------------------------------------------------------------------
	local gridx:DWORD
	local gridy:DWORD
	mov offsetToEndofArray,LengthofLeaf
	mov eax,x
	shr eax,2
	mov gridx,eax
	mov eax,y
	shr eax,2
	mov gridy,eax

	invoke insertPriority,gridx,gridy,d
	invoke setValue,gridx,gridy,d,offset tempDistanceMap
	again:
	cmp offsetToEndofArray,LengthofLeaf;maybe remove
	jle end_loop
	invoke real_mark
	jmp again
	end_loop:

;============================================================================
ret
my_mark ENDP



make_distance_map PROC
;----------------------------------------------------------------------------
again:
cmp STATUS,1
jne again
mov ebx,offset tempDistanceMap
mov ecx,(((WINDOW_WIDTH/4)*(WINDOW_HEIGHT/4))*4)
loopingzeroing:

mov dword ptr [ebx],-1
add ebx,4

loop loopingzeroing
invoke set_obs
invoke my_mark,Player.x,Player.y,0

invoke RtlMoveMemory,offset DistanceMap,offset tempDistanceMap,(((WINDOW_WIDTH/4)*(WINDOW_HEIGHT/4))*8)
COMMENT @;Work in progress, need to make this work in online mode aswell
cmp two_Players,FALSE
je no_make_other_d_map
invoke RtlMoveMemory,offset tempDistanceMap2,offset Blank,WINDOW_WIDTH*WINDOW_HEIGHT*4
invoke my_mark2,Player2.x,Player2.y,0
invoke RtlMoveMemory,offset DistanceMap2,offset tempDistanceMap2,WINDOW_WIDTH*WINDOW_HEIGHT*4
no_make_other_d_map:
@
jmp again

;============================================================================
ret
make_distance_map ENDP

BUILDRECT       PROC,   x:DWORD,        y:DWORD, h:DWORD,       w:DWORD,        hdc:HDC,        brush:HBRUSH
;--------------------------------------------------------------------------------
LOCAL rectangle:RECT
mov eax, x
mov rectangle.left, eax
add eax, w
mov     rectangle.right, eax
 
mov eax, y
mov     rectangle.top, eax
add     eax, h
mov rectangle.bottom, eax
 
invoke FillRect, hdc, addr rectangle, brush
;================================================================================
ret
BUILDRECT ENDP
 
Get_Handle_To_Mask_Bitmap	PROC,	hbmColour:HBITMAP,	crTransparent:COLORREF
;--------------------------------------------------------------------------------
local hdcMem:HDC
local hdcMem2:HDC
local hbmMask:HBITMAP
local bm:BITMAP
local hold:HBITMAP
local hold2:HBITMAP

invoke GetObject,hbmColour,SIZEOF(BITMAP),addr bm
invoke CreateBitmap,bm.bmWidth,bm.bmHeight,1,1,NULL
mov hbmMask,eax


invoke CreateCompatibleDC,NULL
mov hdcMem,eax
invoke CreateCompatibleDC,NULL
mov hdcMem2,eax

invoke SelectObject,hdcMem,hbmColour
invoke SelectObject,hdcMem2,hbmMask


invoke SetBkColor,hdcMem, crTransparent
invoke BitBlt,hdcMem2, 0, 0, bm.bmWidth, bm.bmHeight, hdcMem, 0, 0, SRCCOPY
invoke BitBlt,hdcMem, 0, 0, bm.bmWidth, bm.bmHeight, hdcMem2, 0, 0, SRCINVERT

invoke DeleteDC,hdcMem
invoke DeleteDC,hdcMem2

mov eax,hbmMask

;================================================================================
ret
Get_Handle_To_Mask_Bitmap ENDP

GetRandomNumber PROC,   blen:BYTE,PointToBuffer:PLONG
;--------------------------------------------------------------------------------
local hprovide:HANDLE
invoke CryptAcquireContext, addr hprovide,0,0,PROV_RSA_FULL,CRYPT_VERIFYCONTEXT or CRYPT_SILENT
invoke CryptGenRandom, hprovide, blen, PointToBuffer
invoke CryptReleaseContext,hprovide,0
;================================================================================
ret
GetRandomNumber ENDP

CloseProcess	PROC
;--------------------------------------------------------------------------------
		cmp two_Players,FALSE
		je dont_send_two_players_over
		invoke sendto,sock, offset not_two_players, 1024, 0, offset clientsin, sizeof clientsin
		dont_send_two_players_over:
		invoke closesocket, sock
		invoke WSACleanup 
        invoke ExitProcess, 0
;================================================================================
ret
CloseProcess ENDP

DrawImage_fast PROC, hdc:HDC, img:HBITMAP, x:DWORD, y:DWORD,x2:DWORD,y2:DWORD,w:DWORD,h:DWORD

local hdcMem:HDC
local HOld:HBITMAP
  invoke CreateCompatibleDC, hdc
  mov hdcMem, eax
  invoke SelectObject, hdcMem, img
  mov HOld, eax
  ;invoke SetStretchBltMode,hdc,COLORONCOLOR
  invoke BitBlt,hdc,x,y,w,h,hdcMem,x2,y2,SRCCOPY
  invoke SelectObject,hdcMem,HOld
  invoke DeleteDC,hdcMem 
  invoke DeleteObject,HOld


ret
DrawImage_fast ENDP


DrawImage_fast_WithMask PROC, hdc:HDC, img:HBITMAP,maskedimg:HBITMAP, x:DWORD, y:DWORD,x2:DWORD,y2:DWORD,w:DWORD,h:DWORD
local hdcMem:HDC
local HOld:HDC
  invoke CreateCompatibleDC, hdc
  mov hdcMem, eax
  ;invoke SetGraphicsMode,hdcMem,GM_ADVANCED
  ; mov edi,lp_xForm
  ;invoke SetWorldTransform,hdcMem,edi
  invoke SelectObject, hdcMem, maskedimg
  mov HOld,eax
   
  
  invoke BitBlt,hdc,x,y,w,h,hdcMem,x2,y2,SRCAND
		
  invoke SelectObject, hdcMem, img
  invoke BitBlt ,hdc,x,y,w,h,hdcMem,x2,y2,SRCPAINT

  invoke SelectObject,hdcMem,HOld
  invoke DeleteObject,HOld

        invoke DeleteDC,hdcMem 

ret
DrawImage_fast_WithMask ENDP
DrawImage PROC, hdc:HDC, img:HBITMAP, x:DWORD, y:DWORD,x2:DWORD,y2:DWORD,w:DWORD,h:DWORD,wstrech:DWORD,hstrech:DWORD
;--------------------------------------------------------------------------------
local hdcMem:HDC
local HOld:HBITMAP
  invoke CreateCompatibleDC, hdc
  mov hdcMem, eax
  invoke SelectObject, hdcMem, img
  mov HOld, eax
  invoke SetStretchBltMode,hdc,COLORONCOLOR
  invoke StretchBlt ,hdc,x,y,wstrech,hstrech,hdcMem,x2,y2,w,h,SRCCOPY
  invoke SelectObject,hdcMem,HOld
  invoke DeleteDC,hdcMem 
  invoke DeleteObject,HOld
;================================================================================
ret
DrawImage ENDP

DrawImage_WithMask PROC, hdc:HDC, img:HBITMAP, maskedimg:HBITMAP,  x:DWORD, y:DWORD,w:DWORD,h:DWORD,x2:DWORD,y2:DWORD,wstrech:DWORD,hstrech:DWORD
;--------------------------------------------------------------------------------
local hdcMem:HDC
local HOld:HDC
  invoke CreateCompatibleDC, hdc
  mov hdcMem, eax
  ;invoke SetGraphicsMode,hdcMem,GM_ADVANCED
  ; mov edi,lp_xForm
  ;invoke SetWorldTransform,hdcMem,edi
  invoke SelectObject, hdcMem, maskedimg
  mov HOld,eax
  invoke SetStretchBltMode,hdc,COLORONCOLOR
 
  
  invoke StretchBlt ,hdc,x,y,wstrech,hstrech,hdcMem,x2,y2,w,h,SRCAND
		
  invoke SelectObject, hdcMem, img
  invoke StretchBlt ,hdc,x,y,wstrech,hstrech,hdcMem,x2,y2,w,h,SRCPAINT

  invoke SelectObject,hdcMem,HOld
  invoke DeleteObject,HOld

        invoke DeleteDC,hdcMem 
;================================================================================
ret
DrawImage_WithMask ENDP


WaitingScreen PROC,hdc:HDC
;--------------------------------------------------------------------------------
invoke DrawImage,hdc,WaitingScreenBMP,0,0,0,0,1024,1024,WINDOW_WIDTH,WINDOW_HEIGHT

invoke DrawImage_WithMask,hdc,Rightz,RightzMask,Waiting_zomb_x,Waiting_zomb_y,30,40,Waiting_cut_x,0,Zombie_Width*5,Zombie_Height*5
invoke DrawImage_WithMask,hdc,hWalk,hWalkMask,Waiting_player_x,Waiting_player_y,75,105,Waiting_player_cut_x,385,Zombie_Width*5,Zombie_Height*5
inc FramesSinceLastClick
cmp FramesSinceLastClick,6
jl finish
invoke GetAsyncKeyState,VK_ESCAPE
shr eax,15
cmp eax,0
je finish
mov STATUS,0
mov FramesSinceLastClick,0
invoke closesocket, sock
invoke WSACleanup 
invoke GetAsyncKeyState,VK_RETURN
finish:
;---------------------------ZOMBIE---------------------------------
invoke GetTickCount
cmp Time_Step_Should_End,eax
jg no_need_to_advance_zomb
cmp Waiting_cut_x,70
jl noend_zomb
mov Waiting_cut_x,0
invoke GetTickCount
add eax,Time_Between_Steps_waiting
mov Time_Step_Should_End,eax
add Waiting_zomb_x,20
jmp no_need_to_advance_zomb
noend_zomb:
add Waiting_cut_x,35
invoke GetTickCount
add eax,Time_Between_Steps_waiting
mov Time_Step_Should_End,eax
add Waiting_zomb_x,20
no_need_to_advance_zomb:


cmp Waiting_zomb_x,WINDOW_WIDTH+Distance_Between_Zombie_And_Player; Player_x on purpose
jl dont_reset_zomb
mov Waiting_zomb_x,-Zombie_Width*5; Player_x on purpose
dont_reset_zomb:
;---------------------------PLAYER---------------------------------
invoke GetTickCount
cmp Time_Step_Should_End_Player,eax
jg no_need_to_advance
cmp Waiting_player_cut_x,1000
jl noend
mov Waiting_player_cut_x,0
invoke GetTickCount
add eax,Time_Between_Steps_waiting_player
mov Time_Step_Should_End_Player,eax
add Waiting_player_x,20
jmp no_need_to_advance
noend:
add Waiting_player_cut_x,127
invoke GetTickCount
add eax,Time_Between_Steps_waiting_player
mov Time_Step_Should_End_Player,eax
add Waiting_player_x,20
no_need_to_advance:


cmp Waiting_player_x,WINDOW_WIDTH
jl dont_reset
mov Waiting_player_x,-Zombie_Width*5-Distance_Between_Zombie_And_Player
dont_reset:

;================================================================================
ret
WaitingScreen ENDP



DrawOptionScreenButtons PROC,hdc:HDC,Highlighted:DWORD
;--------------------------------------------------------------------------------
	invoke DrawImage_WithMask,hdc,Volume,VolumeMask,200,200,933,244,0,0,WINDOW_WIDTH/4,WINDOW_HEIGHT/7
	invoke DrawImage_WithMask,hdc,VolumeBar,VolumeBarMask,50,275,910,52,0,0,(WINDOW_WIDTH*4)/5,WINDOW_HEIGHT/8
	invoke DrawImage_WithMask,hdc,Circle,CircleMask,CircleX,275,630,642,0,0,WINDOW_WIDTH/8,WINDOW_HEIGHT/8
;================================================================================
ret
DrawOptionScreenButtons ENDP

OptionsScreen PROC,hdc:HDC
;--------------------------------------------------------------------------------
invoke DrawImage,hdc,OptionScreenhbitmap,0,0,0,0,960,720,WINDOW_WIDTH,WINDOW_HEIGHT

invoke DrawOptionScreenButtons,hdc,Highlight

inc FramesSinceLastClick
cmp FramesSinceLastClick,6
jl finish
invoke GetAsyncKeyState,VK_ESCAPE
shr eax,15
cmp eax,0
je next
mov FramesSinceLastClick,0
mov al,SAVESTATUS
mov STATUS,al
mov Highlight,0
invoke GetAsyncKeyState,VK_RETURN
next:
invoke GetAsyncKeyState,VK_RIGHT
cmp eax,0
je next2
add CircleX,10
next2:
invoke GetAsyncKeyState,VK_LEFT
cmp eax,0
je finish
sub CircleX,10
finish:
cmp CircleX,50
jg no_reset
mov CircleX,50
no_reset:
cmp CircleX,((WINDOW_WIDTH*4)/5)-50
jl no_reset2
mov CircleX,((WINDOW_WIDTH*4)/5)-50
no_reset2:
xor eax,eax
mov ax,0ffffh
xor ebx,ebx
mov bx,((WINDOW_WIDTH*4)/5)-50+50
xor edx,edx
idiv bx
mov ebx,CircleX
sub ebx,50
xor edx,edx
imul bx
mov edi,offset volume
mov word ptr [edi],ax
mov word ptr [edi+2],ax
invoke waveOutSetVolume,NULL,volume
;================================================================================
ret
OptionsScreen ENDP

DrawStartScreenButtons PROC,hdc:HDC,Highlighted:DWORD
;--------------------------------------------------------------------------------
mov esi,WINDOW_HEIGHT/5
mov eax,Highlighted
imul eax,WINDOW_HEIGHT/6-30
add esi,eax
invoke DrawImage_WithMask,hdc,HighlightBIT,HighlightBITMasked,550,esi,240,60,0,0,WINDOW_WIDTH/6,WINDOW_HEIGHT/10
mov edx,WINDOW_HEIGHT/5

push edx
invoke DrawImage_WithMask,hdc,NewGame,NewGameMasked,550,edx,240,60,0,0,WINDOW_WIDTH/6,WINDOW_HEIGHT/10
pop edx
add edx,WINDOW_HEIGHT/6-30

push edx
invoke DrawImage_WithMask,hdc,Online,OnlineMask,550,edx,240,60,0,0,WINDOW_WIDTH/6,WINDOW_HEIGHT/10
pop edx
add edx,WINDOW_HEIGHT/6-30

push edx
invoke DrawImage_WithMask,hdc,Options,OptionsMasked,550,edx,240,60,0,0,WINDOW_WIDTH/6,WINDOW_HEIGHT/10
pop edx
add edx,WINDOW_HEIGHT/6-30

push edx
invoke DrawImage_WithMask,hdc,MechanicsS,MechanicsSMask,550,edx,960,185,0,0,WINDOW_WIDTH/6,WINDOW_HEIGHT/10
pop edx
add edx,WINDOW_HEIGHT/6-30

invoke DrawImage_WithMask,hdc,Exiting,ExitingMasked,550,edx,240,60,0,0,WINDOW_WIDTH/6,WINDOW_HEIGHT/10



;================================================================================
ret
DrawStartScreenButtons ENDP

connect_to_server PROC,hWnd:HWND
;--------------------------------------------------------------------------------
 mov textoffset, offset text

invoke WSAStartup, 101h,addr wsadata 
.if eax!=NULL 
    invoke ExitProcess, 1;<An error occured> 
.else 
    xor eax, eax ;<The initialization is successful. You may proceed with other winsock calls> 
.endif

invoke socket,AF_INET,SOCK_DGRAM,0     ; Create a stream socket for internet use 
.if eax!=INVALID_SOCKET 
    mov sock,eax 
.else 
    invoke ExitProcess, 1
.endif

invoke WSAAsyncSelect, sock, hWnd,WM_SOCKET, FD_READ 
            ; Register interest in connect, read and close events. 
.if eax==SOCKET_ERROR 
	invoke WSAGetLastError
    invoke ExitProcess, 1;<put your error handling routine here> 
.else 
    xor eax, eax  ;........ 
.endif


mov sin.sin_family, AF_INET 
invoke htons, Port                    ; convert port number into network byte order first 
mov sin.sin_port,ax                  ; note that this member is a word-size param. 
invoke inet_addr, addr IPAddress    ; convert the IP address into network byte order 
mov sin.sin_addr,eax 
invoke crt_strlen, offset pleaseconnectus
invoke sendto,sock, offset pleaseconnectus, eax, 0, offset sin, sizeof sin
invoke WSAGetLastError
;================================================================================
ret
connect_to_server ENDP

Draw_Rotating_Object PROC,hdc:HDC
;--------------------------------------------------------------------------------
local pt:POINT
local cos_rotate:DWORD
local sin_rotate:DWORD
invoke GetAsyncKeyState,VK_LBUTTON

cmp eax,0
je endofdraw_rotating
 mov esi, offset buffer
invoke GetCursorPos,addr pt
mov ecx,rotatePT.x;pt.x
;sub ecx,WINPLACE.rcNormalPosition.left
;sub ecx,rotatePT.x
cvtsi2ss xmm0,ecx
movss dword ptr [esi],xmm0

mov edx,rotatePT.y;pt.y
;sub edx,WINPLACE.rcNormalPosition.top
;sub edx,rotatePT.y
cvtsi2ss xmm0,edx
movss dword ptr [esi+4],xmm0


 ;FLD dword ptr [esi+4]

;FLD dword ptr [esi]

;FPATAN
movss xmm0,Adding_Angle
movss xmm1,Current_Angle
addss xmm1,xmm0
movss Current_Angle,xmm1
endofdraw_rotating:
 FLD Current_Angle
;movss xmm6,Adding_Angle
;addss xmm6,xmm6
;movss Adding_Angle,xmm6
FSINCOS;cos first sin after
;mov edi,ADDR cos_rotate
FSTP cos_rotate;cos
;mov edi,ADDR sin_rotate
FSTP sin_rotate;sin
movss xmm0,sin_rotate
mulss xmm0,Minus1;xmm0=minus sin

movss xmm1,cos_rotate
movss rotate_xForm.eM11,xmm1
movss rotate_xForm.eM22,xmm1
movss xmm1,sin_rotate
movss rotate_xForm.eM12,xmm1
movss rotate_xForm.eM21,xmm0

mov eax,rotatePT.x
;sub eax,WINPLACE.rcNormalPosition.left
cvtsi2ss xmm0,eax

mov eax,rotatePT.y
;sub eax,WINPLACE.rcNormalPosition.top
cvtsi2ss xmm4,eax

movss xmm1,cos_rotate
mulss xmm1,xmm0
movss xmm2,sin_rotate
mulss xmm2,xmm4
movss xmm3,xmm0
subss xmm3,xmm1
addss xmm3,xmm2
movss rotate_xForm.ex,xmm3

movss xmm1,cos_rotate
mulss xmm1,xmm4
movss xmm2,sin_rotate
mulss xmm2,xmm0
movss xmm3,xmm4
subss xmm3,xmm1
subss xmm3,xmm2
movss rotate_xForm.ey,xmm3

invoke SetWorldTransform,hdc,offset rotate_xForm


; invoke GetClientRect,hWnd,addr testrc
; invoke DPtoLP,hdcBuffer,addr testrc,2

 invoke GetStockObject,LTGRAY_BRUSH
 invoke SelectObject,hdc,eax
 
  
 mov eax,rotatePT.x
 sub eax,100
 mov ebx,rotatePT.y
 sub ebx,100
 mov ecx,rotatePT.x
 add ecx,100
 mov edx,rotatePT.y
 add edx,100
 invoke Ellipse,hdc,eax,ebx,ecx,edx



 mov eax,rotatePT.x
 sub eax,94
 mov ebx,rotatePT.y
 sub ebx,94
 mov ecx,rotatePT.x
 add ecx,94
 mov edx,rotatePT.y
 add edx,94
 invoke Ellipse,hdc,eax,ebx,ecx,edx

 
 mov eax,rotatePT.x
 sub eax,13
 mov ebx,rotatePT.y
 sub ebx,113
 mov ecx,rotatePT.x
 add ecx,13
 mov edx,rotatePT.y
 add edx,50
 invoke Rectangle,hdc,eax,ebx,ecx,edx

 mov eax,rotatePT.x
 sub eax,13
 mov ebx,rotatePT.y
 sub ebx,96
 mov ecx,rotatePT.x
 add ecx,13
 mov edx,rotatePT.y
 add edx,50
 invoke Rectangle,hdc,eax,ebx,ecx,edx

 mov eax,rotatePT.x
 sub eax,150
 invoke MoveToEx,hdc,eax,rotatePT.y,NULL
 mov eax,rotatePT.x
 sub eax,16
 invoke LineTo,hdc,eax,rotatePT.y

 mov eax,rotatePT.x
 sub eax,13
 invoke MoveToEx,hdc,eax,rotatePT.y,NULL
 mov eax,rotatePT.x
 add eax,13
 invoke LineTo,hdc,eax,rotatePT.y

 
 mov eax,rotatePT.x
 add eax,16
 invoke MoveToEx,hdc,eax,rotatePT.y,NULL
 mov eax,rotatePT.x
 add eax,150
 invoke LineTo,hdc,eax,rotatePT.y
 invoke SetWorldTransform,hdc,offset normal_xForm;WORKS GREAT







;================================================================================
ret
Draw_Rotating_Object ENDP

MechanicsScreen PROC,hdc:HDC,hWnd:HWND
;--------------------------------------------------------------------------------
cmp STATUS_INMECH,0
jne nomain

invoke DrawImage,hdc,MechanicsP,0,0,0,0,960,720,WINDOW_WIDTH,WINDOW_HEIGHT
mov esi,Highlight
imul esi,WINDOW_WIDTH/3
add esi,100
invoke DrawImage_WithMask,hdc,HighlightBIT,HighlightBITMasked,esi,WINDOW_HEIGHT/2-100,240,60,0,0,WINDOW_WIDTH/8,WINDOW_HEIGHT/14
invoke DrawImage_WithMask,hdc,Vectors,VectorsMask,100,WINDOW_HEIGHT/2-100,810,179,0,0,WINDOW_WIDTH/8,WINDOW_HEIGHT/14
invoke DrawImage_WithMask,hdc,Rotation,RotationMask,100+WINDOW_WIDTH/3,WINDOW_HEIGHT/2-100,773,156,0,0,WINDOW_WIDTH/8,WINDOW_HEIGHT/14
invoke DrawImage_WithMask,hdc,OnlineF,OnlineFMask,100+WINDOW_WIDTH/3+WINDOW_WIDTH/3,WINDOW_HEIGHT/2-100,720,191,0,0,WINDOW_WIDTH/8,WINDOW_HEIGHT/14
inc	FramesSinceLastClick
cmp FramesSinceLastClick,7
jl finishbutton
mov FramesSinceLastClick,0
invoke GetAsyncKeyState,VK_ESCAPE

cmp eax,0
je dont_switch_to_start
mov STATUS,0
invoke GetAsyncKeyState,VK_RETURN
dont_switch_to_start:

invoke GetAsyncKeyState,VK_RETURN

cmp eax,0
je iright
cmp Highlight,0
jne next
mov STATUS_INMECH,1
jmp finishbutton
next:
cmp Highlight,1
jne next2
mov STATUS_INMECH,2
jmp finishbutton
next2:
cmp Highlight,2
jne iright
mov STATUS_INMECH,3
jmp finishbutton

iright: 
invoke GetAsyncKeyState,VK_RIGHT

cmp eax,0
je ileft
inc Highlight
cmp Highlight,2
jng nevermind
mov Highlight,0
nevermind:
jmp finishbutton
ileft:
invoke GetAsyncKeyState,VK_LEFT

cmp eax,0
je finishbutton
dec Highlight
cmp Highlight,0
jnl finishbutton
mov Highlight,2
jmp finishbutton

nomain:
cmp STATUS_INMECH,1
jne novectors
invoke DrawImage,hdc,VectorsP,0,0,0,0,960,720,WINDOW_WIDTH,WINDOW_HEIGHT-20
inc	FramesSinceLastClick
cmp FramesSinceLastClick,6
jl finishbutton
mov FramesSinceLastClick,0
invoke GetAsyncKeyState,VK_ESCAPE

cmp eax,0
je noreturn1
mov STATUS_INMECH,0
noreturn1: 
jmp finishbutton
novectors:

cmp STATUS_INMECH,2
jne norotation
invoke DrawImage,hdc,RotationP,0,0,0,0,960,720,WINDOW_WIDTH,WINDOW_HEIGHT-20
invoke GetWindowPlacement,hWnd,OFFSET WINPLACE
invoke Draw_Rotating_Object,hdc
inc	FramesSinceLastClick
cmp FramesSinceLastClick,6
jl finishbutton
mov FramesSinceLastClick,0
invoke GetAsyncKeyState,VK_ESCAPE

cmp eax,0
je noreturn2
mov STATUS_INMECH,0
noreturn2: 
jmp finishbutton
norotation:

cmp STATUS_INMECH,3
jne noOnline

invoke GetAsyncKeyState,VK_ESCAPE

cmp eax,0
je noreturn3
mov STATUS_INMECH,0
noreturn3: 
invoke DrawImage,hdc,OnlineP,0,0,0,0,960,720,WINDOW_WIDTH,WINDOW_HEIGHT-20
inc	FramesSinceLastClick
cmp FramesSinceLastClick,6
jl finishbutton
mov FramesSinceLastClick,0
jmp finishbutton
noOnline:
finishbutton:
;================================================================================
ret
MechanicsScreen ENDP

YouLostScreen PROC,hdc:HDC,hWnd:HWND
;--------------------------------------------------------------------------------
invoke DrawImage,hdc,YouLost,0,0,0,0,960,720,WINDOW_WIDTH,WINDOW_HEIGHT

mov eax,Highlight
mov esi,WINDOW_HEIGHT/5+20
xor edx,edx
imul esi
add eax,200
invoke DrawImage_WithMask,hdc,HighlightBIT,HighlightBITMasked,350,eax,240,60,0,0,WINDOW_WIDTH/4,WINDOW_HEIGHT/5

invoke DrawImage_WithMask,hdc,NewGameDead,NewGameDeadMask,350,200,782,194,0,0,WINDOW_WIDTH/4,WINDOW_HEIGHT/5
invoke DrawImage_WithMask,hdc,MainMenu,MainMenuMask,350,200+((WINDOW_HEIGHT/5)+20),861,138,0,0,WINDOW_WIDTH/4,WINDOW_HEIGHT/5

inc FramesSinceLastClick
cmp FramesSinceLastClick,5
jl finish

invoke GetAsyncKeyState,VK_RETURN
cmp eax,0
je next

mov FramesSinceLastClick,0

cmp Highlight,0
jne notrestart
mov SAVESTATUS,7
invoke Restart,hWnd
mov STATUS,1
jmp finish
notrestart:

cmp Highlight,1
jne notmainmenu
invoke KillTimer,hWnd,RoundEnded
mov STATUS,0
jmp finish
notmainmenu:


next:
invoke GetAsyncKeyState,VK_DOWN
cmp eax,0
je next2

mov FramesSinceLastClick,0

inc Highlight
cmp Highlight,1
jng nevermind
mov Highlight,0
nevermind:


next2:
invoke GetAsyncKeyState,VK_UP
cmp eax,0
je finish

mov FramesSinceLastClick,0

dec Highlight
cmp Highlight,0
jnl nevermind2
mov Highlight,1
nevermind2:

finish:
;================================================================================
ret

;================================================================================
ret
YouLostScreen ENDP


PauseScreen PROC,hdc:HDC,hWnd:HWND
;--------------------------------------------------------------------------------
invoke DrawImage,hdc,Paused,0,0,0,0,960,720,WINDOW_WIDTH,WINDOW_HEIGHT
mov eax,Highlight
mov esi,WINDOW_HEIGHT/5+20
xor edx,edx
imul esi
add eax,200
invoke DrawImage_WithMask,hdc,HighlightBIT,HighlightBITMasked,350,eax,240,60,0,0,WINDOW_WIDTH/4,WINDOW_HEIGHT/5

invoke DrawImage_WithMask,hdc,Resume,ResumeMask,350,200,782,194,0,0,WINDOW_WIDTH/4,WINDOW_HEIGHT/5
invoke DrawImage_WithMask,hdc,OptionsPaused,OptionsPausedMask,350,200+WINDOW_HEIGHT/5+20,717,169,0,0,WINDOW_WIDTH/4,WINDOW_HEIGHT/5
invoke DrawImage_WithMask,hdc,MainMenu,MainMenuMask,350,200+((2*(WINDOW_HEIGHT/5)+20)),861,138,0,0,WINDOW_WIDTH/4,WINDOW_HEIGHT/5

inc FramesSinceLastClick
cmp FramesSinceLastClick,5
jl finish

invoke GetAsyncKeyState,VK_RETURN
cmp eax,0
je next

mov FramesSinceLastClick,0

cmp Highlight,0
jne notresume
mov SAVESTATUS,6
mov STATUS,1
jmp finish
notresume:

cmp Highlight,1
jne notoptions
mov SAVESTATUS,6
mov STATUS,3
jmp finish
notoptions:

cmp Highlight,2
jne notmainmenu
invoke KillTimer,hWnd,RoundEnded
mov STATUS,0
jmp finish
notmainmenu:


next:
invoke GetAsyncKeyState,VK_DOWN
cmp eax,0
je next2

mov FramesSinceLastClick,0

inc Highlight
cmp Highlight,2
jng nevermind
mov Highlight,0
nevermind:


next2:
invoke GetAsyncKeyState,VK_UP
cmp eax,0
je finish

mov FramesSinceLastClick,0

dec Highlight
cmp Highlight,0
jnl nevermind2
mov Highlight,2
nevermind2:

finish:
;================================================================================
ret
PauseScreen ENDP


StartScreen PROC,hdc:HDC,hWnd:HWND
;--------------------------------------------------------------------------------
inc	FramesSinceLastClick
invoke DrawImage,hdc,StartScreenBK,0,0,0,0,960,720,WINDOW_WIDTH-15,WINDOW_HEIGHT-40
invoke DrawStartScreenButtons,hdc,Highlight
cmp FramesSinceLastClick,5
jl finishbutton
mov FramesSinceLastClick,0
invoke GetAsyncKeyState,VK_RETURN
cmp eax,0
je idown
cmp Highlight,0
jne next
invoke Restart,hWnd
mov STATUS,1
cmp myFirstLoad,TRUE
jne no_createthread
invoke CreateThread, NULL, NULL, offset make_distance_map,NULL, NULL, NULL
mov myFirstLoad,FALSE
no_createthread:

jmp finishbutton
next:
cmp Highlight,1
jne next2
invoke connect_to_server,hWnd
;mov two_Players,TRUE
invoke GetTickCount
mov Time_Step_Should_End,eax
mov Time_Step_Should_End_Player,eax
mov STATUS,4
jmp finishbutton
next2:
cmp Highlight,2
jne next3
mov SAVESTATUS,0
mov STATUS,3
mov Highlight,0
jmp finishbutton
next3:
cmp Highlight,3
jne next4
mov STATUS,5
invoke GetAsyncKeyState,VK_ESCAPE
mov Highlight,0
jmp finishbutton
next4:
cmp Highlight,4
jne idown
invoke CloseProcess
jmp finishbutton

idown: 
invoke GetAsyncKeyState,VK_DOWN

cmp eax,0
je iup
inc Highlight
cmp Highlight,4
jng nevermind
mov Highlight,0
nevermind:
jmp finishbutton
iup:
invoke GetAsyncKeyState,VK_UP

cmp eax,0
je finishbutton
dec Highlight
cmp Highlight,0
jnl finishbutton
mov Highlight,4
finishbutton:
;================================================================================
ret
StartScreen ENDP

itoa PROC,num:DWORD,stringP:DWORD,radix:DWORD
;--------------------------------------------------------------------------------
local counting:DWORD
local savingNum:DWORD
mov eax,0
mov savingNum,eax
mov counting,eax
mov eax,num
mov savingNum,eax
mov ebx,stringP
loopingcheckingifzero:

mov eax,savingNum
mov ecx,10
xor edx,edx
idiv ecx
mov savingNum,eax
add dl,"0"
push edx
inc counting
cmp savingNum,0
jne loopingcheckingifzero

mov ecx,counting

looppoping:
pop edx
mov byte ptr [ebx],dl
inc ebx
loop looppoping
mov byte ptr [ebx],0
mov eax,counting

;================================================================================
ret
itoa	ENDP

DrawStore	PROC,hdc:HDC,hWnd:HWND
;--------------------------------------------------------------------------------
local brush:HBRUSH

invoke DrawImage,hdc,StoreBK,0,0,0,0,960,720,WINDOW_WIDTH-15,WINDOW_HEIGHT-40
cmp Highlight,3
je up_state
mov eax,Highlight
mov esi,WINDOW_WIDTH/6+180
xor edx,edx
imul esi
add eax,50
invoke DrawImage_WithMask,hdc,HighlightBIT,HighlightBITMasked,eax,275,240,60,0,0,WINDOW_WIDTH/6,WINDOW_HEIGHT/6
jmp not_up_state
up_state:

invoke DrawImage_WithMask,hdc,HighlightBIT,HighlightBITMasked,750,150,240,60,0,0,WINDOW_WIDTH/6,WINDOW_HEIGHT/6

not_up_state:
invoke DrawImage_WithMask,hdc,NextWave,NextWaveMask,750,150,831,143,0,0,WINDOW_WIDTH/6,WINDOW_HEIGHT/6

invoke DrawImage_WithMask,hdc,h25hp,h25hpMask,50,460,268,116,0,0,WINDOW_WIDTH/6,WINDOW_HEIGHT/6
invoke DrawImage_WithMask,hdc,h75hp,h75hpMask,50+WINDOW_WIDTH/6+180,460,267,84,0,0,WINDOW_WIDTH/6,WINDOW_HEIGHT/6
invoke DrawImage_WithMask,hdc,h150hp,h150hpMask,50+WINDOW_WIDTH/6+180+WINDOW_WIDTH/6+180,460,314,86,0,0,WINDOW_WIDTH/6,WINDOW_HEIGHT/6

invoke DrawImage_WithMask,hdc,h30d,h30dMask,50,275,744,325,0,0,WINDOW_WIDTH/6,WINDOW_HEIGHT/6
invoke DrawImage_WithMask,hdc,h80d,h80dMask,50+WINDOW_WIDTH/6+180,275,785,321,0,0,WINDOW_WIDTH/6,WINDOW_HEIGHT/6
invoke DrawImage_WithMask,hdc,h150d,h150dMask,50+WINDOW_WIDTH/6+180+WINDOW_WIDTH/6+180,275,796,265,0,0,WINDOW_WIDTH/6,WINDOW_HEIGHT/6

invoke itoa,Money,offset MoneyBuffer,10
push eax

invoke SelectObject,hdc,MyFont
invoke SetBkMode,hdc,TRANSPARENT
invoke SetTextColor,hdc,000045f7h
pop eax
invoke TextOut,hdc,275,140,offset MoneyBuffer,eax

inc FramesSinceLastClick
cmp FramesSinceLastClick,5
jl finish

invoke GetAsyncKeyState,VK_RETURN
cmp eax,0
je next

mov FramesSinceLastClick,0

cmp Highlight,0
jne not25
cmp Money,30
jl finish
cmp Player_Life,500
jge finish
sub Money,30
add Player_Life,25
jmp finish
not25:

cmp Highlight,1
jne not75
cmp Money,80
jl finish
cmp Player_Life,500
jge finish
sub Money,80
add Player_Life,75
jmp finish
not75:

cmp Highlight,2
jne not150
cmp Money,150
jl finish
cmp Player_Life,500
jge finish
sub Money,150
add Player_Life,150
jmp finish
not150:

cmp Highlight,3
jne not_next_wave
invoke NextWaveP,hWnd
mov STATUS,1
jmp finish
not_next_wave:

next:
invoke GetAsyncKeyState,VK_RIGHT
cmp eax,0
je next2

mov FramesSinceLastClick,0

inc Highlight
cmp Highlight,2
jng nevermind
mov Highlight,0
nevermind:


next2:
invoke GetAsyncKeyState,VK_LEFT
cmp eax,0
je next3

mov FramesSinceLastClick,0

dec Highlight
cmp Highlight,0
jnl nevermind2
mov Highlight,2
nevermind2:

next3:
invoke GetAsyncKeyState,VK_UP
cmp eax,0
je next4
mov FramesSinceLastClick,0
mov Highlight,3
jmp finish
next4:
invoke GetAsyncKeyState,VK_DOWN
cmp eax,0
je finish
mov FramesSinceLastClick,0
mov Highlight,0
finish:
cmp Player_Life,500
jng noreset
mov Player_Life,500
noreset:

invoke GetStockObject,DC_BRUSH
mov brush,eax
invoke SelectObject,hdc,brush
invoke SetDCBrushColor, hdc,00000000FF00h
mov brush,eax
mov eax,Player_Life
mov ecx,5
xor edx,edx
idiv ecx
push eax
invoke BUILDRECT,275,205,50,eax,hdc,brush
pop eax
mov ebx,100
sub ebx,eax
add eax,275
push ebx
push eax
invoke SelectObject,hdc,brush
invoke SetDCBrushColor,hdc,0000000000ffh
mov brush,eax
pop eax
pop ebx
invoke BUILDRECT,eax,205,50,ebx,hdc,brush



;================================================================================
ret
DrawStore	ENDP



DrawScore	PROC,hdc:HDC
;--------------------------------------------------------------------------------
invoke DrawImage_WithMask,hdc,score,scoreMasked,20,20,150,56,0,0,WINDOW_WIDTH/6,WINDOW_HEIGHT/8
invoke itoa,scoreNum,offset scoreBuffer,10
push eax

invoke SelectObject,hdc,MyFont
invoke SetBkMode,hdc,TRANSPARENT
invoke SetTextColor,hdc,000045f7h
pop eax
invoke TextOut,hdc,(WINDOW_WIDTH/6)+20,20+40,offset scoreBuffer,eax
mov ecx,60
mov eax,realtimetillend
xor edx,edx
idiv ecx
push edx
invoke itoa,eax,offset timeBuffer,10
invoke TextOut,hdc,450,20+40,offset timeBuffer,eax

invoke TextOut,hdc,550,20+40,offset doubledot,1
pop edx
invoke itoa,edx,offset timeBuffer,10
invoke TextOut,hdc,600,20+40,offset timeBuffer,eax
invoke SetBkMode,hdc,OPAQUE
invoke SetTextColor,hdc,00000000
;================================================================================
ret
DrawScore	ENDP

Check_If_Bullet_Hit_And_Destroy_Zombie PROC,x:DWORD,y:DWORD,w:DWORD,h:DWORD,lp_zombies:DWORD
;--------------------------------------------------------------------------------
local rect:RECT
local rectz:RECT
local junkrect:RECT
mov eax,x
mov rect.left,eax
add eax,w
mov rect.right,eax
mov eax,y
mov rect.top,eax
add eax,h
mov rect.bottom,eax
 
mov ebx,lp_zombies
mov ecx,50
 
searchingforhits:
pusha;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mov eax,dword ptr [ebx]
cmp eax,-999
je next

popa;------------------------------------------
pusha;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cvtss2si eax,dword ptr [ebx]
mov rectz.left,eax
add eax,Zombie_Width
mov rectz.right,eax
cvtss2si eax,dword ptr [ebx+4]
mov rectz.top,eax
add eax,Zombie_Height
mov rectz.bottom,eax
invoke IntersectRect,addr junkrect,addr rectz,addr rect
cmp eax,0
je next

found:
popa;------------------------------------------
inc dword ptr [ebx+16]
cmp dword ptr [ebx+16],2
jl noaddscore
add scoreNum,50
noaddscore:
mov eax,1;Found
jmp endingsearching

next:
popa;------------------------------------------
add ebx,36
loop searchingforhits
mov eax,0
endingsearching:
;================================================================================
ret
Check_If_Bullet_Hit_And_Destroy_Zombie ENDP
 
 Check_If_Player_Hit_Coin_Add_Money_And_Remove_Coin PROC,x:DWORD,y:DWORD,lp_money:DWORD
 ;--------------------------------------------------------------------------------
 local PlayerRect:RECT
 local CoinRect:RECT
 local junkrect:RECT
 mov eax,x
 mov PlayerRect.left,eax
 add eax,RECT_WIDTH
 mov PlayerRect.right,eax
 mov eax,y
 mov PlayerRect.top,eax
 add eax,RECT_HEIGHT
 mov PlayerRect.bottom,eax

 mov ebx,offset coins
 mov ecx,50
loopcheckingforcoinhits:
cmp dword ptr [ebx],-999
pusha
je DeadCoin
popa
mov eax,dword ptr [ebx]
mov CoinRect.left,eax
add eax,Coin_Width
mov CoinRect.right,eax
mov eax,dword ptr [ebx+4]
mov CoinRect.top,eax
add eax,Coin_Height
mov CoinRect.bottom,eax
pusha
invoke IntersectRect,addr junkrect,addr PlayerRect,addr CoinRect
cmp eax,0
je DeadCoin
popa
mov dword ptr [ebx],-999
mov edi,lp_money
inc dword ptr [edi]
add scoreNum,20
pusha
DeadCoin:
popa
add ebx,12
dec ecx
jnz loopcheckingforcoinhits 
 ;================================================================================
 ret
 Check_If_Player_Hit_Coin_Add_Money_And_Remove_Coin ENDP

 Push_Zombies	PROC,x:DWORD,y:DWORD,w:DWORD,h:DWORD
 ;-------------------------------------------------------------------------------
 local rect:RECT
local rectz:RECT
local junkrect:RECT
mov eax,x
mov rect.left,eax
add eax,w
mov rect.right,eax
mov eax,y
mov rect.top,eax
add eax,h
mov rect.bottom,eax
 
mov ebx,offset zombies
mov ecx,50
 
searchingforhits:
pusha;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mov eax,dword ptr [ebx]
cmp eax,-999
je next

popa;------------------------------------------
pusha;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cvtss2si eax,dword ptr [ebx]
mov rectz.left,eax
add eax,Zombie_Width
mov rectz.right,eax
cvtss2si eax,dword ptr [ebx+4]
mov rectz.top,eax
add eax,Zombie_Height
mov rectz.bottom,eax
invoke IntersectRect,addr junkrect,addr rectz,addr rect
cmp eax,0
je next


found:
popa;------------------------------------------
movss xmm0,dword ptr [ebx+12]
mulss xmm0,threepointzero
movss xmm1,dword ptr [ebx]
subss xmm1,dword ptr [ebx+12]
movss dword ptr [ebx],xmm1
movss xmm0, dword ptr [ebx+8]
mulss xmm0,threepointzero
movss xmm1,dword ptr [ebx+4]
subss xmm1,xmm0
movss dword ptr [ebx+4],xmm1
pusha


next:
popa;------------------------------------------
add ebx,36
loop searchingforhits
endingsearching:
 ;================================================================================
 ret
 Push_Zombies	ENDP

Check_If_Player_Hit_And_Remove_Life PROC,x:DWORD,y:DWORD,w:DWORD,h:DWORD
;--------------------------------------------------------------------------------
local rect:RECT
local rectz:RECT
local junkrect:RECT
mov eax,x
mov rect.left,eax
add eax,w
mov rect.right,eax
mov eax,y
mov rect.top,eax
add eax,h
mov rect.bottom,eax
 
mov ebx,offset zombies
mov ecx,80
 
searchingforhits:
pusha;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mov eax,dword ptr [ebx]
cmp eax,-999
je next

popa;------------------------------------------
pusha;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cvtss2si eax,dword ptr [ebx]
mov rectz.left,eax
add eax,Zombie_Width
mov rectz.right,eax
cvtss2si eax,dword ptr [ebx+4]
mov rectz.top,eax
add eax,Zombie_Height
mov rectz.bottom,eax
invoke IntersectRect,addr junkrect,addr rectz,addr rect
cmp eax,0
je next


found:
popa;------------------------------------------
dec Player_Life
mov FoundForSound,1
mov Found,1
pusha


next:
popa;------------------------------------------
add ebx,36
loop searchingforhits
endingsearching:

;================================================================================
ret
Check_If_Player_Hit_And_Remove_Life ENDP

Check_If_Player_Hit_Pack_And_Remove_Pack	PROC,x:DWORD,y:DWORD,lp_life:DWORD
;--------------------------------------------------------------------------------

local PlayerRect:RECT
 local PackRect:RECT
 local junkrect:RECT
 mov eax,x
 mov PlayerRect.left,eax
 add eax,RECT_WIDTH
 mov PlayerRect.right,eax
 mov eax,y
 mov PlayerRect.top,eax
 add eax,RECT_HEIGHT
 mov PlayerRect.bottom,eax

 mov ebx,offset Packs
 mov ecx,10
loopcheckingforpackhits:
cmp dword ptr [ebx],-999
pusha
je DeadPack
popa
mov eax,dword ptr [ebx]
mov PackRect.left,eax
add eax,Health_Pack_Width
mov PackRect.right,eax
mov eax,dword ptr [ebx+4]
mov PackRect.top,eax
add eax,Health_Pack_Height
mov PackRect.bottom,eax
pusha
invoke IntersectRect,addr junkrect,addr PlayerRect,addr PackRect
cmp eax,0
je DeadPack
popa
mov dword ptr [ebx],-999
mov edi,lp_life
add dword ptr [edi],50;add Player_Life,50
pusha
DeadPack:
popa
add ebx,16
dec ecx
jnz loopcheckingforpackhits 


;================================================================================
ret
Check_If_Player_Hit_Pack_And_Remove_Pack ENDP

DropCoin	PROC,	x:DWORD,y:DWORD
;--------------------------------------------------------------------------------
mov ebx,offset coins
mov ecx,50
loopingcheckingifemptyc:
cmp dword ptr [ebx],-999
jne CoinTaken
mov eax,x
mov dword ptr [ebx],eax
mov eax,y
mov dword ptr [ebx+4],eax
invoke GetTickCount
add eax,8000
mov dword ptr [ebx+8],eax
jmp EndDropCoin
CoinTaken:
add ebx,12
dec ecx
jnz loopingcheckingifemptyc


EndDropCoin:
;================================================================================
ret
DropCoin ENDP


DrawCoin	PROC,hdc:HDC,brush:HBRUSH
;--------------------------------------------------------------------------------
  local hdcMem1:HDC
  local hOld:HBITMAP

mov ebx,offset coins
mov ecx,50
loopdrawingcoins:
push ecx
cmp dword ptr [ebx],-999
je NoCoin
pop ecx
push ecx
cmp two_Players,FALSE
je dont_check
cmp host,FALSE
je ContinueDrawingCoins
dont_check:
invoke GetTickCount
cmp dword ptr [ebx+8],eax
jg ContinueDrawingCoins
pop ecx
push ecx
mov dword ptr [ebx],-999
jmp NoCoin
ContinueDrawingCoins:
	pop ecx
	push ecx
	
	invoke DrawImage_WithMask,hdc,hCoinColour,hCoinMask,dword ptr [ebx],dword ptr [ebx+4],Coin_Width,Coin_Height,0,0,Coin_Width,Coin_Height;CHANGE TO WINDO_WIDTH/X AND WINDOW_HEIGHT/Y
	
	
NoCoin:
	pop ecx
	add ebx,12
	dec ecx
	jnz loopdrawingcoins
endloopdrawingcoins:
;================================================================================
ret
DrawCoin ENDP


Maybe_Drop_Pack	PROC,x:DWORD,y:DWORD
;--------------------------------------------------------------------------------
 invoke GetRandomNumber,4,offset randombuffer 
 mov eax, randombuffer
 mov ecx,ChanceToDropHealthPack
 xor edx,edx
 div ecx
 cmp edx,0
 jne End_Maybe_Drop_Health_Pack 
 mov ebx,offset Packs
 mov ecx,10
 loopingcheckingifemptypacks:
 cmp dword ptr [ebx],-999
 jne nextPack
 mov eax,x
 mov dword ptr [ebx],eax
 mov eax,y
 mov dword ptr [ebx+4],eax
 invoke GetTickCount
add eax,8000
mov dword ptr [ebx+8],eax
mov dword ptr [ebx+12],0;For now it will be zero later I will add different packs so it will be random 0-somenumber
jmp End_Maybe_Drop_Health_Pack
 nextPack:
 add ebx,16
 loop loopingcheckingifemptypacks
 End_Maybe_Drop_Health_Pack:
;================================================================================
ret
Maybe_Drop_Pack	ENDP

Draw_Packs	PROC,hdc:HDC
;--------------------------------------------------------------------------------
local hdcMem:HDC
local hOld:HBITMAP

mov ebx,offset Packs
mov ecx,10
loopingdrawingpacks:
push ecx
cmp dword ptr [ebx],-999
je nopack
pop ecx
push ecx
invoke GetTickCount
cmp dword ptr [ebx+8],eax
jg ContinueDrawingPacks
pop ecx
push ecx
mov dword ptr [ebx],-999
jmp nopack

ContinueDrawingPacks:

    invoke DrawImage_WithMask,hdc,hHealthPackColour,hHealthPackMask,dword ptr [ebx],dword ptr [ebx+4],Health_Pack_Width,Health_Pack_Height,0,0,Health_Pack_Width,Health_Pack_Height;CHANGE TO WINDO_WIDTH/X AND WINDOW_HEIGHT/Y

	COMMENT @
	invoke CreateCompatibleDC,hdc
	mov hdcMem,eax
	invoke SelectObject,hdcMem,hHealthPackMask
	mov hOld,eax
	

	
	invoke BitBlt,hdc,dword ptr [ebx],dword ptr [ebx+4],Health_Pack_Width,Health_Pack_Height,hdcMem,0,0,SRCAND
	
	
	invoke SelectObject,hdcMem,hHealthPackColour
	
	invoke BitBlt,hdc,dword ptr [ebx],dword ptr [ebx+4],Health_Pack_Width,Health_Pack_Height,hdcMem,0,0,SRCPAINT

	invoke SelectObject,hdcMem,hOld
	invoke DeleteDC,hdcMem
	@
	pop ecx
	push ecx

nopack:
pop ecx
add ebx,16
dec ecx
jnz loopingdrawingpacks
;================================================================================
ret
Draw_Packs	ENDP

BITMAP_ID_TO_HBITMAP	PROC,id:DWORD

cmp id,113
jne notIDB_Front
mov eax,Frontz
mov edx,FrontzMask
notIDB_Front:

cmp id,114
jne notIDB_Right
mov eax,Rightz
mov edx,RightzMask
notIDB_Right:

cmp id,115
jne notIDB_Left
mov eax,Leftz
mov edx,LeftzMask
notIDB_Left:

cmp id,116
jne notIDB_Back
mov eax,Backz
mov edx,BackzMask
notIDB_Back:


ret
BITMAP_ID_TO_HBITMAP	ENDP

DrawZombie PROC,hdc:HDC,brush:HBRUSH,hWnd:HWND
;--------------------------------------------------------------------------------
mov ebx,offset zombies
mov ecx,50
 
loopingzomb:
pusha
mov eax,dword ptr [ebx]
cmp eax,-999
je next
mov eax,dword ptr [ebx+16];hit count
cmp eax,2
jge deadz

 mov eax,dword ptr [ebx+8]
 cvtsi2ss xmm2,eax
 movss dword ptr [ebx],xmm2
 mov eax,dword ptr [ebx+12]
 cvtsi2ss xmm2,eax
 movss dword ptr [ebx+4],xmm2


movss xmm0, dword ptr [ebx]
movss xmm1, dword ptr [ebx+4]

cvtss2si eax,xmm0
mov ZombieX,eax
cvtss2si eax,xmm1
mov ZombieY,eax
mov edx,dword ptr [ebx+28]
;DOES NOT WORK WITH ONLINE - BITMAPS ARE LOADED DIFFERENTLY IN DIFFERENT PROGRAMS----------------------------
;SOLUTION: MAKE A FUNCTION THAT RECIEVES BITMAP_ID,AND CREATES IT'S BITMAP
invoke BITMAP_ID_TO_HBITMAP,dword ptr [ebx+20]
 invoke DrawImage_WithMask,hdc,eax,edx,ZombieX,ZombieY,30,40,dword ptr [ebx+28],0,Zombie_Width,Zombie_Height ;,WINDOW_WIDTH/25,WINDOW_HEIGHT/22
 ;invoke BUILDRECT,       ZombieX,        ZombieY,        Zombie_Height,Zombie_Width,hdc,brush
invoke GetTickCount
cmp dword ptr [ebx+32],eax
jg next
cmp dword ptr [ebx+28],70
jl noend
mov dword ptr [ebx+28],0
invoke GetTickCount
add eax,Time_Between_Steps
mov dword ptr [ebx+32],eax
jmp next
noend:
add dword ptr [ebx+28],35
invoke GetTickCount
add eax,Time_Between_Steps
mov dword ptr [ebx+32],eax
jmp next
deadz:
;add scoreNum,50
sub Time_Between_Steps,50
pusha
cvtss2si eax,dword ptr [ebx]
mov ZombieX,eax
cvtss2si edx,dword ptr [ebx+4]
mov ZombieY,edx
invoke Maybe_Drop_Pack,ZombieX,ZombieY
invoke DropCoin,ZombieX,ZombieY
popa
mov dword ptr [ebx],-999
cmp Zombie_Spawning_Time,500
jle next
mov eax,Zombie_Spawning_Time
sub eax,60
mov Zombie_Spawning_Time,eax
;inc Number_To_Spawn
invoke SetTimer, hWnd, ZombieTime, Zombie_Spawning_Time , NULL ;Set the zombie time
movss xmm0,ADDINGZ
movss xmm1,VELZ
addss xmm1,xmm0
movss VELZ,xmm1
next:
popa
add ebx,36
dec ecx
jnz loopingzomb;loop loopingzomb
;================================================================================
ret
DrawZombie ENDP

 
closest_player PROC,zomb_x:DWORD,zomb_y:DWORD

 mov esi,Player.x
 sub esi,zomb_x

 mov ebx,Player.y
 sub ebx,zomb_y

 xor edx,edx
 imul esi,esi

 xor edx,edx
 imul ebx,ebx

 add esi,ebx


 mov ebx,Player2.x
 sub ebx,zomb_x
 mov edi,Player2.y
 sub edi,zomb_y
 xor edx,edx
 imul ebx,ebx
 xor edx,edx
 imul edi,edi
 add ebx,edi
 
 cmp esi,ebx
 jl firstisbigger

 secondisbigger:
 ;mov edi,lp_x
 ;mov eax,Player2.x
 ;mov dword ptr [edi],eax
 ;mov edi,lp_y
 ;mov eax,Player2.y
 ;mov dword ptr [edi],eax
 mov eax,2
 jmp endofclosest_player

 firstisbigger:
 ;mov edi,lp_x
 ;mov eax,Player.x
 ;mov dword ptr [edi],eax
 ;mov edi,lp_y
 ;mov eax,Player.y
 ;mov dword ptr [edi],eax
 mov eax,1

 endofclosest_player:

 ret
 closest_player ENDP

 return_closest_pixel1 PROC,x:DWORD,y:DWORD,lp_pt:DWORD
 

 local topD:DWORD
 local botD:DWORD
 local rightD:DWORD
 local leftD:DWORD
 mov eax,y
 dec eax

 invoke getValue,x,eax,offset DistanceMap
 mov topD,eax
 
 
 mov eax,y
 inc eax

 invoke getValue,x,eax,offset DistanceMap
 mov botD,eax

 mov eax,x
 inc eax
 
 invoke getValue,eax,y,offset DistanceMap
 mov rightD,eax

 mov eax,x
 dec eax
 invoke getValue,eax,y,offset DistanceMap
 mov leftD,eax

 mov eax,leftD
 cmp rightD,eax
 jg right_not_biggest
	mov eax,botD
	cmp rightD,eax
	jg right_not_biggest
		mov eax,topD
		cmp rightD,eax
		jg right_not_biggest
			mov eax,x
			inc eax
			shl eax,2
			mov edi,lp_pt
			mov [edi],eax
			mov eax,y
			shl eax,2
			mov [edi+4],eax
			jmp endof_return_closest_pixel1
right_not_biggest:
  mov eax,rightD
  cmp leftD,eax
  jg left_not_biggest
	mov eax,topD
	cmp leftD,eax
	jg left_not_biggest
		mov eax,botD
		cmp leftD,eax
		jg left_not_biggest
			mov eax,x
			dec eax
			shl eax,2
			mov edi,lp_pt
			mov [edi],eax
			mov eax,y
			shl eax,2
			mov [edi+4],eax
			jmp endof_return_closest_pixel1
left_not_biggest:
   mov eax,rightD
   cmp topD,eax
   jg top_not_biggest
	   mov eax,leftD
	   cmp topD,eax
	   jg top_not_biggest
			mov eax,botD
			cmp topD,eax
			jg top_not_biggest
				mov eax,x
				shl eax,2
				mov edi,lp_pt
				mov [edi],eax
				mov eax,y
				dec eax
				shl eax,2
				mov [edi+4],eax
				jmp endof_return_closest_pixel1
top_not_biggest:
	mov eax,topD
	cmp botD,eax
	jg endof_return_closest_pixel1
		mov eax,rightD
		cmp botD,eax
		jg endof_return_closest_pixel1
			mov eax,leftD
			cmp botD,eax
			jg endof_return_closest_pixel1
				mov eax,x
				shl eax,2
				mov edi,lp_pt
				mov [edi],eax
				mov eax,y
				inc eax
				shl eax,2
				mov [edi+4],eax

 endof_return_closest_pixel1:
 ret
 return_closest_pixel1 ENDP

 adjustzombie	PROC
 local closest_x:DWORD
 local closest_y:DWORD
 local pt:POINT
 FNINIT
    mov ebx,offset zombies
                mov ecx,50
        loopingAdjustment:
		 push ecx
				mov eax,dword ptr [ebx]
				cmp eax,-999
				je DeadNoAdjust
				pusha
				cmp two_Players,FALSE
				je use_player1
				cvtss2si eax,dword ptr [ebx]
				cvtss2si edx,dword ptr [ebx+4]
				invoke closest_player,eax,edx
				cmp eax,1
				je use_player1
				
				use_player1:
				cvtss2si ecx,dword ptr [ebx]
				cvtss2si edx,dword ptr [ebx+4]
				shr ecx,2
				shr edx,2
				invoke return_closest_pixel1,ecx,edx,addr pt
				mov eax,Player.x
				mov closest_x,eax
				mov eax,Player.y
				mov closest_y,eax
				end_of_closest:
				popa
                mov esi, offset buffer
           ;=====================DELTA X=================================
           mov ecx,closest_x
            cvtss2si edx,dword ptr [ebx]
           sub ecx,edx
           cvtsi2ss xmm2,ecx
           movss dword ptr [esi],xmm2
           ;-------------------------------------------------------------
           ;=====================DELTA Y=================================
           mov eax,closest_y
           cvtss2si edx,dword ptr [ebx+4]
           sub eax,edx
           cvtsi2ss xmm3,eax
           movss dword ptr [esi+8],xmm3
           ;-------------------------------------------------------------
 
       
            FLD dword ptr [esi+8]
         
           FLD dword ptr [esi]
           FPATAN
		   mov edi,offset angle
		   FST qword ptr [edi]
		   cvtsd2ss xmm0,qword ptr [edi]
		   movss realangle,xmm0
		   cvtss2si eax,xmm0
		   mov realangle,eax
		   
		   mov eax,pt.x
		   mov dword ptr [ebx+8],eax
		   mov eax,pt.y
		   mov dword ptr [ebx+12],eax


          

		 

		   mov eax,realangle
		
		 
		   cmp eax,-0;0
		   je right

		   cmp eax,-1;1
		   je up

		   cmp eax,-2
		   je up

		   cmp eax,-3
		   je left

		   cmp eax,-4
		   je left

	
		   cmp eax,0;0
		   je right

		   cmp eax,1;1
		   je down

		   cmp eax,2
		   je down

		   cmp eax,3
		   je left

		   cmp eax,4
		   je left

		  
		   
		  
		 


		   right:
			
		    mov eax,114
			mov dword ptr [ebx+20],eax
			mov eax,114
			mov dword ptr [ebx+24],eax


	
		   jmp DeadNoAdjust

		   down:
		 
		     mov eax,113
			mov dword ptr [ebx+20],eax
			mov eax,113
			mov dword ptr [ebx+24],eax


		  jmp DeadNoAdjust

		  left:
		 
		    mov eax,115
			mov dword ptr [ebx+20],eax
			mov eax,115
			mov dword ptr [ebx+24],eax
		  jmp DeadNoAdjust

		  up:
		
		    mov eax,116
			mov dword ptr [ebx+20],eax
			mov eax,116
			mov dword ptr [ebx+24],eax
		
		   DeadNoAdjust:
           pop ecx
           add ebx,36
             dec ecx
			 jnz loopingAdjustment	;loop loopingAdjustment

 ret
 adjustzombie	ENDP

 enemybullet PROC,hdc:HDC,brush:HBRUSH,lp_bullets_array:DWORD
;--------------------------------------------------------------------------------
local rc:RECT
FNINIT
mov ebx,lp_bullets_array
mov ecx,50
 
loopingbull:
 pusha
mov eax,dword ptr [ebx]
cmp eax,-999
je next
  
movss xmm0, dword ptr [ebx]
movss xmm1, dword ptr [ebx+4]
addss xmm0,dword ptr [ebx+12]
movss dword ptr [ebx],xmm0
addss xmm1, dword ptr [ebx+8]
movss dword ptr [ebx+4],xmm1
 
cvtss2si eax,xmm0
mov BulletX,eax
mov rc.left,eax
add eax,Bullet_Width
mov rc.right,eax
cvtss2si eax,xmm1
mov BulletY,eax
mov rc.top,eax
add eax,Bullet_Height
mov rc.bottom,eax
 pusha
 
 ;invoke Ellipse,hdc,rc.left,rc.top,rc.right,rc.bottom

;invoke BUILDRECT,       BulletX,        BulletY,        Bullet_Width,Bullet_Height,hdc,brush
pusha
cmp two_Players,FALSE
je dont_check
cmp host,FALSE
je continueon
dont_check:
invoke Check_If_Bullet_Hit_And_Destroy_Zombie,BulletX,BulletY,Bullet_Width,Bullet_Height,offset zombies

cmp eax,1
jne continueon
popa
mov dword ptr [ebx],-999
pusha
continueon:
popa
invoke GetPixel,hdc,BulletX,BulletY
cmp eax, 0FFFFFFFFh
jne next
deadb:
mov dword ptr [ebx],-999
next:
popa
add ebx,40
dec ecx
jnz loopingbull;loop loopingbull
;================================================================================
ret
enemybullet ENDP

GetSinAndCos PROC,lp_sin:DWORD,lp_cos:DWORD,lp_minus_sin:DWORD,muled_sin:DWORD,muled_cos:DWORD
;--------------------------------------------------------------------------------
 movss xmm0,muled_sin
 divss xmm0,VEL
 mov edi,lp_sin
 movss dword ptr [edi],xmm0
 
 movss xmm0,muled_cos
 divss xmm0,VEL
 mov edi,lp_cos
 movss dword ptr [edi],xmm0


 movss xmm0,muled_sin
 divss xmm0,VEL
 mulss xmm0,Minus1
 mov edi,lp_minus_sin
 movss dword ptr [edi],xmm0
;================================================================================
ret
GetSinAndCos ENDP

bullet PROC,hdc:HDC,brush:HBRUSH,lp_bullets_array:DWORD,hWnd:HWND
;--------------------------------------------------------------------------------
local rc:RECT
local testrc:RECT
FNINIT
;invoke SetGraphicsMode,hdc,GM_ADVANCED
mov ebx,lp_bullets_array
mov ecx,48
 
loopingbull:
 pusha
mov eax,dword ptr [ebx]
cmp eax,-999
je next
  

 pusha
 
 pusha

  mov eax,Bullet_Height/2
 cvtsi2ss xmm4,eax
 addss xmm4,dword ptr [ebx+4];was adss

  ;xmm4 is y0
 mov eax,Bullet_Width/2
 cvtsi2ss xmm0,eax
 addss xmm0,dword ptr [ebx];was adss
 ;movss xmm0,ZeroPointZero
 ;xmm0 is x0
 movss xmm1,dword ptr [ebx+16]
 mulss xmm1,xmm0;xmm1=cos*x0
 movss xmm2,dword ptr [ebx+20]
 mulss xmm2,xmm4;xmm2=sin*y0
 movss xmm3,xmm0
 subss xmm3,xmm1
 addss xmm3,xmm2
 movss dword ptr [ebx+32],xmm3
 movss xmm1,dword ptr [ebx+16]
 mulss xmm1,xmm4;xmm1=cos*y0
 movss xmm2,dword ptr [ebx+20]
 mulss xmm2,xmm0;xmm2=sin*x0
 movss xmm3,xmm4
 subss xmm3,xmm1
 subss xmm3,xmm2
 movss dword ptr [ebx+36],xmm3
 
  movss xmm0, dword ptr [ebx]
movss xmm1, dword ptr [ebx+4]
addss xmm0,dword ptr [ebx+12];VEL IN X
movss dword ptr [ebx],xmm0
addss xmm1, dword ptr [ebx+8];VEL IN Y
movss dword ptr [ebx+4],xmm1
 
cvtss2si eax,xmm0
mov BulletX,eax
mov rc.left,eax
add eax,Bullet_Width
mov rc.right,eax
cvtss2si eax,xmm1
mov BulletY,eax
mov rc.top,eax
add eax,Bullet_Height
mov rc.bottom,eax
mov eax,ebx
add eax,16
 invoke SetWorldTransform,hdc,eax;WORKS GREAT--------------------------------------------
 
 
 ;invoke Ellipse,hdc,rc.left,rc.top,rc.right,rc.bottom
 invoke DrawImage_fast_WithMask,hdc,ArrowBMP,ArrowBMPMask,BulletX,BulletY,0,0,60,18
 ;invoke DrawImage,hdc,ArrowBMP,BulletX,BulletY,0,0,1591,153,Bullet_Width,Bullet_Height
  ;invoke DrawImage_WithMask,hdc,ArrowBMP,ArrowBMPMask,BulletX,BulletY,1591,153,0,0,Bullet_Width,Bullet_Height
 ;invoke DrawImage_WithMask,hdc,Rightz,RightzMask,BulletX,BulletY,30,40,0,0,Zombie_Width,Zombie_Height
 invoke SetWorldTransform,hdc,offset normal_xForm;WORKS GREAT--------------------------------------------  
 popa

pusha

invoke Check_If_Bullet_Hit_And_Destroy_Zombie,BulletX,BulletY,Bullet_Width,Bullet_Height,offset zombies

cmp eax,1
jne continueon
popa
mov dword ptr [ebx],-999
pusha
continueon:
popa
invoke GetPixel,hdc,BulletX,BulletY
cmp eax, 0FFFFFFFFh
jne next
deadb:
mov dword ptr [ebx],-999
next:
popa
add ebx,40
dec ecx
jnz loopingbull;loop loopingbull
;================================================================================
ret
bullet ENDP

Draw_Player_Health_Bar	PROC,x:DWORD,y:DWORD,hdc:HDC,brush:HBRUSH
;--------------------------------------------------------------------------------
;The Width Would Be 50 Pixels Long Because The Player's Life is 500

invoke SelectObject,hdc,brush
invoke SetDCBrushColor, hdc,   00000000FF00h
mov brush,eax

mov ebx,y
sub ebx,20;Testing
mov eax,Player_Life
mov ecx,10
xor edx,edx
idiv ecx
cmp Player_Life,500
jle NoShield
mov eax,50
NoShield:
mov ecx,x
sub ecx,10
pusha
invoke BUILDRECT,ecx,ebx,5,eax,hdc,brush
invoke SelectObject,hdc,brush
invoke SetDCBrushColor, hdc,   0000000000ffh
mov brush,eax
popa

add ecx,eax
mov edx,50
sub edx,eax
cmp Player_Life,500
jle NoShield2
pusha
invoke SelectObject,hdc,brush
invoke SetDCBrushColor, hdc,   000000ff0000h
mov brush,eax
popa
mov eax,Player_Life
sub eax,500
mov esi,10
xor edx,edx
idiv esi
mov edx,eax
add ebx,5
sub ecx,50
NoShield2:


invoke BUILDRECT,ecx,ebx,5,edx,hdc,brush


;================================================================================
ret
Draw_Player_Health_Bar ENDP


;Draw_Zombie_Health_Bar

Draw_Sprint_Bar	PROC,x:DWORD,y:DWORD,hdc:HDC,brush:HBRUSH
;--------------------------------------------------------------------------------
;The Width Would Be 50 Pixels Long Because The Player's Life is 500

invoke SelectObject,hdc,brush
invoke SetDCBrushColor, hdc,   000000ff00ffh
mov brush,eax

mov ebx,y
sub ebx,10;Testing
mov eax,sprintmeter
mov ecx,10
xor edx,edx
idiv ecx
;cmp Player_Life,500
;jle NoShield
;mov eax,50
NoShield:
mov ecx,x
sub ecx,10
;pusha
invoke BUILDRECT,ecx,ebx,5,eax,hdc,brush
;invoke SelectObject,hdc,brush
;invoke SetDCBrushColor, hdc,   0000000000ffh
;mov brush,eax
;popa

;add ecx,eax
;mov edx,50
;sub edx,eax
;cmp Player_Life,500
;jle NoShield2
;pusha
;invoke SelectObject,hdc,brush
;invoke SetDCBrushColor, hdc,   000000ff0000h
;mov brush,eax
;popa
;mov eax,Player_Life
;sub eax,500
;mov esi,10
;xor edx,edx
;idiv esi
;mov edx,eax
;add ebx,5
;sub ecx,50
;NoShield2:


;invoke BUILDRECT,ecx,ebx,5,edx,hdc,brush


;================================================================================
ret
Draw_Sprint_Bar ENDP

 createbullet PROC
 ;--------------------------------------------------------------------------------
		local pt:POINT 
			FNINIT
            invoke GetCursorPos,addr pt
			
			 mov esi, offset buffer
           ;=====================DELTA X=================================
           mov ecx,pt.x
           sub ecx,ShootX
          
           sub ecx,WINPLACE.rcNormalPosition.left
           sub ecx,40
           cvtsi2ss xmm2,ecx
           movss dword ptr [esi],xmm2
           ;-------------------------------------------------------------
           ;=====================DELTA Y=================================
           mov eax,pt.y
           sub eax,ShootY
           
           sub eax,WINPLACE.rcNormalPosition.top
           sub eax,40
           cvtsi2ss xmm3,eax
           movss dword ptr [esi+8],xmm3
           ;-------------------------------------------------------------
 
         
            FLD dword ptr [esi+8]

           FLD dword ptr [esi]
		     
         
 
           FPATAN
           FSINCOS
		   FMUL VEL
           FSTP qword ptr [esi];VEL IN X
           CVTSD2SS xmm0,qword ptr [esi]
           movss dword ptr [ebx+12],xmm0
		 
           FMUL VEL
           FSTP qword ptr [esi];VEL IN Y
           CVTSD2SS xmm0,qword ptr [esi]
           movss dword ptr [ebx+8],xmm0
              
			  

           cvtsi2ss xmm0,ShootX
           movss dword ptr [ebx],xmm0
           cvtsi2ss xmm1,ShootY
           movss dword ptr [ebx+4],xmm1

		   
 invoke GetSinAndCos,offset sin_angle_world,offset cos_angle_world,offset minus_sin_angle_world,dword ptr [ebx+8],dword ptr [ebx+12]
 movss xmm0,cos_angle_world
 movss dword ptr [ebx+16],xmm0
 movss xmm0,sin_angle_world
 movss dword ptr [ebx+20],xmm0
 movss xmm0,minus_sin_angle_world
 movss dword ptr [ebx+24],xmm0
 movss xmm0,cos_angle_world
 movss dword ptr [ebx+28],xmm0


 

 
	;invoke mciSendString ,offset playshootsound,NULL,0,NULL
	;invoke waveOutSetVolume, NULL , volume;	Special Thanks To Tal Bortman
    ;invoke PlaySound, offset SoundPath, NULL,SND_ASYNC;	Special Thanks To Tal Bortman
;================================================================================
 ret
 createbullet ENDP
 
 GetPlayerAngleAndFix	PROC,hWnd:HWND
 ;--------------------------------------------------------------------------------
 	local pt:POINT 
		FNINIT
        invoke GetWindowPlacement,hWnd,OFFSET WINPLACE
            invoke GetCursorPos,addr pt
			
			 mov esi, offset buffer
           ;=====================DELTA X=================================
           mov ecx,pt.x
           sub ecx,ShootX
           mov edx,WINPLACE.rcNormalPosition.left
           sub ecx,edx
           sub ecx,40
           cvtsi2ss xmm2,ecx
           movss dword ptr [esi],xmm2
           ;-------------------------------------------------------------
           ;=====================DELTA Y=================================
           mov eax,pt.y
           sub eax,ShootY
           mov edx,WINPLACE.rcNormalPosition.top
           sub eax,edx
           sub eax,40
           cvtsi2ss xmm3,eax
           movss dword ptr [esi+8],xmm3
           ;-------------------------------------------------------------
 
         
            FLD dword ptr [esi+8]
         
           FLD dword ptr [esi]
           FPATAN
		    mov edi,offset anglePlayer
		   FST qword ptr [edi]
		   cvtsd2ss xmm0,qword ptr [edi]
		   movss realanglePlayer,xmm0
		   cvtss2si eax,xmm0
		   mov realanglePlayer,eax
		   
		   mov eax,realanglePlayer
		
		
		 
		   cmp eax,-0;0
		   je right

		   cmp eax,-1;1
		   je up

		   cmp eax,-2
		   je up

		   cmp eax,-3
		   je left

		   cmp eax,-4
		   je left

	
		   cmp eax,0;0
		   je right

		   cmp eax,1;1
		   je down

		   cmp eax,2
		   je down

		   cmp eax,3
		   je left

		   cmp eax,4
		   je left


		   right:
		   mov Player.CURRENTFACING,385
		   jmp endGetPlayerAngleAndFix
		   left:
		   mov Player.CURRENTFACING,130
		   jmp endGetPlayerAngleAndFix
		   down:
		   mov Player.CURRENTFACING,260
		   jmp endGetPlayerAngleAndFix
		   up:
		   mov Player.CURRENTFACING,0
		   endGetPlayerAngleAndFix:
		   
 ;================================================================================
 ret
 GetPlayerAngleAndFix	ENDP

ProjectWndProc  PROC,   hWnd:HWND, message:UINT, wParam:WPARAM, lParam:LPARAM
        local paint:PAINTSTRUCT
        local hdc:HDC
        local brushcolouring:HBRUSH
                local brushcolouring2:HBRUSH
            local hdcMem:HDC
                local hbmOld:HBITMAP
                local bm:BITMAP
                local rectforpic:RECT   
               local hdcBuffer:HDC
				local hbmBuffer:HBITMAP
				local hOldBuffer:HBITMAP
				local testrc:RECT
        cmp     message,        WM_PAINT
        je      painting
		cmp message,	WM_RBUTTONDOWN
		je pushing
        cmp message,    WM_CLOSE
        je      closing     
        cmp message,    WM_TIMER
        je      timing
		cmp message,WM_ERASEBKGND
		je returnnonzero
		cmp message, WM_SOCKET
		je handlesocket
        cmp message,	WM_CREATE
		je create     
        jmp OtherInstances
       
	   returnnonzero:
	   mov eax,1
	   ret

	   handlesocket:
	   mov eax,lParam 
        .if ax==FD_CONNECT            ; the low word of lParam contains the event code. 
            shr eax,16                              ; the error code (if any) is in the high word of lParam 
            .if ax==NULL 
                ;<no error occurs so proceed> 
            .else 
					invoke ExitProcess, 1
            .endif 
        .elseif    ax==FD_READ 
            shr eax,16 
            .if ax==NULL 
				 invoke ioctlsocket, sock, FIONREAD, addr available_data 
				 .if eax==NULL 				    
					invoke recvfrom, sock, offset buffer_for_sock, 1024, 0,NULL,NULL
					;invoke MessageBox, hWnd,offset irecievedsomething,offset irecievedsomething,MB_OK
					.if connected_to_friend == TRUE
					invoke crt_strcmp,offset buffer_for_sock,offset you_are_host
					cmp eax,0
					je you_are_the_host2

					invoke crt_strcmp,offset buffer_for_sock,offset not_two_players
					cmp eax,0
					jne two_players_yes
					mov connected_to_friend,FALSE
					mov two_Players,FALSE
					jmp endofrecieve
					two_players_yes:
						mov ebx, offset buffer_for_sock
						cmp byte ptr [ebx],0
						jne norecieveplayer

						inc ebx
						mov eax, [ebx]
						mov Player2.x, eax

						add ebx, 4
						mov eax, [ebx]		
						mov Player2.y, eax

						add ebx, 4
						mov eax, [ebx]		
						mov Player2.CURRENTFACING, eax
						
						add ebx, 4
						mov eax, [ebx]		
						mov Player2.CURRENTSTEP, eax
						
						add ebx, 4
						mov eax, [ebx]
						mov Player2.CURRENTACTION, eax
						
						add ebx, 4
						mov eax, [ebx]		
						mov Player2.CURRENTACTIONMASK, eax
						
						add ebx,4
						push ebx
						invoke RtlMoveMemory,offset enemybullets,ebx,24*40
						pop ebx
						add ebx,24*40
						cmp host,TRUE
						je dont_recieve_player2_life_and_score
						
					
						mov eax,[ebx]
						mov scoreNum,eax
						add ebx,4
						
						mov eax,[ebx]
						mov Money,eax
						add ebx,4

						mov eax,dword ptr [ebx]
						add Player_Life,eax
						add ebx,4
						dont_recieve_player2_life_and_score:
						jmp endofrecieve
						
						norecieveplayer:
						
						
						cmp byte ptr [ebx],1
						jne norecievebullets
						
						;cmp host,TRUE
						;je no_need_to_check_if_recieved_bullets
						;invoke MessageBox,0,offset recievingbullets,offset recievingbullets,MB_OK 
						;no_need_to_check_if_recieved_bullets:
								

						inc ebx
						mov esi,offset enemybullets
						add esi,24*40
						invoke RtlMoveMemory ,esi,ebx,24*40

						jmp endofrecieve

						norecievebullets:

						cmp host,TRUE
						je norecievezombies
						cmp byte ptr [ebx],2
						jne norecievezombies
						;invoke MessageBox, hWnd,offset recievingzombies,offset recievingzombies,MB_OK
						inc ebx
						invoke RtlMoveMemory,offset zombies,ebx,25*36
						jmp endofrecieve
						norecievezombies:


						cmp host,TRUE
						je norecievezombies2
						cmp byte ptr [ebx],3
						jne norecievezombies2
						;invoke MessageBox, hWnd,offset recievingxy,offset recievingxy,MB_OK
						inc ebx
						mov esi,offset zombies
						add esi,25*36
						invoke RtlMoveMemory,esi,ebx,25*36
						jmp endofrecieve
						norecievezombies2:

						cmp host,TRUE
						je norecievecoins
						cmp byte ptr [ebx],4
						jne norecievecoins

						inc ebx
						invoke RtlMoveMemory,offset coins,ebx,50*12
						add ebx,50*12
						invoke RtlMoveMemory,offset Packs,ebx,10*16
						jmp endofrecieve
						norecievecoins:

						endofrecieve:
						ret
					.endif
					

					invoke crt_strcmp, offset buffer_for_sock, offset doyouwanttoconnect
					cmp eax, 0
					je sendyes

					invoke crt_strcmp, offset buffer_for_sock, offset get_ready_for_ip
					cmp eax, 0
					je getreadyforip

					invoke crt_strcmp,offset buffer_for_sock,offset you_are_host
					cmp eax,0
					je you_are_the_host

					;invoke crt_strcmp,offset buffer_for_sock,offset you_are_not_host
					;cmp eax,0
					;je you_are_not_the_host


					.if expecting_PORT == TRUE
				     invoke crt_atoi, offset buffer_for_sock
					 mov clientport, eax
					 mov expecting_PORT, FALSE

					 
					 mov clientsin.sin_family, AF_INET 
					 invoke htons, clientport                    ; convert port number into network byte order first 
					 mov clientsin.sin_port,ax                  ; note that this member is a word-size param. 
			     	 invoke inet_addr, addr clientip    ; convert the IP address into network byte order 
			 		 mov clientsin.sin_addr,eax 
					 

					 invoke CreateThread, NULL, NULL, offset sendlocation,offset clientsin, NULL, NULL
					 mov connected_to_friend, TRUE
					 mov two_Players,TRUE
					 invoke Restart,hWnd
					 mov STATUS,1
					 ;invoke MessageBox, hWnd,offset connectedtopeer,offset connectedtopeer,MB_OK
					.endif


					.if expecting_IP == TRUE
						;invoke crt_strcmp,offset buffer_for_sock,offset you_are_host
					;cmp eax,0
					;je you_are_the_host
					
						 invoke crt_strcpy, offset clientip, offset buffer_for_sock
						 mov textoffset, offset clientip
						 mov expecting_PORT, TRUE
						 mov expecting_IP, FALSE
					.endif	
					COMMENT @				
						mov ebx, offset buffer_for_sock
						mov eax, [ebx]
						mov Player2.x, eax
			
						add ebx, 4
						mov eax, [ebx]		
						mov Player2.y, eax

						add ebx, 4
						mov eax, [ebx]		
						mov Player2.CURRENTFACING, eax
						
						add ebx, 4
						mov eax, [ebx]		
						mov Player2.CURRENTSTEP, eax
						
						add ebx, 4
						mov eax, [ebx]
						mov Player2.CURRENTACTION, eax
						
						add ebx, 4
						mov eax, [ebx]		
						mov Player2.CURRENTACTIONMASK, eax
						@
				.endif
                ;<no error occurs so proceed> 
            .else 
				invoke ExitProcess, 1
            .endif 
        .elseif   ax==FD_CLOSE 
            shr eax,16 
            .if ax==NULL 
                ;<no error occurs so proceed> 
            .else 
				invoke ExitProcess, 1
            .endif 
        .endif 
		ret


		getreadyforip:
		mov expecting_IP, TRUE
		;invoke MessageBox, 0,offset expectingip,offset expectingip,MB_OK
 
		ret


		sendyes:
		invoke crt_strlen, offset yesiamsure
		invoke sendto,sock, offset yesiamsure, eax, 0, offset sin, sizeof sin
		mov expecting_IP, TRUE
		;invoke MessageBox, hWnd,offset captionyesiwanttoconnect,offset captionyesiwanttoconnect,MB_OK
		ret
		
		you_are_the_host:
		mov host,TRUE
		cmp two_Players,TRUE
		je nosetx
		mov Player.x,600
		nosetx:
		invoke MessageBox, 0,offset iamhost,offset iamhost,MB_OK
		ret

		you_are_the_host2:
		mov host,TRUE
		mov two_Players,FALSE
		ret
		you_are_not_the_host:
		mov host,FALSE
		;invoke MessageBox, hWnd,offset iamnothost,offset iamnothost,MB_OK
		ret

	   pushing:
	   invoke Push_Zombies, Player.x,Player.y,RECT_WIDTH,RECT_HEIGHT
	   ret

       create:
	   movss xmm0,cos_angle_world
 movss xForm.eM11,xmm0
 movss xmm0,sin_angle_world
 movss xForm.eM12,xmm0
 movss xmm0,minus_sin_angle_world
 movss xForm.eM21,xmm0
 movss xmm0,cos_angle_world
 movss xForm.eM22,xmm0
 movss xmm0,ZeroPointZero
 movss xForm.ex,xmm0
 movss xmm0,ZeroPointZero
 movss xForm.ey,xmm0

 movss xmm0,OnePointZero
 movss normal_xForm.eM11,xmm0
 movss xmm0,ZeroPointZero
 movss normal_xForm.eM12,xmm0
movss xmm0,ZeroPointZero
 movss normal_xForm.eM21,xmm0
movss xmm0,OnePointZero
 movss normal_xForm.eM22,xmm0
 movss xmm0,ZeroPointZero
 movss normal_xForm.ex,xmm0
 movss xmm0,ZeroPointZero
 movss normal_xForm.ey,xmm0


	   mov offsetToEndofArray,LengthofLeaf
	   invoke CreateFont,56,50,180,90,FW_BOLD,FALSE,FALSE,FALSE,ANSI_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,ANTIALIASED_QUALITY,DEFAULT_PITCH or FF_DECORATIVE,NULL
	   mov MyFont,eax
	   invoke GetModuleHandle,NULL
       invoke LoadBitmap,eax,101
       mov zombiebr,eax

	   invoke GetModuleHandle,NULL
	   invoke LoadBitmap,eax,117
	   mov hWalk,eax

	   invoke Get_Handle_To_Mask_Bitmap,	hWalk,	00ffffffh
	   mov hWalkMask,eax

	   invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,121
		mov WaitingScreenBMP,eax

		invoke Get_Handle_To_Mask_Bitmap,	WaitingScreenBMP,	00ffffffh
		mov WaitingScreenBMPMask,eax
		
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,120
		mov Online,eax

		invoke Get_Handle_To_Mask_Bitmap,	Online,	00ffffffh
		mov OnlineMask,eax
		
		 invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,122
		mov ArrowBMP,eax

		invoke Get_Handle_To_Mask_Bitmap,	ArrowBMP,	00ffffffh
		mov ArrowBMPMask,eax
		

		mov eax,hWalk
		mov Player.CURRENTACTION,eax
		mov eax,hWalkMask
		mov Player.CURRENTACTIONMASK,eax

		invoke GetTickCount
		mov Player.TimeStepShouldDisappear,eax
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,102
		mov hCoinColour,eax

		invoke Get_Handle_To_Mask_Bitmap,	hCoinColour,	00ffffffh
		mov hCoinMask,eax

		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,103
		mov hHealthPackColour,eax

		
		invoke Get_Handle_To_Mask_Bitmap,	hHealthPackColour,	00ffffffh
		mov hHealthPackMask,eax

		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,104
        mov NewGame,eax

		invoke Get_Handle_To_Mask_Bitmap,	NewGame,	00ffffffh
		mov NewGameMasked,eax

		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,125
        mov Vectors,eax

		invoke Get_Handle_To_Mask_Bitmap,	Vectors,	00ffffffh
		mov VectorsMask,eax

		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,131
        mov Volume,eax

		invoke Get_Handle_To_Mask_Bitmap,	Volume,	00ffffffh
		mov VolumeMask,eax


		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,132
        mov VolumeBar,eax

		invoke Get_Handle_To_Mask_Bitmap,	VolumeBar,	00ffffffh
		mov VolumeBarMask,eax


			 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,133
        mov Circle,eax

		invoke Get_Handle_To_Mask_Bitmap,	Circle,	00ffffffh
		mov CircleMask,eax


		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,124
        mov Rotation,eax

		invoke Get_Handle_To_Mask_Bitmap,	Rotation,	00ffffffh
		mov RotationMask,eax

		invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,123
        mov OnlineF,eax

		invoke Get_Handle_To_Mask_Bitmap,	OnlineF,	00ffffffh
		mov OnlineFMask,eax

		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,105
        mov Options,eax

		invoke Get_Handle_To_Mask_Bitmap,	Options,	00ffffffh
		mov OptionsMasked,eax

		
		; invoke GetModuleHandle,NULL
        ;invoke LoadBitmap,eax,106
        ;mov HighScores,eax

		;invoke Get_Handle_To_Mask_Bitmap,	HighScores,	00ffffffh
		;mov HighScoresMasked,eax

		
		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,118
        mov OptionScreenhbitmap,eax

		
		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,127
        mov MechanicsS,eax

		invoke Get_Handle_To_Mask_Bitmap,	MechanicsS,	00ffffffh
		mov MechanicsSMask,eax


		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,126
        mov MechanicsP,eax

		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,128
        mov VectorsP,eax


		
		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,129
        mov RotationP,eax


		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,130
        mov OnlineP,eax

		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,107
        mov Exiting,eax

		invoke Get_Handle_To_Mask_Bitmap,	Exiting,	00ffffffh
		mov ExitingMasked,eax

		
		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,108
        mov StartScreenBK,eax

		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,109
        mov HighlightBIT,eax
		invoke Get_Handle_To_Mask_Bitmap,	HighlightBIT,	00ffffffh
		mov HighlightBITMasked,eax

		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,110
        mov StoreBK,eax

		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,111
        mov cost,eax
		invoke Get_Handle_To_Mask_Bitmap,	cost,	00ffffffh
		mov costMasked,eax

		
		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,112
        mov score,eax
		invoke Get_Handle_To_Mask_Bitmap,	score,	00ffffffh
		mov scoreMasked,eax

		invoke GetModuleHandle,NULL
			invoke LoadBitmap,eax,114
			mov Rightz,eax
			invoke Get_Handle_To_Mask_Bitmap,	Rightz,	00ffffffh
		mov RightzMask,eax


		invoke GetModuleHandle,NULL
			invoke LoadBitmap,eax,113
			mov Frontz,eax
				invoke Get_Handle_To_Mask_Bitmap,	Frontz,	00ffffffh
		mov FrontzMask,eax


		 invoke GetModuleHandle,NULL
			invoke LoadBitmap,eax,115
			mov Leftz,eax
				invoke Get_Handle_To_Mask_Bitmap,	Leftz,	00ffffffh
		mov LeftzMask,eax

		 invoke GetModuleHandle,NULL
			invoke LoadBitmap,eax,116
			mov Backz,eax
				invoke Get_Handle_To_Mask_Bitmap,	Backz,	00ffffffh
		mov BackzMask,eax

		 invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,134
		mov Paused,eax
		
		 invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,135
		mov Resume,eax
		invoke Get_Handle_To_Mask_Bitmap,	Resume,	00ffffffh
		mov ResumeMask,eax

		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,136
		mov OptionsPaused,eax
		invoke Get_Handle_To_Mask_Bitmap,	OptionsPaused,	00ffffffh
		mov OptionsPausedMask,eax

		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,137
		mov MainMenu,eax
		invoke Get_Handle_To_Mask_Bitmap,	MainMenu,	00ffffffh
		mov MainMenuMask,eax


		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,138
		mov YouLost,eax


		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,139
		mov NewGameDead,eax

		invoke Get_Handle_To_Mask_Bitmap,	NewGameDead,	00ffffffh
		mov NewGameDeadMask,eax

		
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,140
		mov h25hp,eax

		invoke Get_Handle_To_Mask_Bitmap,	h25hp,	00ffffffh
		mov h25hpMask,eax

		
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,141
		mov h75hp,eax

		invoke Get_Handle_To_Mask_Bitmap,	h75hp,	00ffffffh
		mov h75hpMask,eax
		
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,142
		mov h150hp,eax

		invoke Get_Handle_To_Mask_Bitmap,	h150hp,	00ffffffh
		mov h150hpMask,eax
		
						
        invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,143
		mov h30d,eax

		invoke Get_Handle_To_Mask_Bitmap,	h30d,	00ffffffh
		mov h30dMask,eax

		
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,144
		mov h80d,eax

		invoke Get_Handle_To_Mask_Bitmap,	h80d,	00ffffffh
		mov h80dMask,eax
		
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,145
		mov h150d,eax

		invoke Get_Handle_To_Mask_Bitmap,	h150d,	00ffffffh
		mov h150dMask,eax


		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,146
		mov NextWave,eax

		invoke Get_Handle_To_Mask_Bitmap,	NextWave,	00ffffffh
		mov NextWaveMask,eax



        invoke LoadCursor,NULL,IDC_CROSS
        mov icursor,eax
		
		xor eax,eax
		mov ax,0ffffh
		xor ebx,ebx
		mov bx,((WINDOW_WIDTH*4)/5)-50+50
		xor edx,edx
		idiv bx
		mov ebx,CircleX
		sub ebx,50
		xor edx,edx
		imul bx
		mov edi,offset volume
		mov word ptr [edi],ax
		mov word ptr [edi+2],ax
		invoke waveOutSetVolume,NULL,volume


	   ret
       
        closing:
	
		invoke CloseProcess	
 
 
        painting:
				
				invoke 	mciSendString,offset playbk,NULL,0,NULL
		        invoke  BeginPaint,     hWnd,   addr paint
				mov hdc, eax
				invoke SetGraphicsMode,hdc,GM_ADVANCED
				invoke CreateCompatibleDC,hdc
				mov hdcBuffer,eax
				invoke CreateCompatibleBitmap,hdc,WINDOW_WIDTH,WINDOW_HEIGHT
				mov hbmBuffer,eax
				invoke SelectObject,hdcBuffer,hbmBuffer
				mov hOldBuffer,eax
				invoke SetGraphicsMode,hdcBuffer,GM_ADVANCED
				invoke SetCursor,icursor
				cmp STATUS,0
				jne noStart
				invoke StartScreen,hdcBuffer,hWnd
				jmp endingofpainting
				noStart:

				cmp STATUS,2
				jne noStore
				invoke DrawStore,hdcBuffer,hWnd
				jmp endingofpainting
				ret
				noStore:
				
				cmp STATUS,3
				jne noOptions
				invoke OptionsScreen,hdcBuffer
				jmp endingofpainting
				noOptions:
				
				cmp STATUS,4
				jne noWaitingForOtherPlayer
				invoke WaitingScreen,hdcBuffer
				jmp endingofpainting
				noWaitingForOtherPlayer:

				cmp STATUS,5
				jne noMechanicsScreen
				invoke MechanicsScreen,hdcBuffer,hWnd
				jmp endingofpainting
				noMechanicsScreen:

				cmp STATUS,6
				jne noPauseScreen
				invoke PauseScreen,hdcBuffer,hWnd
				jmp endingofpainting
				noPauseScreen:


				cmp STATUS,7
				jne nodeath
				invoke YouLostScreen,hdcBuffer,hWnd
				jmp endingofpainting
				nodeath:
				invoke GetAsyncKeyState,VK_ESCAPE
				shr eax,15
				cmp eax,0
				je no_move_to_pause
				mov SAVESTATUS,1
				mov STATUS,6
				no_move_to_pause:
                cmp RECT_WIDTH,RECT_WIDTH_BACKUP
                je iflat
                mov eax,RECT_HEIGHT_BACKUP/2
                add eax,Player.x
                mov ShootX,eax
                mov eax,RECT_WIDTH_BACKUP/2
                add eax,Player.y
                mov ShootY,eax
                jmp fin
                iflat:
                mov eax,RECT_WIDTH_BACKUP/2
                add eax,Player.x
                mov ShootX,eax
                mov eax,RECT_HEIGHT_BACKUP/2
                add eax,Player.y
                mov ShootY,eax
                fin:
				
				
				;invoke SetWorldTransform,hdcBuffer,offset xForm;WORKS GREAT--------------------------------------------
				;invoke SetWorldTransform,hdcBuffer,offset xForm
				invoke DrawImage,hdcBuffer,zombiebr,0,0,0,0, 1504,910 ,WINDOW_WIDTH,WINDOW_HEIGHT
				;invoke SetWorldTransform,hdcBuffer;WORKS GREAT--------------------------------------------
				invoke GetPlayerAngleAndFix,hWnd
				
				invoke GetStockObject,  DC_BRUSH
        mov brushcolouring, eax
               
                invoke SelectObject, hdcBuffer,brushcolouring
				
        invoke SetDCBrushColor, hdcBuffer,   00000000aaffh
        mov brushcolouring, eax

				mov ebx,offset DistanceMap
				mov eax,0
				mov edx,0
				mov ecx,((WINDOW_WIDTH/4)*(WINDOW_HEIGHT/4))
				loopingdrawing:
				add eax,4
				cmp eax,WINDOW_WIDTH
				jl dontreset
				add edx,4
				mov eax,0
				dontreset:
				cmp dword ptr [ebx],2147483647
				jne next
				pusha
				invoke BUILDRECT,eax,edx,8,8,hdcBuffer,brushcolouring
				popa
				next:
				add ebx,4

				loop loopingdrawing


				;DrawImage_WithMask PROC, hdc:HDC, img:HBITMAP, maskedimg:HBITMAP,  x:DWORD, y:DWORD,w:DWORD,h:DWORD,x2:DWORD,y2:DWORD,wstrech:DWORD,hstrech:DWORD
				invoke DrawImage_WithMask,hdcBuffer, Player.CURRENTACTION,  Player.CURRENTACTIONMASK,Player.x,Player.y,75,105,Player.CURRENTSTEP,Player.CURRENTFACING,RECT_WIDTH,RECT_HEIGHT
				;do cmp two players
				;make a function that gets a code for an img and returns the hbitmap for that image #for drawing the second player in, you can't send hbitmaps because they are loaded differently in each run of the program
				cmp two_Players,FALSE
				je dontdrawplayer2
				invoke DrawImage_WithMask,hdcBuffer, Player.CURRENTACTION,  Player.CURRENTACTIONMASK,Player2.x,Player2.y,75,105,Player2.CURRENTSTEP,Player2.CURRENTFACING,RECT_WIDTH,RECT_HEIGHT
				dontdrawplayer2:
				invoke DrawScore,hdcBuffer
				invoke GetStockObject,  DC_BRUSH
        mov brushcolouring, eax
               
                invoke SelectObject, hdcBuffer,brushcolouring
				
        invoke SetDCBrushColor, hdcBuffer,   0000000000FFh
        mov brushcolouring, eax
			;invoke BUILDRECT,EnemyX,EnemyY,30,30,hdcBuffer,brushcolouring
				COMMENT @
                  invoke GetStockObject,  DC_BRUSH
        mov brushcolouring, eax
               
                invoke SelectObject, hdcBuffer,brushcolouring
				
        invoke SetDCBrushColor, hdcBuffer,   0000000000FFh
        mov brushcolouring, eax
		
        invoke BUILDRECT, hdc, Player.CURRENTACTION,  Player.CURRENTACTIONMASK,  RECT_WIDTH,     hdcBuffer,  brushcolouring
				@

                invoke GetStockObject,  DC_BRUSH
        mov brushcolouring, eax
		invoke SelectObject, hdcBuffer,brushcolouring
                invoke SetDCBrushColor, hdcBuffer, 000000F0870Fh
                mov brushcolouring,eax
                
                invoke bullet,hdcBuffer,brushcolouring,offset bullets,hWnd;MAYBE REMOVE
				invoke SetDCBrushColor,hdcBuffer,0000000F87FFh
				invoke bullet,hdcBuffer,brushcolouring,offset enemybullets,hWnd;MAYBE REMVOE
               invoke SetWorldTransform,hdcBuffer,offset normal_xForm
			    
               
                invoke GetStockObject,  DC_BRUSH
        mov brushcolouring, eax
                invoke SetDCBrushColor, hdcBuffer, 0077ff00h
                mov brushcolouring,eax
				;cmp host,TRUE
				;je noadvance
				;invoke AdvanceZombie_and_CheckIfDead,hWnd
				;noadvance:
                invoke DrawZombie,hdcBuffer,brushcolouring,hWnd
				invoke DrawCoin,hdcBuffer,brushcolouring
				invoke Draw_Packs,hdcBuffer
				invoke Draw_Player_Health_Bar,Player.x,Player.y,hdcBuffer,brushcolouring
	
				invoke Draw_Sprint_Bar,Player.x,Player.y,hdcBuffer,brushcolouring
				endingofpainting:
				invoke BitBlt,hdc,0,0,WINDOW_WIDTH,WINDOW_HEIGHT,hdcBuffer,0,0,SRCCOPY
	invoke SelectObject,hdcBuffer,hOldBuffer
	invoke DeleteObject,hbmBuffer
	invoke DeleteDC,hdcBuffer
	invoke crt_strlen, textoffset
				invoke TextOut, hdc, 0,0,textoffset,eax
 
        invoke EndPaint, hWnd,  addr paint
		cmp STATUS,1
		jne realend
		cmp Player_Life,0       
		jle endgame
		cmp two_Players,FALSE
		je needtocheck
		cmp host,FALSE
		je noneedtocheck
		
		
		invoke Check_If_Player_Hit_Coin_Add_Money_And_Remove_Coin,Player2.x,Player2.y,offset MoneyToAdd
		invoke Check_If_Player_Hit_Pack_And_Remove_Pack,Player2.x,Player2.y,offset player2_health_to_add
		needtocheck:
		invoke Check_If_Player_Hit_Coin_Add_Money_And_Remove_Coin,Player.x,Player.y,offset Money
		invoke Check_If_Player_Hit_Pack_And_Remove_Pack,Player.x,Player.y,offset Player_Life
		noneedtocheck:

		invoke Check_If_Player_Hit_And_Remove_Life,Player.x,Player.y,RECT_WIDTH,RECT_HEIGHT
		cmp Found,1
		je endmovement
		
		
	
        invoke GetAsyncKeyState,41h;A Key
		
        cmp eax, 0
        jne moveleft
        invoke GetAsyncKeyState,44h;D Key
		
        cmp eax, 0
        jne moveright
        jumpingcheck:
        cmp jmpingUp, 1
        je jmpUp
        cmp jmpingDown, 1
        je jmpDown
        invoke GetAsyncKeyState, VK_SPACE
		shr eax,15
        cmp eax, 0
        jne startjmp
        checkupdown:
        invoke GetAsyncKeyState, 57h ;W Key
		
        cmp eax, 0
        jne moveup
        invoke GetAsyncKeyState, 53h;S Key
		
        cmp eax, 0
        jne movedown
       
        jmp endmovement
        startjmp:        
        mov jmpingUp, 1        
                mov eax, Player.y
        mov StartY, eax
                sub eax, JMP_HEIGHT
                mov dstY, eax
        jmp endmovement
                hello:
                dec PlayerX2
                jmp jumpingcheck
jmpUp:
    mov ecx, dstY
    cmp Player.y, ecx
    jng startJmpingDown
    cmp Player.y, 5
    jng startJmpingDown
    mov eax, Player.y
    sub eax, JMP_SPEED
    mov Player.y, eax
    jmp endmovement
startJmpingDown:
    mov jmpingUp, 0
    mov jmpingDown, 1
    jmp endmovement
jmpDown:
        mov ecx, StartY
    cmp Player.y, ecx
    jnl stopJmping
   mov eax, Player.y
    add eax, JMP_SPEED
    mov Player.y, eax
    jmp endmovement
stopJmping:
    mov jmpingDown, 0
    jmp endmovement
   
moveleft:
		
		mov eax,Player.x
		sub eax,Player.speed
		shr eax,2
		mov ebx,Player.y
		shr ebx,2
		invoke getValue,eax,ebx,offset DistanceMap
		cmp eax,2147483647
		je jumpingcheck




        invoke GetAsyncKeyState,VK_LSHIFT
	    
		cmp eax,0
        je noSprint
		mov Player.speed,8
		sub sprintmeter,10
		cmp sprintmeter,0
		jle NoSprint1
		jmp noSprint
		NoSprint1:
		mov sprintmeter,0
		mov Player.speed,6
		noSprint:
    ;mov RECT_HEIGHT, RECT_HEIGHT_BACKUP
    ;mov RECT_WIDTH, RECT_WIDTH_BACKUP
		
        mov eax, Player.speed
        sub Player.x, eax
		invoke GetTickCount
		cmp Player.TimeStepShouldDisappear,eax
		jg DontChangeToNext1
		cmp Player.CURRENTSTEP,1000
		jl NoMax1
		mov Player.CURRENTSTEP,0
		invoke GetTickCount
		add eax,Player.Time_Between_Steps_P
		mov Player.TimeStepShouldDisappear,eax
		jmp DontChangeToNext1
		NoMax1:
		add Player.CURRENTSTEP,127
		invoke GetTickCount
		add eax,Player.Time_Between_Steps_P
		mov Player.TimeStepShouldDisappear,eax
		DontChangeToNext1:
        jmp jumpingcheck
moveright:
		

		mov eax,Player.x
		add eax,Player.speed
		add eax,RECT_WIDTH
		shr eax,2
		mov ebx,Player.y
		shr ebx,2
		invoke getValue,eax,ebx,offset DistanceMap
		cmp eax,2147483647
		je jumpingcheck


        invoke GetAsyncKeyState,VK_LSHIFT;A Key
		
		cmp eax,0
        je noSprint1
		mov Player.speed,8
		sub sprintmeter,10
		cmp sprintmeter,0
		jle NoSprint2
		jmp noSprint1
		NoSprint2:
		mov sprintmeter,0
		mov Player.speed,6
		noSprint1:
		;mov RECT_HEIGHT, RECT_HEIGHT_BACKUP
		;mov RECT_WIDTH, RECT_WIDTH_BACKUP
        mov eax, Player.speed
        add Player.x, eax
		invoke GetTickCount
		cmp Player.TimeStepShouldDisappear,eax
		jg DontChangeToNext2
		cmp Player.CURRENTSTEP,1000
		jl NoMax2
		mov Player.CURRENTSTEP,0
		invoke GetTickCount
		add eax,Player.Time_Between_Steps_P
		mov Player.TimeStepShouldDisappear,eax
		jmp DontChangeToNext2
		NoMax2:
		add Player.CURRENTSTEP,127
		invoke GetTickCount
		add eax,Player.Time_Between_Steps_P
		mov Player.TimeStepShouldDisappear,eax
		DontChangeToNext2:
        jmp jumpingcheck
movedown:
		
        cmp jmpingUp, 1
        je endmovement
        cmp jmpingDown, 1
        je endmovement

	
		mov eax,Player.y
		add eax,Player.speed
		add eax,RECT_HEIGHT
		shr eax,2
		mov ebx,Player.x
		shr ebx,2
		invoke getValue,ebx,eax,offset DistanceMap
		cmp eax,2147483647
		je endmovement

		



		invoke GetAsyncKeyState,VK_LSHIFT;A Key
		
		cmp eax,0
        je noSprint2
		mov Player.speed,8
		sub sprintmeter,10
		cmp sprintmeter,0
		jle NoSprint3
		jmp noSprint2
		NoSprint3:
		mov sprintmeter,0
		mov Player.speed,6
		noSprint2:
    ;mov RECT_HEIGHT, RECT_WIDTH_BACKUP
    ;mov RECT_WIDTH, RECT_HEIGHT_BACKUP
    mov eax, Player.speed
    add Player.y,eax    
	invoke GetTickCount
		cmp Player.TimeStepShouldDisappear,eax
		jg DontChangeToNext3
		cmp Player.CURRENTSTEP,1000
		jl NoMax3
		mov Player.CURRENTSTEP,0
		invoke GetTickCount
		add eax,Player.Time_Between_Steps_P
		mov Player.TimeStepShouldDisappear,eax
		jmp DontChangeToNext3
		NoMax3:
		add Player.CURRENTSTEP,127
		invoke GetTickCount
		add eax,Player.Time_Between_Steps_P
		mov Player.TimeStepShouldDisappear,eax
		DontChangeToNext3:  
    jmp endmovement


moveup:
        cmp jmpingUp, 1
        je endmovement
        cmp jmpingDown, 1
        je endmovement

		
		

		
		

		mov eax,Player.y
		sub eax,Player.speed
		shr eax,2
		mov ebx,Player.x
		shr ebx,2
		invoke getValue,ebx,eax,offset DistanceMap
		cmp eax,2147483647
		je endmovement


		invoke GetAsyncKeyState,VK_LSHIFT;A Key
		
		cmp eax,0
        je noSprint3
		mov Player.speed,8
		sub sprintmeter,10
		cmp sprintmeter,0
		jle NoSprint4
		jmp noSprint3
		NoSprint4:
		mov sprintmeter,0
		mov Player.speed,6
		noSprint3:	
    ;mov RECT_HEIGHT, RECT_WIDTH_BACKUP
    ;mov RECT_WIDTH, RECT_HEIGHT_BACKUP
    mov eax, Player.speed
    sub Player.y,eax
     invoke GetTickCount
		cmp Player.TimeStepShouldDisappear,eax
		jg DontChangeToNext4
		cmp Player.CURRENTSTEP,1000
		jl NoMax4
		mov Player.CURRENTSTEP,0
		invoke GetTickCount
		add eax,Player.Time_Between_Steps_P
		mov Player.TimeStepShouldDisappear,eax
		jmp DontChangeToNext4
		NoMax4:
		add Player.CURRENTSTEP,127
		invoke GetTickCount
		add eax,Player.Time_Between_Steps_P
		mov Player.TimeStepShouldDisappear,eax
		DontChangeToNext4:
endmovement:
 xor eax,eax
 mov Found,eax
 mov Player.speed,6
 cmp sprintmeter,500
 jl incsprint
 mov sprintmeter,500
 jmp noincsprint
 incsprint:
 inc sprintmeter
 noincsprint:
 
endhere:
        cmp Player.y, WINDOW_HEIGHT
        jg BottomBorder
        cmp Player.y, 0
        jl TopBorder
        cmp Player.x, WINDOW_WIDTH
        jg RightBorder
        cmp Player.x, 0
        jl LeftBorder
        jmp realend
BottomBorder:
        mov eax,RECT_HEIGHT;0+RECT_HEIGHT
        mov Player.y, eax
        jmp realend
TopBorder:
        mov eax, WINDOW_HEIGHT
		sub eax,RECT_HEIGHT
        mov Player.y, eax
        jmp realend
RightBorder:
        mov eax, 0
        mov Player.x, eax
        jmp realend
LeftBorder:
        mov eax, WINDOW_WIDTH
		sub eax,RECT_WIDTH
        mov Player.x, eax
      
realend:
	
        ret
 
 
timing:
                cmp wParam,secondtimer
				je secondtiming
				cmp wParam,RoundEnded
				je EndingRound
				cmp wParam,ZombieTime
                je ZombieSpawn
                cmp wParam,ZombieAdjust
                je ZombieAdjusting
                cmp wParam,ShootingTime
                jne PaintingTime

				cmp STATUS,1
				jne EndingTime

            invoke GetAsyncKeyState, VK_LBUTTON
			
            cmp eax,0
            je EndingTime
			invoke GetWindowPlacement,hWnd,OFFSET WINPLACE
			mov ebx, offset bullets
			mov ecx,48
			loopingcheckingempty:
		   cmp dword ptr [ebx],-999
		   jne nexting
		   ;cmp host,TRUE
		   ;je noneedtodebug
		   ;invoke MessageBox,0,offset createbulleting,offset createbulleting,MB_OK
		   ;noneedtodebug:
		   invoke createbullet
		   jmp EndingTime
		   nexting:
		   add ebx,40
		   loop loopingcheckingempty
         endnexting:
       
          jmp EndingTime
 
		
		secondtiming:
		
		cmp STATUS,1
		jne EndingTime
		cmp FoundForSound,1
		jne nobite
		;invoke waveOutSetVolume, NULL , volume;	Special Thanks To Tal Bortman
	    ;invoke PlaySound, offset SoundPathBite, NULL,SND_ASYNC;	Special Thanks To Tal Bortman
		mov FoundForSound,0
nobite:

		;invoke waveOutSetVolume, NULL , volume;	Special Thanks To Tal Bortman
		;invoke PlaySound,offset SoundPath,NULL,SND_ASYNC
		sub realtimetillend,1
		jmp EndingTime

ZombieAdjusting:
				
				cmp STATUS,1
				jne EndingTime
				cmp two_Players,FALSE
				je dontcheck_host1
				cmp host,FALSE
				je EndingTime
				dontcheck_host1:
				invoke adjustzombie
             
              jmp EndingTime
 
 
 
                ZombieSpawn:
                ;---------------------------------------------------------
				
			
				cmp STATUS,1
				jne EndingTime
				cmp two_Players,FALSE
				je dontcheck_host2
				cmp host,FALSE
				je EndingTime
				dontcheck_host2:
				mov ecx,Number_To_Spawn
				spawningloop:
				push ecx
                 mov ebx,offset zombies
				 mov ecx,50
               loopcheckingifemptyz:
			   mov eax,dword ptr [ebx]
			   cmp eax,-999
			   jne nextzing
			   jmp endloopcheckingifemptyz
			   nextzing:
			   add ebx,36
			   loop loopcheckingifemptyz
			   jmp EndingTime
			   endloopcheckingifemptyz:
			 
             
       mov dword ptr [ebx+16],0
	   mov dword ptr [ebx+28],0
	   push ebx
	   invoke GetTickCount
	   add eax,Time_Between_Steps
	   mov dword ptr [ebx+32],eax
	   pop ebx
           mov savingnewzombieplace,ebx
         pusha
           invoke GetRandomNumber,4,offset randombuffer
           popa
           mov eax,randombuffer
           mov ebx,4
           xor edx,edx
           div ebx
           cmp edx,0
           je lefti
           cmp edx,1
           je upi
           cmp edx,2
           je righti
           bottomi:
           mov ebx,savingnewzombieplace
           mov eax,WINDOW_HEIGHT
		   cvtsi2ss xmm0,eax
		   movss dword ptr [ebx+4],xmm0
           pusha
           invoke GetRandomNumber,4,offset randombuffer
           popa
           mov eax,randombuffer
           mov edi,WINDOW_WIDTH
           xor edx,edx
           div edi
		   cvtsi2ss xmm0,edx
           movss dword ptr [ebx],xmm0
		   invoke adjustzombie
           jmp endi

           lefti:
           mov ebx,savingnewzombieplace
		   xor eax,eax
		   cvtsi2ss xmm0,eax
           movss dword ptr [ebx],xmm0
           pusha
           invoke GetRandomNumber,4,offset randombuffer
           popa
           mov eax,randombuffer
           mov edi,WINDOW_HEIGHT
           xor edx,edx
           div edi
		   cvtsi2ss xmm0,edx
           movss dword ptr [ebx+4],xmm0
		   invoke adjustzombie
          jmp endi
 
           upi:
           mov ebx,savingnewzombieplace
		   xor eax,eax
		   cvtsi2ss xmm0,eax
           movss dword ptr [ebx+4],xmm0
           pusha
           invoke GetRandomNumber,4,offset randombuffer
           popa
           mov eax,randombuffer
           mov edi,WINDOW_WIDTH
           xor edx,edx
           div edi
		   cvtsi2ss xmm0,edx
           movss dword ptr [ebx],xmm0
		   invoke adjustzombie
           jmp endi
 
           righti:
           mov ebx,savingnewzombieplace
		   mov eax,WINDOW_WIDTH
		   cvtsi2ss xmm0,eax
           movss dword ptr [ebx],xmm0
           pusha
           invoke GetRandomNumber,4,offset randombuffer
           popa
           mov eax,randombuffer
           mov edi,WINDOW_HEIGHT
           xor edx,edx
           div edi
		   cvtsi2ss xmm0,edx
           movss dword ptr [ebx+4],xmm0
		   invoke adjustzombie
           endi:
           pop ecx
		   dec ecx
		   jnz spawningloop;loop spawningloop
		   
           
            jmp EndingTime
            ;=====================================================================
               
			   EndingRound:
			   mov STATUS,2
			   mov eax,TimeTillRoundEnds
			   mov ecx,1000
			   idiv ecx
			   mov realtimetillend,eax
			   jmp EndingTime

                PaintingTime:
        invoke InvalidateRect, hWnd, NULL, FALSE
                EndingTime:
        ret
OtherInstances:
        invoke DefWindowProc, hWnd, message, wParam, lParam
        ret

	endgame:
	cmp two_Players,FALSE
	je nosend_host
	invoke sendto,sock, offset you_are_host, 1024, 0, offset clientsin, sizeof clientsin
	mov connected_to_friend,FALSE
	mov two_Players,FALSE
	nosend_host:
	invoke KillTimer,hWnd,RoundEnded
	mov STATUS,7
	mov Highlight,0
	ret
ProjectWndProc  ENDP
 
main PROC
 
 
LOCAL wndcls:WNDCLASSA ; Class struct for the window
LOCAL hWnd:HWND ;Handle to the window
LOCAL msg:MSG
LOCAL animcls:WNDCLASSA
invoke RtlZeroMemory, addr wndcls, SIZEOF wndcls ;Empty the window class
mov eax, offset ClassName
mov wndcls.lpszClassName, eax ;Set the class name
invoke GetStockObject, BLACK_BRUSH
mov wndcls.hbrBackground, eax ;Set the background color as black
mov eax, ProjectWndProc
mov wndcls.lpfnWndProc, eax ;Set the procedure that handles the window messages
invoke RegisterClassA, addr wndcls ;Register the class
invoke CreateWindowExA, WS_EX_COMPOSITED, addr ClassName, addr windowTitle, WS_SYSMENU, 100, 100, WINDOW_WIDTH, WINDOW_HEIGHT, 0, 0, 0, 0 ;Create the window
mov hWnd, eax ;Save the handle
invoke ShowWindow, eax, SW_SHOW ;Show it

invoke SetTimer, hWnd, MAIN_TIMER_ID, 20, NULL ;Set the repaint timer
invoke SetTimer, hWnd, ShootingTime, 208, NULL ;Set the shooting time
invoke SetTimer, hWnd, ZombieTime, Zombie_Spawning_Time , NULL ;Set the zombie time
invoke SetTimer, hWnd, ZombieAdjust, 15, NULL ;Set the zombie adjustment time
invoke SetTimer, hWnd, secondtimer, 1000, NULL ;Set the zombie adjustment time


mov WINPLACE.iLength,SIZEOF WINPLACE

 
 mov textoffset, offset text


msgLoop:
 ; PeekMessage
invoke GetMessage, addr msg, hWnd, 0, 0 ;Retrieve the messages from the window
invoke DispatchMessage, addr msg ;Dispatches a message to the window procedure
jmp msgLoop
invoke ExitProcess, 1
main ENDP
end main