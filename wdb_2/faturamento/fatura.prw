#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Fatura   º Autor ³ Edilson Mendes     º Data ³  11/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Realiza a emissao da fatura.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Cliente WDB                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER FUNCTION Fatura()        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99

LOCAL cPerg   := "MTR750"

	IF Pergunte( cPerg, .T.)
		
		RptStatus({|| RunReport() } )
		
	ENDIF
		
RETURN


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RunReportº Autor ³ Edilson Mendes     º Data ³  11/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Realiza a montagem da fatura grafica para impressao.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Cliente WDB                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC PROCEDURE RunReport()

LOCAL aArea        := GetArea()
LOCAL aStruct      := {}
LOCAL nLinha       := 0
LOCAL nPagina      := 800
LOCAL lPrimaryPage := .T.
LOCAL nTotFat
LOCAL nCount
LOCAL cPedido
LOCAL cQuery
LOCAL oPrint
LOCAL nTam
LOCAL cMemo
LOCAL nMemCount
LOCAL cLinha
LOCAL cFileLogo    := GetSrvProfString('Startpath','') + 'WDBLOGO' + '.JPG'

LOCAL oFont
LOCAL oFont1       := TFont():New( "Arial",,16,,.t.,,,,,.f. )
LOCAL oFont2       := TFont():New( "Arial",,16,,.f.,,,,,.f. )
LOCAL oFont3       := TFont():New( "Arial",,10,,.t.,,,,,.f. )
LOCAL oFont4       := TFont():New( "Arial",,10,,.f.,,,,,.f. )
LOCAL oFont5       := TFont():New( "Arial",,06,,.t.,,,,,.f. )
LOCAL oFont6       := TFont():New( "Arial",,08,,.f.,,,,,.f. )
LOCAL oFont7       := TFont():New( "Arial",,14,,.t.,,,,,.f. )
LOCAL oFont8       := TFont():New( "Arial",,14,,.f.,,,,,.f. )
LOCAL oFont9       := TFont():New( "Arial",,12,,.t.,,,,,.f. )
LOCAL oFont10      := TFont():New( "Arial",,12,,.f.,,,,,.f. )

