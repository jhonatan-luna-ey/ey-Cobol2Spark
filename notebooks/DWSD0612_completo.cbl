DWSD0612******** Convertido de OS/VS COBOL p/ COBOL for OS/390 em 07/10/04 10:4800000001
       IDENTIFICATION DIVISION.                                         00000002
      *========================*                                        00000003
                                                                        00000004
       PROGRAM-ID.    DWSD0612.                                         00000005
       AUTHOR.        CLAUDIA MARIA.                                    00000006
                                                                        00000007
      *================================================================*00000008
      *                                                                *00000009
      *  PROJETO    : DWSD - DATAWAREHOUSE EM AMBIENTE MAINFRAME       *00000010
      *                                                                *00000011
      *               -----------------------------------------------  *00000012
      *  OBJETIVO   : ETL  - DIMENSAO ESTIPULANTE                      *00000013
      *               -----------------------------------------------  *00000014
      *                                                                *00000015
      *  TABELA USADAS : ATSAUDAO.SSCESTIPULANTE    (SSCF3339)         *00000016
      *                  DBSISA.DESC                (SISA3511)         *00000017
      *                                                                *00000018
      *  SAIDA      : DIMESTIP (ARQUIVO APOLICE ESTIPULANTE)           *00000019
      *                                                                *00000020
      *  EQUIPE     : EXTRACAO DW ( G & P )                            *00000021
      *                                                                *00000022
      *  DATA       : MARCO DE 2002                                    *00000023
      *  DATA       : JUNHO DE 2010 - 240610 - AUMENTO DE CASA DECIMAL *00000023
      *                                        APOLICE ATIVA DESC      *00000024
      *================================================================*00000025
      *================================================================*00000027
30468 * ALTERACAO :AJUSTAR OS PROCESSOS DE EXTRACAO, CARGA DE DADOS E  *
30468 *            APRESENTACAO NAS TELAS DE CONSULTAS COM A FINALIDADE*
30468 *            DE INCLUIR A MODALIDADE NOVA CIA DAS APOLICES       *
30468 *            ATRELADAS A ESSA MECANICA, PARA O SISTEMA SISA.     *
30468 * GD :             RESP: MJV               DATA: 22/08/2018      *
30468 *----------------------------------------------------------------*
170423* ALTERACAO :AJUSTAR O CAMPO DE APOLICE PARA 7 BYTES             *
170423*            PROJETO NUMERO DA APOLICE     MARCA: 170423         *
      *================================================================*
                                                                        00000026
      *----------------------------------------------------------------*00000027
       ENVIRONMENT DIVISION.                                            00000028
      *----------------------------------------------------------------*00000029
                                                                        00000030
       CONFIGURATION SECTION.                                           00000031
       SPECIAL-NAMES.                                                   00000032
                     DECIMAL-POINT IS COMMA.                            00000033
       INPUT-OUTPUT  SECTION.                                           00000034
       FILE-CONTROL.                                                    00000035
                                                                        00000036
           SELECT ARQPARM       ASSIGN    TO ARQPARM.                   00000037
                                                                        00000038
           SELECT ARQSORT       ASSIGN    TO ARQSORT.                   00000039
                                                                        00000040
           SELECT DIMESTIP      ASSIGN    TO DIMESTIP.                  00000041
                                                                        00000042
           SELECT ARQFTP        ASSIGN    TO ARQFTP.                    00000043
                                                                        00000044
      *----------------------------------------------------------------*00000045
       DATA DIVISION.                                                   00000046
       FILE SECTION.                                                    00000047
      *----------------------------------------------------------------*00000048
                                                                        00000049
       FD  ARQPARM                                                      00000050
           BLOCK CONTAINS 0 RECORDS                                     00000051
           RECORDING MODE IS F                                          00000052
           LABEL RECORD IS STANDARD.                                    00000053
                                                                        00000054
       01  REG-PARAMETRO                 PIC X(80).                     00000055
                                                                        00000056
                                                                        00000057
       SD  ARQSORT.                                                     00000058
                                                                        00000059
       01  REG-ARQSORT.                                                 00000060
           03 NUM-CGC-SORT               PIC 9(12).                     00000061
240610     03 DATA-CANCEL-SORT           PIC 9(08).                     00000062
           03 DATA-INIC-SORT             PIC 9(08).                     00000062
           03 FILLER   REDEFINES DATA-INIC-SORT.                        00000063
              05 ANO-INIC-SORT           PIC 9(04).                     00000064
              05 MES-INIC-SORT           PIC 9(02).                     00000065
              05 DIA-INIC-SORT           PIC 9(02).                     00000066
           03 NUM-DV-CGC-SORT            PIC 9(02).                     00000067
           03 COD-CIA-SORT               PIC 9(03).                     00000068
170423     03 COD-APOLICE-SORT           PIC 9(07).                     00000069
           03 NOME-ESTIP-SORT            PIC X(35).                     00000070
           03 COD-ATIV-SORT              PIC 9(04).                     00000071
                                                                        00000072
                                                                        00000073
       FD  DIMESTIP                                                     00000074
           BLOCK CONTAINS 0 RECORDS                                     00000075
           RECORDING MODE IS F                                          00000076
           LABEL RECORD IS STANDARD.                                    00000077
                                                                        00000078
170423 01  REG-ESTIPULANTE               PIC X(68).                     00000079
                                                                        00000080
       FD  ARQFTP                                                       00000081
           BLOCK CONTAINS 0 RECORDS                                     00000082
           RECORD CONTAINS 80                                           00000083
           RECORDING MODE IS F                                          00000084
           LABEL RECORDS IS STANDARD.                                   00000085
                                                                        00000086
       01  FTP-REGISTRO                 PIC X(80).                      00000087
                                                                        00000088
      *---------------------------------------------------------------* 00000089
       WORKING-STORAGE SECTION.                                         00000090
      *---------------------------------------------------------------* 00000091
                                                                        00000092
       77  WS-SDCDSUC                       PIC  9(003)    VALUE 0.     00000093
       77  WS-ABEND                  COMP   PIC S9(04)     VALUE +0777. 00000094
       77  WS-SQLCODE                       PIC ---------9 VALUE ZEROS. 00000095
       77  WS-QTDE-SUBF                     PIC S9(09) USAGE COMP.      00000096
       77  NCOB1660                         PIC  X(08) VALUE 'NCOB1660'.00000097
                                                                        00000098
      *    LINHAS PARA FTP                                              00000099
                                                                        00000100
       01  LN-FTP-01.                                                   00000101
           03 FILLER         PIC X(80) VALUE 'ANONYMOUS'.               00000102
       01  LN-FTP-02.                                                   00000103
           03 FILLER         PIC X(80) VALUE 'ANONYMOUS'.               00000104
       01  LN-FTP-03.                                                   00000105
           03 FILLER         PIC X(04) VALUE 'CD  '.                    00000106
           03 DIRETORIO      PIC X(76).                                 00000107
       01  LN-FTP-04.                                                   00000108
           03 FILLER         PIC X(04) VALUE 'LCD '.                    00000109
           03 FILLER         PIC X(01) VALUE ''''.                      00000110
           03 FILLER         PIC X(16) VALUE 'BS.DWSD.DWSD0619'.        00000111
           03 FILLER         PIC X(01) VALUE ''''.                      00000112
       01  LN-FTP-05.                                                   00000113
           03 FILLER         PIC X(80) VALUE                            00000114
              'PUT ESTIP ESTIP.TMP'.                                    00000115
       01  LN-FTP-06.                                                   00000116
           03 FILLER         PIC X(28) VALUE                            00000117
              'RENAME ESTIP.TMP DWSD_ESTIP_'.                           00000118
           03 LN-DATA        PIC 9(08).                                 00000119
           03 FILLER         PIC X(38) VALUE '.dat'.                    00000120
       01  LN-FTP-07.                                                   00000121
           03 FILLER         PIC X(80) VALUE 'CLOSE'.                   00000122
       01  LN-FTP-08.                                                   00000123
           03 FILLER         PIC X(80) VALUE 'QUIT'.                    00000124
                                                                        00000125
       01  WS-HORA-SISTEMA                  PIC X(06).                  00000126
       01  WS-HORA-SIST-R     REDEFINES     WS-HORA-SISTEMA.            00000127
           03 WS-HH-SIST                    PIC X(02).                  00000128
           03 WS-MM-SIST                    PIC X(02).                  00000129
           03 WS-SS-SIST                    PIC X(02).                  00000130
                                                                        00000131
       01  WS-HORA-CORRENTE                 PIC X(06).                  00000132
       01  WS-HORA-CORREN-R   REDEFINES     WS-HORA-CORRENTE.           00000133
           03 WS-HH-CORR                    PIC X(02).                  00000134
           03 WS-MM-CORR                    PIC X(02).                  00000135
           03 WS-SS-CORR                    PIC X(02).                  00000136
                                                                        00000137
       01  WS-HORA-DISPLAY                  PIC X(08).                  00000138
       01  WS-HORA-DISPLY-R REDEFINES WS-HORA-DISPLAY.                  00000139
           03 WS-HH-DISPLY                  PIC X(02).                  00000140
           03 WS-BR3-DISPLY                 PIC X(01).                  00000141
           03 WS-MM-DISPLY                  PIC X(02).                  00000142
           03 WS-BR4-DISPLY                 PIC X(01).                  00000143
           03 WS-SS-DISPLY                  PIC X(02).                  00000144
                                                                        00000145
       01  WS-DATA-SISTEMA                  PIC 9(08).                  00000146
       01  WS-DATA-SIST-R    REDEFINES      WS-DATA-SISTEMA.            00000147
           03 WS-SEC-SIST                   PIC 9(02).                  00000148
           03 WS-ANO-SIST                   PIC 9(02).                  00000149
           03 WS-MES-SIST                   PIC 9(02).                  00000150
           03 WS-DIA-SIST                   PIC 9(02).                  00000151
                                                                        00000152
       01  WS-DATA-CORRENTE                 PIC 9(08).                  00000153
       01  WS-DATA-CORR-R    REDEFINES      WS-DATA-CORRENTE.           00000154
           03 WS-MES-CORR                   PIC X(02).                  00000155
           03 FILLER                        PIC X(01).                  00000156
           03 WS-DIA-CORR                   PIC X(02).                  00000157
           03 FILLER                        PIC X(01).                  00000158
           03 WS-ANO-CORR                   PIC X(02).                  00000159
                                                                        00000160
       01  WS-DATA-DISPLAY                  PIC X(10).                  00000161
       01  WS-DATA-DISP-R    REDEFINES      WS-DATA-DISPLAY.            00000162
           03 WS-DIA-DISPLAY                PIC X(02).                  00000163
           03 WS-BR1-DISPLAY                PIC X(01).                  00000164
           03 WS-MES-DISPLAY                PIC X(02).                  00000165
           03 WS-BR2-DISPLAY                PIC X(01).                  00000166
           03 WS-SEC-DISPLAY                PIC X(02).                  00000167
           03 WS-ANO-DISPLAY                PIC X(02).                  00000168
                                                                        00000169
       01  WS-DATA-INIC                     PIC 9(08).                  00000170
       01  WS-DATA-INIC-R    REDEFINES      WS-DATA-INIC.               00000171
           03 WS-DIA-INIC                   PIC X(02).                  00000172
           03 WS-MES-INIC                   PIC X(02).                  00000173
           03 WS-SEC-INIC                   PIC X(02).                  00000174
           03 WS-ANO-INIC                   PIC X(02).                  00000175
                                                                        00000176
       01  WS-DATA-INIC-INV                 PIC 9(08).                  00000177
       01  WS-DATA-INIC-INV-R REDEFINES     WS-DATA-INIC-INV.           00000178
           03 WS-SEC-INV                    PIC X(02).                  00000179
           03 WS-ANO-INV                    PIC X(02).                  00000180
           03 WS-MES-INV                    PIC X(02).                  00000181
           03 WS-DIA-INV                    PIC X(02).                  00000182
                                                                        00000183
       01  DATA-INI-SEL                     PIC S9(09) COMP.            00000184
       01  DATA-FIM-SEL                     PIC S9(09) COMP.            00000185
                                                                        00000186
       01  WS-DATA-INI                      PIC  9(08).                 00000187
       01  FILLER         REDEFINES    WS-DATA-INI.                     00000188
           03 WS-ANO-INI                    PIC 9(04).                  00000189
           03 WS-MES-INI                    PIC 9(02).                  00000190
           03 WS-DIA-INI                    PIC 9(02).                  00000191
                                                                        00000192
       01  WS-DATA-FIM                      PIC  9(08).                 00000193
       01  FILLER         REDEFINES      WS-DATA-FIM.                   00000194
           03 WS-ANO-FIM                    PIC 9(04).                  00000195
           03 WS-MES-FIM                    PIC 9(02).                  00000196
           03 WS-DIA-FIM                    PIC 9(02).                  00000197
                                                                        00000198
       01  WS-DESC-NM-CHAVE.                                            00000199
           03 WS-DESC-NM-CHAVE-CIA          PIC 9(03).                  00000200
           03 WS-DESC-NM-CHAVE-APO          PIC 9(06).                  00000201
       01  WS-DESC-NM-CHAVE-R REDEFINES WS-DESC-NM-CHAVE PIC X(11).     00000202
                                                                        00000203
