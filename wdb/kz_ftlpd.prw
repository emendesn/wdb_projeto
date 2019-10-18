# include "Protheus.ch"
# include "TOPCONN.CH"

/*#############################################################
##                   __   "   __                             ##
##                 ( __ \ | / __ ) Kazoolo                   ##
##                  ( _ / | \ _ )  Codefacttory              ##
###############################################################
## Função:     ## KZ_FTlPd.PRW                               ##
###############################################################
## Descrição:  ##  Cria a tela para o usuário selecionar os  ##
##			   ## produtos que irão no pedido de vendas      ##
###############################################################
## Autor :     ## Hermes Ferreira de Almeida                 ##
###############################################################
## Data:       ## 20/01/2010                                 ##
###############################################################
## Palavras Chaves: Produtos                                 ##
#############################################################*/

User Function KZ_FTlPd()
	
	Local olDlg		:= Nil
	Local olMark	:= NIl	
	Local cTmp		:= ""
	Local clBusc	:= Space(160)
	Local alItens	:= {}
	Local alIndice	:= {}
	Local clItens	:= ""
	Local nlIndice	:= 0
	Local llMrcTd	:= .F.
	

	Private apCampos	:= {}		
	Private cpMarca		:= "XX"//GetMark()
	
    If !Empty(M->C5_DATAINI) .OR. !Empty(M->C5_DATAFIM)

		// Grupo de Produto
		
		clQry := ""
		clQry := "SELECT B1_COD,B1_DESC,BM_GRUPO,BM_DESC"
		clQry += " FROM "+RetSqlName("SB1")+" SB1"
	
		clQry += " JOIN "+RetSqlName("SBM")+" SBM"
		clQry += " ON SBM.D_E_L_E_T_ = ' ' "
		clQry += " AND BM_GRUPO = B1_GRUPO "
		
		clQry += " WHERE SB1.D_E_L_E_T_ = ' '"
		clQry += " ORDER BY B1_COD "
	
		clQry	:= ChangeQuery(clQry)
	
		TcQuery clQry New Alias "GRP"
	
		aAdd(alItens,"")
		aAdd(alItens,"Sem Grupo")
		GRP->(dbGoTop())
		While !Eof()
			If Ascan(alItens, Alltrim(GRP->BM_DESC)) == 0
				aAdd(alItens,Alltrim(GRP->BM_DESC))
			EndIf
			dbSkip()
		EndDo
		GRP->(dbCloseArea())
		
		
	    // Indice de Busa
		aAdd(alIndice,"")
		aAdd(alIndice,"B1_COD")
		aAdd(alIndice,"B1_DESC")
		aAdd(alIndice,"B1_COD+B1_DESC")
		
	
		
	    // Produtos para preencher o GRID
		clQry := ""
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
		
		TMP1->(dbGoTop())
		While TMP1->(!Eof())
			If RecLocK("TMP1",.F.)
				Replace TMP1->QTD		With 1
				Replace TMP1->SUBLOC	With 0
				MsUnLock()
			EndIf
			TMP1->(dbSkip())
		EndDo
		
		TMP1->(dbGoTop())
		
		aAdd(apCampos,{"OK"			,   , ""			,""	,,})
		aAdd(apCampos,{"B1_COD"		,"C", "Codigo" 		,""	,15,0})
		aAdd(apCampos,{"B1_DESC"	,"C", "Descrição"	,""	,40,0})
		aAdd(apCampos,{"QTD"		,"N", "Quantidade"	,"@E 999999.99",9,2})
	
		olDlg :=  MSDialog():New(000,000,478,762,"Locação",,,,,,,,,.T.)
	
			@ 016,005 to 050,379 Pixel of olDlg
	
			@ 21 ,007 Say "Grupo de Produtos:" Pixel of olDlg
			olComboG:= tComboBox():New(020,057,{|u|if(PCount()>0,clItens:=u,clItens)},;
			alItens,60,10,olDlg,,{|| Filtr(clItens,olMark),olMark:oBrowse:Refresh(),nlIndice:=0,clBusc:= Space(160) },,,,.T.,,,,,,,,,"clItens")
	
			@ 35 ,007 Say "Indice de Busca" Pixel of olDlg
	
			olComboP:= tComboBox():New(035,057,{|u|if(PCount()>0,nlIndice:=u,nlIndice)},;
			alIndice,120,10,olDlg,,{|| FSetOrder(olComboP:NAT,olMark)},,,,.T.,,,,,,,,,"nlIndice")
	
			@ 35 ,180 MsGet olBusc var clBusc Picture "@!" size 80,08 Pixel of oldlg
	
			@ 35 ,265 Button "Buscar" Size 30,10 Action FPsq(olComboP:NAT,clBusc,clItens,olMark)		Pixel Of olDlg 
			
			@ 227 ,007 Button "Marca/Desmarca Todos" 	Size 60,10 Action FMrcTdN(llMrcTd:=!llMrcTd)	Pixel Of olDlg 
			@ 227 ,072 Button "Inverte Marcação" 		Size 60,10 Action FInvMr() 						Pixel Of olDlg 
	
			olMark:=MsSelect():New("TMP1","OK",,apCampos,,@cpMarca,{55,005,222,379})
			olMark:oBrowse:lhasMark := .T.
			olMark:oBrowse:lCanAllmark := .F.
			olMark:oBrowse:BLDBLCLICK:={|| FQTD(TMP1->OK,TMP1->B1_COD,TMP1->B1_DESC,TMP1->QTD,TMP1->B1_TS,TMP1->B1_PRV1),olMark:oBrowse:Refresh()}
	
		ACTIVATE MSDIALOG olDlg CENTERED ON INIT EnchoiceBar(olDlg, {|| olDlg:End(),FVrfPAZ(),FCarAcol()},{|| olDlg:End()}) 
	
		dbSelectArea("TMP1")
		TMP1->(dbCloseArea())
		FErase(cTmp+GetDBExtension())
		
	Else
	
    	Aviso("Atenção","É necessário informar a Data Inicial e a Data Final do Evento",{"Ok"})

    EndIf
