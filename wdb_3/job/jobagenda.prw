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

LOCAL aCores    := {	{'Z1_DTFIM< DATE()'	,'BR_VERMELHO'   },;	// JOB Encerrado/Em atraso
						{'Z1_DTFIM==DATE()'	,'BR_AMARELO'	 },;	// JOB na Data
						{'Z1_DTFIM> DATE()'	,'BR_VERDE'		 } }	// JOB em Andamento
      
PRIVATE cCadastro := 'Cadastro de JOBs'
PRIVATE aRotina   := {	{ 'Pesquisar' , 'AxPesqui' , 0, 1 },;
						{ 'Visualizar', 'AxVisual' , 0, 2 },;
						{ 'Incluir'   , 'AxInclui' , 0, 3 },;
						{ 'Alterar'   , 'AxAltera' , 0, 4 },;
						{ 'Excluir'   , 'U_ExcluiJOB',	0, 5, 3 },;
						{ 'Legenda'	  , 'U_LegendaJOB',	0, 6, 3 }}

MBrowse( ,,,,"SZ1",/* aFixe */,"Z1_DTFIM",/* nPar08 */,/* cFun */,/* nClickDef */,aCores,;
		 /* cTopFun */, /* cBotFun */, /* nPar14 */, /* bInitBloc */,/* lNoMnuFilter */, /* lSeeAll */, /* lChgAll */)
		 
RETURN



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

	IF APMsgYesNo("Deseja realmente excluir JOB selecionado?")
		
		//verifica se existe agenda aberta para este JOB
		DBSelectArea(cAlias)
		DBGoto(nReg)
		
		DBSelectArea("SZ2")
		IF SZ2->( DBSeek( (cAlias)->Z1_CODJOB) )
			MsgStop("Este JOB possui uma ou mais Agendas cadastradas","Exclus�o negada")
		ELSE
			DBSelectArea(cAlias)
			RecLock(cAlias,.F.,.T.)
			DBDelete()
			MsUnLock()
			MsgInfo("Concluido","JOB excluido com Sucesso!")
		ENDIF
		
		SZ2->(dbCloseArea())
		
	ENDIF
	
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

LOCAL aLegenda := {}

	AADD( aLegenda,{"BR_VERMELHO" ,"JOB Encerrado ou Em Atraso" })
	AADD( aLegenda,{"BR_AMARELO"	 ,"JOB na Data" })
	AADD( aLegenda,{"BR_VERDE"	 ,"JOB Aberto ou Em Andamento" })
	
	BrwLegenda(cCadastro, "Legenda", aLegenda)
	
RETURN( NIL )


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

LOCAL aCores    := {	{'Z2_ATIVA=="1"','BR_VERDE'		},;	// Agenda Ativa
						{'Z2_ATIVA=="0"','BR_VERMELHO'	},;	// Agenda Inativa
						{'Z2_ATIVA=="2"','BR_AZUL'		} }	// Agenda Ja efetuada orcamento

PRIVATE cCadastro := 'Cadastro de Agendas'
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


PRIVATE cCadastro := "Cadastro de Agendas"

PRIVATE oWBrowse1
PRIVATE aWBrowse1	:= {}
PRIVATE cTxtJob		:= SPACE(09)
PRIVATE cTxtCodCli	:= SPACE(06)
PRIVATE cTxtNomeCli	:= SPACE(30)
PRIVATE cTxtLoja	:= SPACE(02)
PRIVATE cTxtEvento	:= SPACE(30)
PRIVATE cTxtLocal	:= SPACE(30)
PRIVATE cTxtAgenda	:= SPACE(09)
PRIVATE cTxtVersao	:= SPACE(05)
PRIVATE cTxtDtIni	:= SPACE(10)
PRIVATE cTxtDtFim	:= SPACE(10)

	mBrowse( ,,,,"SZ2",,"Z2_ATIVA",,,,aCores)
	//mBrowse( ,,,,"SA1")
	
RETURN                                                     


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
USER FUNCTION ExcluiAgenda(cAlias,nReg,nOpc)

	MsgStop("N�o � permitido excluir agenda!", "Controle de Vers�o Ativado")
	
	DBUnLockAll()
	
RETURN


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