170423 01  WS-DESC-NM-CHAVE-7.
170423     03 WS-DESC-NM-CHAVE-CIA-7        PIC 9(03) VALUE ZEROS.
170423     03 WS-DESC-NM-CHAVE-APO-7        PIC 9(07) VALUE ZEROS.

170423 01  WS-MOVI-NM-COMPL-REAV            PIC X(150) VALUE SPACES.
170423 01  WS-MOVI-NM-COMPL-REAV-R REDEFINES WS-MOVI-NM-COMPL-REAV.
170423     03 WS-AAAAMMDD-CORTE-REAV        PIC 9(08).
170423     03 FILLER                        PIC X(142).

       01  WS-CONTADORES.                                               00000204
           03 WS-QTDE-ETP                   PIC 9(09) VALUE ZEROS.      00000205
           03 WS-LIDOS-SORT                 PIC 9(09) VALUE ZEROS.      00000206
           03 WS-LIDOS-CURSOR-ATETP         PIC 9(09) VALUE ZEROS.      00000207
           03 WS-LIDOS-CURSOR-DBETP         PIC 9(09) VALUE ZEROS.      00000208
           03 WS-CONT-CGC-ZERADOS           PIC 9(09) VALUE ZEROS.      00000209
           03 WS-CGC-ZERADOS-ZZZ            PIC ZZZ.ZZZ.ZZ9.            00000210
           03 WS-LIDOS-ZZZ-ATETP            PIC ZZZ.ZZZ.ZZ9.            00000211
           03 WS-LIDOS-ZZZ-DBETP            PIC ZZZ.ZZZ.ZZ9.            00000212
           03 WS-GRAVADOS-ETP               PIC 9(09) VALUE ZEROS.      00000213
           03 WS-GRAVADOS-SORT              PIC 9(09) VALUE ZEROS.      00000214
           03 WS-GRAVA-ZZZ                  PIC ZZZ.ZZZ.ZZ9.            00000215
                                                                        00000216
       01  AUXILIARES.                                                  00000217
           03 WS-FIM-SORT                   PIC X(03)      VALUE 'NAO'. 00000218
           03 WS-COMANDO                    PIC X(30)      VALUE SPACES.00000219
           03 WS-CGC-ANT                    PIC 9(12)      VALUE ZEROS. 00000220
           03 WS-DATA-INIC-ANT              PIC 9(08)      VALUE ZEROS. 00000221
           03 WS-DV-CGC-ANT                 PIC 9(02)      VALUE ZEROS. 00000222
           03 WS-COD-CIA-ANT                PIC 9(03)      VALUE ZEROS. 00000223
170423     03 WS-COD-APOL-ANT               PIC 9(07)      VALUE ZEROS. 00000224
           03 WS-NOME-ESTIP-ANT             PIC X(35)      VALUE SPACES.00000225
           03 WS-COD-ATIV-ANT               PIC 9(04)      VALUE ZEROS. 00000226
                                                                        00000227
       01  WS-CGC-INTEIRO                   PIC 9(14).                  00000228
       01  FILLER          REDEFINES     WS-CGC-INTEIRO.                00000229
           03 WS-CGC-SDV                    PIC 9(12).                  00000230
           03 WS-CGC-DV                     PIC 9(02).                  00000231
                                                                        00000232
       01  WS-IDENT-APOL.                                               00000233
           03 WS-CIA                        PIC 9(03).                  00000234
170423     03 WS-APOLICE                    PIC 9(07).                  00000235
170423 01  WS-IDENT-APOL-R REDEFINES WS-IDENT-APOL PIC X(10).           00000236
                                                                        00000237
       01  WS-CODIGO-CNPJ.                                              00000238
           03 WS-COD-BASE                   PIC 9(08).                  00000239
           03 WS-COD-FILIAL                 PIC 9(04).                  00000240
       01  WS-CODIGO-CNPJ-R REDEFINES WS-CODIGO-CNPJ PIC X(12).         00000241
                                                                        00000242
      *---------------------------------------------------------------* 00000243
                                                                        00000244
       01  WS-CAMPOS-ATSAUDAO-ETP.                                      00000245
           03 WS-CIA-ATSAUDAO               PIC S9(04)  USAGE COMP.     00000246
           03 WS-APOLICE-ATSAUDAO           PIC S9(09)  USAGE COMP.     00000247
           03 WS-RSOCIAL-ATSAUDAO           PIC  X(35).                 00000248
           03 WS-CGC-ATSAUDAO               PIC  9(15).                 00000249
           03 FILLER REDEFINES WS-CGC-ATSAUDAO.                         00000250
              05 FILLER                     PIC  X(01).                 00000251
              05 WS-CGC-SDV-ATSAUDAO        PIC  9(12).                 00000252
              05 WS-CGC-DV-ATSAUDAO         PIC  9(02).                 00000253
           03 WS-CODIGO-ATIV-ATSAUDAO       PIC S9(04)  USAGE COMP.     00000254
           03 WS-RMO-ATSAUDAO               PIC S9(03)  USAGE COMP.     00000255
           03 WS-AMD-INICIO-ATSAUDAO        PIC S9(09)  USAGE COMP.     00000256
                                                                        00000257
      *---------------------------------------------------------------* 00000258
                                                                        00000259
       01  WS-CAMPOS-DBSAUDE-ETP.                                       00000260
           03 WS-CIA-DBSAUDE                PIC S9(04)  USAGE COMP.     00000261
           03 WS-APOLICE-DBSAUDE            PIC S9(09)  USAGE COMP.     00000262
           03 WS-NOME-DBSAUDE               PIC  X(35).                 00000263
           03 WS-CGC-DBSAUDE                PIC  9(15).                 00000264
           03 FILLER REDEFINES WS-CGC-DBSAUDE.                          00000265
              05 FILLER                     PIC  X(01).                 00000266
              05 WS-CGC-SDV-DBSAUDE         PIC  9(12).                 00000267
              05 WS-CGC-DV-DBSAUDE          PIC  9(02).                 00000268
           03 WS-DT-INICIO-DBSAUDE          PIC S9(09)V USAGE COMP-3.   00000269
                                                                        00000270
      *---------------------------------------------------------------* 00000271
      *                 LAYOUT DO ARQUIVO DE PARAMETRO                * 00000272
      *---------------------------------------------------------------* 00000273
           COPY DWSD1001.                                               00000274
      *        *****************************************                00000066
      *        DWSDS1001- LAYOUT DO ARQUIVO DE PARAMETRO                00000067
      *        *****************************************                00000068
      *                                                                 00000087
      * ATUALIZACOES DE DATAS NO ARQUIVO PELO PROGRAMA DWSD0669         00000088
      *             QUE GERA O ARQUIVO PARAMETRO:                       00000089
      *                                                                 00000090
      * QUANDO OPCAO1 = 'E' TODAS AS DATAS SAO ATUALIZADAS  CONFORME    00000091
      *                     O PARAMETRO                                 00000092
      *                                                                 00000093
      * QUANDO OPCAO1 = 'D' SAO ATUALIZADAS CONFORME ABAIXO :           00000094
      *                                                                 00000095
      * DATA DE CORTE................. NAO E ATUALIZADA                 00000096
      * DATA INICIO DO PERIODO........ ATUALIZADA QUANDO OPCAO2 = 'I'   00000097
      * DATA FIM DO PERIODO........... ATUALIZADA QUANDO OPCAO2 = 'I'   00000098
      * DATA DE PROCESSAMENTO......... ATUALIZADA QUANDO OPCAO2 = 'I'   00000099
      * DATA DO PROXIMO PROCESSAMENTO. ATUALIZADA QUANDO OPCAO2 = 'F'   00000100
      * MES A PROCESSAR NA MENSAL..... ATUALIZADA QUANDO OPCAO2 = 'I'   00000101
      *                                E ULTIMO PROCESSAMENTO MENSAL'   00000102
      * PROXIMO MES DA MENSAL......... ATUALIZADA QUANDO OPCAO2 = 'F'   00000103
      *                                E ULTIMO PROCESSAMENTO  MENSAL   00000104
      * DATA INICIO PARA MENSAL....... ATUALIZADA QUANDO O MES A PRO-   00000105
      *                                CESSAR NA MENSAL FOR ATUALIZA-   00000106
      *                                DO                               00000107
      * DATA  FIM   PARA MENSAL....... ATUALIZADA  JUNTAMENTE  COM  A   00000108
      *                                DATA INICIO PARA MENSAL          00000109
      *--------------------------------------------------------------   00000117
                                                                        00000118
       01  REGISTRO-PARAMETRO.                                          00000127
           03 DATA-CORTE                      PIC 9(008).               00000128
           03 FILLER      REDEFINES    DATA-CORTE.                      00000129
              05 ANO-CORTE                    PIC 9(004).               00000130
              05 MES-CORTE                    PIC 9(002).               00000131
              05 DIA-CORTE                    PIC 9(002).               00000132
           03 FILLER      REDEFINES    DATA-CORTE.                      00000133
              05 SEC-CORTE                    PIC 9(002).               00000134
              05 FILLER                       PIC 9(006).               00000135
           03 DATA-INI                        PIC 9(008).               00000137
           03 FILLER      REDEFINES    DATA-INI.                        00000138
              05 ANO-INI                      PIC 9(004).               00000139
              05 MES-INI                      PIC 9(002).               00000140
              05 DIA-INI                      PIC 9(002).               00000141
           03 FILLER      REDEFINES    DATA-INI.                        00000142
              05 SEC-INI                      PIC 9(002).               00000143
              05 FILLER                       PIC 9(006).               00000144
           03 DATA-FIM                        PIC 9(008).               00000145
           03 FILLER      REDEFINES    DATA-FIM.                        00000146
              05 ANO-FIM                      PIC 9(004).               00000147
              05 MES-FIM                      PIC 9(002).               00000148
              05 DIA-FIM                      PIC 9(002).               00000149
           03 FILLER      REDEFINES    DATA-FIM.                        00000150
              05 SEC-FIM                      PIC 9(002).               00000151
              05 FILLER                       PIC 9(006).               00000152
           03 DATA-PROC                       PIC 9(008).               00000153
           03 FILLER      REDEFINES    DATA-PROC.                       00000154
              05 ANO-PROC                     PIC 9(004).               00000155
              05 MES-PROC                     PIC 9(002).               00000156
              05 DIA-PROC                     PIC 9(002).               00000157
           03 FILLER      REDEFINES    DATA-PROC.                       00000158
              05 SEC-PROC                     PIC 9(002).               00000159
              05 FILLER                       PIC 9(006).               00000160
           03 DATA-PROX                       PIC 9(008).               00000161
           03 FILLER      REDEFINES    DATA-PROX.                       00000162
              05 ANO-PROX                     PIC 9(004).               00000163
              05 MES-PROX                     PIC 9(002).               00000164
              05 DIA-PROX                     PIC 9(002).               00000165
           03 FILLER      REDEFINES    DATA-PROX.                       00000166
              05 SEC-PROX                     PIC 9(002).               00000167
              05 FILLER                       PIC 9(006).               00000168
           03 DATA-PROC-MENSAL                PIC 9(006).               00000169
           03 FILLER      REDEFINES    DATA-PROC-MENSAL.                00000170
              05 ANO-PROC-MENSAL              PIC 9(004).               00000171
              05 MES-PROC-MENSAL              PIC 9(002).               00000172
           03 FILLER      REDEFINES    DATA-PROC-MENSAL.                00000173
              05 SEC-PROC-MENSAL              PIC 9(002).               00000174
              05 FILLER                       PIC 9(004).               00000175
           03 DATA-PROX-MENSAL                PIC 9(006).               00000176
           03 FILLER      REDEFINES    DATA-PROX-MENSAL.                00000177
              05 ANO-PROX-MENSAL              PIC 9(004).               00000178
              05 MES-PROX-MENSAL              PIC 9(002).               00000179
           03 FILLER      REDEFINES    DATA-PROX-MENSAL.                00000180
              05 SEC-PROX-MENSAL              PIC 9(002).               00000181
              05 FILLER                       PIC 9(004).               00000182
           03 DATA-INI-PROC-MENSAL            PIC 9(008).               00000183
           03 FILLER      REDEFINES    DATA-INI-PROC-MENSAL.            00000184
              05 ANO-INI-PROC-MENSAL          PIC 9(004).               00000185
              05 MES-INI-PROC-MENSAL          PIC 9(002).               00000186
              05 DIA-INI-PROC-MENSAL          PIC 9(002).               00000187
           03 FILLER      REDEFINES    DATA-INI-PROC-MENSAL.            00000188
              05 SEC-INI-PROC-MENSAL          PIC 9(002).               00000189
              05 FILLER                       PIC 9(006).               00000190
           03 DATA-FIM-PROC-MENSAL            PIC 9(008).               00000191
           03 FILLER      REDEFINES    DATA-FIM-PROC-MENSAL.            00000192
              05 ANO-FIM-PROC-MENSAL          PIC 9(004).               00000193
              05 MES-FIM-PROC-MENSAL          PIC 9(002).               00000194
              05 DIA-FIM-PROC-MENSAL          PIC 9(002).               00000195
           03 FILLER      REDEFINES    DATA-FIM-PROC-MENSAL.            00000196
              05 SEC-FIM-PROC-MENSAL          PIC 9(002).               00000197
              05 FILLER                       PIC 9(006).               00000198
           03 ULTIMA-OPCAO1                   PIC X(001).               00000199
           03 ULTIMA-OPCAO2                   PIC X(001).               00000200
                                                                        00000201
                                                                        00000275
      *---------------------------------------------------------------* 00000276
      *  LAYOUT DO ARQUIVO DE SAIDA ESTIPULANTE RAMOS 875/876/878     * 00000277
      *---------------------------------------------------------------* 00000278
                                                                        00000279
