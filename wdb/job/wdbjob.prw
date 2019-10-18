//#INCLUDE "FINA010.CH"
//#INCLUDE "CTBA120.CH"
#INCLUDE "FONT.CH"			
#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CADJOB   ³ Autor ³ Murilo Swistalski     ³ Data ³25/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de Cadastro de JOBs                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION CADJOB()

Local aCores    := {	{'Alltrim(Z1_STATUS)=="" .OR. Z1_STATUS=="A"'	,'BR_AZUL'},;	// JOB 0% - Aberto
						{'Z1_STATUS=="B"' , 'BR_AMARELO'	},;	// JOB 25% - com chance, sem prioridade
						{'Z1_STATUS=="C"' , 'BR_PINK'		},;	// JOB 50% - Cliente deu retorno
						{'Z1_STATUS=="D"' , 'BR_LARANJA'	},;	// JOB 75% - em negociacao
						{'Z1_STATUS=="E"' , 'BR_BRANCO'		},;	// JOB 99% - Tentou fechar, nao tinha checklist
						{'Z1_STATUS=="F"' , 'BR_VERDE'		},;	// JOB 100% - Fechou
						{'Z1_STATUS=="G"' , 'BR_PRETO'		},;	// JOB Encerrado - Concluido
						{'Z1_STATUS=="H"' , 'BR_VERMELHO'	} }	// JOB CAIU - Cancelado, nao deu certo

Private cCadastro := 'Cadastro de JOBs'
Private aRotina := {	{ 'Pesquisar' , 'AxPesqui'		, 0, 1 },;
						{ 'Visualizar', 'AxVisual'		, 0, 2 },;
						{ 'Incluir'   , 'AxInclui'		, 0, 3 },; //U_IncluiJOB
						{ 'Alterar'   , 'U_AlteraJOB'	, 0, 4 },;
						{ 'Excluir'   , 'U_ExcluiJOB'	, 0, 5, 3 },;
						{ 'Legenda'	  , 'U_LegendaJOB'	, 0, 6, 3 },;
						{ 'Status'	  , 'U_StatusJOB'	, 0, 7, 3 },;
						{ 'Agenda'	  , 'U_Projecao'	, 0, 8, 3 }}
//						{ 'TESTE'	  , 'U_TESTE1'	, 0, 9, 3 }}

MBrowse( ,,,,"SZ1",/* aFixe */,"Z1_DTEVFIM",/* nPar08 */,/* cFun */,/* nClickDef */,aCores,;
		 /* cTopFun */, /* cBotFun */, /* nPar14 */, /* bInitBloc */,/* lNoMnuFilter */, /* lSeeAll */, /* lChgAll */)
		 
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ExcluiJOB³ Autor ³ Murilo Swistalski     ³ Data ³25/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de Exclusao de Cadastro de JOBs                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION ExcluiJOB(cAlias,nReg,nOpc)

If APMsgYesNo("Deseja realmente excluir JOB selecionado?")
	
	//verifica se existe agenda aberta para este JOB
	dbSelectArea(cAlias)
	dbGoto(nReg)
	
	dbSelectArea("SZ2")
	If SZ2->( DbSeek((cAlias)->Z1_CODJOB) )
		MsgStop("Este JOB possui uma ou mais Agendas cadastradas","Exclusão negada")
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

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ExcluiJOB³ Autor ³ Murilo Swistalski     ³ Data ³25/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de Alteracao de Cadastro de JOBs                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
User Function AlteraJOB(cAlias,nReg,nOpc)
Local aArea := GetArea()
Local aCpos := {}

aCpos := {	"Z1_LOCAL"  ,"Z1_FORASP","Z1_ENDEREC","Z1_REFER","Z1_ATENDE","Z1_DIRTEC","Z1_RESPONS","Z1_CONTATO","Z1_CONTTEL",;
			"Z1_DTCARGM","Z1_HRCARGM","Z1_DTVGM1","Z1_HRVGM1",/*"Z1_DTEVINI","Z1_DTEVFIM",*/"Z1_DTVGM2","Z1_HRVGM2",;
			"Z1_DTMONT1","Z1_HRMONT1","Z1_DTMONT2","Z1_HRMONT2","Z1_DTENINI","Z1_HRENINI","Z1_HREVINI","Z1_HREVFIM",;
			"Z1_DTDESM1","Z1_HRDESM1","Z1_DTDESM2","Z1_HRDESM2","Z1_DTVGM3","Z1_HRVGM3","Z1_DTVGM4","Z1_HRVGM4",;
			"Z1_DESCJOB","Z1_OBSGERA",;
			"Z1_TETPVEI","Z1_TEQTPE","Z1_TEDTSAI","Z1_TEDIASD","Z1_TEDTRET","Z1_TERESCO","Z1_TEOBS",;
			"Z1_HEPERIO","Z1_HEQTDPE","Z1_HERESCO","Z1_HEOBS",;
			"Z1_CANUMMO","Z1_CANUMDE","Z1_CARESCO","Z1_CAOBS",;
			"Z1_TCTPVEI","Z1_TCCOMPR","Z1_TCPESO","Z1_TCVALOR","Z1_TCOBS",;
			"Z1_ETVERBA","Z1_ETDIAAL","Z1_ETRESP","Z1_ETOBS";
			}

AXALTERA("SZ1", nReg, 4,/*aAcho*/, aCpos, /*nColMens*/, /*cMensagem*/, /*cTudoOk*/, /*cTransact*/, /*cFunc*/, /*aButtons*/, /*aParam*/, /*aAuto*/, /*lVirtual*/, .T.)

RestArea(aArea)
RETURN

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³LegendaJOB³ Autor ³ Murilo Swistalski     ³ Data ³25/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de Legendas do Cadastro de JOBs                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION LegendaJOB(cAlias,nReg,nOpc)
Local aLegenda := {}

AADD(aLegenda,{"BR_AZUL"	 ,"0% - JOB Aberto" })
AADD(aLegenda,{"BR_AMARELO"	 ,"25% - JOB sem Prioridade" })
AADD(aLegenda,{"BR_PINK"	 ,"50% - JOB Aguardando Resposta" })
AADD(aLegenda,{"BR_LARANJA"	 ,"75% - JOB Em Negociação" })
AADD(aLegenda,{"BR_BRANCO"	 ,"90% - JOB Negociado, sem Check-List" })
AADD(aLegenda,{"BR_VERDE"	 ,"100% - JOB Fechado, OK!" })
//AADD(aLegenda,{"BR_PRETO"	 ,"JOB Encerrado / Concluído" })
AADD(aLegenda,{"BR_VERMELHO" ,"JOB CAIU / Cancelado" })

BrwLegenda(cCadastro, "Legenda", aLegenda)

RETURN NIL

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CadAgenda ³ Autor ³ Murilo Swistalski     ³ Data ³25/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de Cadastro de Agenda                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION CADAGENDA()
Local aCores    := {	{'Z2_ATIVO== "0"'						 ,'BR_MARROM'	},;	
						{'Z2_ATIVO== "1" .and. Z2_STATUS=="    "','BR_AMARELO'	},;	
						{'Z2_ATIVO== "1" .and. Z2_STATUS=="0   "','BR_AMARELO'	},;	
						{'Z2_ATIVO== "1" .and. Z2_STATUS=="25  "','BR_AMARELO'	},;	
						{'Z2_ATIVO== "1" .and. Z2_STATUS=="50  "','BR_AMARELO'	},;	
						{'Z2_ATIVO== "1" .and. Z2_STATUS=="75  "','BR_AMARELO'	},;	
						{'Z2_ATIVO== "1" .and. Z2_STATUS=="90  "','BR_BRANCO'	},;	
						{'Z2_ATIVO== "1" .and. Z2_STATUS=="100 "','BR_VERDE'	},;	
						{'Z2_ATIVO== "1" .and. Z2_STATUS=="OK  "','BR_PRETO'	},;	
						{'Z2_ATIVO== "1" .and. Z2_STATUS=="CAIU"','BR_VERMELHO'	} }	

Private cCadastro := 'Agenda de JOBs'

Private aRotina := {	{ "Pesquisar",	"AxPesqui",		 0 , 1 },; //"Pesquisar"
						{ "Agendar",	"U_AGENDA",		 0 , 3 },; //"Incluir"
						{ "Legenda",	"U_LegAgenda",	 0 , 8 }}  //"Legenda"
/*
Private aRotina := {	{ "Pesquisar",	"AxPesqui",		 0 , 1 },; //"Pesquisar"
						{ "Agendar",	"U_AGENDA",		 0 , 3 },; //"Incluir"
						{ "Liberar",	"U_Liberar",	 0 , 6 },; //"Incluir"
						{ "Retorno",	"U_Retorno",	 0 , 7 },; //"Incluir"
						{ "Legenda",	"U_LegAgenda",	 0 , 8 }}  //"Legenda"
//						{ "Visualizar",	"U_RECURSOS",	 0 , 2 },; //"Visualizar"
//						{ "JOBs",		"U_JOBAGENDA",	 0 , 3 },; //"Visualizar"
*/

Private oWBrowse1
Private aWBrowse1	:= {}
Private aMemoGrid	:= {}
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
Private nComboBox	:= Space(99)

mBrowse( ,,,,"SZ2",,"Z2_ATIVO",,,,aCores)
//MBrowse(nLin1, nCol1, nLin2, nCol2, cAlias, aFixe, cCpo, nPar08,cFun, nClickDef, aColors, cTopFun, cBotFun, nPar14, bInitBloc,lNoMnuFilter, lSeeAll, lChgAll)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ LegAgenda³ Autor ³ Murilo Swistalski     ³ Data ³05/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de Legendas do Cadastro de Agendas de JOBs		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function LegAgenda(cAlias,nReg,nOpc)

Local aLegenda := {}

AADD(aLegenda,{"BR_MARROM"	,OemToAnsi("Agenda NÃO LIBERADA - Inativa")		})
AADD(aLegenda,{"BR_AMARELO"	,OemToAnsi("Agenda NÃO LIBERADA - Status")		})
AADD(aLegenda,{"BR_BRANCO"	,OemToAnsi("Agenda NÃO LIBERADA - Check-List")	})
AADD(aLegenda,{"BR_VERDE"	,OemToAnsi("Agenda LIBERADA para Uso")	   		})
AADD(aLegenda,{"BR_PRETO"	,OemToAnsi("Agenda - JOB Concluido")			})
AADD(aLegenda,{"BR_VERMELHO",OemToAnsi("Agenda - JOB CAIU")				})

BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ExcluiAgenda³ Autor ³ Murilo Swistalski     ³ Data ³14/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inclusao de Recursos (Produtos) para a Agenda				³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
User Function ExcluiAgenda(cAlias,nReg,nOpc)

MsgStop("Não é permitido excluir agenda!", "Controle de Versão Ativado")

dbUnLockAll()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RECURSOS ³ Autor ³ Murilo Swistalski     ³ Data ³25/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inclusao de Recursos (Produtos) para a Agenda			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
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
aMemoGrid := {}

Do Case
	Case nOpc==2
		 cTipo := " - Visualizar"
//		 aNovoArray := PassaInfo(nReg)
		 cTxtVersao := (cAlias)->Z2_VERSAO //StrZero(Val(cTxtVersao)-1,5)
		 
	Case nOpc==3; cTipo := " - Incluir"
	
	Case nOpc==4
		 cTipo := " - Copiar" //" - Alterar"
		 MsgAlert(OemToAnsi("Cópia de versão selecionada.") + chr(13) + OemToAnsi("Número de versão será atualizada!"), OemToAnsi("Controle de Versão Ativado"))
//		 aNovoArray := PassaInfo(nReg)
		
	Case nOpc==5
		 cTipo := " - Excluir"
		 MsgStop(OemToAnsi("Exclusão não permitida"))
		 Return
		 
EndCase

aAdd(aHeader,{"OK"			,"OK_SN"	,"@BMP"			, 5,0,"","","C","","V"})
aAdd(aHeader,{"Cod.Prod"	,"B1_COD"	,"@!"			,15,0,"","","C","",""})
aAdd(aHeader,{"Nome Prod."	,"B1_DESC"	,"@!"			,40,0,"","","C","",""})
aAdd(aHeader,{"QT.Estoque"	,"QTEST"	,"@E 999999.99" , 9,2,"","","N","",""})
aAdd(aHeader,{"Qt.Agenda"	,"QTD"		,"@E 999999.99" , 9,2,"","","N","",""})

DEFINE MSDIALOG oDlg TITLE "Agenda de JOBs"+cTipo From 000,000 To 030,070 OF oMainWnd
DEFINE FONT oFnt NAME "Arial" Size 10,15
		
 	MOSTRAGRID(.F.,aNovoArray)
 	aGrupos := GRUPOS() //carrega grupos de produtos para o ComboBox
	
    @ 022, 015 SAY "JOB:" OF oDlg PIXEL
//	@ 020, 040 MSGET oTxtJob VAR cTxtJob PICTURE "@!" F3 "WDB" ON CHANGE ValidaJOB(cTxtJob:=TrataVar(cTxtJob)) SIZE 020, 010 OF oDlg COLORS 0, 16777215 HASBUTTON PIXEL
	@ 020, 040 MSGET oTxtJob VAR cTxtJob PICTURE "@!" F3 "WDB" SIZE 020, 010 OF oDlg COLORS 0, 16777215 HASBUTTON PIXEL
    
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
    
    @ 067, 015 SAY "Selecione o Grupo de Produtos:" OF oDlg PIXEL
    @ 065, 095 MSCOMBOBOX oComboBox VAR nComboBox ITEMS aGrupos VALID {|| ValidaGrupo(nComboBox)} COLORS 0, 16777215 SIZE 170, 010 OF oDlg PIXEL 

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,	{|| nOpcA:=1,	oDlg:End()},;
														 	{|| nOpcA:=2,	oDlg:End()})

IF nOpcA == 1 .and. (nOpc==3 .or. nOpc==4) // Aceita operacao e grava dados
	lGrava	:= .F.
	cErro	:= ""
	                                                 			
	//verifica se foi selecionado algum produto
	For i:=1 to Len(aWBrowse1)
		If aWBrowse1[i][6] > 0   //aWBrowse1[oWBrowse1:nAt][5]
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
			MsgAlert("Verifique se há produto selecionado"+chr(13)+"e se o codigo da agenda está correto.","Impossível Gravar")
		ElseIf cErro == "QT"
			MsgAlert("Verifique se há produto selecionado ou se as quantidades foram informadas","Impossível Gravar")
		ElseIf cErro == "AG"
			MsgAlert("Verifique se o codigo da agenda/versão está correto.","Impossível Gravar")
		EndIf
	EndIf
    
	If lGrava
		GravaAgenda(nOpc)
	EndIf

