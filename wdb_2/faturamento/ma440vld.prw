# INCLUDE "Protheus.ch"
# INCLUDE "TopConn.ch"
# INCLUDE "Rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MA440VLD บ Autor ณ Edilson Mendes     บ Data ณ  11/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de Entrada, ao clicar no botใo OK na libera็ใo do    บฑฑ
ฑฑบ          ณ pedido de venda.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cliente WDB                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
USER FUNCTION MA440VLD

LOCAL nPos
LOCAL dlDtIniEv  := M->C5_DATAINI
LOCAL dlDtFimEv  := M->C5_DATAFIM
LOCAL nlQtdB2	 := 0
LOCAL nlDisp	 := 0
LOCAL clQryPAZ	 := ""
LOCAL clDescProd := ""
LOCAL llRet		 := .T.
LOCAL alProdloc	 := {}

PRIVATE	lMsErroAuto := .F.

	nItem   := ASCAN( aHeader, { |xItem| ALLTRIM( xItem[2] ) == "C6_ITEM"		})
	nProd   := ASCAN( aHeader, { |xItem| ALLTRIM( xItem[2] ) == "C6_PRODUTO"	})
	cUnid	:= ASCAN( aHeader, { |xItem| ALLTRIM( xItem[2] ) == "C6_UM"			})
	nQuant	:= ASCAN( aHeader, { |xItem| ALLTRIM( xItem[2] ) == "C6_QTDVEN"		})
	nUnit	:= ASCAN( aHeader, { |xItem| ALLTRIM( xItem[2] ) == "C6_PRCVEN"		})
	nValTot := ASCAN( aHeader, { |xItem| ALLTRIM( xItem[2] ) == "C6_VALOR"		})
	nSub	:= ASCAN( aHeader, { |xItem| ALLTRIM( xItem[2] ) == "C6_QTDSUB"		})
	nValSub	:= ASCAN( aHeader, { |xItem| ALLTRIM( xItem[2] ) == "C6_VALSUB"		})
	nLoc	:= ASCAN( aHeader, { |xItem| ALLTRIM( xItem[2] ) == "C6_LOCAL"		})
	nOpe	:= ASCAN( aHeader, { |xItem| ALLTRIM( xItem[2] ) == "C6_OPER"		})
	
	FOR nPos := 1 TO LEN( aCols )
		
		clDescProd	:= ""
		
		IF .NOT. aCols[nPos][LEN(aHeader)+1]
			
			DBSelectArea("SB2")
			IF SB2->( DBSetorder(1), DBSeek(xFilial("SB2")+aCols[nPos][nProd]+aCols[nPos][nLoc]) )
				nlQtdB2:= SB2->B2_QATU
			ENDIF
			
			IF nlQtdB2 > 0
				
				clQryPAZ := ""
				clQryPAZ := "SELECT (SELECT SUM(PAZ_QUANT)"
				clQryPAZ += "			FROM "+ RetSqlName("PAZ")+ " PAZ "
				clQryPAZ += "			WHERE PAZ.D_E_L_E_T_ = ' '"
				clQryPAZ += "			AND PAZ_FILIAL = '"+xFilial("PAZ")+"'"
				clQryPAZ += "			AND PAZ_PRODUT = '"+ALLTRIM(aCols[nPos][nProd])+"'"
				clQryPAZ += " 			AND(PAZ_DTINI BETWEEN	'"+ DtoS(M->C5_DATAINI)	+"' AND '"	+ DtoS(M->C5_DATAFIM)+"'"
				clQryPAZ += " 			OR 	PAZ_DTFIM BETWEEN	'"+DtoS(M->C5_DATAINI)	+"' AND '"	+ DtoS(M->C5_DATAFIM)+"'"
				clQryPAZ += " 			OR (PAZ_DTINI <= '"+DtoS(M->C5_DATAINI)+"' AND PAZ_DTFIM >= '"+DtoS(M->C5_DATAFIM) +"' ))"
				clQryPAZ += "			GROUP BY PAZ_PRODUT)AS TOTAL"
				clQryPAZ += "			,PAZ_PRODUT"
				
				clQryPAZ += " FROM "+ RetSqlName("PAZ")+ " PAZ "
				clQryPAZ += " WHERE PAZ.D_E_L_E_T_ = ' '"
				clQryPAZ += " AND PAZ_FILIAL = '"+xFilial("PAZ")+"'"
				clQryPAZ += " AND PAZ_PRODUT = '"+ALLTRIM(aCols[nPos][nProd])+"'"
				clQryPAZ += " AND(	PAZ_DTINI BETWEEN	'"+ DtoS(M->C5_DATAINI)	+"' AND '"	+ DtoS(M->C5_DATAFIM)+"'"
				clQryPAZ += " OR 	PAZ_DTFIM BETWEEN	'"+DtoS(M->C5_DATAINI)	+"' AND '"	+ DtoS(M->C5_DATAFIM)+"'"
				clQryPAZ += " OR (PAZ_DTINI <= '"+DtoS(M->C5_DATAINI)+"' AND PAZ_DTFIM >= '"+DtoS(M->C5_DATAFIM) +"' ))"
				
				clQryPAZ += " GROUP BY PAZ_PRODUT"
				
				TcQuery clQryPAZ New Alias "TMPP"
				
				nlDisp	:= nlQtdB2 - TMPP->TOTAL
				
				IF nlDisp > 0
					IF aCols[nPos][nQuant] > nlDisp
						nlSubLoc := aCols[nPos][nQuant] - nlDisp
						
						aCols[nPos][nSub] := nlSubLoc
						Aviso("Aten็ใo","Produto de C๓digo: "+ALLTRIM(aCols[nPos][nProd])+", foi sublocado em quantidade igual a "+ALLTRIM(Str(nlSubLoc))+".",{"Ok"})
						
					ELSE
						
						aCols[nPos][nSub] := 0
						
					ENDIF
				ELSE
					
					aCols[nPos][nSub] := aCols[nPos][nQuant]
					Aviso("Aten็ใo","Produto de C๓digo: "+ALLTRIM(aCols[nPos][nProd])+", foi sublocado em quantidade igual a "+ALLTRIM(Str(aCols[nPos][nQuant]))+".",{"Ok"})
					
				ENDIF
				
				TMPP->(dbCloseArea())
				
			ELSE
				IF .NOT. EMPTY( aCols[nPos][nProd] ) .AND. .NOT. aCols[nPos][Len(aHeader)+1]
					aCols[nPos][nSub] := aCols[nPos][nQuant]
					Aviso("Aten็ใo","Produto de C๓digo: "+ALLTRIM(aCols[nPos][nProd])+", foi sublocado em quantidade igual a "+ALLTRIM(Str(aCols[nPos][nQuant]))+".",{"Ok"})
				ENDIF
			ENDIF
			
			IF .NOT. EMPTY(aCols[nPos][nSub])
				IF EMPTY(aCols[nPos][nValSub])
					DBSelectArea("SB1")
					IF SB1->( DBSetOrder(1), DBSeek(xFilial("SB1")+ALLTRIM(aCols[nPos][nProd] ) ) )
						clDescProd	:= SB1->B1_DESC
					ENDIF
					Aviso("Aten็ใo","Nใo ้ possํvel liberar esse pedido de venda, pois o produto "+ALLTRIM(aCols[k][nProd])+", Descri็ใo: "+ALLTRIM(clDescProd)+" na linha "+ALLTRIM(Str(k))+" possui subloca็ใo e nใo cont้m o valor. Para liberar tal pedido ้ necessแrio que voc๊ preencha o valor de subloca็ใo",{"Ok"})
					llRet := .F.
				ENDIF
			ENDIF
			
		ENDIF
		
		IF .NOT. llRet
			Exit
		ENDIF
		
	NEXT
	
	If llRet
		
		DBSelectArea("PAZ")
		PAZ->( DBSetOrder(2) )
		
		FOR nPos := 1 TO LEN(aCols)
			IF PAZ->( DBSeek( xFilial("PAZ")+M->C5_NUM+aCols[nPos][nItem] ) )
				IF ( aCols[nPos][nQuant] - aCols[nPos][nSub]) > 0
					IF RecLock("PAZ",.F.)
						PAZ->PAZ_QUANT	:= (aCols[nPos][nQuant] - aCols[nPos][nSub])
					ENDIF
				ENDIF
			ELSE
				IF (aCols[nPos][nQuant] - aCols[nPos][nSub]) > 0
					IF RecLock("PAZ",.T.)
						PAZ->PAZ_FILIAL		:= xFilial("PAZ")
						PAZ->PAZ_PRODUT		:= aCols[nPos][nProd]
						PAZ->PAZ_DTINI		:= M->C5_DATAINI
						PAZ->PAZ_DTFIM		:= M->C5_DATAFIM
						PAZ->PAZ_QUANT		:= (aCols[nPos][nQuant] - aCols[nPos][nSub])
						PAZ->PAZ_PEDIDO		:= M->C5_NUM
						PAZ->PAZ_ITEM		:= aCols[nPos][nItem]
						PAZ->PAZ_OPERAC		:= aCols[nPos][nOpe]
					ENDIF
				ENDIF
			ENDIF
		NEXT
		alProdloc := aClone(aCols)
		PedCom(3,alProdloc)
	ENDIF
		