170423 01  REGISTRO-ESTIP                     PIC X(68).                00000280
       01  REG-HEADER-ETP        REDEFINES    REGISTRO-ESTIP.           00000281
           03 TIPO-REG-H-ETP                  PIC 9(01).                00000282
           03 DATA-SISTEMA-H-ETP              PIC 9(08).                00000283
           03 HORA-SISTEMA-H-ETP              PIC 9(06).                00000284
           03 DATA-INI-H-ETP                  PIC 9(08).                00000285
           03 DATA-FIM-H-ETP                  PIC 9(08).                00000286
           03 NOME-PGM-H-ETP                  PIC X(08).                00000287
170423     03 FILLER                          PIC X(29).                00000288
       01  REG-DETALHE-ETP       REDEFINES    REGISTRO-ESTIP.           00000289
           03 TIPO-REG-D-ETP                  PIC 9(01).                00000290
           03 COD-ORIGEM-D-ETP                PIC 9(04).                00000291
170423     03 IDENT-APOLICE-D-ETP             PIC 9(10).                00000292
           03 NOME-ESTIPULANTE-D-ETP          PIC X(35).                00000293
           03 CHAVE-OLTP.                                               00000294
              05 CODIGO-BASE-D-ETP            PIC 9(08).                00000295
              05 CODIGO-FILIAL-D-ETP          PIC 9(04).                00000296
           03 CODIGO-DV-D-ETP                 PIC 9(02).                00000297
           03 IDENT-RAMO-ATIV-D-ETP           PIC 9(04).                00000298
       01  REG-TRAILLER-ETP      REDEFINES    REGISTRO-ESTIP.           00000299
           03 TIPO-REG-T-ETP                  PIC 9(01).                00000300
           03 DATA-SISTEMA-T-ETP              PIC 9(08).                00000301
           03 HORA-SISTEMA-T-ETP              PIC 9(06).                00000302
           03 QTDE-REGISTROS-T-ETP            PIC 9(09).                00000303
170423     03 FILLER                          PIC X(44).                00000304
                                                                        00000305
      *---------------------------------------------------------------* 00000306
      *          DEFINICAO DA AREA DE MENSAGEM DE ERRO DO DB2         * 00000307
      *---------------------------------------------------------------* 00000308
                                                                        00000309
       01  WS-SQLCA.                                                    00000310
           03 WS-SQLCAID                    PIC X(08)      VALUE SPACES.00000311
           03 WS-SQLCABC                    PIC ---------9.             00000312
           03 WS-SQLERRML                   PIC ---------9.             00000313
           03 WS-SQLERRP                    PIC ---------9.             00000314
           03 WS-SQLERRMC                   PIC X(70)      VALUE SPACES.00000315
           03 WS-SQLERRD   OCCURS 6 TIMES   PIC S9(09).                 00000316
           03 WS-SQLWARN1                   PIC X          VALUE SPACES.00000317
           03 WS-SQLWARN2                   PIC X          VALUE SPACES.00000318
           03 WS-SQLWARN3                   PIC X          VALUE SPACES.00000319
           03 WS-SQLWARN4                   PIC X          VALUE SPACES.00000320
           03 WS-SQLWARN5                   PIC X          VALUE SPACES.00000321
           03 WS-SQLWARN6                   PIC X          VALUE SPACES.00000322
           03 WS-SQLWARN7                   PIC X          VALUE SPACES.00000323
           03 WS-SQLEXT                     PIC X(08)      VALUE SPACES.00000324
                                                                        00000325
      *----------------------------------------------------------------*00000326
      *    BOOK CORPORATIVO DE UTILIZACAO GENERICA                     *00000327
      *----------------------------------------------------------------*00000328
                                                                        00000329
JAPI-U     COPY 'NCOB1410'.                                             00000330
      ******************************************************************00000001
      *                                                                *00000002
      *                       N C O B 1 4 1 0                          *00000003
      *                       ---------------                          *00000004
      *                                                                *00000005
      *     ======> INCLUDE PARA ROTINA DE ACESSO AO DB2 <=======      *00000006
      *                                                                *00000007
      *    1. NCOB1410 - MANEIRA DE USAR                               *00000008
      *      A - NO INICIO DA PROCEDURE DIVISION, ANTES DO PRIMEIRO    *00000009
      *          COMANDO SQL :                                         *00000010
      *              MOVE 'XXXXXXXX' TO SQL-PLAN                       *00000011
      *              CALL 'DSNALI' USING SQL-OPEN SQL-SSID SQL-PLAN.   *00000012
      *          ONDE      'XXXXXXXX'  E' O NOME DO PROGRAMA.          *00000013
      *      B - NO FINAL DO PROGRAMA, ANTES DO STOP RUN :             *00000014
      *              CALL 'DSNALI' USING SQL-CLOSE SQL-SYNC.           *00000015
      *      C - ANTES DE QUALQUER TERMINO ANORMAL DE PROGRAMA :       *00000016
      *              CALL 'DSNALI' USING SQL-CLOSE SQL-ABRT.           *00000017
      ******************************************************************00000027
                                                                        00000028
       01  SQL-PARAMETROS.                                              00000029
           03  SQL-OPEN           PIC X(12)       VALUE 'OPEN'.         00000030
           03  SQL-SSID           PIC X(04)       VALUE 'DSN'.          00000031
           03  SQL-CLOSE          PIC X(12)       VALUE 'CLOSE'.        00000032
           03  SQL-SYNC           PIC X(04)       VALUE 'SYNC'.         00000033
           03  SQL-ABRT           PIC X(04)       VALUE 'ABRT'.         00000034
           03  SQL-PLAN           PIC X(08)       VALUE ' '.            00000035
           03  SQL-RCOD           PIC S9(9) COMP  VALUE +0.             00000036
           03  SQL-RESON          PIC X(04)       VALUE ' '.            00000037
           03  SQL-TRANSLATE      PIC X(12)       VALUE 'TRANSLATE'.    00000038
           03  SQL-CONNECT        PIC X(12)       VALUE 'CONNECT'.      00000039
           03  SQL-DISCONNECT     PIC X(12)       VALUE 'DISCONNECT'.   00000040
           03  SQL-TECB-DB2       PIC S9(9) COMP  VALUE +0.             00000041
           03  SQL-SECB-DB2       PIC S9(9) COMP  VALUE +0.             00000042
           03  SQL-RIBT-DB2       PIC S9(9) COMP  VALUE +0.             00000043
                                                                        00000044
                                                                        00000331
      *----------------------------------------------------------------*00000332
      *    INCLUDES DAS TABELAS DB2  (CMDS E VIEWS)                    *00000333
      *----------------------------------------------------------------*00000334
                                                                        00000335
           EXEC SQL                                                     00000336
                INCLUDE SQLCA                                           00000337
           END-EXEC.                                                    00000338
                                                                        00000339
30468 *----------------------------------------------------------------*00000433
30468 *    INCLUDE DA TABELA ATSAUDAO.SSCESTIPULANTE                   *00000434
30468 *----------------------------------------------------------------*00000435
                                                                        00000436
