#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ WDBParam    ³ Autor ³ Murilo Swistalski  ³ Data ³23/06/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de Atualizacao de Parametros da Customizacao do JOB ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para WDB									      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function WDBParam()
Local nOpcA := 0

Local oBVImp
Local cBVImp := Alltrim(Str(GetNewPar("MV_WDBBV","3  ")))
Local oVend
Local cVend := Alltrim(Str(GetNewPar("MV_WDBVEND",501)))
Local oReme
Local cReme := Alltrim(Str(GetNewPar("MV_WDBREME",502)))
Local oServ
Local cServ := Alltrim(Str(GetNewPar("MV_WDBSERV","SERVICO"+Space(15-Len("SERVICO")))))

Local oSay1
Local oSay2
Local oSay3
Local oSay4
Static oDlg

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Parâmetros") FROM 000, 000  TO 500, 500 COLORS 0, 16777215 PIXEL

	@ 023, 011 MSPANEL oPanel1 SIZE 114, 060 OF oDlg COLORS 0, 16777215 RAISED
	
	@ 006, 010 SAY oSay1 PROMPT "MV_WDBVIMP" SIZE 041, 006 OF oPanel1 COLORS 0, 16777215 PIXEL
	@ 005, 054 MSGET oBVImp VAR cBVImp SIZE 047, 010 OF oPanel1 COLORS 0, 16777215 PIXEL
	
	@ 019, 010 SAY oSay2 PROMPT "MV_WDBVEND" SIZE 041, 006 OF oPanel1 COLORS 0, 16777215 PIXEL
	@ 018, 054 MSGET oVend VAR cVend SIZE 047, 010 OF oPanel1 COLORS 0, 16777215 PIXEL
	
	@ 032, 010 SAY oSay3 PROMPT "MV_WDBREME" SIZE 041, 006 OF oPanel1 COLORS 0, 16777215 PIXEL
	@ 031, 054 MSGET oReme VAR cReme SIZE 047, 010 OF oPanel1 COLORS 0, 16777215 PIXEL
	
	@ 045, 010 SAY oSay4 PROMPT "MV_WDBSERV" SIZE 041, 006 OF oPanel1 COLORS 0, 16777215 PIXEL
	@ 044, 054 MSGET oServ VAR cServ SIZE 047, 010 OF oPanel1 COLORS 0, 16777215 PIXEL

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,	{|| nOpcA:=1,	oDlg:End()},;
														 	{|| nOpcA:=2,	oDlg:End()})
