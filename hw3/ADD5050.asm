.model small
.stack 100h

.data
    buffer db '     $'          ; 定义缓冲区
    newline db 0dh, 0ah, '$'    
    result dw 0                 

.code
START:
    MOV AX, @data          ; 将数据段地址装入AX寄存器
    MOV DS, AX             ; 设置DS为数据段寄存器指向data段

    XOR AX, AX             ; 清除AX寄存器
    MOV CX, 100            ; 设置CX为100，表示循环100次

sum_loop:  
    ADD [result], CX       ; 将CX的值加到result中
    LOOP sum_loop          ; 使用LOOP指令自动减小CX并跳转回循环，直至CX为0

    ; 现在CX等于0，结果已经计算完毕，接下来将结果转换为ASCII字符并存储

    LEA BX, [buffer+5]     ; 直接将BX指向buffer的末尾位置
    MOV BYTE PTR [BX], '$' ; 设置字符串结束符为'$'
    DEC BX                 ; BX指向前一个字符的位置

    MOV AX, [result]       ; 将result的值装入AX，准备进行数字转换
    MOV CX, 10             ; 将CX设置为10，准备以10为基数进行除法转换

convert_loop:
    XOR DX, DX             ; 清除DX寄存器，确保除法时DX为0
    DIV CX                 ; 将AX除以10，商在AX，余数在DX（余数是当前位）
    ADD DL, '0'            ; 将余数转为字符（0-9对应的ASCII码）
    MOV [BX], DL           ; 将转换后的字符存入BX指向的缓冲区位置
    DEC BX                 ; BX向前移动一位，准备存储下一个字符
    TEST AX, AX            ; 测试AX是否为0（即是否处理完所有位）
    JNZ convert_loop       ; 如果AX不为0，则继续循环处理下一个数字

    ; 输出结果字符串

    LEA DX, [buffer]       ; 将buffer地址加载到DX（用于中断调用输出字符串）
    MOV AH, 09h            ; 设置DOS中断功能号09h，用于输出以'$'结尾的字符串
    INT 21h                ; 调用DOS中断，输出buffer中的字符串

    ; 程序结束

    MOV AH, 4ch            ; 设置DOS中断功能号4Ch，正常结束程序
    INT 21H                ; 调用DOS中断，返回操作系统

END START                  ; 定义程序入口点

