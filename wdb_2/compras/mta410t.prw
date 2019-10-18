/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MTA410T   � Autor � Murilo Swistalski   � Data � 17/03/2010 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada apos a grava��o do pedido de compra, e    ���
���          � verifica se manda e-mail para o tecnico                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para Criacao/Alteracao da Agenda JOB - WDB      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
			Aviso("Aten��o","A planilha foi enviada com sucesso para o tecnico "+clNome+".",{"Ok"})
		ELSE
			Aviso("Aten��o","A planilha n�o pode ser enviada.",{"Ok"})
		ENDIF
	ENDIF
		
RETURN