#include "protheus.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � KZ_EMLTC � Autor � Edilson Mendes     � Data �  11/10/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Envia e-mail para um tecnico com o anexo da planilha       ���
�������������������������������������������������������������������������͹��
���Parametro � <codTec> - Codigo do Tecnico                               ���
�������������������������������������������������������������������������͹��
���Uso       � Cliente WDB                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER FUNCTION KZ_EmlTc( codTec )

	Local llRet		:= .F.
	Local clSubject	:= "Solicita��o de visita ao Tecnico"

	MsgRun( "Enviando e-mail para o Tecnico", "Aguarde...", { || llRet := EnviaMens( clSubject, codTec) } )

RETURN( llRet )


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � EnviaMens� Autor � Edilson Mendes     � Data �  11/10/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Conecta no server/autentica, envia o e-mail com anexo      ���
�������������������������������������������������������������������������͹��
���Parametro � <clSubject> - Titulo do e-mail(Numero do Pedido)           ���
���          � <codTec> - Codigo do Tecnico                               ���
�������������������������������������������������������������������������͹��
���Uso       � Cliente WDB                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

		//Crio a conex�o com o server STMP ( Envio de e-mail )
		oServer := TMailManager():New()
		oServer:Init( "", cMailServer, cMailConta,cMailSenha)

		//realizo a conex�o SMTP
		If oServer:SmtpConnect() != 0
			Conout( "Falha ao conectar" )
			Return .F.
		EndIf

		//seto um tempo de time out com servidor de 1min
		If oServer:SetSmtpTimeOut( 60 ) != 0
			Conout( "Falha ao setar o time out" )
			Return .F.
		EndIf

		// Autentica��o
		If oServer:SMTPAuth ( cMailConta,cMailSenha ) != 0
			Conout( "Falha ao autenticar" )
			Return .F.
		EndIf		


		//Apos a conex�o, crio o objeto da mensagem
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
			//adiciono uma tag informando que � um attach e o nome do arq
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
    	Aviso("Aten��o","N�o foi localizado o e-mail do Tecnico.",{"Ok"})
    	Return .F.
    EndIf

Return llRet