Return


/*#############################################################
##                   __   "   __                             ##
##                 ( __ \ | / __ ) Kazoolo                   ##
##                  ( _ / | \ _ )  Codefacttory              ##
###############################################################
## Função:     ## FMrcTdN		                             ##
###############################################################
## Descrição:  ## Realiza um filtro no Grid de acordo com o  ##
##			   ## conteudo do combobox Grupo de Produtos     ##
###############################################################
## Parametros: ## llMrcTd - Variavel logica Marca ou Não	 ##
###############################################################
## Autor :     ## Hermes Ferreira de Almeida                 ##
###############################################################
## Data:       ## 20/01/2010                                 ##
###############################################################
## Palavras Chaves: Marca Todos                              ##
#############################################################*/
Static Function FMrcTdN(llMrcTd)

	dbSelectArea("TMP1")
	TMP1->(dbGoTop())

	If llMrcTd
		While TMP1->(!Eof())
			If RecLock("TMP1",.F.)
				Replace TMP1->OK With cpMarca
				MsUnLock()
			EndIf
			TMP1->(dbSkip())
		EndDo
	Else
		While TMP1->(!Eof())
			If RecLock("TMP1",.F.)
				Replace TMP1->OK With Space(2)
				MsUnLock()
			EndIf
			TMP1->(dbSkip())
		EndDo
	EndIf

	TMP1->(dbGoTop())

Return

/*#############################################################
##                   __   "   __                             ##
##                 ( __ \ | / __ ) Kazoolo                   ##
##                  ( _ / | \ _ )  Codefacttory              ##
###############################################################
## Função:     ## FInvMr		                             ##
###############################################################
## Descrição:  ## Realiza um filtro no Grid de acordo com o  ##
##			   ## conteudo do combobox Grupo de Produtos     ##
###############################################################
## Autor :     ## Hermes Ferreira de Almeida                 ##
###############################################################
## Data:       ## 20/01/2010                                 ##
###############################################################
## Palavras Chaves: Marca Todos                              ##
#############################################################*/
Static Function FInvMr()
	
	Local clRecno := Recno()
	
	dbSelectArea("TMP1")
	TMP1->(dbGoTop())
	
	While TMP1->(!Eof())
		If TMP1->OK == cpMarca
			If RecLock("TMP1",.F.)
				Replace TMP1->OK With Space(2)
				MsUnLock()
			EndIf
		Else
			If RecLock("TMP1",.F.)
				Replace TMP1->OK With cpMarca
				MsUnLock()
			EndIf
		EndIf
		TMP1->(dbSkip()) 
	EndDo
	
	TMP1->(dbGoTo(clRecno))
