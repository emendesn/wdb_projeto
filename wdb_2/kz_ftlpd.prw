# include "Protheus.ch"
# include "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ UpdAGENDAบ Autor ณ Edilson Mendes     บ Data ณ  11/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cria a tela para o usuแrio selecionar os produtos que irใo บฑฑ
ฑฑบ          ณ no pedido de vendas.                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cliente WDB                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
USER FUNCTION KZ_FTlPd()
	
LOCAL olDlg
LOCAL olMark
LOCAL cTmp		:= ""
LOCAL clBusc	:= Space(160)
LOCAL alItens	:= {}
LOCAL alIndice	:= {}
LOCAL clItens	:= ""
LOCAL nlIndice	:= 0
LOCAL llMrcTd	:= .F.

PRIVATE apCampos := {}
PRIVATE cpMarca  := "XX"//GetMark()

	IF .NOT. EMPTY(M->C5_DATAINI) .OR. .NOT. EMPTY(M->C5_DATAFIM)
		
		// Grupo de Produto
		
		clQry := "SELECT B1_COD,B1_DESC,BM_GRUPO,BM_DESC"
		clQry += " FROM "+RetSqlName("SB1")+" SB1"
		
		clQry += " JOIN "+RetSqlName("SBM")+" SBM"
		clQry += " ON SBM.D_E_L_E_T_ = ' ' "
		clQry += " AND BM_GRUPO = B1_GRUPO "
		
		clQry += " WHERE SB1.D_E_L_E_T_ = ' '"
		clQry += " ORDER BY B1_COD "
		
		clQry := ChangeQuery(clQry)
		
		TcQuery clQry New Alias "GRP"
		
		AADD(alItens,"")
		AADD(alItens,"Sem Grupo")
		GRP->(DBGoTop())
		WHILE GRP->( .NOT. EOF() )
			IF ASCAN( alItens, ALLTRIM(GRP->BM_DESC)) == 0
				AADD( alItens, ALLTRIM(GRP->BM_DESC))
			ENDIF
			GRP->(DBSkip())
		ENDDO
		GRP->(dbCloseArea())
		
		
		// Indice de Busa
		AADD( alIndice, "")
		AADD( alIndice, "B1_COD")
		AADD( alIndice, "B1_DESC")
		AADD( alIndice, "B1_COD+B1_DESC")
		
		// Produtos para preencher o GRID
		clQry := "SELECT DISTINCT '  ' AS OK
		clQry += ",1 AS QTD"
		clQry += ",0 AS SUBLOC"
		clQry += ",B1_COD"
		clQry += ",B1_DESC"
		clQry += ",B1_UM"
		clQry += ",B1_TS"
		clQry += ",B1_PRV1"
		clQry += ",B1_LOCPAD"
		clQry += ",BM_GRUPO"
		clQry += ",BM_DESC"
		clQry += ",B2_QATU"
		
		clQry += " FROM "+RetSqlName("SB1")+" SB1"
		
		clQry += " LEFT JOIN "+RetSqlName("SB2")+" SB2"
		clQry += " ON SB2.D_E_L_E_T_ = ' ' "
		clQry += " AND B2_FILIAL = B1_FILIAL "
		clQry += " AND B2_COD = B1_COD"
		clQry += " AND B2_LOCAL = B1_LOCPAD"
		
		clQry += " LEFT JOIN "+RetSqlName("SBM")+" SBM"
		clQry += " ON SBM.D_E_L_E_T_ = ' ' "
		clQry += " AND BM_GRUPO = B1_GRUPO "
		clQry += " AND BM_FILIAL = B1_FILIAL"
		
		clQry += " WHERE SB1.D_E_L_E_T_ = ' '"
		clQry += " AND B1_FILIAL = '"+xFilial("SB1")+"'"
		clQry += " AND B1_FLAG = '1'
		clQry += " ORDER BY B1_COD "
		
		clQry	:= ChangeQuery(clQry)
		
		TcQuery clQry New Alias "TMP"
		
		cTmp := CriaTrab(Nil,.F.)
		DbSelectArea("TMP")
		
		Copy To &cTmp
		TMP->(DbCloseArea())
		
		DbUseArea(.T.,,cTmp,"TMP1",.F.,.F.)
		
		Index on B1_COD TAG IND1 TO &cTmp
		Index on B1_DESC TAG IND2 TO &cTmp
		Index on B1_COD+B1_DESC TAG IND3 TO &cTmp
		
		TMP1->(DBGoTop())
		WHILE TMP1->( .NOT. EOF())
			IF RecLocK("TMP1",.F.)
				REPLACE TMP1->QTD		With 1
				REPLACE TMP1->SUBLOC	With 0
				MsUnLock()
			ENDIF
			TMP1->(DBSkip())
		ENDDO
		
		TMP1->(DBGoTop())
		
		AADD( apCampos,{"OK"      ,    , ""           ,"" ,,})
		AADD( apCampos,{"B1_COD"  , "C", "Codigo"     ,"" ,15,0})
		AADD( apCampos,{"B1_DESC" , "C", "Descri็ใo"  ,"" ,40,0})
		AADD( apCampos,{"QTD"     , "N", "Quantidade" ,"@E 999999.99",9,2})
		
		olDlg :=  MSDialog():New(000,000,478,762,"Loca็ใo",,,,,,,,,.T.)
		
		@ 016,005 to 050,379 Pixel of olDlg
		
		@ 21 ,007 Say "Grupo de Produtos:" Pixel of olDlg
		olComboG := tComboBox():New( 020, 057, { |xItem| IF( PCount() > 0, clItens := xItem, clItens ) },;
		alItens,60,10,olDlg,,{|| Filtr(clItens,olMark),olMark:oBrowse:Refresh(),nlIndice:=0,clBusc:= Space(160) },,,,.T.,,,,,,,,,"clItens")
		
		@ 35 ,007 Say "Indice de Busca" Pixel of olDlg
		
		olComboP := tComboBox():New( 035, 057, { |xItem| IF( PCount() > 0, nlIndice := xItem, nlIndice ) },;
		alIndice,120,10,olDlg,,{|| FSetOrder(olComboP:NAT,olMark)},,,,.T.,,,,,,,,,"nlIndice")
		
		@ 35 ,180 MsGet olBusc var clBusc Picture "@!" size 80,08 Pixel of oldlg
		
		@ 35 ,265 Button "Buscar" Size 30,10 Action FPsq(olComboP:NAT,clBusc,clItens,olMark)		Pixel Of olDlg
		
		@ 227 ,007 Button "Marca/Desmarca Todos" 	Size 60,10 Action FMrcTdN(llMrcTd:=!llMrcTd)	Pixel Of olDlg
		@ 227 ,072 Button "Inverte Marca็ใo" 		Size 60,10 Action FInvMr() 						Pixel Of olDlg
		
		olMark:=MsSelect():New("TMP1","OK",,apCampos,,@cpMarca,{55,005,222,379})
		olMark:oBrowse:lhasMark    := .T.
		olMark:oBrowse:lCanAllmark := .F.
		olMark:oBrowse:BLDBLCLICK:={|| FQTD(TMP1->OK,TMP1->B1_COD,TMP1->B1_DESC,TMP1->QTD,TMP1->B1_TS,TMP1->B1_PRV1),olMark:oBrowse:Refresh()}
		
		ACTIVATE MSDIALOG olDlg CENTERED ON INIT EnchoiceBar(olDlg, {|| olDlg:End(),FVrfPAZ(),FCarAcol()},{|| olDlg:End()})
		
		DBSelectArea("TMP1")
		TMP1->(DBCloseArea())
		FErase(cTmp+GetDBExtension())
		
	ELSE
		
		Aviso("Aten็ใo","ษ necessแrio informar a Data Inicial e a Data Final do Evento",{"Ok"})
		
	ENDIF
	    
