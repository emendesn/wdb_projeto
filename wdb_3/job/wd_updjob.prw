#INCLUDE "Protheus.ch"

#DEFINE X3_USADO_EMUSO    "€€€€€€€€€€€€€€ "
#DEFINE X3_USADO_NAOUSADO "€€€€€€€€€€€€€€€"   
#DEFINE X3_OBRIGAT        "Á€" 
#DEFINE X3_RESER          "þÀ"  
#DEFINE X3_RESER_NUMERICO "øÇ" 
#DEFINE X3_RES	          "€€"   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ UpdAGENDAº Autor ³ Edilson Mendes     º Data ³  11/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Criacao / Atualizacao das tabelas da Agenda de JOBs da WD  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Cliente WDB                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER FUNCTION UpdAGENDA()

cArqEmp     := "SigaMat.Emp"
nModulo		:= 44
__cInterNet := Nil
      	
PRIVATE cMessage
PRIVATE aArqUpd	 		:= {}
PRIVATE aReOpen	 		:= {}
PRIVATE oMainWnd 
PRIVATE lMsFinalAuto 	:= .F.
PRIVATE lOpen			:=	.F.

	Set Dele On
	
	lHistorico 	:= MsgYesNo("Deseja efetuar a atualizacao do Dicionario de Dados para Agenda de JOBs - WDB? Esta rotina deve ser utilizada em modo exclusivo ! Faca um backup dos dicionarios e da Base de Dados antes da atualizacao para eventuais falhas de atualizacao !", "Atenção")
	lEmpenho	:= .F.
	lAtuMnu		:= .F.
	
	DEFINE WINDOW oMainWnd FROM 0,0 TO 01,30 TITLE "Atualizacao da Agenda de JOBs - WDB"
	ACTIVATE WINDOW oMainWnd ;
	         ON INIT If(lHistorico,(Processa({|lEnd| MSAProc(@lEnd,@lOpen)},"Processando","Aguarde, processando preparacao das Tabelas",.F.) ,If(lOpen,Final("Atualizacao efetuada!"),oMainWnd:End())),oMainWnd:End())
	
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MSAProc   ³ Autor ³ Murilo Swistalski     ³ Data ³17/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao dos arquivos           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION MSAProc(lEnd,lOpen)

LOCAL cTexto    := ''
LOCAL cFile     :=""
LOCAL cMask     := "Arquivos Texto (*.TXT) |*.txt|"
LOCAL cCodigo   := "DM"
LOCAL nRecno    := 0
LOCAL nPos
LOCAL nCount
LOCAL aRecnoSM0 := {}     


	ProcRegua(1)
	IncProc("Verificando integridade dos dicionarios....")
	
	IF MyOpenSm0Ex()
		
		DBSelectArea("SM0")
		SM0->( DBGotop() )
		While SM0->( .NOT. EOF() )
			AADD( aRecnoSM0, SM0->( RECNO() ) )
			SM0->( DBSkip() )
		EndDo
		
		FOR nPos := 1 TO LEN( aRecnoSM0 )
			SM0->( DBGoto( aRecnoSM0[nPos] ) )
			RpcSetType(3) //RpcSetType(2)
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
			RpcClearEnv()
			IF .NOT. ( lOpen := MyOpenSm0Ex() )
				Exit
			ENDIF
		NEXT
		
		IF lOpen
			FOR nPos := 1 TO LEN( aRecnoSM0 )
				SM0->( DBGoto( aRecnoSM0[nPos] ) )
				RpcSetType(2)
				RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL)
				cTexto += REPLICATE( "-", 128 ) + CHR(13) + CHR(10)
				cTexto += "Empresa : " + SM0->M0_CODIGO + SM0->M0_NOME+CHR(13)+CHR(10)
				
				ProcRegua(8)
				//			cTexto += MSAAtuSX1() //Atualiza as perguntes de relatorios
				cTexto += MSAAtuSX2() //Atualiza o dicionario de arquivos
				//			cTexto += MSAAtuSIX() //Atualiza indices
				cTexto += MSAAtuSX3() //Atualiza o dicionario de dados
				//			MSAAtuSX5() //Atualiza tabelas genericas
				//			cTexto += MSAAtuSX6() //Atualiza os parametros
				//			MSAAtuSX7() //Atualiza os gatilhos
				//			MSAAtuSXA() //Atualiza os folder's de cadastro
				//			cTexto += MSAAtuSXB() //Atualiza as consultas padroes
				
				__SetX31Mode(.F.)
				FOR nCount := 1 TO LEN(aArqUpd)
					IncProc("Atualizando estruturas. Aguarde... ["+aArqUpd[nCount]+"]")
					IF SELECT( aArqUpd[nCount] ) > 0
						DBSelecTArea( aArqUpd[nCount] )
						DBCloseArea()
					ENDIF
					X31UpdTable(aArqUpd[nCount])
					IF __GetX31Error()
						Alert(__GetX31Trace())
						Aviso("Atencao!","Ocorreu um erro desconhecido durante a atualizacao da tabela : "+ aArqUpd[nCount] + ". Verifique a integridade do dicionario e da tabela.",{"Continuar"},2)
						cTexto += "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "+aArqUpd[nCount] +CHR(13)+CHR(10)
					ENDIF
				NEXT
				
				RpcClearEnv()
				IF .NOT. ( lOpen := MyOpenSm0Ex() )
					Exit
				ENDIF
			NEXT
			
			IF lOpen
				cTexto     := "Log da atualizacao " + CHR(13) + CHR(10) + cTexto
				__cFileLog := MemoWrite( Criatrab(,.f.) + ".LOG", cTexto)
				DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
				DEFINE MSDIALOG oDlg TITLE "Atualizacao concluida." From 3,0 to 340,417 PIXEL
				@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
				oMemo:bRClicked := {||AllwaysTrue()}
				oMemo:oFont     := oFont
				DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
				DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."
				ACTIVATE MSDIALOG oDlg CENTER
			ENDIF
		ENDIF
	ENDIF
	
