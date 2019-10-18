#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CADJOB   � Autor � Murilo Swistalski     � Data �25/03/2010���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de Cadastro de JOBs                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para Criacao/Alteracao da Agenda JOB - WDB      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION CADJOB()

Local aCores    := {	{'Z1_DTFIM< DATE()'	,'BR_VERMELHO'   },;	// JOB Encerrado/Em atraso
						{'Z1_DTFIM==DATE()'	,'BR_AMARELO'	 },;	// JOB na Data
						{'Z1_DTFIM> DATE()'	,'BR_VERDE'		 } }	// JOB em Andamento
      
Private cCadastro := 'Cadastro de JOBs'
Private aRotina := {	{ 'Pesquisar' , 'AxPesqui' , 0, 1 },;
						{ 'Visualizar', 'AxVisual' , 0, 2 },;
						{ 'Incluir'   , 'AxInclui' , 0, 3 },;
						{ 'Alterar'   , 'AxAltera' , 0, 4 },;
						{ 'Excluir'   , 'U_ExcluiJOB',	0, 5, 3 },;
						{ 'Legenda'	  , 'U_LegendaJOB',	0, 6, 3 }}

MBrowse( ,,,,"SZ1",/* aFixe */,"Z1_DTFIM",/* nPar08 */,/* cFun */,/* nClickDef */,aCores,;
		 /* cTopFun */, /* cBotFun */, /* nPar14 */, /* bInitBloc */,/* lNoMnuFilter */, /* lSeeAll */, /* lChgAll */)
		 
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ExcluiJOB� Autor � Murilo Swistalski     � Data �25/03/2010���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de Exclusao de Cadastro de JOBs                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para Criacao/Alteracao da Agenda JOB - WDB      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION ExcluiJOB(cAlias,nReg,nOpc)

If APMsgYesNo("Deseja realmente excluir JOB selecionado?")
	
	//verifica se existe agenda aberta para este JOB
	dbSelectArea(cAlias)
	dbGoto(nReg)
	
	dbSelectArea("SZ2")
	If SZ2->( DbSeek((cAlias)->Z1_CODJOB) )
		MsgStop("Este JOB possui uma ou mais Agendas cadastradas","Exclus�o negada")
	Else
		dbSelectArea(cAlias)
		RecLock(cAlias,.F.,.T.)
		dbDelete()
		MsUnLock()
	    MsgInfo("Concluido","JOB excluido com Sucesso!")
	EndIf
	
	SZ2->(dbCloseArea())	

EndIf

RETURN

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �LegendaJOB� Autor � Murilo Swistalski     � Data �25/03/2010���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de Legendas do Cadastro de JOBs                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para Criacao/Alteracao da Agenda JOB - WDB      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION LegendaJOB(cAlias,nReg,nOpc)
Local aLegenda := {}

AADD(aLegenda,{"BR_VERMELHO" ,"JOB Encerrado ou Em Atraso" })
AADD(aLegenda,{"BR_AMARELO"	 ,"JOB na Data" })
AADD(aLegenda,{"BR_VERDE"	 ,"JOB Aberto ou Em Andamento" })

BrwLegenda(cCadastro, "Legenda", aLegenda)

RETURN NIL

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CadAgenda � Autor � Murilo Swistalski     � Data �25/03/2010���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de Cadastro de Agenda                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para Criacao/Alteracao da Agenda JOB - WDB      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION CADAGENDA()
Local aCores    := {	{'Z2_ATIVA=="1"','BR_VERDE'		},;	// Agenda Ativa
						{'Z2_ATIVA=="0"','BR_VERMELHO'	},;	// Agenda Inativa
						{'Z2_ATIVA=="2"','BR_AZUL'		} }	// Agenda Ja efetuada orcamento

Private cCadastro := 'Cadastro de Agendas'
/*
Private aRotina := {	{ "Pesquisar",		"AxPesqui"  ,	 0 , 1     },; //"Pesquisar"
						{ "Visualizar",		"U_RECURSOS",	 0 , 2 , 3 },; //"Visualizar"
						{ "Incluir",		"U_RECURSOS",	 0 , 3 , 3 },; //"Incluir"
						{ "Alterar",		"MsgStop('N�o � permitida altera��o de Agendas','Acesso Negado')",	 0 , 4 , 3 },; //"Alterar"
						{ "Excluir",		"MsgStop('MsgStop("N�o � permitida exclus�o de Agendas','Acesso Negado')",0 , 5 , 3 },; //"Excluir"
						{ "Ativar Agenda",	"U_AtivaAgenda", 0 , 6 , 3 },; //"Ativar Agenda"
						{ "Gerar Or�amento","U_GERAORC",	 0 , 7 , 3 },; //"Gerar Orcamento"
						{ "Legenda",		"U_LegAgenda",	 0 , 8 , 3 }}  //"Legenda"
*/
/*
Private aRotina := {	{ "Pesquisar",		"AxPesqui"  ,	 0 , 1 , 3 },; //"Pesquisar"
						{ "Visualizar",		"U_RECURSOS",	 0 , 2 , 3 },; //"Visualizar"
						{ "Incluir",		"U_RECURSOS",	 0 , 3 , 3 },; //"Incluir"
						{ "Copiar",			"U_RECURSOS",	 0 , 4 , 3 },; //"Copiar"
						{ "Excluir",		"U_RECURSOS",	 0 , 5 , 3 },; //"Excluir
						{ "Ativar Agenda",	"U_AtivaAgenda", 0 , 6 , 3 },; //"Ativar Agenda"
						{ "Gerar Or�amento","U_GERAORC",	 0 , 7 , 3 },; //"Gerar Orcamento"
						{ "Legenda",		"U_LegAgenda",	 0 , 8 , 3 }}  //"Legenda"
*/
Private aRotina := {	{ "Pesquisar",		"AxPesqui"  ,	 0 , 1 },; //"Pesquisar"
						{ "Visualizar",		"U_RECURSOS",	 0 , 2 },; //"Visualizar"
						{ "Incluir",		"U_RECURSOS",	 0 , 3 },; //"Incluir"
						{ "Copiar",			"U_RECURSOS",	 0 , 4 },; //"Copiar"
						{ "Excluir",		"U_RECURSOS",	 0 , 5 },; //"Excluir
						{ "Ativar Agenda",	"U_AtivaAgenda", 0 , 6 },; //"Ativar Agenda"
						{ "Gerar Or�amento","U_GERAORC",	 0 , 7 },; //"Gerar Orcamento"
						{ "Legenda",		"U_LegAgenda",	 0 , 8 }}  //"Legenda"


Private cCadastro := "Cadastro de Agendas"

Private oWBrowse1
Private aWBrowse1	:= {}
Private cTxtJob		:= Space(09)
Private cTxtCodCli	:= Space(06)
Private cTxtNomeCli	:= Space(30)
Private cTxtLoja	:= Space(02)
Private cTxtEvento	:= Space(30)
Private cTxtLocal	:= Space(30)
Private cTxtAgenda	:= Space(09)
Private cTxtVersao	:= Space(05)
Private cTxtDtIni	:= Space(10)
Private cTxtDtFim	:= Space(10)