RETURN


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FMrcTdN  บ Autor ณ Edilson Mendes     บ Data ณ  11/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Realiza um filtro no Grid de acordo com o conteudo do      บฑฑ
ฑฑบ          ณ combobox Grupo de Produtos.                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ llMrcTd - Variavel logica Marca ou Nใo                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cliente WDB                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
STATIC PROCEDURE FMrcTdN(llMrcTd)

	DBSelectArea("TMP1")
	TMP1->(DBGoTop())
	
	IF llMrcTd
		WHILE TMP1->( .NOT. EOF() )
			IF RecLock("TMP1",.F.)
				REPLACE TMP1->OK With cpMarca
				MsUnLock()
			ENDIF
			TMP1->(DBSkip())
		EndDo
	ELSE
		WHILE TMP1->( .NOT. Eof())
			IF RecLock("TMP1",.F.)
				Replace TMP1->OK With Space(2)
				MsUnLock()
			ENDIF
			TMP1->(DBSkip())
		ENDDO
	ENDIF
	
	TMP1->(dbGoTop())
	
RETURN

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FInvMr   บ Autor ณ Edilson Mendes     บ Data ณ  11/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Realiza um filtro no Grid de acordo com o conteudo do      บฑฑ
ฑฑบ          ณ combobox Grupo de Produtos.                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cliente WDB                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
STATIC PROCEDURE FInvMr()
	
