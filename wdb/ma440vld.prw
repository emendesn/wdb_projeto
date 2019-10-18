# INCLUDE "Protheus.ch"
# INCLUDE "TopConn.ch"
# INCLUDE "Rwmake.ch"

/*#############################################################
##                   __   "   __                             ##
##                 ( __ \ | / __ ) Kazoolo                   ##
##                  ( _ / | \ _ )  Codefacttory              ##
###############################################################
## Função:     ## KZ_FTlPd.PRW                               ##
###############################################################
## Descrição:  ## Ponto de Entrada, ao clicar no botão OK    ##
##			   ## na liberação do pedido de venda            ##
###############################################################
## Autor :     ## Hermes Ferreira de Almeida                 ##
###############################################################
## Data:       ## 20/01/2010                                 ##
###############################################################
## Palavras Chaves: Liberação pedido de venda                ##
#############################################################*/

User Function MA440VLD

	Local k := 0
	Local dlDtIniEv := M->C5_DATAINI
	Local dlDtFimEv := M->C5_DATAFIM
	Local nlQtdB2	:= 0
	Local nlDisp	:= 0
	Local clQryPAZ	:= ""
	Local clDescProd:= ""
	Local llRet		:=.T.
	Local alProdloc	:= {}
	Private	lMsErroAuto := .F.

	nItem   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_ITEM"		})
	nProd   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRODUTO"	})	
	cUnid	:= Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_UM"			})
	nQuant	:= Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_QTDVEN"		})
	nUnit	:= Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRCVEN"		})	
	nValTot := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_VALOR"		})
	nSub	:= Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_QTDSUB"		})
	nValSub	:= Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_VALSUB"		})
	nLoc	:= Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_LOCAL"		})
	nOpe	:= Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_OPER"		})
	
	For k := 1 to Len(aCols)
		clDescProd	:= ""
		
		If !aCols[k][Len(aHeader)+1]

			dbSelectArea("SB2")
			dbGotop()
			dbSetorder(1)
			If dbSeek(xFilial("SB2")+aCols[k][nProd]+aCols[k][nLoc])
				nlQtdB2:= SB2->B2_QATU
			EndIf

			If nlQtdB2 > 0

				clQryPAZ := ""
				clQryPAZ := "SELECT (SELECT SUM(PAZ_QUANT)"
				clQryPAZ += "			FROM "+ RetSqlName("PAZ")+ " PAZ "
				clQryPAZ += "			WHERE PAZ.D_E_L_E_T_ = ' '"
				clQryPAZ += "			AND PAZ_FILIAL = '"+xFilial("PAZ")+"'"
				clQryPAZ += "			AND PAZ_PRODUT = '"+Alltrim(aCols[k][nProd])+"'"
				clQryPAZ += " 			AND(PAZ_DTINI BETWEEN	'"+ DtoS(M->C5_DATAINI)	+"' AND '"	+ DtoS(M->C5_DATAFIM)+"'"
				clQryPAZ += " 			OR 	PAZ_DTFIM BETWEEN	'"+DtoS(M->C5_DATAINI)	+"' AND '"	+ DtoS(M->C5_DATAFIM)+"'"
				clQryPAZ += " 			OR (PAZ_DTINI <= '"+DtoS(M->C5_DATAINI)+"' AND PAZ_DTFIM >= '"+DtoS(M->C5_DATAFIM) +"' ))"	
				clQryPAZ += "			GROUP BY PAZ_PRODUT)AS TOTAL"
				clQryPAZ += "			,PAZ_PRODUT"
			
				clQryPAZ += " FROM "+ RetSqlName("PAZ")+ " PAZ "
				clQryPAZ += " WHERE PAZ.D_E_L_E_T_ = ' '"
				clQryPAZ += " AND PAZ_FILIAL = '"+xFilial("PAZ")+"'"
				clQryPAZ += " AND PAZ_PRODUT = '"+Alltrim(aCols[k][nProd])+"'"
				clQryPAZ += " AND(	PAZ_DTINI BETWEEN	'"+ DtoS(M->C5_DATAINI)	+"' AND '"	+ DtoS(M->C5_DATAFIM)+"'"
				clQryPAZ += " OR 	PAZ_DTFIM BETWEEN	'"+DtoS(M->C5_DATAINI)	+"' AND '"	+ DtoS(M->C5_DATAFIM)+"'"
				clQryPAZ += " OR (PAZ_DTINI <= '"+DtoS(M->C5_DATAINI)+"' AND PAZ_DTFIM >= '"+DtoS(M->C5_DATAFIM) +"' ))"

				clQryPAZ += " GROUP BY PAZ_PRODUT"

				TcQuery clQryPAZ New Alias "TMPP"

				nlDisp	:= nlQtdB2 - TMPP->TOTAL

				If nlDisp > 0
					If aCols[k][nQuant] > nlDisp
						nlSubLoc := aCols[k][nQuant] - nlDisp
                            
						aCols[k][nSub]		:= nlSubLoc
						Aviso("Atenção","Produto de Código: "+Alltrim(aCols[k][nProd])+", foi sublocado em quantidade igual a "+Alltrim(Str(nlSubLoc))+".",{"Ok"})
					
					Else
					
						aCols[k][nSub]		:= 0
						
					EndIf
				Else

					aCols[k][nSub]:= aCols[k][nQuant]
					Aviso("Atenção","Produto de Código: "+Alltrim(aCols[k][nProd])+", foi sublocado em quantidade igual a "+Alltrim(Str(aCols[k][nQuant]))+".",{"Ok"})

                EndIf
                
				TMPP->(dbCloseArea())
				
			Else
				If !Empty(aCols[k][nProd]) .AND.!aCols[k][Len(aHeader)+1]
					aCols[k][nSub]:= aCols[k][nQuant]
					Aviso("Atenção","Produto de Código: "+Alltrim(aCols[k][nProd])+", foi sublocado em quantidade igual a "+Alltrim(Str(aCols[k][nQuant]))+".",{"Ok"})
                EndIf
			EndIf
			
			If !Empty(aCols[k][nSub])
				If Empty(aCols[k][nValSub])
					dbSelectArea("SB1")
					dbSetOrder(1)
					dbGoTop()
					If dbSeek(xFilial("SB1")+Alltrim(aCols[k][nProd]))
						clDescProd	:= SB1->B1_DESC
					EndIf
					Aviso("Atenção","Não é possível liberar esse pedido de venda, pois o produto "+Alltrim(aCols[k][nProd])+", Descrição: "+Alltrim(clDescProd)+" na linha "+Alltrim(Str(k))+" possui sublocação e não contém o valor. Para liberar tal pedido é necessário que você preencha o valor de sublocação",{"Ok"})					
					llRet := .F.
				EndIf
			EndIf
			
		EndIf
		If !llRet
			Exit
		EndIf
	Next k
	
	If llRet
	
		dbSelectArea("PAZ")
		dbGoTop()
		dbSetOrder(2)
		
		For m := 1 to Len(aCols)
			If dbSeek(xFilial("PAZ")+M->C5_NUM+aCols[m][nItem])
				If (aCols[m][nQuant] - aCols[m][nSub]) > 0
					If RecLock("PAZ",.F.)
						PAZ->PAZ_QUANT	:= (aCols[m][nQuant] - aCols[m][nSub])
					EndIf
				EndIf
			Else
				if (aCols[m][nQuant] - aCols[m][nSub]) > 0
					If RecLock("PAZ",.T.)
						PAZ->PAZ_FILIAL		:= xFilial("PAZ")
						PAZ->PAZ_PRODUT		:= aCols[m][nProd]
						PAZ->PAZ_DTINI		:= M->C5_DATAINI
						PAZ->PAZ_DTFIM		:= M->C5_DATAFIM
						PAZ->PAZ_QUANT		:= (aCols[m][nQuant] - aCols[m][nSub])  
						PAZ->PAZ_PEDIDO		:= M->C5_NUM
						PAZ->PAZ_ITEM		:= aCols[m][nItem]
						PAZ->PAZ_OPERAC		:= aCols[m][nOpe]
					EndIf
				endif
			EndIf
		Next l
		alProdloc:= aClone(aCols)
		PedCom(3,alProdloc)
	EndIf
	
