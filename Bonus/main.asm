section .data
    newline db 10          ; Caractère de nouvelle ligne (ASCII 10)
    buffer db 10 dup(0)    ; Buffer pour stocker les chiffres convertis en chaîne

section .bss
    num resd 1             ; Variable pour stocker le nombre actuel

section .text
    global main

main:
    mov dword [num], 0     ; Initialiser le nombre à 0

print_loop:
    ; Convertir le nombre en chaîne de caractères
    mov eax, [num]         ; Charger le nombre dans EAX
    lea edi, [buffer + 9]  ; Pointer EDI à la fin du buffer
    mov byte [edi], 0      ; Terminer la chaîne avec un caractère nul
    mov ecx, 10            ; Base 10 pour la conversion

convert_loop:
    dec edi                ; Déplacer le pointeur vers la gauche
    xor edx, edx           ; Effacer EDX pour la division
    div ecx                ; Diviser EAX par 10, reste dans EDX
    add dl, '0'            ; Convertir le reste en caractère ASCII
    mov [edi], dl          ; Stocker le caractère dans le buffer
    test eax, eax          ; Vérifier si EAX est 0
    jnz convert_loop       ; Continuer si EAX n'est pas 0

    ; Calculer la longueur de la chaîne
    lea esi, [buffer + 9]  ; ESI pointe à la fin du buffer
    sub esi, edi           ; ESI = longueur de la chaîne

    ; Écrire la chaîne dans la console
    mov eax, 4             ; Appel système pour write (4)
    mov ebx, 1             ; Descripteur de fichier (1 = stdout)
    mov ecx, edi           ; Adresse de la chaîne
    mov edx, esi           ; Longueur de la chaîne
    int 0x80               ; Interruption pour appeler le système

    ; Écrire une nouvelle ligne
    mov eax, 4             ; Appel système pour write (4)
    mov ebx, 1             ; Descripteur de fichier (1 = stdout)
    mov ecx, newline       ; Adresse de la nouvelle ligne
    mov edx, 1             ; Longueur de la nouvelle ligne (1 caractère)
    int 0x80               ; Interruption pour appeler le système

    ; Incrémenter le nombre
    inc dword [num]        ; Incrémenter le nombre de 1

    ; Vérifier si on a atteint 10 000
    cmp dword [num], 10000 ; Comparer avec 10 000
    jle print_loop         ; Continuer si <= 10 000

    ; Quitter le programme
    mov eax, 1             ; Appel système pour exit (1)
    xor ebx, ebx           ; Code de retour 0
    int 0x80               ; Interruption pour appeler le système