LOCAL clRecno := Recno()

	DBSelectArea("TMP1")
	TMP1->(DBGoTop())
	
	WHILE TMP1->( .NOT. Eof())
		IF TMP1->OK == cpMarca
			IF RecLock("TMP1",.F.)
				Replace TMP1->OK With Space(2)
				MsUnLock()
			ENDIF
		ELSE
			IF RecLock("TMP1",.F.)
				Replace TMP1->OK With cpMarca
				MsUnLock()
			ENDIF
		ENDIF
		TMP1->(dbSkip())
	ENDDO
	
	TMP1->(DBGoTo(clRecno))
		
RETURN


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Filtr    บ Autor ณ Edilson Mendes     บ Data ณ  11/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Realiza um filtro no Grid de acordo com o conteudo do      บฑฑ
ฑฑบ          ณ combobox Grupo de Produtos .                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ clItens - Conteudo do combobox                             บฑฑ
ฑฑบ          ณ olMark - Objeto do Grid                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cliente WDB                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
STATIC PROCEDURE Filtr(clItens,olMark)

	IF .NOT. EMPTY(clItens) .AND. clItens <> "Sem Grupo"
		
		// Monta filtro no TMP1 para mostrar apenas os Protutos que pertece ao grupo informado no combobox
		cFiltra := "ALLTRIM(TMP1->BM_DESC)=='"+ALLTRIM(clItens)+"'"
		TMP1->( DBsetfilter({|| ALLTRIM(TMP1->BM_DESC) == ALLTRIM(clItens)} , cFiltra))
		
	ELSEIF clItens == "Sem Grupo"
		
		cFiltra := "ALLTRIM(TMP1->BM_DESC) == '' "
		TMP1->( DBsetfilter({|| ALLTRIM(TMP1->BM_DESC) == ""} , cFiltra))
		
	ELSE
		
		// Limpa o Filtro
		TMP1->(dbclearfil())
		
	ENDIF
	
	olMark:oBrowse:Refresh()
	TMP1->(DBGoTop())
	
	IF EMPTY(TMP1->B1_COD)
		Aviso("Aten็ใo","Nใo foi localizado nenhum registro",{"Ok"})
	ENDIF
		
