#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PLANO    º Autor ³ Edilson Mendes     º Data ³  14/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio para impressão da relacao de Plano de contas com º±±
±±º          ³ Centro de Custo.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Cliente WDB                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

user Function Plano()

Local cPict          := ""
Local titulo         := "Relacao de Plano de Contas x CC"
Local nLin           := 80
Local Cabec1         := " DOCUMENTO        CENTRO DE CUSTO                    TOTAL"
Local Cabec2         := ""
Local imprime        := .T.

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private tamanho      := "G"
Private nomeprog     := "PLANO_CC" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private m_pag        := 1
Private cPerg        := "PLANO_CC"
Private wnrel        := "PLANO_CC" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := "SD1"

	AjustaSX1()
	
	Pergunte(cPerg,.F.)
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,,,,.F.,,.T.,Tamanho)//,,.T.)
	
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
LOCAL cTmpConta
LOCAL nTotalConta

	// Carrega a Estrutura da tabela SC7
	DBSelectArea("SX3")
	SX3->( DBSetOrder(1) )
	SX3->( DBSeek("SD1") )
	WHILE SX3->( .NOT. EOF() ) .AND. SX3->X3_ARQUIVO == "SD1"
		AADD( aStruct, { SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL } )
		SX3->( DBSkip() )
	ENDDO
	
	// Realiza a Montagem da Query de Acordo com os Parametros passados
	cQuery	:=	"SELECT *"
	cQuery	+=	" FROM " + RetSqlName("SD1") "
	cQuery	+=	" WHERE D1_FILIAL = '"+ xFilial("SD1") +"' AND D1_CONTA >= '"+ MV_PAR01 +"' AND D1_CONTA <= '"+ MV_PAR02 +"' AND"
	cQuery	+=	" D1_EMISSAO Between '"+ DTOS( MV_PAR03 ) +"' AND '"+ DTOS( MV_PAR04 ) +"' AND D_E_L_E_T_ <> '*'"
	cQuery	+=	" ORDER BY D1_EMISSAO, D1_CONTA, D1_CC"
	
	DbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),"TMP",.t.,.t.)
	
	FOR nPos := 1 TO LEN( aStruct )
		IF aStruct[ nPos, 2] <> 'C'
			TCSetField( 'TMP', aStruct[ nPos, 1], aStruct[ nPos, 2], aStruct[ nPos, 3], aStruct[ nPos, 4] )
		ENDIF
	NEXT
	
	// Processa os Registros do Arquivo Temporario
	WHILE TMP->( .NOT. EOF() )
		cTmpConta := TMP->D1_CONTA
		
		If nLin > 64
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 6
		Endif
		
		@ nLin++, 03 PSAY "Conta Contabil:" + TMP->D1_CONTA + " - " + IIF( CT1->( DBSetOrder(1), DBSeek( xFilial("CT1") + TMP->D1_CONTA ) ), CT1->CT1_DESC01, "" )
		@ nLin++, 00 PSAY REPLICATE("=", 80 )
		
		nTotalConta := 0
		WHILE TMP->( .NOT. EOF() ) .AND. TMP->D1_CONTA == cTmpConta
			
			If nLin > 64
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 6
			Endif
			
			@ nLin  , 10 PSay TMP->D1_DOC
			@ nLin  , 20 PSay TMP->D1_CC + " - " + PADR( IIF( CTT->( DBSetOrder(1), DBSeek( xFilial("CTT") + TMP->D1_CC ) ), CTT->CTT_DESC01, "" ), 25 )
			@ nLin++, 65 PSay TRANSFORM( TMP->D1_TOTAL, X3Picture("D1_TOTAL") )
			nTotalConta += TMP->D1_TOTAL
			
			TMP->( DBSkip() )
		ENDDO
		@ nLin++, 00 PSAY REPLICATE("-", 80 )
		@ nLin++, 53 PSay "Sub Total : " +TRANSFORM( nTotalConta, X3Picture("D1_TOTAL") )
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
LOCAL cPergunta := PADR( cPerg,8 )
LOCAL nTamSX1   := LEN( SX1->X1_GRUPO )
LOCAL aRegs     := {}
LOCAL nPos
LOCAL nCount

	AADD( aRegs,{ cPergunta, '01',OemToAnsi(PadR('Conta De',19)+'?')   ,'','','mv_cha','C', 9,0,0,'G','','mv_par01','','','','','','','','','','','','','','','','','','','','','','','','','CT1','' } )
	AADD( aRegs,{ cPergunta, '02',OemToAnsi(PadR('Conta Ate',19)+'?')  ,'','','mv_chb','C', 9,0,0,'G','','mv_par02','','','','','','','','','','','','','','','','','','','','','','','','','CT1','' } )
	AADD( aRegs,{ cPergunta, "03",OemToAnsi(PadR("Data De",19)+"?")    ,'','',"mv_chc","D", 8,0,0,'G','','mv_par03','','','','','','','','','','','','','','','','','','','','','','','','','',   '' } )
	AADD( aRegs,{ cPergunta, "04",OemToAnsi(PadR("Data Ate",19)+"?")   ,'','',"mv_chd","D", 8,0,0,'G','','mv_par04','','','','','','','','','','','','','','','','','','','','','','','','','',   '' } )
	
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