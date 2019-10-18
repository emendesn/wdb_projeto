#include "protheus.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ KZ_EMLTC บ Autor ณ Edilson Mendes     บ Data ณ  11/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Envia e-mail para um tecnico com o anexo da planilha       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ <codTec> - Codigo do Tecnico                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cliente WDB                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
USER FUNCTION KZ_EmlTc( codTec )

	Local llRet		:= .F.
	Local clSubject	:= "Solicita็ใo de visita ao Tecnico"

	MsgRun( "Enviando e-mail para o Tecnico", "Aguarde...", { || llRet := EnviaMens( clSubject, codTec) } )

RETURN( llRet )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ EnviaMensบ Autor ณ Edilson Mendes     บ Data ณ  11/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Conecta no server/autentica, envia o e-mail com anexo      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ <clSubject> - Titulo do e-mail(Numero do Pedido)           บฑฑ
ฑฑบ          ณ <codTec> - Codigo do Tecnico                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cliente WDB                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
STATIC FUNCTION EnviaMens(clSubject,codTec)

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

	DBSelectArea("SA3")
	SA3->( DBGoTop() )
	IF SA3->( DBSetOrder(1), DBSeek( xFilial("SA3") + ALLTRIM( codTec ) ) )
		IF .NOT. EMPTY( ALLTRIM( SA3->A3_EMAIL ) )
			clEmailTec := SA3->A3_EMAIL
		ENDIF
	ENDIF

	IF .NOT. EMPTY( clEmailTec )
		llRet := .T.
	ENDIF

	IF llRet

		Conout("Configurando Mensagem...")

		//Obtem dados necessarios a conexao.

		cMailConta  := GetMV("KZ_WDBCONT")
		cMailServer := GetMV("KZ_WDBSERV")
		cMailSenha  := GetMV("KZ_WDBPWD")
		cMailCtaAut := GetMV("KZ_WDBAUTH")
		clMsgmail	:= GetMV("KZ_MSGMAIL") // Texto do e-mail

		alMsgmail := Separa(clMsgmail,";")

		//Crio a conexใo com o server STMP ( Envio de e-mail )
		oServer := TMailManager():New()
		oServer:Init( "", cMailServer, cMailConta,cMailSenha)

		//realizo a conexใo SMTP
		If oServer:SmtpConnect() != 0
			Conout( "Falha ao conectar" )
			Return .F.
		EndIf

		//seto um tempo de time out com servidor de 1min
		If oServer:SetSmtpTimeOut( 60 ) != 0
			Conout( "Falha ao setar o time out" )
			Return .F.
		EndIf

		// Autentica็ใo
		If oServer:SMTPAuth ( cMailConta,cMailSenha ) != 0
			Conout( "Falha ao autenticar" )
			Return .F.
		EndIf		


		//Apos a conexใo, crio o objeto da mensagem
		oMessage := TMailMessage():New()

		//Limpo o objeto
		oMessage:Clear()

		// Alimento a variavel com o texto do e-mail 
		If Len(alMsgmail)>0
			cMensagem:= ""
			For n := 1 to len(alMsgmail)
				If n == 1
					cMensagem += alMsgmail[n]+"<Br> <Br> "
				Else
					cMensagem += alMsgmail[n]+"<Br>"
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
			//adiciono uma tag informando que ้ um attach e o nome do arq
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
    	Aviso("Aten็ใo","Nใo foi localizado o e-mail do Tecnico.",{"Ok"})
    	Return .F.
    EndIf

Return llRet