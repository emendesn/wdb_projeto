
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M410LIOK � Autor � Edilson Mendes     � Data �  11/10/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada na valida��o do LinhaOK da getdados no    ���
���          � pedido de venda.                                           ���
�������������������������������������������������������������������������͹��
���Parametro �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Cliente WDB                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER FUNCTION M410LIOK()

LOCAL nPos
LOCAL clProd := ""
LOCAL llRet  := .T.
LOCAL alCpy  := aClone(aCols)

	alCpy := aSort(alCpy,,,{|x,y| x[GDFIELDPOS("C6_PRODUTO")] < y[GDFIELDPOS("C6_PRODUTO")]} )
	
	IF( LEN( alCpy ) -1 ) > 0
		
		FOR nPos := 1 TO LEN(alCpy)
			IF .NOT. alCpy[nPos][Len(aHeader)+1])
				IF clProd <> Alltrim(alCpy[nPos][GDFIELDPOS("C6_PRODUTO")])
					clProd := Alltrim(alCpy[nPos][GDFIELDPOS("C6_PRODUTO")])
				ELSE
					Aviso("Aten��o","O produto "+Alltrim(alCpy[n][GDFIELDPOS("C6_PRODUTO")])+" j� foi informado.",{"OK"})
					oGetDad:OBROWSE:NCOLPOS := GDFIELDPOS("C6_PRODUTO")
					llRet	:= .F.
					EXIT
				ENDIF
			ENDIF
		NEXT
		
	ENDIF
	    
RETURN( llRet )
