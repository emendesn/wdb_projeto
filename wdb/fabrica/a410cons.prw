# Include "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � A410CONS � Autor � Edilson Mendes     � Data �  11/10/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para incluir botoes na                    ���
���          � enchoicebar na tela de pedido de vendas                    ���
�������������������������������������������������������������������������͹��
���Uso       � Cliente WDB                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER FUNCTION A410CONS()

LOCAL nOpc:= 2

PRIVATE aButtons := {}

	IF TYPE("oGetDad") == "O"
		nOpc := oGetDad:nOpc
	ENDIF
	
	IF nOpc <> 2 .AND. nOpc <> 5
		AADD( aButtons, {"PENDENTE", {|| U_KZ_FTlPd()}, "Produtos" } )
	ENDIF
	
RETURN aButtons