RETURN

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FPsq     บ Autor ณ Edilson Mendes     บ Data ณ  11/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Realiza a Pesquisa e posiciona no Grid de acordo com o     บฑฑ
ฑฑบ          ณ grupo e produto informado.                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ nIndice 	- Indice de Busca                                 บฑฑ
ฑฑบ          ณ Busc 	- Descri็ใo da busca                              บฑฑ
ฑฑบ          ณ clItens 	- Conteudo do combobox                            บฑฑ
ฑฑบ          ณ olMark 	- Objeto do Grid                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cliente WDB                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
STATIC PROCEDURE FPsq(nIndice,Busc,clItens,olMark)

	LOCAL nlRecno	:= 0
	
	IF nIndice > 1
	
		IF .NOT. EMPTY(Busc) 
			nlRecno := TMP1->(RECNO())
			DBSelectArea("TMP1")
			TMP1->(DBSetOrder(nIndice-1))
			IF TMP1->( DBSeek(ALLTRIM(Busc),.T.) )
				IF UPPER( ALLTRIM( TMP1->BM_DESC ) ) <> UPPER( ALLTRIM( clItens ) ) .AND. .NOT. EMPTY( ALLTRIM( clItens ) )
					Aviso("Aten็ใo","Nใo foi localizado nenhum registro para esse Grupo",{"Ok"})				
				ENDIF
			ELSE
				Aviso("Aten็ใo","Nใo foi localizado nenhum registro para esse Grupo",{"Ok"})				
				DBGoTo(nlRecno)										
			ENDIF
						
		ELSE
			Aviso("Aten็ใo","Informe algum parโmtro para realizar a pesquisa",{"Ok"})
			TMP1->(dbGoTop())
		ENDIF
	ENDIF

	olMark:oBrowse:Refresh()

RETURN


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FQTD     บ Autor ณ Edilson Mendes     บ Data ณ  11/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cria a tela para alterar a quantidade do produto no pedido บฑฑ
ฑฑบ          ณ de vendas.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ cStatus 	- Se estแ marcado ou nใo                          บฑฑ
ฑฑบ          ณ cod 		- Codigo do Produto                               บฑฑ
ฑฑบ          ณ desc	 	- Descri็ใo do Produto                            บฑฑ
ฑฑบ          ณ nQtd	 	- Quantidade                                      บฑฑ
ฑฑบ          ณ Tes 		- TES do Produto                                  บฑฑ
ฑฑบ          ณ Prc	 	- Pre็o de Venda                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cliente WDB                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
STATIC PROCEDURE FQTD(cStatus,cod,desc,nQtd,Tes,Prc)

LOCAL olDlg2
LOCAL nlQtd		:= 1
LOCAL llMarc	:= .F.
LOCAL llCmpPreen:= .T.
	
	
	IF EMPTY(Tes) .OR. EMPTY(Prc)
		Aviso("Aten็ใo","Nใo serแ possํvel selecionar o produto "+ ALLTRIM(cod)+" devido os campos B1_TS e B1_PRV1 nใo estarem preenchidos",{"Ok"})
		llCmpPreen := .F.
	ENDIF
	
	IF llCmpPreen
		IF .NOT. EMPTY( cStatus )
			llMarc	:= .T.
		ENDIF
		
		IF nQtd > 1
			nlQtd := nQtd
		ENDIF
		
		olDlg2 :=  MSDialog():New(000,000,160,305,"Quantidade",,,,,,,,,.T.)
		
		@ 05,05 to 75,148 PIXEL OF olDlg2
		
		@ 10 ,007 Say "Codigo" Pixel of olDlg2
		@ 10 ,050 Get cod size 50,08 when .F. Pixel of olDlg2
		
		@ 25 ,007 Say "Descri็ใo" Pixel of olDlg2
		@ 25 ,050 Get desc size 80,08 when .F. Pixel of olDlg2
		
		@ 40 ,007 Say "Quantidade" Pixel of olDlg2
		@ 40 ,050 Get nlQtd size 50,08 Picture "@E 999999.99" Pixel of olDlg2
		
		@ 062,007  CHECKBOX  olCheck1 var llMarc PROMPT "Marca/Desmarca"	SIZE 60,10 PIXEL OF olDlg2  ON CLICK( )
		
		DEFINE SBUTTON FROM  060,090 TYPE 01 ACTION Eval({|| FGrQtMr(cod,desc,nlQtd,llMarc),olDlg2:End()})  Enable OF olDlg2
		DEFINE SBUTTON FROM  060,120 TYPE 02 ACTION olDlg2:End() Enable OF olDlg2
		
		ACTIVATE MSDIALOG olDlg2 CENTERED
		
	ENDIF
		
