#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CCJOB    º Autor ³ Edilson Mendes     º Data ³  11/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio para impressão da relacao de JOB eos CC          º±±
±±º          ³ relacionados.                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Cliente WDB                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

user Function CC()

Local cPict          := ""
Local titulo         := "Relacao de Centro de Custo"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "CC" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private m_pag        := 01
Private cPerg        := "CC"
Private wnrel        := "CC" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := "SC7"

	AjustaSX1()
	
	Pergunte(cPerg,.F.)
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,,,,.F.,,.F.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  24/09/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

STATIC PROCEDURE RunReport(Cabec1,Cabec2,Titulo,nLin)

LOCAL aArea   := GetArea()
LOCAL aStruct := {}
LOCAL cQuery
LOCAL cTmpCC
LOCAL nTotalCC

	// Carrega a Estrutura da tabela SC7
	DBSelectArea("SX3")
	SX3->( DBSetOrder(1) )
	SX3->( DBSeek("SC7") )
	WHILE SX3->( .NOT. EOF() ) .AND. SX3->X3_ARQUIVO == "SC7"
		AADD( aStruct, { SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL } )
		SX3->( DBSkip() )
	ENDDO
	
	// Realiza a Montagem da Query de Acordo com os Parametros passados
	cQuery	:=	"SELECT *"
	cQuery	+=	" FROM " + RetSqlName("SC7") "
	cQuery	+=	" WHERE C7_FILIAL = '"+ xFilial("SC7") +"' AND C7_CC >= '"+ MV_PAR01 +"' AND C7_CC <= '"+ MV_PAR02 +"' AND"
	cQuery	+=	" C7_EMISSAO Between '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"' AND D_E_L_E_T_ <> '*'"
	cQuery	+=	" ORDER BY C7_EMISSAO, C7_CC, C7_PRODUTO"
	
	DbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),"TMP",.t.,.t.)
	
	FOR nPos := 1 TO LEN( aStruct )
		IF aStruct[ nPos, 2] <> 'C'
			TCSetField( 'TMP', aStruct[ nPos, 1], aStruct[ nPos, 2], aStruct[ nPos, 3], aStruct[ nPos, 4] )
		ENDIF
	NEXT
	
	// Processa os Registros do Arquivo Temporario
	WHILE TMP->( .NOT. EOF() )
		cTmpCC := TMP->C7_CC
		
		If nLin > 64
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 6
		Endif
		
		@ nLin++, 03 PSAY "Centro de Custo:" + TMP->C7_CC + " - " + IIF( CTT->( DBSetOrder(1), DBSeek( xFilial("CTT") + TMP->C7_CC ) ), CTT->CTT_DESC01, "" )
		@ nLin++, 00 PSAY REPLICATE("=", 80 )
		
		nTotalCC := 0
		WHILE TMP->( .NOT. EOF() ) .AND. TMP->C7_CC == cTmpCC
			
			If nLin > 64
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 6
			Endif
			
			@ nLin  , 10 PSay TMP->C7_NUM
			@ nLin  , 20 PSay TMP->C7_PRODUTO + " - " + PADR( IIF( SB1->( DBSetOrder(1), DBSeek( xFilial("SB1") + TMP->C7_PRODUTO ) ), SB1->B1_DESC, "" ), 25 )
			@ nLin++, 65 PSay TRANSFORM( TMP->C7_TOTAL, X3Picture("C7_TOTAL") )
			nTotalCC += TMP->C7_TOTAL
			
			TMP->( DBSkip() )
		ENDDO
		@ nLin++, 00 PSAY REPLICATE("-", 80 )
		@ nLin++, 53 PSay "Sub Total : " +TRANSFORM( nTotalCC, X3Picture("C7_TOTAL") )
		nLin++
		
	ENDDO
	
	Roda()
	
	Set Device To Screen
	
	If aReturn[5]==1
		dbCommitAll()
		Set Printer To
		OurSpool(wnrel)
	Endif
	
	TMP->( DBCloseArea() )
	
	RestArea(aArea)
	
	MS_FLUSH()
						
RETURN

/*
+--------+--------------------------------------------------------------+
| Funcao | AjustaSX1()                                                  |
| Autor  | Edilson Mendes                                               |
| Data   | 10 de Outubro de 2010                                        |
| Descri | Ajusta dicionario de perguntas.                              |
+--------+--------------------------------------------------------------+
*/
STATIC PROCEDURE AjustaSX1()

LOCAL sAlias    := ALIAS()
LOCAL cPergunta := PADR( cPerg,6 )
LOCAL nTamSX1   := LEN( SX1->X1_GRUPO )
LOCAL aRegs     := {}
LOCAL nPos
LOCAL nCount

	AADD( aRegs,{ cPergunta, '01',OemToAnsi(PadR('CC De',19)+'?')   ,'','','mv_cha','C', 9,0,0,'G','','mv_par01','','','','','','','','','','','','','','','','','','','','','','','','','CTT','' } )
	AADD( aRegs,{ cPergunta, '02',OemToAnsi(PadR('CC Ate',19)+'?')  ,'','','mv_chb','C', 9,0,0,'G','','mv_par02','','','','','','','','','','','','','','','','','','','','','','','','','CTT','' } )
	AADD( aRegs,{ cPergunta, "03",OemToAnsi(PadR("Data De",19)+"?") ,'','',"mv_chc","D", 8,0,0,'G','','mv_par03','','','','','','','','','','','','','','','','','','','','','','','','','',   '' } )
	AADD( aRegs,{ cPergunta, "04",OemToAnsi(PadR("Data Ate",19)+"?"),'','',"mv_chd","D", 8,0,0,'G','','mv_par04','','','','','','','','','','','','','','','','','','','','','','','','','',   '' } )
	
	DBSelectArea('SX1')
	SX1->( DBSetOrder(1) )
	FOR nPos := 1 TO LEN( aRegs )
		IF .NOT. SX1->( DBSeek( PADR( cPerg, nTamSX1 ) + aRegs[ nPos, 2] ) )
			RecLock('SX1',.T.)
			FOR nCount := 1 TO SX1->( FCOUNT() )
				IF nCount <= LEN( aRegs[ nPos ] )
					FieldPut( nCount, aRegs[ nPos, nCount ])
				ENDIF
			NEXT
			MsUnlock()
		ENDIF
	NEXT
	
	DBSelectArea(sAlias)
		
RETURN