RETURN( .T. )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MyOpenSM0Ex³ Autor ³Murilo Swistalski     ³ Data ³17/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a abertura do SM0 exclusivo                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION MyOpenSM0Ex()
                  
LOCAL nLoop := 0 

	FOR nLoop := 1 TO 20
		DBUseArea( .T.,, "SIGAMAT.EMP", "SM0", .F., .F. )
		IF .NOT. EMPTY( SELECT( "SM0" ) )
			lOpen := .T.
			DBSetIndex("SIGAMAT.IND")
			EXIT
		EndIf
		Sleep( 500 )
	NEXT
	
	IF !lOpen
		Aviso( "Atencao !", "Nao foi possivel a abertura da tabela de empresas de forma exclusiva !", { "Ok" }, 2 )
	ENDIF
	
RETURN( lOpen ) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MSAAtuSX2 ³ Autor ³Murilo Swistalski      ³ Data ³18/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX2                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION MSAAtuSX2()

LOCAL aSX2    := {}
LOCAL aEstrut := {}
LOCAL nPos
LOCAL nCount
LOCAL cTexto  := ''
LOCAL lSX2	  := .F.
LOCAL cAlias  := ''
LOCAL cPath
LOCAL cNome


	aEstrut:= {"X2_CHAVE","X2_PATH","X2_ARQUIVO","X2_NOME","X2_NOMESPA","X2_NOMEENG","X2_DELET","X2_MODO","X2_TTS","X2_ROTINA","X2_DISPLAY"}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tabela SZ1 - Cadastro de JOBs                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aSX2,{"SZ1","","","Cadastro de JOBs","Cadastro de JOBs","Cadastro de JOBs",0,"C","","","Z1_CODJOB+Z1_EVENTO"})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tabela SZ2 - Cadastro de Agendas                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aSX2,{"SZ2","","","Cadastro de Agendas","Cadastro de Agendas","Cadastro de Agendas",0,"C","","","Z2_CODJOB+Z2_AGENDA+Z2_VERSAO"})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tabela SZ3 - Reservas de Produtos para a Agenda       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aSX2,{"SZ3","","","Cadastro de Reservas para Agenda de JOBs","Cadastro de Reservas para Agenda de JOBs","Cadastro de Reservas para Agenda de JOBs",0,"C","","","Z3_RESERVA+Z3_PROD"})
	
	
	ProcRegua( LEN(aSX2))
	
	DBSelectArea("SX2")
	SX2->( DBSetOrder(1) )
	SX2->( DBSeek("AF8") )
	cPath := SX2->X2_PATH
	cNome := cEmpAnt + "0"
	
	FOR nPos := 1 TO LEN( aSX2 )
		IF .NOT. EMPTY( aSX2[nPos][1] )
			IF .NOT. DBSeek( aSX2[nPos,1] )
				lSX2 := .T.
				IF .NOT. ( aSX2[nPos,1] $ cAlias )
					cAlias += aSX2[ nPos,1]+"/"
				ENDIF
				RecLock("SX2",.T.)
				FOR nCount := 1 TO LEN( aSX2[nPos] )
					IF FieldPos( aEstrut[nCount] ) > 0
						FieldPut( FieldPos( aEstrut[nCount] ), aSX2[nPos,nCount])
					ENDIF
				NEXT
				SX2->X2_PATH    := cPath
				SX2->X2_ARQUIVO := aSX2[nPos,1]+cNome
				dbCommit()
				MsUnLock()
				IncProc("Atualizando Dicionario para Agenda...")
			ENDIF
		ENDIF
	NEXT
	