RETURN


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FGrQtMr  บ Autor ณ Edilson Mendes     บ Data ณ  11/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Atualiza na tela do Grid se o produto foi selecionado e    บฑฑ
ฑฑบ          ณ quantidade.                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ cod  - Codigo do produto                                   บฑฑ
ฑฑบ          ณ desc - Descri็ใo do Produto                                บฑฑ
ฑฑบ          ณ qtd  - Quantidade do produto                               บฑฑ
ฑฑบ          ณ Marc - Variavel logica, Marca ou Nใo                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cliente WDB                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
STATIC PROCEDURE FGrQtMr(cod,desc,qtd,Marc)

LOCAL clRecno := RECNO()

	TMP1->(DBGoTo(clRecno))
	
	IF ( nExit := ASCAN( aCols, { |xItem| xItem[ GDFIELDPOS("C6_PRODUTO") ] == cod } ) ) > 0
		IF ( aCols[nExit][Len(aHeader)+1] )
			nExit := 0
		ENDIF
	ENDIF
	
	IF nExit == 0
		
		IF qtd > 0 .AND. Marc
			IF RecLock("TMP1",.F.)
				TMP1->QTD := qtd
				MsUnLock()
			ENDIF
		ENDIF
		IF Marc
			IF RecLock("TMP1",.F.)
				TMP1->OK := cpMarca
				MsUnLock()
			ENDIF
		ELSE
			IF RecLock("TMP1",.F.)
				TMP1->OK  := SPACE(2)
				TMP1->QTD := 1
				MsUnLock()
			ENDIF
		ENDIF
	ELSE
		Aviso("Aten็ใo","Jแ existe esse produto nos itens do pedido",{"OK"})
	ENDIF
	
	TMP1->(dbGoTo(clRecno))
		
RETURN

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FVrfPAZ  บ Autor ณ Edilson Mendes     บ Data ณ  11/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Verifica a disponibilidade do produto na tabela PAZ.       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ cod  - Codigo do produto                                   บฑฑ
ฑฑบ          ณ desc - Descri็ใo do Produto                                บฑฑ
ฑฑบ          ณ qtd  - Quantidade do produto                               บฑฑ
ฑฑบ          ณ Marc - Variavel logica, Marca ou Nใo                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cliente WDB                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
STATIC PROCEDURE FVrfPAZ()