mBrowse( ,,,,"SZ2",,"Z2_ATIVA",,,,aCores)
//mBrowse( ,,,,"SA1")
Return

/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    �ExcluiAgenda� Autor � Murilo Swistalski     � Data �14/04/2010���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Inclusao de Recursos (Produtos) para a Agenda				���
���������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para Criacao/Alteracao da Agenda JOB - WDB		���
����������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������*/
User Function ExcluiAgenda(cAlias,nReg,nOpc)

MsgStop("N�o � permitido excluir agenda!", "Controle de Vers�o Ativado")

dbUnLockAll()

Return
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � RECURSOS � Autor � Murilo Swistalski     � Data �25/03/2010���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Inclusao de Recursos (Produtos) para a Agenda			  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para Criacao/Alteracao da Agenda JOB - WDB      ���
��������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������*/
USER FUNCTION RECURSOS(cAlias,nReg,nOpc)

Local cTipo		 := ""
Local oTxtJob, oTxtAgenda, oTxtCodCli, oTxtNomeCli, oTxtEvento, oTxtLocal, oTxtLoja, oTxtVersao
Local nOpca
Local nCont		 := 0
Local lGrava	 := .F.
Local aNovoArray := {}
Private aHeader  := {}
Private aHeader  := {}
Static oDlg

dbSelectArea("SZ1")

aAdd(aHeader,{"OK"			,"OK_SN"	,"@BMP"			, 5,0,"","","C","","V"})
aAdd(aHeader,{"Cod.Prod"	,"B1_COD"	,"@!"			,15,0,"","","C","",""})
aAdd(aHeader,{"Nome Prod."	,"B1_DESC"	,"@!"			,40,0,"","","C","",""})
aAdd(aHeader,{"QT.Estoque"	,"QTEST"	,"@E 999999.99" , 9,2,"","","N","",""})
aAdd(aHeader,{"Qt.Agenda"	,"QTD"		,"@E 999999.99" , 9,2,"","","N","",""})

Do Case
	Case nOpc==2
		 cTipo := " - Visualizar"
		 aNovoArray := PassaInfo(nReg)
		 cTxtVersao := (cAlias)->Z2_VERSAO //StrZero(Val(cTxtVersao)-1,5)
		 
	Case nOpc==3; cTipo := " - Incluir"
	
	Case nOpc==4
		 cTipo := " - Copiar" //" - Alterar"
		 MsgAlert("C�pia de vers�o selecionada." + chr(13) + "N�mero de vers�o ser� atualizada!", "Controle de Vers�o Ativado")
		 aNovoArray := PassaInfo(nReg)
		
	Case nOpc==5
		 cTipo := " - Excluir"
		 MsgStop("N�o � permitido excluir agenda!", "Controle de Vers�o Ativado")
		 Return
		 
EndCase

DEFINE MSDIALOG oDlg TITLE "Agenda de JOBs"+cTipo From 000,000 To 030,070 OF oMainWnd
DEFINE FONT oFnt NAME "Arial" Size 10,15
		
 	MOSTRAGRID(.F.,aNovoArray)
	
    @ 022, 015 SAY "JOB:" OF oDlg PIXEL
	@ 020, 040 MSGET oTxtJob VAR cTxtJob PICTURE "@!" F3 "WDB" ON CHANGE ValidaJOB(cTxtJob:=TrataVar(cTxtJob)) SIZE 020, 010 OF oDlg COLORS 0, 16777215 HASBUTTON PIXEL
    
    @ 022, 085 SAY "Cliente:" OF oDlg PIXEL    
    @ 020, 105 MSGET oTxtCodCli VAR cTxtCodCli SIZE 020, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL  
    @ 020, 130 MSGET oTxtNomeCli VAR cTxtNomeCli SIZE 100, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    
    @ 022, 235 SAY "Loja:" OF oDlg PIXEL
    @ 020, 250 MSGET oTxtLoja VAR cTxtLoja SIZE 015, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    
    @ 037, 015 SAY "Evento:" OF oDlg PIXEL
    @ 035, 040 MSGET oTxtEvento VAR cTxtEvento SIZE 100, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    
    @ 037, 145 SAY "Local:" OF oDlg PIXEL
    @ 035, 165 MSGET oTxtLocal VAR cTxtLocal SIZE 100, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
                                                 	
    @ 052, 015 SAY "Agenda:" OF oDlg PIXEL
    @ 050, 040 MSGET oTxtAgenda VAR cTxtAgenda PICTURE "@!" ON CHANGE ValidaAgenda(cTxtAgenda:=StrZero(Val(cTxtAgenda),9)) VALID Val(cTxtAgenda)<>0 SIZE 020, 010 OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 052, 085 SAY "Versao:" OF oDlg PIXEL
    @ 050, 105 MSGET oTxtVerso VAR cTxtVersao SIZE 020, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    
    @ 052, 140 SAY "Dt.Inicial:" OF oDlg PIXEL
    @ 050, 165 MSGET oTxtDtIni VAR cTxtDtIni SIZE 035, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    
    @ 052, 210 SAY "Dt.Final:" OF oDlg PIXEL
    @ 050, 230 MSGET oTxtDtFim VAR cTxtDtFim SIZE 035, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,	{|| nOpcA:=1,	oDlg:End()},;
														 	{|| nOpcA:=2,	oDlg:End()})

IF nOpcA == 1 .and. (nOpc==3 .or. nOpc==4) // Aceita operacao e grava dados
	lGrava	:= .F.
	cErro	:= ""
	                                                 			
	//verifica se foi selecionado algum produto
	For i:=1 to Len(aWBrowse1)
		If aWBrowse1[i][5] > 0   //aWBrowse1[oWBrowse1:nAt][5]
			lGrava := .T.
		EndIf
	Next
	If !(lGrava)
		cErro += "QT"
	EndIf
	
	//verifica se o numero da agenda foi digitado e se esta correto
	If lGrava
		If Val(cTxtAgenda) <= 0
	    	lGrava:=.F.
			cErro += "AG"
		EndIf
	EndIf
    
	If !lGrava
		If cErro == "QTAG"
			MsgAlert("Verifique se h� produto selecionado"+chr(13)+"e se o codigo da agenda est� correto.","Imposs�vel Gravar")
		ElseIf cErro == "QT"
			MsgAlert("Verifique se h� produto selecionado ou se as quantidades foram informadas","Imposs�vel Gravar")
		ElseIf cErro == "AG"
			MsgAlert("Verifique se o codigo da agenda/vers�o est� correto.","Imposs�vel Gravar")
		EndIf
	EndIf
    
	If lGrava
		GravaAgenda(nOpc)
	EndIf

ElseIf nOpcA == 1 .and. nOpc == 2
	MsgStop("N�o � permitido efetuar altera��es!","Visualizar Agenda")