ElseIf nOpcA == 1 .and. nOpc == 2
	MsgStop("Não é permitido efetuar alterações!","Visualizar Agenda")
ElseIf nOpcA == 2

EndIf

If lGrava
	LimpaTela("Var")	
EndIf

Return      

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ValidaJOB³ Autor ³ Murilo Swistalski     ³ Data ³30/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de Validacao de Digitacao de JOBs					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ValidaJOB(cJOB,cParam)
Local nCont := 0
Default cParam := .T.

clQry := "SELECT Z1_CODJOB, Z1_EVENTO, Z1_LOCAL,"
clQry += "		 Z1_CLIENTE, A1_NOME, Z1_LOJA, Z1_DTEVINI, Z1_DTEVFIM, "
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
	cTxtDtIni	:= Right(QZ1->Z1_DTEVINI,2)+"/"+Substr(QZ1->Z1_DTEVINI,5,2)+"/"+Left(QZ1->Z1_DTEVINI,4)
	cTxtDtFim	:= Right(QZ1->Z1_DTEVFIM,2)+"/"+Substr(QZ1->Z1_DTEVFIM,5,2)+"/"+Left(QZ1->Z1_DTEVFIM,4)
	
	If cParam
		LimpaTela("-JOB")
	EndIf
Else
	LimpaTela("Tudo")
    
	MsgAlert("JOB não encontrado!")
EndIf

DbSelectArea("QZ1")                           			
DbCloseArea()

Return .T.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ValidaAgenda³ Autor ³ Murilo Swistalski     ³ Data ³31/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de Validacao de Digitacao da Agenda					³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
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

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ValidaGrupo³ Autor ³ Murilo Swistalski     ³ Data ³15/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de Atualizacao dos Grupos e Grid de produtos			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ValidaGrupo(nComboBox)
If Len(Alltrim(cTxtJob)) > 0 .and. Len(Alltrim(cTxtAgenda)) > 0
	MOSTRAGRID(.T.)
	lRetorno := .T.
Else
    MsgStop("Selecione JOB e Agenda para continuar","JOB/Agenda não informado!")
    nComboBox := 0
    lRetorno := .F.
EndIf	
Return lRetorno

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MOSTRAGRID³ Autor ³ Murilo Swistalski     ³ Data ³26/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de Atualizacao de Grid de Reservas				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MOSTRAGRID(lBrowseCriado,aNOVO)

Local oOk	:= LoadBitmap( GetResources(), "LBOK")
Local oNo	:= LoadBitmap( GetResources(), "LBNO")
Local nCont	:= 0
Local nPos	:= 0
Default lBrowseCriado := .F.
Default aNOVO := {}

If Len(aNOVO) == 0
	clQry := "SELECT B1_FILIAL, B1_GRUPO, B1_COD, B1_DESC,"
	clQry += "		 B2_QATU AS QTEST,"		//Quantidade em Estoque
	clQry += "		 ' '	 AS OK_SN,"		//Selecao da linha?
	clQry += "		 0		 AS QTD "		//Quantidade Utilizada
	clQry += "FROM ("
	clQry += "	 SELECT B1_FILIAL, B1_GRUPO, B1_COD, B1_DESC, B1_LOCPAD "
	clQry += "	 FROM "+RetSqlName("SB1")"
	clQry += "	 WHERE B1_FILIAL  = '"+xFilial("SB1")+"'"
	
	//Se selecionou Grupo, mostre APENAS produtos do Grupo Selecionado
	If Alltrim(nComboBox) <> ""       
		clQry += " AND B1_GRUPO = '" + Left(Right(Alltrim(nComboBox),5),4) + "'"
	EndIf
	clQry += " AND D_E_L_E_T_ = ' '"
	clQry += "		   
	
	clQry += "	 ) SB1  "
	clQry += " LEFT JOIN ("       			
	clQry += "	 	  SELECT B2_FILIAL, B2_COD, B2_LOCAL, B2_QATU"
	clQry += "		  FROM "+RetSqlName("SB2")"
	clQry += "		  WHERE B2_FILIAL  = '"+xFilial("SB2")+"'"
	clQry += "		        AND D_E_L_E_T_ = ' '"
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
		nPos:=aScan(aMemoGrid,{|x| x[2] == Alltrim(QRY->B1_COD)})
		If nPos > 0
			Aadd(aWBrowse1,{IIF(aMemoGrid[nPos][3]==0,.F.,.T.),QRY->B1_GRUPO,Alltrim(QRY->B1_COD),Alltrim(QRY->B1_DESC),QRY->QTEST,aMemoGrid[nPos][3],IIF(aMemoGrid[nPos][4]==1,"*","")})
		Else
			Aadd(aWBrowse1,{.F.,QRY->B1_GRUPO,Alltrim(QRY->B1_COD),Alltrim(QRY->B1_DESC),QRY->QTEST,0,""})
		EndIf
		dbSkip()
	EndDo
	
	DbSelectArea("QRY")
	DbCloseArea()

Else
	aWBrowse1	:=	aClone(aNOVO)
EndIf

MemoGrid(aWBrowse1)

If lBrowseCriado //APENAS quando o WBrowse1 ja tiver sido criado

	oWBrowse1:bLine := {|| {;
      If(aWBrowse1[oWBrowse1:nAT,1],oOk,oNo),;
	     aWBrowse1[oWBrowse1:nAt,2],;
     	 aWBrowse1[oWBrowse1:nAt,3],;
     	 aWBrowse1[oWBrowse1:nAt,4],;                			
     	 aWBrowse1[oWBrowse1:nAt,5],;
     	 aWBrowse1[oWBrowse1:nAt,6],;
     	 aWBrowse1[oWBrowse1:nAt,7],;
     	 IIF(aWBrowse1[oWBrowse1:nAt,6]>0,aWBrowse1[oWBrowse1:nAT,1]:=.T.,aWBrowse1[oWBrowse1:nAT,1]:=.F.);
    }}
    oWBrowse1:Refresh()
	
Else

//    @ 066, 015 LISTBOX oWBrowse1 Fields HEADER "","Cod.Prod.","Nome Prod.","Qt.Estoque","Quant.","" SIZE 250, 150 OF oDlg PIXEL ColSizes 38,38//50,50
    @ 082, 015 LISTBOX oWBrowse1 Fields HEADER "","Grupo","Cod.Prod.","Nome Prod.","Qt.Estoque","Quant.","" SIZE 250, 130 OF oDlg PIXEL ColSizes 10,20,30,120,30,20//38,38//50,50
    oWBrowse1:Lhscroll:=.F. //Desabilita o scroll horizontal
    oWBrowse1:SetArray(aWBrowse1)
    oWBrowse1:bLine := {|| {;
      If(aWBrowse1[oWBrowse1:nAT,1],oOk,oNo),;
	     aWBrowse1[oWBrowse1:nAt,2],;
     	 aWBrowse1[oWBrowse1:nAt,3],;
     	 aWBrowse1[oWBrowse1:nAt,4],;                			
     	 aWBrowse1[oWBrowse1:nAt,5],;
     	 aWBrowse1[oWBrowse1:nAt,6],;
     	 aWBrowse1[oWBrowse1:nAt,7],;
     	 IIF(aWBrowse1[oWBrowse1:nAt,6]>0,aWBrowse1[oWBrowse1:nAT,1]:=.T.,aWBrowse1[oWBrowse1:nAT,1]:=.F.);
    }}

    oWBrowse1:bLDblClick := {||	 EditaTela("1","Digite quantidade"), oWBrowse1:Refresh()}

EndIf

Return

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o   ³ EditaTela ³ Autor ³ Murilo Swistalski      ³ Data ³29/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o³ Monta a tela para a edicao do ListBox                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso     ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB		   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
//Static Function EditTela(cTipo,aWBrowse1,oWBrowse1,cDescr1,cDescr2,lUltAlt)
Static Function EditaTela(cTipo,cDescr1)
Local oEditTela,oQtUtil,cQtUtil := 0
Local nInterfere := 2
Local oInterfereoSButton1,oSButton2
Local nOpc:=0,nLin:=0
Local lOk:=.F.

If cTipo=="1".And.(oWBrowse1:nAt<=len(aWBrowse1))

	nQtUtil:=aWBrowse1[oWBrowse1:nAt][6]
	nInterfere:=IIF(aWBrowse1[oWBrowse1:nAt][7]=="*",1,2)
	
	Do While !lOk
		  
		  DEFINE MSDIALOG oEditTela TITLE cDescr1 FROM 000, 000  TO 080, 255 COLORS 0, 16777215 PIXEL

			@ 008, 005 MSGET cQtUtil VAR nQtUtil PICTURE "@E 9,999,999" VALID (nQtUtil>=0) SIZE 116, 010 OF oEditTela COLORS 0, 16777215 PIXEL
		    DEFINE SBUTTON oSButton1 FROM 025, 065 TYPE 01 OF oEditTela ENABLE ACTION (lOk:=.T.,nOpc:=1,oEditTela:End())
		    DEFINE SBUTTON oSButton2 FROM 025, 095 TYPE 02 OF oEditTela ENABLE ACTION (lOk:=.T.,nOpc:=2,oEditTela:End())
		    @ 023, 005 RADIO oInterfere VAR nInterfere ITEMS "Interfere no preço","Não interfere" SIZE 060, 023 OF oEditTela COLOR 0, 16777215 PIXEL

		  ACTIVATE MSDIALOG oEditTela CENTERED
		  		 
	End	
	If nOpc==1
		If nQtUtil > aWBrowse1[oWBrowse1:nAt][5]
			If MsgYesNo("Deseja efetuar Sublocação?","Quantidade maior que Estoque")
				aWBrowse1[oWBrowse1:nAt][6]:=nQtUtil
			EndIf
		Else
			aWBrowse1[oWBrowse1:nAt][6]:=nQtUtil
		EndIf
		If nQtUtil > 0
			IIF(nInterfere==1, aWBrowse1[oWBrowse1:nAt][7]:="*",aWBrowse1[oWBrowse1:nAt][7]:=" ")
		Else
			nInterfere:=2
			aWBrowse1[oWBrowse1:nAt][7]:=" "
		EndIf
	Endif
EndIf

oWBrowse1:Refresh()
MemoGrid(aWBrowse1) //controle de memoria de todos os produtos selecionados
		
Return

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o   ³ LimpaTela ³ Autor ³ Murilo Swistalski      ³ Data ³31/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o³ Limpa os campos da tela de Cadastro de Agendas			   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso     ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB		   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
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
	nComboBox	:= Space(99)

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
//  nComboBox

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
//	nComboBox    
 
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
	nComboBox	:= Space(99)
	
EndIf

Return

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o   ³GravaAgenda³ Autor ³ Murilo Swistalski      ³ Data ³01/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o³ Grava a agenda com as informacoes selecionadas			   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso     ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB		   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
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
	clQry += "FROM "+RetSqlName("SZ3")+" SZ3"
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
		If aWBrowse1[i][6] > 0
			RecLock( "SZ3", .T. )
				nContaItem++
				SZ3->Z3_RESERVA	 := cReserva
				SZ3->Z3_ITEM	 := StrZero(nContaItem,5)
				SZ3->Z3_CODPROD	 := aWBrowse1[i][3]
				SZ3->Z3_QTPROD	 := aWBrowse1[i][6]
				SZ3->Z3_PRECO	 := IIF(aWBrowse1[i][7]=="*","1","0")
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
	SZ2->Z2_FILIAL	:=	xFilial("SZ2")
	SZ2->Z2_CODJOB	:=	cTxtJob	
	SZ2->Z2_AGENDA	:=	cTxtAgenda
	SZ2->Z2_VERSAO	:=	cTxtVersao
	SZ2->Z2_RESERVA	:=	cReserva
	SZ2->Z2_ATIVA	:=	"1"
	SZ2->Z2_FILIAL	:= xFilial("SZ2")
	SZ2->(MsUnlock())
	
	END TRANSACTION
	
	MsgInfo("Agenda incluída com Sucesso!","Agenda OK")
	
	DbSelectArea("QZ3")                           			
	DbCloseArea()
	
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PassaInfo³ Autor ³ Murilo Swistalski     ³ Data ³05/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Passa as informacoes referentes a agenda selecionada		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nReg  -  Numero do R_E_C_N_O_ da Tabela SZ2				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³ Retorna array contendo o aWBrowse1 da Agenda JOB - WDB     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
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
clQry := "SELECT Z2_CODJOB, B1_GRUPO, B1_COD, B1_DESC, B2_QATU, Z3_QTPROD, Z3_PRECO "
clQry += "FROM   ("
clQry += "	   SELECT B1_COD, B1_GRUPO, B1_DESC, B2_QATU"
clQry += "	   FROM "+RetSqlName("SB1")+" SB1"
clQry += "	   LEFT JOIN "+RetSqlName("SB2")+" SB2 ON B2_FILIAL = B1_FILIAL AND"
clQry += "                                            B2_COD	= B1_COD	AND"
clQry += "                                            B2_LOCAL  = B1_LOCPAD"
clQry += "	   ) SB1 "
clQry += "LEFT JOIN ("
clQry += "	 	  SELECT Z2_CODJOB, Z3_CODPROD, Z3_QTPROD, Z3_PRECO"
clQry += "		  FROM ("
clQry += "	 	  	   SELECT *"
clQry += "	 	  	   FROM "+RetSqlName("SZ2") 
clQry += "	 	  	   WHERE R_E_C_N_O_ = " + Alltrim(Str(nReg))
clQry += "	 		   ) SZ2"
clQry += "		  INNER JOIN "+RetSqlName("SZ3")+" SZ3 ON SZ2.Z2_RESERVA = SZ3.Z3_RESERVA"
clQry += "		  ) SZ3 ON B1_COD = Z3_CODPROD"

clQry := ChangeQuery( clQry )
dbUseArea( .T., "TopConn", TCGenQry(,,clQry), "QZ3", .F., .F. )
                  
QZ3->( dbEval( {|| nCont++ } ) )
QZ3->( dbGoTop() )