LOCAL cTipo		 := ""
LOCAL oTxtJob, oTxtAgenda, oTxtCodCli, oTxtNomeCli, oTxtEvento, oTxtLOCAL, oTxtLoja, oTxtVersao
LOCAL nOpca
LOCAL nCont		 := 0
LOCAL lGrava	 := .F.
LOCAL aNovoArray := {}

PRIVATE aHeader  := {}
PRIVATE aHeader  := {}
STATIC oDlg

	DBSelectArea("SZ1")
	
	AADD( aHeader,{"OK"			,"OK_SN"	,"@BMP"			, 5,0,"","","C","","V"})
	AADD( aHeader,{"Cod.Prod"	,"B1_COD"	,"@!"			,15,0,"","","C","",""})
	AADD( aHeader,{"Nome Prod."	,"B1_DESC"	,"@!"			,40,0,"","","C","",""})
	AADD( aHeader,{"QT.Estoque"	,"QTEST"	,"@E 999999.99" , 9,2,"","","N","",""})
	AADD( aHeader,{"Qt.Agenda"	,"QTD"		,"@E 999999.99" , 9,2,"","","N","",""})
	
	DO CASE
		CASE nOpc == 2
			cTipo := " - Visualizar"
			aNovoArray := PassaInfo(nReg)
			cTxtVersao := (cAlias)->Z2_VERSAO //StrZero(Val(cTxtVersao)-1,5)
			
		CASE nOpc == 3
			cTipo := " - Incluir"
			
		CASE nOpc == 4
			cTipo := " - Copiar" //" - Alterar"
			MsgAlert("C�pia de vers�o selecionada." + chr(13) + "N�mero de vers�o ser� atualizada!", "Controle de Vers�o Ativado")
			aNovoArray := PassaInfo(nReg)
			
		CASE nOpc == 5
			cTipo := " - Excluir"
			MsgStop("N�o � permitido excluir agenda!", "Controle de Vers�o Ativado")
			RETURN
			
	ENDCASE
	
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
	@ 035, 165 MSGET oTxtLocal VAR cTxtLOCAL SIZE 100, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
	
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
		FOR nPos := 1 TO LEN(aWBrowse1)
			IF aWBrowse1[nPos][5] > 0   //aWBrowse1[oWBrowse1:nAt][5]
				lGrava := .T.
			ENDIF
		NEXT
		
		IF .NOT. (lGrava)
			cErro += "QT"
		ENDIF
		
		//verifica se o numero da agenda foi digitado e se esta correto
		IF lGrava
			IF VAV( cTxtAgenda ) <= 0
				lGrava :=.F.
				cErro  += "AG"
			ENDIF
		ENDIF
		
		IF .NOT. lGrava
			IF cErro == "QTAG"
				MsgAlert("Verifique se h� produto selecionado"+chr(13)+"e se o codigo da agenda est� correto.","Imposs�vel Gravar")
			ELSEIF cErro == "QT"
				MsgAlert("Verifique se h� produto selecionado ou se as quantidades foram informadas","Imposs�vel Gravar")
			ELSEIF cErro == "AG"
				MsgAlert("Verifique se o codigo da agenda/vers�o est� correto.","Imposs�vel Gravar")
			ENDIF
		ENDIF
		
		IF lGrava
			GravaAgenda(nOpc)
		ENDIF
		
	ELSEIF nOpcA == 1 .AND. nOpc == 2
		MsgStop("N�o � permitido efetuar altera��es!","Visualizar Agenda")
	ELSEIF nOpcA == 2
		
	ENDIF
	
	IF lGrava
		LimpaTela("Var")
	ENDIF
	
RETURN      


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
STATIC Function ValidaJOB(cJOB,cParam)

