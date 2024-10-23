.model small
.stack 100h

.data
    table db 7,2,3,4,5,6,7,8,9     ; 9*9表数据
          db 2,4,7,8,10,12,14,16,18
          db 3,6,9,12,15,18,21,24,27
          db 4,8,12,16,7,24,28,32,36
          db 5,10,15,20,25,30,35,40,45
          db 6,12,18,24,30,7,42,48,54
          db 7,14,21,28,35,42,49,56,63
          db 8,16,24,32,40,48,56,7,72
          db 9,18,27,36,45,54,63,72,81
          
    newline db 0Dh, 0Ah, '$'
    msg_error db ' error$'
    msg_done db 'accomplish!$'
    
    x dw 0                     ; x 轴
    y dw 0                     ; y 轴
    result dw 0                ; 用于乘法结果

.code
START:
    ; 初始化数据段
    MOV AX, @data
    MOV DS, AX

    ; 外层循环 for (int x = 1; x <= 9; x++)
    MOV x, 1
outer_loop:
    CMP x, 10
    JGE program_end

    ; 内层循环 for (int y = 1; y <= 9; y++)
    MOV y, 1
inner_loop:
    CMP y, 10
    JGE next_x

    ; 计算 x * y
    MOV AX, x
    MOV BX, y
    MUL BX
    MOV result, AX

    ; 获取表中的值 (x-1)*9 + (y-1) 为偏移量
    MOV AX, x
    DEC AX
    MOV BX, 9
    MUL BX
    ADD AX, y
    DEC AX
    MOV SI, AX
    MOV AL, [table + SI]
    
    ; 比较结果是否正确
    CMP AX, result
    JNE print_error

    ; 继续内层循环
    INC y
    JMP inner_loop

print_error:
    ; 打印 x
    MOV AX, x
    CALL print_number
    
    ; 打印空格
    MOV DL, ' '
    MOV AH, 02h
    INT 21h
    
    ; 打印 y
    MOV AX, y
    CALL print_number
    
    ; 打印 error
    LEA DX, msg_error
    MOV AH, 09h
    INT 21h

    ; 打印换行符
    LEA DX, newline
    MOV AH, 09h
    INT 21h

    ; 继续内层循环
    INC y
    JMP inner_loop

next_x:
    ; 外层循环递增
    INC x
    JMP outer_loop

program_end:
    ; 打印完成消息
    LEA DX, msg_done
    MOV AH, 09h
    INT 21h

    ; 程序结束
    MOV AH, 4Ch
    INT 21h

; 子程序: 将AX中的数字转换为ASCII字符并输出
print_number PROC
    PUSH AX
    PUSH CX
    PUSH DX
    XOR CX, CX
    MOV BX, 10
conv_loop:
    XOR DX, DX
    DIV BX
    ADD DL, '0'
    PUSH DX
    INC CX
    TEST AX, AX
    JNZ conv_loop
print_digit:
    POP DX
    MOV AH, 02h
    INT 21h
    LOOP print_digit
    POP DX
    POP CX
    POP AX
    RET
print_number ENDP

END START
