.model small
.stack 100h

; 声明其他模块中的外部过程和数据
EXTRN InitData: FAR, ProcessData: FAR; , PrintTable: FAR
EXTRN REVENUE: WORD, EMPLOYEES: WORD, TABLE: BYTE, YEARS: BYTE

.data
msg db 'Press any key to exit...', '$'

.code
main proc
    mov ax, @data
    mov ds, ax

    ; 调用外部过程
    call InitData
    call ProcessData
    ; call PrintTable

    ; 显示结束信息
    mov ah, 9
    lea dx, msg
    int 21h

    ; 等待用户按键退出
    mov ah, 1
    int 21h

    mov ax, 4C00h
    int 21h
main endp
END main