LOCAL nCont := 0
LOCAL clQry

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
	DBUseArea( .T., "TopConn", TCGenQry(,,clQry), "QZ1", .F., .F. )
	
	QZ1->( DBEval( {|| nCont++ } ) )
	QZ1->( DBGoTop() )
	
	IF QZ1->( .NOT. EOF() )
		//atualizar campos
		cTxtCodCli	:= QZ1->Z1_CLIENTE
		cTxtNomeCli	:= QZ1->A1_NOME
		cTxtLoja	:= QZ1->Z1_LOJA
		cTxtEvento	:= QZ1->Z1_EVENTO
		cTxtLocal	:= QZ1->Z1_LOCAL
		cTxtAgenda	:= IIF( QZ1->Z2_AGENDA == SPACE(9), STRZERO(1,9), STRZERO( VAL( QZ1->Z2_AGENDA ), 9 ) )
		cTxtVersao	:= IIF( QZ1->Z2_VERSAO == SPACE(5), STRZERO(1,5), STRZERO( VAL( QZ1->Z2_VERSAO ) +1, 5 ) )
		cTxtDtIni	:= RIGHT( QZ1->Z1_DTINI, 2) + "/" + SUBSTR( QZ1->Z1_DTINI, 5, 2) + "/" + LEFT( QZ1->Z1_DTINI, 4)
		cTxtDtFim	:= RIGHT( QZ1->Z1_DTFIM, 2) + "/" + SUBSTR( QZ1->Z1_DTFIM, 5, 2) + "/" + LEFT( QZ1->Z1_DTFIM, 4)
		
		IF cParam
			LimpaTela("-JOB")
		ENDIF
	ELSE
		LimpaTela("Tudo")
		
		MsgAlert("JOB n�o encontrado!")
	ENDIF
	
	DBSelectArea("QZ1")
	DBCloseArea()
	
RETURN .T.


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
STATIC FUNCTION ValidaAgenda(cTxtAgenda) 

LOCAL nCont := 0
LOCAL clQry

	clQry := "SELECT TOP 1 "
	clQry += "		 Z2_CODJOB, Z2_AGENDA, Z2_VERSAO, Z2_RESERVA, Z2_ATIVA "
	clQry += "FROM "+RetSqlName("SZ2")+" SZ2 "
	clQry += "WHERE Z2_CODJOB = '" + STRZERO( VAL( cTxtJob ), 9) + "' "
	clQry += "	AND Z2_AGENDA = '" + STRZERO( VAL( cTxtAgenda ), 9) + "' "
	clQry += "ORDER BY Z2_AGENDA, Z2_VERSAO DESC"
	
	clQry := ChangeQuery( clQry )
	dbUseArea( .T., "TopConn", TCGenQry(,,clQry), "QZ2", .F., .F. )
	
	QZ2->( DBEval( {|| nCont++ } ) )
	QZ2->( DBGoTop() )
	
	IF QZ2->( .NOT. Eof() )
		
		//agenda encontrada, valida versao
		cTxtVersao := STRZERO( VAL( QZ2->Z2_VERSAO ) +1, 5 )
		@ 050, 105 MSGET oTxtVerso	 VAR cTxtVersao	 SIZE 020, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
		
	ELSE
		
		//nao encontrou
		cTxtAgenda := STRZERO( VAL( cTxtAgenda ), 9)
		cTxtVersao := STRZERO( 1, 5 )
		@ 050, 040 MSGET oTxtAgenda	 VAR cTxtAgenda	 SIZE 020, 010 OF oDlg COLORS 0, 16777215 PICTURE "@!" ON CHANGE ValidaAgenda( cTxtAgenda := STRZERO( VAL( cTxtAgenda ), 9 ) ) VALID VAL( cTxtAgenda ) <> 0 PIXEL
		@ 050, 105 MSGET oTxtVerso	 VAR cTxtVersao	 SIZE 020, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
	ENDIF
	
	DBSelectArea("QZ2")
	DBCloseArea()
	
RETURN


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
STATIC FUNCTION MOSTRAGRID(lBrowseCriado,aNOVO)