While QZ3->( !Eof() )
	Aadd(aNOVO,{IIF(QZ3->Z2_CODJOB==Space(9),.F.,.T.),;
				QZ3->B1_GRUPO,;
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

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AtivaAgenda³ Autor ³ Murilo Swistalski      ³ Data ³07/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ativa Agenda de JOB anteriormente com Status Inativo			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function AtivaAgenda(cAlias,nReg,nOpc)
Local cChave := ""

dbSelectArea(cAlias)
dbSetOrder(1)
dbGoto(nReg)
If (cAlias)->Z2_ATIVA == "2" //agenda ja virou orcamento
	MsgStop("Esta versão já gerou um Orçamento!","Impossível Utilizar")
ElseIf (cAlias)->Z2_ATIVA == "1"
	MsgAlert("Esta versão já está ativa!")
Else
	If APMsgYesNo("Todas as demais versões serão desativadas"+chr(13)+;
				  "Se houver ORÇAMENTO gerado de outras versões, será Cancelado!"+chr(13)+;
				  "Se houver PEDIDO relacionado ao Orçamento, será Excluído!"+chr(13)+;
				  "Se houver NOTA FISCAL de Saída gerada, NÃO SERÁ EXCLUÍDA!",;
				  "Deseja realmente ativar o Status da Agenda "+(cAlias)->Z2_AGENDA+", versão "+(cAlias)->Z2_VERSAO +"?")
        
		cChave := (cAlias)->Z2_CODJOB + (cAlias)->Z2_AGENDA
		If dbSeek(cChave)
			While !EOF() .AND. cChave == (cAlias)->Z2_CODJOB + (cAlias)->Z2_AGENDA
			
				BEGIN TRANSACTION
				
			    If (cAlias)->Z2_ATIVA == "2"

			    	aAreaAnt := GetArea()
			    	dbSelectArea("SCJ")
			    	dbSetOrder(1)
			    	
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
		
		MsgInfo("Status da Agenda " + (cAlias)->Z2_AGENDA + " ,Versão " + (cAlias)->Z2_VERSAO + " foi alterada com sucesso!","Status Ativado")
	End	
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GeraOrc  ³ Autor ³ Murilo Swistalski     ³ Data ³07/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera Orcamento a partir de uma Agenda de JOB				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
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
	MsgStop("Esta Agenda já gerou um Orçamento!","Impossível Continuar")
ElseIf (cAlias)->Z2_ATIVA == "0"
	MsgAlert("Ative esta versão para gerar orçamento","Versão Inativa")
Else
	If APMsgYesNo("Deseja realmente gerar orçamento da Agenda "+(cAlias)->Z2_AGENDA+" e versão "+(cAlias)->Z2_VERSAO+"?")

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
				cTexto := "Baixado"
//				MsgStop("Foi encontrado orcamento com mesma numeracao."+chr(13)+"Verifique no cadastro de Orçamentos a possibilidade da exclusão deste orçamento n." + cNovoOrc,;
//						"Impossível Continuar")
//				DISARMTRANSACTION()
//				Return Nil
			ElseIf SCJ->CJ_STATUS == "A"
				cTexto := "Aberto"
			ElseIf SCJ->CJ_STATUS == "C"
				cTexto := "Cancelado"
			EndIf
			MsgAlert("Encontrado orçamento "+cTexto+" de n." + cNovoOrc,"Orçamento Encontrado!")
			If  APMsgYesNo("Deseja Excluir Orçamento n."+cTexto+" para gera um novo ?","Orçamento Encontrado")

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
		
		clQry := "SELECT Z2_AGENDA, A1_COD, A1_LOJA, Z1_DTEVINI, Z1_DTEVFIM "
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
        	MsgStop("Erro: Cliente não encontrado!","Entre em contato com o Administrador do Sistema")
        	DISARMTRANSACTION()
        	Return Nil
		EndIf
        
		clQry := "SELECT Z3_QTPROD, B1_COD, B1_DESC, B1_UM, B1_VALLOC, B1_UPRC, B1_TS "
//		clQry := "SELECT Z3_QTPROD, B1_COD, B1_DESC, B1_UM, B1_PRV1, B1_UPRC, B1_TS "
		clQry += "FROM "+RetSqlName("SZ2")+" SZ2 "
		clQry += "INNER JOIN "+RetSqlName("SZ3")+" SZ3 ON SZ3.Z3_RESERVA = SZ2.Z2_RESERVA"
		clQry += " LEFT JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_COD = SZ3.Z3_CODPROD "
		clQry += "WHERE SZ2.R_E_C_N_O_ = " + Alltrim(Str(nReg))
		
		clQry := ChangeQuery( clQry )
		dbUseArea( .T., "TopConn", TCGenQry(,,clQry), "QZ3", .F., .F. )
		                  
		QZ3->( dbEval( {|| nCont++ } ) )
		QZ3->( dbGoTop() )
		
		If ! ( QZ3->( !Eof() ) )
			MsgStop("Erro: Produtos reservados não encontrados!","Entre em contato com o Administrador do Sistema")        
			DISARMTRANSACTION()
			Return Nil
		EndIf
		
		cCondPag := SuperGetMV("MV_CONDPAD",.F.,"")		
		If Alltrim(cCondPag) == ""
			MsgStop("Erro: Parâmetro MV_CONDPAD deve ser configurado corretamente","Cond. de Pagto Inválido")
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
			SCJ->CJ_VALIDA	:= CTOD(Right(QZ2->Z1_DTEVFIM,2)+"/"+Substr(QZ2->Z1_DTEVFIM,5,2)+"/"+Left(QZ2->Z1_DTEVFIM,4))	//Validade do orcamento para ultimo dia do Evento do JOB
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
			SCK->CK_PRCVEN	:= QZ3->B1_VALLOC //B1_PRV1 //IIF(!Empty(QZ3->B1_PRV1),QZ3->B1_PRV1,QZ3->B1_UPRC)
			SCK->CK_DESCRI	:= QZ3->B1_DESC
			SCK->CK_VALOR	:= QZ3->B1_VALLOC * QZ3->Z3_QTPROD //B1_PRV1 * QZ3->Z3_QTPROD //IIF(!Empty(QZ3->B1_PRV1),QZ3->Z3_QTPROD * QZ3->B1_PRV1,QZ3->Z3_QTPROD * QZ3->B1_UPRC) //valor total
			SCK->CK_TES		:= QZ3->B1_TS
			SCK->CK_LOCAL	:= "01" //""
			SCK->CK_ENTREG	:= CTOD(Right(QZ2->Z1_DTEVINI,2) +"/"+ SubStr(QZ2->Z1_DTEVINI,5,2)  +"/"+ Left(QZ2->Z1_DTEVINI,4))
			SCK->CK_FILVEN	:= xFilial(cAlias)
			SCK->CK_FILENT	:= xFilial(cAlias)
			SCK->CK_DT1VEN	:= CTOD(Right(QZ2->Z1_DTEVINI,2)+"/"+Substr(QZ2->Z1_DTEVINI,5,2)+"/"+Left(QZ2->Z1_DTEVINI,4))
			
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
		
		MsgInfo("Orçamento da Agenda " + (cAlias)->Z2_AGENDA + Chr(13) +;
				"Foi criado com sucesso para a versão " + (cAlias)->Z2_VERSAO + "!",;
				"Orçamento n."+cNovoOrc+" Gerado")
		
		MsgAlert("Favor entrar no orçamento n."+cNovoOrc+chr(13)+" para completar a geração do Orçamento.",;
				 "Verifique orçamento gerado")
		
		SCJ->(dbCloseArea())
		SCK->(dbCloseArea())
		
		END TRANSACTION

	Else
		MsgAlert("Geração do Orçamento cancelado","Cancelado")
	EndIf
    
EndIf

Return .T.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PosCliente³ Autor ³ Murilo Swistalski     ³ Data ³07/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Posicionar o Cliente a partir do Codigo do Job			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
User Function PosCliente(cCodJob)
Local cCliente := ""

aAreaAnt := GetArea()
cCliente := POSICIONE("SA1",1,XFILIAL("SA1")+POSICIONE("SZ1",1,cCodJob,"Z1_CLIENTE"),"A1_NOME")
RestArea(aAreaAnt)

Return cCliente

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PosEvento ³ Autor ³ Murilo Swistalski     ³ Data ³07/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Posicionar o Evento a partir do Codigo do Job			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
User Function PosEvento(cCodJob)
Local cEvento := ""

aAreaAnt := GetArea()
cEvento	 := Posicione("SZ1",1,SZ2->Z2_CODJOB,"Z1_EVENTO")
RestArea(aAreaAnt)

Return cEvento

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PosDtIni ³ Autor ³ Murilo Swistalski     ³ Data ³07/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Posicionar o cDtIni a partir do Codigo do Job			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
User Function PosDtIni(cCodJob)
Local cDtIni := ""

aAreaAnt := GetArea()
cDtIni	 := Posicione("SZ1",1,SZ2->Z2_CODJOB,"Z1_DTEVINI")
RestArea(aAreaAnt)

Return cDtIni

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PosDtFim ³ Autor ³ Murilo Swistalski     ³ Data ³07/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retornar o cDtFim a partir do Codigo do Job				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
User Function PosDtFim(cCodJob)
Local cDtFim := ""

aAreaAnt := GetArea()
cDtFim	 := Posicione("SZ1",1,SZ2->Z2_CODJOB,"Z1_DTEVFIM")
RestArea(aAreaAnt)

Return cDtFim

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TrataVar ³ Autor ³ Murilo Swistalski     ³ Data ³09/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Trata variavel e retorna variavel valida					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function TrataVar(uVariavel)

If Val(uVariavel) == 0 .Or. Val(uVariavel) == Nil
	uVariavel := Alltrim(uVariavel)
Else
	uVariavel := StrZero(Val(cTxtJob),9)
EndiF

Return uVariavel  

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Grupos   ³ Autor ³ Murilo Swistalski     ³ Data ³15/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Carrega grupos de produtos para o Combo de Grupos		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³ Array simples com todos os grupos						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function Grupos()
Local aGrupos	:= {}
Local nCont		:= 0

aAdd(Agrupos,"") //Primeiro grupo em branco para trazer todos

//select distinct para todos os grupos de produtos no SBM
clQry := "SELECT DISTINCT BM_GRUPO, BM_DESC "
clQry += "FROM "+RetSqlName("SBM")+" SBM "
clQry += "ORDER BY BM_DESC"

clQry := ChangeQuery( clQry )
dbUseArea( .T., "TopConn", TCGenQry(,,clQry), "QZ1", .F., .F. )
                  
QZ1->( dbEval( {|| nCont++ } ) )
QZ1->( dbGoTop() )

While QZ1->( !Eof() )
	aAdd(Agrupos,Alltrim(QZ1->BM_DESC) + " - ("+QZ1->BM_GRUPO+")")
	QZ1->( dbSkip() )
End

DbSelectArea("QZ1")                           			
DbCloseArea()

Return aGrupos

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MemoGrid ³ Autor ³ Murilo Swistalski     ³ Data ³15/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Controle de memoria de todos os Produtos selecionados	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function MemoGrid(aWBrowse1,lLimpaMemo)
Local aAreaAnt
Local nPos := 0

Default lLimpaMemo := .F.

aAreaAnt := GetArea()

// se a primeira posicao estiver  .T. - USAR
// varrer todo o array de memoria procurando o produto
//  se NAO encontrar, INCLUI quantidade e interferencia de preco
//  se encontrar ATUALIZA quantidade e interferencia de preco

dbSelectArea("SBM")
dbSetOrder(1)

//Procura em todo o array recebido as informacoes digitadas
For i:=1 to Len(aWBrowse1)
	    	    
	//Procura em todo array de memoria o mesmo produto
	nPos:=aScan(aMemoGrid,{|x| x[2] == Alltrim(aWBrowse1[i][3])})
			
	If nPos > 0
		aMemoGrid[nPos][1] := Alltrim(aWBrowse1[i][2])		 //Grupo de Produtos
		aMemoGrid[nPos][2] := Alltrim(aWBrowse1[i][3])		 //Produto
		aMemoGrid[nPos][3] := aWBrowse1[i][6]				 //Quantidade
		aMemoGrid[nPos][4] := IIF(aWBrowse1[i][7]=="*",1,2)//Se interfere (1) ou nao (2) no preco
	Else
	    aAdd(aMemoGrid,{ Alltrim(aWBrowse1[i][2]),;	//Grupo de Produtos
	    				 Alltrim(aWBrowse1[i][3]),;		//Produto
	    				 aWBrowse1[i][6],;				//Quantidade
	    				 IIF(aWBrowse1[i][7]=="*",1,2);//Se interfere (1) ou nao (2) no preco
	    				})
	EndIf
	
Next 

RestArea(aAreaAnt)
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IncluiJOB³ Autor ³ Murilo Swistalski     ³ Data ³14/05/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de Inclusao de JOB - Teste						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
User Function IncluiJOB(cAlias,nReg,nOpc)
AxInclui(cAlias, nReg, nOpc,,,, MsgAlert("cTudoOk"),, MsgAlert("cTransact"),,,,, .T.)
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AutoJOB  ³ Autor ³ Murilo Swistalski     ³ Data ³14/05/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna Ultimo Numero do JOB valido +1 para uso			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
User Function AutoJOB()
Local nTam	:= TamSX3("Z1_CODJOB")[1]
Local cRet	:= StrZero(0,nTam)
Local nCont	:= 0

clQry := "SELECT Z1_CODJOB "
clQry += "FROM "+RetSqlName("SZ1")+" SZ1 "
clQry += "WHERE Z1_CODJOB <> 'A1       ' "
clQry += "ORDER BY Z1_CODJOB DESC"

clQry := ChangeQuery( clQry )
dbUseArea( .T., "TopConn", TCGenQry(,,clQry), "QZ1", .F., .F. )
                  
QZ1->( dbEval( {|| nCont++ } ) )
QZ1->( dbGoTop() )

If QZ1->( !Eof() )
	cRet := StrZero(Val(QZ1->Z1_CODJOB)+1,nTam)
Else
	cRet := StrZero(1,nTam)
EndIf

//DbSelectArea("QZ1")                           			
QZ1->(DbCloseArea())

Return cRet//"000000000" //cRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ StatusJOB³ Autor ³ Murilo Swistalski     ³ Data ³14/05/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Controle de Status do JOB								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
User Function StatusJOB(cAlias,nReg,nOpc)
Local oCodJOB
Local cCodJOB := (cAlias)->Z1_CODJOB
Local oCodCli
Local cCodCli := (cAlias)->Z1_CLIENTE
Local oLoja
Local cLoja := (cAlias)->Z1_LOJA
Local oEvento
Local cEvento := (cAlias)->Z1_EVENTO
Local oDt1
Local cDt1 := (cAlias)->Z1_DTEVINI
Local oDt2
Local cDt2 := (cAlias)->Z1_DTEVFIM
Local oCombo
Local nCombo := IIF ( ASC( Alltrim( (cAlias)->Z1_STATUS ) ) == 0, 1, ASC( Alltrim( (cAlias)->Z1_STATUS ) ) - 64 )
Local oMultiGet
Local cMultiGet := ""
Local aItens	:= {}
Local nOpcA		:= 0
Local lCont		:= .T.
Local lBranco	:= .F.

Static oDlg

aAdd(aItens,"000 - Aberto")
aAdd(aItens,"025 - Sem Prioridade")
aAdd(aItens,"050 - Aguardando")
aAdd(aItens,"075 - Negociacao")
aAdd(aItens,"100 - Fechado")
//aAdd(aItens,"111 - Concluido")
aAdd(aItens,"999 - CAIU")

cMultiGet := chr(10) + chr(13) +;
			 Space(10) + OemToAnsi("025 - Tem chance de dar certo, mas não dará prioridade") + chr(10) + chr(13) +;
			 Space(10) + OemToAnsi("050 - Tem maiores chances mas não é certeza") + chr(10) + chr(13) +;
			 Space(10) + OemToAnsi("075 - Grande chance de dar certo, em negociação") + chr(10) + chr(13) +;
			 Space(10) + OemToAnsi("100 - Cliente fechou, OK.") + chr(10) + chr(13) +;
			 Space(10) + OemToAnsi("CAIU - JOB Cancelado")
//			 Space(10) + "111 - Encerrado, JOB Concluido" + chr(10) + chr(13) +;

DEFINE MSDIALOG oDlg TITLE "Status Atual do JOB: " + AllTrim(Str(StatusPerc((cAlias)->Z1_STATUS))) + "%" FROM  000, 000  TO 290, 440 OF oMainWnd PIXEL

    @ 008, 010 SAY oSay1 PROMPT "Cod. JOB"		SIZE 026, 009 OF oDlg COLORS 0, 16777215 PIXEL
    @ 019, 010 SAY oSay2 PROMPT "Cod. Cliente"	SIZE 031, 009 OF oDlg COLORS 0, 16777215 PIXEL
    @ 031, 010 SAY oSay3 PROMPT "Dt.EventoIni"	SIZE 034, 009 OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 005, 045 MSGET oCodJOB VAR cCodJOB		SIZE 034, 009 OF oDlg COLORS 0, 16777215 PIXEL READONLY
    @ 017, 045 MSGET oCodCli VAR cCodCli		SIZE 026, 009 OF oDlg COLORS 0, 16777215 PIXEL READONLY
    @ 029, 045 MSGET oDt1	 VAR cDt1			SIZE 026, 009 OF oDlg COLORS 0, 16777215 PIXEL READONLY
    
    @ 008, 100 SAY oSay1 PROMPT "Evento"		SIZE 026, 009 OF oDlg COLORS 0, 16777215 PIXEL
    @ 019, 100 SAY oSay2 PROMPT "Loja Cliente"	SIZE 031, 009 OF oDlg COLORS 0, 16777215 PIXEL
    @ 031, 100 SAY oSay3 PROMPT "Dt.EventoFim"	SIZE 034, 009 OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 005, 145 MSGET oEvento VAR cEvento		SIZE 065, 009 OF oDlg COLORS 0, 16777215 PIXEL READONLY
    @ 017, 145 MSGET oLoja   VAR cLoja		   	SIZE 026, 009 OF oDlg COLORS 0, 16777215 PIXEL READONLY
    @ 029, 145 MSGET oDt2	 VAR cDt2			SIZE 026, 009 OF oDlg COLORS 0, 16777215 PIXEL READONLY

//	@ 045, 010 SAY oSay4 PROMPT "STATUS:"		SIZE 034, 009 OF oDlg COLORS 0, 16777215 PIXEL
//	@ 045, 045 MSCOMBOBOX oCombo VAR nCombo		SIZE 110, 009 OF oDlg COLORS 0, 16777215 PIXEL ITEMS aItens
	
    @ 045, 010 BUTTON oButton1 PROMPT "25%"		SIZE 040, 015 OF oDlg ACTION TrocaStatus(oDlg,cAlias,nReg,25) PIXEL
    @ 045, 050 BUTTON oButton2 PROMPT "50%"		SIZE 040, 015 OF oDlg ACTION TrocaStatus(oDlg,cAlias,nReg,50) PIXEL
    @ 045, 090 BUTTON oButton3 PROMPT "75%"		SIZE 040, 015 OF oDlg ACTION TrocaStatus(oDlg,cAlias,nReg,75) PIXEL
    @ 045, 130 BUTTON oButton4 PROMPT "100%"	SIZE 040, 015 OF oDlg ACTION TrocaStatus(oDlg,cAlias,nReg,100) PIXEL
    @ 045, 170 BUTTON oButton5 PROMPT "CAIU"	SIZE 040, 015 OF oDlg ACTION TrocaStatus(oDlg,cAlias,nReg,999) PIXEL
    	
    @ 062, 010 SAY oSay10 PROMPT "Informacoes:" SIZE 191, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 069, 010 GET oMultiGe1 VAR cMultiGet OF oDlg MULTILINE SIZE 200, 050 COLORS 0, 16777215 READONLY HSCROLL PIXEL

ACTIVATE MSDIALOG oDlg CENTERED //ON INIT EnchoiceBar(oDlg, {|| nOpcA := 1 , oDlg:End() }, {|| oDlg:End() })

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³TrocaStatus³ Autor ³ Murilo Swistalski    ³ Data ³18/05/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de Alteracao de Status							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function TrocaStatus(oDlg,cAlias,nReg,nStatus)
Local nCont			:= 0
Local aCampos		:= {}
Local lCont			:= .F.
Local lBranco		:= .F.
Local lContinua		:= .F.

aCampos := {"Z1_LOCAL","Z1_ENDEREC","Z1_REFER","Z1_ATENDE","Z1_FORASP",;
			"Z1_DIRTEC","Z1_RESPONS","Z1_CONTATO","Z1_CONTTEL",;
			"Z1_DTCARGM","Z1_DTENINI",;
			"Z1_DTVGM1" ,"Z1_DTVGM2" ,"Z1_DTMONT1","Z1_DTMONT2",;
			"Z1_DTDESM1","Z1_DTDESM2","Z1_DTVGM3" ,"Z1_DTVGM4" ,;
			"Z1_OBSGERA"}
			

If (cAlias)->Z1_STATUS $ "FGH"             
	MsgStop(OemToAnsi("Não é permitido alterar o Status desde JOB"),OemToAnsi("Status Definitivo"))
Else 

	//Se escolheu estatus maior que 50%
	// deve ter orcamento consolidado
	If nStatus > 50 .And. nStatus <> 999
		clQry := "SELECT Z4_CODJOB FROM "+RetSqlName("SZ4")+" SZ4 "
		clQry += "WHERE Z4_GRUPO = '0'  AND" 
		clQry += "		Z4_STATUS = '1' AND"
		clQry += "		Z4_CODJOB = '" + (cAlias)->Z1_CODJOB + "'"
		
		clQry := ChangeQuery( clQry )
		dbUseArea( .T., "TopConn", TCGenQry(,,clQry), "QZ1", .F., .F. )
                  
		QZ1->( dbEval( {|| nCont++ } ) )
		QZ1->( dbGoTop() )

		If QZ1->( !Eof() )
			lContinua := .T.
		EndIf
		
		DbSelectArea("QZ1")
		DbCloseArea()
		
		If !lContinua
			MsgStop(OemToAnsi("Para alterar para este Status, o JOB deve ter Orçamento Consolidado"),OemToAnsi("Permissão Negada"))
			Return Nil
		EndIf

	EndIf	

	Do Case
		Case ( nStatus == 0   ) ; ( cOpcao := "A" )
		Case ( nStatus == 25  ) ; ( cOpcao := "B" )
		Case ( nStatus == 50  ) ; ( cOpcao := "C" )
		Case ( nStatus == 75  ) ; ( cOpcao := "D" )
		Case ( nStatus == 90  ) ; ( cOpcao := "E" )
		Case ( nStatus == 100 ) ; ( cOpcao := "F" )
		Case ( nStatus == 111 ) ; ( cOpcao := "G" )
		Case ( nStatus == 999 ) ; ( cOpcao := "H" )
	EndCase
    
    //Verifica se alterou o Status
    //Nao permite alteracao para menor do que o anterior
	If (cAlias)->Z1_STATUS >= cOpcao
        MsgStop(OemToAnsi("Não é permitido alterar o Status")+chr(13)+OemToAnsi("Posição Anterior ou Igual a atual"),OemToAnsi("Permissão Negada"))
    Else

		If APMsgYesNo(OemToAnsi("Confirma alteração de Status para " + IIF(nStatus<=100,AllTrim(Str(nStatus)) + "% ?","'CAIU' ?")) + chr(13) +;
					  OemToAnsi("Não será possível desfazer esta alteração!"),"Atenção: Status Atual em " + AllTrim(Str(StatusPerc((cAlias)->Z1_STATUS))) + "%")
			
			//Se mudou status para 100, verifica se preencheu check-list
			If cOpcao == "F"
				For i:=1 to Len(aCampos)
					If	( ValType((cAlias)->&(aCampos[i])) == "D" .And. (cAlias)->&(aCampos[i]) == CTOD("  /  /  ")	) .Or.;
						( ValType((cAlias)->&(aCampos[i])) == "C" .And. Alltrim((cAlias)->&(aCampos[i])) == ""		)
						dbSelectArea("SX3") 
						dbSetOrder(2)
						If SX3->(dbSeek(aCampos[i]))
							MsgStop(OemToAnsi("Campo: '")+Alltrim(SX3->X3_TITULO)+"'"+CHR(13)+"Descricao: '"+Alltrim(SX3->X3_DESCRIC)+"'",OemToAnsi("Campo Obrigatório"))
		                    //Neste caso, deve mostrar status em BRANCO
							cOpcao := "E"
							Exit
						EndIf
					EndIf
				Next
				
			EndIf
			
			If cOpcao == "E"
				//Se o check-list NAO esta preenchido
				// ALTERAR agenda para Area Tecnica
				If SZ2->( dbSeek( (cAlias)->Z1_CODJOB ) )
			    	RecLock( "SZ2", .F. )
			    	SZ2->Z2_STATUS := "90"
			    	SZ2->(MsUnLock())
				EndIf
			EndIf
			If cOpcao == "F"
				//Se o check-list esta preenchido
				// LIBERAR agenda para Area Tecnica
				If SZ2->( dbSeek( (cAlias)->Z1_CODJOB ) )
			    	RecLock( "SZ2", .F. )
			    	SZ2->Z2_STATUS := "100"
			    	SZ2->(MsUnLock())
				EndIf
			EndIf
				
			RecLock( "SZ1", .F. )
			SZ1->Z1_STATUS	:= cOpcao
			SZ1->Z1_USUARIO	:= cUsername
			SZ1->Z1_DTHRUSO	:= DtoC(Date()) + " " + Time()
			MsUnLock()
	
			If cOpcao <> "E"
				MsgInfo("Status alterado com Sucesso!")
			Else
				MsgInfo(OemToAnsi("Check-List não foi preenchido"),"Status pendente")
			EndIf
			
			oDlg:End()
			
		EndIf
    EndIf
EndIf    

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³StatusPerc³ Autor ³ Murilo Swistalski     ³ Data ³25/05/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna percentual a partir da letra do status			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function StatusPerc(cLetra)
Local nPerc := 0

Do Case
	Case ( cLetra == "A" ) ; ( nPerc := 0	 )
	Case ( cLetra == "B" ) ; ( nPerc := 25	 )
	Case ( cLetra == "C" ) ; ( nPerc := 50	 )
	Case ( cLetra == "D" ) ; ( nPerc := 75	 )
	Case ( cLetra == "E" ) ; ( nPerc := 90	 )
	Case ( cLetra == "F" ) ; ( nPerc := 100 )
	Case ( cLetra == "G" ) ; ( nPerc := 0 )
	Case ( cLetra == "H" ) ; ( nPerc := 0 )
EndCase

Return nPerc

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ValDtIni ³ Autor ³ Murilo Swistalski     ³ Data ³14/05/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Controle de Data de INICIO								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
User Function ValDtIni(dData)
Local lRet		:= .T.
Default dData	:= Date()

If dData < Date()
	lRet := .F.
Endif

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ValDtFim ³ Autor ³ Murilo Swistalski     ³ Data ³14/05/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Controle de Data FINAL									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
User Function ValDtFim(dData)
Local lRet		:= .T.
Default dData	:= Date()

If dData < Date()
	lRet := .F.
Endif

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VerJOBs  ³ Autor ³ Murilo Swistalski     ³ Data ³19/05/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Visualizar Cadastro de JOBS								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para Criacao/Alteracao da Agenda JOB - WDB      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
User Function VerJOBs(cAlias,nReg,nOpc)
Local aCampos := {}
Local nOpcA := 0
Local aSize := {}
Local aInfo := {}
Local aPObj := {}

Private bCampo := {|nField| FieldName(nField) }

aAdd(aCampos,{"Z1_CODJOB",;
			  "Z1_DTCARGM",;
			  "Z1_HRCARGM",;			  
			  "Z1_DTVGM1",;
			  "Z1_HRVGM1",;
			  "Z1_DTVGM2",;
			  "Z1_HRVGM2",;
			  "Z1_DTMONT1",;
			  "Z1_HRMONT1",;
			  "Z1_DTMONT2",;
			  "Z1_HRMONT2",;
			  "Z1_DTDESM1",;
			  "Z1_HRDESM1",;
			  "Z1_DTDESM2",;
			  "Z1_HRDESM2",;
			  "Z1_DTVGM3",;
			  "Z1_HRVGM3",;
			  "Z1_DTVGM4",;
			  "Z1_HRVGM4",;
			  "Z1_TETPVEI",;
			  "Z1_TEQTPE",;
			  "Z1_TEDTSAI",;
			  "Z1_TEDIASD",;
			  "Z1_TEDTRET",;
			  "Z1_TERESCO",;
			  "Z1_TEOBS",;
			  "Z1_HEPERIO",;
			  "Z1_HEQTDPE",;
			  "Z1_HERESCO",;
			  "Z1_HEOBS",;
			  "Z1_CANUMMO",;
			  "Z1_CANUMDE",;
			  "Z1_CARESCO",;
			  "Z1_CAOBS",;
			  "Z1_TCTPVEI",;
			  "Z1_TCCOMPR",;
			  "Z1_TCPESO",;
			  "Z1_TCVALOR",;
			  "Z1_TCOBS",;
			  "Z1_ETVERBA",;
			  "Z1_ETDIAAL",;
		   	  "Z1_ETRESP",;
		   	  "Z1_ETOBS",;
			  })
nOpc:=3
//aSize := MsAdvSize(.T.,.T.,400)
//aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
//aPObj := { 15, 3, 95, 637} //MsObjSize( aInfo, aObj )

aHeader := {}
aCols	:= {}

dbSelectArea("SZ1")
dbSetOrder(1)
If SZ1->(dbSeek(xFilial("SZ1") + SZ2->Z2_CODJOB))
//	axVisual("SZ1", SZ1->(Recno()), nOpc)

//	For nX := 1 To FCount()
//		M->&( Eval( bCampo, nX ) ) := CriaVar( FieldName( nX ), .T. )
//	Next nX
    
//	M->Z1_CODJOB := SZ2->Z2_CODJOB
	MontaSZ1( 4, SZ2->Z2_CODJOB )

	DEFINE MSDIALOG oDlg TITLE "Cadastro de JOBs" FROM 26,0 TO 465,660 OF oMainWnd PIXEL

	Enchoice( "SZ1", SZ1->(Recno()), 4, , , , , {12,0,220,330}, aCampos, , , , /*cTudoOk*/, oDlg)

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| nOpcA := 1, oDlg:End() }, {|| oDlg:End() })
	
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MontaSZ1   ³ Autor ³ Murilo Swistalski   ³ Data ³19/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta aHeader e aCols dos arquivos Temporarios             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para WDB									      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MontaSZ1( nOpc, nNum )
//Local nNUM	 := //SZ4->Z4_NUM
Local cChave := nNUM
Local cAlias := "SZ1"
Local nI	 := 0

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta aHeader³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !EOF() .And. X3_ARQUIVO == cAlias
	If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
		AADD( aHeader, { Trim( X3Titulo() ),;
						X3_CAMPO,;
						X3_PICTURE,;
						X3_TAMANHO,;
						X3_DECIMAL,;
						IIF(Alltrim(X3_CAMPO)=="Z1_CODJOB",Space(128),X3_VALID),;
						X3_USADO,;
						X3_TIPO,;
						X3_ARQUIVO,;
						X3_CONTEXT})
	Endif
	dbSkip()
