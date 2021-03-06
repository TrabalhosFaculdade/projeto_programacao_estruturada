
       IDENTIFICATION DIVISION.
       PROGRAM-ID. LEITURA.

       ENVIRONMENT DIVISION.
           CONFIGURATION SECTION.

               SPECIAL-NAMES.
                   DECIMAL-POINT IS COMMA.

               INPUT-OUTPUT SECTION.
                   FILE-CONTROL.
                       SELECT OPTIONAL ARQ-LIVRO
                       ASSIGN TO "livros.dat"
                       ORGANIZATION INDEXED
                       RECORD KEY IS COD-LIVRO
                       ACCESS RANDOM
                       FILE STATUS IS W-COD-ERRO.

       DATA DIVISION.
           FILE  SECTION.
           FD ARQ-LIVRO.
           01 REG-LIVRO.
               02 COD-LIVRO    PIC 9(3).
               02 TITULO-LIVRO PIC X(40).
               02 AUTOR-LIVRO  PIC X(40).
               02 FILLER       PIC X(41).

           WORKING-STORAGE SECTION.
           77 W-COD-ERRO           PIC  X(2) VALUE SPACES.
           77 OPC                  PIC X     VALUE SPACE.
              88 OPC-OK                      VALUE "S" "N".
           77 W-COD-LIVRO-PESQUISA PIC 9(3)  VALUE ZEROS.
           77 COD-LIVRO-ED         PIC ZZ9   VALUE ZEROS.
           77 W-BRANCO             PIC X(50) VALUE SPACES.

           SCREEN SECTION.
           01 CLEAR-SCREEN.
               05 BLANK SCREEN BACKGROUND-COLOR 0 FOREGROUND-COLOR 0.

       PROCEDURE DIVISION.

       INICIO.
           PERFORM INICIALIZACAO.
           PERFORM PROCESSAMENTO UNTIL OPC = "N".
           PERFORM FINALIZACAO.
           EXIT PROGRAM.

       INICIALIZACAO.
           PERFORM ABRIR-ARQUIVO.
           MOVE "S" TO OPC.

       PROCESSAMENTO.

           PERFORM FORMATAR-TELA.
           PERFORM ROTINA-LEITURA
           PERFORM EXIBIR-DADOS-LIDOS.
           PERFORM RECEBER-OPCAO-CONTINUIDADE.

       FORMATAR-TELA.

           MOVE ZEROS TO COD-LIVRO-ED.

           *> LIMPANDO TELA
           DISPLAY  CLEAR-SCREEN.

           CALL "CABECALHO".
           DISPLAY "LEITURA DE LIVROS"      AT 1311.

           DISPLAY "CODIGO:"                AT 1502.
           DISPLAY "TITULO:"                AT 1702.
           DISPLAY "AUTOR:"                 AT 1902.
           DISPLAY "OUTRO REGISTRO? (S/N):" AT 2102.
           DISPLAY "MENSAGEM:"              AT 2502.

       ROTINA-LEITURA.
           ACCEPT COD-LIVRO-ED AT 1511.
           MOVE COD-LIVRO-ED TO COD-LIVRO
           READ ARQ-LIVRO.

       EXIBIR-DADOS-LIDOS.

           IF W-COD-ERRO NOT = "00"
               DISPLAY "LIVRO NAO ENCONTRADO" AT 2512
           ELSE
               DISPLAY TITULO-LIVRO AT 1711
               DISPLAY AUTOR-LIVRO  AT 1911
           END-IF.

       RECEBER-OPCAO-CONTINUIDADE.

           PERFORM WITH TEST AFTER UNTIL OPC-OK
               ACCEPT OPC AT 2125 WITH AUTO
               MOVE FUNCTION UPPER-CASE (OPC) TO OPC
               PERFORM LIMPAR-ESPACO-MENSAGEM
               IF  NOT OPC-OK
                   DISPLAY "DIGITE 'S' OU 'N'" AT 2512
               END-IF
           END-PERFORM.

       ABRIR-ARQUIVO.
           OPEN I-O ARQ-LIVRO.

       LIMPAR-ESPACO-MENSAGEM.
           DISPLAY W-BRANCO AT 2512.

       FINALIZACAO.
           CLOSE ARQ-LIVRO.