30468      EXEC SQL                                                     00000437
30468           INCLUDE SSCF3039                                        00000438
30468      END-EXEC.                                                    00000439
      ******************************************************************
      * DCLGEN TABLE(ATSAUDAO.SSCESTIPULANTE)                          *
      *        LIBRARY(ANPR.DCLGEN(SSCF3039))                          *
      *        ACTION(REPLACE)                                         *
      *        LANGUAGE(COBOL)                                         *
      *        QUOTE                                                   *
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *
      ******************************************************************
           EXEC SQL DECLARE ATSAUDAO.SSCESTIPULANTE TABLE
           ( ETP_CIA                        SMALLINT NOT NULL,
             ETP_APOLICE                    INTEGER NOT NULL,
             ETP_DT_INICIO                  DECIMAL(7, 0) NOT NULL,
             ETP_RSOCIAL                    CHAR(35) NOT NULL,
             ETP_ENDERECO                   CHAR(50) NOT NULL,
             ETP_CEP                        INTEGER NOT NULL,
             ETP_CIDADE                     CHAR(20) NOT NULL,
             ETP_UF                         CHAR(2) NOT NULL,
             ETP_CGC                        DECIMAL(15, 0) NOT NULL,
             ETP_TP_APOLICE                 DECIMAL(1, 0) NOT NULL,
             ETP_NSUBF                      SMALLINT NOT NULL,
             ETP_ULT_CMPRV                  INTEGER NOT NULL,
             ETP_GERA_CMPRV                 DECIMAL(1, 0) NOT NULL,
             ETP_SITUACAO                   DECIMAL(1, 0) NOT NULL,
             ETP_DATA_CANCEL                DECIMAL(7, 0) NOT NULL,
             ETP_PREMIO_OTN                 DECIMAL(1, 0) NOT NULL,
             ETP_COBRANCA_OTN               DECIMAL(1, 0) NOT NULL,
             ETP_CALC_SIN_ADM               DECIMAL(1, 0) NOT NULL,
             ETP_RSOCIAL_CARD               DECIMAL(1, 0) NOT NULL,
             ETP_COBRANCA_ANT               DECIMAL(1, 0) NOT NULL,
             ETP_DT_RENOVACAO               DECIMAL(7, 0) NOT NULL,
             ETP_DT_INICIO_DIC              DECIMAL(7, 0) NOT NULL,
             ETP_CODIGO_ATIV                SMALLINT NOT NULL,
             ETP_DT_INI                     DECIMAL(8, 0) NOT NULL,
             ETP_DT_ACEITE                  DECIMAL(8, 0) NOT NULL,
             ETP_CD_DISP                    DECIMAL(2, 0) NOT NULL,
             ETP_CD_ORI                     CHAR(8) NOT NULL,
             ETP_ID_RESP                    INTEGER NOT NULL,
             ETP_CD_MOTIVOFIM               DECIMAL(2, 0) NOT NULL,
             ETP_DIA_VENC_NSEG              DECIMAL(2, 0) NOT NULL,
             ETP_RMO                        DECIMAL(3, 0) NOT NULL,
             ETP_NOME_ABREV                 CHAR(21) NOT NULL,
             ETP_SUC                        DECIMAL(3, 0) NOT NULL,
             ETP_DIA_FAT                    DECIMAL(2, 0) NOT NULL,
             ETP_PRAZO_RENOV                DECIMAL(1, 0) NOT NULL,
             ETP_ORDENACAO                  DECIMAL(1, 0) NOT NULL,
             ETP_TP_FATURA                  DECIMAL(1, 0) NOT NULL,
             ETP_AAAAMM_FAT                 DECIMAL(6, 0) NOT NULL,
             ETP_TERMINAL                   CHAR(8) NOT NULL,
             ETP_EMIT_CERT                  DECIMAL(1, 0) NOT NULL,
             ETP_GERA_FATURA                DECIMAL(1, 0) NOT NULL,
             ETP_DCL_SAUDE                  DECIMAL(1, 0) NOT NULL,
             ETP_POSCAD_MAGN                DECIMAL(1, 0) NOT NULL,
             ETP_PERC_ADM                   DECIMAL(5, 2) NOT NULL,
             ETP_PERC_DESC                  DECIMAL(5, 2) NOT NULL,
             ETP_PERC_BONUS                 DECIMAL(5, 2) NOT NULL,
             ETP_CARENCIAS                  SMALLINT NOT NULL,
             ETP_NUMFAT                     SMALLINT NOT NULL,
             ETP_QTDFUNCEXCL                SMALLINT NOT NULL,
             ETP_MASSA                      SMALLINT NOT NULL,
             ETP_CATEGORIA                  CHAR(1) NOT NULL,
             ETP_TIPO_ADESAO                DECIMAL(1, 0) NOT NULL,
             ETP_DTVENCGUIA                 INTEGER NOT NULL,
             ETP_LIBERADO_FAT               DECIMAL(1, 0) NOT NULL,
             ETP_APO_MESTRE                 INTEGER NOT NULL,
             ETP_APO_CONJUGADA              INTEGER NOT NULL,
             ETP_GERA_CARTAO                DECIMAL(1, 0) NOT NULL,
             ETP_GERA_POSCAD                DECIMAL(1, 0) NOT NULL,
             ETP_GERA_SINISTRO              DECIMAL(1, 0) NOT NULL,
             ETP_PARTICIP_MAGN              DECIMAL(1, 0) NOT NULL,
             ETP_SINISTRO_MAGN              DECIMAL(1, 0) NOT NULL,
             ETP_GERA_PARTICIP              DECIMAL(1, 0) NOT NULL,
             ETP_IN_DTLIMITE                DECIMAL(1, 0) NOT NULL,
             ETP_IN_TXADM                   DECIMAL(1, 0) NOT NULL,
             ETP_IN_PERCAPITA               DECIMAL(1, 0) NOT NULL,
             ETP_CRITICA_DV                 DECIMAL(1, 0) NOT NULL,
             ETP_AMD_INICIO                 INTEGER NOT NULL,
             ETP_AMD_CANCEL                 INTEGER NOT NULL,
             ETP_AMD_RENOVACAO              INTEGER NOT NULL,
             ETP_AMD_INICIO_DIC             INTEGER NOT NULL,
             ETP_IN_REMISSAO                SMALLINT NOT NULL,
             ETP_NR_ANOS_REMIS              SMALLINT NOT NULL,
             ETP_TP_REAVALIA                SMALLINT NOT NULL,
             ETP_CRITMOV_MAGN               DECIMAL(1, 0) NOT NULL,
             CSRAMO_ESTTE                   SMALLINT NOT NULL,
             CDDD_ESTTE                     CHAR(6) NOT NULL,
             CFONE_ESTTE                    DECIMAL(11, 0) NOT NULL,
             CPRIM_RMAL_ESTTE               DECIMAL(8, 0) NOT NULL,
             CSEGDA_DDD_ESTTE               DECIMAL(6, 0) NOT NULL,
             CSEGDA_FONE_ESTTE              DECIMAL(11, 0) NOT NULL,
             CSEGDA_RMAL_ESTTE              DECIMAL(8, 0) NOT NULL,
             IBAIRO_ESTTE                   VARCHAR(25) NOT NULL,
             REMAIL_ESTTE                   VARCHAR(256) NOT NULL,
             CSIT_ACEIT_AGRDO               DECIMAL(1, 0) NOT NULL,
ALPO         QMES_RENOV_CATAO               DECIMAL(3, 0) NOT NULL,
030468       COPER_PLANO_SAUDE              DECIMAL(6, 0) NOT NULL
           ) END-EXEC.
      ******************************************************************
      * COBOL DECLARATION FOR TABLE ATSAUDAO.SSCESTIPULANTE            *
      ******************************************************************
       01  DCLSSCESTIPULANTE.
           10 ETP-CIA              PIC S9(4) USAGE COMP.
           10 ETP-APOLICE          PIC S9(9) USAGE COMP.
           10 ETP-DT-INICIO        PIC S9(7)V USAGE COMP-3.
           10 ETP-RSOCIAL          PIC X(35).
           10 ETP-ENDERECO         PIC X(50).
           10 ETP-CEP              PIC S9(9) USAGE COMP.
           10 ETP-CIDADE           PIC X(20).
           10 ETP-UF               PIC X(2).
           10 ETP-CGC              PIC S9(15)V USAGE COMP-3.
           10 ETP-TP-APOLICE       PIC S9(1)V USAGE COMP-3.
           10 ETP-NSUBF            PIC S9(4) USAGE COMP.
           10 ETP-ULT-CMPRV        PIC S9(9) USAGE COMP.
           10 ETP-GERA-CMPRV       PIC S9(1)V USAGE COMP-3.
           10 ETP-SITUACAO         PIC S9(1)V USAGE COMP-3.
           10 ETP-DATA-CANCEL      PIC S9(7)V USAGE COMP-3.
           10 ETP-PREMIO-OTN       PIC S9(1)V USAGE COMP-3.
           10 ETP-COBRANCA-OTN     PIC S9(1)V USAGE COMP-3.
           10 ETP-CALC-SIN-ADM     PIC S9(1)V USAGE COMP-3.
           10 ETP-RSOCIAL-CARD     PIC S9(1)V USAGE COMP-3.
           10 ETP-COBRANCA-ANT     PIC S9(1)V USAGE COMP-3.
           10 ETP-DT-RENOVACAO     PIC S9(7)V USAGE COMP-3.
           10 ETP-DT-INICIO-DIC    PIC S9(7)V USAGE COMP-3.
           10 ETP-CODIGO-ATIV      PIC S9(4) USAGE COMP.
           10 ETP-DT-INI           PIC S9(8)V USAGE COMP-3.
           10 ETP-DT-ACEITE        PIC S9(8)V USAGE COMP-3.
           10 ETP-CD-DISP          PIC S9(2)V USAGE COMP-3.
           10 ETP-CD-ORI           PIC X(8).
           10 ETP-ID-RESP          PIC S9(9) USAGE COMP.
           10 ETP-CD-MOTIVOFIM     PIC S9(2)V USAGE COMP-3.
           10 ETP-DIA-VENC-NSEG    PIC S9(2)V USAGE COMP-3.
           10 ETP-RMO              PIC S9(3)V USAGE COMP-3.
           10 ETP-NOME-ABREV       PIC X(21).
           10 ETP-SUC              PIC S9(3)V USAGE COMP-3.
           10 ETP-DIA-FAT          PIC S9(2)V USAGE COMP-3.
           10 ETP-PRAZO-RENOV      PIC S9(1)V USAGE COMP-3.
           10 ETP-ORDENACAO        PIC S9(1)V USAGE COMP-3.
           10 ETP-TP-FATURA        PIC S9(1)V USAGE COMP-3.
           10 ETP-AAAAMM-FAT       PIC S9(6)V USAGE COMP-3.
           10 ETP-TERMINAL         PIC X(8).
           10 ETP-EMIT-CERT        PIC S9(1)V USAGE COMP-3.
           10 ETP-GERA-FATURA      PIC S9(1)V USAGE COMP-3.
           10 ETP-DCL-SAUDE        PIC S9(1)V USAGE COMP-3.
           10 ETP-POSCAD-MAGN      PIC S9(1)V USAGE COMP-3.
           10 ETP-PERC-ADM         PIC S9(3)V9(2) USAGE COMP-3.
           10 ETP-PERC-DESC        PIC S9(3)V9(2) USAGE COMP-3.
           10 ETP-PERC-BONUS       PIC S9(3)V9(2) USAGE COMP-3.
           10 ETP-CARENCIAS        PIC S9(4) USAGE COMP.
           10 ETP-NUMFAT           PIC S9(4) USAGE COMP.
           10 ETP-QTDFUNCEXCL      PIC S9(4) USAGE COMP.
           10 ETP-MASSA            PIC S9(4) USAGE COMP.
           10 ETP-CATEGORIA        PIC X(1).
           10 ETP-TIPO-ADESAO      PIC S9(1)V USAGE COMP-3.
           10 ETP-DTVENCGUIA       PIC S9(9) USAGE COMP.
           10 ETP-LIBERADO-FAT     PIC S9(1)V USAGE COMP-3.
           10 ETP-APO-MESTRE       PIC S9(9) USAGE COMP.
           10 ETP-APO-CONJUGADA    PIC S9(9) USAGE COMP.
           10 ETP-GERA-CARTAO      PIC S9(1)V USAGE COMP-3.
           10 ETP-GERA-POSCAD      PIC S9(1)V USAGE COMP-3.
           10 ETP-GERA-SINISTRO    PIC S9(1)V USAGE COMP-3.
           10 ETP-PARTICIP-MAGN    PIC S9(1)V USAGE COMP-3.
           10 ETP-SINISTRO-MAGN    PIC S9(1)V USAGE COMP-3.
           10 ETP-GERA-PARTICIP    PIC S9(1)V USAGE COMP-3.
           10 ETP-IN-DTLIMITE      PIC S9(1)V USAGE COMP-3.
           10 ETP-IN-TXADM         PIC S9(1)V USAGE COMP-3.
           10 ETP-IN-PERCAPITA     PIC S9(1)V USAGE COMP-3.
           10 ETP-CRITICA-DV       PIC S9(1)V USAGE COMP-3.
           10 ETP-AMD-INICIO       PIC S9(9) USAGE COMP.
           10 ETP-AMD-CANCEL       PIC S9(9) USAGE COMP.
           10 ETP-AMD-RENOVACAO    PIC S9(9) USAGE COMP.
           10 ETP-AMD-INICIO-DIC   PIC S9(9) USAGE COMP.
           10 ETP-IN-REMISSAO      PIC S9(4) USAGE COMP.
           10 ETP-NR-ANOS-REMIS    PIC S9(4) USAGE COMP.
           10 ETP-TP-REAVALIA      PIC S9(4) USAGE COMP.
           10 ETP-CRITMOV-MAGN     PIC S9(1)V USAGE COMP-3.
           10 CSRAMO-ESTTE         PIC S9(4) USAGE COMP.
           10 CDDD-ESTTE           PIC X(6).
           10 CFONE-ESTTE          PIC S9(11)V USAGE COMP-3.
           10 CPRIM-RMAL-ESTTE     PIC S9(8)V USAGE COMP-3.
           10 CSEGDA-DDD-ESTTE     PIC S9(6)V USAGE COMP-3.
           10 CSEGDA-FONE-ESTTE    PIC S9(11)V USAGE COMP-3.
           10 CSEGDA-RMAL-ESTTE    PIC S9(8)V USAGE COMP-3.
           10 IBAIRO-ESTTE.
              49 IBAIRO-ESTTE-LEN
                 PIC S9(4) USAGE COMP.
              49 IBAIRO-ESTTE-TEXT
                 PIC X(25).
           10 REMAIL-ESTTE.
              49 REMAIL-ESTTE-LEN
                 PIC S9(4) USAGE COMP.
              49 REMAIL-ESTTE-TEXT
                 PIC X(256).
           10 CSIT-ACEIT-AGRDO     PIC S9(1)V USAGE COMP-3.
           10 QMES-RENOV-CATAO     PIC S9(3)V USAGE COMP-3.
030468     10 COPER-PLANO-SAUDE    PIC S9(6)V USAGE COMP-3.
******************************************************************
ALPO  * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 86      *
      ******************************************************************

      *----------------------------------------------------------------*00000340
      *    INCLUDE DA TABELA ATSAUDAO.SSCESTIPULANTE                   *00000341
      *----------------------------------------------------------------*00000342
                                                                        00000343
30468**    EXEC SQL                                                     00000344
30468**         INCLUDE SSCF3339                                        00000345
30468**    END-EXEC.                                                    00000346
                                                                        00000347
      *----------------------------------------------------------------*00000348
      *    INCLUDE DA TABELA DBSISA.DESC                               *00000349
      *----------------------------------------------------------------*00000350
                                                                        00000351
           EXEC SQL                                                     00000352
170423          INCLUDE SISA3011                                        00000353
           END-EXEC.                                                    00000354
      ******************************************************************
      * DCLGEN TABLE(DBSISA.DESC)                                      *
      *        LIBRARY(ANPR.DCLGEN(SISA3011))                          *
      *        ACTION(REPLACE)                                         *
      *        LANGUAGE(COBOL)                                         *
      *        STRUCTURE(DCLDESC)                                      *
      *        APOST                                                   *
      *        LABEL(YES)                                              *
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *
      ******************************************************************
           EXEC SQL DECLARE DBSISA.DESC TABLE
           ( DESC_CD_ESTRUT                 DECIMAL(3, 0) NOT NULL,
             DESC_NM_CHAVE                  CHAR(20) NOT NULL,
             DESC_CD_CPO                    DECIMAL(4, 0) NOT NULL,
             DESC_NR_SUBCPO                 DECIMAL(1, 0) NOT NULL,
             DESC_NR_CPOTAM                 DECIMAL(2, 0) NOT NULL,
             DESC_NR_CPODEC                 DECIMAL(2, 0) NOT NULL,
             DESC_IN_CPOCLAS                CHAR(1) NOT NULL,
             DESC_NM_CPO                    CHAR(100) NOT NULL,
             DESC_DT_INI                    DECIMAL(8, 0) NOT NULL,
             DESC_DT_FIM                    DECIMAL(8, 0) NOT NULL,
             DESC_CD_MOTIVOFIM              DECIMAL(2, 0) NOT NULL,
             DESC_DT_ACEITE                 DECIMAL(8, 0) NOT NULL,
             DESC_CD_DISP                   DECIMAL(2, 0) NOT NULL,
             DESC_CD_ORI                    CHAR(8) NOT NULL,
             DESC_NM_CPO_ANT                CHAR(100) NOT NULL,
             DESC_ID_RESP                   INTEGER NOT NULL,
             DESC_CD_TERM                   CHAR(8) NOT NULL
           ) END-EXEC.
      ******************************************************************
      * COBOL DECLARATION FOR TABLE DBSISA.DESC                        *
      ******************************************************************
       01  DCLDESC.
      *    *************************************************************
           10 DESC-CD-ESTRUT       PIC S9(3)V USAGE COMP-3.
      *    *************************************************************
           10 DESC-NM-CHAVE        PIC X(20).
      *    *************************************************************
           10 DESC-CD-CPO          PIC S9(4)V USAGE COMP-3.
      *    *************************************************************
           10 DESC-NR-SUBCPO       PIC S9(1)V USAGE COMP-3.
      *    *************************************************************
           10 DESC-NR-CPOTAM       PIC S9(2)V USAGE COMP-3.
      *    *************************************************************
           10 DESC-NR-CPODEC       PIC S9(2)V USAGE COMP-3.
      *    *************************************************************
           10 DESC-IN-CPOCLAS      PIC X(1).
      *    *************************************************************
           10 DESC-NM-CPO          PIC X(100).
      *    *************************************************************
           10 DESC-DT-INI          PIC S9(8)V USAGE COMP-3.
      *    *************************************************************
           10 DESC-DT-FIM          PIC S9(8)V USAGE COMP-3.
      *    *************************************************************
           10 DESC-CD-MOTIVOFIM    PIC S9(2)V USAGE COMP-3.
      *    *************************************************************
           10 DESC-DT-ACEITE       PIC S9(8)V USAGE COMP-3.
      *    *************************************************************
           10 DESC-CD-DISP         PIC S9(2)V USAGE COMP-3.
      *    *************************************************************
           10 DESC-CD-ORI          PIC X(8).
      *    *************************************************************
           10 DESC-NM-CPO-ANT      PIC X(100).
      *    *************************************************************
           10 DESC-ID-RESP         PIC S9(9) USAGE COMP.
      *    *************************************************************
           10 DESC-CD-TERM         PIC X(8).
      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 17      *
      ******************************************************************
                                                                        00000347
