.model small
.stack 100h

.data
; 声明外部数据
EXTRN REVENUE: WORD, EMPLOYEES: WORD, TABLE: BYTE, YEARS: BYTE

.code
public ProcessData
ProcessData proc
    mov si, offset YEARS
    mov di, offset TABLE
    mov cx, 21          ; 年份数量

process_loop:
    ; 复制年份
    mov ax, [si]
    mov [di], ax
    add si, 2
    add di, 4

    ; 复制总收入（32位分段存储：高16位在BX，低16位在AX）
    mov ax, word ptr [si]        ; 取总收入的低16位
    mov bx, word ptr [si + 2]    ; 取总收入的高16位
    mov [di], ax                 ; 将低16位写入表格
    mov [di + 2], bx             ; 将高16位写入表格
    add si, 4
    add di, 4

    ; 复制雇员人数
    mov ax, word ptr [si]
    mov [di], ax
    add si, 2
    add di, 2

    ; 计算人均收入 = 总收入 / 雇员人数
    mov cx, [si - 2]    ; 雇员人数在 CX 中

    ; 清空DX用于存储商的高16位部分（因为我们进行的是32位除法）
    xor dx, dx          ; 将 DX 清零，形成 32 位的被除数 BX:AX

    ; 执行32位除法 (DX:AX) / CX，结果在AX中
    div cx              ; 32位除法，结果低16位在 AX，中间结果保存在DX

    ; 将人均收入写入表格
    mov [di], ax        ; 存储除法结果
    add di, 2

    loop process_loop
    ret
ProcessData endp
END
