# INCLUDE "Protheus.ch"
# INCLUDE "TopConn.ch"
# INCLUDE "Rwmake.ch"

// Apos a gravação da liberação do pedido de vendas
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
	
	TcQuery clQryPed New Alias "TMP1"
		
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
	dbSelectArea("TMP1")

	While TMP1->(!EOF())
		nCont++
		If nCont == 1
			clQry += " AND (C6_PRODUTO = '"+TMP1->C6_PRODUTO+"'"
		Else
			clQry += " OR C6_PRODUTO = '"+TMP1->C6_PRODUTO+"'""
		EndIf
		TMP1->(dbSkip())
	EndDo
	TMP1->(dbCloseArea())
	clQry += ")"
	clQry += " AND(	C6_DINIC BETWEEN	'"+ DtoS(M->C5_DATAINI)	+"' AND '"	+ DtoS(M->C5_DATAFIM)+"'"
	clQry += " OR 	C6_DFINAL BETWEEN	'"+DtoS(M->C5_DATAINI)	+"' AND '"	+ DtoS(M->C5_DATAFIM)+"'"
	clQry += " OR ( C6_DINIC <= '"+DtoS(M->C5_DATAINI)+"' AND C6_DFINAL >= '"+DtoS(M->C5_DATAFIM) +"' ))"
	clQry += " AND C6_QTDEMP <> C6_QTDVEN"
	
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
    
			clQryPAZ := ""
			clQryPAZ := "SELECT (SELECT SUM(PAZ_QUANT)"
			clQryPAZ += "			FROM "+ RetSqlName("PAZ")+ " PAZ "
			clQryPAZ += "			WHERE PAZ.D_E_L_E_T_ = ' '"
			clQryPAZ += "			AND PAZ_FILIAL = '"+xFilial("PAZ")+"'"
			clQryPAZ += "			AND PAZ_PRODUT = '"+Alltrim(TMP1->C6_PRODUTO)+"'"
			clQryPAZ += " 			AND(PAZ_DTINI BETWEEN	'"+ DtoS(M->C5_DATAINI)	+"' AND '"	+ DtoS(M->C5_DATAFIM)+"'"
			clQryPAZ += " 			OR 	PAZ_DTFIM BETWEEN	'"+DtoS(M->C5_DATAINI)	+"' AND '"	+ DtoS(M->C5_DATAFIM)+"'"
			clQryPAZ += " 			OR (PAZ_DTINI <= '"+DtoS(M->C5_DATAINI)+"' AND PAZ_DTFIM >= '"+DtoS(M->C5_DATAFIM) +"' ))"				
			clQryPAZ += "			GROUP BY PAZ_PRODUT)AS TOTAL"
			clQryPAZ += "			,PAZ_PRODUT"
		
			clQryPAZ += " FROM "+ RetSqlName("PAZ")+ " PAZ "
			clQryPAZ += " WHERE PAZ.D_E_L_E_T_ = ' '"
			clQryPAZ += " AND PAZ_FILIAL = '"+xFilial("PAZ")+"'"
			clQryPAZ += " AND PAZ_PRODUT = '"+Alltrim(TMP1->C6_PRODUTO)+"'"
			clQryPAZ += " AND(	PAZ_DTINI BETWEEN	'"+ DtoS(M->C5_DATAINI)	+"' AND '"	+ DtoS(M->C5_DATAFIM)+"'"
			clQryPAZ += " OR 	PAZ_DTFIM BETWEEN	'"+DtoS(M->C5_DATAINI)	+"' AND '"	+ DtoS(M->C5_DATAFIM)+"'"
			clQryPAZ += " OR (PAZ_DTINI <= '"+DtoS(M->C5_DATAINI)+"' AND PAZ_DTFIM >= '"+DtoS(M->C5_DATAFIM) +"' ))"

			clQryPAZ += " GROUP BY PAZ_PRODUT"
		
			TcQuery clQryPAZ New Alias "TMPP"

			nlDisp	:= nlQtdB2 - TMPP->TOTAL

			If nlDisp > 0

				If TMP1->C6_QTDVEN > nlDisp
					nlSubLoc := TMP1->C6_QTDVEN - nlDisp
				Else
					nlSubLoc := 0
				EndIf

			Else

				nlSubLoc := TMP1->C6_QTDVEN

			EndIf
			
			TMPP->(dbCloseArea())

		Else

			nlSubLoc := TMP1->C6_QTDVEN

		EndIf

		aAdd(alAltPed,{TMP1->C6_NUM,TMP1->C6_ITEM,TMP1->C6_PRODUTO,nlSubLoc})

		TMP1->(dbSkip())
	EndDo
	
	
	
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
					
						aAdd(alMailAux,{alAltPed[n][1],SC5->C5_VEND1,SC5->C5_VEND2,SC5->C5_VEND3,SC5->C5_VEND4,SC5->C5_VEND5,SC5->C5_CLIENTE,SC5->C5_LOJACLI})
						aAdd(alPedAux,{alAltPed[n][1],alAltPed[n][2],alAltPed[n][3],alAltPed[n][4]})
						llFirs:= .F.
						
					Else
						
						alMailVend	:= aClone(alMailAux)
						alPedAlt	:= aClone(alPedAux)
						aAdd(alEnvMail,{alMailVend,alPedAlt})
						alMailAux	:= {}
						alPedAux	:= {}
						aAdd(alMailAux,{alAltPed[n][1],SC5->C5_VEND1,SC5->C5_VEND2,SC5->C5_VEND3,SC5->C5_VEND4,SC5->C5_VEND5,SC5->C5_CLIENTE,SC5->C5_LOJACLI})
						aAdd(alPedAux,{alAltPed[n][1],alAltPed[n][2],alAltPed[n][3],alAltPed[n][4]})
											
					EndIf
					
				Else
	
					aAdd(alPedAux,{alAltPed[n][1],alAltPed[n][2],alAltPed[n][3],alAltPed[n][4]})
	
				EndIf
			EndIf
		EndIf
	Next n
	
	alMailVend	:= aClone(alMailAux)
	alPedAlt	:= aClone(alPedAux)
	aAdd(alEnvMail,{alMailVend,alPedAlt})

	If Len(alEnvMail)>0
		//FMailVed(alEnvMail)
	Endif

