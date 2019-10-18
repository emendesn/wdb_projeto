/*#############################################################
##                   __   "   __                             ##
##                 ( __ \ | / __ ) Kazoolo                   ##
##                  ( _ / | \ _ )  Codefacttory              ##
###############################################################
## Função:     ## MTA410T.PRW                                ##
###############################################################
## Descrição:  ##  Ponto de Entrada apos a gravação do pedido##
##			   ## de compra, e verifica se manda e-mail para ##
##			   ## o tecnico                 				 ##
###############################################################
## Autor :     ## Hermes Ferreira de Almeida                 ##
###############################################################
## Data:       ## 20/01/2010                                 ##
###############################################################
## Palavras Chaves: Produtos                                 ##
#############################################################*/

User Function MTA410T
	Local clNome	:= ""
	Local clCod		:= GetMV("KZ_SOLTECN")
	Local llOk		:= .F.
	
	dbSelectArea("SA3")
	dbSetorder(1)
	dbGotop()
	If dbSeek(xFilial("SA3")+M->C5_VEND5)
		clNome	:= SA3->A3_NOME
	EndIf
	
	nExist := Ascan(aCols,{|m| Alltrim(m[GDFIELDPOS("C6_PRODUTO")]) == Alltrim(clCod)})

	If M->C5_EMAIL == '1' .and. !Empty(clCod) .AND. nExist > 0
		llOk := U_KZ_EmlTc(M->C5_VEND5)
		If llOk
			Aviso("Atenção","A planilha foi enviada com sucesso para o tecnico "+clNome+".",{"Ok"})
		Else
			Aviso("Atenção","A planilha não pode ser enviada.",{"Ok"})
		EndIf
	EndIf	

Return