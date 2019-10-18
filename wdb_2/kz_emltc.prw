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

	LOCAL clSubject	:= "Solicita็ใo de visita ao Tecnico"

	EnviaMens( clSubject, codTec)
	
RETURN

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ENVIAMENSบ Autor ณ Edilson Mendes     บ Data ณ  11/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Conecta no server/autentica, envia o e-mail com anexo      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ <codTec> - Codigo do Tecnico                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cliente WDB                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
STATIC FUNCTION EnviaMens(clSubject,codTec)

	LOCAL oServer
	LOCAL oMessage

	LOCAL cMailConta	:= ""
	LOCAL cMailServer	:= ""
	LOCAL cMailSenha	:= ""
	LOCAL cMailCtaAut	:= ""
	LOCAL cMensagem		:= ""
	LOCAL clEmailTec	:= ""
	LOCAL clMsgmail		:= ""
	
	LOCAL llRet			:= .F.


	DBSelectArea("SA3")
	IF SA3->( DBSetOrder(1), DBSeek( xFilial("SA3") + ALLTRIM( codTec ) ) )
		clEmailTec := SA3->A3_EMAIL
	ENDIF


	IF .NOT. EMPTY( clEmailTec )
		llRet := .T.
	ENDIF
	
	IF llRet

		Conout("Configurando Mensagem...")
		
		//Obtem dados necessarios a conexao.                                      ณ
		
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
		IF oServer:SmtpConnect() != 0
			Conout( "Falha ao conectar" )
			Return .F.
		ENDIF
		
		//seto um tempo de time out com servidor de 1min
		IF oServer:SetSmtpTimeOut( 60 ) != 0
			Conout( "Falha ao setar o time out" )
			Return .F.	
		ENDIF

		// Autentica็ใo
		IF oServer:SMTPAuth ( cMailConta,cMailSenha ) != 0
			Conout( "Falha ao autenticar" )
			Return .F.			        
		ENDIF


		//Apos a conexใo, crio o objeto da mensagem
		oMessage := TMailMessage():New()

		//Limpo o objeto
		oMessage:Clear()

		// Alimento a variavel com o texto do e-mail 
		IF LEN( alMsgmail ) > 0
			cMensagem:= ""
			FOR nPos := 1 TO LEN(alMsgmail)
				IF nPos == 1
					cMensagem += alMsgmail[nPos]+chr(13)+chr(10)
					cMensagem += chr(13)+chr(10)
				ELSE
					cMensagem += alMsgmail[nPos]+chr(13)+chr(10)
				ENDIF
			NEXT
		ENDIF

		//Populo com os dados de envio
		oMessage:cFrom		:= 	cMailConta
		oMessage:cTo		:=	clEmailTec
		oMessage:cSubject	:= 	clSubject
		oMessage:cBody		:= 	cMensagem


		//Adiciono um attach
		IF oMessage:AttachFile( "\System\planilhaWDB.xls" ) < 0   
			Conout( "Erro ao atachar o arquivo" )
			Return .F.
		ELSE
			//adiciono uma tag informando que ้ um attach e o nome do arq
			oMessage:AddAtthTag( 'Content-Disposition: attachmentfilename=planilhaWDB.xls')
			Conout( "Sucesso ao Anexar" )
		ENDIF


		//Envio o e-mail
		IF oMessage:Send( oServer ) != 0
			Conout( "Erro ao enviar o e-mail" )
			Return .F.
		ELSE
			Conout( "E-mail enviado com Sucesso" )
		ENDIF


		//Disconecto do servidor
		IF oServer:SmtpDisconnect() != 0
			Conout( "Erro ao disconectar do servidor SMTP" )
			Return .F.
		ELSE
			Conout( "Disconectado com Sucesso" )
		ENDIF

    ELSE
    	Aviso("Aten็ใo","Nใo foi localizado o e-mail do Tecnico.",{"Ok"})
    	Return .F.	
    ENDIF

RETURN( llRet )