RETURN( llRet )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PEDCOM   บ Autor ณ Edilson Mendes     บ Data ณ  11/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina Automatica para a grava็ใo do pedido de compra para บฑฑ
ฑฑบ          ณ itens que foram sublocados.                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ <nOpc>  - 3-Grava็ใo                                       บฑฑ
ฑฑบ          ณ <alCmp> - Array com itens do pedido                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cliente WDB                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
STATIC PROCEDURE PedCom(nOpc,alCmp)

LOCAL nPos
LOCAL olDlg
LOCAL aCab		:= {}
LOCAL aItem		:= {}
LOCAL nlVerif	:= 0
LOCAL nlItem	:= 0

PRIVATE clNomFor	:= ""
PRIVATE alList	    := {}
PRIVATE lMsErroAuto := .F.
PRIVATE olFont1	    := TFont():New( "Arial",,-11,,.T.)

	FOR nPos := 1 TO LEN(alCmp)
		IF alCmp[nPos][GDFIELDPOS("C6_QTDSUB")] > 0
			nlVerif += 1
			EXIT
		ENDIF
	NEXT
	
	IF nlVerif == 0
		Return ()
	ELSE
		aCab := {		{"C7_NUM"     ,GetSxEnum("SC7","C7_NUM")		,Nil} , ; // Numero do Pedido
                        {"C7_EMISSAO" ,dDataBase						,Nil} , ; // Data de Emissao
                        {"C7_FORNECE" ,GetMV("KZ_FORNECE")				,Nil} , ; // Fornecedor
                        {"C7_LOJA"    ,GetMV("KZ_LJFORNE")				,Nil} , ; // Loja do Fornecedor
                        {"C7_CONTATO" ,"               "				,Nil} , ; // Contato
                        {"C7_COND"    ,GetMV("KZ_CONDPG")				,Nil} , ; // Condicao de pagamento
                        {"C7_FILENT"  ,cFilAnt							,Nil} , ; // Filial Entrega
                        {"C7_MOEDA"   ,1								,Nil} , ;
                        {"C7_TXMOEDA" ,1								,Nil} , ;
                        {"C7_FRETE"   ,0								,Nil} , ;
                        {"C7_DESPESA" ,0								,Nil} , ;
                        {"C7_SEGURO"  ,0								,Nil} , ;
                        {"C7_DESC1"   ,0                				,Nil} , ;
                        {"C7_DESC2"   ,0								,Nil} , ;
                        {"C7_DESC3"   ,0								,Nil} , ;
                        {"C7_MSG"     ,""								,Nil} , ;
                        {"C7_REAJUST" ,""								,Nil}   }
		
		FOR nPos := 1 TO LEN(alCmp)
			If alCmp[nPos][GDFIELDPOS("C6_QTDSUB")] > 0
				nlItem += 1
				aadd(aItem,{	{"C7_ITEM"    	,StrZero(nlItem,4)						,Nil},;
				{"C7_PRODUTO",alCmp[nI][GDFIELDPOS("C6_PRODUTO")]		,Nil},; //Codigo do Produto
				{"C7_QUANT"  ,alCmp[nI][GDFIELDPOS("C6_QTDSUB")]		,Nil},; //Quantidade
				{"C7_PRECO"  ,alCmp[nI][GDFIELDPOS("C6_VALSUB")]/;
				alCmp[nI][GDFIELDPOS("C6_QTDSUB")]		,Nil},; //Preco
				{"C7_TOTAL"  ,alCmp[nI][GDFIELDPOS("C6_VALSUB")]		,Nil},; //Valor total do item
				{"C7_TES"    ,GetMV("KZ_TES")							,Nil},;//Tes
				{"C7_LOCAL"  ,alCmp[nI][GDFIELDPOS("C6_LOCAL")]		,Nil} })  //Localizacao
				
				aAdd(alList,{alCmp[nPos][GDFIELDPOS("C6_PRODUTO")],Transform(alCmp[nI][GDFIELDPOS("C6_QTDSUB")],PesqPict("SC6","C6_QTDSUB"))})
			ENDIF
		NEXT
		
		MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)},1,aCab,aItem,3)
		
		IF lMsErroAuto
			DisarmTransaction()
			MostraErro()
			RollbackSx8()
		ELSE
			ConfirmSx8()
			
			DBSelectArea("SA2")
			IF SA2->( DBSetorder(1), DBSeek(xFilial("SA2") + GetMV("KZ_FORNECE")) )
				clNomFor := SA2->A2_NOME
			ENDIF
			
			Processa({|| FTela()}, "Tiago Bizan Pereira")
		ENDIF
	ENDIF
		
RETURN


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FTELA    บ Autor ณ Edilson Mendes     บ Data ณ  11/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cliente WDB                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
STATIC PROCEDURE FTela()

	LOCAL olBrowse 	:= Nil
	
	olDlg :=  MSDialog():New(000,000,418,762,"Pedido de Compra",,,,,,,,,.T.)
	
		@ 005,005 to 030,379 Pixel of olDlg
		@ 010,010 Say "Foi gerado um pedido de compra para o forneceodor " + ALLTRIM(GetMV("KZ_FORNECE"))+ " - " + clNomFor Font olFont1 of olDlg Pixel
		@ 020,010 Say "Com os seguintes itens:" Font olFont1 of olDlg Pixel		
		  
		olBrowse:= TWBrowse():New(40,005,372,150,,{"Produto","Quantidade"},,olDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		olBrowse:SetArray( alList )
		olBrowse:bLine := { || alList[olBrowse:nAT] }			    
		
		DEFINE SBUTTON FROM  195,352 TYPE 01 ACTION olDlg:End() Enable OF olDlg
	
	ACTIVATE MSDIALOG olDlg CENTERED
	
RETURN