ElseIf nOpcA == 2

EndIf

If lGrava
	LimpaTela("Var")	
EndIf

Return      

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ValidaJOB� Autor � Murilo Swistalski     � Data �30/03/2010���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de Validacao de Digitacao de JOBs					  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para Criacao/Alteracao da Agenda JOB - WDB      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function ValidaJOB(cJOB,cParam)
Local nCont := 0
Default cParam := .T.

clQry := "SELECT Z1_CODJOB, Z1_EVENTO, Z1_LOCAL, Z1_DESCR,"
clQry += "		 Z1_CLIENTE, A1_NOME, Z1_LOJA, Z1_DTINI, Z1_DTFIM, "
clQry += "		 Z2_AGENDA, Z2_VERSAO, Z2_RESERVA, Z2_ATIVA "
clQry += "FROM "+RetSqlName("SZ1")+" SZ1 "
clQry += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON SZ1.Z1_CLIENTE = SA1.A1_COD "
clQry += "LEFT JOIN "+RetSqlName("SZ2")+" SZ2 ON SZ1.Z1_CODJOB = SZ2.Z2_CODJOB "
clQry += "WHERE Z1_CODJOB = '" + cJOB + "' "
clQry += "ORDER BY Z2_VERSAO DESC"

clQry := ChangeQuery( clQry )
dbUseArea( .T., "TopConn", TCGenQry(,,clQry), "QZ1", .F., .F. )
                  
QZ1->( dbEval( {|| nCont++ } ) )
QZ1->( dbGoTop() )

If QZ1->( !Eof() )
	//atualizar campos
	cTxtCodCli	:= QZ1->Z1_CLIENTE
	cTxtNomeCli	:= QZ1->A1_NOME
	cTxtLoja	:= QZ1->Z1_LOJA
	cTxtEvento	:= QZ1->Z1_EVENTO
	cTxtLocal	:= QZ1->Z1_LOCAL
	cTxtAgenda	:= IIF(QZ1->Z2_AGENDA==Space(9),StrZero(1,9),StrZero(Val(QZ1->Z2_AGENDA),9))
	cTxtVersao	:= IIF(QZ1->Z2_VERSAO==Space(5),StrZero(1,5),StrZero(Val(QZ1->Z2_VERSAO)+1,5))
	cTxtDtIni	:= Right(QZ1->Z1_DTINI,2)+"/"+Substr(QZ1->Z1_DTINI,5,2)+"/"+Left(QZ1->Z1_DTINI,4)
	cTxtDtFim	:= Right(QZ1->Z1_DTFIM,2)+"/"+Substr(QZ1->Z1_DTFIM,5,2)+"/"+Left(QZ1->Z1_DTFIM,4)
	
	If cParam
		LimpaTela("-JOB")
	EndIf
Else
	LimpaTela("Tudo")
    
	MsgAlert("JOB n�o encontrado!")
EndIf

DbSelectArea("QZ1")                           			
DbCloseArea()

Return .T.

/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    �ValidaAgenda� Autor � Murilo Swistalski     � Data �31/03/2010���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de Validacao de Digitacao da Agenda					���
���������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para Criacao/Alteracao da Agenda JOB - WDB		���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function ValidaAgenda(cTxtAgenda) 

Local nCont := 0

clQry := "SELECT TOP 1 "
clQry += "		 Z2_CODJOB, Z2_AGENDA, Z2_VERSAO, Z2_RESERVA, Z2_ATIVA "
clQry += "FROM "+RetSqlName("SZ2")+" SZ2 "
clQry += "WHERE Z2_CODJOB = '" + StrZero(Val(cTxtJob),9) + "' "
clQry += "	AND Z2_AGENDA = '" + StrZero(Val(cTxtAgenda),9) + "' "
clQry += "ORDER BY Z2_AGENDA, Z2_VERSAO DESC"

clQry := ChangeQuery( clQry )
dbUseArea( .T., "TopConn", TCGenQry(,,clQry), "QZ2", .F., .F. )
                  
QZ2->( dbEval( {|| nCont++ } ) )
QZ2->( dbGoTop() )

If QZ2->( !Eof() )

	//agenda encontrada, valida versao
	cTxtVersao:= StrZero(Val(QZ2->Z2_VERSAO)+1,5)
	@ 050, 105 MSGET oTxtVerso	 VAR cTxtVersao	 SIZE 020, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL

Else

	//nao encontrou
	cTxtAgenda:=StrZero(Val(cTxtAgenda),9)
	cTxtVersao:=StrZero(1,5)
	@ 050, 040 MSGET oTxtAgenda	 VAR cTxtAgenda	 SIZE 020, 010 OF oDlg COLORS 0, 16777215 PICTURE "@!" ON CHANGE ValidaAgenda(cTxtAgenda:=StrZero(Val(cTxtAgenda),9)) VALID Val(cTxtAgenda)<>0 PIXEL
	@ 050, 105 MSGET oTxtVerso	 VAR cTxtVersao	 SIZE 020, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
EndIf

DbSelectArea("QZ2")                           			
DbCloseArea()

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MOSTRAGRID� Autor � Murilo Swistalski     � Data �26/03/2010���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de Atualizacao de Grid de Reservas				  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para Criacao/Alteracao da Agenda JOB - WDB      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function MOSTRAGRID(lBrowseCriado,aNOVO)

Local oOk := LoadBitmap( GetResources(), "LBOK")
Local oNo := LoadBitmap( GetResources(), "LBNO")
Local nCont
Default lBrowseCriado := .F.
Default aNOVO := {}

clQry := "SELECT B1_FILIAL, B1_COD, B1_DESC,"
clQry += "		 B2_QATU AS QTEST,"		//Quantidade em Estoque
clQry += "		 ' '	 AS OK_SN,"		//Selecao da linha?
clQry += "		 0		 AS QTD "		//Quantidade Utilizada
clQry += "FROM ("
clQry += "	 SELECT B1_FILIAL, B1_COD, B1_DESC, B1_LOCPAD "
clQry += "	 FROM "+RetSqlName("SB1")"
clQry += "	 WHERE D_E_L_E_T_ = ' ' AND"
clQry += "		   B1_FILIAL  = '"+xFilial("SB1")+"'"
clQry += "	 ) SB1  "
clQry += " LEFT JOIN ("       			
clQry += "	 	  SELECT B2_FILIAL, B2_COD, B2_LOCAL, B2_QATU"
clQry += "		  FROM "+RetSqlName("SB2")"
clQry += "		  WHERE D_E_L_E_T_ = ' ' AND"
clQry += "				B2_FILIAL  = '"+xFilial("SB2")+"'"
clQry += "		  ) SB2 "
clQry += "	   ON B2_FILIAL	     = B1_FILIAL AND"
clQry += "		  B2_COD	   	 = B1_COD	 AND"
clQry += "		  B2_LOCAL		 = B1_LOCPAD"

