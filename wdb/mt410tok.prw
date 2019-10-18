# INCLUDE "Protheus.ch"
# INCLUDE "TopConn.ch"

/*#############################################################
##                   __   "   __                             ##
##                 ( __ \ | / __ ) Kazoolo                   ##
##                  ( _ / | \ _ )  Codefacttory              ##
###############################################################
## Função:     ## KZ_FTlPd.PRW                               ##
###############################################################
## Descrição:  ## Ponto de Entrada, ao clicar no botão OK    ##
##			   ## no pedido de venda                         ##
###############################################################
## Autor :     ## Hermes Ferreira de Almeida                 ##
###############################################################
## Data:       ## 20/01/2010                                 ##
###############################################################
## Palavras Chaves: Pedido de venda                          ##
#############################################################*/

User Function MT410TOK
	Local k := 0
	
	Local nlQtdB2	:= 0
	Local nlDisp	:= 0
	Local clQryPAZ	:= ""

	nProd   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRODUTO"	})	
	nQuant	:= Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_QTDVEN"		})
	nSub	:= Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_QTDSUB"		})
	nLoc	:= Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_LOCAL"		})

	For k := 1 to Len(aCols)
		
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
		EndIf
	Next k

Return .T.