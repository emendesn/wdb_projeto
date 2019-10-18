# INCLUDE "Protheus.ch"
# INCLUDE "TopConn.ch"
# INCLUDE "Rwmake.ch" 
#Define CRLF CHR(13)+CHR(10)

/*#############################################################
##                   __   "   __                             ##
##                 ( __ \ | / __ ) Kazoolo                   ##
##                  ( _ / | \ _ )  Codefacttory              ##
###############################################################
## Função:     ## MTA410T.PRW                                ##
###############################################################
## Descrição:  ## Ponto de Entrada apos a gravação da        ##
##			   ## liberação do pedido de vendas				 ##
###############################################################
## Autor :     ## Hermes Ferreira de Almeida                 ##
###############################################################
## Data:       ## 20/01/2010                                 ##
###############################################################
## Palavras Chaves: Produtos                                 ##
#############################################################*/

User Function M440STTS

	Local clQry			:= ""
	Local clQryPed		:= ""
	Local clNumPed		:= ""

	Local nlQtdB2		:= 0
	Local nCont			:= 0

	Local alAltPed		:= {}
	Local alMailVend	:= {}
	Local alPedAlt		:= {}
	Local alMailAux		:= {}
	Local alPedAux		:= {}
	Local alEnvMail		:= {}

	Local llAlt			:= .F.
	Local llEnv			:= .F.
	Local llFirs		:= .T.

	clQryPed := " SELECT C6_NUM"
	clQryPed += ",C6_ITEM"
	clQryPed += ",C6_PRODUTO"
	clQryPed += ",C6_QTDVEN"
	clQryPed += ",C6_LOCAL"
	clQryPed += ",C6_QTDEMP"
	clQryPed += ",C6_QTDSUB"
	clQryPed += " FROM "+ RetSqlName("SC6")+ " SC6"
	clQryPed += " WHERE SC6.D_E_L_E_T_ = ' ' "
	clQryPed += " AND C6_FILIAL = '"+xFilial("SC6")+"'"
	clQryPed += " AND C6_NUM = '"+Alltrim(M->C5_NUM)+"'"

	clQryPed := ChangeQuery(clQryPed)

	TcQuery clQryPed New Alias "TMP"

	clQry := ""
	clQry := " SELECT C6_NUM"
	clQry += ",C6_ITEM"
	clQry += ",C6_PRODUTO"
	clQry += ",C6_QTDVEN"
	clQry += ",C6_LOCAL"
	clQry += ",C6_QTDEMP"
	clQry += ",C6_QTDSUB"

	clQry += " FROM "+ RetSqlName("SC6")+ " SC6"

	clQry += " WHERE SC6.D_E_L_E_T_ = ' '"
	clQry += " AND C6_FILIAL = '"+xFilial("SC6")+"'"
	clQry += " AND C6_NUM <> '"+Alltrim(M->C5_NUM)+"'"

	dbSelectArea("TMP")

	While TMP->(!EOF())
		nCont++
		If nCont == 1
			clQry += " AND (C6_PRODUTO = '"+TMP->C6_PRODUTO+"'"
		Else
			clQry += " OR C6_PRODUTO = '"+TMP->C6_PRODUTO+"'""
		EndIf
		TMP->(dbSkip())
	EndDo

	TMP->(dbCloseArea())

	clQry += ")"
	clQry += " AND(	C6_DINIC BETWEEN	'"+ DtoS(M->C5_DATAINI)	+"' AND '"	+ DtoS(M->C5_DATAFIM)+"'"
	clQry += " OR 	C6_DFINAL BETWEEN	'"+DtoS(M->C5_DATAINI)	+"' AND '"	+ DtoS(M->C5_DATAFIM)+"'"
	clQry += " OR ( C6_DINIC <= '"+DtoS(M->C5_DATAINI)+"' AND C6_DFINAL >= '"+DtoS(M->C5_DATAFIM) +"' ))"
	clQry += " AND C6_QTDEMP <> C6_QTDVEN"
	clQry += " ORDER BY C6_NUM"

	clQry	:= ChangeQuery(clQry)
	TcQuery clQry New Alias "TMPC6"

	cTmp := CriaTrab(Nil,.F.)
	DbSelectArea("TMPC6")

	Copy To &cTmp
	TMPC6->(DbCloseArea())

	DbUseArea(.T.,,cTmp,"TMP1",.F.,.F.)

	While TMP1->(!Eof())

		dbSelectArea("SB2")
		dbGotop()
		dbSetorder(1)
		If dbSeek(xFilial("SB2")+TMP1->C6_PRODUTO+TMP1->C6_LOCAL)
			nlQtdB2:= SB2->B2_QATU
		EndIf

		If nlQtdB2 > 0

			nlTotd := U_FFilDisp(TMP1->C6_PRODUTO,M->C5_DATAINI,M->C5_DATAFIM)
			TMPP->(dbCloseArea())

			nlDisp	:= nlQtdB2 - nlTotd

			If nlDisp > 0

				If TMP1->C6_QTDVEN > nlDisp
					nlSubLoc := TMP1->C6_QTDVEN - nlDisp
				Else
					nlSubLoc := 0
				EndIf

			Else

				nlSubLoc := TMP1->C6_QTDVEN

			EndIf

		Else

			nlSubLoc := TMP1->C6_QTDVEN

		EndIf

		If TMP1->C6_QTDSUB <> nlSubLoc

			aAdd(alAltPed,{TMP1->C6_NUM,;		// Numero do Pedido
							TMP1->C6_ITEM,;		// Item
							TMP1->C6_PRODUTO,;	// Produto
							nlSubLoc})			// Quantidade SubLocada

		EndIf

		TMP1->(dbSkip())
	EndDo
	TMP1->(dbCloseArea())


	For n := 1 To Len(alAltPed)

		llAlt:= .F.

		dbSelectArea("SC6")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek(xFilial("SC6")+alAltPed[n][1]+alAltPed[n][2]+alAltPed[n][3])
			If RecLock("SC6",.F.)
				SC6->C6_QTDSUB := alAltPed[n][4]
				MsUnLock()
			EndIf
			llAlt := .T.
		EndIf

        If llAlt
			dbSelectArea("SC5")
			dbSetorder(1)
			dbGoTop()
			If dbSeek(xFilial("SC5")+Alltrim(alAltPed[n][1]))

				If clNumPed <> Alltrim(alAltPed[n][1])

					clNumPed := alAltPed[n][1]

					If llFirs

						aAdd(alMailAux,{alAltPed[n][1],;	// Numero Pedido
										SC5->C5_VEND1,;		// Vendedor 1
										SC5->C5_VEND2,;		// Vendedor 2
										SC5->C5_VEND3,;		// Vendedor 3
										SC5->C5_VEND4,;		// Vendedor 4
										SC5->C5_VEND5,;		// Vendedor 5
										SC5->C5_CLIENTE,;	// Cliente
										SC5->C5_LOJACLI})	// Loja

						aAdd(alPedAux,{alAltPed[n][1],;	// Numero Pedido
										alAltPed[n][2],;	// Item do Pedido
										alAltPed[n][3],;	// Produto
										alAltPed[n][4]})	// Quantidade SubLocada
						llFirs:= .F.                    	

					Else

						alMailVend	:= aClone(alMailAux)
						alPedAlt	:= aClone(alPedAux)
						aAdd(alEnvMail,{alMailVend,alPedAlt})
						alMailAux	:= {}
						alPedAux	:= {}
						aAdd(alMailAux,{alAltPed[n][1],;	// Numero Pedido
										SC5->C5_VEND1,;		// Vendedor 1
										SC5->C5_VEND2,;		// Vendedor 2
										SC5->C5_VEND3,;		// Vendedor 3
										SC5->C5_VEND4,;		// Vendedor 4
										SC5->C5_VEND5,;		// Vendedor 5
										SC5->C5_CLIENTE,;	// Cliente
										SC5->C5_LOJACLI})	// Loja

						aAdd(alPedAux,{alAltPed[n][1],;	// Numero do Pedido
										alAltPed[n][2],;	// Item do Pedido
										alAltPed[n][3],;	// Produto
										alAltPed[n][4]})	// Quantidade SubLocada

					EndIf

				Else

					aAdd(alPedAux,{alAltPed[n][1],;	// Numero do Pedido
									alAltPed[n][2],;	// Item do Pedido
									alAltPed[n][3],;	// Produto
									alAltPed[n][4]})	// Quantidade SubLocada

				EndIf
			EndIf
		EndIf
	Next n

	If Len(alMailAux)>0 .and. Len(alPedAux)>0
		alMailVend	:= aClone(alMailAux)
		alPedAlt	:= aClone(alPedAux)
		aAdd(alEnvMail,{alMailVend,alPedAlt})
    EndIf

	If Len(alEnvMail)>0
		MsgRun("Enviando e-mail aos vendedores ", "Aguarde...", { || llEnv := FMailVed(alEnvMail) } )
		If llEnv
			Aviso("Atenção","O e-mail foi enviado com sucesso para os vendedores.",{"Ok"})
		Else
			Aviso("Atenção","Não foi possível enviar o e-mail para os vendedores.",{"Ok"})
		EndIf
	Endif