Return
/*#############################################################
##                   __   "   __                             ##
##                 ( __ \ | / __ ) Kazoolo                   ##
##                  ( _ / | \ _ )  Codefacttory              ##
###############################################################
## Função:     ## Filtr			                             ##
###############################################################
## Descrição:  ## Realiza um filtro no Grid de acordo com o  ##
##			   ## conteudo do combobox Grupo de Produtos     ##
###############################################################
## Parametros: ## clItens - Conteudo do combobox			 ##
##             ## olMark - Objeto do Grid			 		 ##
###############################################################
## Autor :     ## Hermes Ferreira de Almeida                 ##
###############################################################
## Data:       ## 20/01/2010                                 ##
###############################################################
## Palavras Chaves: Filtro                                   ##
#############################################################*/

Static Function Filtr(clItens,olMark)

	If !Empty(clItens) .AND. clItens <> "Sem Grupo"

		// Monta filtro no TMP1 para mostrar apenas os Protutos que pertece ao grupo informado no combobox
		cFiltra := "alltrim(TMP1->BM_DESC)=='"+alltrim(clItens)+"'"
		TMP1->(dbsetfilter({|| alltrim(TMP1->BM_DESC) == alltrim(clItens)} , cFiltra))

	ElseIf clItens == "Sem Grupo"

		cFiltra := "alltrim(TMP1->BM_DESC) == '' "
		TMP1->(dbsetfilter({|| alltrim(TMP1->BM_DESC) == ""} , cFiltra))

	Else

		// Limpa o Filtro
		TMP1->(dbclearfil())

	EndIf
	
	olMark:oBrowse:Refresh()
	TMP1->(dbGoTop())	

	If Empty(TMP1->B1_COD)
		Aviso("Atenção","Não foi localizado nenhum registro",{"Ok"})
	EndIf      
	

Return

/*#############################################################
##                   __   "   __                             ##
##                 ( __ \ | / __ ) Kazoolo                   ##
##                  ( _ / | \ _ )  Codefacttory              ##
###############################################################
## Função:     ## FPsq			                             ##
###############################################################
## Descrição:  ## Realiza a Pesquisa e posiciona no Grid de  ##
##			   ## acordo com o grupo e produto informado     ##
###############################################################
## Parametros: ## nIndice 	- Indice de Busca				 ##
##             ## Busc 		- Descrição da busca			 ##
##             ## clItens 	- Conteudo do combobox			 ##
##             ## olMark 	- Objeto do Grid				 ##
###############################################################
## Autor :     ## Hermes Ferreira de Almeida                 ##
###############################################################
## Data:       ## 20/01/2010                                 ##
###############################################################
## Palavras Chaves: Pesquisa                                 ##
#############################################################*/ 

Static Function FPsq(nIndice,Busc,clItens,olMark)
	Local nlRecno	:= 0
	
	If nIndice > 1
		If !Empty(Busc) 
			nlRecno := TMP1->(Recno())
			dbSelectArea("TMP1")
			dbSetOrder(nIndice-1)
			If dbSeek(Alltrim(Busc),.T.)   
			
				If Upper(Alltrim(TMP1->BM_DESC)) <> Upper(Alltrim(clItens)) .And. !Empty(Alltrim(clItens))
					Aviso("Atenção","Não foi localizado nenhum registro para esse Grupo",{"Ok"})				
			
				EndIf
			Else
				Aviso("Atenção","Não foi localizado nenhum registro para esse Grupo",{"Ok"})				
				dbGoTo(nlRecno)										
			EndIf
						
		Else
			Aviso("Atenção","Informe algum parâmtro para realizar a pesquisa",{"Ok"})
			TMP1->(dbGoTop())
		EndIf
	EndIf

	olMark:oBrowse:Refresh()

Return