170423*----------------------------------------------------------------*00000348
170423*    INCLUDE DA TABELA DBSISA.MOVI                               *00000349
170423*----------------------------------------------------------------*00000350
170423
170423     EXEC SQL
170423          INCLUDE SISA3018
170423     END-EXEC.

                                                                        00000355
      ******************************************************************00000050
      * DCLGEN TABLE(DBSISA.MOVI)                                      *00000100
      *        LIBRARY(ANPR.DCLGEN(SISA3018))                          *00000150
      *        ACTION(REPLACE)                                         *00000200
      *        LANGUAGE(COBOL)                                         *00000250
      *        APOST                                                   *00000300
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *00000350
      ******************************************************************00000400
           EXEC SQL DECLARE DBSISA.MOVI TABLE                           00000450
           ( MOVI_CD_MOV                    DECIMAL(3, 0) NOT NULL,     00000500
             MOVI_DT_CAD                    DECIMAL(8, 0) NOT NULL,     00000550
             MOVI_DT_ATU                    DECIMAL(8, 0) NOT NULL,     00000600
             MOVI_IN_SIT                    DECIMAL(1, 0) NOT NULL,     00000650
             MOVI_NM_CHAVE                  CHAR(40) NOT NULL,          00000700
             MOVI_NM_COMPL                  CHAR(150) NOT NULL,         00000750
             MOVI_TIMESTAMP                 TIMESTAMP NOT NULL,         00000800
             MOVI_NM_PROGRAMA               CHAR(8) NOT NULL            00000850
           ) END-EXEC.                                                  00000900
      ******************************************************************00000950
      * COBOL DECLARATION FOR TABLE DBSISA.MOVI                        *00001000
      ******************************************************************00001050
       01  DCLMOVI.                                                     00001100
           10 MOVI-CD-MOV          PIC S9(3)V USAGE COMP-3.             00001150
           10 MOVI-DT-CAD          PIC S9(8)V USAGE COMP-3.             00001200
           10 MOVI-DT-ATU          PIC S9(8)V USAGE COMP-3.             00001250
           10 MOVI-IN-SIT          PIC S9(1)V USAGE COMP-3.             00001300
           10 MOVI-NM-CHAVE        PIC X(40).                           00001350
           10 MOVI-NM-COMPL        PIC X(150).                          00001400
           10 MOVI-TIMESTAMP       PIC X(26).                           00001450
           10 MOVI-NM-PROGRAMA     PIC X(8).                            00001500
      ******************************************************************00001550
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 8       *00001600
      ******************************************************************00001650


      *----------------------------------------------------------------*00000356
      *    DECLARACAO DE CURSOR   -  ATSAUDAO.SSCESTIPULANTE           *00000357
      *----------------------------------------------------------------*00000358
                                                                        00000359
           EXEC SQL DECLARE CURSOR-ATETP CURSOR FOR                     00000360
                                                                        00000361
              SELECT ETP_CIA,                                           00000362
                     ETP_APOLICE,                                       00000363
                     ETP_RMO,                                           00000364
                     ETP_RSOCIAL,                                       00000365
                     ETP_CGC,                                           00000366
                     ETP_CODIGO_ATIV,                                   00000367
                     ETP_AMD_INICIO,                                    00000368
                     ETP_AMD_CANCEL,                                    00000369
                     ETP_DT_INI,                                        00000370
30468                COPER_PLANO_SAUDE                                  00000370
                                                                        00000371
               FROM  ATSAUDAO.SSCESTIPULANTE                            00000372
                                                                        00000373
              WHERE (ETP_RMO       IN (875, 876, 878))                  00000374
           END-EXEC.                                                    00000376
JAPI-I*                                                                 00000377
JAPI-I 01  CB-CURRENT-DATE.                                             00000378
JAPI-I     03  CB-MM           PIC X(2).                                00000379
JAPI-I     03  FILLER          PIC X(1) VALUE '/'.                      00000380
JAPI-I     03  CB-DD           PIC X(2).                                00000381
JAPI-I     03  FILLER          PIC X(1) VALUE '/'.                      00000382
JAPI-I     03  CB-YY           PIC X(2).                                00000383
JAPI-I*                                                                 00000384
JAPI-I 01  CB-ACCEPT-DATE.                                              00000385
JAPI-I     03  CB-YY           PIC X(2).                                00000386
JAPI-I     03  CB-MM           PIC X(2).                                00000387
JAPI-I     03  CB-DD           PIC X(2).                                00000388
JAPI-I*                                                                 00000389
JAPI-I 01  CB-ACCEPT-TIME.                                              00000390
JAPI-I     03  CB-TIME-OF-DAY  PIC X(6).                                00000391
JAPI-I     03  FILLER          PIC X(2).                                00000392
                                                                        00000393
       LINKAGE SECTION.                                                 00000394
                                                                        00000395
       01  PARAMETRO.                                                   00000396
           03 FILLER                      PIC X(02).                    00000397
           03 PERIODICIDADE               PIC X(01).                    00000398
           03 FILLER                      PIC X(01).                    00000399
           03 AMBIENTE                    PIC X(01).                    00000400
           03 FILLER                      PIC X(01).                    00000401
           03 DIRETORIO-PRODUCAO          PIC X(09).                    00000402
           03 FILLER                      PIC X(01).                    00000403
           03 DIRETORIO-DESENVOLVIMENTO   PIC X(09).                    00000404
                                                                        00000405
      *-----------------------------------*                             00000406
       PROCEDURE DIVISION USING PARAMETRO.                              00000407
      *-----------------------------------*                             00000408
                                                                        00000409
       000-INICIO.                                                      00000410
      *------------*                                                    00000411
                                                                        00000412
           PERFORM 100-INICIALIZACAO                                    00000413
              THRU 100-FIM.                                             00000414
                                                                        00000415
           PERFORM 200-PROCESSAMENTO                                    00000416
              THRU 200-FIM.                                             00000417
                                                                        00000418
           PERFORM 500-FINALIZACAO                                      00000419
              THRU 500-FIM.                                             00000420
                                                                        00000421
           STOP RUN.                                                    00000422
                                                                        00000423
      *------------------*                                              00000424
       100-INICIALIZACAO.                                               00000425
      *------------------*                                              00000426
                                                                        00000427
JAPI-I     ACCEPT CB-ACCEPT-DATE FROM DATE                              00000428
JAPI-I     MOVE CORR CB-ACCEPT-DATE TO CB-CURRENT-DATE                  00000429
JAPI-I     MOVE CB-CURRENT-DATE TO WS-DATA-CORRENTE.                    00000430
           MOVE '/'            TO WS-BR1-DISPLAY WS-BR2-DISPLAY.        00000431
           MOVE '20'           TO WS-SEC-DISPLAY.                       00000432
           MOVE WS-MES-CORR    TO WS-MES-DISPLAY.                       00000433
           MOVE WS-DIA-CORR    TO WS-DIA-DISPLAY.                       00000434
           MOVE WS-ANO-CORR    TO WS-ANO-DISPLAY.                       00000435
JAPI-I     ACCEPT CB-ACCEPT-TIME FROM TIME                              00000436
JAPI-I     MOVE CB-TIME-OF-DAY TO WS-HORA-CORRENTE.                     00000437
           MOVE ':'            TO WS-BR3-DISPLY WS-BR4-DISPLY.          00000438
           MOVE WS-HH-CORR     TO WS-HH-DISPLY.                         00000439
           MOVE WS-MM-CORR     TO WS-MM-DISPLY.                         00000440
           MOVE WS-SS-CORR     TO WS-SS-DISPLY.                         00000441
                                                                        00000442
JAPI-I     MOVE 'DWSD0612' TO SQL-PLAN                                  00000443
JAPI-I     CALL 'DSNALI' USING SQL-OPEN SQL-SSID SQL-PLAN.              00000444
                                                                        00000445
           OPEN INPUT  ARQPARM                                          00000446
           OPEN OUTPUT DIMESTIP.                                        00000447
                                                                        00000448
           PERFORM 101-GERA-HEADER-ETP                                  00000449
              THRU 101-FIM.                                             00000450
                                                                        00000451
       100-FIM.    EXIT.                                                00000452
                                                                        00000453
                                                                        00000454
      *-----------------------*                                         00000455
       101-GERA-HEADER-ETP.                                             00000456
      *-----------------------*                                         00000457
                                                                        00000458
           MOVE SPACES           TO  REG-HEADER-ETP.                    00000459
                                                                        00000460
           MOVE 0                TO  TIPO-REG-H-ETP.                    00000461
                                                                        00000462
           MOVE '20'             TO  WS-SEC-SIST.                       00000463
           MOVE WS-ANO-CORR      TO  WS-ANO-SIST.                       00000464
           MOVE WS-MES-CORR      TO  WS-MES-SIST.                       00000465
           MOVE WS-DIA-CORR      TO  WS-DIA-SIST.                       00000466
           MOVE WS-DATA-SIST-R   TO  DATA-SISTEMA-H-ETP.                00000467
                                                                        00000468
JAPI-I     ACCEPT CB-ACCEPT-TIME FROM TIME                              00000469
JAPI-I     MOVE CB-TIME-OF-DAY TO HORA-SISTEMA-H-ETP.                   00000470
                                                                        00000471
           READ ARQPARM INTO REGISTRO-PARAMETRO                         00000472
              AT END                                                    00000473
              DISPLAY '*----------------------------------------------*'00000474
              DISPLAY '*    DWSD0612 - ARQUIVO DE PARAMETROS VAZIO    *'00000475
              DISPLAY '*----------------------------------------------*'00000476
              CALL NCOB1660 USING WS-ABEND.                             00000477
                                                                        00000478
           IF PERIODICIDADE = 'D'                                       00000479
              IF DATA-PROC NOT EQUAL DATA-PROX                          00000480
                 DISPLAY ' '                                            00000481
                 DISPLAY 'DWSD0612 - PARAMETRO INVALIDO '               00000482
                 DISPLAY 'DATA DO PROCESSAMENTO.. ' DATA-PROC           00000483
                 DISPLAY 'DATA DO PROXIMO........ ' DATA-PROX           00000484
                 DISPLAY ' '                                            00000485
                 CALL  NCOB1660  USING WS-ABEND                         00000486
              END-IF                                                    00000487
           ELSE                                                         00000488
              DISPLAY ' '                                               00000489
              DISPLAY 'DWSD0612-PERIODICIDADE INVALIDA=' PERIODICIDADE  00000490
              DISPLAY ' '                                               00000491
              CALL  NCOB1660  USING WS-ABEND                            00000492
           END-IF.                                                      00000493
                                                                        00000494
           DISPLAY ' '.                                                 00000495
           DISPLAY 'DWSD0612 - REGISTRO PARAMETRO : '.                  00000496
           DISPLAY  REGISTRO-PARAMETRO.                                 00000497
                                                                        00000498
           MOVE DATA-CORTE       TO DATA-INI-SEL.                       00000499
           MOVE DATA-FIM         TO DATA-FIM-SEL.                       00000500
                                                                        00000501
           CLOSE ARQPARM.                                               00000502
                                                                        00000503
      *    GRAVA ARQUIVO PARA FTP                                       00000504
                                                                        00000505
           OPEN OUTPUT ARQFTP.                                          00000506
                                                                        00000507
           IF AMBIENTE = 'P'                                            00000508
              MOVE DIRETORIO-PRODUCAO         TO DIRETORIO              00000509
           ELSE                                                         00000510
              MOVE DIRETORIO-DESENVOLVIMENTO  TO DIRETORIO              00000511
           END-IF.                                                      00000512
                                                                        00000513
           MOVE  DATA-INI  TO   LN-DATA.                                00000514
                                                                        00000515
           PERFORM 102-GRAVA-FTP-ESTIP.                                 00000516
                                                                        00000517
           MOVE 'DWSD0612'     TO  NOME-PGM-H-ETP.                      00000518
           MOVE  DATA-INI      TO  DATA-INI-H-ETP                       00000519
                                   DATA-FIM-H-ETP.                      00000520
                                                                        00000521
           WRITE REG-ESTIPULANTE FROM                                   00000522
                 REG-HEADER-ETP.                                        00000523
                                                                        00000524
       101-FIM. EXIT.                                                   00000525
                                                                        00000526
                                                                        00000527
       102-GRAVA-FTP-ESTIP.                                             00000528
                                                                        00000529
           DISPLAY ' '                                                  00000530
           DISPLAY 'ARQ FTP ESTIP   '.                                  00000531
           WRITE FTP-REGISTRO  FROM LN-FTP-01.                          00000532
           DISPLAY LN-FTP-01.                                           00000533
           WRITE FTP-REGISTRO  FROM LN-FTP-02.                          00000534
           DISPLAY LN-FTP-02.                                           00000535
           WRITE FTP-REGISTRO  FROM LN-FTP-03.                          00000536
           DISPLAY LN-FTP-03.                                           00000537
           WRITE FTP-REGISTRO  FROM LN-FTP-04.                          00000538
           DISPLAY LN-FTP-04.                                           00000539
           WRITE FTP-REGISTRO  FROM LN-FTP-05.                          00000540
           DISPLAY LN-FTP-05.                                           00000541
           WRITE FTP-REGISTRO  FROM LN-FTP-06.                          00000542
           DISPLAY LN-FTP-06.                                           00000543
           WRITE FTP-REGISTRO  FROM LN-FTP-07.                          00000544
           DISPLAY LN-FTP-07.                                           00000545
           WRITE FTP-REGISTRO  FROM LN-FTP-08.                          00000546
           DISPLAY LN-FTP-08.                                           00000547
                                                                        00000548
           CLOSE ARQFTP.                                                00000549
                                                                        00000550
                                                                        00000551
                                                                        00000552
      *------------------*                                              00000553
       200-PROCESSAMENTO.                                               00000554
      *------------------*                                              00000555
                                                                        00000556
           SORT ARQSORT ON ASCENDING  KEY NUM-CGC-SORT                  00000557