LOCAL nlDisp	:= 0
LOCAL nlSubLoc	:= 0
LOCAL clQryPAZ	:= ""

	TMP1->(DBGoTop())
	WHILE TMP1->( .NOT. EOF())
		
		IF .NOT. EMPTY( TMP1->OK )
			
			IF TMP1->B2_QATU > 0
				
				clQryPAZ := "SELECT (SELECT SUM(PAZ_QUANT)"
				clQryPAZ += "			FROM "+ RetSqlName("PAZ")+ " PAZ "
				clQryPAZ += "			WHERE PAZ.D_E_L_E_T_ = ' '"
				clQryPAZ += "			AND PAZ_FILIAL = '"+xFilial("PAZ")+"'"
				clQryPAZ += "			AND PAZ_PRODUT = '"+ALLTRIM(TMP1->B1_COD)+"'"
				clQryPAZ += " 			AND(PAZ_DTINI BETWEEN	'"+ DtoS(M->C5_DATAINI)	+"' AND '"	+ DtoS(M->C5_DATAFIM)+"'"
				clQryPAZ += " 			OR 	PAZ_DTFIM BETWEEN	'"+DtoS(M->C5_DATAINI)	+"' AND '"	+ DtoS(M->C5_DATAFIM)+"'"
				clQryPAZ += " 			OR (PAZ_DTINI <= '"+DtoS(M->C5_DATAINI)+"' AND PAZ_DTFIM >= '"+DtoS(M->C5_DATAFIM) +"' ))"
				clQryPAZ += "			GROUP BY PAZ_PRODUT)AS TOTAL"
				clQryPAZ += "			,PAZ_PRODUT"
				
				clQryPAZ += " FROM "+ RetSqlName("PAZ")+ " PAZ "
				clQryPAZ += " WHERE PAZ.D_E_L_E_T_ = ' '"
				clQryPAZ += " AND PAZ_FILIAL = '"+xFilial("PAZ")+"'"
				clQryPAZ += " AND PAZ_PRODUT = '"+ALLTRIM(TMP1->B1_COD)+"'"
				clQryPAZ += " AND(	PAZ_DTINI BETWEEN	'"+ DtoS(M->C5_DATAINI)	+"' AND '"	+ DtoS(M->C5_DATAFIM)+"'"
				clQryPAZ += " OR 	PAZ_DTFIM BETWEEN	'"+DtoS(M->C5_DATAINI)	+"' AND '"	+ DtoS(M->C5_DATAFIM)+"'"
				clQryPAZ += " OR (PAZ_DTINI <= '"+DtoS(M->C5_DATAINI)+"' AND PAZ_DTFIM >= '"+DtoS(M->C5_DATAFIM) +"' ))"
				
				clQryPAZ += " GROUP BY PAZ_PRODUT"
				
				TcQuery clQryPAZ New Alias "TMPP"
				
				nlDisp	:= TMP1->B2_QATU - TMPP->TOTAL
				
				IF nlDisp > 0
					IF TMP1->QTD > nlDisp
						nlSubLoc := TMP1->QTD - nlDisp
						IF RecLock("TMP1",.F.)
							REPLACE TMP1->SUBLOC WITH nlSubLoc
							Aviso("Aten็ใo","Produto de C๓digo: "+ALLTRIM(TMP1->B1_COD)+", Descri็ใo: "+ALLTRIM(TMP1->B1_DESC)+", foi sublocado em quantidade igual a "+ALLTRIM(Str(nlSubLoc))+".",{"Ok"})
							MsUnLock()
						ENDIF
					ELSE
						TMP1->SUBLOC := 0
					ENDIF
				ELSE
					IF RecLock("TMP1",.F.)
						REPLACE TMP1->SUBLOC WITH TMP1->QTD
						Aviso("Aten็ใo","Produto de C๓digo: "+ALLTRIM(TMP1->B1_COD)+", Descri็ใo: "+ALLTRIM(TMP1->B1_DESC)+", foi sublocado em quantidade igual a "+ALLTRIM(Str(TMP1->QTD))+".",{"Ok"})
						MsUnLock()
					ENDIF
				ENDIF
				
				TMPP->(DBCloseArea())
				
			ELSE
				IF RecLock("TMP1",.F.)
					REPLACE TMP1->SUBLOC WITH TMP1->QTD
					Aviso("Aten็ใo","Produto de C๓digo: "+ALLTRIM(TMP1->B1_COD)+", Descri็ใo: "+ALLTRIM(TMP1->B1_DESC)+", foi sublocado em quantidade igual a "+ALLTRIM(Str(TMP1->QTD))+".",{"Ok"})
					MsUnLock()
				ENDIF
			ENDIF
		ENDIF
		TMP1->(dbSkip())
	ENDDO
	
