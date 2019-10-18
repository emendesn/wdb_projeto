# INCLUDE "Protheus.ch"
# INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT410TOK º Autor ³ Edilson Mendes     º Data ³  11/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada, ao clicar no botão OK no pedido de venda º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Cliente WDB                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER FUNCTION MT410TOK

LOCAL nPos
LOCAL nlQtdB2	:= 0
LOCAL nlDisp	:= 0
LOCAL clQryPAZ	:= ""


	nProd   := ASCAN( aHeader, { |xItem| ALLTRIM( xItem[2] ) == "C6_PRODUTO"	})
	nQuant	:= ASCAN( aHeader, { |xItem| ALLTRIM( xItem[2] ) == "C6_QTDVEN"		})
	nSub	:= ASCAN( aHeader, { |xItem| ALLTRIM( xItem[2] ) == "C6_QTDSUB"		})
	nLoc	:= ASCAN( aHeader, { |xItem| ALLTRIM( xItem[2]) == "C6_LOCAL"		})
	
	FOR nPos := 1 TO LEN( aCols )
		
		IF .NOT. aCols[ nPos ][LEN(aHeader)+1]
			
			DBSelectArea("SB2")
			IF SB2->( DBSetorder(1), DBSeek( xFilial("SB2") + aCols[nPos][nProd] + aCols[nPos][nLoc]) )
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
						Aviso("Atenção","Produto de Código: "+ALLTRIM(aCols[nPos][nProd])+", foi sublocado em quantidade igual a "+ALLTRIM(Str(nlSubLoc))+".",{"Ok"})
						
					ELSE
						aCols[nPos][nSub] := 0
					ENDIF
				ELSE
					
					aCols[nPos][nSub] := aCols[nPos][nQuant]
					Aviso("Atenção","Produto de Código: "+ALLTRIM(aCols[nPos][nProd])+", foi sublocado em quantidade igual a "+ALLTRIM(Str(aCols[nPos][nQuant]))+".",{"Ok"})
					
				ENDIF
				
				TMPP->(DBCloseArea())
				
			ELSE
				IF .NOT. EMPTY( aCols[nPos][nProd]) .AND..NOT. aCols[nPos][LEN(aHeader)+1]
					
					aCols[nPos][nSub] := aCols[nPos][nQuant]
					Aviso("Atenção","Produto de Código: "+ALLTRIM(aCols[nPos][nProd])+", foi sublocado em quantidade igual a "+ALLTRIM(Str(aCols[nPos][nQuant]))+".",{"Ok"})
					
				ENDIF
				
			ENDIF
		ENDIF
	NEXT
	
RETURN( .T. )