clQry := ChangeQuery( clQry )
dbUseArea( .T., "TopConn", TCGenQry(,,clQry), "QRY", .F., .F. )
                  
QRY->( dbEval( {|| nCont++ } ) )
QRY->( dbGoTop() )

dbSelectArea("QRY") 
QRY->(DbGoTop())

ASize(aWBrowse1,0) //zera o array

While QRY->( !Eof() )	
	Aadd(aWBrowse1,{.F.,QRY->B1_COD,QRY->B1_DESC,QRY->QTEST,0,""})
	dbSkip()
EndDo

If Len(aNOVO)>0
	aWBrowse1	:=	aClone(aNOVO)
EndIf

If lBrowseCriado //APENAS quando o WBrowse1 ja tiver sido criado

	oWBrowse1:bLine := {|| {;
      If(aWBrowse1[oWBrowse1:nAT,1],oOk,oNo),;
	     aWBrowse1[oWBrowse1:nAt,2],;
     	 aWBrowse1[oWBrowse1:nAt,3],;
     	 aWBrowse1[oWBrowse1:nAt,4],;                			
     	 aWBrowse1[oWBrowse1:nAt,5],;
     	 aWBrowse1[oWBrowse1:nAt,6],;
     	 IIF(aWBrowse1[oWBrowse1:nAt,5]>0,aWBrowse1[oWBrowse1:nAT,1]:=.T.,aWBrowse1[oWBrowse1:nAT,1]:=.F.);
    }}
    oWBrowse1:Refresh()
	
Else

    @ 066, 015 LISTBOX oWBrowse1 Fields HEADER "","Cod.Prod.","Nome Prod.","Qt.Estoque","Quant.","" SIZE 250, 150 OF oDlg PIXEL ColSizes 38,38//50,50
    oWBrowse1:Lhscroll:=.F. //Desabilita o scroll horizontal
    oWBrowse1:SetArray(aWBrowse1)
    oWBrowse1:bLine := {|| {;
      If(aWBrowse1[oWBrowse1:nAT,1],oOk,oNo),;
	     aWBrowse1[oWBrowse1:nAt,2],;
     	 aWBrowse1[oWBrowse1:nAt,3],;
     	 aWBrowse1[oWBrowse1:nAt,4],;                			
     	 aWBrowse1[oWBrowse1:nAt,5],;
     	 aWBrowse1[oWBrowse1:nAt,6],;
     	 IIF(aWBrowse1[oWBrowse1:nAt,5]>0,aWBrowse1[oWBrowse1:nAT,1]:=.T.,aWBrowse1[oWBrowse1:nAT,1]:=.F.);
    }}

    oWBrowse1:bLDblClick := {||	 EditaTela("1","Digite quantidade"), oWBrowse1:Refresh()}

EndIf

DbSelectArea("QRY")
DbCloseArea()

Return

/*����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o   � EditaTela � Autor � Murilo Swistalski      � Data �29/03/2010���
��������������������������������������������������������������������������Ĵ��
���Descri��o� Monta a tela para a edicao do ListBox                        ���
��������������������������������������������������������������������������Ĵ��
��� Uso     � Especifico para Criacao/Alteracao da Agenda JOB - WDB		   ���
���������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������*/
//Static Function EditTela(cTipo,aWBrowse1,oWBrowse1,cDescr1,cDescr2,lUltAlt)
Static Function EditaTela(cTipo,cDescr1)
Local oEditTela,oQtUtil,cQtUtil := 0
Local nInterfere := 2
Local oInterfereoSButton1,oSButton2
Local nOpc:=0,nLin:=0
Local lOk:=.F.

If cTipo=="1".And.(oWBrowse1:nAt<=len(aWBrowse1))

	nQtUtil:=aWBrowse1[oWBrowse1:nAt][5]
	nInterfere:=IIF(aWBrowse1[oWBrowse1:nAt][6]=="*",1,2)
	
	Do While !lOk
		  
		  DEFINE MSDIALOG oEditTela TITLE cDescr1 FROM 000, 000  TO 080, 255 COLORS 0, 16777215 PIXEL

			@ 008, 005 MSGET cQtUtil VAR nQtUtil PICTURE "@E 9,999,999" VALID (nQtUtil>=0) SIZE 116, 010 OF oEditTela COLORS 0, 16777215 PIXEL
		    DEFINE SBUTTON oSButton1 FROM 025, 065 TYPE 01 OF oEditTela ENABLE ACTION (lOk:=.T.,nOpc:=1,oEditTela:End())
		    DEFINE SBUTTON oSButton2 FROM 025, 095 TYPE 02 OF oEditTela ENABLE ACTION (lOk:=.T.,nOpc:=2,oEditTela:End())
		    @ 023, 005 RADIO oInterfere VAR nInterfere ITEMS "Interfere no pre�o","N�o interfere" SIZE 060, 023 OF oEditTela COLOR 0, 16777215 PIXEL

		  ACTIVATE MSDIALOG oEditTela CENTERED
		  		 
	End	
	If nOpc==1
		If nQtUtil > aWBrowse1[oWBrowse1:nAt][4]
			If MsgYesNo("Deseja efetuar Subloca��o?","Quantidade maior que Estoque")
				aWBrowse1[oWBrowse1:nAt][5]:=nQtUtil
			EndIf
		Else
			aWBrowse1[oWBrowse1:nAt][5]:=nQtUtil
		EndIf
		If nQtUtil > 0
			IIF(nInterfere==1, aWBrowse1[oWBrowse1:nAt][6]:="*",aWBrowse1[oWBrowse1:nAt][6]:=" ")
		Else
			nInterfere:=2
			aWBrowse1[oWBrowse1:nAt][6]:=" "
		EndIf
	Endif
EndIf
		
Return

/*����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o   � LimpaTela � Autor � Murilo Swistalski      � Data �31/03/2010���
��������������������������������������������������������������������������Ĵ��
���Descri��o� Limpa os campos da tela de Cadastro de Agendas			   ���
��������������������������������������������������������������������������Ĵ��
��� Uso     � Especifico para Criacao/Alteracao da Agenda JOB - WDB		   ���
���������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������*/
Static Function LimpaTela(cParam,cParam2)

DEFAULT cParam2 := .T.