Return 
/*
  
EM DESENVOLVIMENTO



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
	Local clSubject		:= "Alteração no pedido de venda"
	
	
	Local llRet			:= .F.

	For n := 1 To Len(alEnvMail)
	
		dbSelectArea("SA3")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek(xFilial("SA3")+ALLTRIM(alEnvMail[n][1][1][2]))
			clVend1 := SA3->A3_EMAIL
		EndIf
		If dbSeek(xFilial("SA3")+ALLTRIM(alEnvMail[n][1][1][3]))
			clVend2 := SA3->A3_EMAIL
		EndIf
		If dbSeek(xFilial("SA3")+ALLTRIM(alEnvMail[n][1][1][4]))
			clVend3 := SA3->A3_EMAIL
		EndIf
		If dbSeek(xFilial("SA3")+ALLTRIM(alEnvMail[n][1][1][5]))
			clVend4 := SA3->A3_EMAIL
		EndIf
		If dbSeek(xFilial("SA3")+ALLTRIM(alEnvMail[n][1][1][6]))
			clVend5 := SA3->A3_EMAIL
		EndIf
	
	
		If !Empty(clVend1).or.!Empty(clVend2).or.!Empty(clVend3).or.!Empty(clVend4).or.!Empty(clVend5)
			llRet := .T.
		EndIf
		
		If llRet
	
			Conout("Configurando Mensagem...")
			
			//Obtem dados necessarios a conexao.                                      ³
			
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
	
	
			//Apos a conexão, crio o objeto da mensagem
			oMessage := TMailMessage():New()
	
			//Limpo o objeto
			oMessage:Clear()
	
			// Alimento a variavel com o texto do e-mail 

			dbSelectArea("SA1")
			dbSetorder(1)
			dbGoTop()
			If dbSeek(xFilial("SA1")+PadR(ALLTRIM(alEnvMail[n][1][1][7]),TamSx3("A1_COD")[1])+Padr(ALLTRIM(alEnvMail[n][1][1][8])),TamSx3("A1_LOJA")[1])
				clNomeCli := SA1->A1_NOME
			EndIf
			
			cMensagem := "O pedido Numero "+ALLTRIM(alEnvMail[n][1][1][2])+" do cliente" + ALLTRIM(alEnvMail[n][1][1][7])+"-"+clNomeCli+"," +chr(13)+chr(10)
			cMensagem += "houve alteração nos itens com quantidade subalocados"+chr(13)+chr(10)
			cMensagem += "Produtos"+Space(7)+"Quantidade"+chr(13)+chr(10)
			
			For m := 1 to len(alEnvMail[n][2])
				cMensagem += alEnvMail[n][2][m][3]+Space(7)+alEnvMail[n][2][m][4]+chr(13)+chr(10)
			Next n

	
			//Populo com os dados de envio
			oMessage:cFrom		:= 	cMailConta
			oMessage:cTo		:=	clVend1+";"+clVend2+";"+clVend3+";"+clVend4+";"+clVend5
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
    Next n
	
Return llRet 
*/