LOCAL oOk := LoadBitmap( GetResources(), "LBOK")
LOCAL oNo := LoadBitmap( GetResources(), "LBNO")
LOCAL nCont
LOCAL clQry

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
	DBUseArea( .T., "TopConn", TCGenQry(,,clQry), "QRY", .F., .F. )
	
	QRY->( DBEval( {|| nCont++ } ) )
	QRY->( DBGoTop() )
	
	DBSelectArea("QRY")
	QRY->(DBGoTop())
	
	ASIZE( aWBrowse1, 0) //zera o array
	
	WHILE QRY->( .NOT. EOF() )
		AADD(aWBrowse1,{.F.,QRY->B1_COD,QRY->B1_DESC,QRY->QTEST,0,""})
		QRY->( DBSkip() )
	ENDDO
	
	IF LEN( aNOVO ) > 0
		aWBrowse1 := ACLONE( aNOVO )
	ENDIF
	
	IF lBrowseCriado //APENAS quando o WBrowse1 ja tiver sido criado
		
		oWBrowse1:bLine := {|| {;
		IF(aWBrowse1[oWBrowse1:nAT,1],oOk,oNo),;
			aWBrowse1[oWBrowse1:nAt,2],;
			aWBrowse1[oWBrowse1:nAt,3],;
			aWBrowse1[oWBrowse1:nAt,4],;
			aWBrowse1[oWBrowse1:nAt,5],;
			aWBrowse1[oWBrowse1:nAt,6],;
			IIF(aWBrowse1[oWBrowse1:nAt,5]>0,aWBrowse1[oWBrowse1:nAT,1]:=.T.,aWBrowse1[oWBrowse1:nAT,1]:=.F.);
			}}
			oWBrowse1:Refresh()
			
	ELSE
			
			@ 066, 015 LISTBOX oWBrowse1 Fields HEADER "","Cod.Prod.","Nome Prod.","Qt.Estoque","Quant.","" SIZE 250, 150 OF oDlg PIXEL ColSizes 38,38//50,50
			oWBrowse1:Lhscroll:=.F. //Desabilita o scroll horizontal
			oWBrowse1:SetArray(aWBrowse1)
			oWBrowse1:bLine := {|| {;
			IF(aWBrowse1[oWBrowse1:nAT,1],oOk,oNo),;
				aWBrowse1[oWBrowse1:nAt,2],;
				aWBrowse1[oWBrowse1:nAt,3],;
				aWBrowse1[oWBrowse1:nAt,4],;
				aWBrowse1[oWBrowse1:nAt,5],;
				aWBrowse1[oWBrowse1:nAt,6],;
				IIF(aWBrowse1[oWBrowse1:nAt,5]>0,aWBrowse1[oWBrowse1:nAT,1]:=.T.,aWBrowse1[oWBrowse1:nAT,1]:=.F.);
				}}
				
				oWBrowse1:bLDblClick := {||	 EditaTela("1","Digite quantidade"), oWBrowse1:Refresh()}
				
	ENDIF
			
	DBSelectArea("QRY")
	DBCloseArea()
	
RETURN

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
STATIC FUNCTION EditaTela(cTipo,cDescr1)

LOCAL oEditTela,oQtUtil,cQtUtil := 0
LOCAL nInterfere := 2
LOCAL oInterfereoSButton1,oSButton2
LOCAL nOpc:=0,nLin:=0
LOCAL lOk:=.F.

	IF cTipo == "1" .AND. ( oWBrowse1:nAt <= LEN( aWBrowse1 ) )
		
		nQtUtil    := aWBrowse1[ oWBrowse1:nAt ][5]
		nInterfere := IIF(aWBrowse1[ oWBrowse1:nAt ][6] == "*", 1, 2 )
		
		WHILE .NOT. lOk
			
			DEFINE MSDIALOG oEditTela TITLE cDescr1 FROM 000, 000  TO 080, 255 COLORS 0, 16777215 PIXEL
			
			@ 008, 005 MSGET cQtUtil VAR nQtUtil PICTURE "@E 9,999,999" VALID (nQtUtil>=0) SIZE 116, 010 OF oEditTela COLORS 0, 16777215 PIXEL
			DEFINE SBUTTON oSButton1 FROM 025, 065 TYPE 01 OF oEditTela ENABLE ACTION (lOk:=.T.,nOpc:=1,oEditTela:End())
			DEFINE SBUTTON oSButton2 FROM 025, 095 TYPE 02 OF oEditTela ENABLE ACTION (lOk:=.T.,nOpc:=2,oEditTela:End())
			@ 023, 005 RADIO oInterfere VAR nInterfere ITEMS "Interfere no pre�o","N�o interfere" SIZE 060, 023 OF oEditTela COLOR 0, 16777215 PIXEL
			
			ACTIVATE MSDIALOG oEditTela CENTERED
			
		ENDDO
		
		IF nOpc == 1
			
			IF nQtUtil > aWBrowse1[oWBrowse1:nAt][4]
				IF MsgYesNo("Deseja efetuar Subloca��o?","Quantidade maior que Estoque")
					aWBrowse1[oWBrowse1:nAt][5] := nQtUtil
				ENDIF
			ELSE
				aWBrowse1[oWBrowse1:nAt][5]:=nQtUtil
			ENDIF
			
			IF nQtUtil > 0
				IIF(nInterfere==1, aWBrowse1[oWBrowse1:nAt][6]:="*",aWBrowse1[oWBrowse1:nAt][6]:=" ")
			ELSE
				nInterfere:=2
				aWBrowse1[oWBrowse1:nAt][6]:=" "
			ENDIF
			
		ENDIF
		
	ENDIF
			
