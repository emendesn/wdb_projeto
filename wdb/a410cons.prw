# Include "Protheus.ch"

// Ponto de entrada para incluir botoes na enchoicebar na tela de pedido de vendas

/*#############################################################
##                   __   "   __                             ##
##                 ( __ \ | / __ ) Kazoolo                   ##
##                  ( _ / | \ _ )  Codefacttory              ##
###############################################################
## Fun��o:     ## A410CONS.PRW                               ##
###############################################################
## Descri��o:  ## Ponto de entrada para incluir botoes na    ##
##			   ## enchoicebar na tela de pedido de vendas    ##
###############################################################
## Autor :     ## Hermes Ferreira de Almeida                 ##
###############################################################
## Data:       ## 20/01/2010                                 ##
###############################################################
## Palavras Chaves: Bot�o                                    ##
#############################################################*/

User Function A410CONS()
	Local nOpc:= 2
	Private aButtons := {}
	
	If Type("oGetDad") == "O"
		 nOpc:= oGetDad:nOpc
	EndIf
		
	Aadd(aButtons,{"PENDENTE",{|| IIf( nOpc <> 2 .AND. nOpc <> 5 , U_KZ_FTlPd(),Aviso("Aten��o","Essa op��o s� pode ser executada quando for Inclus�o ou Altera��o do Pedido de Vendas",{"Ok"}) ) },"Produtos"})

Return aButtons