End
dbUnLock()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta aCols  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpc <> 3
	dbSelectArea( cAlias )
	(cAlias)->( dbSetOrder(1) )
	(cAlias)->( dbSeek( xFilial( cAlias ) + cChave ) )

	While !EOF() .And. xFilial( cAlias ) + cChave == (cAlias)->Z1_FILIAL + (cAlias)->Z1_CODJOB
	
		AADD( aCOLS, Array( Len( aHeader ) + 1 ) )
		
		For nI := 1 To Len( aHeader )
			If aHeader[nI,10] == "V"
				aCOLS[Len(aCOLS),nI] := CriaVar(aHeader[nI,2],.T.)
			Else
				aCOLS[Len(aCOLS),nI] := FieldGet(FieldPos(aHeader[nI,2]))
			Endif
		Next nI
		
		aCOLS[Len(aCOLS),Len(aHeader)+1] := .F.
		dbSkip()
		
	End
	
Else

	AADD( aCOLS, Array( Len( aHeader ) + 1 ) )
	
	For nI := 1 To Len( aHeader )
		aCOLS[1, nI] := CriaVar( aHeader[nI, 2], .T. )
	Next nI
	
	aCOLS[1, GdFieldPos("Z1_CODJOB")] := "01"
	aCOLS[1, Len( aHeader )+1 ] := .F.
	
Endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AGENDA     ³ Autor ³ Murilo Swistalski   ³ Data ³20/05/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de Agendamento de Equipamentos					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para WDB									      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function AGENDA(cAlias,nReg,nOpc)
Local aArea := {}
Local nOpcA := 0
Local aFields := {"Z1_CODJOB","Z1_EVENTO","Z1_CLIENTE","Z1_LOJA","Z1_LOCAL","Z1_ENDEREC"}
Local aAlterFields := {}

Local oProdOrc
Local aProdOrc	:= {}

Local oProdTec
//Local aProdTec	:= {}

Local oCmbGrupo
Local cCmbGrupo := ""

Local oProduto
Local cProduto := Space(30)

Local oQuant
Local cQuant := Space(8)

Local oQtTec
Local cQtTec := Space(8)

Local aGrupos := {}

Local oProdTec
Local aProdTec := {}

Local oSay01, oSay02, oSay03, oSay04, oSay05, oSay06, oSay07, oSay08, oSay09, oSay10, oSay11, oSay12, oSay13, oSay14, oSay15, oSay16, oSay17, oSay18, oSay19, oSay20, oSay21, oSay22, oSay23, oSay24, oSay25, oSay26, oSay27, oSay28
Local oSay01, oGet02, oGet03, oGet04, oGet05, oGet06, oGet07, oGet08, oGet09, oGet10, oGet11, oGet12, oGet13, oGet14, oGet15, oGet16, oGet17, oGet18, oGet19, oGet20, oGet21, oGet22, oGet23, oGet24, oGet25, oGet26, oGet27, oGet28

Local cCodJOB		 := "000000001"
Local cEvento		 := "EVENTO TESTE"
Local cLocal		 := "LOCAL TESTE"
Local cCodCli		 := "COD CLIENTE"
Local cNomeCli		 := "NOME DO CLIENTE"
Local cDtCarrega	 := "99/99/9999"
Local cHrCarrega	 := "99:99"
Local cDtViagem1	 := "99/99/9999"
Local cDtViagem2	 := "99/99/9999"
Local cHrViagem1	 := "99:99"
Local cHrViagem2	 := "99:99"
Local cDtMontaIni	 := "99/99/9999"
Local cDtMontaFim	 := "99/99/9999"
Local cHrMontaIni	 := "99:99"
Local cHrMontaFim	 := "99:99"
Local cDtEventoIni	 := "99/99/9999"
Local cDtEventoFim	 := "99/99/9999
Local cHrEventoIni	 := "99:99"
Local cHrEventoFim	 := "99:99"
Local cDtDesmIni   	 := "99/99/9999"
Local cDtDesmFim	 := "99/99/9999
Local cHrDesmIni	 := "99:99"
Local cHrDesmFim	 := "99:99"
Local cDtViagem3	 := "99/99/9999"
Local cDtViagem4	 := "99/99/9999"
Local cHrViagem3	 := "99:99"
Local cHrViagem4	 := "99:99"

Local lVisualizar	 := .F.
Local lAlterar		 := .F.

Local aNovoArray	 := {}
Local lResp			 := .F.

Static oCabec

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se a Agenda pode ser:³
//³		- Visualizada, ou		 ³
//³		- Alterada				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cAlias)->Z2_ATIVO <> "0"
	lVisualizar := .T.
	
	If !(Alltrim((cAlias)->Z2_STATUS) == "CAIU" .Or. Alltrim((cAlias)->Z2_ATIVO) == "0")
		lAlterar	:= .T.
	EndIf
	
EndIf

If lVisualizar := .F.
	MsgStop(OemToAnsi("Não é permitido visualizar Agenda com a Versão selecionada"),OemToAnsi("Versão de Agenda Inativa"))
	Return Nil
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carregamento das Variaveis³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")

dbSelectArea("SZ1")
dbSetOrder(1)
dbSeek(xFilial("SZ1")+SZ2->Z2_CODJOB)
cCodJOB		 := SZ1->Z1_CODJOB
cEvento		 := SZ1->Z1_EVENTO
cLocal		 := SZ1->Z1_LOCAL
cCodCli		 := SZ1->Z1_CLIENTE
cNomeCli	 := Posicione( "SA1", 1, xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA, "A1_NOME" )
cDtCarrega	 := SZ1->Z1_DTCARGM
cHrCarrega	 := SZ1->Z1_HRCARGM	
cDtViagem1	 := SZ1->Z1_DTVGM1
cDtViagem2	 := SZ1->Z1_DTVGM2
cHrViagem1	 := SZ1->Z1_HRVGM1
cHrViagem2	 := SZ1->Z1_HRVGM2
cDtMontaIni	 := SZ1->Z1_DTMONT1
cDtMontaFim	 := SZ1->Z1_DTMONT2
cHrMontaIni	 := SZ1->Z1_HRMONT1
cHrMontaFim	 := SZ1->Z1_HRMONT2
cDtEnsaio	 := SZ1->Z1_DTENINI
cHrEnsaio	 := SZ1->Z1_HRENINI
cDtEventoIni := SZ1->Z1_DTEVINI
cDtEventoFim := SZ1->Z1_DTEVFIM
cHrEventoIni := SZ1->Z1_HREVINI
cHrEventoFim := SZ1->Z1_HREVFIM
cDtDesmIni	 := SZ1->Z1_DTDESM1
cDtDesmFim	 := SZ1->Z1_DTDESM2
cHrDesmIni	 := SZ1->Z1_HRDESM1
cHrDesmFim	 := SZ1->Z1_HRDESM2
cDtViagem3	 := SZ1->Z1_DTVGM3
cDtViagem4	 := SZ1->Z1_DTVGM4
cHrViagem3	 := SZ1->Z1_HRVGM3
cHrViagem4	 := SZ1->Z1_HRVGM4

dbSelectArea("SZ3")
dbSetOrder(3) //+++ ao incluir o indice corretamente, lembrar de adicionar o xFilial
If SZ3->( dbSeek( xFilial("SZ3") + SZ2->Z2_CODJOB + SZ2->Z2_RESERVA ) ) //	SZ3->( dbSeek( SZ2->Z2_CODJOB + SZ2->Z2_RESERVA ) )
	While !EOF() .And. SZ2->Z2_CODJOB == SZ3->Z3_CODJOB .And. SZ2->Z2_RESERVA == SZ3->Z3_RESERVA
		//Carrega Todos os itens orcados
		cTecCodProd	:= Alltrim(SZ3->Z3_TECPROD)
		cTecObs		:= Alltrim(SZ3->Z3_TECOBS)
		cTecQuant	:= Alltrim(Str(SZ3->Z3_TECQT))
		cOrcCodProd	:= Alltrim(SZ3->Z3_ORCPROD)
		cOrcQuant	:= Alltrim(Str(SZ3->Z3_ORCQT))
		
		aArea := GetArea()
		cTecDescr	 := Posicione("SB1",1,xFilial("SB1")+cTecCodProd,"B1_DESC")
		cTecGrupo	 := Posicione("SBM",1,xFilial("SBM")+Posicione("SB1",1,xFilial("SB1")+cTecCodProd,"B1_GRUPO"),"BM_DESC")
		
		cOrcDescr	 := Posicione("SB1",1,xFilial("SB1")+cOrcCodProd,"B1_DESC")
		cOrcGrupo	 := Posicione("SBM",1,xFilial("SBM")+Posicione("SB1",1,xFilial("SB1")+cOrcCodProd,"B1_GRUPO"),"BM_DESC")
		RestArea(aArea)
		
		If SZ3->Z3_ORCADO == "1"
//			aAdd(aProdOrc,{cTecCodProd,cTecDescr,cTecQuant,cOrcCodProd,cOrcDescr,cOrcQuant,cTecObs})
			aAdd(aProdTec,{Len(aProdTec)+1,cOrcGrupo,cOrcCodProd,cOrcDescr,cOrcQuant,"*"})
		Else
	   		aAdd(aProdTec,{Len(aProdTec)+1,cTecGrupo,cTecCodProd,cTecDescr,cTecQuant," "})
		EndIf
		SZ3->(dbSkip())
	End
EndIf

IIF( Len(aProdOrc)==0, aAdd(aProdOrc,{"","","","","","",""}), .T. )
IIF( Len(aProdTec)==0, aAdd(aProdTec,{"","","","","",""}), .T. )

M->Z4_GRUPO := "2"
aAdd(aGrupos,"") //Primeiro da Lista, em Branco

dbSelectArea("SBM")
dbSetOrder(1)
dbGoTop()
While !EOF()
	If Val(Substr(SBM->BM_GRUPO,1,2)) >= 10 .And. Val(Substr(SBM->BM_GRUPO,1,2)) <= 30 //+++ verificar se 1001 a 1007 para comercial e 2001 a 20?? para tecnicos
		aAdd(aGrupos,Alltrim(SBM->BM_DESC) + " - ("+SBM->BM_GRUPO+")")
	EndIf
	SBM->(dbSkip())
End

//DEFINE MSDIALOG oDlg TITLE "Agendamento" + IIF(lAlterar,OemToAnsi(" (Alteração Permitida)"),OemToAnsi(" (apenas Visualização)")) FROM 26,0 TO 600,800 OF oMainWnd PIXEL
DEFINE MSDIALOG oDlg TITLE "Agendamento" FROM 26,0 TO 600,800 OF oMainWnd PIXEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FOLDER          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	@ 016, 005 FOLDER oFolder1 SIZE 390, 265 OF oDlg ITEMS "JOB "+cCodJOB,"Agenda",OemToAnsi("Observações") COLORS 0, 16777215 PIXEL
	@ 016, 005 FOLDER oFolder1 SIZE 390, 265 OF oDlg ITEMS "JOB","Agenda","Controle" COLORS 0, 16777215 PIXEL
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CABECALHO - SZ1 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAcho	:= {"Z1_CODJOB","Z1_EVENTO","Z1_CLIENTE","Z1_LOJA","Z1_LOCAL","Z1_FORASP","Z1_ENDEREC","Z1_REFER","Z1_DIRTEC","Z1_RESPONS","Z1_ATENDE","NOUSER"}
aCampos	:= {"Z1_DTCARGM","Z1_HRCARGM","Z1_DTVGM1","Z1_HRVGM1","Z1_DTVGM2","Z1_HRVGM2","Z1_DTMONT1","Z1_HRMONT1","Z1_DTMONT2","Z1_HRMONT2","Z1_DTENINI","Z1_HRENINI","Z1_DTDESM1","Z1_HRDESM1","Z1_DTDESM2","Z1_HRDESM2","Z1_DTVGM3","Z1_HRVGM3","Z1_DTVGM4","Z1_HRVGM4"}