LOCAL oFont1c      := TFont():New( "Courier New",,16,,.t.,,,,,.f. )
LOCAL oFont2c      := TFont():New( "Courier New",,16,,.f.,,,,,.f. )
LOCAL oFont3c      := TFont():New( "Courier New",,10,,.t.,,,,,.f. )
LOCAL oFont4c      := TFont():New( "Courier New",,10,,.f.,,,,,.f. )
LOCAL oFont5c      := TFont():New( "Courier New",,09,,.t.,,,,,.f. )
LOCAL oFont6c      := TFont():New( "Courier New",,09,,.T.,,,,,.f. )
LOCAL oFont7c      := TFont():New( "Courier New",,14,,.t.,,,,,.f. )
LOCAL oFont8c      := TFont():New( "Courier New",,14,,.f.,,,,,.f. )
LOCAL oFont9c      := TFont():New( "Courier New",,12,,.t.,,,,,.f. )
LOCAL oFont10c     := TFont():New( "Courier New",,12,,.f.,,,,,.f. )


	// Carrega a Estrutura da tabela SE1
	DBSelectArea("SX3")
	SX3->( DBSetOrder(1), DBSeek("SF2") )
	WHILE SX3->( .NOT. EOF() ) .AND. SX3->X3_ARQUIVO == "SF2"
		AADD( aStruct, { SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL } )
		SX3->( DBSkip() )
	ENDDO
	
	cQuery	:=	"SELECT *"
	cQuery	+=	" FROM " + RetSqlName("SF2")
	cQuery	+=	" WHERE F2_FILIAL = '"+ xFilial("SF2") +"' AND F2_DOC >= '"+ MV_PAR01 +"' AND F2_DOC <= '"+ MV_PAR02 +"' AND"
	cQuery	+=	" F2_SERIE = '"+ MV_PAR03 +"' AND D_E_L_E_T_ <> '*'"
	cQuery	+=	" ORDER BY F2_FILIAL, F2_DOC"
	
	DbUseArea(.T.,'TOPCONN',TCGenQry(,,cQuery),"TMP",.t.,.t.)
	
	FOR nPos := 1 TO LEN( aStruct )
		IF aStruct[ nPos, 2] <> 'C'
			TCSetField( 'TMP', aStruct[ nPos, 1], aStruct[ nPos, 2], aStruct[ nPos, 3], aStruct[ nPos, 4] )
		ENDIF
	NEXT
	
	
	oPrint := TMSPrinter():New(OemToAnsi("Emissao de Faturas"))
	oPrint:Setup()
	
	oPrint:Say( nLinha, 0020, " ",oFont,100 ) // startando a impressora
	
	WHILE TMP->( .NOT. EOF() )
		
		nTotFat := 0
		nLinha  := 500
		cPedido := ""
		
		oPrint:SayBitmap( 0050, 0100, cFileLogo, 2320, 500)   // 2610
		
		oPrint:Box( nLinha      , 0100, nLinha+  100,2430) // Box Destinatarios
		oPrint:Say( nLinha +  30, 1150, OemToAnsi("Destinatario:"), oFont7,100 )
		
		oPrint:Box( nLinha+  100, 0100, nLinha+  450,2430) // Box Dados do Destinatarios
		oPrint:Say( nLinha+  130, 0150, OemToAnsi("Razao Social"), oFont7,100 )
		oPrint:Say( nLinha+  190, 0225, OemToAnsi("Endereco"), oFont7,100 )
		oPrint:Say( nLinha+  190, 1750, OemToAnsi("CEP"), oFont7,100 )
		oPrint:Say( nLinha+  250, 0220, OemToAnsi("Municipio"), oFont7,100 )
		oPrint:Say( nLinha+  250, 1750, OemToAnsi("UF"), oFont7,100 )
		oPrint:Say( nLinha+  310, 0310, OemToAnsi("CNPJ"), oFont7,100 )
		oPrint:Say( nLinha+  310, 1750, OemToAnsi("IE"), oFont7,100 )
		oPrint:Say( nLinha+  370, 0170, OemToAnsi("Vencimento"), oFont7,100 )
		
		IF SA1->( DBSetOrder(1), DBSeek( xFilial("SA1") + TMP->F2_CLIENTE + TMP->F2_LOJA ) )
			
			oPrint:Say( nLinha+  130, 0500, OemToAnsi( TRANSFORM( ALLTRIM( SA1->A1_NOME ), X3Picture("A1_NOME") ) ), oFont8,100 ) // Razao Social
			oPrint:Say( nLinha+  190, 0500, OemToAnsi( TRANSFORM( ALLTRIM( SA1->A1_END ), X3Picture("A1_END") ) ), oFont8,100 )
			oPrint:Say( nLinha+  190, 1900, OemToAnsi( TRANSFORM( ALLTRIM( SA1->A1_CEP ), X3Picture("A1_CEP") ) ), oFont8,100 )
			oPrint:Say( nLinha+  250, 0500, OemToAnsi( TRANSFORM( ALLTRIM( SA1->A1_MUN ), X3Picture("A1_MUN") ) ), oFont8,100 )
			oPrint:Say( nLinha+  250, 1900, OemToAnsi( TRANSFORM( ALLTRIM( SA1->A1_EST ), X3Picture("A1_EST") ) ), oFont8,100 )
			oPrint:Say( nLinha+  310, 0500, OemToAnsi( TRANSFORM( ALLTRIM( SA1->A1_CGC ), X3Picture("A1_CGC") ) ), oFont8,100 )
			oPrint:Say( nLinha+  310, 1900, OemToAnsi( TRANSFORM( ALLTRIM( SA1->A1_INSCR ), X3Picture("A1_INSCR") ) ), oFont8,100 )
			
		ENDIF
		
		IF SE1->( DBSetOrder(2), DBSeek( xFilial("SE1") + TMP->F2_CLIENTE + TMP->F2_LOJA + TMP->F2_SERIE + TMP->F2_DOC ) )
			oPrint:Say( nLinha+  370, 0500, OemToAnsi( TRANSFORM( SE1->E1_VENCTO, PesqPict("SE1","E1_VENCTO") ) ), oFont8,100 )
		ENDIF
		
		oPrint:Box( nLinha+  450, 0100, nLinha+  550,2430) // Box Cabecario Dados dos Produtos
		oPrint:Say( nLinha+  480, 0150, OemToAnsi("Unid."), oFont7,100 )
		oPrint:Say( nLinha+  480, 0350, OemToAnsi("Qtd."), oFont7,100 )
		oPrint:Say( nLinha+  480, 0650, OemToAnsi("Discriminacao/Especificacao"), oFont7,100 )
		oPrint:Say( nLinha+  480, 1850, OemToAnsi("R$ Unid."), oFont7,100 )
		oPrint:Say( nLinha+  480, 2200, OemToAnsi("R$ Total."), oFont7,100 )
		
		oPrint:Box( nLinha+  550, 0100, nLinha+ 1100,2430) // Box Dados dos Produtos
		
		IF SD2->( DBSetOrder(3), DBSeek( xFilial("SD2") + TMP->F2_DOC + TMP->F2_SERIE + TMP->F2_CLIENTE + TMP->F2_LOJA ) )
			cPedido := SD2->D2_PEDIDO
			nCount  := ( nLinha + 550 )
			WHILE SD2->( .NOT. EOF() ) .AND. SD2->D2_FILIAL == xFilial("SD2") .AND. ;
				SD2->D2_DOC == TMP->F2_DOC .AND. SD2->D2_SERIE == TMP->F2_SERIE .AND. ;
				SD2->D2_CLIENTE == TMP->F2_CLIENTE .AND. SD2->D2_LOJA == TMP->F2_LOJA
				
				oPrint:Say( nCount, 0250, OemToAnsi( PADR( TRANSFORM( SD2->D2_QUANT, PesqPict("SD2","D2_QUANT") ), TamSX3("D2_QUANT")[1] ) ), oFont7,100 )
				IF SC6->( DBSetOrder(1), DBSeek( xFilial("SC6") + SD2->D2_PEDIDO + SD2->D2_ITEMPV ) )
					oPrint:Say( nCount, 0650, OemToAnsi( TRANSFORM( ALLTRIM( SC6->C6_DESCRI ), PesqPict("SC6","C6_DESCRI") ) ), oFont7,100 ) // Descricao do Produto
				ENDIF
				oPrint:Say( nCount, 1800, OemToAnsi( PADR( TRANSFORM( SD2->D2_PRCVEN, PesqPict("SD2","D2_PRCVEN") ), TamSX3("D2_PRCVEN")[1] ) ), oFont7,100 )
				oPrint:Say( nCount, 2150, OemToAnsi( PADR( TRANSFORM( SD2->D2_TOTAL + SD2->D2_VALIMP1 + SD2->D2_VALIMP2, PesqPict("SD2","D2_TOTAL") ), TamSX3("D2_TOTAL")[1] ) ), oFont7,100 )
				
				nTotFat += SD2->D2_TOTAL + SD2->D2_VALIMP1 + SD2->D2_VALIMP2
				nCount  += 50
				
				SD2->( DBSkip() )
				
			ENDDO
			
		ENDIF
		
		oPrint:Box( nLinha+ 1100, 0100, nLinha+ 1700,2430) // Box Observacoes
		
		IF SC5->( DBSetOrder(1), DBSeek( xFilial("SC5") + cPedido ) )
			nTam      := TamSX3("YP_TEXTO")[1]
			cMemo     := AllTrim( MSMM( SC5->C5_COD_OBS ) )
			nMemCount := MlCount( cMemo, nTam,, .T. )
			nCount    := ( nLinha + 1200 )
			IF .NOT. EMPTY( nMemCount )
				FOR nPos := 1 TO nMemCount
					cLinha := MemoLine( cMemo, nTam, nPos )
					oPrint:Say( nCount, 0150, OemToAnsi( cLinha ), oFont7,100 )
					nCount += 50
				NEXT
			ENDIF
		ENDIF
		
		oPrint:Box( nLinha+ 1700, 0100, nLinha+ 1900,2430) // Box com a Legislacao
		oPrint:Say( nLinha+ 1730, 0120, OemToAnsi("Operacao nao Sujeita a emissao de Nota Fiscal de Servico-Vetada a cobranca de ISS Conforme Lei"), oFont8,100 )
		oPrint:Say( nLinha+ 1790, 0120, OemToAnsi("Complementar 116/03."), oFont8,100 )
		
		oPrint:Box( nLinha+ 1900, 0100, nLinha+ 2000,2430) // Box com o Total
		oPrint:Say( nLinha+ 1930, 1900, OemToAnsi("R$ Total."), oFont7,100 )
		oPrint:Say( nLinha+ 1930, 2150, OemToAnsi( PADR( TRANSFORM( nTotFat, PesqPict("SD2","D2_TOTAL") ), TamSX3("D2_TOTAL")[1] ) ), oFont7,100 )
		
		oPrint:Box( nLinha+ 2000, 0100, nLinha+ 2200,2430) // Box com os dados da Fatura
		oPrint:Say( nLinha+ 2030, 0120, OemToAnsi("Recebi/emos de ,"), oFont8,100 )
		oPrint:Say( nLinha+ 2030, 0500, OemToAnsi( ALLTRIM( IIF( SA1->( DBSetOrder(1), DBSeek( xFilial("SA1") + TMP->F2_CLIENTE + TMP->F2_LOJA ) ), SA1->A1_NOME, "" ) ) ), oFont7,100 )
		oPrint:Say( nLinha+ 2090, 0120, OemToAnsi("Os servicos constantes na Nota Fatura"), oFont8,100 )
		oPrint:Say( nLinha+ 2090, 1000, OemToAnsi( TRANSFORM( TMP->F2_DOC, PesqPict("SF2","F2_DOC") ) ), oFont7,100 )
		
		oPrint:Box( nLinha+ 2200, 0100, nLinha+ 2600,2430) // Box com os dados da Cobranca
		oPrint:Say( nLinha+ 2230, 0150, OemToAnsi("Dados de Cobranca:"), oFont7,100 )
		oPrint:Say( nLinha+ 2350, 0150, OemToAnsi("Endereco"), oFont7,100 )
		oPrint:Say( nLinha+ 2470, 0190, OemToAnsi("Cidade"), oFont7,100 )
		oPrint:Say( nLinha+ 2470, 1750, OemToAnsi("CEP"), oFont7,100 )
		
		oPrint:EndPage()
		
		TMP->( DBSkip() )
		
	ENDDO
	
	oPrint:Preview()
	
	MS_FLUSH()
	
	TMP->( DBCloseArea() )
	
	RestArea(aArea)
						
RETURN	