RETURN

/*����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o   � LimpaTela � Autor � Murilo Swistalski      � Data �31/03/2010���
��������������������������������������������������������������������������Ĵ��
���Descri��o� Limpa os campos da tela de Cadastro de Agendas			   ���
��������������������������������������������������������������������������Ĵ��
��� Uso     � Especifico para Criacao/Alteracao da Agenda JOB - WDB		   ���
���������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������*/
STATIC FUNCTION LimpaTela(cParam,cParam2)

DEFAULT cParam2 := .T.

	IF cParam == "Tudo"
		cTxtJob		:= SPACE(09)
		cTxtCodCli	:= SPACE(06)
		cTxtNomeCli	:= SPACE(30)
		cTxtLoja	:= SPACE(02)
		cTxtEvento	:= SPACE(30)
		cTxtLocal	:= SPACE(30)
		cTxtAgenda	:= SPACE(09)
		cTxtVersao	:= SPACE(05)
		cTxtDtIni	:= SPACE(10)
		cTxtDtFim	:= SPACE(10)
		
		@ 020, 040 MSGET oTxtJob 	 VAR cTxtJob	 SIZE 020, 010 OF oDlg COLORS 0, 16777215 PICTURE "@!" F3 "WDB" ON CHANGE ValidaJOB(ctxtJob:=TrataVar(ctxtJob)) HASBUTTON PIXEL
		@ 020, 105 MSGET oTxtCodCli	 VAR cTxtCodCli	 SIZE 020, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
		@ 020, 130 MSGET oTxtNomeCli VAR cTxtNomeCli SIZE 100, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
		@ 020, 250 MSGET oTxtLoja	 VAR cTxtLoja	 SIZE 015, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
		@ 035, 040 MSGET oTxtEvento	 VAR cTxtEvento	 SIZE 100, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
		@ 035, 165 MSGET oTxtLocal	 VAR cTxtLocal	 SIZE 100, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
		@ 050, 040 MSGET oTxtAgenda	 VAR cTxtAgenda	 SIZE 020, 010 OF oDlg COLORS 0, 16777215 PICTURE "@!" ON CHANGE ValidaAgenda(cTxtAgenda:=STRZERO(Val(cTxtAgenda),9)) VALID Val(cTxtAgenda)<>0 PIXEL
		@ 050, 105 MSGET oTxtVerso	 VAR cTxtVersao	 SIZE 020, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
		@ 050, 165 MSGET oTxtDtIni	 VAR cTxtDtIni	 SIZE 035, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
		@ 050, 230 MSGET oTxtDtFim	 VAR cTxtDtFim	 SIZE 035, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
		
		IF cParam2
			MOSTRAGRID(.T.)
		ENDIF
		
	ELSEIF cParam == "-JOB"
		
		@ 020, 105 MSGET oTxtCodCli	 VAR cTxtCodCli	 SIZE 020, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
		@ 020, 130 MSGET oTxtNomeCli VAR cTxtNomeCli SIZE 100, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
		@ 020, 250 MSGET oTxtLoja	 VAR cTxtLoja	 SIZE 015, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
		@ 035, 040 MSGET oTxtEvento	 VAR cTxtEvento	 SIZE 100, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
		@ 035, 165 MSGET oTxtLocal	 VAR cTxtLocal	 SIZE 100, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
		@ 050, 040 MSGET oTxtAgenda	 VAR cTxtAgenda	 SIZE 020, 010 OF oDlg COLORS 0, 16777215 PICTURE "@!" ON CHANGE ValidaAgenda(cTxtAgenda:=STRZERO(Val(cTxtAgenda),9)) VALID Val(cTxtAgenda)<>0 PIXEL
		@ 050, 105 MSGET oTxtVerso	 VAR cTxtVersao	 SIZE 020, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
		@ 050, 165 MSGET oTxtDtIni	 VAR cTxtDtIni	 SIZE 035, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
		@ 050, 230 MSGET oTxtDtFim	 VAR cTxtDtFim	 SIZE 035, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
		
		IF cParam2
			MOSTRAGRID(.T.)
		ENDIF
		
	ELSEIF cParam == "Grid"
		
		MOSTRAGRID(.T.)
		
	ELSEIF cParam == "Var"
		cTxtJob		:= SPACE(09)
		cTxtCodCli	:= SPACE(06)
		cTxtNomeCli	:= SPACE(30)
		cTxtLoja	:= SPACE(02)
		cTxtEvento	:= SPACE(30)
		cTxtLocal	:= SPACE(30)
		cTxtAgenda	:= SPACE(09)
		cTxtVersao	:= SPACE(05)
		cTxtDtIni	:= SPACE(10)
		cTxtDtFim	:= SPACE(10)
		
	ENDIF
	
