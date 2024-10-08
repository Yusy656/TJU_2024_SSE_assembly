.model small
.stack 100h

.data
    buffer db '     $'          ; 定义缓冲区，长度预留足够大
    newline db 0dh, 0ah, '$'    ; 新行符
    prompt db 'Enter a number (1-100): $'

.code
START:
    MOV AX, @data          ; 将数据段地址装入AX寄存器
    MOV DS, AX             ; 设置DS为数据段寄存器指向data段

    ; 输出提示信息
    LEA DX, prompt         ; 将提示信息地址加载到DX
    MOV AH, 09h            ; 设置DOS中断功能号09h，用于输出以'$'结尾的字符串
    INT 21h                ; 调用DOS中断，输出提示信息

    ; 读取用户输入的数字
    XOR BX, BX             ; BX用于保存输入的数字，初始化为0
read_loop:
    MOV AH, 01h            ; 设置DOS中断功能号01h，用于读取输入字符
    INT 21h                ; 调用DOS中断，读取一个字符
    SUB AL, '0'            ; 将ASCII字符转换为数字（0-9）

    MOV CL, AL             ; 将输入的数字字符保存到CL中
    MOV AX, BX             ; 将BX中的当前值放入AX中
    MOV BX, 10             ; 将基数10放入BX中
    MUL BX                 ; AX = AX * 10 (进一位)
    ADD AX, CX             ; AX = AX + CL，将当前输入数字加入结果中
    MOV BX, AX             ; 更新BX为新的数字值

    ; 读取下一个字符，直到按下回车
    MOV AH, 01h            ; 设置DOS中断功能号01h
    INT 21h                ; 调用DOS中断，读取下一个字符
    CMP AL, 0dh            ; 判断是否是回车键 (0Dh)
    JNZ read_loop          ; 如果不是回车，则继续读取

    ; 将输入的值放入CX中作为循环次数
    MOV CX, BX             ; 将BX中的输入值放入CX

    ; 执行循环操作
    XOR AX, AX             ; 清除AX寄存器
sum_loop:  
    ADD AX, CX                 ; 将CX的值加到AX中
    LOOP sum_loop              ; 使用LOOP指令自动减小CX并跳转回循环，直至CX为0

    ; 现在CX等于0，结果已经计算完毕，接下来将结果转换为ASCII字符并存储
    LEA BX, [buffer+5]         ; 直接将BX指向buffer的末尾位置
    MOV BYTE PTR [BX], '$'     ; 设置字符串结束符为'$'
    DEC BX                     ; BX指向前一个字符的位置

    MOV CX, 10                 ; 将CX设置为10，准备以10为基数进行除法转换
convert_loop:
    XOR DX, DX                 ; 清除DX寄存器，确保除法时DX为0
    DIV CX                     ; 将AX除以10，商在AX，余数在DX（余数是当前位）
    ADD DL, '0'                ; 将余数转为字符（0-9对应的ASCII码）
    MOV [BX], DL               ; 将转换后的字符存入BX指向的缓冲区位置
    DEC BX                     ; BX向前移动一位，准备存储下一个字符
    TEST AX, AX                ; 测试AX是否为0（即是否处理完所有位）
    JNZ convert_loop           ; 如果AX不为0，则继续循环处理下一个数字

    ; 输出结果字符串
    LEA DX, buffer             ; 将buffer地址加载到DX（用于中断调用输出字符串）
    MOV AH, 09h                ; 设置DOS中断功能号09h，用于输出以'$'结尾的字符串
    INT 21h                    ; 调用DOS中断，输出buffer中的字符串

    ; 程序结束
    MOV AH, 4Ch                ; 设置DOS中断功能号4Ch，正常结束程序
    INT 21H                    ; 调用DOS中断，返回操作系统

END START                      ; 定义程序入口点