If cParam == "Tudo"
	cTxtJob		:= Space(09)
	cTxtCodCli	:= Space(06)
	cTxtNomeCli	:= Space(30)
	cTxtLoja	:= Space(02)
	cTxtEvento	:= Space(30)
	cTxtLocal	:= Space(30)
	cTxtAgenda	:= Space(09)
	cTxtVersao	:= Space(05)
	cTxtDtIni	:= Space(10)
	cTxtDtFim	:= Space(10)

	@ 020, 040 MSGET oTxtJob 	 VAR cTxtJob	 SIZE 020, 010 OF oDlg COLORS 0, 16777215 PICTURE "@!" F3 "WDB" ON CHANGE ValidaJOB(ctxtJob:=TrataVar(ctxtJob)) HASBUTTON PIXEL
    @ 020, 105 MSGET oTxtCodCli	 VAR cTxtCodCli	 SIZE 020, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL  
    @ 020, 130 MSGET oTxtNomeCli VAR cTxtNomeCli SIZE 100, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL    
    @ 020, 250 MSGET oTxtLoja	 VAR cTxtLoja	 SIZE 015, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 035, 040 MSGET oTxtEvento	 VAR cTxtEvento	 SIZE 100, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL    
    @ 035, 165 MSGET oTxtLocal	 VAR cTxtLocal	 SIZE 100, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 050, 040 MSGET oTxtAgenda	 VAR cTxtAgenda	 SIZE 020, 010 OF oDlg COLORS 0, 16777215 PICTURE "@!" ON CHANGE ValidaAgenda(cTxtAgenda:=StrZero(Val(cTxtAgenda),9)) VALID Val(cTxtAgenda)<>0 PIXEL
    @ 050, 105 MSGET oTxtVerso	 VAR cTxtVersao	 SIZE 020, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL    
    @ 050, 165 MSGET oTxtDtIni	 VAR cTxtDtIni	 SIZE 035, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 050, 230 MSGET oTxtDtFim	 VAR cTxtDtFim	 SIZE 035, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL

	If cParam2    
	    MOSTRAGRID(.T.)
	EndIf

ElseIf cParam == "-JOB"
	@ 020, 105 MSGET oTxtCodCli	 VAR cTxtCodCli	 SIZE 020, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL  
    @ 020, 130 MSGET oTxtNomeCli VAR cTxtNomeCli SIZE 100, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL    
    @ 020, 250 MSGET oTxtLoja	 VAR cTxtLoja	 SIZE 015, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 035, 040 MSGET oTxtEvento	 VAR cTxtEvento	 SIZE 100, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL    
    @ 035, 165 MSGET oTxtLocal	 VAR cTxtLocal	 SIZE 100, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 050, 040 MSGET oTxtAgenda	 VAR cTxtAgenda	 SIZE 020, 010 OF oDlg COLORS 0, 16777215 PICTURE "@!" ON CHANGE ValidaAgenda(cTxtAgenda:=StrZero(Val(cTxtAgenda),9)) VALID Val(cTxtAgenda)<>0 PIXEL
    @ 050, 105 MSGET oTxtVerso	 VAR cTxtVersao	 SIZE 020, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL    
    @ 050, 165 MSGET oTxtDtIni	 VAR cTxtDtIni	 SIZE 035, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 050, 230 MSGET oTxtDtFim	 VAR cTxtDtFim	 SIZE 035, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
 
	If cParam2    
	    MOSTRAGRID(.T.)
	EndIf
	
ElseIf cParam == "Grid"
	MOSTRAGRID(.T.) 
ElseIf cParam == "Var"
	cTxtJob		:= Space(09)
	cTxtCodCli	:= Space(06)
	cTxtNomeCli	:= Space(30)
	cTxtLoja	:= Space(02)
	cTxtEvento	:= Space(30)
	cTxtLocal	:= Space(30)
	cTxtAgenda	:= Space(09)
	cTxtVersao	:= Space(05)
	cTxtDtIni	:= Space(10)
	cTxtDtFim	:= Space(10)
	
EndIf

Return

/*����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o   �GravaAgenda� Autor � Murilo Swistalski      � Data �01/04/2010���
��������������������������������������������������������������������������Ĵ��
���Descri��o� Grava a agenda com as informacoes selecionadas			   ���
��������������������������������������������������������������������������Ĵ��
��� Uso     � Especifico para Criacao/Alteracao da Agenda JOB - WDB		   ���
���������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������*/
Static Function GravaAgenda(nOpc)

Local nCont		 := 0
Local nContaItem := 0
Local cReserva

If nOpc == 3 .Or. nOpc == 4//Incluir sempre nova para 3 ou 4 (incluir/alterar)

	//INCLUIR RESERVA(SZ3) dos produtos selecionados no grid com quant > 0
	//pegar o numero da reserva
	//ATUALIZAR AGENDA(SZ2) para campo ATIVA = .F. de todas as versoes anteriores de agenda selecionada
	//INCLUIR AGENDA(SZ2) com as informacoes das variaveis public e incluir numero da reserva 
    BEGIN TRANSACTION

	clQry := "SELECT TOP 1 Z3_RESERVA "
	clQry += "FROM SZ3990 "
	clQry += "ORDER BY Z3_RESERVA DESC"

	clQry := ChangeQuery( clQry )
	dbUseArea( .T., "TopConn", TCGenQry(,,clQry), "QZ3", .F., .F. )
	                  
	QZ3->( dbEval( {|| nCont++ } ) )
	QZ3->( dbGoTop() )

	If QZ3->( !Eof() )
        cUltReserva := QZ3->Z3_RESERVA
    Else
		cUltReserva := Replicate("0",9)
	EndIf

	cReserva := StrZero(Val(cUltReserva)+1,9)	
	For i:=1 to Len(aWBrowse1)
		If aWBrowse1[i][5] > 0
			RecLock( "SZ3", .T. )
				nContaItem++
				SZ3->Z3_RESERVA	 := cReserva
				SZ3->Z3_ITEM	 := StrZero(nContaItem,5)
				SZ3->Z3_CODPROD	 := aWBrowse1[i][2]
				SZ3->Z3_QTPROD	 := aWBrowse1[i][5]
				SZ3->Z3_PRECO	 := IIF(aWBrowse1[i][6]=="*","1","0")
			SZ3->(MsUnLock())
		EndIf 
	Next

	dbSelectArea("SZ2")
    dbSetOrder(1)
	If dbSeek(cTxtJob + cTxtAgenda)
		While !EOF() .AND. cTxtJob + cTxtAgenda == SZ2->Z2_CODJOB + SZ2->Z2_AGENDA
		    Reclock("SZ2",.F.)
		    SZ2->Z2_ATIVA := "0"
	    	SZ2->(MsUnlock())
			dbSkip()
		End
	EndIf
	
	Reclock("SZ2",.T.)
	SZ2->Z2_CODJOB	:=	cTxtJob	
	SZ2->Z2_AGENDA	:=	cTxtAgenda
	SZ2->Z2_VERSAO	:=	cTxtVersao
	SZ2->Z2_RESERVA	:=	cReserva
	SZ2->Z2_ATIVA	:=	"1"
	SZ2->Z2_FILIAL	:= xFilial("SZ2")
	SZ2->(MsUnlock())
	
	END TRANSACTION
	
	MsgInfo("Agenda inclu�da com Sucesso!","Agenda OK")
	
	DbSelectArea("QZ3")                           			
	DbCloseArea()
	
EndIf

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � LegAgenda� Autor � Murilo Swistalski     � Data �05/04/2010���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de Legendas do Cadastro de Agendas de JOBs		  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para Criacao/Alteracao da Agenda JOB - WDB      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function LegAgenda(cAlias,nReg,nOpc)