RETURN

/*����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o   �GravaAgenda� Autor � Murilo Swistalski      � Data �01/04/2010���
��������������������������������������������������������������������������Ĵ��
���Descri��o� Grava a agenda com as informacoes selecionadas			   ���
��������������������������������������������������������������������������Ĵ��
��� Uso     � Especifico para Criacao/Alteracao da Agenda JOB - WDB		   ���
���������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������*/
STATIC FUNCTION GravaAgenda(nOpc)

LOCAL nCont		 := 0
LOCAL nContaItem := 0
LOCAL nPos
LOCAL cReserva
LOCAL clQry

	IF nOpc == 3 .Or. nOpc == 4//Incluir sempre nova para 3 ou 4 (incluir/alterar)
		
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
		
		QZ3->( DBEval( {|| nCont++ } ) )
		QZ3->( DBGoTop() )
		
		IF QZ3->( .NOT. EOF() )
			cUltReserva := QZ3->Z3_RESERVA
		ELSE
			cUltReserva := REPLICATE( "0", 9 )
		ENDIF
		
		cReserva := STRZERO( VAL( cUltReserva ) + 1, 9 )
		FOR nPos := 1 TO LEN( aWBrowse1 )
			IF aWBrowse1[ nPos ][5] > 0
				RecLock( "SZ3", .T. )
				nContaItem++
				SZ3->Z3_RESERVA	 := cReserva
				SZ3->Z3_ITEM	 := STRZERO(nContaItem,5)
				SZ3->Z3_CODPROD	 := aWBrowse1[nPos][2]
				SZ3->Z3_QTPROD	 := aWBrowse1[nPos][5]
				SZ3->Z3_PRECO	 := IIF(aWBrowse1[nPos][6]=="*","1","0")
				SZ3->(MsUnLock())
			ENDIF
		NEXT
		
		DBSelectArea("SZ2")
		SZ2->( DBSetOrder(1) )
		IF SZ2->( DBSeek(cTxtJob + cTxtAgenda) )
			WHILE SZ2->( .NOT. EOF() ) .AND. cTxtJob + cTxtAgenda == SZ2->Z2_CODJOB + SZ2->Z2_AGENDA
				Reclock("SZ2",.F.)
				SZ2->Z2_ATIVA := "0"
				SZ2->(MsUnlock())
				SZ2->( DBSkip() )
			ENDDO
		ENDIF
		
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
		
		DBSelectArea("QZ3")
		DBCloseArea()
		
	ENDIF
	
RETURN

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
USER FUNCTION LegAgenda(cAlias,nReg,nOpc)

LOCAL aLegenda := {}

	AADD(aLegenda,{"BR_VERDE"		 ,"Vers�o Ativa da Agenda"	 })
	AADD(aLegenda,{"BR_VERMELHO"	 ,"Vers�o Inativa da Agenda" })
	AADD(aLegenda,{"BR_AZUL"		 ,"Vers�o Or�ada da Agenda"	 })
	
	BrwLegenda(cCadastro, "Vers�o de Agenda", aLegenda)
	
RETURN( NIL )

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
STATIC FUNCTION PassaInfo(nReg)

