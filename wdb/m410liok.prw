/*#############################################################
##                   __   "   __                             ##
##                 ( __ \ | / __ ) Kazoolo                   ##
##                  ( _ / | \ _ )  Codefacttory              ##
###############################################################
## Função:     ## M410LIOK.PRW                               ##
###############################################################
## Descrição:  ## Ponto de entrada na validação do LinhaOK   ##
##			   ## da getdados no pedido de venda             ##
###############################################################
## Autor :     ## Hermes Ferreira de Almeida                 ##
###############################################################
## Data:       ## 20/01/2010                                 ##
###############################################################
## Palavras Chaves: Produtos                                 ##
#############################################################*/

User Function M410LIOK()
	Local k			:= 0
	Local clProd	:= ""
	Local llRet		:= .T.
	Local alCpy		:= aClone(aCols)
	
	alCpy := aSort(alCpy,,,{|x,y| x[GDFIELDPOS("C6_PRODUTO")] < y[GDFIELDPOS("C6_PRODUTO")]} )
	
	If (Len(alCpy)-1) > 0
		
		For k := 1 to (Len(alCpy))
			If !(alCpy[k][Len(aHeader)+1])
				If  clProd <> Alltrim(alCpy[k][GDFIELDPOS("C6_PRODUTO")])
				
					clProd := Alltrim(alCpy[k][GDFIELDPOS("C6_PRODUTO")])
					
				Else	
				
					Aviso("Atenção","O produto "+Alltrim(alCpy[n][GDFIELDPOS("C6_PRODUTO")])+" já foi informado.",{"OK"})
					oGetDad:OBROWSE:NCOLPOS := GDFIELDPOS("C6_PRODUTO")
					llRet	:= .F.
					Exit
					
				EndIf
			EndIf
		Next k
    EndIf
Return llRet