240610                                    DATA-CANCEL-SORT              00000558
240610                     DESCENDING KEY DATA-INIC-SORT                00000559
190216                                    COD-CIA-SORT                  00000559
190216                     COD-APOLICE-SORT                             00000559
                                                                        00000560
                INPUT   PROCEDURE 300-PROCESSA-CURSOR THRU 300-FIM      00000561
                                                                        00000562
                OUTPUT  PROCEDURE 400-PROCESSA-SORT   THRU 400-FIM.     00000563
                                                                        00000564
                                                                        00000565
       200-FIM. EXIT.                                                   00000566
                                                                        00000567
      *----------------------------*                                    00000568
       300-PROCESSA-CURSOR.                                             00000569
      *----------------------------*                                    00000570
                                                                        00000571
           PERFORM 310-ABRE-CURSOR-ATSAUDAO                             00000572
              THRU 310-FIM.                                             00000573
                                                                        00000574
           PERFORM 320-LE-CURSOR-ATSAUDAO                               00000575
              THRU 320-FIM.                                             00000576
                                                                        00000577
           IF SQLCODE NOT EQUAL 0 AND 100                               00000578
              DISPLAY '*----------------------------------------------*'00000579
              DISPLAY '* DWSD0612 300-PROCESSA-CURSOR                 *'00000580
              DISPLAY '* DWSD0612 ERRO PRIMEIRA LEITURA CURSOR-ATETP  *'00000581
              DISPLAY '* DWSD0612 ATSAUDAO.SSCESTIPULANTE             *'00000582
              DISPLAY '*----------------------------------------------*'00000583
              DISPLAY '* SQLCODE  = ' WS-SQLCODE                        00000584
              DISPLAY '*----------------------------------------------*'00000585
              MOVE 'ERRO NA LEITURA CURSOR-ATETP'  TO   WS-COMANDO      00000586
              PERFORM 9999-TRATA-ERRO-SQL       THRU 9999-FIM.          00000587
                                                                        00000588
           PERFORM 330-PROCESSA-ATSAUDAO                                00000589
              THRU 330-FIM                                              00000590
             UNTIL SQLCODE  EQUAL 100.                                  00000591
                                                                        00000592
                                                                        00000593
       300-FIM. EXIT.                                                   00000594
                                                                        00000595
      *------------------------------*                                  00000596
       310-ABRE-CURSOR-ATSAUDAO.                                        00000597
      *------------------------------*                                  00000598
                                                                        00000599
           EXEC SQL                                                     00000600
                OPEN CURSOR-ATETP                                       00000601
           END-EXEC.                                                    00000602
                                                                        00000603
           MOVE SQLCODE  TO  WS-SQLCODE.                                00000604
                                                                        00000605
           IF SQLCODE NOT EQUAL 0                                       00000606
              DISPLAY '*-------------------------------------------*'   00000607
              DISPLAY '*  DWSD0612 - 310-ABRE-CURSOR-ATSAUDAO      *'   00000608
              DISPLAY '*  DWSD0612 - ERRO NA ABERTURA CURSOR-ATETP *'   00000609
              DISPLAY '*  DWSD0612 - ATSAUDAO.SSCESTIPULANTE       *'   00000610
              DISPLAY '*-------------------------------------------*'   00000611
              DISPLAY '* SQLCODE  = ' WS-SQLCODE                        00000612
              DISPLAY '*-------------------------------------------*'   00000613
              MOVE 'ERRO NO OPEN DO CURSOR-ATETP'  TO   WS-COMANDO      00000614
              PERFORM 9999-TRATA-ERRO-SQL       THRU 9999-FIM.          00000615
                                                                        00000616
       310-FIM.    EXIT.                                                00000617
                                                                        00000618
      *----------------------------------*                              00000619
       320-LE-CURSOR-ATSAUDAO.                                          00000620
      *----------------------------------*                              00000621
                                                                        00000622
           EXEC SQL  FETCH CURSOR-ATETP                                 00000623
                                                                        00000624
               INTO :DCLSSCESTIPULANTE.ETP-CIA,                         00000625
                    :DCLSSCESTIPULANTE.ETP-APOLICE,                     00000626
                    :DCLSSCESTIPULANTE.ETP-RMO,                         00000627
                    :DCLSSCESTIPULANTE.ETP-RSOCIAL,                     00000628
                    :DCLSSCESTIPULANTE.ETP-CGC,                         00000629
                    :DCLSSCESTIPULANTE.ETP-CODIGO-ATIV,                 00000630
                    :DCLSSCESTIPULANTE.ETP-AMD-INICIO,                  00000631
                    :DCLSSCESTIPULANTE.ETP-AMD-CANCEL,                  00000632
                    :DCLSSCESTIPULANTE.ETP-DT-INI,                      00000633
                    :DCLSSCESTIPULANTE.COPER-PLANO-SAUDE                00000633
                                                                        00000634
           END-EXEC.                                                    00000635
                                                                        00000636
           MOVE SQLCODE       TO WS-SQLCODE.                            00000637
                                                                        00000638
           IF SQLCODE EQUAL 0                                           00000639
              ADD  1          TO WS-LIDOS-CURSOR-ATETP                  00000640
              PERFORM 320A-MOVE-CAMPOS-ATSAUDAO-ETP                     00000641
                 THRU 320A-FIM                                          00000642
           ELSE                                                         00000643
           IF SQLCODE NOT EQUAL 100                                     00000644
              DISPLAY '*------------------------------------------*'    00000645
              DISPLAY '* DWSD0612 320-LE-CURSOR-ATSAUDAO          *'    00000646
              DISPLAY '* DWSD0612 ERRO NA LEITURA CURSOR-ATETP    *'    00000647
              DISPLAY '* DWSD0612 ATSAUDAO.SSCESTIPULANTE         *'    00000648
              DISPLAY '*------------------------------------------*'    00000649
              DISPLAY '* SQLCODE     = ' WS-SQLCODE                     00000650
              DISPLAY '* ETP-CIA     = ' WS-CIA-ATSAUDAO                00000651
              DISPLAY '* ETP-APOLICE = ' WS-APOLICE-ATSAUDAO            00000652
              DISPLAY '*------------------------------------------*'    00000653
              MOVE 'ERRO NA LEITURA DO CURSOR-ATETP' TO  WS-COMANDO     00000654
              PERFORM 9999-TRATA-ERRO-SQL          THRU 9999-FIM.       00000655
                                                                        00000656
       320-FIM.   EXIT.                                                 00000657
                                                                        00000658
      *----------------------------------*                              00000659
       320A-MOVE-CAMPOS-ATSAUDAO-ETP.                                   00000660
      *----------------------------------*                              00000661
                                                                        00000662
           MOVE ETP-CIA         OF DCLSSCESTIPULANTE TO                 00000663
                WS-CIA-ATSAUDAO.                                        00000664
                                                                        00000665
           MOVE ETP-APOLICE     OF DCLSSCESTIPULANTE TO                 00000666
                WS-APOLICE-ATSAUDAO.                                    00000667
                                                                        00000668
           MOVE ETP-RMO         OF DCLSSCESTIPULANTE TO                 00000669
                WS-RMO-ATSAUDAO.                                        00000670
                                                                        00000671
           MOVE ETP-RSOCIAL     OF DCLSSCESTIPULANTE TO                 00000672
                WS-RSOCIAL-ATSAUDAO.                                    00000673
                                                                        00000674
           MOVE ETP-CGC         OF DCLSSCESTIPULANTE TO                 00000675
                WS-CGC-ATSAUDAO                                         00000676
                                                                        00000677
           MOVE ETP-CODIGO-ATIV OF DCLSSCESTIPULANTE TO                 00000678
                WS-CODIGO-ATIV-ATSAUDAO.                                00000679
                                                                        00000680
           MOVE ETP-AMD-INICIO  OF DCLSSCESTIPULANTE TO                 00000681
                WS-AMD-INICIO-ATSAUDAO.                                 00000682
                                                                        00000683
       320A-FIM.   EXIT.                                                00000684
                                                                        00000685
      *----------------------------*                                    00000686
       330-PROCESSA-ATSAUDAO.                                           00000687
      *----------------------------*                                    00000688
                                                                        00000689
           MOVE ZEROS TO DESC-DT-INI.                                   00000690
                                                                        00000691
           IF ETP-AMD-CANCEL NOT EQUAL ZEROS                            00000692
              PERFORM 330A-ACESSA-DESC                                  00000693
                 THRU 330A-FIM.                                         00000694
                                                                        00000695
           IF (ETP-AMD-CANCEL  = 0                      OR              00000696
               ETP-AMD-CANCEL NOT LESS    DATA-INI-SEL) AND             00000697
              (ETP-DT-INI     NOT GREATER DATA-FIM-SEL)                 00000698
               PERFORM 330B-TRATA-ATSAUDAO                              00000699
                  THRU 330B-FIM                                         00000700
           ELSE                                                         00000701
              IF (ETP-AMD-CANCEL  < DATA-INI-SEL)         AND           00000702
                 (ETP-DT-INI   NOT GREATER DATA-FIM-SEL)  AND           00000703
                 (DESC-DT-INI  NOT LESS    DATA-INI-SEL   AND           00000704
                  DESC-DT-INI  NOT GREATER DATA-FIM-SEL)                00000705
                  PERFORM 330B-TRATA-ATSAUDAO                           00000706
                     THRU 330B-FIM                                      00000707
              ELSE                                                      00000708
                 PERFORM 320-LE-CURSOR-ATSAUDAO                         00000709
                    THRU 320-FIM.                                       00000710
                                                                        00000711
       330-FIM. EXIT.                                                   00000712
                                                                        00000713
      *--------------------------*                                      00000714
       330A-ACESSA-DESC.                                                00000715
      *--------------------------*                                      00000716

170423     PERFORM 330C-ACESSA-DATA-CORTE                               00000717

170423     IF DATA-PROC >= WS-AAAAMMDD-CORTE-REAV
170423        MOVE ETP-CIA             OF  DCLSSCESTIPULANTE
170423                                 TO  WS-DESC-NM-CHAVE-CIA-7
170423        MOVE ETP-APOLICE         OF  DCLSSCESTIPULANTE
170423                                 TO  WS-DESC-NM-CHAVE-APO-7
170423        MOVE WS-DESC-NM-CHAVE-7  TO  DESC-NM-CHAVE                00000722
170423     ELSE
              MOVE ETP-CIA             OF  DCLSSCESTIPULANTE            00000718
                                       TO  WS-DESC-NM-CHAVE-CIA         00000719
              MOVE ETP-APOLICE         OF  DCLSSCESTIPULANTE            00000720
                                       TO  WS-DESC-NM-CHAVE-APO         00000721
              MOVE WS-DESC-NM-CHAVE    TO  DESC-NM-CHAVE                00000722
