/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪哪勘�
北矲un噮o    矼TA410T   � Autor � Murilo Swistalski   � Data � 17/03/2010 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪哪幢�
北矰escri噭o � Ponto de Entrada apos a grava玢o do pedido de compra, e    潮�
北�          � verifica se manda e-mail para o tecnico                    潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Especifico para Criacao/Alteracao da Agenda JOB - WDB      潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
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
			Aviso("Aten玢o","A planilha foi enviada com sucesso para o tecnico "+clNome+".",{"Ok"})
		ELSE
			Aviso("Aten玢o","A planilha n鉶 pode ser enviada.",{"Ok"})
		ENDIF
	ENDIF
		
RETURN