Local aLegenda := {}

AADD(aLegenda,{"BR_VERDE"		 ,"Vers�o Ativa da Agenda"	 })
AADD(aLegenda,{"BR_VERMELHO"	 ,"Vers�o Inativa da Agenda" })
AADD(aLegenda,{"BR_AZUL"		 ,"Vers�o Or�ada da Agenda"	 })

BrwLegenda(cCadastro, "Vers�o de Agenda", aLegenda)

RETURN NIL

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � PassaInfo� Autor � Murilo Swistalski     � Data �05/04/2010���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Passa as informacoes referentes a agenda selecionada		  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� nReg  -  Numero do R_E_C_N_O_ da Tabela SZ2				  ���
�������������������������������������������������������������������������Ĵ��
��� Retorno  � Retorna array contendo o aWBrowse1 da Agenda JOB - WDB     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para Criacao/Alteracao da Agenda JOB - WDB      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function PassaInfo(nReg)
Local nCont	:= 0
Local aNOVO := {}

dbSelectArea("SZ2")
dbGoto(nReg)
cTxtJob := SZ2->Z2_CODJOB

clQry := "SELECT Z2_CODJOB "
clQry += "FROM "+RetSqlName("SZ2")+" SZ2 "
clQry += "WHERE R_E_C_N_O_ = " + Alltrim(Str(nReg))

clQry := ChangeQuery( clQry )
dbUseArea( .T., "TopConn", TCGenQry(,,clQry), "QZ2", .F., .F. )
                  
QZ2->( dbEval( {|| nCont++ } ) )
QZ2->( dbGoTop() )

If QZ2->( !Eof() )
	cTxtJob := QZ2->Z2_CODJOB
	ValidaJOB(QZ2->Z2_CODJOB,.F.)
EndIf

DbSelectArea("QZ2")                           			
DbCloseArea()

//Informacoes sobre Agenda - Reserva
clQry := "SELECT Z2_CODJOB, B1_COD, B1_DESC, B2_QATU, Z3_QTPROD, Z3_PRECO "
clQry += "FROM   ("
clQry += "	   SELECT B1_COD, B1_DESC, B2_QATU"
clQry += "	   FROM SB1990 SB1"
clQry += "	   INNER JOIN SB2990 SB2 ON  B2_FILIAL = B1_FILIAL AND"
clQry += "  	   		 		  	  	 B2_COD	   = B1_COD	   AND"
clQry += "							  	 B2_LOCAL  = B1_LOCPAD"
clQry += "	   ) SB1 "
clQry += "LEFT JOIN ("
clQry += "	 	  SELECT Z2_CODJOB, Z3_CODPROD, Z3_QTPROD, Z3_PRECO"
clQry += "		  FROM ("
clQry += "	 	  	   SELECT *"
clQry += "	 	  	   FROM SZ2990" 
clQry += "	 	  	   WHERE R_E_C_N_O_ = " + Alltrim(Str(nReg))
clQry += "	 		   ) SZ2"
clQry += "		  INNER JOIN SZ3990 SZ3 ON SZ2.Z2_RESERVA = SZ3.Z3_RESERVA"
clQry += "		  ) SZ3 ON B1_COD = Z3_CODPROD"

clQry := ChangeQuery( clQry )
dbUseArea( .T., "TopConn", TCGenQry(,,clQry), "QZ3", .F., .F. )
                  
QZ3->( dbEval( {|| nCont++ } ) )
QZ3->( dbGoTop() )

While QZ3->( !Eof() )
	Aadd(aNOVO,{IIF(QZ3->Z2_CODJOB==Space(9),.F.,.T.),;
				QZ3->B1_COD,;
				QZ3->B1_DESC,;
				QZ3->B2_QATU,;
				IIF(QZ3->Z3_QTPROD==Nil,0,QZ3->Z3_QTPROD),;
				IIF(QZ3->Z3_PRECO=="0","",IIF(QZ3->Z3_PRECO=="1","*",""))})
	dbSkip()
EndDo
 
DbSelectArea("QZ3")                           			
DbCloseArea()
                      
Return aNOVO

/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    �AtivaAgenda� Autor � Murilo Swistalski      � Data �07/04/2010���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Ativa Agenda de JOB anteriormente com Status Inativo			���
���������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para Criacao/Alteracao da Agenda JOB - WDB		���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function AtivaAgenda(cAlias,nReg,nOpc)
Local cChave := ""

dbSelectArea(cAlias)
dbSetOrder(1)
dbGoto(nReg)
If (cAlias)->Z2_ATIVA == "2" //agenda ja virou orcamento
	MsgStop("Esta vers�o j� gerou um Or�amento!","Imposs�vel Utilizar")
ElseIf (cAlias)->Z2_ATIVA == "1"
	MsgAlert("Esta vers�o j� est� ativa!")