RETURN


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FCarAcol บ Autor ณ Edilson Mendes     บ Data ณ  11/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Carrega no aCols do pedido de venda os produtos            บฑฑ
ฑฑบ          ณ selecionados na tela anterior                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cliente WDB                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
STATIC PROCEDURE FCarAcol()

	LOCAL nlItem := Len(aCols)+1
	
	nProd   := ASCAN( aHeader,  { |xItem| ALLTRIM( xItem[2] ) == "C6_PRODUTO" })	
	cUnid	:= ASCAN( aHeader,  { |xItem| ALLTRIM( xItem[2] ) == "C6_UM"      })
	nQuant	:= ASCAN( aHeader,  { |xItem| ALLTRIM( xItem[2] ) == "C6_QTDVEN"  })
	nUnit	:= ASCAN( aHeader,  { |xItem| ALLTRIM( xItem[2] ) == "C6_PRCVEN"  })	
	nValTot := ASCAN( aHeader,  { |xItem| ALLTRIM( xItem[2] ) == "C6_VALOR"   })
	cTes	:= ASCAN( aHeader,  { |xItem| ALLTRIM( xItem[2] ) == "C6_TES"     })
	nSub	:= ASCAN( aHeader,  { |xItem| ALLTRIM( xItem[2] ) == "C6_QTDSUB"  })
	nLoc	:= ASCAN( aHeader,  { |xItem| ALLTRIM( xItem[2] ) == "C6_LOCAL"   })
	nPosDtaI:= 	ASCAN( aHeader, { |xItem| ALLTRIM( xItem[2] ) == "C6_DINIC"   })
	nPosDtaF:= 	ASCAN( aHeader, { |xItem| ALLTRIM( xItem[2] ) == "C6_DFINAL"  })	
			
	DBSelectArea("TMP1")
	TMP1->( DBGoTop() )
	While TMP1->( .NOT. EOF() )
		IF .NOT. EMPTY( TMP1->OK )
			
			n := LEN(aCols)
			
			IF n > 1 .OR. .NOT. EMPTY( aCols[n][nProd] )
			
				AADD( aCols, ARRAY( LEN( aHeader )+1 ) )
				n++
				FOR nPos := 1 TO LEN(aHeader)
				
					IF ( aHeader[nPos,2] <> "C6_REC_WT" ) .AND. ( aHeader[nPos,2] <> "C6_ALI_WT" )
						aCols[n,nPos] := CriaVar(aHeader[nPos,2])
					ENDIF
				NEXT
				aCols[n,1] := ALLTRIM( STRZERO( nlItem, 2 ) )
				nlItem++
				aCols[n,Len(aHeader)+1] := .F.
				
			ENDIF
						
			IF nProd > 0 .AND. ;
			   cUnid > 0 .AND. ;
			   nQuant > 0 .AND. ;
			   nUnit > 0 .AND. ;
			   nValTot > 0 .AND. ;
			   cTes > 0 .AND. ;			   			   			   
			   nSub > 0 .AND. ;
			   nLoc > 0 .AND. ;
			   nPosDtaI > 0 .AND.;
			   nPosDtaF > 0 			   			   
			   
				aCols[n][nProd]		:= TMP1->B1_COD
				aCols[n][cUnid]		:= TMP1->B1_UM
				aCols[n][nQuant]	:= TMP1->QTD
				aCols[n][nUnit]		:= TMP1->B1_PRV1
				aCols[n][nValTot]	:= (TMP1->QTD*TMP1->B1_PRV1)
				aCols[n][cTes]		:= TMP1->B1_TS
				aCols[n][nSub]		:= TMP1->SUBLOC
				aCols[n][nLoc]		:= TMP1->B1_LOCPAD
				aCols[n][nPosDtaI]	:= M->C5_DATAINI
				aCols[n][nPosDtaF]	:= M->C5_DATAFIM
				
			ENDIF
			
		ENDIF
		
		TMP1->(dbSkip())
		
	ENDDO
	
	oGetDad:Refresh()
		
RETURN


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FSetOrderบ Autor ณ Edilson Mendes     บ Data ณ  11/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Define a ordem do arquivo temporario.                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cliente WDB                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/	
STATIC PROCEDURE FSetOrder(nlIndex,olMark)

	IF nlIndex > 1
		DBSelectArea("TMP1")
		TMP1->( DBSetOrder(nlIndex - 1) )
		TMP1->( DBGoTop() )
	ENDIF
	
	olMark:oBrowse:Refresh()

RETURN