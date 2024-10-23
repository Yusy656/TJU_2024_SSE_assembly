.model small
.stack 100h

.data
    msg1 db 'The 9mul9 table: $'
    newline db 0Dh, 0Ah, '$'
    i dw 0                     ; 循环变量 i
    j dw 0                     ; 循环变量 j
    temp dw 0                  ; 用于乘法结果
    buffer db 6 dup(0)          ; 用于存储转换后的数字

.code
START:
    ; 初始化数据段
    MOV AX, @data
    MOV DS, AX

    ; 打印 "The 9mul9 table: "
    LEA DX, msg1
    MOV AH, 09h
    INT 21h
    
    LEA DX, newline
    MOV AH, 09h
    INT 21h

    ; 外层循环 for (int i = 9; i >= 1; i--)
    MOV i, 9
outer_loop:
    CMP i, 0
    JL end_program

    ; 内层循环 for (int j = 1; j <= i; j++)
    MOV j, 1
inner_loop:
    MOV AX, j
    CMP AX, i
    JG new_line

    ; 计算 i * j
    MOV AX, i
    MOV BX, j
    MUL BX
    MOV temp, AX

    ; 打印 i * j = temp 的格式
    MOV AX, i
    CALL print_number      ; 打印 i
    MOV DL, '*'
    MOV AH, 02h
    INT 21h
    MOV AX, j
    CALL print_number      ; 打印 j
    MOV DL, '='
    MOV AH, 02h
    INT 21h
    MOV AX, temp
    CALL print_number      ; 打印乘积结果

    ; 打印制表符
    MOV DL, 09h
    MOV AH, 02h
    INT 21h

    INC j
    JMP inner_loop

new_line:
    ; 打印换行符
    LEA DX, newline
    MOV AH, 09h
    INT 21h

    DEC i
    JMP outer_loop

end_program:
    ; 程序结束
    MOV AH, 4Ch
    INT 21h

; 子程序: 将AX中的数字转换为ASCII字符并输出
print_number PROC
    PUSH AX
    PUSH CX
    PUSH DX
    PUSH SI                ; 保存SI寄存器

    ; 初始化指针，指向buffer起始位置
    MOV SI, OFFSET buffer  ; 使用SI作为指针操作buffer
    MOV CX, 10

convert_loop:
    XOR DX, DX             ; 清除DX，确保除法无余数
    DIV CX                 ; AX / 10，商存入AX，余数在DX
    ADD DL, '0'            ; 将余数转换为字符
    MOV [SI], DL           ; 存储字符到buffer中
    INC SI                 ; SI指针前移
    TEST AX, AX            ; 检查AX是否为0
    JNZ convert_loop       ; 如果AX不为0，继续循环

    ; 输出缓冲区中的字符，倒序输出
    DEC SI                 ; 因为最后一次 INC SI 超出了存储的范围，所以这里要先递减SI
print_loop:
    MOV DL, [SI]           ; 取出buffer中的字符
    MOV AH, 02h
    INT 21h
    DEC SI                 ; 递减SI指向前一个字符
    CMP SI, OFFSET buffer-1 ; 判断是否全部输出完毕
    JNE print_loop         ; 如果SI未到buffer的起始地址，继续输出

    POP SI                 ; 恢复SI寄存器
    POP DX
    POP CX
    POP AX
    RET
print_number ENDP

END START