/*#############################################################
##                   __   "   __                             ##
##                 ( __ \ | / __ ) Kazoolo                   ##
##                  ( _ / | \ _ )  Codefacttory              ##
###############################################################
## Função:     ## FQTD			                             ##
###############################################################
## Descrição:  ## Cria a tela para alterar a quantidade do   ##
##			   ## produto no pedido de vendas			     ##
###############################################################
## Parametros: ## cStatus 	- Se está marcado ou não		 ##
##             ## cod 		- Codigo do Produto				 ##
##             ## desc	 	- Descrição do Produto			 ##
##             ## nQtd	 	- Quantidade					 ##
##             ## Tes 		- TES do Produto				 ##
##             ## Prc	 	- Preço de Venda				 ##
###############################################################
## Autor :     ## Hermes Ferreira de Almeida                 ##
###############################################################
## Data:       ## 20/01/2010                                 ##
###############################################################
## Palavras Chaves: Quantidade                               ##
#############################################################*/ 
Static Function FQTD(cStatus,cod,desc,nQtd,Tes,Prc)

	Local olDlg2	:= Nil
	Local nlQtd		:= 1
	Local llMarc	:= .F.
	Local llCmpPreen:= .T.
	
	
	If Empty(Tes) .or. Empty(Prc)
		Aviso("Atenção","Não será possível selecionar o produto "+ Alltrim(cod)+" devido os campos B1_TS e B1_PRV1 não estarem preenchidos",{"Ok"})	
		llCmpPreen := .F.
	EndIf
	
	If llCmpPreen
		If !Empty(cStatus)
			llMarc	:= .T.
		EndIf
		
		If nQtd > 1
			nlQtd := nQtd
		EndIf
	
		olDlg2 :=  MSDialog():New(000,000,160,305,"Quantidade",,,,,,,,,.T.)
			
			@ 05,05 to 75,148 PIXEL OF olDlg2
			
			@ 10 ,007 Say "Codigo" Pixel of olDlg2
			@ 10 ,050 Get cod size 50,08 when .F. Pixel of olDlg2
	
			@ 25 ,007 Say "Descrição" Pixel of olDlg2
			@ 25 ,050 Get desc size 80,08 when .F. Pixel of olDlg2
		
			@ 40 ,007 Say "Quantidade" Pixel of olDlg2
			@ 40 ,050 Get nlQtd size 50,08 Picture "@E 999999.99" Pixel of olDlg2
			
			@ 062,007  CHECKBOX  olCheck1 var llMarc PROMPT "Marca/Desmarca"	SIZE 60,10 PIXEL OF olDlg2  ON CLICK( ) 
	
			DEFINE SBUTTON FROM  060,090 TYPE 01 ACTION Eval({|| FGrQtMr(cod,desc,nlQtd,llMarc),olDlg2:End()})  Enable OF olDlg2
			DEFINE SBUTTON FROM  060,120 TYPE 02 ACTION olDlg2:End() Enable OF olDlg2		
	
		ACTIVATE MSDIALOG olDlg2 CENTERED
		
	EndIf
	
Return

/*#############################################################
##                   __   "   __                             ##
##                 ( __ \ | / __ ) Kazoolo                   ##
##                  ( _ / | \ _ )  Codefacttory              ##
###############################################################
## Função:     ## FGrQtMr		                             ##
###############################################################
## Descrição:  ## Atualiza na tela do Grid se o produto foi  ##
##			   ## selecionado e quantidade				     ##
###############################################################
## Parametros: ## cod 	- Codigo do produto					 ##
##             ## desc 	- Descrição do Produto				 ##
##             ## qtd 	- Quantidade do produto				 ##
##             ## Marc 	- Variavel logica, Marca ou Não		 ##
###############################################################
## Autor :     ## Hermes Ferreira de Almeida                 ##
###############################################################
## Data:       ## 20/01/2010                                 ##
###############################################################
## Palavras Chaves: Atualiza Grid                            ##
#############################################################*/ 
Static Function FGrQtMr(cod,desc,qtd,Marc)

	Local clRecno := Recno()
	
	TMP1->(dbGoTo(clRecno))
    
    nExit	:= Ascan(aCols,{|m| m[GDFIELDPOS("C6_PRODUTO")] == cod})

    If nExit > 0
    	If (aCols[nExit][Len(aHeader)+1])
    		nExit := 0
    	EndIf
    EndIf 
	
	If nExit == 0 
	
		If qtd > 0 .and. Marc
			If RecLock("TMP1",.F.)
				TMP1->QTD := qtd
				MsUnLock()
			EndIf
		EndIf
		If Marc
			If RecLock("TMP1",.F.)
				TMP1->OK := cpMarca
				MsUnLock()
			EndIf
		Else
			If RecLock("TMP1",.F.)
				TMP1->OK		:= Space(02)
				TMP1->QTD	:= 1
				MsUnLock()
			EndIf
		EndIf
	Else
		Aviso("Atenção","Já existe esse produto nos itens do pedido",{"OK"})
	EndIf

	TMP1->(dbGoTo(clRecno))
