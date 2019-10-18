#include "protheus.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"

/*#############################################################
##                   __   "   __                             ##
##                 ( __ \ | / __ ) Kazoolo                   ##
##                  ( _ / | \ _ )  Codefacttory              ##
###############################################################
## Função:     ## KZ_EmlTc.PRW                               ##
###############################################################
## Descrição:  ##  Envia e-mail para um tecnico com o anexo  ##
##			   ## da planilha							     ##
###############################################################
## Parametro   ## codTec - Codigo do Tecnico                 ##
###############################################################
## Autor :     ## Hermes Ferreira de Almeida                 ##
###############################################################
## Data:       ## 25/01/2010                                 ##
###############################################################
## Palavras Chaves: E-mail/Anexo                             ##
#############################################################*/

User Function KZ_EmlTc(codTec)

	Local clSubject	:= "Solicitação de visita ao Tecnico"

	EnviaMens(clSubject,codTec)
	
Return

/*#############################################################
##                   __   "   __                             ##
##                 ( __ \ | / __ ) Kazoolo                   ##
##                  ( _ / | \ _ )  Codefacttory              ##
###############################################################
## Função:     ## EnviaMens.PRW                              ##
###############################################################
## Descrição:  ## Conecta no server/autentica, envia o e-mail##
##			   ## com anexo								     ##
###############################################################
## Parametro   ## clSubject - Titulo do e-mail(Numero do     ##
##             ## Pedido					                 ##
##             ## codTec - Codigo do Tecnico                 ##
###############################################################
## Autor :     ## Hermes Ferreira de Almeida                 ##
###############################################################
## Data:       ## 25/01/2010                                 ##
###############################################################
## Palavras Chaves: E-mail/Anexo                             ##
#############################################################*/

Static Function EnviaMens(clSubject,codTec)

	Local oServer
	Local oMessage

	Local cMailConta	:= ""
	Local cMailServer	:= ""
	Local cMailSenha	:= ""
	Local cMailCtaAut	:= ""
	Local cMensagem		:= ""
	Local clEmailTec	:= ""
	Local clMsgmail		:= ""
	
	Local llRet			:= .F.


	dbSelectArea("SA3")
	dbSetOrder(1)
	dbGoTop()
	If dbSeek(xFilial("SA3")+ALLTRIM(codTec))
		clEmailTec := SA3->A3_EMAIL
	EndIf


	If !Empty(clEmailTec)
		llRet := .T.
	EndIf
	
	If llRet

		Conout("Configurando Mensagem...")
		
		//Obtem dados necessarios a conexao.                                      ³
		
		cMailConta  := GetMV("KZ_WDBCONT")
		cMailServer := GetMV("KZ_WDBSERV")
		cMailSenha  := GetMV("KZ_WDBPWD")
		cMailCtaAut := GetMV("KZ_WDBAUTH")
		clMsgmail	:= GetMV("KZ_MSGMAIL") // Texto do e-mail

		alMsgmail := Separa(clMsgmail,";")

		//Crio a conexão com o server STMP ( Envio de e-mail )
		oServer := TMailManager():New()
		oServer:Init( "", cMailServer, cMailConta,cMailSenha)

		//realizo a conexão SMTP
		If oServer:SmtpConnect() != 0
			Conout( "Falha ao conectar" )
			Return .F.
		EndIf
		
		//seto um tempo de time out com servidor de 1min
		If oServer:SetSmtpTimeOut( 60 ) != 0
			Conout( "Falha ao setar o time out" )
			Return .F.	
		EndIf

		// Autenticação
		If oServer:SMTPAuth ( cMailConta,cMailSenha ) != 0
			Conout( "Falha ao autenticar" )
			Return .F.			        
		EndIf		


		//Apos a conexão, crio o objeto da mensagem
		oMessage := TMailMessage():New()

		//Limpo o objeto
		oMessage:Clear()

		// Alimento a variavel com o texto do e-mail 
		If Len(alMsgmail)>0
			cMensagem:= ""
			For n := 1 to len(alMsgmail)
				If n == 1
					cMensagem += alMsgmail[n]+chr(13)+chr(10)
					cMensagem += chr(13)+chr(10)
				Else
					cMensagem += alMsgmail[n]+chr(13)+chr(10)
				EndIf
			Next n
		EndIf

		//Populo com os dados de envio
		oMessage:cFrom		:= 	cMailConta
		oMessage:cTo		:=	clEmailTec
		oMessage:cSubject	:= 	clSubject
		oMessage:cBody		:= 	cMensagem


		//Adiciono um attach
		If oMessage:AttachFile( "\System\planilhaWDB.xls" ) < 0   
			Conout( "Erro ao atachar o arquivo" )
			Return .F.
		Else
			//adiciono uma tag informando que é um attach e o nome do arq
			oMessage:AddAtthTag( 'Content-Disposition: attachmentfilename=planilhaWDB.xls')
			Conout( "Sucesso ao Anexar" )
		EndIf


		//Envio o e-mail
		If oMessage:Send( oServer ) != 0
			Conout( "Erro ao enviar o e-mail" )
			Return .F.
		Else
			Conout( "E-mail enviado com Sucesso" )
		EndIf


		//Disconecto do servidor
		If oServer:SmtpDisconnect() != 0
			Conout( "Erro ao disconectar do servidor SMTP" )
			Return .F.
		Else
			Conout( "Disconectado com Sucesso" )
		EndIf

    Else
    	Aviso("Atenção","Não foi localizado o e-mail do Tecnico.",{"Ok"})
    	Return .F.	
    EndIf

Return llRet