RETURN cTexto


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MSAAtuSX3 ³ Autor ³Murilo Swistalski      ³ Data ³18/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX3                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION MSAAtuSX3()

LOCAL aSX3      := {}
LOCAL cTitulo   :=""
LOCAL cDescr    :=""
LOCAL aPHelpPor	:={}
LOCAL aPHelpEng	:={}
LOCAL aPHelpSpa	:={}
LOCAL nPos
LOCAL nCount
LOCAL lSX3	    := .F.
LOCAL cTexto    := ''
LOCAL cAlias    := ''
LOCAL cOrdem    := ""
LOCAL cfolder   := ""
//Estrutura para gravacao dos itens no SX3
LOCAL aEstrut   := { "X3_ARQUIVO","X3_ORDEM"  ,"X3_CAMPO"  ,;
                     "X3_TIPO"   ,"X3_TAMANHO","X3_DECIMAL",;
                     "X3_TITULO" ,"X3_TITSPA" ,"X3_TITENG" ,;
                     "X3_DESCRIC","X3_DESCSPA","X3_DESCENG",;
                     "X3_PICTURE","X3_VALID"  ,"X3_USADO"  ,;
                     "X3_RELACAO","X3_F3"     ,"X3_NIVEL"  ,;
                     "X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER",;
                     "X3_PROPRI" ,"X3_BROWSE" ,"X3_VISUAL" ,;
                     "X3_CONTEXT","X3_OBRIGAT","X3_VLDUSER",;
                     "X3_CBOX"   ,"X3_CBOXSPA","X3_CBOXENG",;
                     "X3_PICTVAR","X3_WHEN"   ,"X3_INIBRW" ,;
                     "X3_GRPSXG" ,"X3_FOLDER" ,"X3_PYME"}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posicoes a serem consideradas na definicao dos campos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// Titulo 		= 12 caracteres
	// Descricao 	= 25 caracteres
	// Help			= 40 caracteres por linha de help
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Os campos sao criados apenas para o Brasil.                      ³
	//³Caso algum campo seja utilizado em novos indices, sera necessario³
	//³criar os campos do processo em todos os paises.                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (cPaisLoc <> "BRA")
		Return
	EndIf
	
	cFolder := ""
	cOrdem  := ""
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Alteracoes da tabela SZ1 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//CAMPO Z1_FILIAL
	IF .NOT. SX3->( DBSetOrder(2), DBSeek("Z1_FILIAL") ) //se nao existir, cadastrar
		cTitulo:="Filial"
		cDescr :="Filial do Sistema"
		//			  1234567890123456789012345
		//	                     x            x
		AADD( aSX3,{"SZ1",cOrdem,"Z1_FILIAL","C",2,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@!",;
		"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
		//                   1234567890123456789012345678901234567890
		aPHelpPor := {""}
		aPHelpEng := aPHelpSpa := aPHelpPor
		PutHelp("PZ1_FILIAL",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	ENDIF
	
	//CAMPO Z1_CODJOB
	IF .NOT. SX3->( DBSeek("Z1_CODJOB")) //se nao existir, cadastrar
		cTitulo:="Cod.Job"
		cDescr :="Codigo do JOB"
		//			  1234567890123456789012345
		//	                     x            x
		AADD(aSX3,{"SZ1",cOrdem,"Z1_CODJOB","N",9,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@E 999999999",;
		"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
		//                   1234567890123456789012345678901234567890
		aPHelpPor 	:= {"Código do JOB a ser utilizado para ",;
		"o Agendamento.                     "}
		aPHelpEng := aPHelpSpa := aPHelpPor
		PutHelp("PZ1_CODJOB",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	ENDIF
	
	//CAMPO Z1_EVENTO
	If .NOT. SX3->(DBSeek("Z1_EVENTO")) //se nao existir, cadastrar
		cTitulo :="Evento"
		cDescr  :="Evento do JOB"
		//			  1234567890123456789012345
		//	                     x            x
		AADD(aSX3,{"SZ1",cOrdem,"Z1_EVENTO","C",30,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@!",;
		"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
		//                   1234567890123456789012345678901234567890
		aPHelpPor 	:= {"Nome do Evento do JOB"}
		aPHelpEng 	:= 	aPHelpSpa	:=	aPHelpPor
		PutHelp("PZ1_EVENTO",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	ENDIF
	
	//CAMPO Z1_LOCAL
	If .NOT. SX3->(DBSeek("Z1_LOCAL")) //se nao existir, cadastrar
		cTitulo :="Local"
		cDescr  :="Local do Evento do JOB"
		//			  1234567890123456789012345
		//	                     x            x
		AADD(aSX3,{"SZ1",cOrdem,"Z1_LOCAL","C",30,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@!",;
		"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
		//                   1234567890123456789012345678901234567890
		aPHelpPor 	:= {"Local que ocorrerá o evento do JOB"}
		aPHelpEng 	:= 	aPHelpSpa	:=	aPHelpPor
		PutHelp("PZ1_LOCAL",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	ENDIF
	
	//CAMPO Z1_DESCR
	IF .NOT. SX3->(DBSeek("Z1_DESCR")) //se nao existir, cadastrar
		cTitulo := "Descricao"
		cDescr  := "Descricao Resumida do JOB"
		//			  1234567890123456789012345
		//	                     x            x
		AADD(aSX3,{"SZ1",cOrdem,"Z1_DESCR","C",255,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@!",;
		"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
		//                   1234567890123456789012345678901234567890
		aPHelpPor 	:= {"Informe aqui um resumo descritivo  ",;
		"sobre o JOB"}
		aPHelpEng 	:= 	aPHelpSpa	:=	aPHelpPor
		PutHelp("PZ1_DESCR",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	ENDIF
	
	//CAMPO Z1_CLIENTE
	IF .NOT. SX3->(DBSeek("Z1_CLIENTE")) //se nao existir, cadastrar
		cTitulo := "Cod. Cliente"
		cDescr  := "Codigo do Cliente"
		//			  1234567890123456789012345
		//	                     x            x
		AADD(aSX3,{"SZ1",cOrdem,"Z1_CLIENTE","C",6,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@!",;
		"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
		//                   1234567890123456789012345678901234567890
		aPHelpPor := {"Código do Cliente do Evento"}
		aPHelpEng := aPHelpSpa := aPHelpPor
		PutHelp("PZ1_CLIENTE",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	ENDIF
	
	//CAMPO Z1_LOJA
	IF .NOT. SX3->(DBSeek("Z1_LOJA")) //se nao existir, cadastrar
		cTitulo:="Loja Cliente"
		cDescr :="Loja do Cliente"
		//			  1234567890123456789012345
		//	                     x            x
		AADD(aSX3,{"SZ1",cOrdem,"Z1_LOJA","C",2,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@!",;
		"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
		//                   1234567890123456789012345678901234567890
		aPHelpPor 	:= {"Numero da Loja do Cliente"}
		aPHelpEng 	:= 	aPHelpSpa	:=	aPHelpPor
		PutHelp("PZ1_LOJA",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	ENDIF
	
	//CAMPO Z1_DTINI
	IF .NOT. SX3->(DBSeek("Z1_DTINI")) //se nao existir, cadastrar
		cTitulo:="Data Inicial"
		cDescr :="Data do Inicio do JOB"
		//			  1234567890123456789012345
		//	                     x            x
		AADD(aSX3,{"SZ1",cOrdem,"Z1_DTINI","D",8,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@!",;
		"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
		//                   1234567890123456789012345678901234567890
		aPHelpPor 	:= {"Data do Inicio do JOB"}
		aPHelpEng 	:= 	aPHelpSpa	:=	aPHelpPor
		PutHelp("PZ1_DTINI",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	ENDIF
	
	//CAMPO Z1_DTINI
	If .NOT. SX3->(DBSeek("Z1_DTFIM")) //se nao existir, cadastrar
		cTitulo:="Data Final"
		cDescr :="Data do Termino do JOB"
		//			  1234567890123456789012345
		//	                     x            x
		AADD(aSX3,{"SZ1",cOrdem,"Z1_DTFIM","D",8,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@!",;
		"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
		//                   1234567890123456789012345678901234567890
		aPHelpPor 	:= {"Data do Termino do JOB"}
		aPHelpEng 	:= 	aPHelpSpa	:=	aPHelpPor
		PutHelp("PZ1_DTFIM",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	ENDIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Alteracoes da tabela SZ2 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//CAMPO Z2_FILIAL
	If .NOT. SX3->(DBSeek("Z2_FILIAL")) //se nao existir, cadastrar
		cTitulo:="Filial"
		cDescr :="Filial do Sistema"
		//			  1234567890123456789012345
		//	                     x            x
		AADD(aSX3,{"SZ2",cOrdem,"Z2_FILIAL","C",2,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@!",;
		"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
		//                   1234567890123456789012345678901234567890
		aPHelpPor 	:= {""}
		aPHelpEng 	:= 	aPHelpSpa	:=	aPHelpPor
		PutHelp("PZ2_FILIAL",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	ENDIF
	
	//CAMPO Z2_CODJOB
	IF .NOT. SX3->(DBSeek("Z2_CODJOB")) //se nao existir, cadastrar
		cTitulo:="Cod.Job"
		cDescr :="Codigo do JOB"
		//			  1234567890123456789012345
		//	                     x            x
		AADD(aSX3,{"SZ2",cOrdem,"Z2_CODJOB","N",9,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@E 999999999",;
		"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
		//                   1234567890123456789012345678901234567890
		aPHelpPor 	:= {"Código do JOB a ser utilizado para ",;
		"o Agendamento.                     "}
		aPHelpEng 	:= 	aPHelpSpa	:=	aPHelpPor
		PutHelp("PZ2_CODJOB",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	ENDIF
	
	//CAMPO Z2_AGENDA
	IF .NOT. SX3->(DBSeek("Z2_AGENDA")) //se nao existir, cadastrar
		cTitulo:="Num. Agenda"
		cDescr :="Numero da Agenda"
		//			  1234567890123456789012345
		//	                     x            x
		AADD(aSX3,{"SZ2",cOrdem,"Z2_AGENDA","N",9,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@E 999999999",;
		"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
		//                   1234567890123456789012345678901234567890
		aPHelpPor 	:= {"Numero da Agenda"}
		aPHelpEng 	:= 	aPHelpSpa	:=	aPHelpPor
		PutHelp("PZ2_AGENDA",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	EndIf
	
	//CAMPO Z2_VERSAO
	IF .NOT.SX3->(DBSeek("Z2_VERSAO")) //se nao existir, cadastrar
		cTitulo:="Versao"
		cDescr :="Controle da Versao"
		//			  1234567890123456789012345
		//	                     x            x
		AADD(aSX3,{"SZ2",cOrdem,"Z2_VERSAO","N",5,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@E 99999",;
		"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
		//                   1234567890123456789012345678901234567890
		aPHelpPor 	:= {"Controle de Versão da Agenda"}
		aPHelpEng 	:= 	aPHelpSpa	:=	aPHelpPor
		PutHelp("PZ2_VERSAO",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	ENDIF
	
	//CAMPO Z2_RESERVA
	IF .NOT. SX3->(DBSeek("Z2_RESERVA")) //se nao existir, cadastrar
		cTitulo:="Reserva"
		cDescr :="Reserva por Agenda"
		//			  1234567890123456789012345
		//	                     x            x
		AADD(aSX3,{"SZ2",cOrdem,"Z2_RESERVA","N",9,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@E 999999999",;
		"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
		//                   1234567890123456789012345678901234567890
		aPHelpPor 	:= {"Controle de Reserva por Agenda"}
		aPHelpEng 	:= 	aPHelpSpa	:=	aPHelpPor
		PutHelp("PZ2_RESERVA",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	ENDIF
	
	//CAMPO Z2_PRECO
	IF .NOT. SX3->(DBSeek("Z2_PRECO")) //se nao existir, cadastrar
		cTitulo:="Preco"
		cDescr :="Agenda Influencia Preco"
		//			  1234567890123456789012345
		//	                     x            x
		AADD(aSX3,{"SZ2",cOrdem,"Z2_PRECO","C",1,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"",;
		"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
		//                   1234567890123456789012345678901234567890
		aPHelpPor 	:= {"Informa se esta versao de agenda ",;
		"influenciara ou nao no preço"}
		aPHelpEng 	:= 	aPHelpSpa	:=	aPHelpPor
		PutHelp("PZ2_PRECO",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	ENDIF
	
	//CAMPO Z2_ATIVA
	If .NOT. SX3->(DBSeek("Z2_ATIVA")) //se nao existir, cadastrar
		cTitulo:="Ativa"
		cDescr :="Agenda Ativa ou Inativa"
		//			  1234567890123456789012345
		//	                     x            x
		AADD(aSX3,{"SZ2",cOrdem,"Z2_ATIVA","C",1,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"",;
		"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
		//                   1234567890123456789012345678901234567890
		aPHelpPor 	:= {"Informa se esta versao de agenda ",;
		"estara ou nao ativa"}
		aPHelpEng 	:= 	aPHelpSpa	:=	aPHelpPor
		PutHelp("PZ2_ATIVA",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	ENDIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Alteracoes da tabela SZ3 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//CAMPO Z3_FILIAL
	IF .NOT. SX3->(DBSeek("Z3_FILIAL")) //se nao existir, cadastrar
		cTitulo:="Filial"
		cDescr :="Filial do Sistema"
		//			  1234567890123456789012345
		//	                     x            x
		AADD(aSX3,{"SZ3",cOrdem,"Z3_FILIAL","C",2,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@!",;
		"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
		//                   1234567890123456789012345678901234567890
		aPHelpPor 	:= {""}
		aPHelpEng 	:= 	aPHelpSpa	:=	aPHelpPor
		PutHelp("PZ3_FILIAL",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	EndIf
	
	//CAMPO Z3_RESERVA
	IF .NOT. SX3->(DBSeek("Z3_RESERVA")) //se nao existir, cadastrar
		cTitulo:="Cod.Reserva"
		cDescr :="Codigo da Reserva"
		//			  1234567890123456789012345
		//	                     x            x
		AADD(aSX3,{"SZ3",cOrdem,"Z3_RESERVA","N",9,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@E 999999999",;
		"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
		//                   1234567890123456789012345678901234567890
		aPHelpPor 	:= {"Código da reserva controle da agenda"}
		aPHelpEng 	:= 	aPHelpSpa	:=	aPHelpPor
		PutHelp("PZ3_RESERVA",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	ENDIF
	
	//CAMPO Z3_ITEM
	IF .NOT. SX3->(DBSeek("Z3_ITEM")) //se nao existir, cadastrar
		cTitulo:="Num. Item"
		cDescr :="Numero do Item da Reserva"
		//			  1234567890123456789012345
		//	                     x            x
		AADD(aSX3,{"SZ3",cOrdem,"Z3_ITEM","N",5,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@E 99999",;
		"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
		//                   1234567890123456789012345678901234567890
		aPHelpPor 	:= {"Numero do Item da Reserva da agenda"}
		aPHelpEng 	:= 	aPHelpSpa	:=	aPHelpPor
		PutHelp("PZ3_ITEM",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	ENDIF
	
	//CAMPO Z3_CODPROD
	IF .NOT. SX3->(DBSeek("Z3_CODPROD")) //se nao existir, cadastrar
		cTitulo:="Cod. Prod."
		cDescr :="Cod. do Produto reservado"
		//			  1234567890123456789012345
		//	                     x            x
		AADD(aSX3,{"SZ3",cOrdem,"Z3_CODPROD","C",15,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@!",;
		"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
		//                   1234567890123456789012345678901234567890
		aPHelpPor 	:= {"Codigo do Produto reservado para ",;
		"a Agenda"}
		aPHelpEng 	:= 	aPHelpSpa	:=	aPHelpPor
		PutHelp("PZ3_CODPROD",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	ENDIF
	
	//CAMPO Z3_QTPROD
	IF .NOT. SX3->(DBSeek("Z3_QTPROD")) //se nao existir, cadastrar
		cTitulo:="Quant.Prod."
		cDescr :="Quantidade do Produto"
		//			  1234567890123456789012345
		//	                     x            x
		AADD(aSX3,{"SZ3",cOrdem,"Z3_QTPROD","N",11,2,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@E 99999999.99",;
		"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
		//                   1234567890123456789012345678901234567890
		aPHelpPor 	:= {"Quantidade do Produto reservado para ",;
		"a Agenda"}
		aPHelpEng 	:= 	aPHelpSpa	:=	aPHelpPor
		PutHelp("PZ3_QTPROD",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
	ENDIF
	
	
	ProcRegua(Len(aSX3))
	
	DBSelectArea("SX3")
	SX3->( DBSetOrder(2) )
	
	FOR nPos := 1 TO LEN( aSX3 )
		IF .NOT. EMPTY( aSX3[nPos][1] )
			If .NOT. SX3->( DBSeek( PadR( aSX3[nPos,3], LEN( SX3->X3_CAMPO ) ) ) )
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³A ordem sera analisada no momento da gravacao visto que    ³
				//³a base pode conter alguns dos campos informados neste      ³
				//³fonte para gravacao. Neste caso, se definissemos a ordem   ³
				//³no momento da criacao do array aSX3, algumas ordem ficariam³
				//³perdidas no SX3.                                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cOrdem       := IIF( ProxOrdem( aSX3[nPos,1]) == NIL, "01", ProxOrdem( aSX3[nPos,1]))
				aSX3[nPos,2] := cOrdem
				//
				lSX3	:= .T.
				IF .NOT. ( aSX3[nPos,1] $ cAlias )
					cAlias += aSX3[nPos,1]+"/"
					AADD( aArqUpd, aSX3[nPos,1])
				ENDIF
				
				RecLock("SX3",.T.)
				FOR nCount := 1 TO LEN( aSX3[nPos] )
					IF FieldPos( aEstrut[nCount] ) > 0
						FieldPut( FieldPos( aEstrut[nCount]), aSX3[nPos,nCount] )
					ENDIF
				NEXT
				DBCommit()
				MSUnLock()
				IncProc("Atualizando Dicionario de Dados...")
			ENDIF
		ENDIF
	NEXT
	
	IF lSX3
		cTexto := 'Foram alteradas as estruturas das seguintes tabelas : ' + cAlias + CHR(13) + CHR(10)
	ENDIF
	
RETURN( cTexto )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ProxOrdem ºAutor  ³Microsiga           º Data ³  10/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica a proxima ordem no SX3 para criacao de novos camposº±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION ProxOrdem(cTabela,cOrdem)

LOCAL aOrdem	 := {"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","X","W","Y","Z"}
LOCAL cProxOrdem := ""
LOCAL aAreaSX3   := SX3->(GetArea())
LOCAL nPos

Default cOrdem	:= ""

	// Verificando a ultima ordem utilizada
	IF EMPTY( cOrdem )
		DBSelectArea("SX3")
		SX3->( DBSetOrder(1) )
		IF SX3->( MsSeek(cTabela) )
			WHILE SX3->X3_ARQUIVO == cTabela .And. SX3->( .NOT. EOF())
				cOrdem := SX3->X3_ORDEM
				SX3->(DBSkip())
			ENDDO
		ELSE
			cOrdem := "00"
		ENDIF
	ENDIF
	
	// Criando a nova ordem para o cadastro do novo campo
	IF VAL( SUBSTR( cOrdem, 2, 1 ) ) < 9
		cProxOrdem := SUBSTR( cOrdem, 1, 1) + STR( ( VAL( SUBSTR( cOrdem, 2, 1 ) ) +1 ), 1)
	ELSE
		FOR nPos := 1 TO LEN( aOrdem )
			IF aOrdem[nPos] == SUBSTR( cOrdem, 1, 1 )
				EXIT
			ENDIF
		NEXT
		cProxOrdem := aOrdem[nPos+1] + "0"
	ENDIF
	
	SX3->(RestArea(aAreaSX3))
	
RETURN( cProxOrdem )