EnChoice("SZ1", nReg, 3 /*nOpc*/,/*aCRA*/,/*cLetra*/,/*cTexto*/,aAcho,{005,005,080/*067*/,383}, /*aCampos*/,/*nModelo*/, /*nColMens*/, /*cMensagem*/, /*cTudoOk*/, oFolder1:aDialogs[1], /*lF3*/, /*lMemoria*/, /*lColumn*/, /*caTela*/, .T./*lNoFolder*/, /*lProperty*/)

    @ 073+13, 007 SAY oSay01 PROMPT "Dt.Carrega:"		SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
    @ 072+13, 041 MSGET oGet01 VAR cDtCarrega			SIZE 035, 009 OF oFolder1:aDialogs[1] PICTURE "99/99/99" COLORS 0, 16777215 PIXEL
    @ 073+13, 109 SAY oSay02 PROMPT "Hr.Carrega:"		SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
	@ 072+13, 143 MSGET oGet02 VAR cHrCarrega			SIZE 025, 009 OF oFolder1:aDialogs[1] PICTURE "99:99" VALID ValidaHora(cHrCarrega) COLORS 0, 16777215 PIXEL
 
    @ 085+13, 007 SAY oSay05 PROMPT "Dt.Viagem 1:"		SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 12632256 PIXEL
    @ 084+13, 041 MSGET oGet05 VAR cDtViagem1			SIZE 035, 009 OF oFolder1:aDialogs[1] PICTURE "99/99/99" COLORS 0, 16777215 PIXEL
    @ 085+13, 109 SAY oSay06 PROMPT "Hr.Viagem 1:"		SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 12632256 PIXEL
    @ 084+13, 143 MSGET oGet06 VAR cHrViagem1			SIZE 025, 009 OF oFolder1:aDialogs[1] PICTURE "99:99" VALID ValidaHora(cHrViagem1) COLORS 0, 16777215 PIXEL
    @ 085+13, 202 SAY oSay07 PROMPT "Dt.Viagem 2:"		SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 12632256 PIXEL
    @ 084+13, 236 MSGET oGet07 VAR cDtViagem2			SIZE 035, 009 OF oFolder1:aDialogs[1] PICTURE "99/99/99" COLORS 0, 16777215 PIXEL
    @ 085+13, 293 SAY oSay08 PROMPT "Hr.Viagem 2:"		SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 12632256 PIXEL
    @ 084+13, 327 MSGET oGet08 VAR cHrViagem2			SIZE 025, 009 OF oFolder1:aDialogs[1] PICTURE "99:99" VALID ValidaHora(cHrViagem2) COLORS 0, 16777215 PIXEL
    
    @ 097+13, 007 SAY oSay09 PROMPT "Dt.Monta.Ini:"	SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
    @ 096+13, 041 MSGET oGet09 VAR cDtMontaIni			SIZE 035, 009 OF oFolder1:aDialogs[1] PICTURE "99/99/99" COLORS 0, 16777215 PIXEL
    @ 097+13, 109 SAY oSay10 PROMPT "Hr.Monta.Ini:"	SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
    @ 096+13, 143 MSGET oGet10 VAR cHrMontaIni			SIZE 025, 009 OF oFolder1:aDialogs[1] PICTURE "99:99" VALID ValidaHora(cHrMontaIni) COLORS 0, 16777215 PIXEL
    @ 097+13, 202 SAY oSay11 PROMPT "Dt.Monta.Fim:"	SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
    @ 096+13, 236 MSGET oGet11 VAR cDtMontaFim			SIZE 035, 009 OF oFolder1:aDialogs[1] PICTURE "99/99/99" COLORS 0, 16777215 PIXEL
    @ 097+13, 293 SAY oSay12 PROMPT "Hr.Monta.Fim:"	SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
    @ 096+13, 327 MSGET oGet12 VAR cHrMontaFim 		SIZE 025, 009 OF oFolder1:aDialogs[1] PICTURE "99:99" VALID ValidaHora(cHrMontafIM) COLORS 0, 16777215 PIXEL
    
    @ 110+13, 007 SAY oSay13 PROMPT "Dt.Ensaio:"		SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
    @ 109+13, 041 MSGET oGet13 VAR cDtEnsaio			SIZE 035, 009 OF oFolder1:aDialogs[1] PICTURE "99/99/99" COLORS 0, 16777215 PIXEL
    @ 110+13, 109 SAY oSay14 PROMPT "Hr.Ensaio:"		SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
    @ 109+13, 143 MSGET oGet14 VAR cHrEnsaio			SIZE 025, 009 OF oFolder1:aDialogs[1] PICTURE "99:99" VALID ValidaHora(cHrEnsaio) COLORS 0, 16777215 PIXEL

    @ 123+13, 007 SAY oSay17 PROMPT "Dt.EventoIni"		SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
    @ 122+13, 041 MSGET oGet17 VAR cDtEventoIni		SIZE 035, 009 OF oFolder1:aDialogs[1] PICTURE "99/99/99" COLORS 0, 12632256 PIXEL READONLY
    @ 123+13, 109 SAY oSay18 PROMPT "Hr.EventoIni"		SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
    @ 122+13, 143 MSGET oGet18 VAR cHrEventoIni		SIZE 025, 009 OF oFolder1:aDialogs[1] PICTURE "99:99" VALID ValidaHora(cHrEventoIni) COLORS 0, 12632256 PIXEL READONLY
    @ 123+13, 202 SAY oSay19 PROMPT "Dt.EventoFim"		SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
    @ 122+13, 236 MSGET oGet19 VAR cDtEventoFim		SIZE 035, 009 OF oFolder1:aDialogs[1] PICTURE "99/99/99" COLORS 0, 12632256 PIXEL READONLY
    @ 123+13, 293 SAY oSay20 PROMPT "Hr.EventoFim"		SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
    @ 122+13, 327 MSGET oGet20 VAR cHrEventoFim		SIZE 025, 009 OF oFolder1:aDialogs[1] PICTURE "99:99" VALID ValidaHora(cHrEventoFim) COLORS 0, 12632256 PIXEL READONLY
    
    @ 136+13, 007 SAY oSay21 PROMPT "Dt.Desm.Ini:"		SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
    @ 135+13, 041 MSGET oGet21 VAR cDtDesmIni			SIZE 035, 009 OF oFolder1:aDialogs[1] PICTURE "99/99/99" COLORS 0, 16777215 PIXEL
    @ 136+13, 109 SAY oSay22 PROMPT "Hr.Desm.Ini:"		SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
    @ 135+13, 143 MSGET oGet22 VAR cHrDesmIni			SIZE 025, 009 OF oFolder1:aDialogs[1] PICTURE "99:99" VALID ValidaHora(cHrDesmIni) COLORS 0, 16777215 PIXEL
    @ 136+13, 202 SAY oSay23 PROMPT "Dt.Desm.Fim:"		SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
    @ 135+13, 236 MSGET oGet23 VAR cDtDesmFim			SIZE 035, 009 OF oFolder1:aDialogs[1] PICTURE "99/99/99" COLORS 0, 16777215 PIXEL
    @ 136+13, 293 SAY oSay24 PROMPT "Hr.Desm.Fim:"		SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
    @ 135+13, 327 MSGET oGet24 VAR cHrDesmFim			SIZE 025, 009 OF oFolder1:aDialogs[1] PICTURE "99:99" VALID ValidaHora(cHrDesmFim) COLORS 0, 16777215 PIXEL
    
    @ 149+13, 007 SAY oSay25 PROMPT "Dt.Viagem 3:"		SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
    @ 148+13, 041 MSGET oGet25 VAR cDtViagem3			SIZE 035, 009 OF oFolder1:aDialogs[1] PICTURE "99/99/99" COLORS 0, 16777215 PIXEL
    @ 149+13, 109 SAY oSay26 PROMPT "Hr.Viagem 3:"		SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
    @ 148+13, 143 MSGET oGet26 VAR cHrViagem3			SIZE 025, 009 OF oFolder1:aDialogs[1] PICTURE "99:99" VALID ValidaHora(cHrViagem3) COLORS 0, 16777215 PIXEL
    @ 149+13, 202 SAY oSay27 PROMPT "Dt.Viagem 4:"		SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
    @ 148+13, 236 MSGET oGet27 VAR cDtViagem4			SIZE 035, 009 OF oFolder1:aDialogs[1] PICTURE "99/99/99" COLORS 0, 16777215 PIXEL
    @ 149+13, 293 SAY oSay28 PROMPT "Hr.Viagem 3:"		SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
	@ 148+13, 327 MSGET oGet28 VAR cHrViagem4			SIZE 025, 009 OF oFolder1:aDialogs[1] PICTURE "99:99" VALID ValidaHora(cHrViagem4) COLORS 0, 16777215 PIXEL //Hr.Viagem 4
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³EQUIP. ORCADOS E TECNICOS - ( SZ2 / SZ3 )³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	@ 004, 005 SAY oSay29 PROMPT OemToAnsi("Acessórios / Equipamentos") SIZE 100, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
        
	@ 006, 005 SAY oSGrupo PROMPT "Grupo:" SIZE 020, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
	@ 005, 023 MSCOMBOBOX oCmbGrupo VAR cCmbGrupo ITEMS aGrupos SIZE 068, 010 OF oFolder1:aDialogs[2] COLORS 0, 16777215 ON CHANGE M->Z4_GRUPO := Left(Right(cCmbGrupo,2),1) PIXEL //M->Z4_GRUPO:=Left(Right(aGrupos[nCmbGrupo],2),1), 

	@ 006, 095 SAY oSay30 PROMPT "Produto:" SIZE 020, 008 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL           								
	@ 004, 120 MSGET oProduto VAR cProduto F3 "SB1SZ5" VALID SB1->(dbSeek(xFilial("SB1")+cProduto)) SIZE 093, 010 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
	
	@ 006, 217 SAY oSQuant PROMPT "Quant.:" SIZE 020, 008 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
	@ 004, 240 MSGET oQtTec VAR cQtTec SIZE 030, 010 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
    
	@ 004, 320 BUTTON oButton1 PROMPT "Incluir" SIZE 030, 012 OF oFolder1:aDialogs[2] ACTION {||	IIF(Len(aProdTec)==0 .Or. (Len(aProdTec)>0 .And. aProdTec[1][2]==""),;
																										IIF(Len(cCmbGrupo)>0 .And. Len(cProduto)>0 .And. Len(cQtTec)>0,;
																											ASize(aProdTec,0),;
																											.T.),;
																										.T.),;
																									IIF(Len(cCmbGrupo)>0 .And. Len(cProduto)>0 .And. Len(cQtTec)>0,;
																										Aadd(aProdTec,{Len(aProdTec)+1,Substr(cCmbGrupo,1,At(" ",cCmbGrupo)),cProduto,Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_DESC"),Alltrim(cQtTec),""}),;
																										.T.),;
																									cCmbGrupo := "",;
																									cProduto := Space(30),;
																									cQtTec := Space(8);
																								}  PIXEL
	
	@ 004, 355 BUTTON oButton2 PROMPT "Excluir" SIZE 030, 012 OF oFolder1:aDialogs[2] ACTION {||   lEquip:= .F. ,;
																									lResp := .F. ,;
																									IIF(aProdTec[oProdTec:nAt,6] == "*",;
																										lEquip:=.T. ,;
																										lEquip:=.F.),;
																									IIF(lEquip,;	
																										IIF(APMsgYesNo(OemToAnsi("Deseja excluir Equipamento Orçado ") + Alltrim(aProdTec[oProdTec:nAt,3]) + "?"),;
																											lResp:=.T.,;
																											.T.),;
																										.T.),;
																									IIF((lEquip .And. lResp) .Or. !lEquip,;
																										ADEL(aProdTec,oProdTec:nAt),;
																										.T.),;
																									IIF((lEquip .And. lResp) .Or. !lEquip,;
																										ASIZE(aProdTec,Len(aProdTec)-1),;
																										.T.),;
																									IIF(Len(aProdTec)==0,;
																										Aadd(aProdTec,{"","","","","",""}),;
																										.T.);
																								} PIXEL

    @ 017, 005 LISTBOX oProdTec Fields HEADER "","Grupo","Cod.Prod.","Descricao Tecnica","Quantidade","Tipo" SIZE 380, 215 OF oFolder1:aDialogs[2] PIXEL ColSizes 5,40,40,100,40,5

    oProdTec:Lhscroll := .F.
    oProdTec:SetArray(aProdTec)

    oProdTec:bLine := {|| { IIF(aProdTec[oProdTec:nAt,2]=="","",oProdTec:nAt), aProdTec[oProdTec:nAt,2], aProdTec[oProdTec:nAt,3], aProdTec[oProdTec:nAt,4], aProdTec[oProdTec:nAt,5], aProdTec[oProdTec:nAt,6] } }
	
    // DoubleClick event
    oProdTec:bLDblClick := {|| oProdTec:DrawSelect() }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ LIBERA REMESSA / RETORNO DE EQUIPAMENTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTexto1 :=	OemToAnsi("Liberar JOB para Emissão de  Nota Fiscal para Remessa")
	cTexto2 :=	OemToAnsi("Conclusão do JOB com o Retorno do Equipamento.") + chr(13) + ;
				OemToAnsi("Esta etapa é importante para o controle de quantidade em Estoque") + chr(13) + ;
				OemToAnsi("e futuros Agendamentos de Equipamento.")
				
    @ 036, 057 BUTTON oButton1 PROMPT "Liberar Remessa" SIZE 079, 033 OF oFolder1:aDialogs[3] ACTION LiberaRemessa((cAlias)->Z2_CODJOB) PIXEL
    @ 090, 057 BUTTON oButton2 PROMPT "Retorno de Equipamento" SIZE 079, 033 OF oFolder1:aDialogs[3] ACTION RetornoEquipam((cAlias)->Z2_CODJOB)PIXEL
    @ 050, 148 SAY oSay1 PROMPT cTexto1 SIZE 141, 009 OF oFolder1:aDialogs[3] COLORS 0, 16777215 PIXEL
    @ 097/*102*/, 148 SAY oSay2 PROMPT cTexto2 SIZE 170, 023 OF oFolder1:aDialogs[3] COLORS 0, 16777215 PIXEL

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| nOpcA := 1, oDlg:End() }, {|| oDlg:End() })