170423     END-IF.                                                      00000722

           MOVE 1                      TO  DESC-CD-ESTRUT.              00000723
           MOVE 68                     TO  DESC-CD-CPO.                 00000724
           MOVE 0                      TO  DESC-NR-SUBCPO.              00000725
           MOVE 99999999               TO  DESC-DT-FIM.                 00000726
                                                                        00000727
           EXEC SQL                                                     00000728
                                                                        00000729
                SELECT  DESC_DT_INI                                     00000730
                                                                        00000731
                  INTO :DESC-DT-INI                                     00000732
                                                                        00000733
                  FROM  DBSISA.DESC                                     00000734
                                                                        00000735
                 WHERE  DESC_CD_ESTRUT   = :DESC-CD-ESTRUT              00000736
                   AND  DESC_CD_CPO      = :DESC-CD-CPO                 00000737
                   AND  DESC_NR_SUBCPO   = :DESC-NR-SUBCPO              00000738
                   AND  DESC_DT_FIM      = :DESC-DT-FIM                 00000739
                   AND  DESC_NM_CHAVE    = :DESC-NM-CHAVE               00000740
                                                                        00000741
           END-EXEC.                                                    00000742
                                                                        00000743
           MOVE SQLCODE   TO  WS-SQLCODE.                               00000744
                                                                        00000745
           IF SQLCODE EQUAL 100                                         00000746
              MOVE ZEROS  TO  DESC-DT-INI                               00000747
           ELSE                                                         00000748
              IF SQLCODE EQUAL 0                                        00000749
                 NEXT SENTENCE                                          00000750
              ELSE                                                      00000751
                 IF SQLCODE NOT EQUAL ZEROS                             00000752
                    DISPLAY '*----------------------------------------*'00000753
                    DISPLAY '* DWSD0612 - 330A-ACESSA-DESC            *'00000754
                    DISPLAY '* DWSD0612 - ERRO NA LEITURA DA TABELA   *'00000755
                    DISPLAY '* DWSD0612 - DBSISA.DESC                 *'00000756
                    DISPLAY '*----------------------------------------*'00000757
                    DISPLAY '* SQLCODE         = ' WS-SQLCODE           00000758
                    DISPLAY '* DESC-CD-ESTRUT  = ' DESC-CD-ESTRUT       00000759
                    DISPLAY '* DESC-CD-CPO     = ' DESC-CD-CPO          00000760
                    DISPLAY '* DESC-NR-SUBCPO  = ' DESC-NR-SUBCPO       00000761
                    DISPLAY '* DESC-DT-FIM     = ' DESC-DT-FIM          00000762
                    DISPLAY '* DESC-NM-CHAVE   = ' DESC-NM-CHAVE        00000763
                    DISPLAY '*----------------------------------------*'00000764
                    MOVE 'ERRO NA LEITURA DA TABELA DESC' TO WS-COMANDO 00000765
                    PERFORM 9999-TRATA-ERRO-SQL  THRU 9999-FIM.         00000766
                                                                        00000767
       330A-FIM. EXIT.                                                  00000768
                                                                        00000769
      *----------------------------*                                    00000770
       330B-TRATA-ATSAUDAO.                                             00000771
      *----------------------------*                                    00000772
                                                                        00000773
           PERFORM 331-GRAVA-SORT-ATSAUDAO                              00000774
              THRU 331-FIM.                                             00000775
                                                                        00000776
           PERFORM 320-LE-CURSOR-ATSAUDAO                               00000777
              THRU 320-FIM.                                             00000778
                                                                        00000779
       330B-FIM. EXIT.                                                  00000780
                                                                        00000867
170423*----------------------------*                                    00000770
..     330C-ACESSA-DATA-CORTE.                                          00000868
.     *----------------------------*                                    00000869
                                                                        00000870
           EXEC SQL                                                     00000870
                SELECT MOVI_NM_COMPL                                    00000870
                  INTO :MOVI-NM-COMPL                                   00000870
                FROM DBSISA.MOVI                                        00000870
                WHERE  MOVI_CD_MOV = 80                                 00000870
                  AND  MOVI_NM_CHAVE LIKE '0510%'                       00000870
                  FETCH FIRST 1 ROW ONLY                                00000870
           END-EXEC                                                     00000870

           IF SQLCODE             EQUAL ZEROS                           80      
              MOVE MOVI-NM-COMPL  TO WS-MOVI-NM-COMPL-REAV              00000870
           ELSE                                                         80      
              DISPLAY '*----------------------------------------*'      81      
              DISPLAY '* DWSD0612 - 330CACESSA-DATA-CORTE       *'      82      
              DISPLAY '* DWSD0612 - ERRO NA LEITURA DBSISA-MOVI *'      83      
              DISPLAY '*----------------------------------------*'      84      
              DISPLAY '* SQLCODE        = ' SQLCODE                     85      
              DISPLAY '*----------------------------------------*'      81      
              MOVE 'ERRO SELECT TABELA DBSISA.MOVI' TO WS-COMANDO       90      
.             GO TO  9999-TRATA-ERRO-SQL.                               91      
..                                                                      00000870
170423 330C-FIM. EXIT.                                                  00000888
                                                                        00000781
      *----------------------------*                                    00000782
       331-GRAVA-SORT-ATSAUDAO.                                         00000783
      *----------------------------*                                    00000784
                                                                        00000785
           MOVE  SPACES                  TO REG-ARQSORT.                00000786
                                                                        00000787
           MOVE  WS-CGC-ATSAUDAO         TO WS-CGC-INTEIRO.             00000788
           MOVE  WS-CGC-SDV              TO NUM-CGC-SORT.               00000789
           MOVE  WS-CGC-DV               TO NUM-DV-CGC-SORT.            00000790
                                                                        00000791
           MOVE  WS-AMD-INICIO-ATSAUDAO  TO DATA-INIC-SORT.             00000792
240610     MOVE  ETP-AMD-CANCEL          TO DATA-CANCEL-SORT.           00000792
           MOVE  WS-CIA-ATSAUDAO         TO COD-CIA-SORT.               00000793
           MOVE  WS-APOLICE-ATSAUDAO     TO COD-APOLICE-SORT.           00000794
           MOVE  WS-RSOCIAL-ATSAUDAO     TO NOME-ESTIP-SORT.            00000795
           MOVE  WS-CODIGO-ATIV-ATSAUDAO TO COD-ATIV-SORT.              00000796
                                                                        00000797
           RELEASE REG-ARQSORT.                                         00000798
           ADD   1                       TO WS-GRAVADOS-SORT.           00000799
                                                                        00000800
       331-FIM. EXIT.                                                   00000801
                                                                        00000802
                                                                        00000803
      *----------------------------*                                    00000804
       400-PROCESSA-SORT.                                               00000805
      *----------------------------*                                    00000806
                                                                        00000807
           PERFORM 440-LE-ARQSORT                                       00000808
              THRU 440-FIM.                                             00000809
                                                                        00000810
           PERFORM 410-TRATA-ARQSORT                                    00000811
              THRU 410-FIM                                              00000812
             UNTIL WS-FIM-SORT EQUAL 'SIM'.                             00000813
                                                                        00000814
       400-FIM. EXIT.                                                   00000815
                                                                        00000816
      *----------------------------*                                    00000817
       410-TRATA-ARQSORT.                                               00000818
      *----------------------------*                                    00000819
                                                                        00000820
           IF NUM-CGC-SORT = 0                                          00000821
              PERFORM 425-TRATA-CGC-ZERADO                              00000822
                 THRU 425-FIM                                           00000823
                UNTIL NUM-CGC-SORT NOT EQUAL WS-CGC-ANT.                00000824
                                                                        00000832
190216     MOVE COD-CIA-SORT     TO WS-COD-CIA-ANT                      00000826
190216     MOVE COD-APOLICE-SORT TO WS-COD-APOL-ANT                     00000827
190216     MOVE DATA-INIC-SORT   TO WS-DATA-INIC-ANT                    00000828
190216     MOVE NUM-DV-CGC-SORT  TO WS-DV-CGC-ANT                       00000829
190216     MOVE NOME-ESTIP-SORT  TO WS-NOME-ESTIP-ANT                   00000830
190216     MOVE COD-ATIV-SORT    TO WS-COD-ATIV-ANT                     00000831
190216     MOVE NUM-CGC-SORT     TO WS-CGC-ANT                          00000832
                                                                        00000825
190216     IF DATA-CANCEL-SORT = 0
190216        PERFORM 430-GRAVA-ESTIPULANTE                             00000839
190216           THRU 430-FIM                                           00000840
190216        PERFORM 440-LE-ARQSORT THRU 440-FIM                       00000870
190216          UNTIL WS-FIM-SORT      EQUAL 'SIM'
190216             OR NUM-CGC-SORT NOT EQUAL WS-CGC-ANT
190216     ELSE
190216        MOVE ZEROS   TO WS-DATA-INIC-ANT                          00000828
190216        PERFORM 420-TRATA-ESTIPULANTE-IGUAL THRU 420-FIM          00000834
190216          UNTIL WS-FIM-SORT      EQUAL 'SIM'                      00000836
190216             OR NUM-CGC-SORT NOT EQUAL WS-CGC-ANT                 00000837
190216        PERFORM 430-GRAVA-ESTIPULANTE                             00000839
190216           THRU 430-FIM                                           00000840
190216     END-IF.                                                      00000838
                                                                        00000841
       410-FIM. EXIT.                                                   00000842
                                                                        00000843
      *----------------------------*                                    00000844
       420-TRATA-ESTIPULANTE-IGUAL.                                     00000845
      *----------------------------*                                    00000846
                                                                        00000847
190216     IF DATA-INIC-SORT > WS-DATA-INIC-ANT
190216        MOVE COD-CIA-SORT     TO WS-COD-CIA-ANT                   00000826
190216        MOVE COD-APOLICE-SORT TO WS-COD-APOL-ANT                  00000827
190216        MOVE DATA-INIC-SORT   TO WS-DATA-INIC-ANT                 00000828
190216        MOVE NUM-DV-CGC-SORT  TO WS-DV-CGC-ANT                    00000829
190216        MOVE NOME-ESTIP-SORT  TO WS-NOME-ESTIP-ANT                00000830
190216        MOVE COD-ATIV-SORT    TO WS-COD-ATIV-ANT                  00000831
190216        MOVE NUM-CGC-SORT     TO WS-CGC-ANT                       00000832
190216     END-IF.
                                                                        00000833
           PERFORM 440-LE-ARQSORT                                       00000848
              THRU 440-FIM.                                             00000849
                                                                        00000850
       420-FIM. EXIT.                                                   00000851
                                                                        00000852
      *----------------------------*                                    00000853
       425-TRATA-CGC-ZERADO.                                            00000854
      *----------------------------*                                    00000855
                                                                        00000856
           ADD  1                TO WS-CONT-CGC-ZERADOS.                00000857
                                                                        00000858
           MOVE COD-CIA-SORT     TO WS-COD-CIA-ANT.                     00000859
           MOVE COD-APOLICE-SORT TO WS-COD-APOL-ANT.                    00000860
           MOVE DATA-INIC-SORT   TO WS-DATA-INIC-ANT.                   00000861
           MOVE NUM-DV-CGC-SORT  TO WS-DV-CGC-ANT.                      00000862
           MOVE NOME-ESTIP-SORT  TO WS-NOME-ESTIP-ANT.                  00000863
           MOVE COD-ATIV-SORT    TO WS-COD-ATIV-ANT.                    00000864
           MOVE NUM-CGC-SORT     TO WS-CGC-ANT.                         00000865
                                                                        00000866
           PERFORM 430-GRAVA-ESTIPULANTE                                00000867
              THRU 430-FIM.                                             00000868
                                                                        00000869
           PERFORM 440-LE-ARQSORT                                       00000870
              THRU 440-FIM.                                             00000871
                                                                        00000872
       425-FIM. EXIT.                                                   00000873
                                                                        00000874
      *----------------------------*                                    00000875
       430-GRAVA-ESTIPULANTE.                                           00000876
      *----------------------------*                                    00000877
                                                                        00000878
           MOVE  1                   TO TIPO-REG-D-ETP.                 00000879
           MOVE  6                   TO COD-ORIGEM-D-ETP.               00000880
                                                                        00000881
           MOVE  WS-COD-CIA-ANT      TO WS-CIA.                         00000882
           MOVE  WS-COD-APOL-ANT     TO WS-APOLICE.                     00000883

30468      MOVE WS-APOLICE           TO   ETP-APOLICE                   00001801
30468      PERFORM 450-ACESSA-ESTIPULANTE-NVCIA THRU 450-FIM            00001807

170423     MOVE  WS-IDENT-APOL-R     TO IDENT-APOLICE-D-ETP.            00000884
                                                                        00000885
           MOVE  WS-NOME-ESTIP-ANT   TO NOME-ESTIPULANTE-D-ETP.         00000886
                                                                        00000887
           MOVE  WS-CGC-ANT          TO WS-CODIGO-CNPJ-R.               00000888
           MOVE  WS-COD-BASE         TO CODIGO-BASE-D-ETP.              00000889
           MOVE  WS-COD-FILIAL       TO CODIGO-FILIAL-D-ETP.            00000890
           MOVE  WS-DV-CGC-ANT       TO CODIGO-DV-D-ETP.                00000891
                                                                        00000892
           MOVE  WS-COD-ATIV-ANT     TO IDENT-RAMO-ATIV-D-ETP.          00000893
                                                                        00000894
           WRITE REG-ESTIPULANTE     FROM                               00000895
                 REG-DETALHE-ETP.                                       00000896
                                                                        00000897
           ADD   1                   TO WS-QTDE-ETP                     00000898
                                        WS-GRAVADOS-ETP.                00000899
                                                                        00000900
       430-FIM. EXIT.                                                   00000901
                                                                        00000902
      *----------------------------*                                    00000903
       440-LE-ARQSORT.                                                  00000904
      *----------------------------*                                    00000905
                                                                        00000906
           RETURN ARQSORT                                               00000907
                  AT END MOVE 'SIM' TO WS-FIM-SORT.                     00000907
                                                                        00000908
           IF WS-FIM-SORT NOT EQUAL 'SIM'                               00000909
              ADD  1 TO WS-LIDOS-SORT.                                  00000910
                                                                        00000911
       440-FIM. EXIT.                                                   00000912
                                                                        00000913
      *----------------------------*                                    00000903