LOCAL nCont	:= 0
LOCAL aNOVO := {}
LOCAL clQry

	DBSelectArea("SZ2")
	SZ2->( DBGoto(nReg) )
	cTxtJob := SZ2->Z2_CODJOB
	
	clQry := "SELECT Z2_CODJOB "
	clQry += "FROM "+RetSqlName("SZ2")+" SZ2 "
	clQry += "WHERE R_E_C_N_O_ = " + Alltrim(Str(nReg))
	
	clQry := ChangeQuery( clQry )
	dbUseArea( .T., "TopConn", TCGenQry(,,clQry), "QZ2", .F., .F. )
	
	QZ2->( DBEval( {|| nCont++ } ) )
	QZ2->( DBGoTop() )
	
	IF QZ2->( .NOT. EOF() )
		cTxtJob := QZ2->Z2_CODJOB
		ValidaJOB(QZ2->Z2_CODJOB,.F.)
	ENDIF
	
	DBSelectArea("QZ2")
	DBCloseArea()
	
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
	
	QZ3->( DBEval( {|| nCont++ } ) )
	QZ3->( DBGoTop() )
	
	WHILE QZ3->( .NOT. EOF() )
		AADD(aNOVO,{IIF(QZ3->Z2_CODJOB==SPACE(9),.F.,.T.),;
		QZ3->B1_COD,;
		QZ3->B1_DESC,;
		QZ3->B2_QATU,;
		IIF(QZ3->Z3_QTPROD==Nil,0,QZ3->Z3_QTPROD),;
		IIF(QZ3->Z3_PRECO=="0","",IIF(QZ3->Z3_PRECO=="1","*",""))})
		SZ2->( DBSkip() )
	ENDDO
	
	DBSelectArea("QZ3")
	DBCloseArea()
	                      
RETURN( aNOVO )

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
USER FUNCTION AtivaAgenda(cAlias,nReg,nOpc)

LOCAL cChave := ""

	DBSelectArea(cAlias)
	DBSetOrder(1)
	DBGoto(nReg)
	IF (cAlias)->Z2_ATIVA == "2" //agenda ja virou orcamento
		MsgStop("Esta vers�o j� gerou um Or�amento!","Imposs�vel Utilizar")
	ELSEIF (cAlias)->Z2_ATIVA == "1"
		MsgAlert("Esta vers�o j� est� ativa!")
	ELSE
		IF APMsgYesNo("Todas as demais vers�es ser�o desativadas"+chr(13)+;
			"Se houver OR�AMENTO gerado de outras vers�es, ser� Cancelado!"+chr(13)+;
			"Se houver PEDIDO relacionado ao Or�amento, ser� Exclu�do!"+chr(13)+;
			"Se houver NOTA FISCAL de Sa�da gerada, N�O SER� EXCLU�DA!",;
			"Deseja realmente ativar o Status da Agenda "+(cAlias)->Z2_AGENDA+", vers�o "+(cAlias)->Z2_VERSAO +"?")
			
			cChave := (cAlias)->Z2_CODJOB + (cAlias)->Z2_AGENDA
			IF DBSeek(cChave)
				WHILE .NOT. EOF() .AND. cChave == (cAlias)->Z2_CODJOB + (cAlias)->Z2_AGENDA
					
					BEGIN TRANSACTION
					
					IF (cAlias)->Z2_ATIVA == "2"
						
						aAreaAnt := GetArea()
						DBSelectArea("SCJ")
						SCJ->( DBSetOrder(1) )
						
						IF SCJ->( DBSeek(xFilial("SCJ")+RIGHT((cAlias)->Z2_AGENDA,6)))
							//foi gerado orcamento, cancelar
							Reclock("SCJ",.F.)
							SCJ->CJ_STATUS == "C"
							SCJ->(MsUnlock())
							
							DBSelectArea("SCK")
							SCK->( DBSetOrder(1) )
							SCK->( DBSeek(xFilial("SCK")+SCJ->CJ_NUM))
							
							DBSelectArea("SC5")
							SC5->( DBSetOrder(1) )
							
							IF SC5->( DBSeek(xFilial("SC5")+SCK->CK_NUMPV) )
								//foi gerado pedido de venda, excluir pedido e itens
								DBSelectArea("SC6")
								SC6->( DBSetOrder(1) )
								SC6->( DBSeek(xFilial("SC6")+SC5->C5_NUM) )
								
								WHILE .NOT. EOF() .AND. SC5->C5_NUM == SC6->C6_NUM
									Reclock("SC6",.F.)
									dbDelete()
									SC6->(MsUnlock())
									SC6->( DBSkip() )
								ENDDO
								
								Reclock("SC5",.F.)
								dbDelete()
								SC5->(MsUnlock())
								
							ENDIF
							
						ENDIF
						
						DBSelectArea(cAlias)
						RestArea(aAreaAnt)
						
					ENDIF
					
					IF (cAlias)->Z2_ATIVA $ "12"
						Reclock("SZ2",.F.)
						(cAlias)->Z2_ATIVA := "0"
						(cAlias)->(MsUnlock())
					ENDIF
					
					END TRANSACTION
					
					DBSkip()
					
				ENDDO
				
			ENDIF
			
			(cAlias)->( DBGoto(nReg) )
			Reclock("SZ2",.F.)
			(cAlias)->Z2_ATIVA := "1"
			(cAlias)->(MsUnlock())
			
			MsgInfo("Status da Agenda " + (cAlias)->Z2_AGENDA + " ,Vers�o " + (cAlias)->Z2_VERSAO + " foi alterada com sucesso!","Status Ativado")
			
		ENDIF
		
	ENDIF
	