Return

/*#############################################################
##                   __   "   __                             ##
##                 ( __ \ | / __ ) Kazoolo                   ##
##                  ( _ / | \ _ )  Codefacttory              ##
###############################################################
## Função:     ## FVrfPAZ		                             ##
###############################################################
## Descrição:  ## Verifica a disponibilidade do produto na   ##
##			   ## tabela PAZ.							     ##
###############################################################
## Autor :     ## Hermes Ferreira de Almeida                 ##
###############################################################
## Data:       ## 20/01/2010                                 ##
###############################################################
## Palavras Chaves: PAZ                           ##
#############################################################*/ 
Static Function FVrfPAZ()
    Local nlDisp	:= 0
    Local nlSubLoc	:= 0
	Local clQryPAZ	:= ""

	TMP1->(dbGoTop())
	While TMP1->(!Eof())
		If !Empty(TMP1->OK) 

			If TMP1->B2_QATU > 0
    
				clQryPAZ := ""
				clQryPAZ := "SELECT (SELECT SUM(PAZ_QUANT)"
				clQryPAZ += "			FROM "+ RetSqlName("PAZ")+ " PAZ "
				clQryPAZ += "			WHERE PAZ.D_E_L_E_T_ = ' '"
				clQryPAZ += "			AND PAZ_FILIAL = '"+xFilial("PAZ")+"'"
				clQryPAZ += "			AND PAZ_PRODUT = '"+Alltrim(TMP1->B1_COD)+"'"
				clQryPAZ += " 			AND(PAZ_DTINI BETWEEN	'"+ DtoS(M->C5_DATAINI)	+"' AND '"	+ DtoS(M->C5_DATAFIM)+"'"
				clQryPAZ += " 			OR 	PAZ_DTFIM BETWEEN	'"+DtoS(M->C5_DATAINI)	+"' AND '"	+ DtoS(M->C5_DATAFIM)+"'"
				clQryPAZ += " 			OR (PAZ_DTINI <= '"+DtoS(M->C5_DATAINI)+"' AND PAZ_DTFIM >= '"+DtoS(M->C5_DATAFIM) +"' ))"				
				clQryPAZ += "			GROUP BY PAZ_PRODUT)AS TOTAL"
				clQryPAZ += "			,PAZ_PRODUT"
			
				clQryPAZ += " FROM "+ RetSqlName("PAZ")+ " PAZ "
				clQryPAZ += " WHERE PAZ.D_E_L_E_T_ = ' '"
				clQryPAZ += " AND PAZ_FILIAL = '"+xFilial("PAZ")+"'"
				clQryPAZ += " AND PAZ_PRODUT = '"+Alltrim(TMP1->B1_COD)+"'"
				clQryPAZ += " AND(	PAZ_DTINI BETWEEN	'"+ DtoS(M->C5_DATAINI)	+"' AND '"	+ DtoS(M->C5_DATAFIM)+"'"
				clQryPAZ += " OR 	PAZ_DTFIM BETWEEN	'"+DtoS(M->C5_DATAINI)	+"' AND '"	+ DtoS(M->C5_DATAFIM)+"'"
				clQryPAZ += " OR (PAZ_DTINI <= '"+DtoS(M->C5_DATAINI)+"' AND PAZ_DTFIM >= '"+DtoS(M->C5_DATAFIM) +"' ))"

				clQryPAZ += " GROUP BY PAZ_PRODUT"
			
				TcQuery clQryPAZ New Alias "TMPP"

				nlDisp	:= TMP1->B2_QATU - TMPP->TOTAL

				If nlDisp > 0
					If TMP1->QTD > nlDisp
						nlSubLoc := TMP1->QTD - nlDisp
						If RecLock("TMP1",.F.)
							Replace TMP1->SUBLOC	With nlSubLoc
							Aviso("Atenção","Produto de Código: "+Alltrim(TMP1->B1_COD)+", Descrição: "+Alltrim(TMP1->B1_DESC)+", foi sublocado em quantidade igual a "+Alltrim(Str(nlSubLoc))+".",{"Ok"})
							MsUnLock()
						EndIf
					Else
						TMP1->SUBLOC := 0						
					EndIf
				Else
					If RecLock("TMP1",.F.)
						Replace TMP1->SUBLOC	With TMP1->QTD
						Aviso("Atenção","Produto de Código: "+Alltrim(TMP1->B1_COD)+", Descrição: "+Alltrim(TMP1->B1_DESC)+", foi sublocado em quantidade igual a "+Alltrim(Str(TMP1->QTD))+".",{"Ok"})
						MsUnLock()
					EndIf
                EndIf

				TMPP->(dbCloseArea())

			Else
				If RecLock("TMP1",.F.)
					Replace TMP1->SUBLOC	With TMP1->QTD
					Aviso("Atenção","Produto de Código: "+Alltrim(TMP1->B1_COD)+", Descrição: "+Alltrim(TMP1->B1_DESC)+", foi sublocado em quantidade igual a "+Alltrim(Str(TMP1->QTD))+".",{"Ok"})
					MsUnLock()
				EndIf
			EndIf
		EndIf
		TMP1->(dbSkip())
	EndDo				    

