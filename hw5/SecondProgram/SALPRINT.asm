.model small
.stack 100h

.data
EXTRN REVENUE: WORD, EMPLOYEES: WORD, TABLE: BYTE, YEARS: BYTE

.code
public PrintTable
PrintTable proc
    mov si, offset TABLE
    mov cx, 21          ; 年份数量

print_loop:
    ; 显示年份
    mov dx, [si]
    call PrintWord      ; 假设 PrintWord 是一个显示 word 的过程
    add si, 2

    ; 显示收入
    mov dx, [si]
    call PrintWord      ; 显示总收入
    add si, 2

    ; 显示雇员人数
    mov dx, [si]
    call PrintWord      ; 显示雇员人数
    add si, 2

    ; 显示人均收入
    mov dx, [si]
    call PrintWord      ; 显示人均收入
    add si, 2

    ; 换行
    call NewLine

    loop print_loop
    ret
PrintTable endp

; PrintWord 显示 DX 中的 word 数据
PrintWord proc
    push ax
    push bx
    push cx
    push dx

    ; 将 DX 中的数字转换为字符串并显示
    mov cx, 5              ; 假设最大5位数字
    mov bx, 10             ; 除数
    lea si, buffer         ; 指向缓冲区

convert_loop:
    xor dx, dx             ; 清除 DX
    div bx                 ; AX / 10，余数在 DX，商在 AX
    add dl, '0'            ; 转换余数为 ASCII
    dec si                 ; 指向前一个字符位置
    mov [si], dl           ; 存储字符
    loop convert_loop

    ; 显示转换后的字符串
    mov ah, 9
    lea dx, [si]
    int 21h

    pop dx
    pop cx
    pop bx
    pop ax
    ret
PrintWord endp

; NewLine - 输出换行符
NewLine proc
    mov ah, 2
    mov dl, 13             ; 回车
    int 21h
    mov dl, 10             ; 换行
    int 21h
    ret
NewLine endp

.data
buffer db 5 dup (' ')      ; 用于存储数字转换后的字符串
END