RETURN

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
USER FUNCTION GeraOrc(cAlias,nReg,nOpc)

LOCAL nCont		:= 0
LOCAL cCondPag	:= ""
LOCAL cLojaCli	:= ""
LOCAL cCodCli	:= ""
LOCAL cNovoOrc	:= ""
LOCAL nContaItem:= 0
LOCAL cEmissao	:= ""
LOCAL cTexto	:= ""

DBSelectArea(cAlias)
DBGoto(nReg)

IF (cAlias)->Z2_ATIVA == "2"
	MsgStop("Esta Agenda j� gerou um Or�amento!","Imposs�vel Continuar")
ELSEIf (cAlias)->Z2_ATIVA == "0"
	MsgAlert("Ative esta vers�o para gerar or�amento","Vers�o Inativa")
ELSE
	IF APMsgYesNo("Deseja realmente gerar or�amento da Agenda "+(cAlias)->Z2_AGENDA+" e vers�o "+(cAlias)->Z2_VERSAO+"?")

		BEGIN TRANSACTION
	    		
		//Controle de numeracao de orcamento
//		cNovoOrc := GetSX8Num("SCJ","CJ_NUM")
//		cNovoOrc := (cAlias)->Z2_AGENDA
		cNovoOrc := IIF(Len((cAlias)->Z2_AGENDA)>6,RIGHT((cAlias)->Z2_AGENDA,6),(cAlias)->Z2_AGENDA)
		
		DBSelectArea("SCJ")
		SCJ->( DBSetOrder(1) )

		DBSelectArea("SCK")
		SCK->( DBSetOrder(1) )
		
		//Antes de incluir, verificar se existe orcamento com mesmo numero
		//	este caso pode ocorrer quando eh criado um orcamento e depois eh ativado o status de outra versao
		//	neste caso o orcamento nao eh excluido, apenas cancelado - podendo ocorrer erro no momento de salvar um novo
		
		IF SCJ->( DBSeek(xFilial("SCJ")+cNovoOrc) )
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
			SCJ->CJ_VALIDA	:= CTOD(RIGHT(QZ2->Z1_DTFIM,2)+"/"+SUBSTR(QZ2->Z1_DTFIM,5,2)+"/"+LEFT(QZ2->Z1_DTFIM,4))	//Validade do orcamento para ultimo dia do Evento do JOB
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
			SCK->CK_ENTREG	:= CTOD(RIGHT(QZ2->Z1_DTINI,2) +"/"+ SUBSTR(QZ2->Z1_DTINI,5,2)  +"/"+ LEFT(QZ2->Z1_DTINI,4))
			SCK->CK_FILVEN	:= xFilial(cAlias)
			SCK->CK_FILENT	:= xFilial(cAlias)
			SCK->CK_DT1VEN	:= CTOD(RIGHT(QZ2->Z1_DTINI,2)+"/"+SUBSTR(QZ2->Z1_DTINI,5,2)+"/"+LEFT(QZ2->Z1_DTINI,4))
			
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
LOCAL cCliente := ""

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
LOCAL cEvento := ""

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
LOCAL cDtIni := ""

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
LOCAL cDtFim := ""

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
	uVariavel := STRZERO(Val(cTxtJob),9)
EndiF

Return uVariavel  
