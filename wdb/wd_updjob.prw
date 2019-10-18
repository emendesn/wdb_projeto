#INCLUDE "Protheus.ch"
#DEFINE X3_USADO_EMUSO "€€€€€€€€€€€€€€ "
#DEFINE X3_USADO_NAOUSADO "€€€€€€€€€€€€€€€"   
#DEFINE X3_OBRIGAT "Á€" 
#DEFINE X3_RESER "þÀ"  
#DEFINE X3_RESER_NUMERICO "øÇ" 
#DEFINE X3_RES	"€€"   

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³UpdAGENDA ³ Autor ³ Murilo Swistalski   ³ Data ³ 17/03/2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Criacao / Atualizacao das tabelas da Agenda de JOBs da WD  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UpdAGENDA()
cArqEmp := "SigaMat.Emp"
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
ACTIVATE 	WINDOW oMainWnd ;
	ON INIT If(lHistorico,(Processa({|lEnd| MSAProc(@lEnd,@lOpen)},"Processando","Aguarde, processando preparacao das Tabelas",.F.) ,If(lOpen,Final("Atualizacao efetuada!"),oMainWnd:End())),oMainWnd:End())

Return

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
Static Function MSAProc(lEnd,lOpen)
Local cTexto    := ''
Local cFile     :=""
Local cMask     := "Arquivos Texto (*.TXT) |*.txt|"
Local cCodigo   := "DM"
Local nRecno    := 0
Local nI        := 0
Local aRecnoSM0 := {}     
Local nX		:= 0

ProcRegua(1)
IncProc("Verificando integridade dos dicionarios....")

If MyOpenSm0Ex()
	dbSelectArea("SM0")
	dbGotop()
	While !Eof()
		Aadd(aRecnoSM0,SM0->(RECNO()))
		dbSkip()
	EndDo
		
	For nI := 1 To Len(aRecnoSM0)
		SM0->(dbGoto(aRecnoSM0[nI]))
		RpcSetType(3) //RpcSetType(2) 
		RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
		RpcClearEnv()
		If !( lOpen := MyOpenSm0Ex() )
			Exit 
		EndIf 
	Next nI
	         
	If lOpen
		For nI := 1 To Len(aRecnoSM0)
			SM0->(dbGoto(aRecnoSM0[nI]))
			RpcSetType(2) 
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
			cTexto += Replicate("-",128)+CHR(13)+CHR(10)
			cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)
			
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
			For nX := 1 To Len(aArqUpd)
				IncProc("Atualizando estruturas. Aguarde... ["+aArqUpd[nx]+"]")
				If Select(aArqUpd[nx])>0
					dbSelecTArea(aArqUpd[nx])
					dbCloseArea()
				EndIf
				X31UpdTable(aArqUpd[nx])
				If __GetX31Error()
					Alert(__GetX31Trace())
					Aviso("Atencao!","Ocorreu um erro desconhecido durante a atualizacao da tabela : "+ aArqUpd[nx] + ". Verifique a integridade do dicionario e da tabela.",{"Continuar"},2)
					cTexto += "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "+aArqUpd[nx] +CHR(13)+CHR(10)
				EndIf
			Next nX

			RpcClearEnv()
			If !( lOpen := MyOpenSm0Ex() )
				Exit 
			EndIf 
		Next nI 
		   
		If lOpen
			cTexto := "Log da atualizacao "+CHR(13)+CHR(10)+cTexto
			__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
			DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
			DEFINE MSDIALOG oDlg TITLE "Atualizacao concluida." From 3,0 to 340,417 PIXEL
			@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
			oMemo:bRClicked := {||AllwaysTrue()}
			oMemo:oFont:=oFont
			DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
			DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."
			ACTIVATE MSDIALOG oDlg CENTER
		EndIf 
	EndIf
EndIf 	
Return(.T.)


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

Static Function MyOpenSM0Ex()
                  
Local nLoop := 0 

For nLoop := 1 To 20
	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .F., .F. ) 
	If !Empty( Select( "SM0" ) ) 
		lOpen := .T. 
		dbSetIndex("SIGAMAT.IND") 
		Exit	
	EndIf
	Sleep( 500 ) 
Next nLoop 

If !lOpen
	Aviso( "Atencao !", "Nao foi possivel a abertura da tabela de empresas de forma exclusiva !", { "Ok" }, 2 ) 
EndIf                                 

Return( lOpen ) 

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
Static Function MSAAtuSX2()
Local aSX2   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cTexto := ''
Local lSX2	 := .F.
Local cAlias := ''
Local cPath
Local cNome


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


ProcRegua(Len(aSX2))

dbSelectArea("SX2")
dbSetOrder(1)
dbSeek("AF8")
cPath := SX2->X2_PATH
cNome := cEmpAnt+"0"