If nOpcA == 1
	If lAlterar
		If APMsgYesNo(OemToAnsi("Deseja salvar as alterações?"))
			
			BEGIN TRANSACTION
			
			//Gravar os campos de Data e Hora no SZ1
			dbSelectArea("SZ1")
			dbSeek(xFilial("SZ1")+(cAlias)->Z2_CODJOB) //Z1_FILIAL+Z1_CODJOB+Z1_CLIENTE+Z1_EVENTO

			RecLock( "SZ1", .F. )
			SZ1->Z1_DTCARGM	:= 	cDtCarrega
			SZ1->Z1_HRCARGM	:= 	cHrCarrega
			SZ1->Z1_DTVGM1	:= 	cDtViagem1
			SZ1->Z1_DTVGM2	:= 	cDtViagem2
			SZ1->Z1_HRVGM1	:= 	cHrViagem1
			SZ1->Z1_HRVGM2	:= 	cHrViagem2
			SZ1->Z1_DTMONT1	:= 	cDtMontaIni
			SZ1->Z1_DTMONT2	:= 	cDtMontaFim
			SZ1->Z1_HRMONT1	:= 	cHrMontaIni
			SZ1->Z1_HRMONT2	:= 	cHrMontaFim
			SZ1->Z1_DTEVINI	:= 	cDtEventoIni
			SZ1->Z1_DTEVFIM	:= 	cDtEventoFim
			SZ1->Z1_HREVINI	:= 	cHrEventoIni
			SZ1->Z1_HREVFIM	:= 	cHrEventoFim
			SZ1->Z1_DTDESM1	:= 	cDtDesmIni
			SZ1->Z1_DTDESM2	:= 	cDtDesmFim
			SZ1->Z1_HRDESM1	:= 	cHrDesmIni
			SZ1->Z1_HRDESM2	:= 	cHrDesmFim
			SZ1->Z1_DTVGM3	:= 	cDtViagem3
			SZ1->Z1_DTVGM4	:= 	cDtViagem4
			SZ1->Z1_HRVGM3	:= 	cHrViagem3
			SZ1->Z1_HRVGM4	:= 	cHrViagem4		
			SZ1->(MsUnLock())
	 //		dbSetOrder(1)
	 //		If SZ1->( dbSeek(xFilial("SZ1")+) )
			
			//Gravar os equipamentos orcados
			//  se houver alteracao, informar Area Comercial
			//+++ nao sera feito no momento, o aviso sera verbal da area tecnica para a area comercial
			
			//Antes de Gravar, excluir todos os equipamentos anteriores
			DbSelectArea("SZ3")
			DbSetOrder(1) //Z3_FILIAL+Z3_CODJOB+Z3_ITEM+Z3_ORCPROD
			If SZ3->( DbSeek(xFilial("SZ3") + (cAlias)->Z2_CODJOB) )
				While SZ3->( !Eof() .And. (cAlias)->Z2_CODJOB == SZ3->Z3_CODJOB)
					SZ3->(RecLock("SZ3",.F.))
					SZ3->(DbDelete())
					SZ3->(MsUnLock())
					SZ3->(dbSkip())
				End
//				__DBPACK()
			EndIf
			
//			DbSelectArea("SZ3")
//			DbSetOrder(1) //Z3_FILIAL+Z3_CODJOB+Z3_ITEM+Z3_ORCPROD
//			DbSeek(xFilial("SZ3") + (cAlias)->Z2_CODJOB)
			
			//Gravar todos os equipamentos e acessorios no SZ3
			For i:=1 to Len(aProdTec)
				RecLock( "SZ3", .T. )
				SZ3->Z3_FILIAL	 := xFilial("SZ3")
				SZ3->Z3_CODJOB	 := (cAlias)->Z2_CODJOB
				SZ3->Z3_RESERVA	 := (cAlias)->Z2_RESERVA
				SZ3->Z3_ORCADO	 := IIF(aProdTec[i][6] == "*","1","0")
				SZ3->Z3_ORCALT	 := "0"
//				SZ3->Z3_ORCOBS	 := ""
//				SZ3->Z3_TECOBS	 := ""
				SZ3->Z3_ITEM	 := Alltrim(Str(aProdTec[i][1]))
				If aProdTec[i][6] == "*"
					SZ3->Z3_ORCPROD	 := aProdTec[i][3]
					SZ3->Z3_ORCQT	 := Val(aProdTec[i][5])
					SZ3->Z3_TECPROD	 := aProdTec[i][3]
					SZ3->Z3_TECQT	 := Val(aProdTec[i][5])
				Else
//					SZ3->Z3_ORCPROD	 := ""
//					SZ3->Z3_ORCQT	 := ""
					SZ3->Z3_TECPROD	 := aProdTec[i][3]
					SZ3->Z3_TECQT	 := Val(aProdTec[i][5])
				EndIf
				
				SZ3->(MsUnLock())
			Next
			
			END TRANSACTION
			
//			MsgInfo(OemToAnsi("Agendamento de Equipamentos e Acessórios foi efetuado com Sucesso!"))
		EndIf
	Else
		//Visualizar == .F.
		MsgErro(OemToAnsi("Agenda Bloqueada para Alteração"),OemToAnsi("Atenção"))
	EndIf
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Liberar    ³ Autor ³ Murilo Swistalski   ³ Data ³08/06/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de Liberacao de NF's para remessa					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para WDB									      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function Liberar(cAlias,nReg,nOpc)

Return

Static Function MostraProdTec(lBrowseCriado,aNOVO)
Default aNovo := {}

If lBrowseCriado //APENAS quando o WBrowse1 ja tiver sido criado

    oProdTec:bLine := {|| {;
					      aProdTec[oProdTec:nAt,1],;
					      aProdTec[oProdTec:nAt,2],;
					      aProdTec[oProdTec:nAt,3],;
					      aProdTec[oProdTec:nAt,4],;
					      aProdTec[oProdTec:nAt,5],;
					      aProdTec[oProdTec:nAt,6];
					    }}

    oProdTec:Refresh()

Else

    @ 027, 005 LISTBOX oProdTec Fields HEADER "","Grupo","Cod.Prod.","Descricao Tecnica","Quantidade","" SIZE 380, 073 OF oPanel3 PIXEL ColSizes 5,40,40,100,40,5

    oProdTec:Lhscroll := .F.
    oProdTec:SetArray(aProdTec)
    oProdTec:bLine := {|| {;
					      aProdTec[oProdTec:nAt,1],;
					      aProdTec[oProdTec:nAt,2],;
					      aProdTec[oProdTec:nAt,3],;
					      aProdTec[oProdTec:nAt,4],;
					      aProdTec[oProdTec:nAt,5],;
					      aProdTec[oProdTec:nAt,6];
					    }}
	
    // DoubleClick event
//    oProdTec:bLDblClick := {|| aProdTec[oProdTec:nAt,1] := !aProdTec[oProdTec:nAt,1],;
    oProdTec:bLDblClick := {|| MsgAlert(oProdTec:bLine), MsgAlert(oProdTec:nAt),;
      oProdTec:DrawSelect()}

EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AlteraLista³ Autor ³ Murilo Swistalski   ³ Data ³09/06/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Altera intens da lista de Equipamentos					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para WDB									      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
/*
User Function AlteraLista(aProdTec,nPos)
Local nOpcA := 0
Local oSay1, oSay2, oSay3
Local oGrupo
Local cGrupo := ""
Local oProd
Local cProd := Space(30)
Local oQtTec
Local cQtTec := Space(8)

Local oCmbGrupo
Local cCmbGrupo := ""
Local oProduto
Local cProduto := Space(30)
Local oQuant
Local cQuant := Space(8)

Local aGrupos := {}
Local aGrupos := {}

aAdd(aGrupos,"") //Primeiro da Lista, em Branco

dbSelectArea("SBM")
dbSetOrder(1)
dbGoTop()
While !EOF()
	If Val(SBM->BM_GRUPO) > 10 //+++ verificar se 1001 a 1007 para comercial e 2001 a 20?? para tecnicos
		aAdd(aGrupos,Alltrim(SBM->BM_DESC) + " - ("+SBM->BM_GRUPO+")")
	EndIf
	SBM->(dbSkip())
End

DEFINE MSDIALOG oDlg1 TITLE "Equipamento - Alterar" FROM 26,0 TO 200,500 OF oDlg PIXEL

@ 016, 005 MSPANEL oPanel1 SIZE 100, 050 OF oDlg1 COLORS 0, 16777215 RAISED

@ 006, 005 SAY oSay1 PROMPT "Grupo:" SIZE 020, 007 OF oPanel1 COLORS 0, 16777215 PIXEL
@ 005, 023 MSGET oGrupo VAR cCGrupo SIZE 068, 010 OF oPanel1 COLORS 0, 16777215 READONLY PIXEL
@ 006, 095 SAY oSay2 PROMPT "Produto:" SIZE 020, 008 OF oPanel1 COLORS 0, 16777215 PIXEL
@ 004, 120 MSGET oProd VAR cProd SIZE 093, 010 OF oPanel1 COLORS 0, 16777215 READONLY PIXEL
@ 006, 217 SAY oSay3 PROMPT "Quant.:" SIZE 020, 008 OF oPanel1 COLORS 0, 16777215 PIXEL
@ 004, 240 MSGET oQtTec VAR cQtTec SIZE 030, 010 OF oPanel1 COLORS 0, 16777215 READONLY PIXEL

@ 019, 005 SAY oSay4 PROMPT "Grupo:" SIZE 020, 007 OF oPanel1 COLORS 0, 16777215 PIXEL
@ 018, 023 MSCOMBOBOX oCmbGrupo VAR cCmbGrupo ITEMS aGrupos SIZE 068, 010 OF oPanel1 COLORS 0, 16777215 ON CHANGE M->Z4_GRUPO := Left(Right(cCmbGrupo,2),1) PIXEL

@ 019, 095 SAY oSay4 PROMPT "Produto:" SIZE 020, 008 OF oPanel1 COLORS 0, 16777215 PIXEL           								
@ 018, 120 MSGET oProduto VAR cProduto F3 "SB1SZ5" VALID SB1->(dbSeek(xFilial("SB1")+cProduto)) SIZE 093, 010 OF oPanel1 COLORS 0, 16777215 PIXEL

@ 019, 217 SAY oSay4 PROMPT "Quant.:" SIZE 020, 008 OF oPanel1 COLORS 0, 16777215 PIXEL
@ 018, 240 MSGET oQuant VAR cQuant SIZE 030, 010 OF oPanel1 COLORS 0, 16777215 PIXEL    

ACTIVATE MSDIALOG oDlg1 CENTERED ON INIT EnchoiceBar(oDlg1, {|| nOpcA := 1, oDlg1:End() }, {|| oDlg1:End() })

If nOpcA == 1
	
EndIf

Return .T.
*/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ValidaHora ³ Autor ³ Murilo Swistalski   ³ Data ³21/05/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de Agendamento de Equipamentos					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para WDB									      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ValidaHora(cHora)
Local lRet := .F.
Local nHora

nHora := Val(Substr(cHora,1,2))
nMin :=  Val(Substr(cHora,4,2))

If ( cHora == "  :  " .Or. cHora == "     " ) .And. ( nHora == 0 .And. nMin == 0 )
	lRet := .T.
Else                                           	
	If (nHora >= 1 .And. nHora <=24) .And. (nMin <=59)
		lRet := .T.
	EndIf
EndIf

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CarregaProd ³ Autor ³ Murilo Swistalski  ³ Data ³21/05/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de Agendamento de Equipamentos					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para WDB									      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CarregaProd(cGrupo)
Local aLista := {}

aAdd(aLista,"")

dbSelectArea("SB1")
dbSetOrder(4)

If SB1->(dbSeek(xFilial("SB1")+Left(Right(cGrupo,5),4)))
	aAdd(aLista,SB1->B1_COD)
EndIf

aProdutos := aLista
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IncluiProd  ³ Autor ³ Murilo Swistalski  ³ Data ³21/05/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de Inclusao de Agendamento de Produtos			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para WDB									      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function IncluiProd(aArray,cGrupo,cProduto,cQuant)
Local aArea	 := GetArea()
Local cDescr := ""
Local aTMP	 := {}

If	Alltrim(cGrupo) == "" .Or.;
	Alltrim(cProduto) == "" .Or.;
	Alltrim(cQuant) == ""
	Return aArray
EndIF

//Verificar se o produto digitado existe
dbSelectArea("SB1")
dbSetOrder(1)
If SB1->( dbSeek( xfilial("SB1") + cProduto ) ) 
	cDescr := Alltrim(SB1->B1_DESC)
Else
	Return aArray
EndIf

//Usar a primeira linha
If aArray[1][2] == ""
	ASize(aArray,0) //zera o array
EndIf

	aAdd(aArray,{	Len(aArray)+1,;
					Substr(cGrupo,1,Len(cGrupo)-9),;
					cProduto,;
					cDescr,;
					cQuant,;
					""})
					
//+++ Sera a sequencia de grupos da Area Tecnica
aGrupos := {"Sonorizacao","Iluminacao","Projecao","Filmes","Cenografia","Logistica"}

//nLin := 0
//Ordenar array por Grupo
For i:=1 to Len(aGrupos)
	For j:=1 to Len(aArray)	
		If aArray[j][2] == aGrupos[i]
			aAdd(aTMP,{Len(aTMP)+1,aArray[j][2],aArray[j][3],aArray[j][4],aArray[j][5],aArray[j][6]})
		EndIf
	Next
Next

aArray := AClone(aTMP)

RestArea(aArea)
Return aArray


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MontaORC   ³ Autor ³ Murilo Swistalski   ³ Data ³28/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta aHeader e aCols dos arquivos Temporarios             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para WDB									      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MontaORC( nOpc )
Local nNUM	 := SZ4->Z4_NUM
Local cChave := nNUM
Local cAlias := "SZ5"
Local nI	 := 0

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta aHeader³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !EOF() .And. X3_ARQUIVO == cAlias
	If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
		AADD( aHeader, { Trim( X3Titulo() ),;
						X3_CAMPO,;
						X3_PICTURE,;
						X3_TAMANHO,;
						X3_DECIMAL,;
						X3_VALID,;
						X3_USADO,;
						X3_TIPO,;
						X3_ARQUIVO,;
						X3_CONTEXT})
	Endif
	dbSkip()
End
dbUnLock()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta aCols  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpc <> 3
	dbSelectArea( "SZ5" )
	SZ5->( dbSetOrder(1) )
	SZ5->( dbSeek( xFilial( "SZ5" ) + cChave ) )

	While !EOF() .And. xFilial( "SZ5" ) + cChave == SZ5->Z5_FILIAL + SZ5->Z5_NUMZ4
	
		AADD( aCOLS, Array( Len( aHeader ) + 1 ) )
		
		For nI := 1 To Len( aHeader )
			If aHeader[nI,10] == "V"
				aCOLS[Len(aCOLS),nI] := CriaVar(aHeader[nI,2],.T.)
			Else
				aCOLS[Len(aCOLS),nI] := FieldGet(FieldPos(aHeader[nI,2]))
			Endif
		Next nI
		
		aCOLS[Len(aCOLS),Len(aHeader)+1] := .F.
		dbSkip()
		
	End
	
Else

	AADD( aCOLS, Array( Len( aHeader ) + 1 ) )
	
	For nI := 1 To Len( aHeader )
		aCOLS[1, nI] := CriaVar( aHeader[nI, 2], .T. )
	Next nI
	
	aCOLS[1, GdFieldPos("Z5_ITEM")] := "01"
	aCOLS[1, Len( aHeader )+1 ] := .F.
	
Endif

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Projecao    ³ Autor ³ Murilo Swistalski  ³ Data ³24/05/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tela de Projecao das Informacoes na Parede				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para WDB									      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function Projecao(cAlias, nReg, nOpc)
Local aArea := GetArea()
Local aList := {} // Vetor com elementos do Browse
Local oCor := LoadBitmap(GetResources(),'BR_BRANCO')
Local aCor := {} // Vetor com as cores
Local cCor := ""
Local aRegistro := {}
Local nX
Local nCont := 0