IF nOpcA == 1

	If APMsgYesNo("Deseja realmente Alterar o(s) Parâmetro(s)?")

		//Verificar se alterou o parametro	
		//Se alterou, salvar
		If Alltrim(Str(cBVImp)) <> Alltrim(Str(GetNewPar("MV_WDBBV","3")))
			DbSelectArea("SX6")
			If DbSeek("  MV_WDBVIMP")
				//Alterar
		    	RecLock("SX6",.F.)
				SX6->X6_CONTEUD := cBVImp
				SX6->X6_CONTSPA := cBVImp
				SX6->X6_CONTENG := cBVImp
				MsUnlock()
			Else
				//Incluir
				RecLock("SX6",.T.)
				SX6->X6_VAR     := "MV_WDBVIMP"
				SX6->X6_TIPO    := "N"
				SX6->X6_DESCRIC := "Valor do Imposto do Calculo do BV"
				SX6->X6_DSCSPA  := "Valor do Imposto do Calculo do BV"
				SX6->X6_DSCENG  := "Valor do Imposto do Calculo do BV"
				SX6->X6_DESC1   := "sera somado ao Z?_BV digitado no momento do"
				SX6->X6_DSCSPA1 := "sera somado ao Z?_BV digitado no momento do"
				SX6->X6_DSCENG1 := "sera somado ao Z?_BV digitado no momento do"
				SX6->X6_DESC2   := "calculo do orcamento controlado"
				SX6->X6_DSCSPA2 := "calculo do orcamento controlado"
				SX6->X6_DSCENG2 := "calculo do orcamento controlado"
				SX6->X6_CONTEUD := cBVImp
				SX6->X6_CONTSPA := cBVImp
				SX6->X6_CONTENG := cBVImp
				SX6->X6_PROPRI := "U" 
				MsUnlock()
			EndIf
		EndIf
		
		If Alltrim(Str(cVend)) <> Alltrim(Str(GetNewPar("MV_WDBVEND","501")))
			DbSelectArea("SX6")
			If DbSeek("  MV_WDBVEND")
				//Alterar
		    	RecLock("SX6",.F.)
				SX6->X6_CONTEUD := cVend
				SX6->X6_CONTSPA := cVend
				SX6->X6_CONTENG := cVend
				MsUnlock()
			Else
				//Incluir
				RecLock("SX6",.T.)
				SX6->X6_VAR     := "MV_WDBVEND"
				SX6->X6_TIPO    := "C"
				SX6->X6_DESCRIC := "TES padrao utilizada para venda"
				SX6->X6_DSCSPA  := "TES padrao utilizada para venda"
				SX6->X6_DSCENG  := "TES padrao utilizada para venda"
				SX6->X6_DESC1   := "na customizacao do JOB"
				SX6->X6_DSCSPA1 := "na customizacao do JOB"
				SX6->X6_DSCENG1 := "na customizacao do JOB"
				SX6->X6_DESC2   := ""
				SX6->X6_DSCSPA2 := ""
				SX6->X6_DSCENG2 := ""
				SX6->X6_CONTEUD := cVend
				SX6->X6_CONTSPA := cVend
				SX6->X6_CONTENG := cVend
				SX6->X6_PROPRI := "U" 
				MsUnlock()
			EndIf
		EndIf
		
		If Alltrim(Str(cReme)) <> Alltrim(Str(GetNewPar("MV_WDBREME","502")))
			DbSelectArea("SX6")
			If DbSeek("  MV_WDBREME")
				//Alterar
		    	RecLock("SX6",.F.)
				SX6->X6_CONTEUD := cReme
				SX6->X6_CONTSPA := cReme
				SX6->X6_CONTENG := cReme
				MsUnlock()
			Else
				//Incluir
				RecLock("SX6",.T.)
				SX6->X6_VAR     := "MV_WDBREME"
				SX6->X6_TIPO    := "C"
				SX6->X6_DESCRIC := "TES padrao para Remessa"
				SX6->X6_DSCSPA  := "TES padrao para Remessa"
				SX6->X6_DSCENG  := "TES padrao para Remessa"
				SX6->X6_DESC1   := "Utilizada na customizacao do JOB"
				SX6->X6_DSCSPA1 := "Utilizada na customizacao do JOB"
				SX6->X6_DSCENG1 := "Utilizada na customizacao do JOB"
				SX6->X6_DESC2   := ""
				SX6->X6_DSCSPA2 := ""
				SX6->X6_DSCENG2 := ""
				SX6->X6_CONTEUD := cReme
				SX6->X6_CONTSPA := cReme
				SX6->X6_CONTENG := cReme
				SX6->X6_PROPRI := "U" 
				MsUnlock()
			EndIf
		EndIf
	
		If Alltrim(Str(cServ)) <> Alltrim(Str(GetNewPar("MV_WDBSERV","502")))
			DbSelectArea("SX6")
			If DbSeek("  MV_WDBSERV")
				//Alterar
		    	RecLock("SX6",.F.)
				SX6->X6_CONTEUD := cServ
				SX6->X6_CONTSPA := cServ
				SX6->X6_CONTENG := cServ
				MsUnlock()
			Else
				//Incluir
				RecLock("SX6",.T.)
				SX6->X6_VAR     := "MV_WDBSERV"
				SX6->X6_TIPO    := "C"
				SX6->X6_DESCRIC := "Codigo do Produto cadastrado como Servico"
				SX6->X6_DSCSPA  := "Codigo do Produto cadastrado como Servico"
				SX6->X6_DSCENG  := "Codigo do Produto cadastrado como Servico"
				SX6->X6_DESC1   := "utilizado como padrao na customizacao do JOB"
				SX6->X6_DSCSPA1 := "utilizado como padrao na customizacao do JOB"
				SX6->X6_DSCENG1 := "utilizado como padrao na customizacao do JOB"
				SX6->X6_DESC2   := ""
				SX6->X6_DSCSPA2 := ""
				SX6->X6_DSCENG2 := ""
				SX6->X6_CONTEUD := cServ
				SX6->X6_CONTSPA := cServ
				SX6->X6_CONTENG := cServ
				SX6->X6_PROPRI := "U" 
				MsUnlock()
			EndIf
		EndIf
		
		MsgInfo("Os Parâmetros foram Atualizados com Sucesso!")	
	EndIf
Endif

Return