For i:= 1 To Len(aSX2)
	If !Empty(aSX2[i][1])
		If !dbSeek(aSX2[i,1])
			lSX2	:= .T.
			If !(aSX2[i,1]$cAlias)
				cAlias += aSX2[i,1]+"/"
			EndIf
			RecLock("SX2",.T.)
			For j:=1 To Len(aSX2[i])
				If FieldPos(aEstrut[j]) > 0
					FieldPut(FieldPos(aEstrut[j]),aSX2[i,j])
				EndIf
			Next j
			SX2->X2_PATH := cPath
			SX2->X2_ARQUIVO := aSX2[i,1]+cNome
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Dicionario para Agenda...")
		EndIf
	EndIf
Next i
Return cTexto


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
Static Function MSAAtuSX3()
Local aSX3   := {}
Local cTitulo:=""
Local cDescr :=""
Local aPHelpPor	:={}
Local aPHelpEng	:={}
Local aPHelpSpa	:={}
Local i      := 0
Local j      := 0
Local lSX3	 := .F.
Local cTexto := ''
Local cAlias := ''
Local cOrdem := ""
Local cfolder:= ""
//Estrutura para gravacao dos itens no SX3
Local aEstrut:= { "X3_ARQUIVO","X3_ORDEM"  ,"X3_CAMPO"  ,;
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

dbSelectArea("SX3")
dbSetOrder(2)
		
cFolder := ""
cOrdem  := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alteracoes da tabela SZ1 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//CAMPO Z1_FILIAL
If !(dbSeek("Z1_FILIAL")) //se nao existir, cadastrar
	cTitulo:="Filial"
	cDescr :="Filial do Sistema"
//			  1234567890123456789012345 
//	                     x            x
	AADD(aSX3,{"SZ1",cOrdem,"Z1_FILIAL","C",2,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@!",;
			"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
//                   1234567890123456789012345678901234567890   
	aPHelpPor 	:= {""}
    aPHelpEng 	:= 	aPHelpSpa	:=	aPHelpPor
    PutHelp("PZ1_FILIAL",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
EndIf

//CAMPO Z1_CODJOB
If !(dbSeek("Z1_CODJOB")) //se nao existir, cadastrar
	cTitulo:="Cod.Job"
	cDescr :="Codigo do JOB"
//			  1234567890123456789012345 
//	                     x            x
	AADD(aSX3,{"SZ1",cOrdem,"Z1_CODJOB","N",9,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@E 999999999",;
			"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
//                   1234567890123456789012345678901234567890   
	aPHelpPor 	:= {"Código do JOB a ser utilizado para ",;
					 "o Agendamento.                     "}
    aPHelpEng 	:= 	aPHelpSpa	:=	aPHelpPor
    PutHelp("PZ1_CODJOB",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
EndIf

//CAMPO Z1_EVENTO
If !(dbSeek("Z1_EVENTO")) //se nao existir, cadastrar
	cTitulo:="Evento"
	cDescr :="Evento do JOB"
//			  1234567890123456789012345 
//	                     x            x
	AADD(aSX3,{"SZ1",cOrdem,"Z1_EVENTO","C",30,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@!",;
			"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
//                   1234567890123456789012345678901234567890
	aPHelpPor 	:= {"Nome do Evento do JOB"}
    aPHelpEng 	:= 	aPHelpSpa	:=	aPHelpPor
    PutHelp("PZ1_EVENTO",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
EndIf

//CAMPO Z1_LOCAL
If !(dbSeek("Z1_LOCAL")) //se nao existir, cadastrar
	cTitulo:="Local"
	cDescr :="Local do Evento do JOB"
//			  1234567890123456789012345 
//	                     x            x
	AADD(aSX3,{"SZ1",cOrdem,"Z1_LOCAL","C",30,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@!",;
			"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
//                   1234567890123456789012345678901234567890   
	aPHelpPor 	:= {"Local que ocorrerá o evento do JOB"}
    aPHelpEng 	:= 	aPHelpSpa	:=	aPHelpPor
    PutHelp("PZ1_LOCAL",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
EndIf

//CAMPO Z1_DESCR
If !(dbSeek("Z1_DESCR")) //se nao existir, cadastrar
	cTitulo:="Descricao"
	cDescr :="Descricao Resumida do JOB"
//			  1234567890123456789012345 
//	                     x            x
	AADD(aSX3,{"SZ1",cOrdem,"Z1_DESCR","C",255,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@!",;
			"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
//                   1234567890123456789012345678901234567890
	aPHelpPor 	:= {"Informe aqui um resumo descritivo  ",;
					 "sobre o JOB"}
    aPHelpEng 	:= 	aPHelpSpa	:=	aPHelpPor
    PutHelp("PZ1_DESCR",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
EndIf

//CAMPO Z1_CLIENTE
If !(dbSeek("Z1_CLIENTE")) //se nao existir, cadastrar
	cTitulo:="Cod. Cliente"
	cDescr :="Codigo do Cliente"
//			  1234567890123456789012345 
//	                     x            x
	AADD(aSX3,{"SZ1",cOrdem,"Z1_CLIENTE","C",6,0,cTitulo,cTitulo,cTitulo,cDescr,cDescr,cDescr,"@!",;
			"",X3_USADO_EMUSO,"","",1,X3_RESER,"","","U","N","A","R","","","","","","","","","",""})
//                   1234567890123456789012345678901234567890
	aPHelpPor 	:= {"Código do Cliente do Evento"}
    aPHelpEng 	:= 	aPHelpSpa	:=	aPHelpPor
    PutHelp("PZ1_CLIENTE",aPHelpPor,aPHelpEng,aPHelpSpa,.T.)
EndIf

//CAMPO Z1_LOJA
If !(dbSeek("Z1_LOJA")) //se nao existir, cadastrar
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
EndIf

//CAMPO Z1_DTINI
If !(dbSeek("Z1_DTINI")) //se nao existir, cadastrar
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
EndIf

//CAMPO Z1_DTINI
If !(dbSeek("Z1_DTFIM")) //se nao existir, cadastrar
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
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alteracoes da tabela SZ2 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//CAMPO Z2_FILIAL
If !(dbSeek("Z2_FILIAL")) //se nao existir, cadastrar
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
EndIf

//CAMPO Z2_CODJOB
If !(dbSeek("Z2_CODJOB")) //se nao existir, cadastrar
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
EndIf

//CAMPO Z2_AGENDA
If !(dbSeek("Z2_AGENDA")) //se nao existir, cadastrar
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
If !(dbSeek("Z2_VERSAO")) //se nao existir, cadastrar
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
EndIf

//CAMPO Z2_RESERVA
If !(dbSeek("Z2_RESERVA")) //se nao existir, cadastrar
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
EndIf

//CAMPO Z2_PRECO
If !(dbSeek("Z2_PRECO")) //se nao existir, cadastrar
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
EndIf

//CAMPO Z2_ATIVA
If !(dbSeek("Z2_ATIVA")) //se nao existir, cadastrar
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
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alteracoes da tabela SZ3 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//CAMPO Z3_FILIAL
If !(dbSeek("Z3_FILIAL")) //se nao existir, cadastrar
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
If !(dbSeek("Z3_RESERVA")) //se nao existir, cadastrar
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
EndIf

//CAMPO Z3_ITEM
If !(dbSeek("Z3_ITEM")) //se nao existir, cadastrar
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
EndIf

//CAMPO Z3_CODPROD
If !(dbSeek("Z3_CODPROD")) //se nao existir, cadastrar
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
EndIf

//CAMPO Z3_QTPROD
If !(dbSeek("Z3_QTPROD")) //se nao existir, cadastrar
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
EndIf


ProcRegua(Len(aSX3))

dbSelectArea("SX3")
dbSetOrder(2)

For i:= 1 To Len(aSX3)
	If !Empty(aSX3[i][1])
		If !dbSeek(PadR(aSX3[i,3],Len(SX3->X3_CAMPO)))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³A ordem sera analisada no momento da gravacao visto que    ³
			//³a base pode conter alguns dos campos informados neste      ³
			//³fonte para gravacao. Neste caso, se definissemos a ordem   ³
			//³no momento da criacao do array aSX3, algumas ordem ficariam³
			//³perdidas no SX3.                                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cOrdem		:= IIF(ProxOrdem(aSX3[i,1])==NIL,"01",ProxOrdem(aSX3[i,1]))
			aSX3[i,2] 	:= cOrdem
			//
			lSX3	:= .T.
			If !(aSX3[i,1]$cAlias)
				cAlias += aSX3[i,1]+"/"
				aAdd(aArqUpd,aSX3[i,1])
			EndIf
			RecLock("SX3",.T.)                    
			For j:=1 To Len(aSX3[i])
				If FieldPos(aEstrut[j])>0
					FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
				EndIf
			Next j
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Dicionario de Dados...")
		EndIf
	EndIf
Next i

If lSX3
	cTexto := 'Foram alteradas as estruturas das seguintes tabelas : '+cAlias+CHR(13)+CHR(10)
EndIf

Return cTexto


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

Static Function ProxOrdem(cTabela,cOrdem)
Local aOrdem	:= {"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","X","W","Y","Z"}
Local cProxOrdem:= ""
Local nX		:= 0
Local aAreaSX3 := SX3->(GetArea())

Default cOrdem	:= ""

// Verificando a ultima ordem utilizada
If Empty(cOrdem)
	dbSelectArea("SX3")
	dbSetOrder(1)
	If MsSeek(cTabela)
		Do While SX3->X3_ARQUIVO == cTabela .And. !SX3->(Eof())
			cOrdem := SX3->X3_ORDEM
			SX3->(dbSkip())
		Enddo
	Else
		cOrdem := "00"
	EndIf
Endif

// Criando a nova ordem para o cadastro do novo campo
If Val(SubStr(cOrdem,2,1)) < 9
	cProxOrdem 	:= SubStr(cOrdem,1,1) + Str((Val(SubStr(cOrdem,2,1))+1),1)
Else
	For nX := 1 To Len(aOrdem)
		If aOrdem[nX] == SubStr(cOrdem,1,1)
			Exit
		Endif
	Next
	cProxOrdem 	:= aOrdem[nX+1] + "0"
Endif

SX3->(RestArea(aAreaSX3))
Return cProxOrdem
