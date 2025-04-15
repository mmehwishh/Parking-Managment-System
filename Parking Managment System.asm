INCLUDE Irvine32.inc

.data
stars BYTE "***************************************",0
tabs BYTE " ",0
dashes BYTE "________________________________________________________________________________________",0
lines BYTE " Vehicle No. |Vehicle Type |Slot No.| owner Name |contact Info |Fee  |Status |", 0
welcomeMsg BYTE "Welcome to Parking Management System",0
opt1 BYTE "1. Add New Vehicle",0
opt2 BYTE "2. Remove Vehicle (Vacate Slot)",0
opt3 BYTE "3. View All Parking Slots",0
opt4 BYTE "4. Search Vehicle by Number",0
opt5 BYTE "5. View Rules & Regulations",0
opt6 BYTE "6. View Parking Detail",0
opt7 BYTE "7. Exit",0
choice BYTE "Enter your choice: _",0

;add vehicle proc data
vehicleAdded BYTE "Vehicle Added Successfully!Click Ok to continue...",0
numberPlateInput BYTE "Enter vehicle number(Number plate ): _",0
vehicleTypeInput BYTE "Enter vehicle type [format : [code]type] [[1]CAR , [2]BIKE , [3]RICKSHAW] (Type code of your vehicle too): _",0	
ownerNameInput BYTE "Enter owner name: _",0
contactInfoInput BYTE "Enter your contact information: _",0
parkFeeOutput BYTE "Parking Fee: _",0
parkingSlotnoOutput BYTE "Parking Slot Number: _",0
vechileStautusInput BYTE "Enter vehicle status(Parked(1), Not parked(0)): _"
maxData = 10;
maxStringLength = 100;
currentNoDetails DWORD 0
numberPlate BYTE maxData DUP(maxStringLength DUP(0))
vehicleType BYTE maxData DUP(maxStringLength DUP(0))
parkingSlotno DWORD maxData DUP(0)
ownerName BYTE maxData DUP(maxStringLength DUP(0))
contactInfo DWORD maxData DUP(0)
parkingFee DWORD maxData DUP(0)
vehicleStatus DWORD maxData DUP(0)

;generateTickets variables
gtv BYTE "........GENERATING TICKET........",0
gt0 BYTE "=============================================",0
gt1 BYTE "		||Vehicle number : ",0
gt2 BYTE "		||Owner Name : ",0
gt3 BYTE "		||Assign Slot number : XX-",0
gt4 BYTE "		||Parking Fee : ",0
gt5 BYTE "		||Parking Status : ",0
gt6 BYTE "		||Contact Information : ",0
gt7 BYTE "		||Vehicle Type : ",0

;search variable 
searchName BYTE maxStringLength DUP(0)
vehicleNotFound BYTE "Invalid number plate. Please input correct number plate.",0
vehicleFound BYTE "Vehicle found. yay!",0

;remove vehicle variables
spacePrint BYTE " ",0
dash BYTE "-",0


;Parking Detail variables
totalVehicle DWORD 0
toalBudget DWORD 0
carsTotal DWORD 0
bikeTotal DWORD 0
rickshawTotal DWORD 0
totalMsg BYTE "Number of total vehicles in parking_ ",0
leftSpace BYTE "Left space in parking_ ",0
carsTotalmsg BYTE "Number of total cars in parking_ ",0
bikeTotalmsg BYTE "Number of total bikes in parking_ ",0
rickshawTotalmsg BYTE "Number of total rickshaw in parking_ ",0
toalBudgetmsg BYTE "Total : ",0

;rules & regulations variavbles 
    ; Rules & Regulations
    rules BYTE "1. Vehicles must be parked in designated parking spots.", 0
    rules2 BYTE "2. Only registered vehicles are allowed to park in the system.", 0
    rules3 BYTE "3. Parking fees must be paid in advance.", 0
    rules4 BYTE "4. No overnight parking is allowed without prior permission.", 0
    rules5 BYTE "5. Maximum parking duration is 24 hours.", 0
    rules6 BYTE "6. All vehicles should have valid insurance and registration documents.", 0
    rules7 BYTE "7. Vehicles parked in unauthorized areas will be towed at the owner's expense.", 0
    rules8 BYTE "8. The parking management system is not responsible for any damage to vehicles.", 0
    rules9 BYTE "9. Users must park within the marked lines.", 0
    rules10 BYTE "10. Any violation of rules may result in a fine or removal from the parking system.", 0