Return .T.

/*#############################################################
##                   __   "   __                             ##
##                 ( __ \ | / __ ) Kazoolo                   ##
##                  ( _ / | \ _ )  Codefacttory              ##
###############################################################
## Função:     ## FMailVed                                   ##
###############################################################
## Descrição:  ## Envia e-mail informando as alterações que  ##
##			   ## ocorreram com os pedidos de vendas em 	 ##
##			   ## aberto									 ##
###############################################################
## Autor :     ## Hermes Ferreira de Almeida                 ##
###############################################################
## Data:       ## 20/01/2010                                 ##
###############################################################
## Palavras Chaves: Produtos                                 ##
#############################################################*/

Static Function FMailVed(alEnvMail)

	Local oServer
	Local oMessage

	Local cMailConta	:= ""
	Local cMailServer	:= ""
	Local cMailSenha	:= ""
	Local cMailCtaAut	:= ""
	Local cMensagem		:= ""
	Local clEmailTec	:= ""
	Local clMsgmail		:= ""
	Local clVend1		:= ""
	Local clVend2		:= ""
	Local clVend3		:= ""
	Local clVend4		:= ""
	Local clVend5		:= ""
	Local clNomeCli		:= ""
	Local clMails 		:= ""
	Local clSubject		:= "Alteração no pedido de venda"
	Local alMsgmail		:= {}
	Local llRet			:= .F.

	Conout("Configurando Mensagem...")

	//Obtem dados necessarios a conexao.
	cMailConta  := GetMV("KZ_WDBCONT")
	cMailServer := GetMV("KZ_WDBSERV")
	cMailSenha  := GetMV("KZ_WDBPWD")
	cMailCtaAut := GetMV("KZ_WDBAUTH")


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


	// Envia os e-mail, referentes a cada pedido
	For n := 1 To Len(alEnvMail)
        llRet	:= .F.
		clMails		:= ""
		clMsgmail	:= ""
		alMsgmail:= {}

		dbSelectArea("SA3")
		dbSetOrder(1)
		dbGoTop()

		For nM := 1 To 5
			If !Empty(ALLTRIM(alEnvMail[n][1][1][nM+1]))
				If dbSeek(xFilial("SA3")+ALLTRIM(alEnvMail[n][1][1][nM+1]))
					If !Empty(SA3->A3_EMAIL)
						If nM == 1
							clMails := Alltrim(SA3->A3_EMAIL)
						Else
							clMails += ";"+Alltrim(SA3->A3_EMAIL)
						EndIf
						llRet := .T.
					EndIf
				EndIf
			EndIf
		Next nM

		If llRet

			clMsgmail	:= GetMV("KZ_MSGMLVD") // Texto do e-mail

			alMsgmail := Separa(clMsgmail,";")

			//Apos a conexão, crio o objeto da mensagem
			oMessage := TMailMessage():New()

			//Limpo o objeto
			oMessage:Clear()

			If Len(alMsgmail)>0
				cMensagem:= ""
				For p := 1 To len(alMsgmail)
					If p == 1
						cMensagem += alMsgmail[p]+"<Br> <Br> "
					Else
						cMensagem += alMsgmail[p]+"<Br>"
					EndIf
				Next p
			EndIf
			cMensagem += "<Br> <Br> "

			cMensagem += "<HTML><BODY>" + CRLF
			cMensagem += "<Table width=50%;  border='1'>" + CRLF
			cMensagem += "<TR>" + CRLF
			cMensagem += "<TD width=30% rolspan='1'; ALIGN=CENTER><H2> Pedido - "+ALLTRIM(alEnvMail[n][1][1][1])+"</H2></TD>
			cMensagem += "</TR>" + CRLF
			cMensagem += "</Table>"
			cMensagem += "<BR>"
			cMensagem += "<Table width=50%;  border='1'>" + CRLF
			cMensagem += "<TR>" + CRLF
			cMensagem += "<TD BgColor=RED				; ALIGN='CENTER' ><font face=Arial color=BLACK size=2><b>Cliente</font></b></TD>"+ CRLF
			cMensagem += "<TD BgColor=RED				; ALIGN='CENTER' ><font face=Arial color=BLACK size=2><b>Loja</font></b></TD>"+ CRLF
			cMensagem += "<TD BgColor=RED				; ALIGN='CENTER' ><font face=Arial color=BLACK size=2><b>Item Ped.</font></b></TD>"+ CRLF
			cMensagem += "<TD BgColor=RED				; ALIGN='CENTER' ><font face=Arial color=BLACK size=2><b>Produto</font></b></TD>"+ CRLF
			cMensagem += "<TD BgColor=RED				; ALIGN='CENTER' ><font face=Arial color=BLACK size=2><b>Quantidade</font></b></TD>"+ CRLF
			cMensagem += "</TR>" + CRLF

			For m := 1 to len(alEnvMail[n][2])
				cMensagem += "<TR>"
				cMensagem += "<TD ALIGN=CENTER><font face=Arial color=black size=1>"+ALLTRIM(alEnvMail[n][1][1][7])+"</Font></TD>"+CRLF
				cMensagem += "<TD ALIGN=CENTER><font face=Arial color=black size=1>"+ALLTRIM(alEnvMail[n][1][1][8])+"</Font></TD>"+CRLF
				cMensagem += "<TD ALIGN=CENTER><font face=Arial color=black size=1>"+ALLTRIM(alEnvMail[n][2][m][2])+"</Font></TD>"+CRLF
				cMensagem += "<TD ALIGN=CENTER><font face=Arial color=black size=1>"+ALLTRIM(alEnvMail[n][2][m][3])+"</Font></TD>"+CRLF
				cMensagem += "<TD ALIGN=CENTER><font face=Arial color=black size=1>"+Alltrim(Transform(alEnvMail[n][2][m][4],PesqPict("SC6","C6_QTDSUB")))+"</Font></TD>"+CRLF
				cMensagem += "</TR>"+CRLF
			Next n
			cMensagem += "</table>"

			cMensagem +=  "<BR> <BR> "

			cMensagem += "a Diretoria"

			cMensagem += "</body>"
			cMensagem += "</html>"


			//Populo com os dados de envio
			oMessage:cFrom		:= 	cMailConta
			oMessage:cTo 		:=  clMails
			oMessage:cSubject	:= 	clSubject
			oMessage:cBody		:= 	cMensagem

			//Envio o e-mail
			If oMessage:Send( oServer ) != 0
				Conout( "Erro ao enviar o e-mail" )
				Return .F.
			Else
				Conout( "E-mail enviado com Sucesso" )
			EndIf

	    Else
	    	Aviso("Atenção","Não foi localizado o e-mail de nenhum vendedor para informar sobre o Pedido "+ALLTRIM(alEnvMail[n][1][1][1])+".",{"Ok"})
	    EndIf
    Next n


	//Disconecto do servidor
	If oServer:SmtpDisconnect() != 0
		Conout( "Erro ao disconectar do servidor SMTP" )
		Return .F.
	Else
		Conout( "Disconectado com Sucesso" )
	EndIf

Return llRet