Else
	If APMsgYesNo("Todas as demais vers�es ser�o desativadas"+chr(13)+;
				  "Se houver OR�AMENTO gerado de outras vers�es, ser� Cancelado!"+chr(13)+;
				  "Se houver PEDIDO relacionado ao Or�amento, ser� Exclu�do!"+chr(13)+;
				  "Se houver NOTA FISCAL de Sa�da gerada, N�O SER� EXCLU�DA!",;
				  "Deseja realmente ativar o Status da Agenda "+(cAlias)->Z2_AGENDA+", vers�o "+(cAlias)->Z2_VERSAO +"?")
        
		cChave := (cAlias)->Z2_CODJOB + (cAlias)->Z2_AGENDA
		If dbSeek(cChave)
			While !EOF() .AND. cChave == (cAlias)->Z2_CODJOB + (cAlias)->Z2_AGENDA
			
				BEGIN TRANSACTION
				
			    If (cAlias)->Z2_ATIVA == "2"

			    	aAreaAnt := GetArea()
			    	dbSelectArea("SCJ")
			    	dbSetOrder(`1)
			    	
			    	If SCJ->(dbSeek(xFilial("SCJ")+Right((cAlias)->Z2_AGENDA,6)))
			    		//foi gerado orcamento, cancelar
						Reclock("SCJ",.F.)
						SCJ->CJ_STATUS == "C"
						SCJ->(MsUnlock())
						
						dbSelectArea("SCK")
						dbSetOrder(1)
						SCK->(dbSeek(xFilial("SCK")+SCJ->CJ_NUM))
						
						dbSelectArea("SC5")
						dbSetOrder(1)
						
						If SC5->(dbSeek(xFilial("SC5")+SCK->CK_NUMPV))
                            //foi gerado pedido de venda, excluir pedido e itens
							dbSelectArea("SC6")
							dbSetOrder(1)
							SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))
							
							While !EOF() .AND. SC5->C5_NUM == SC6->C6_NUM
								Reclock("SC6",.F.)
								dbDelete()
								SC6->(MsUnlock())
								dbSkip()
							End
							
							Reclock("SC5",.F.)
							dbDelete()
							SC5->(MsUnlock())
							
						EndIf
						
					EndIf
					
					dbSelectArea(cAlias)
					RestArea(aAreaAnt)

			    EndIf
   				If (cAlias)->Z2_ATIVA $ "12"
				    Reclock("SZ2",.F.)
				    (cAlias)->Z2_ATIVA := "0"
			    	(cAlias)->(MsUnlock())
			    EndIf
			    
			    END TRANSACTION
			    
				dbSkip()
			End
		EndIf
	    
		(cAlias)->(dbGoto(nReg))
		Reclock("SZ2",.F.)
	    (cAlias)->Z2_ATIVA := "1"
    	(cAlias)->(MsUnlock())
		
		MsgInfo("Status da Agenda " + (cAlias)->Z2_AGENDA + " ,Vers�o " + (cAlias)->Z2_VERSAO + " foi alterada com sucesso!","Status Ativado")
	End	
EndIf

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GeraOrc  � Autor � Murilo Swistalski     � Data �07/04/2010���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Gera Orcamento a partir de uma Agenda de JOB				  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para Criacao/Alteracao da Agenda JOB - WDB      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function GeraOrc(cAlias,nReg,nOpc)
Local nCont		:= 0
Local cCondPag	:= ""
Local cLojaCli	:= ""
Local cCodCli	:= ""
Local cNovoOrc	:= ""
Local nContaItem:= 0
Local cEmissao	:= ""
Local cTexto	:= ""

dbSelectArea(cAlias)
dbGoto(nReg)

If (cAlias)->Z2_ATIVA == "2"
	MsgStop("Esta Agenda j� gerou um Or�amento!","Imposs�vel Continuar")
ElseIf (cAlias)->Z2_ATIVA == "0"
	MsgAlert("Ative esta vers�o para gerar or�amento","Vers�o Inativa")
Else
	If APMsgYesNo("Deseja realmente gerar or�amento da Agenda "+(cAlias)->Z2_AGENDA+" e vers�o "+(cAlias)->Z2_VERSAO+"?")

		BEGIN TRANSACTION
	    		
		//Controle de numeracao de orcamento
//		cNovoOrc := GetSX8Num("SCJ","CJ_NUM")
//		cNovoOrc := (cAlias)->Z2_AGENDA
		cNovoOrc := IIF(Len((cAlias)->Z2_AGENDA)>6,Right((cAlias)->Z2_AGENDA,6),(cAlias)->Z2_AGENDA)
		
		dbSelectArea("SCJ")
		dbSetOrder(1)

		dbSelectArea("SCK")
		dbSetOrder(1)
		
		//Antes de incluir, verificar se existe orcamento com mesmo numero
		//	este caso pode ocorrer quando eh criado um orcamento e depois eh ativado o status de outra versao
		//	neste caso o orcamento nao eh excluido, apenas cancelado - podendo ocorrer erro no momento de salvar um novo
		
		If SCJ->(dbSeek(xFilial("SCJ")+cNovoOrc))
			If SCJ->CJ_STATUS == "B"
				MsgStop("Foi encontrado orcamento com mesma numeracao."+chr(13)+"Verifique no cadastro de Or�amentos a possibilidade da exclus�o deste or�amento n." + cNovoOrc,;
						"Imposs�vel Continuar")
				DISARMTRANSACTION()
				Return Nil
			ElseIf SCJ->CJ_STATUS == "A"
				cTexto := "Aberto"
			ElseIf SCJ->CJ_STATUS == "C"
				cTexto := "Cancelado"
			EndIf
			MsgAlert("Encontrado or�amento "+cTexto+" de n." + cNovoOrc,"Or�amento Encontrado!")
			If  APMsgYesNo("Ser� necess�rio excluir este or�amento para incluir um novo or�amento com o mesmo n�mero"+chr(13)+;
							"Deseja Excluir Or�amento "+cTexto+" ?","Or�amento Encontrado")

				dbSeek(xFilial("SCK")+SCJ->CJ_NUM)
				While !EOF() .AND. SCJ->CJ_NUM == SCK->CK_NUM
					Reclock("SCK",.F.)
					dbDelete()
					SCK->(MsUnlock())
					dbSkip()
				End
				RecLock( "SCJ", .F. )
				dbDelete()
				SCJ->(MsUnlock())
				
			Else
				DISARMTRANSACTION()
				Return Nil
			EndIf
		EndIf
		
		clQry := "SELECT Z2_AGENDA, A1_COD, A1_LOJA, Z1_DTINI, Z1_DTFIM "
		clQry += "FROM "+RetSqlName("SZ2")+" SZ2 "
		clQry += "INNER JOIN "+RetSqlName("SZ1")+" SZ1 ON SZ1.Z1_CODJOB = SZ2.Z2_CODJOB"
		clQry += " LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_COD	 = SZ1.Z1_CLIENTE "
		clQry += "WHERE SZ2.R_E_C_N_O_ = " + Alltrim(Str(nReg))
		
		clQry := ChangeQuery( clQry )
		dbUseArea( .T., "TopConn", TCGenQry(,,clQry), "QZ2", .F., .F. )
		                  
		QZ2->( dbEval( {|| nCont++ } ) )
		QZ2->( dbGoTop() )
		
		If QZ2->( !Eof() ) .And. !Empty(QZ2->A1_COD)
			cLojaCli	:= QZ2->A1_LOJA
			cCodCli		:= QZ2->A1_COD			
        Else
        	MsgStop("Erro: Cliente n�o encontrado!","Entre em contato com o Administrador do Sistema")
        	DISARMTRANSACTION()
        	Return Nil
		EndIf
        
		clQry := "SELECT Z3_QTPROD, B1_COD, B1_DESC, B1_UM, B1_PRV1, B1_UPRC, B1_TS "
		clQry += "FROM "+RetSqlName("SZ2")+" SZ2 "
		clQry += "INNER JOIN "+RetSqlName("SZ3")+" SZ3 ON SZ3.Z3_RESERVA = SZ2.Z2_RESERVA"
		clQry += " LEFT JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_COD = SZ3.Z3_CODPROD "
		clQry += "WHERE SZ2.R_E_C_N_O_ = " + Alltrim(Str(nReg))
		
		clQry := ChangeQuery( clQry )
		dbUseArea( .T., "TopConn", TCGenQry(,,clQry), "QZ3", .F., .F. )
		                  
		QZ3->( dbEval( {|| nCont++ } ) )
		QZ3->( dbGoTop() )
		
		If ! ( QZ3->( !Eof() ) )
			MsgStop("Erro: Produtos reservados n�o encontrados!","Entre em contato com o Administrador do Sistema")        
			DISARMTRANSACTION()
			Return Nil
		EndIf
		
		cCondPag := SuperGetMV("MV_CONDPAD",.F.,"")		
		If Alltrim(cCondPag) == ""
			MsgStop("Erro: Par�metro MV_CONDPAD deve ser configurado corretamente","Cond. de Pagto Inv�lido")
			DISARMTRANSACTION()
        	Return Nil
		EndIf
		
		RecLock( "SCJ", .T. )
			SCJ->CJ_FILIAL	:= xFilial(cAlias)
			SCJ->CJ_NUM		:= cNovoOrc //Soma1(cNovoOrc)
			SCJ->CJ_EMISSAO	:= Date()
			SCJ->CJ_LOJA	:= cLojaCli
			SCJ->CJ_CLIENT	:= cCodCli
			SCJ->CJ_CLIENTE	:= cCodCli
			SCJ->CJ_LOJAENT	:= cLojaCli
			SCJ->CJ_CONDPAG	:= cCondPag
			SCJ->CJ_VALIDA	:= CTOD(Right(QZ2->Z1_DTFIM,2)+"/"+Substr(QZ2->Z1_DTFIM,5,2)+"/"+Left(QZ2->Z1_DTFIM,4))	//Validade do orcamento para ultimo dia do Evento do JOB
			SCJ->CJ_TIPLIB	:= "1"
			SCJ->CJ_STATUS	:= "A"
			SCJ->CJ_MOEDA	:= 1 
			SCJ->CJ_TPCARGA	:= "2"
			SCJ->CJ_TXMOEDA	:= 1
		SCJ->(MsUnLock())

		nContaItem := 0		
		While QZ3->( !Eof() )
			RecLock( "SCK", .T. )
			nContaItem++
			SCK->CK_NUM		:= cNovoOrc
			SCK->CK_FILIAL	:= xFilial(cAlias)
			SCK->CK_ITEM	:= IIF(nContaItem<10,"0","") + Alltrim(Str(nContaItem))
			SCK->CK_CLIENTE	:= cCodCli
			SCK->CK_LOJA	:= cLojaCli
			SCK->CK_PRODUTO	:= QZ3->B1_COD
			SCK->CK_UM		:= QZ3->B1_UM
			SCK->CK_QTDVEN	:= QZ3->Z3_QTPROD
			SCK->CK_PRCVEN	:= QZ3->B1_PRV1 //IIF(!Empty(QZ3->B1_PRV1),QZ3->B1_PRV1,QZ3->B1_UPRC)
			SCK->CK_DESCRI	:= QZ3->B1_DESC
			SCK->CK_VALOR	:= QZ3->B1_PRV1 * QZ3->Z3_QTPROD //IIF(!Empty(QZ3->B1_PRV1),QZ3->Z3_QTPROD * QZ3->B1_PRV1,QZ3->Z3_QTPROD * QZ3->B1_UPRC) //valor total
			SCK->CK_TES		:= QZ3->B1_TS
			SCK->CK_LOCAL	:= "01" //""
			SCK->CK_ENTREG	:= CTOD(Right(QZ2->Z1_DTINI,2) +"/"+ SubStr(QZ2->Z1_DTINI,5,2)  +"/"+ Left(QZ2->Z1_DTINI,4))
			SCK->CK_FILVEN	:= xFilial(cAlias)
			SCK->CK_FILENT	:= xFilial(cAlias)
			SCK->CK_DT1VEN	:= CTOD(Right(QZ2->Z1_DTINI,2)+"/"+Substr(QZ2->Z1_DTINI,5,2)+"/"+Left(QZ2->Z1_DTINI,4))
			
			SCK->( MsUnLock() )
			QZ3->( dbSkip() )
		EndDo
		
	    Reclock("SZ2",.F.)
	    SZ2->Z2_ATIVA := "2"
    	SZ2->(MsUnlock())
    	
    	DbSelectArea("QZ2")
		DbCloseArea()
		
		DbSelectArea("QZ3")
		DbCloseArea()
		
		MsgInfo("Or�amento da Agenda " + (cAlias)->Z2_AGENDA + Chr(13) +;
				"Foi criado com sucesso para a vers�o " + (cAlias)->Z2_VERSAO + "!",;
				"Or�amento n."+cNovoOrc+" Gerado")
		
		MsgAlert("Favor entrar no or�amento n."+cNovoOrc+chr(13)+;
				 "Para verificar e corrigir poss�veis itens divergentes",;
				 "Verifique or�amento gerado")
		
		SCJ->(dbCloseArea())
		SCK->(dbCloseArea())
		
		END TRANSACTION

	Else
		MsgAlert("Gera��o do Or�amento cancelado","Cancelado")
	EndIf
    
EndIf

Return .T.

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �PosCliente� Autor � Murilo Swistalski     � Data �07/04/2010���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Posicionar o Cliente a partir do Codigo do Job			  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para Criacao/Alteracao da Agenda JOB - WDB      ���
��������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������*/
User Function PosCliente(cCodJob)
Local cCliente := ""

aAreaAnt := GetArea()
cCliente := POSICIONE("SA1",1,XFILIAL("SA1")+POSICIONE("SZ1",1,cCodJob,"Z1_CLIENTE"),"A1_NOME")
RestArea(aAreaAnt)

Return cCliente

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �PosEvento � Autor � Murilo Swistalski     � Data �07/04/2010���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Posicionar o Evento a partir do Codigo do Job			  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para Criacao/Alteracao da Agenda JOB - WDB      ���
��������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������*/
User Function PosEvento(cCodJob)
Local cEvento := ""

aAreaAnt := GetArea()
cEvento	 := Posicione("SZ1",1,SZ2->Z2_CODJOB,"Z1_EVENTO")
RestArea(aAreaAnt)

Return cEvento

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � PosDtIni � Autor � Murilo Swistalski     � Data �07/04/2010���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Posicionar o cDtIni a partir do Codigo do Job			  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para Criacao/Alteracao da Agenda JOB - WDB      ���
��������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������*/
User Function PosDtIni(cCodJob)
Local cDtIni := ""

aAreaAnt := GetArea()
cDtIni	 := Posicione("SZ1",1,SZ2->Z2_CODJOB,"Z1_DTINI")
RestArea(aAreaAnt)

Return cDtIni

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � PosDtFim � Autor � Murilo Swistalski     � Data �07/04/2010���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retornar o cDtFim a partir do Codigo do Job				  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para Criacao/Alteracao da Agenda JOB - WDB      ���
��������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������*/
User Function PosDtFim(cCodJob)
Local cDtFim := ""

aAreaAnt := GetArea()
cDtFim	 := Posicione("SZ1",1,SZ2->Z2_CODJOB,"Z1_DTFIM")
RestArea(aAreaAnt)

Return cDtFim

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � TrataVar � Autor � Murilo Swistalski     � Data �09/04/2010���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Trata variavel e retorna variavel valida					  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para Criacao/Alteracao da Agenda JOB - WDB      ���
��������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������*/
Static Function TrataVar(uVariavel)

If Val(uVariavel) == 0 .Or. Val(uVariavel) == Nil
	uVariavel := Alltrim(uVariavel)
Else
	uVariavel := StrZero(Val(cTxtJob),9)
EndiF

Return uVariavel  
