EXTERN puts:PROC

.data
message BYTE "2021763045 Yu Jun", 0

.code
PUBLIC PrintMessage

PrintMessage PROC
    sub rsp, 28h
    lea rcx, message
    call puts
    add rsp, 28h
    ret
PrintMessage ENDP

END