;vehilcle remove variables 
removeMsg BYTE "Vehicle Removed Succesfully.",0
.code
Main PROC

call menu

exit
Main ENDP

menu PROC
L1:

mov edx, offset stars
call writeString
call crlf
mov edx, offset welcomeMsg
call writeString
call crlf
mov edx, offset opt1
call writeString
call crlf
mov edx, offset opt2
call writeString
call crlf
mov edx, offset opt3
call writeString
call crlf
mov edx, offset opt4
call writeString
call crlf
mov edx, offset opt5
call writeString
call crlf
mov edx, offset opt6
call writeString
call crlf
mov edx, offset opt7
call writeString
call crlf


mov edx, offset choice
call writeString
call readInt
cmp eax, 7
je exitProgram

cmp eax, 1
jne case1
call addVehicle
;call clrscr
jmp L1


case1:
cmp eax, 2
jne case2
call removeVehicle
;call clrscr
jmp L1

case2:
cmp eax, 3
jne case3
call viewParking
;call clrscr
jmp L1

case3:
cmp eax, 4
jne case4
call searchByNum
;call clrscr
jmp L1


case4:
cmp eax, 5
jne case5
call rulesParking
;call clrscr
jmp L1

case5:
cmp eax, 6
jne exitProgram
call ParkingDetail
;call clrscr
jmp L1


exitProgram:
ret
menu ENDP

addVehicle PROC
mov edx, offset stars
call writeString
call crlf
mov edx, offset opt1
call writeString
call crlf
mov edx, offset stars
call writeString
call crlf

mov eax, maxData
cmp currentNoDetails, eax
jge nospace
inc totalVehicle
mov edx,offset numberPlateInput
call writeString
;data input
mov eax, currentNoDetails
imul eax, maxStringLength
lea edx, numberPlate[eax]
mov ecx, maxStringLength
call ReadString

mov edi , currentNoDetails
mov edx,offset vehicleTypeInput
call writeString
call readDec
mov parkingSlotno[edi*TYPE DWORD], eax
mov eax, currentNoDetails
imul eax, maxStringLength
lea edx, vehicleType[eax]
mov ecx, maxStringLength
call ReadString

cmp parkingSlotno[edi*TYPE DWORD], 2
jl parkingFeeCar
jg parkingFeeRickshaw
mov parkingFee[edi*TYPE DWORD], 500
add toalBudget, 500
inc bikeTotal
jmp con
parkingFeeCar:
mov parkingFee[edi*TYPE DWORD], 1000
add toalBudget, 1000
inc carsTotal
jmp con
parkingFeeRickshaw:
mov parkingFee[edi*TYPE DWORD], 350
add toalBudget, 350
inc rickshawTotal
con:
mov edx,offset ownerNameInput
call writeString

mov eax, currentNoDetails
imul eax, maxStringLength
lea edx, ownerName[eax]
mov ecx, maxStringLength
call ReadString


mov edx, offset contactInfoInput
call WriteString
call ReadDec
mov contactInfo[edi*TYPE DWORD], eax

mov edx, offset vechileStautusInput
call WriteString
call ReadInt 
mov ecx , eax
mov vehicleStatus[edi*TYPE DWORD], eax

cmp ecx , 1
jne complete
call generateTicket
complete:
inc currentNoDetails

mov ebx , offset welcomeMsg
mov edx , offset vehicleAdded
call msgBox

nospace:
ret
addVehicle ENDP

removeVehicle PROC
mov edx, offset stars
call writeString
call crlf
mov edx, offset opt2
call writeString
call crlf
mov edx, offset stars
call writeString
call crlf

    push ebp
    mov ebp , esp
    mov edx, offset stars
    call writeString
    call crlf
    mov edx, offset stars
    call writeString
    call crlf

    mov edx, offset numberPlateInput
    call writeString
    mov ecx, maxStringLength
    lea edx, searchName
    call readString

    mov esi, 0                    
    mov ecx, currentNoDetails    
    mov ebx , 0
searchLoop:
    push ecx
    push esi 

    imul eax, esi, maxStringLength 
    lea esi , numberPlate[eax]
    mov edi, offset searchName 
    mov ecx , maxStringLength
    
    repe cmpsb                     
    je foundVehicle                

    pop esi
    mov ebx  , esi
    inc esi
    pop ecx                        
    loop searchLoop                

    mov edx, offset vehicleNotFound
    call writeString
call crlf
    jmp searchComplete