Return llRet

//  
/*#############################################################
##                   __   "   __                             ##
##                 ( __ \ | / __ ) Kazoolo                   ##
##                  ( _ / | \ _ )  Codefacttory              ##
###############################################################
## Função:     ## PedCom                                     ##
###############################################################
## Descrição:  ## Rotina Automatica para a gravação do pedido##
##			   ##de compra para os itens que foram sublocados##
###############################################################
## Parametros  ## nOpc  - 3-Gravação			 			 ##
## 			   ## alCmp - Array com itens do pedido			 ##
###############################################################
## Autor :     ##                  ##
###############################################################
## Data:       ##                                  ##
###############################################################
## Palavras Chaves: Pedido de Compra                         ##
#############################################################*/

Static Function PedCom(nOpc,alCmp)
	Local olDlg		:= Nil	
	Local aCab		:= {}
	Local aItem		:= {}	
	Local nlVerif	:= 0
	Local nlItem	:= 0
	Private clNomFor	:= ""
	Private alList	:= {}
    Private lMsErroAuto := .F.
    Private olFont1	:= TFont():New( "Arial",,-11,,.T.)

    For nI := 1 to len(alCmp)
		If alCmp[nI][GDFIELDPOS("C6_QTDSUB")] > 0
			nlVerif += 1
			Exit	
		Endif	
	Next nI

	If nlVerif == 0
		Return () 
	Else
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

		For nI := 1 to len(alCmp)
			If alCmp[nI][GDFIELDPOS("C6_QTDSUB")] > 0
				nlItem += 1
				aadd(aItem,{	{"C7_ITEM"    	,StrZero(nlItem,4)						,Nil},;
								{"C7_PRODUTO",alCmp[nI][GDFIELDPOS("C6_PRODUTO")]		,Nil},; //Codigo do Produto
								{"C7_QUANT"  ,alCmp[nI][GDFIELDPOS("C6_QTDSUB")]		,Nil},; //Quantidade
								{"C7_PRECO"  ,alCmp[nI][GDFIELDPOS("C6_VALSUB")]/;
						 	 			      alCmp[nI][GDFIELDPOS("C6_QTDSUB")]		,Nil},; //Preco
								{"C7_TOTAL"  ,alCmp[nI][GDFIELDPOS("C6_VALSUB")]		,Nil},; //Valor total do item
								{"C7_TES"    ,GetMV("KZ_TES")							,Nil},;//Tes
								{"C7_LOCAL"  ,alCmp[nI][GDFIELDPOS("C6_LOCAL")]		,Nil} })  //Localizacao
				
				aAdd(alList,{alCmp[nI][GDFIELDPOS("C6_PRODUTO")],Transform(alCmp[nI][GDFIELDPOS("C6_QTDSUB")],PesqPict("SC6","C6_QTDSUB"))})
			EndIf
		Next nI	    

		MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)},1,aCab,aItem,3)

		If lMsErroAuto	
			DisarmTransaction() 
			MostraErro()
			RollbackSx8()
		Else	
			ConfirmSx8()

			dbSelectArea("SA2")
			dbSetorder(1)
			dbGoTop()
			If dbSeek(xFilial("SA2") + GetMV("KZ_FORNECE"))
				clNomFor	:= SA2->A2_NOME
			EndIf        

			Processa({|| FTela()}, "Tiago Bizan Pereira")
		EndIf
	Endif
Return 

Static Function FTela()

	Local olBrowse 	:= Nil
	
	olDlg :=  MSDialog():New(000,000,418,762,"Pedido de Compra",,,,,,,,,.T.)
	
		@ 005,005 to 030,379 Pixel of olDlg
		@ 010,010 Say "Foi gerado um pedido de compra para o forneceodor " + Alltrim(GetMV("KZ_FORNECE"))+ " - " + clNomFor Font olFont1 of olDlg Pixel
		@ 020,010 Say "Com os seguintes itens:" Font olFont1 of olDlg Pixel		
		  
		olBrowse:= TWBrowse():New(40,005,372,150,,{"Produto","Quantidade"},,olDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		olBrowse:SetArray( alList )
		olBrowse:bLine := { || alList[olBrowse:nAT] }			    
		
		DEFINE SBUTTON FROM  195,352 TYPE 01 ACTION olDlg:End() Enable OF olDlg
	
	ACTIVATE MSDIALOG olDlg CENTERED
Return   