Return

/*#############################################################
##                   __   "   __                             ##
##                 ( __ \ | / __ ) Kazoolo                   ##
##                  ( _ / | \ _ )  Codefacttory              ##
###############################################################
## Função:     ## FCarAcol		                             ##
###############################################################
## Descrição:  ## Carrega no aCols do pedido de venda os pro-##
##			   ## dutos selecionados na tela anterior	     ##
###############################################################
## Autor :     ## Hermes Ferreira de Almeida                 ##
###############################################################
## Data:       ## 20/01/2010                                 ##
###############################################################
## Palavras Chaves: Carrega aCols                            ##
#############################################################*/
Static Function FCarAcol()

	Local nlItem := (Len(aCols)+1)
	
	nProd   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRODUTO"	})	
	cUnid	:= Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_UM"			})
	nQuant	:= Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_QTDVEN"		})
	nUnit	:= Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRCVEN"		})	
	nValTot := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_VALOR"		})
	cTes	:= Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_TES"		})
	nSub	:= Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_QTDSUB"		})
	nLoc	:= Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_LOCAL"		})
	nPosDtaI:= 	Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_DINIC"		})
	nPosDtaF:= 	Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_DFINAL"    })	
			
	dbSelectArea("TMP1")
	dbGoTop()
	While TMP1->(!Eof())
		If !Empty(TMP1->OK)
			
			n := Len(aCols)
			
			If n > 1 .or. !Empty(aCols[n][nProd])
			
				aAdd(aCols, Array(Len(aHeader)+1))
				n++
				For nX := 1 to Len(aHeader)
				
					If (aHeader[nX,2] <> "C6_REC_WT") .And. (aHeader[nX,2] <> "C6_ALI_WT")
						aCols[n,nX] := CriaVar(aHeader[nX,2])
					EndIf
				Next
				aCols[n,1] := Alltrim(StrZero(nlItem,2))
				nlItem++
				aCols[n,Len(aHeader)+1] := .F.
				
			EndIf
						
			If nProd > 0  .And.  ;
			   cUnid > 0  .And.  ;
			   nQuant > 0 .And.  ;
			   nUnit > 0 .And.   ;
			   nValTot > 0 .And. ;
			   cTes > 0 .And.    ;			   			   			   
			   nSub > 0 .And.    ;
			   nLoc > 0 .And.    ;
			   nPosDtaI > 0 .And.;
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
				
			EndIf			
			
		EndIf
		TMP1->(dbSkip())
	EndDo
	
	oGetDad:Refresh()
		
Return
	
Static Function FSetOrder(nlIndex,olMark)

	If nlIndex > 1
		DbSelectArea("TMP1")
		DbSetOrder(nlIndex - 1)
		DbGoTop()
	EndIf
	
	olMark:oBrowse:Refresh()

Return()