foundVehicle:
    mov edx , offset removeMsg 
    call writeString 
    call crlf

    inc ebx
    mov eax , ebx
    imul eax ,maxStringLength
    lea edi ,  numberPlate[eax]
    mov ecx , 7
    mov al , spacePrint
    cld 
    rep stosb 


    mov eax , ebx
    imul eax ,maxStringLength
    lea edi ,  vehicleType[eax]
    mov ecx , 7
    mov al , spacePrint
    cld 
    rep stosb 
    

    mov eax , 0
    mov parkingSlotno[ebx*TYPE DWORD] , eax
    

     mov eax , ebx
    imul eax ,maxStringLength
    lea edi , ownerName[eax]
    mov ecx , 7
    mov al , spacePrint
    cld 
    rep stosb 

 
mov eax , 0
mov contactInfo[ebx*TYPE DWORD] , eax


mov eax , 0
    mov parkingFee[ebx*TYPE parkingFee] , eax


    mov eax , 0
 mov  vehicleStatus[ebx*TYPE vehicleStatus] , eax

    searchComplete:
    mov esp , ebp
    pop ebp
    ret

removeVehicle ENDP




viewParking PROC
mov edx, offset stars
call writeString
call crlf
mov edx, offset opt3
call writeString
call crlf
mov edx, offset stars
call writeString
call crlf

mov edx, offset dashes
call writeString
call crlf
mov edx, offset lines
call writeString
call crlf
mov edx, offset dashes
call writeString
call crlf

mov ecx, currentNoDetails
mov esi, 0

display:

mov eax, esi
imul eax, maxStringLength
lea edx, numberPlate[eax]
call writeString

mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString


mov eax, esi
imul eax, maxStringLength
lea edx, vehicleType[eax]
call writeString

mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString

mov eax, parkingSlotno[esi*TYPE DWORD]
call writeDec

mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString

mov eax, esi
imul eax, maxStringLength
lea edx, ownerName[eax]
call writeString

mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString

mov eax, contactInfo[esi*TYPE DWORD]
call writeDec

mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString

mov eax, parkingFee[esi*TYPE parkingFee]
call writeDec

mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString

mov eax, vehicleStatus[esi*TYPE vehicleStatus]
call writeDec
call crlf

dec ecx
inc esi
cmp ecx, 0
jle loopComplete
jmp display

loopComplete:

mov eax , maxData
sub eax , currentNoDetails
cmp eax , 0
je allPrint

mov ecx , eax

L1:
mov edx , offset dash
call writeString

mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString


mov edx , offset dash
call writeString

mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString


mov edx , offset dash
call writeString

mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString

mov edx , offset dash
call writeString

mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString

mov edx , offset dash
call writeString

mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString

mov edx , offset dash
call writeString

mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString

mov edx , offset dash
call writeString

mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString

call crlf
dec ecx
 cmp ecx , 0
 jg L1





allPrint:

ret
viewParking ENDP

searchByNum PROC
    push ebp
    mov ebp , esp
    mov edx, offset stars
    call writeString
    call crlf
    mov edx, offset opt4
    call writeString
    call crlf
    mov edx, offset stars
    call writeString
    call crlf

    mov edx, offset numberPlateInput
    call writeString
    mov ecx, maxStringLength
    lea edx, searchName
    call readString

    mov esi, 0                    
    mov ecx, currentNoDetails    
    mov ebx , 0
searchLoop:
    push ecx
    push esi 

    imul eax, esi, maxStringLength 
    lea esi , numberPlate[eax]
    mov edi, offset searchName 
    mov ecx , maxStringLength
    
    repe cmpsb                     
    je foundVehicle                

    pop esi
    mov ebx  , esi
    inc esi
    pop ecx                        
    loop searchLoop                

    mov edx, offset vehicleNotFound
    call writeString
    jmp searchComplete

foundVehicle:
    mov edx , offset vehicleFound
    call writeString 
    call crlf

    inc ebx
    mov eax , ebx
    imul eax ,maxStringLength
    lea edx , numberPlate[eax]
    mov ecx , maxStringLength
    call writeString

    mov edx, offset tabs
    call writeString
    mov edx, offset tabs
    call writeString
    mov edx, offset tabs
    call writeString

     mov eax , ebx
    imul eax ,maxStringLength
    lea edx , vehicleType[eax]
    mov ecx , maxStringLength
    call writeString

    mov edx, offset tabs
    call writeString
    mov edx, offset tabs
    call writeString
    mov edx, offset tabs
    call writeString

    mov eax, parkingSlotno[ebx*TYPE DWORD]
    call writeDec


    mov edx, offset tabs
    call writeString
    mov edx, offset tabs
    call writeString
    mov edx, offset tabs
    call writeString


     mov eax , ebx
    imul eax ,maxStringLength
    lea edx , ownerName[eax]
    mov ecx , maxStringLength
    call writeString

    mov edx, offset tabs
    call writeString
    mov edx, offset tabs
    call writeString
    mov edx, offset tabs
    call writeString


 
