
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA410DEL � Autor � Edilson Mendes     � Data �  18/01/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada executado apos a exclusao dos registros   ���
���          � da tabela SC5.                                             ���
�������������������������������������������������������������������������͹��
���Parametro �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Cliente WDB                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER FUNCTION MA410DEL

LOCAL aArea  := GetArea()

ALTD()

	DBSelectArea("SYP")
	SYP->( DBSetOrder(1) )
	SYP->( DBSeek( xFilial("SYP") + M->C5_COD_OBS ) )
	WHILE SYP->( .NOT. EOF() ) .AND. SYP->YP_FILIAL == xFilial("SYP") .AND. SYP->YP_CHAVE == M->C5_COD_OBS
		RecLock('SYP',.F.)
		SYP->( DBDelete() )
		MSUnLock()
		SYP->( DBSkip() )
	ENDDO
	
	RestArea( aArea )
		    
RETURN
