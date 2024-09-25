.model small
.stack 100h
.data
    newline db 0dh, 0ah, '$' ; 定义换行符
.code
START:
    ; 初始化数据段寄存器
    MOV AX, @DATA
    MOV DS, AX

    ; 初始化循环变量
    MOV CX, 26         ; 循环26次，对应26个字母
    MOV AL, 97         ; 'a' 的 ASCII 值是 97，即0x61

print_loop:
    ; 输出字母
    MOV DL, AL         ; 将当前字母的 ASCII 值放入 DL
    MOV AH, 02h        ; 设置为输出单个字符
    INT 21h            ; 调用 DOS 中断输出字符

    ; 递增字母
    INC AL             ; 增加 AL 中的值，使其指向下一个字母

    LOOP print_loop    ; 循环，直到 CX 为 0

    ; 输出换行
    LEA DX, newline
    MOV AH, 09h        ; DOS 中断，输出字符串
    INT 21h

    ; 退出程序
    MOV AX, 4C00h
    INT 21h

END START