mov eax, contactInfo[ebx*TYPE DWORD]
call writeDec


    mov edx, offset tabs
    call writeString
    mov edx, offset tabs
    call writeString
    mov edx, offset tabs
    call writeString



    mov eax, parkingFee[ebx*TYPE parkingFee]
call writeDec


    mov edx, offset tabs
    call writeString
    mov edx, offset tabs
    call writeString
    mov edx, offset tabs
    call writeString

 mov eax, vehicleStatus[ebx*TYPE vehicleStatus]
call writeDec
    call crlf
    searchComplete:
    mov esp , ebp
    pop ebp
    ret
searchByNum ENDP



generateTicket PROC
mov edx, offset stars
call writeString
call crlf
mov edx, offset gtv
call writeString
call crlf
mov edx, offset stars
call writeString
call crlf

mov edx , offset gt0
call writeString 
call crlf

mov esi , currentNoDetails

mov edx , offset gt1
call writeString 

mov eax, esi
imul eax, maxStringLength
lea edx, numberPlate[eax]
call writeString

mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString

mov edx , offset gt7
call writeString 

mov eax, esi
imul eax, maxStringLength
lea edx, vehicleType[eax]
call writeString

mov edx, offset tabs
call writeString
call crlf


mov edx , offset gt3
call writeString 
mov eax, parkingSlotno[esi*TYPE DWORD]
call writeDec

mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString

mov edx , offset gt2
call writeString 

mov eax, esi
imul eax, maxStringLength
lea edx, ownerName[eax]
call writeString

mov edx, offset tabs
call writeString
call crlf


mov edx , offset gt6
call writeString 
mov eax, contactInfo[esi*TYPE DWORD]
call writeDec

mov edx, offset tabs
call writeString
mov edx, offset tabs
call writeString

mov edx , offset gt4
call writeString 
mov eax, parkingFee[esi*TYPE parkingFee]
call writeDec

mov edx, offset tabs
call crlf

mov edx , offset gt5
call writeString 
mov eax, vehicleStatus[esi*TYPE vehicleStatus]
call writeInt
call crlf

mov edx , offset gt0
call writeString 
call crlf


ret
generateTicket ENDP

rulesParking PROC
mov edx, offset stars
call writeString
call crlf
mov edx, offset opt6
call writeString
call crlf
mov edx, offset stars
call writeString
call crlf


    MOV EDX, OFFSET rules
    CALL WriteString
    call crlf
    MOV EDX, OFFSET rules2
    CALL WriteString
    call crlf
    MOV EDX, OFFSET rules3
    CALL WriteString
    call crlf
    MOV EDX, OFFSET rules4
    CALL WriteString
    call crlf
    MOV EDX, OFFSET rules5
    CALL WriteString
    call crlf
    MOV EDX, OFFSET rules6
    CALL WriteString
    call crlf
    MOV EDX, OFFSET rules7
    CALL WriteString
    call crlf
    MOV EDX, OFFSET rules8
    CALL WriteString
    call crlf
    MOV EDX, OFFSET rules9
    CALL WriteString
    call crlf
    MOV EDX, OFFSET rules10
    CALL WriteString
    call crlf




















ret
rulesParking ENDP

parkingDetail PROC
mov edx, offset stars
call writeString
call crlf
mov edx, offset opt7
call writeString
call crlf
mov edx, offset stars
call writeString
call crlf


mov edx , offset totalMsg
call writeString
mov eax , currentNoDetails
call writeDec
call crlf

mov edx , offset leftSpace
call writeString
mov eax  , maxData
sub eax , currentNoDetails
call writeDec
call crlf

mov edx , offset carsTotalmsg
call writeString
mov eax , carsTotal
call writeDec
call crlf

mov edx , offset bikeTotalmsg
call writeString
mov eax , bikeTotal
call writeDec
call crlf

mov edx , offset rickshawTotalmsg
call writeString
mov eax , rickshawTotal
call writeDec
call crlf

mov edx , offset toalBudgetmsg
call writeString
mov eax , toalBudget
call writeDec
call crlf

ret
parkingDetail ENDP


END Main