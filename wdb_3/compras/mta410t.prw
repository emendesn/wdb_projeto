/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MTA410T   ³ Autor ³ Murilo Swistalski   ³ Data ³ 17/03/2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ponto de Entrada apos a gravação do pedido de compra, e    ³±±
±±³          ³ verifica se manda e-mail para o tecnico                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER FUNCTION MTA410T

LOCAL clNome	:= ""
LOCAL clCod		:= GetMV("KZ_SOLTECN")
LOCAL llOk		:= .F.

	DBSelectArea("SA3")
	IF SA3->( DBSetorder(1), DBSeek( xFilial("SA3") + M->C5_VEND5) )
		clNome := SA3->A3_NOME
	ENDIF
	
	IF M->C5_EMAIL == '1' .AND. .NOT. EMPTY( clCod ) .AND. ;
		ASCAN( aCols, { |xItem| ALLTRIM( xItem[ GDFIELDPOS("C6_PRODUTO") ] ) == ALLTRIM( clCod ) } ) > 0
		llOk := U_KZ_EmlTc( M->C5_VEND5 )
		IF llOk
			Aviso("Atenção","A planilha foi enviada com sucesso para o tecnico "+clNome+".",{"Ok"})
		ELSE
			Aviso("Atenção","A planilha não pode ser enviada.",{"Ok"})
		ENDIF
	ENDIF
		
RETURN