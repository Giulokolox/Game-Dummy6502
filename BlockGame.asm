.org $8000

.define CRT $0200 ;in questa parte definiamo vari valori dandoli un nome
.define key $10
.define old_key $11
.define row $12

start:
    LDA #$01 ; carico nell'accumulatore il dato 01 e lo aggiungo nell'sta
    STA CRT  
    LDY #$10 
    STY row
    LDA #$00
    STA old_key

input: 
    STA old_key
    LDA $4000 ;rappresenta il pad
    BEQ input  ; se il risultato è uguale a zero viene chiamato l'input
    CMP old_key ; Compara il nostro tasto a quello vecchio e se uguale torna al vecchio input
    BEQ input 
    JSR clear ;questa è una funzione come il jump solo che quanto troverà l'opcode RTS ritornera al JSR + 1
    STA key
    LSR A ;esso sposta tutti i bits a destra(leggere la doc.). in questo caso lo sfruttiamo usando il pad collegandolo ad una funzione draw
    BCS Move_Up ; Questo indica che il carry è stato settato e se è presente si attiva 
    LSR A
    BCS Move_Down
    LSR A
    BCS Move_Left
    LSR A
    BCS Move_Right

draw:
    LDA key
    JSR finalDraw
    JMP input

clear:
    STA $00
    LDA #00;
    STA CRT, X
    LDA $00
    RTS ; ritorna al JSR + 1 


finalDraw:
    STA $00
    LDA #01 ;
    STA CRT, X ; settiamo lo store accumulator nel registro x 
    LDA $00
    RTS ; ritorna al JSR + 1 



Move_Up:
    TXA ; bisogna trasferire il valore di x in a
    SBC row; poi si sotrare dalla riga
    TAX ; tasferiamo nuovamente il valore di a in x dopo aver sottratto il carry
    JMP draw

Move_Down:
    TXA
    ADC row
    TAX
    DEX
    JMP draw

Move_Left:
    DEX
    JMP draw

Move_Right:
    INX
    JMP draw

.goto $fffa

.dw start
.dw start
.dw start

