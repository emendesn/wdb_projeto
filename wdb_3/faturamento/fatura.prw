#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Fatura   � Autor � Edilson Mendes     � Data �  11/10/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Realiza a emissao da fatura.                               ���
�������������������������������������������������������������������������͹��
���Parametro �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Cliente WDB                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER FUNCTION Fatura()        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99

LOCAL cPerg   := "MTR750"

	IF Pergunte( cPerg, .T.)
		
		RptStatus({|| RunReport() } )
		
	ENDIF
		
RETURN


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RunReport� Autor � Edilson Mendes     � Data �  11/10/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Realiza a montagem da fatura grafica para impressao.       ���
�������������������������������������������������������������������������͹��
���Parametro �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Cliente WDB                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC PROCEDURE RunReport()

LOCAL aArea        := GetArea()
LOCAL aStruct      := {}
LOCAL nLinha       := 0
LOCAL nColuna      := 0
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
LOCAL oFont10v     := TFont():New( "Verdana",,10,,.f.,,,,,.f. )
LOCAL oFont11v     := TFont():New( "Verdana",,11,,.f.,,,,,.f. )
LOCAL oFont11vn    := TFont():New( "Verdana",,11,,.t.,,,,,.f. )

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
		
		oPrint:SayBitmap( 0050, 0010, cFileLogo, 2320, 500)   // 2610
		
		oPrint:Box( nLinha      , 0020, nLinha+  100,2330) // Box Destinatarios
		oPrint:Say( nLinha +  30, 1000, OemToAnsi("Destinatario"), oFont11vn,100 )
		
		// Imprime o Nr da Fatura no Cabecario
		oPrint:Say( nLinha+  30, 2060, OemToAnsi( "No. " + TRANSFORM( TMP->F2_DOC, PesqPict("SF2","F2_DOC") ) ), oFont11vn,100 )
		
		oPrint:Box( nLinha+  100, 0020, nLinha+  450,2330) // Box Dados do Destinatarios
		oPrint:Say( nLinha+  130, 0150, OemToAnsi("Razao Social"), oFont11vn,100 )
		oPrint:Say( nLinha+  190, 0225, OemToAnsi("Endereco"), oFont11vn,100 )
		oPrint:Say( nLinha+  190, 1750, OemToAnsi("CEP"), oFont11vn,100 )
		oPrint:Say( nLinha+  250, 0220, OemToAnsi("Municipio"), oFont11vn,100 )
		oPrint:Say( nLinha+  250, 1750, OemToAnsi("UF"), oFont11vn,100 )
		oPrint:Say( nLinha+  310, 0310, OemToAnsi("CNPJ"), oFont11vn,100 )
		oPrint:Say( nLinha+  310, 1750, OemToAnsi("IE"), oFont11vn,100 )
		oPrint:Say( nLinha+  370, 0250, OemToAnsi("Emissao"), oFont11vn,100 )
		
		// Natureza da Operacao
		oPrint:Say( nLinha+  370, 1280, OemToAnsi("Natureza da Operacao"), oFont11vn,100 )
		oPrint:Say( nLinha+  370, 1890, OemToAnsi("Locacao de Bens Mov."), oFont11v,100 )
		
		IF SA1->( DBSetOrder(1), DBSeek( xFilial("SA1") + TMP->F2_CLIENTE + TMP->F2_LOJA ) )
			
			oPrint:Say( nLinha+  130, 0500, OemToAnsi( TRANSFORM( ALLTRIM( SA1->A1_NOME ), X3Picture("A1_NOME") ) ), oFont11v,100 ) // Razao Social
			oPrint:Say( nLinha+  190, 0500, OemToAnsi( TRANSFORM( ALLTRIM( SA1->A1_END ), X3Picture("A1_END") ) ), oFont11v,100 )
			oPrint:Say( nLinha+  190, 1900, OemToAnsi( TRANSFORM( ALLTRIM( SA1->A1_CEP ), X3Picture("A1_CEP") ) ), oFont11v,100 )
			oPrint:Say( nLinha+  250, 0500, OemToAnsi( TRANSFORM( ALLTRIM( SA1->A1_MUN ), X3Picture("A1_MUN") ) ), oFont11v,100 )
			oPrint:Say( nLinha+  250, 1900, OemToAnsi( TRANSFORM( ALLTRIM( SA1->A1_EST ), X3Picture("A1_EST") ) ), oFont11v,100 )
			oPrint:Say( nLinha+  310, 0500, OemToAnsi( TRANSFORM( ALLTRIM( SA1->A1_CGC ), X3Picture("A1_CGC") ) ), oFont11v,100 )
			oPrint:Say( nLinha+  310, 1900, OemToAnsi( TRANSFORM( ALLTRIM( SA1->A1_INSCR ), X3Picture("A1_INSCR") ) ), oFont11v,100 )
			
		ENDIF
		
		// Preenche a Data de Emissao da Fatura
		oPrint:Say( nLinha+  370, 0500, OemToAnsi( TRANSFORM( SF2->F2_EMISSAO, PesqPict("SF2","F2_EMISSAO") ) ), oFont11v,100 )
		
		// Carrega os Vencimento da Fatura
		oPrint:Box( nLinha+  450, 0020, nLinha+  550,2330) // Box Cabecario Dados dos Produtos
		oPrint:Say( nLinha+  480, 1000, OemToAnsi("Vencimentos"), oFont11vn,100 )
		oPrint:Box( nLinha+  550, 0020, nLinha+ 650,2330) // Box Dados dos Produtos
		
		nColuna := 50
		IF SE1->( DBSetOrder(2), DBSeek( xFilial("SE1") + TMP->F2_CLIENTE + TMP->F2_LOJA + TMP->F2_SERIE + TMP->F2_DOC ) )
			WHILE SE1->( .NOT. EOF() ) .AND. SE1->E1_FILIAL == xFilial("SE1") .AND. ;
				SE1->E1_CLIENTE == TMP->F2_CLIENTE .AND. SE1->E1_LOJA == TMP->F2_LOJA .AND. ;
				SE1->E1_PREFIXO == TMP->F2_SERIE .AND. SE1->E1_NUM == TMP->F2_DOC
				oPrint:Say( nLinha+  580, nColuna, OemToAnsi( TRANSFORM( SE1->E1_PARCELA, PesqPict("SE1","E1_PARCELA") ) + "-" + ;
				                                              TRANSFORM( SE1->E1_VENCTO, PesqPict("SE1","E1_VENCTO") ) + "-R$" + ;
				                                              ALLTRIM( TRANSFORM( SE1->E1_VALOR, PesqPict("SE1","E1_VALOR") ) ) ), oFont11v,100 )
				nColuna += 600
				SE1->( DBSkip() )
			ENDDO
		ENDIF
		
		oPrint:Box( nLinha+  650, 0020, nLinha+  750,2330) // Box Cabecario Dados dos Produtos
		oPrint:Say( nLinha+  680, 0150, OemToAnsi("Unid."), oFont11vn,100 )
		oPrint:Say( nLinha+  680, 0350, OemToAnsi("Qtd."), oFont11vn,100 )
		oPrint:Say( nLinha+  680, 0650, OemToAnsi("Discriminacao/Especificacao"), oFont11vn,100 )
		oPrint:Say( nLinha+  680, 1750, OemToAnsi("R$ Unid."), oFont11vn,100 )
		oPrint:Say( nLinha+  680, 2100, OemToAnsi("R$ Total."), oFont11vn,100 )
		
		oPrint:Box( nLinha+  750, 0020, nLinha+ 1100,2330) // Box Dados dos Produtos
		
		IF SD2->( DBSetOrder(3), DBSeek( xFilial("SD2") + TMP->F2_DOC + TMP->F2_SERIE + TMP->F2_CLIENTE + TMP->F2_LOJA ) )
			cPedido := SD2->D2_PEDIDO
			nCount  := ( nLinha + 750 )
			WHILE SD2->( .NOT. EOF() ) .AND. SD2->D2_FILIAL == xFilial("SD2") .AND. ;
				SD2->D2_DOC == TMP->F2_DOC .AND. SD2->D2_SERIE == TMP->F2_SERIE .AND. ;
				SD2->D2_CLIENTE == TMP->F2_CLIENTE .AND. SD2->D2_LOJA == TMP->F2_LOJA
				
				oPrint:Say( nCount, 0250, OemToAnsi( PADR( TRANSFORM( SD2->D2_QUANT, PesqPict("SD2","D2_QUANT") ), TamSX3("D2_QUANT")[1] ) ), oFont10v,100 )
				IF SC6->( DBSetOrder(1), DBSeek( xFilial("SC6") + SD2->D2_PEDIDO + SD2->D2_ITEMPV ) )
					oPrint:Say( nCount, 0650, OemToAnsi( TRANSFORM( ALLTRIM( SC6->C6_DESCRI ), PesqPict("SC6","C6_DESCRI") ) ), oFont10v,100 ) // Descricao do Produto
				ENDIF
				oPrint:Say( nCount, 1700, OemToAnsi( PADR( TRANSFORM( SD2->D2_PRCVEN, PesqPict("SD2","D2_PRCVEN") ), TamSX3("D2_PRCVEN")[1] ) ), oFont10v,100 )
				oPrint:Say( nCount, 2050, OemToAnsi( PADR( TRANSFORM( SD2->D2_TOTAL + SD2->D2_VALIMP1 + SD2->D2_VALIMP2, PesqPict("SD2","D2_TOTAL") ), TamSX3("D2_TOTAL")[1] ) ), oFont10v,100 )
				
				nTotFat += SD2->D2_TOTAL + SD2->D2_VALIMP1 + SD2->D2_VALIMP2
				nCount  += 50
				
				SD2->( DBSkip() )
				
			ENDDO
			
		ENDIF
		
		oPrint:Box( nLinha+ 1100, 0020, nLinha+ 1700,2330) // Box Observacoes
		
		IF SC5->( DBSetOrder(1), DBSeek( xFilial("SC5") + cPedido ) )
			nTam      := TamSX3("YP_TEXTO")[1]
			cMemo     := AllTrim( MSMM( SC5->C5_COD_OBS ) )
			nMemCount := MlCount( cMemo, nTam,, .T. )
			nCount    := ( nLinha + 1200 )
			IF .NOT. EMPTY( nMemCount )
				FOR nPos := 1 TO nMemCount
					cLinha := MemoLine( cMemo, nTam, nPos )
					oPrint:Say( nCount, 0150, OemToAnsi( cLinha ), oFont11v,100 )
					nCount += 50
				NEXT
			ENDIF
		ENDIF
		
		oPrint:Box( nLinha+ 1700, 0020, nLinha+ 1900,2330) // Box com a Legislacao
		oPrint:Say( nLinha+ 1730, 0120, OemToAnsi("Operacao nao Sujeita a emissao de Nota Fiscal de Servico-Vetada a cobranca de ISS Conforme Lei"), oFont11v,100 )
		oPrint:Say( nLinha+ 1790, 0120, OemToAnsi("Complementar 116/03."), oFont11v,100 )
		
		oPrint:Box( nLinha+ 1900, 0020, nLinha+ 2000,2330) // Box com o Total
		oPrint:Say( nLinha+ 1930, 1750, OemToAnsi("R$ Total."), oFont11vn,100 )
		oPrint:Say( nLinha+ 1930, 2000, OemToAnsi( PADR( TRANSFORM( nTotFat, PesqPict("SD2","D2_TOTAL") ), TamSX3("D2_TOTAL")[1] ) ), oFont11vn,100 )
		
		oPrint:Box( nLinha+ 2000, 0020, nLinha+ 2200,2330) // Box com os dados da Fatura
		oPrint:Say( nLinha+ 2030, 0120, OemToAnsi("Recebi/emos de ,"), oFont11v,100 )
		oPrint:Say( nLinha+ 2030, 0500, OemToAnsi( TRANSFORM( ALLTRIM( SM0->M0_NOMECOM ), "@!") ), oFont11v,100 )
		oPrint:Say( nLinha+ 2090, 0120, OemToAnsi("Os servicos constantes na Nota Fatura"), oFont11v,100 )
		oPrint:Say( nLinha+ 2090, 1000, OemToAnsi( TRANSFORM( TMP->F2_DOC, PesqPict("SF2","F2_DOC") ) ), oFont11vn,100 )
		
		oPrint:Box( nLinha+ 2200, 0020, nLinha+ 2600,2330) // Box com os dados da Cobranca
		oPrint:Say( nLinha+ 2230, 0150, OemToAnsi("Dados de Cobranca:"), oFont11vn,100 )
		oPrint:Say( nLinha+ 2350, 0150, OemToAnsi("Endereco"), oFont11vn,100 )
		oPrint:Say( nLinha+ 2470, 0190, OemToAnsi("Cidade"), oFont11vn,100 )
		oPrint:Say( nLinha+ 2470, 1750, OemToAnsi("CEP"), oFont11vn,100 )
		
		oPrint:EndPage()
		
		TMP->( DBSkip() )
		
	ENDDO
	
	oPrint:Preview()
	
	MS_FLUSH()
	
	TMP->( DBCloseArea() )
	
	RestArea(aArea)
								
RETURN	

