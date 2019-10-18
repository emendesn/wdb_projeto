# Include "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � A410CONS � Autor � Edilson Mendes     � Data �  11/10/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para incluir botoes na enchoicebar na tela���
���          � de pedido de vendas.                                       ���
�������������������������������������������������������������������������͹��
���Parametro �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Cliente WDB                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION A410CONS()

LOCAL nOpc       := 2
PRIVATE aButtons := {}
	
	IF TYPE( "oGetDad" ) == "O"
		 nOpc := oGetDad:nOpc
	ENDIF
		
	AADD( aButtons, {"PENDENTE", {|| IIF( nOpc <> 2 .AND. nOpc <> 5 , U_KZ_FTlPd(), ;
	               Aviso("Aten��o","Essa op��o s� pode ser executada quando for Inclus�o ou Altera��o do Pedido de Vendas",{"Ok"}) ) },"Produtos"})

RETURN( aButtons )
