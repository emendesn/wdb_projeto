#include "PROTHEUS.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATE50   ºAutor  ³Edilson Mendes      º Data ³  20/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verificar situação de crédito do Cliente                    º±±
±±º          ³(C9_BLCRED="" possui crédito/C9_BLCRED="01"ou"04" nao possuiº±±
±±º          ³Credito não liberado -email solicitando liberação de créditoº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ponto de Entrada MTA410T                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION RFATE50(_nOpcao, oProc, nAprov)

LOCAL nTotal   := 0
LOCAL nQtdLib  := 0
LOCAL _cC5_NUM

SetPrvt("OHTML,_lCreditOk,_lEstoq_Ok,_nOpcao")
SetPrvt("_cPedido,_cCliente,_aSCSemEst,_aOPSemEst,_lSemCredito,_cPedido")
SetPrvt("_nQtd,_cNumsc1,_cItemSc1,_csubject")
SetPrvt("wvlrtot")
SetPrvt("nCount,_user")
SetPrvt("cTO, cCC, cBCC, cSubject, cBody")

PRIVATE cEmlApr1 := "edilson.nascimento@wdbgroup.com.br"         //aprovador1
PRIVATE cEmlApr2 := "chacalwillis@yahoo.com.br"           //aprovador2
PRIVATE cAprov
PRIVATE nLimite1 := GetMV("MV_LIMITE1")
PRIVATE nLimite2 := GetMV("MV_LIMITE2")


	/*-----------------------------------------------------------------------------*
	* Inicializando rotina                                                        *
	*-----------------------------------------------------------------------------*/
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³cAprov = 0 - 1 aprovador                   ³
	//³cAprov = 1 - envia para o segundo aprovador|
	//³cAprov = 2 - Retornou do 2 aprovador       |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//verifica se precisa ter mais que uma aprovacao
	IF _nOpcao == 1
		IF oProc:oHtml:RetByName("Aprovacao") = "S"
			cAprov := oProc:oHtml:RetByName('cAprov')
			IF cAprov == "1"
				_nOpcao	:= 2
			ENDIF
		ENDIF
	ENDIF
	
	IF ISNIL( _nOpcao )
		
		_cPedido  := M->C5_NUM
		_cCliente := M->C5_CLIENTE
		
		//soma o total do pedido
		DBSelectArea("SC6")
		SC6->( DBSetOrder(1) )
		SC6->( DBSeek( xFilial() + _cPedido ) )
		WHILE SC6->( .NOT. EOF() ) .And. SC6->C6_NUM == _cPedido
			nTotal += SC6->C6_VALOR
			SC6->( DBSkip() )
		ENDDO
		
		//verifica se o valor e baixo e nao precisa de alcada
		IF nTotal < nLimite1
			RFATE50a(_cPedido)
		ELSE
			oProcess:=TWFProcess():New("000003","Alçada de Vendas")
			oProcess:NewTask('Inicio',"\workflow\HTM\RFATE50.htm")
			oHtml   := oProcess:oHtml
			
			DBSelectArea("SA1")              // Seleciona Cliente
			SA1->( DBSetOrder(1) )
			SA1->( DBSeek( xFilial("SA1") + SC5->C5_CLIENTE+ M->C5_LOJACLI ) )
			wa1_lc     := SA1->A1_LC         // Valor limite de credito
			wa1_venclc := SA1->A1_VENCLC     // Vencto limite de credito
			wa1_pricom := SA1->A1_PRICOM     // Data primeira compra
			wa1_ultcom := SA1->A1_ULTCOM     // Data ultima compra
			wa1_mcompra:= SA1->A1_MCOMPRA    // Valor da maior compra
			wa1_nrocom := SA1->A1_NROCOM     // Numero de compras realizadas
			wa1_saldup := SA1->A1_SALDUP     // Saldo de duplicatas em cliente
			wa1_salpedl:= SA1->A1_SALPEDL    // Saldo de pedidos liberados
			wa1_atr    := SA1->A1_ATR        // Valor dos atrasos
			wa1_matr   := SA1->A1_MATR       // Quantidade de dias de maior atraso
			wa1_vacum  := SA1->A1_VACUM      // Vendas no ano
			wa1_salped := SA1->A1_SALPED     // Saldo de pedidos
			wa1_titprot:= SA1->A1_TITPROT    // Qtde de titulos protestados
			wa1_dtultit:= SA1->A1_DTULTIT    // Data ultimo titulo protestado
			wa1_chqdevo:= SA1->A1_CHQDEVO    // Cheques devolvidos
			wa1_dtulchq:= SA1->A1_DTULCHQ    // Data do ultimo cheque devolvido
			wa1_maidupl:= SA1->A1_MAIDUPL    // Valor da Maior Duplicata
			
			aItens  := {}
			DBSelectArea("SC6")              // Seleciona SC6 - Itens de Pedidos de Venda
			SC6->( DBSetOrder(1) )
			SC6->( DBSeek( xFilial("SC6") + M->C5_NUM ) )
			WHILE SC6->( .NOT. EOF() ) .AND. SC5->C5_NUM = SC6->C6_NUM
				//grava o ID do workflow
				RecLock("SC6",.F.)
				SC6->C6_WFID := oProcess:fProcessID
				MsUnlock()
				
				AADD(aItens, { SC6->C6_ITEM            ,;   // 1 Numero do Item do Pedido
				               SC6->C6_PRODUTO         ,;   // 2 Codigo do Produto
				               ALLTRIM(SC6->C6_DESCRI) ,;   // 3 Descrição Auxiliar
				               SC6->C6_ENTREG          ,;   // 4 Data de Entrega
				               SC6->C6_UM              ,;   // 5 Unidade de Medida
				               SC6->C6_QTDVEN          ,;   // 6 Quantidade Vendida
				               SC6->C6_PRCVEN          ,;   // 7 Preco Unitario Liquido
				               SC6->C6_VALOR           })   // 8 Valor Total do Item
				SC6->( DBskip() )
			ENDDO
			
			DBSelectArea("SE4")              // Seleciona SE4 - Condicoes de Pagamento
			SE4->( DBSetOrder(1) )
			SE4->( DBSeek( xFilial("SE4") + M->C5_CONDPAG ) )
			
			DBSelectArea("SA3")             // Seleciona SA3 - Vendedores
			SA3->( DBSetOrder(1) )
			SA3->( DbSeek( xFilial("SA3") + M->C5_VEND1 ) )
			
			EnviaEmail()
		ENDIF
		
		
	ELSEIF _nOpcao == 1   // Retorno do email de Liberação de Crédito
		
		ConOut("Iniciando Retorno Alçada de Vendas. Credito")
		_cAprovar := oProc:oHtml:RetByName('Aprovacao')
		_cC5_NUM  := oProc:oHtml:RetByName('C5_NUM')         // Numero do P.V.
		_cCliente := oProc:oHtml:RetByName('C5_CLIENTE')     // Cliente
		_cC5_VEND1:= oProc:oHtml:RetByName('C5_VEND1')       // Codigo do Vendedor no P.V.
		cObs      := oProc:oHtml:RetByName('obs')            // observacao da rejeicao
		
		IF oProc:oHtml:RetByName("Aprovacao") = "S"
			
			//faz liberacao do pedido
			RFATE50a(_cC5_NUM)
			
			//RastreiaWF( ID do Processo, Codigo do Processo, Codigo do Status, Descricao Especifica, Usuario )
			RastreiaWF(oProc:fProcessID+'.'+oProc:fTaskID,"000003",'1004',"Email retornado da liberação1",cUsername)
			
			
		ELSE             // Enviar e-mail para vendedor avisando da não aprovação do crédito
			
			DBSelectArea("SA3")    // Seleciona SA3 - Vendedores
			SA3->( DBSetOrder(1) )
			SA3->( DBSeek( xFilial("SA3") + _cC5_VEND1 ) )
			email  := "pbindo@cis.com.br"//if(empty(SA3->A3_EMAIL), email, SA3->A3_EMAIL)
			
			Reprovar_Credito(_cC5_NUM, _cCliente, cObs)
		ENDIF
		
	ELSEIF _nOpcao == 2 //envia para o segundo aprovador apos primeiro aprovador ter aprovado
		
		//finaliza o processo anterior
		//RastreiaWF( ID do Processo, Codigo do Processo, Codigo do Status, Descricao Especifica, Usuario )
		RastreiaWF(oProc:fProcessID+'.'+oProc:fTaskID,"000003",'1004',"Email retornado da liberação1",cUsername)
		
		DBSelectArea("SC5")
		SC5->( DBSetOrder(1) )
		SC5->( DBSeek( xFilial("SC5") + oProc:oHtml:RetByName("c5_num")) )
		
		DBSelectArea("SA1")              // Seleciona Cliente
		SA1->( DBSetOrder(1) )
		SA1->( DBSeek( xFilial("SA1") + oProc:oHtml:RetByName("c5_cliente") ) )
		
		DBSelectArea("SE4")              // Seleciona SE4 - Condicoes de Pagamento
		SE4->( DBSetOrder(1) )
		SE4->( DBSeek( xFilial("SE4") +oProc:oHtml:RetByName("c5_condpag") ) )
		
		DBSelectArea("SA3")             // Seleciona SA3 - Vendedores
		SA3->( DBSetOrder(1) )
		SA3->( DBSeek( xFilial("SA3") + oProc:oHtml:RetByName("c5_vend1"  ) ) )
		
		wa1_lc     := oProc:oHtml:RetByName("a1_lc"     )
		wa1_saldup := oProc:oHtml:RetByName("a1_saldup" )
		wa1_salpedl:= oProc:oHtml:RetByName("a1_salpedl")
		wa1_salped := oProc:oHtml:RetByName("a1_salped" )
		wa1_pricom := oProc:oHtml:RetByName("a1_pricom" )
		wa1_nrocom := oProc:oHtml:RetByName("a1_nrocom" )
		wa1_dtultit:= oProc:oHtml:RetByName("a1_dtultit")
		wa1_titprot:= oProc:oHtml:RetByName("a1_titprot")
		wa1_chqdevo:= oProc:oHtml:RetByName("a1_chqdevo")
		wa1_mcompra:= oProc:oHtml:RetByName("a1_mcompra")
		wa1_maidupl:= oProc:oHtml:RetByName("a1_maidupl")
		wa1_atr    := oProc:oHtml:RetByName("a1_atr"    )
		wa1_venclc := oProc:oHtml:RetByName("a1_venclc" )
		wa1_matr   := oProc:oHtml:RetByName("a1_matr"   )
		wa1_ultcom := oProc:oHtml:RetByName("a1_ultcom" )
		wa1_vacum  := oProc:oHtml:RetByName("a1_vacum"  )
		wa1_dtulchq:= oProc:oHtml:RetByName("a1_dtulchq")
		
		aItens  := {}
		DBSelectArea("SC6")              // Seleciona SC6 - Itens de Pedidos de Venda
		SC6->( DBSetOrder(1) )
		SC6->( DBSeek( xFilial("SC6") + oProc:oHtml:RetByName("c5_num") ) )
		WHILE SC6->( .NOT. EOF() ) .AND. SC5->C5_NUM = SC6->C6_NUM
			AADD( aItens, { SC6->C6_ITEM            ,;   // 1 Numero do Item do Pedido
				            SC6->C6_PRODUTO         ,;   // 2 Codigo do Produto
				            ALLTRIM(SC6->C6_DESCRI) ,;   // 3 Descrição Auxiliar
				            SC6->C6_ENTREG          ,;   // 4 Data de Entrega
				            SC6->C6_UM              ,;   // 5 Unidade de Medida
				            SC6->C6_QTDVEN          ,;   // 6 Quantidade Vendida
				            SC6->C6_PRCVEN          ,;   // 7 Preco Unitario Liquido
				            SC6->C6_VALOR           })   // 8 Valor Total do Item
			SC6->( DBskip() )
		ENDDO
		
		//gera novo processo
		oProcess:=TWFProcess():New("000003","Crédito Não Liberado")
		oProcess:NewTask('Inicio',"\workflow\HTM\RFATE50.htm")
		oHtml   := oProcess:oHtml
		
		EnviaEmail()
		
	ENDIF
		
RETURN



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATE50   ºAutor  ³Edilson Mendes      º Data ³  20/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia e-mail para os aprovadores                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION EnviaEmail()

LOCAL nCount

	wvlrtot := 0
	
	DBSelectArea("SC5")
	//RecLock("SC5")
	//SC5->C5_WFID := "000003"
	//MsUnlock()
	
	oHtml:valbyname("c5_num"    , SC5->C5_NUM)
	oHtml:valbyname("c5_cliente", SC5->C5_CLIENTE)
	oHtml:valbyname("a1_nome"   , SA1->A1_NOME)
	oHtml:valbyname("a1_end"    , SA1->A1_END)
	oHtml:valbyname("a1_mun"    , SA1->A1_MUN)
	oHtml:valbyname("a1_est"    , SA1->A1_EST)
	oHtml:valbyname("a1_cgc"    , SA1->A1_CGC)
	oHtml:valbyname("a1_inscr"  , SA1->A1_INSCR)
	oHtml:valbyname("a1_inscrm" , SA1->A1_INSCRM)
	oHtml:valbyname("c5_condpag", trim(SC5->C5_CONDPAG))
	oHtml:valbyname("e4_descri" , trim(SE4->E4_DESCRI))
	oHtml:valbyname("c5_vend1"  , SC5->C5_VEND1)
	oHtml:valbyname("a3_nome"   , SA3->A3_NOME)
	
	FOR nCount := 1 TO LEN(aItens)
		AADD(oHtml:valbyname("it.it")     , aItens[nCount,1])
		AADD(oHtml:valbyname("it.codprod"), aItens[nCount,2])
		AADD(oHtml:valbyname("it.desc")   , aItens[nCount,3])
		AADD(oHtml:valbyname("it.prev")   , aItens[nCount,4])
		AADD(oHtml:valbyname("it.um")     , aItens[nCount,5])
		AADD(oHtml:valbyname("it.qtd")    , TRANSFORM( aItens[nCount,6] ,'@E 9999,999.99' ))
		AADD(oHtml:valbyname("it.vlruni") , TRANSFORM( aItens[nCount,7] ,'@E 9999,999.99' ))
		AADD(oHtml:valbyname("it.vlrtot") , TRANSFORM( aItens[nCount,8] ,'@E 9999,999.99' ))
		wvlrtot += (aItens[nCount,6]*aItens[nCount,7])
	NEXT
	
	oHtml:valbyname("vlrtot"    ,TRANSFORM(wvlrtot    ,'@E 9999,999.99'))
	oHtml:valbyname("a1_lc"     ,TRANSFORM(wa1_lc     ,'@E 9999,999.99'))
	oHtml:valbyname("a1_saldup" ,TRANSFORM(wa1_saldup ,'@E 9999,999.99'))
	oHtml:valbyname("a1_salpedl",TRANSFORM(wa1_salpedl,'@E 9999,999.99'))
	wvlrsaldo := wa1_lc - wa1_saldup
	oHtml:valbyname("a1_sallim" ,TRANSFORM(wvlrsaldo  ,'@E 9999,999.99'))
	oHtml:valbyname("a1_pedatu" ,TRANSFORM(wvlrtot    ,'@E 9999,999.99'))
	oHtml:valbyname("a1_salped" ,TRANSFORM(wa1_salped ,'@E 9999,999.99'))
	oHtml:valbyname("a1_pricom" ,wa1_pricom)
	oHtml:valbyname("a1_nrocom" ,TRANSFORM(wa1_nrocom ,'@E 9999,999.99'))
	oHtml:valbyname("a1_dtultit",wa1_dtultit)
	oHtml:valbyname("a1_titprot",TRANSFORM(wa1_titprot,'@E 9999,999.99'))
	oHtml:valbyname("a1_chqdevo",TRANSFORM(wa1_chqdevo,'@E 9999,999.99'))
	oHtml:valbyname("a1_mcompra",TRANSFORM(wa1_mcompra,'@E 9999,999.99'))
	oHtml:valbyname("a1_maidupl",TRANSFORM(wa1_maidupl,'@E 9999,999.99'))
	oHtml:valbyname("a1_atr"    ,TRANSFORM(wa1_atr    ,'@E 9999,999.99'))
	oHtml:valbyname("a1_venclc" ,wa1_venclc)
	oHtml:valbyname("a1_matr"   ,wa1_matr )
	oHtml:valbyname("a1_ultcom" ,wa1_ultcom)
	oHtml:valbyname("a1_vacum"  ,TRANSFORM(wa1_vacum  ,'@E 9999,999.99'))
	oHtml:valbyname("a1_dtulchq",wa1_dtulchq)
	
	//faz a verificacao de quantos aprovadores serao necessarios
	IF cAprov # "1"
		cAprov := "0"
		IF wvlrtot >= nLimite2
			cAprov := "1"
		ENDIF
	ELSE
		cAprov := "2"
	ENDIF
	oHtml:valbyname("cAprov",cAprov)
	
	_user := Subs(cUsuario,7,15)
	oProcess:ClientName(_user)
	IF cAprov $ "0|1"
		oProcess:cTo      := cEmlApr1
	ELSE
		oProcess:cTo      := cEmlApr2
	ENDIF
	oProcess:cBCC     := ''
	oProcess:cSubject := "Solicitação de Crédito - Cliente " + SC5->C5_CLIENTE + "  " + SA1->A1_NOME
	oProcess:cBody    := ""
	oProcess:bReturn  := "U_RFATE50(1)"
	
	oProcess:Start()
	//RastreiaWF( ID do Processo, Codigo do Processo, Codigo do Status, Descricao Especifica, Usuario )
	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000003",'1003',"Email Enviado Para liberação1 de Crédito",cUsername)
	oProcess:Free()
	oProcess:= Nil
	
	WFSendMail()
	
RETURN( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Reprovar_Credito  ºAutor³Edilson Mendesº Data ³  20/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia e-mail para o vendedor avisando a reprovacao          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION Reprovar_Credito(_cC5_NUM, _cCliente,cObs)

LOCAL lResult   := .f.				// Resultado da tentativa de comunicacao com servidor de E-Mail
LOCAL cTitulo1
LOCAL lRelauth 	:= GetNewPar("MV_RELAUTH",.F.)		// Parametro que indica se existe autenticacao no e-mail
LOCAL cEmailTo
LOCAL cEmailBcc	:= ""
LOCAL cError   	:= ""
LOCAL lRelauth 	:= GetNewPar("MV_RELAUTH",.F.)		// Parametro que indica se existe autenticacao no e-mail
LOCAL lRet	   	:= .F.
LOCAL cFrom	   	:= GetMV("MV_RELACNT")
LOCAL cConta   	:= GetMV("MV_RELACNT")
LOCAL cSenha   	:= GetMV("MV_RELPSW")
LOCAL cMensagem


	cEmailTo := Email
	cTitulo1 := "Rejeição de Pedido"+_cC5_NUM
	cCli     := Posicione("SA1",1,xFilial("SA1")+_cCliente,"A1_NOME")
	
	cMensagem := cCli+"("+_cCliente+")"+CHR(13)+CHR(10)
	cMensagem += CHR(13)+CHR(10)
	cMensagem += "O Pedido: "+_cC5_NUM+" foi rejeitado pelo motivo:"+CHR(13)+CHR(10)
	cMensagem += cObs
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tenta conexao com o servidor de E-Mail ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CONNECT SMTP                        ;
	        SERVER   GetMV("MV_RELSERV"); 	// Nome do servidor de e-mail
	        ACCOUNT  GetMV("MV_RELACNT"); 	// Nome da conta a ser usada no e-mail
	        PASSWORD GetMV("MV_RELPSW") ; 	// Senha
	        RESULT   lResult             	// Resultado da tentativa de conexão
	
	// Se a conexao com o SMPT esta ok
	IF lResult
		
		// Se existe autenticacao para envio valida pela funcao MAILAUTH
		IF lRelauth
			lRet := Mailauth(cConta,cSenha)
		ELSE
			lRet := .T.
		ENDIF
		
		IF lRet
			SEND MAIL FROM 	  cFrom ;
			          TO      cEmailTo;
			          BCC     cEmailBcc;
			          SUBJECT cTitulo1;
			          BODY    cMensagem;
			          RESULT  lResult
			
			IF .NOT. lResult
				//Erro no envio do email
				GET MAIL ERROR cError
				Help(" ",1,"ATENCAO",,cError+ " " + cEmailTo,4,5)	//STR0006
			ENDIF
			
		ELSE
			GET MAIL ERROR cError
			Help(" ",1,"Autenticacao",,cError,4,5)
			MsgStop("Erro de autenticação","Verifique a conta e a senha para envio")
		ENDIF
		
		DISCONNECT SMTP SERVER
	ELSE
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		Help(" ",1,"Atencao",,cError,4,5)
	ENDIF
	
RETURN( Nil )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATE50a  ºAutor  ³Edilson Mendes      º Data ³  20/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Libera pedido                                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION RFATE50a(_cC5_NUM)

	DBSelectArea("SC5")
	SC5->( DBSetOrder(1) )
	SC5->( MsSeek( xFilial("SC5") + _cC5_NUM ) )
	
	DBSelectArea("SC6")
	SC6->( DBSetOrder(1) )
	SC6->( MsSeek( xFilial("SC6") + _cC5_NUM ) )
	
	WHILE SC6->( .NOT. EOF() ) .And. SC6->C6_NUM == _cC5_NUM
		IF RecLock("SC5")
			nQtdLib  := ( SC6->C6_QTDVEN - ( SC6->C6_QTDEMP + SC6->C6_QTDENT ) )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Recalcula a Quantidade Liberada                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RecLock("SC6") //Forca a atualizacao do Buffer no Top
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Libera por Item de Pedido                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Begin Transaction
				/*
				±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
				±±³Funcao    ³MaLibDoFat³ Autor ³Eduardo Riera          ³ Data ³09.03.99  ³±±
				±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
				±±³Descri‡…o ³Liberacao dos Itens de Pedido de Venda                      ³±±
				±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
				±±³Retorno   ³ExpN1: Quantidade Liberada                                  ³±±
				±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
				±±³Transacao ³Nao possui controle de Transacao a rotina chamadora deve    ³±±
				±±³          ³controlar a Transacao e os Locks                            ³±±
				±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
				±±³Parametros³ExpN1: Registro do SC6                                      ³±±
				±±³          ³ExpN2: Quantidade a Liberar                                 ³±±
				±±³          ³ExpL3: Bloqueio de Credito                                  ³±±
				±±³          ³ExpL4: Bloqueio de Estoque                                  ³±±
				±±³          ³ExpL5: Avaliacao de Credito                                 ³±±
				±±³          ³ExpL6: Avaliacao de Estoque                                 ³±±
				±±³          ³ExpL7: Permite Liberacao Parcial                            ³±±
				±±³          ³ExpL8: Tranfere Locais automaticamente                      ³±±
				±±³          ³ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao ³±±
				±±³          ³       apenas avalia ).                                     ³±±
				±±³          ³ExpbA: CodBlock a ser avaliado na gravacao do SC9           ³±±
				±±³          ³ExpAB: Array com Empenhos previamente escolhidos            ³±±
				±±³          ³       (impede selecao dos empenhos pelas rotinas)          ³±±
				±±³          ³ExpLC: Indica se apenas esta trocando lotes do SC9          ³±±
				±±³          ³ExpND: Valor a ser adicionado ao limite de credito          ³±±
				±±³          ³ExpNE: Quantidade a Liberar - segunda UM                    ³±±
				*/
				MaLibDoFat(SC6->(RecNo()),@nQtdLib,.F.,.F.,.T.,.T.,.F.,.F.)
			End Transaction
		ENDIF
		SC6->(MsUnLock())
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza o Flag do Pedido de Venda                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Begin Transaction
			SC6->(MaLiberOk({_cC5_NUM},.F.))
		End Transaction
		
		SC6->( DBSkip() )
	ENDDO
	
	SC6->(DBCloseArea())
	
RETURN( Nil )
