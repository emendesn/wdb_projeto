/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA410T  � Autor � Edilson Mendes     � Data �  11/10/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada apos a grava��o do pedido de venda, e     ���
���          � verifica se manda e-mail para o tecnico.                   ���
�������������������������������������������������������������������������͹��
���Parametro �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Cliente WDB                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
				Aviso( "Aten��o", "A planilha foi enviada com sucesso para o Tecnico " + ALLTRIM( clNome ) + ".", {"Ok"} )
			ELSE
				Aviso( "Aten��o", "A planilha n�o pode ser enviada para o Tecnico.", {"Ok"} )
			ENDIF
		ENDIF
	ENDIF
	    
RETURN