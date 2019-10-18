/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA410T  º Autor ³ Edilson Mendes     º Data ³  11/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada apos a gravação do pedido de venda, e     º±±
±±º          ³ verifica se manda e-mail para o tecnico.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Cliente WDB                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER FUNCTION MTA410T

LOCAL clNome	:= ""
LOCAL clCod		:= GetMV("KZ_SOLTECN")
LOCAL llOk		:= .F.

	IF Funname() == "MATA410"
		
		DBSelectArea("SA3")
		SA3->( DBSetorder(1) )
		SA3->( DBGotop() )
		IF SA3->( DBSeek( xFilial("SA3") + M->C5_VEND5) )
			clNome	:= SA3->A3_NOME
		ENDIF
		
		nExist := Ascan(aCols,{|m| Alltrim(m[GDFIELDPOS("C6_PRODUTO")]) == Alltrim(clCod)})
		
		IF M->C5_EMAIL == '1' .AND. .NOT. EMPTY( clCod ) .AND. nExist > 0
			IF .NOT. EMPTY( M->C5_VEND5 )
				llOk := U_KZ_EmlTc(M->C5_VEND5)
			ENDIF
			IF llOk
				Aviso( "Atenção", "A planilha foi enviada com sucesso para o Tecnico " + ALLTRIM( clNome ) + ".", {"Ok"} )
			ELSE
				Aviso( "Atenção", "A planilha não pode ser enviada para o Tecnico.", {"Ok"} )
			ENDIF
		ENDIF
	ENDIF
	    
RETURN