dbSelectArea("SZ1")

// Cria Vetor e preenche com as informacoes
clQry := "SELECT Z1_STATUS, Z1_CODJOB, Z1_EVENTO, Z1_ATENDE, Z1_CLIENTE, Z1_LOCAL, Z1_FORASP,"
clQry += "	     Z1_DTVGM1, Z1_DTMONT1, Z1_DTEVINI, Z1_DTEVFIM, Z1_DTDESM1, Z1_DTVGM3,"
clQry += "	     Z1_DIRTEC, Z1_RESPONS "
clQry += "FROM "+RetSqlName("SZ1")+" SZ1 "
clQry += "ORDER BY Z1_DTVGM1 DESC, Z1_DTMONT1 DESC, Z1_DTEVINI DESC, Z1_CODJOB DESC"

clQry := ChangeQuery( clQry )
dbUseArea( .T., "TopConn", TCGenQry(,,clQry), "QZ1", .F., .F. )
                  
QZ1->( dbEval( {|| nCont++ } ) )
QZ1->( dbGoTop() )

While QZ1->( !Eof() )
    
	clQry := "SELECT Z4_GRUPO "
	clQry += "FROM "+RetSqlName("SZ4")+" SZ4 "
	clQry += "WHERE Z4_STATUS = 1 AND Z4_CODJOB = '" + QZ1->Z1_CODJOB + "' "
	clQry += "ORDER BY Z4_GRUPO , Z4_VERSAO DESC"
	
	clQry := ChangeQuery( clQry )
	dbUseArea( .T., "TopConn", TCGenQry(,,clQry), "QZ4", .F., .F. )
	                  
//	QZ4->( dbEval( {|| nCont++ } ) )
	QZ4->( dbGoTop() )
	cLetras := ""
	While QZ4->( !Eof() )
		Do Case
			Case QZ4->Z4_GRUPO == "1"	// JOB 0% - Aberto
		 		cLetras += "S"
			Case QZ4->Z4_GRUPO == "2"	// JOB 0% - Aberto
		 		cLetras += "I"
			Case QZ4->Z4_GRUPO == "3"	// JOB 0% - Aberto
		 		cLetras += "P"
			Case QZ4->Z4_GRUPO == "4"	// JOB 0% - Aberto
		 		cLetras +8= "F"
			Case QZ4->Z4_GRUPO == "5"	// JOB 0% - Aberto
		 		cLetras += "C"
			Case QZ4->Z4_GRUPO == "6"	// JOB 0% - Aberto
		 		cLetras += "L"
		EndCase	
		
		QZ4->(dbSkip())
	End

	DbSelectArea("QZ4")
	DbCloseArea()

	aListAux := {	"" ,;
	Alltrim(Str(Val(QZ1->Z1_CODJOB)	))	,;	//1
			Alltrim(QZ1->Z1_EVENTO)		,;	//2
			Alltrim(QZ1->Z1_ATENDE)		,;	//3
			Alltrim(QZ1->Z1_CLIENTE)	,;	//4
			Alltrim(QZ1->Z1_LOCAL)		,;	//5
	IF(QZ1->Z1_FORASP=='0','X','')		,;	//6
	Substr(QZ1->Z1_DTVGM1, 7,2) + "/" + Substr(QZ1->Z1_DTVGM1, 5,2) + "/" + Substr(QZ1->Z1_DTVGM1, 3,2)	,;	//7
	Substr(QZ1->Z1_DTMONT1,7,2) + "/" + Substr(QZ1->Z1_DTMONT1,5,2) + "/" + Substr(QZ1->Z1_DTMONT1,3,2)	,;	//8
	Substr(QZ1->Z1_DTEVINI,7,2) + "/" + Substr(QZ1->Z1_DTEVINI,5,2) + "/" + Substr(QZ1->Z1_DTEVINI,3,2)	,;	//9
	Substr(QZ1->Z1_DTEVFIM,7,2) + "/" + Substr(QZ1->Z1_DTEVFIM,5,2) + "/" + Substr(QZ1->Z1_DTEVFIM,3,2)	,;	//10
	Substr(QZ1->Z1_DTDESM1,7,2) + "/" + Substr(QZ1->Z1_DTDESM1,5,2) + "/" + Substr(QZ1->Z1_DTDESM1,3,2)	,;	//11
	Substr(QZ1->Z1_DTVGM3, 7,2) + "/" + Substr(QZ1->Z1_DTVGM3, 5,2) + "/" + Substr(QZ1->Z1_DTVGM3, 3,2)	,;	//12
					cLetras				,;	//13
			Alltrim(QZ1->Z1_DIRTEC)		,;	//14
			Alltrim(QZ1->Z1_RESPONS)	}	//15
	aAdd(aList, aListAux)
	
	Do Case
	Case QZ1->Z1_STATUS == " "	// JOB 0% - Aberto
		 cCor := "BR_AZUL"
	Case QZ1->Z1_STATUS == "A"	// JOB 0% - Aberto
		 cCor := "BR_AZUL"
	Case QZ1->Z1_STATUS == "B"	// JOB 25% - com chance, sem prioridade
		 cCor := "BR_AMARELO"
	Case QZ1->Z1_STATUS == "C"	// JOB 50% - Cliente deu retorno
		 cCor := "BR_PINK"
	Case QZ1->Z1_STATUS == "D"	// JOB 75% - em negociacao
		 cCor := "BR_LARANJA"
	Case QZ1->Z1_STATUS == "E"	// JOB 90% - Tentou fechar, mas nao tinha checklist
		 cCor := "BR_BRANCO"
	Case QZ1->Z1_STATUS == "F"	// JOB 100% - Fechou
		 cCor := "BR_VERDE"
	Case QZ1->Z1_STATUS == "G"	// JOB Encerrado - Concluido
		 cCor := "BR_PRETO"
	Case QZ1->Z1_STATUS == "H"	// JOB CAIU - Cancelado, nao deu certo
		 cCor := "BR_VERMELHO"
	EndCase	
	
	aAdd(aCor, cCor)
	
	If SZ1->( dbSeek( xFilial("SZ1") + QZ1->Z1_CODJOB ) )	
		aAdd(aRegistro, SZ1->(Recno()) )
	EndIf
	
	QZ1->(dbSkip())
End

DbSelectArea("QZ1")
DbCloseArea()

//Trata as cores do Status
	
DEFINE MSDIALOG oDlg0 FROM 0,0 TO 710,1000 PIXEL TITLE "Listagem de JOB's"
	// Cria objeto de fonte que sera usado na Browse
	Define Font oFont Name 'Courier New' Size 0, -11

	// Cria Browse
	oList := TCBrowse():New( 000 , 000,  501, 358,,{'','JOB   ','Evento','Atendimento','Cliente','Local','','Viagem ','Monta  ','Entrega','Termino','Desmonta','Retorno','Servicos','Diretor','Resp.'},;
													{5 ,15   ,50      ,45           ,40       ,45     ,5 ,10      ,10     ,10       ,10       ,10        ,10       ,35        ,40       ,40     },;
													oDlg0, , , , ,/*{||}*/ , , oFont, , , , ,.F. , ,.T. , ,.F., , , )
	// Seta o vetor a ser utilizado
	oList:SetArray(aList)
	
	// Monta a linha a ser exibida no Browse
	oList:bLine := {||{ LoadBitmap(GetResources(),aCor[oList:nAt]) ,;
							  aList[oList:nAt,02] ,;
							  aList[oList:nAt,03] ,;
							  aList[oList:nAt,04] ,;
							  aList[oList:nAt,05] ,;
							  aList[oList:nAt,06] ,;
							  aList[oList:nAt,07] ,;
					Transform(aList[oList:nAt,08],'99/99/99') ,;
					Transform(aList[oList:nAt,09],'99/99/99') ,;
					Transform(aList[oList:nAt,10],'99/99/99') ,;
					Transform(aList[oList:nAt,11],'99/99/99') ,;
					Transform(aList[oList:nAt,12],'99/99/99') ,;
					Transform(aList[oList:nAt,13],'99/99/99') ,;
							  aList[oList:nAt,14] ,;
							  aList[oList:nAt,15] ,;
							  aList[oList:nAT,16] ,;
					} }
	
	// Evento de DuploClick (Visualiza o JOb selecionado)
	oList:bLDblClick := {|| AXVISUAL("SZ1", aRegistro[oList:nAt], 2,,,,,,.T.) }
	
ACTIVATE MSDIALOG oDlg0 CENTERED

RestArea(aArea)
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Projecao    ³ Autor ³ Murilo Swistalski  ³ Data ³24/05/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tela de Alteracao de JOB a partir da Agenda				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para WDB									      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function JOBAgenda(cAlias,nReg,nOpc)
Local nRecno := 0
Local aCpos := {}
Local aVisualiza := {}
Local aAltera := {}

dbSelectArea("SZ1")
dbSeek( xFilial(cAlias) + (cAlias)->Z2_CODJOB )
nRecno := SZ1->(Recno())
DbCloseArea()

aVisualiza := { "Z1_CODJOB","Z1_EVENTO","Z1_CLIENTE","Z1_LOJA",	"Z1_LOCAL",;
				"Z1_ENDEREC","Z1_REFER","Z1_ATENDE","Z1_DIRTEC","Z1_RESPONS","Z1_CONTATO","Z1_CONTTEL",;
				"Z1_DTCARGM","Z1_HRCARGM","Z1_DTVGM1","Z1_HRVGM1","Z1_DTVGM2","Z1_HRVGM2",;
				"Z1_DTMONT1","Z1_HRMONT1","Z1_DTMONT2","Z1_HRMONT2",;
				"Z1_DTEVINI","Z1_DTEVFIM","Z1_HREVINI",	"Z1_HREVFIM",;
				"Z1_DTDESM1","Z1_HRDESM1","Z1_DTDESM2",	"Z1_HRDESM2",;
				"Z1_DTVGM3","Z1_HRVGM3","Z1_DTVGM4","Z1_HRVGM4",;
				"Z1_DESCJOB","Z1_OBSGERA",;
				"Z1_TETPVEI","Z1_TEQTPE","Z1_TEDTSAI","Z1_TEDIASD",	"Z1_TEDTRET","Z1_TERESCO","Z1_TEOBS",;
				"Z1_HEPERIO","Z1_HEQTDPE","Z1_HERESCO","Z1_HEOBS",;
				"Z1_CANUMMO","Z1_CANUMDE","Z1_CARESCO","Z1_CAOBS",;
				"Z1_TCTPVEI","Z1_TCCOMPR","Z1_TCPESO","Z1_TCVALOR","Z1_TCOBS",;
				"Z1_ETVERBA","Z1_ETDIAAL","Z1_ETRESP","Z1_ETOBS",;
				}

aAltera := {"Z1_DTCARGM","Z1_HRCARGM","Z1_DTVGM1" ,"Z1_HRVGM1" ,"Z1_DTVGM2" ,"Z1_HRVGM2" ,;
			"Z1_DTMONT1","Z1_HRMONT1","Z1_DTMONT2","Z1_HRMONT2","Z1_HREVINI","Z1_HREVFIM",;
			"Z1_DTDESM1","Z1_HRDESM1","Z1_DTDESM2","Z1_HRDESM2","Z1_DTVGM3" ,"Z1_HRVGM3" ,"Z1_DTVGM4","Z1_HRVGM4","Z1_OBSGERA",;
			"Z1_TETPVEI","Z1_TEQTPE" ,"Z1_TEDTSAI","Z1_TEDIASD","Z1_TEDTRET","Z1_TERESCO","Z1_TEOBS" ,;
			"Z1_HEPERIO","Z1_HEQTDPE","Z1_HERESCO","Z1_HEOBS",;
			"Z1_CANUMMO","Z1_CANUMDE","Z1_CARESCO","Z1_CAOBS",;
			"Z1_TCTPVEI","Z1_TCCOMPR","Z1_TCPESO" ,"Z1_TCVALOR","Z1_TCOBS"  ,;
			"Z1_ETVERBA","Z1_ETDIAAL","Z1_ETRESP" ,"Z1_ETOBS"  }

aCpos := {	"Z1_LOCAL","Z1_ENDEREC","Z1_REFER","Z1_ATENDE","Z1_DIRTEC","Z1_RESPONS","Z1_CONTATO","Z1_CONTTEL",;
			"Z1_DTCARGM","Z1_HRCARGM","Z1_DTVGM1","Z1_HRVGM1","Z1_DTVGM2","Z1_HRVGM2",;
			"Z1_DTMONT1","Z1_HRMONT1","Z1_DTMONT2","Z1_HRMONT2","Z1_HREVINI","Z1_HREVFIM",;
			"Z1_DTDESM1","Z1_HRDESM1","Z1_DTDESM2","Z1_HRDESM2","Z1_DTVGM3","Z1_HRVGM3","Z1_DTVGM4","Z1_HRVGM4",;
			"Z1_DESCJOB","Z1_OBSGERA",;
			"Z1_TETPVEI","Z1_TEQTPE","Z1_TEDTSAI","Z1_TEDIASD","Z1_TEDTRET","Z1_TERESCO","Z1_TEOBS",;
			"Z1_HEPERIO","Z1_HEQTDPE","Z1_HERESCO","Z1_HEOBS",;
			"Z1_CANUMMO","Z1_CANUMDE","Z1_CARESCO","Z1_CAOBS",;
			"Z1_TCTPVEI","Z1_TCCOMPR","Z1_TCPESO","Z1_TCVALOR","Z1_TCOBS",;
			"Z1_ETVERBA","Z1_ETDIAAL","Z1_ETRESP","Z1_ETOBS";
			}
	
//AXALTERA("SZ1" , nRecno , 4 ,aVisualiza, aAltera)
AXALTERA("SZ1", nRecno, 4,/*aAcho*/, aCpos, /*nColMens*/, /*cMensagem*/, /*cTudoOk*/, /*cTransact*/, /*cFunc*/, /*aButtons*/, /*aParam*/, /*aAuto*/, /*lVirtual*/, .T.)

//RestArea(aArea)
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³LiberaRemessa³ Autor ³ Murilo Swistalski  ³ Data ³08/06/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de Liberacao de JOB para Nota Fiscal de Remessa	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para WDB									      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function LiberaRemessa(cCodJOB)
//Verificar se o status do JOB tem permissao de liberar remessa (apos

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³LiberaRemessa³ Autor ³ Murilo Swistalski  ³ Data ³08/06/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de Liberacao de JOB para Nota Fiscal de Remessa	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para WDB									      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RetornoEquipam(cCodJOB)
// Verificar se o status do JOB tem permissao de liberar remessa

Return