30468  450-ACESSA-ESTIPULANTE-NVCIA.                                    00026900
      *----------------------------*                                    00000903
30468      EXEC  SQL
30468            SELECT   COPER_PLANO_SAUDE
30468              INTO  :COPER-PLANO-SAUDE
30468              FROM   ATSAUDAO.SSCESTIPULANTE
30468             WHERE   ETP_APOLICE      = :ETP-APOLICE
30468             WITH UR
30468      END-EXEC.
30468 
30468      IF SQLCODE NOT EQUAL 0 AND 100
30468         DISPLAY '*---------------------------------------------*' 00001882
30468         DISPLAY '* DWSD0612 - 450-ACESSA-ESTIPULANTE-NVCIA     *' 00001883
30468         DISPLAY '* DWSD0612 - ERRO NO SELECT                   *' 00001884
30468         DISPLAY '* DWSD0612 - ATSAUDAO.SSCESTIPULANTE          *' 00001885
30468         DISPLAY '*---------------------------------------------*' 00001886
30468         DISPLAY '* SQLCODE     = ' WS-SQLCODE                     00000998
30468         DISPLAY '*--------------------------------------------*'  00000999
30468         MOVE 'ERRO NO ACESSO A TABELA ESTIPULANTE' TO WS-COMANDO  00001000
30468         PERFORM 9999-TRATA-ERRO-SQL              THRU 9999-FIM    00001001
30468      END-IF.
30468 
30468      IF COPER-PLANO-SAUDE NOT EQUAL 0
30468         MOVE COPER-PLANO-SAUDE TO WS-CIA
30468      END-IF.
30468 
30468  450-FIM.    EXIT.                                                00058500

      *--------------------*                                            00000914
       500-FINALIZACAO.                                                 00000915
      *--------------------*                                            00000916
                                                                        00000917
           PERFORM 501-FECHA-CURSOR-ATSAUDAO                            00000918
              THRU 501-FIM.                                             00000919
                                                                        00000920
           PERFORM 503-GERA-TRAILLER-ETP                                00000921
              THRU 503-FIM.                                             00000922
                                                                        00000923
           CLOSE DIMESTIP.                                              00000924
                                                                        00000925
           MOVE WS-LIDOS-CURSOR-ATETP  TO  WS-LIDOS-ZZZ-ATETP.          00000926
           MOVE WS-LIDOS-CURSOR-DBETP  TO  WS-LIDOS-ZZZ-DBETP.          00000927
           MOVE WS-CONT-CGC-ZERADOS    TO  WS-CGC-ZERADOS-ZZZ.          00000928
                                                                        00000929
           DISPLAY '*-------------------------------------------*'      00000930
           DISPLAY '*            PROGRAMA DWSD0612              *'      00000931
           DISPLAY '*           EXTRACAO ESTIPULANTE            *'      00000932
           DISPLAY '*-------------------------------------------*'      00000933
           DISPLAY '* INICIO : ' WS-DATA-DISPLAY                        00000934
                   ' - ' WS-HORA-DISPLAY '            *'                00000935
           DISPLAY '*-------------------------------------------*'      00000936
           DISPLAY '*                                           *'      00000937
           DISPLAY '* LIDOS ATSAUDAO.SSCESTIPULANTE:'                   00000938
                   WS-LIDOS-ZZZ-ATETP ' *'                              00000939
           DISPLAY '*                                           *'      00000940
           DISPLAY '* LIDOS DBSAUDE.SAEESTIPULANTE :'                   00000941
                   WS-LIDOS-ZZZ-DBETP ' *'                              00000942
           DISPLAY '*                                           *'      00000943
           MOVE WS-GRAVADOS-SORT       TO  WS-GRAVA-ZZZ                 00000944
           DISPLAY '* GRAVADOS SORT                :'                   00000945
                   WS-GRAVA-ZZZ       ' *'                              00000946
           DISPLAY '*                                           *'      00000947
           MOVE WS-LIDOS-SORT          TO  WS-GRAVA-ZZZ                 00000948
           DISPLAY '* LIDOS    SORT                :'                   00000949
                   WS-GRAVA-ZZZ       ' *'                              00000950
           DISPLAY '*                                           *'      00000951
           MOVE WS-GRAVADOS-ETP        TO  WS-GRAVA-ZZZ                 00000952
           DISPLAY '* GRAVADOS ESTIPULANTE         :' WS-GRAVA-ZZZ      00000953
                   ' *'                                                 00000954
           DISPLAY '*                                           *'      00000955
           DISPLAY '* CGC ZERADOS                  :' WS-CGC-ZERADOS-ZZZ00000956
                   ' *'                                                 00000957
           DISPLAY '*                                           *'      00000958
           DISPLAY '*-------------------------------------------*'      00000959
                                                                        00000960
JAPI-I     ACCEPT CB-ACCEPT-DATE FROM DATE                              00000961
JAPI-I     MOVE CORR CB-ACCEPT-DATE TO CB-CURRENT-DATE                  00000962
JAPI-I     MOVE CB-CURRENT-DATE TO WS-DATA-CORRENTE.                    00000963
           MOVE '/'            TO WS-BR1-DISPLAY WS-BR2-DISPLAY.        00000964
           MOVE '20'           TO WS-SEC-DISPLAY.                       00000965
           MOVE WS-MES-CORR    TO WS-MES-DISPLAY.                       00000966
           MOVE WS-DIA-CORR    TO WS-DIA-DISPLAY.                       00000967
           MOVE WS-ANO-CORR    TO WS-ANO-DISPLAY.                       00000968
JAPI-I     ACCEPT CB-ACCEPT-TIME FROM TIME                              00000969
JAPI-I     MOVE CB-TIME-OF-DAY TO WS-HORA-CORRENTE.                     00000970
           MOVE ':'            TO WS-BR3-DISPLY WS-BR4-DISPLY.          00000971
           MOVE WS-HH-CORR     TO WS-HH-DISPLY.                         00000972
           MOVE WS-MM-CORR     TO WS-MM-DISPLY.                         00000973
           MOVE WS-SS-CORR     TO WS-SS-DISPLY.                         00000974
                                                                        00000975
           DISPLAY '* FINAL  : ' WS-DATA-DISPLAY                        00000976
              ' - ' WS-HORA-DISPLAY '            *'                     00000977
           DISPLAY '*-------------------------------------------*'.     00000978
                                                                        00000979
       500-FIM. EXIT.                                                   00000980
                                                                        00000981
      *---------------------------*                                     00000982
       501-FECHA-CURSOR-ATSAUDAO.                                       00000983
      *---------------------------*                                     00000984
                                                                        00000985
           EXEC SQL                                                     00000986
                CLOSE CURSOR-ATETP                                      00000987
           END-EXEC.                                                    00000988
                                                                        00000989
           MOVE SQLCODE  TO  WS-SQLCODE.                                00000990
                                                                        00000991
           IF SQLCODE NOT EQUAL ZEROS                                   00000992
              DISPLAY '*--------------------------------------------*'  00000993
              DISPLAY '* DWSD0612 - 501-FECHA-CURSOR-ATSAUDAO       *'  00000994
              DISPLAY '* DWSD0612 - ERRO NO FECHAMENTO CURSOR-ATETP *'  00000995
              DISPLAY '* DWSD0612 - ATSAUDAO.SSCESTIPULANTE         *'  00000996
              DISPLAY '*--------------------------------------------*'  00000997
              DISPLAY '* SQLCODE     = ' WS-SQLCODE                     00000998
              DISPLAY '*--------------------------------------------*'  00000999
              MOVE 'ERRO NO FECHAMENTO DO CURSOR-ATETP' TO WS-COMANDO   00001000
              PERFORM 9999-TRATA-ERRO-SQL            THRU 9999-FIM.     00001001
                                                                        00001002
       501-FIM. EXIT.                                                   00001003
                                                                        00001004
                                                                        00001005
      *------------------------*                                        00001006
       503-GERA-TRAILLER-ETP.                                           00001007
      *------------------------*                                        00001008
                                                                        00001009
           MOVE  SPACES               TO REG-TRAILLER-ETP.              00001010
                                                                        00001011
           MOVE  9                    TO TIPO-REG-T-ETP.                00001012
                                                                        00001013
JAPI-I     ACCEPT CB-ACCEPT-DATE FROM DATE                              00001014
JAPI-I     MOVE CORR CB-ACCEPT-DATE TO CB-CURRENT-DATE                  00001015
JAPI-I     MOVE CB-CURRENT-DATE TO WS-DATA-CORRENTE.                    00001016
           MOVE  '20'                 TO WS-SEC-SIST.                   00001017
           MOVE  WS-ANO-CORR          TO WS-ANO-SIST.                   00001018
           MOVE  WS-MES-CORR          TO WS-MES-SIST.                   00001019
           MOVE  WS-DIA-CORR          TO WS-DIA-SIST.                   00001020
           MOVE  WS-DATA-SIST-R       TO DATA-SISTEMA-T-ETP.            00001021
                                                                        00001022
JAPI-I     ACCEPT CB-ACCEPT-TIME FROM TIME                              00001023
JAPI-I     MOVE CB-TIME-OF-DAY TO HORA-SISTEMA-T-ETP.                   00001024
                                                                        00001025
           MOVE  WS-QTDE-ETP          TO QTDE-REGISTROS-T-ETP.          00001026
                                                                        00001027
           WRITE REG-ESTIPULANTE                                        00001028
            FROM REG-TRAILLER-ETP.                                      00001029
                                                                        00001030
       503-FIM. EXIT.                                                   00001031
                                                                        00001032
      *--------------------*                                            00001033
       9999-TRATA-ERRO-SQL.                                             00001034
      *--------------------*                                            00001035
                                                                        00001036
           MOVE SQLCAID          TO    WS-SQLCAID                       00001037
           MOVE SQLCODE          TO    WS-SQLCODE                       00001038
           MOVE SQLERRML         TO    WS-SQLERRML                      00001039
           MOVE SQLERRMC         TO    WS-SQLERRMC                      00001040
           MOVE SQLERRD (1)      TO    WS-SQLERRD (1)                   00001041
           MOVE SQLERRD (2)      TO    WS-SQLERRD (2)                   00001042
           MOVE SQLWARN1         TO    WS-SQLWARN1                      00001043
           MOVE SQLWARN2         TO    WS-SQLWARN2                      00001044
           MOVE SQLEXT           TO    WS-SQLEXT                        00001045
                                                                        00001046
           DISPLAY   '   '                                              00001047
           DISPLAY   '*-----------------------------------------------*'00001048
           DISPLAY   '*      DESCRICAO DE SITUACAO ANORMAL            *'00001049
           DISPLAY   '*-----------------------------------------------*'00001050
           DISPLAY   '*       PROGRAMA      :    DWSD0612             *'00001051
           DISPLAY   '*-----------------------------------------------*'00001052
           DISPLAY   '*  SQLCAID      : ' ,   WS-SQLCAID                00001053
           DISPLAY   '*  SQLCABC      : ' ,   WS-SQLCABC                00001054
           DISPLAY   '*  SQLCODE      : ' ,   WS-SQLCODE                00001055
           DISPLAY   '*  SQLERRML     : ' ,   WS-SQLERRML               00001056
           DISPLAY   '*  SQLERRMC     : ' ,   WS-SQLERRMC               00001057
           DISPLAY   '*  SQLERRP      : ' ,   WS-SQLERRP                00001058
           DISPLAY   '*  SQLERRD (1)  : ' ,   WS-SQLERRD (1)            00001059
           DISPLAY   '*  SQLERRD (2)  : ' ,   WS-SQLERRD (2)            00001060
           DISPLAY   '*  SQLWARN1     : ' ,   WS-SQLWARN1               00001061
           DISPLAY   '*  SQLWARN2     : ' ,   WS-SQLWARN2               00001062
           DISPLAY   '*  SQLEXT       : ' ,   WS-SQLEXT                 00001063
           DISPLAY   '*  LINE COMMAND : ' ,   WS-COMANDO                00001064
           DISPLAY   '*-------------------------------------------*'    00001065
           DISPLAY   '  '                                               00001066
                                                                        00001067
           CALL      'DSNALI'   USING SQL-CLOSE SQL-ABRT.               00001068
           CALL  NCOB1660  USING WS-ABEND.                              00001069
                                                                        00001070
       9999-FIM. EXIT.                                                  00001071



