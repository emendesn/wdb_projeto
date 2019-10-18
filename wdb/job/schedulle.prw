//#INCLUDE "Matr940.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SCHEDULLE³ Autor ³ Microsiga           ³ Data ³ 20/06/2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Agendamento de Equipamentos                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION SCHEDULLE
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva Ambiente                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local	aSavEnv	:=	MSSavEnv()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao do Programa                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private	titulo		:=	"Agendamento de Equipamentos" //+ CHR(13) + "TESTE"
Private	Tamanho		:=	"M"

Private	cDesc1		:=	"Este relatorio demonstra "
Private	cDesc2		:=	"os Equipamentos Agendados e disponiveis no tempo"
Private cDesc3		:=	"" 
Private	cString		:=	"SZ3"
Private	cabec1		:=	""
Private	cabec2		:=	""

Private	lEnd		:=	.F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis de Controle de Impressao                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private	wnrel		:=	"JOBEST"
Private	m_pag		:=	1

Private	aReturn 	:=	{ "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }

Private	cPerg		:=	"WDBAGENDA"
Private	cbcont		:= 0
Private	cbtxt		:=	SPACE(10)

Private	nLastKey	:=	0
Private	nLin		:=	80

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros utilizados:                                       ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ mv_par01 = De Data                                           ³
//³ mv_par02 = Ate Data                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SetPrint                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel	:=	SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho)
If nLastKey==27
	MSSavEnv(aSavEnv)
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica impressora                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault(aReturn,cString)
If nLastKey==27
	MSSavEnv(aSavEnv)
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa relatorio                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|lEnd| Imprime(@lEnd,wnRel,cString,Tamanho)},titulo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura Ambiente                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MSSavEnv(aSavEnv)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Spool de Impressao                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] = 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPRIME  ³ Autor ³ Murilo Swistalski   ³ Data ³ 20/06/2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o Relatorio										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Imprime(lEnd,wnRel,cString,Tamanho)
Local	nPagina		:=	1
Local	nCont		:=	0
                     
Local	aData	:= {}
Local	aProd	:= {}
Local	aProd2	:= {} //controle de quant APENAS  de Status 'F'

PRIVATE dDataDe		:=	mv_par01	,;	//Data Inicial
		dDataAte	:= dDataDe+15	,;	//IIF(mv_par02=="S",dDataDe+7,dDataDe+15),;
		cGrupo		:=	mv_par02		//Grupo de Produtos

cQuery 	:=	"SELECT SZ3.Z3_TECPROD AS PROD,
cQuery  +=  "	   SB1.B1_GRUPO AS GRUPO,
cQuery  +=  "	   SZ3.Z3_TECQT AS QUANT,
//cQuery  +=  "	   SB9.B9_QINI AS QTINI,
cQuery  +=  "	   Z1_STATUS, Z1_DTCARGM, Z1_DTVGM4, Z1_DTEVINI, Z1_DTEVFIM
cQuery  +=  "FROM   ("
cQuery  +=  "	   SELECT Z1_CODJOB, Z1_STATUS,"
cQuery  +=  "	   		  Z1_DTCARGM, Z1_DTEVINI,"
cQuery  +=  "			  Z1_DTEVFIM, Z1_DTVGM4"
cQuery  +=  "	   FROM "+RetSqlName ("SZ1")
cQuery  +=  "	   WHERE D_E_L_E_T_ = '' AND " 
cQuery  +=  "	          Z1_STATUS IN (' ','A','B','C','D','E','F') AND "
cQuery 	+=	"    	   ( (Z1_DTCARGM  >='"+StrZero(Year(dDataDe),4) + StrZero(Month(dDataDe),2)  + StrZero(Day(dDataDe) ,2)+"'  AND"
cQuery 	+=	"			  Z1_DTVGM4  <='"+StrZero(Year(dDataAte),4) + StrZero(Month(dDataAte),2) + StrZero(Day(dDataAte),2)+"') OR"
cQuery 	+=	"       	 (Z1_DTEVINI  >='"+StrZero(Year(dDataDe),4) + StrZero(Month(dDataDe),2)  + StrZero(Day(dDataDe) ,2)+"'  AND"
cQuery 	+=	"			  Z1_DTEVFIM <='"+StrZero(Year(dDataAte),4) + StrZero(Month(dDataAte),2) + StrZero(Day(dDataAte),2)+"') )"
cQuery  +=  "	   ) SZ1 "
cQuery  +=  "INNER JOIN ("
cQuery  +=  "	  SELECT Z2_CODJOB, MAX(Z2_RESERVA) AS RESERVA "
cQuery  +=  "	  FROM "+RetSqlName ("SZ2")
cQuery  +=  "	  WHERE D_E_L_E_T_ = ''" 
cQuery  +=  "	  GROUP BY Z2_CODJOB"
cQuery  +=  "	  ) SZ2 ON SZ1.Z1_CODJOB = SZ2.Z2_CODJOB "
cQuery  +=  "INNER JOIN ("
cQuery  +=  "	  SELECT * FROM "+RetSqlName ("SZ3")
cQuery  +=  "	  WHERE D_E_L_E_T_ = ''"  
cQuery  +=  "	  ) SZ3 ON SZ3.Z3_CODJOB = SZ2.Z2_CODJOB AND SZ3.Z3_RESERVA = SZ2.RESERVA "
cQuery  +=  "INNER JOIN (
cQuery  +=  "     SELECT B1_COD, B1_GRUPO "
cQuery  +=  "     FROM "+RetSqlName ("SB1")
cQuery  +=  "     WHERE D_E_L_E_T_ = '' 
If AllTrim(cGrupo) <> '' //senao, utilizar TODOS os Grupos
	cQuery  +=  "     AND B1_GRUPO = '" + cGrupo + "'"
EndIf
cQuery  +=  "	  ) SB1 ON SB1.B1_COD = SZ3.Z3_TECPROD "
//cQuery  +=  "LEFT JOIN "+RetSqlName ("SB9")+" SB9 ON SB9.B9_COD = SB1.B1_COD
cQuery	  +=  "ORDER BY SB1.B1_GRUPO, SZ3.Z3_TECPROD"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY", .F., .F. )
//IndRegua( "QRY", /*cNomArq*/, "PROD" )

QRY->( dbEval( {|| nCont++ } ) )
QRY->( dbGoTop() )

//cTexto	:= ""
aData	:= {}
dData	:= dDataDe
For i:=1 to dDataAte - dDataDe
//	cTexto += DToC(dData) + "  "
	aAdd(aData,dData)
	dData++
Next

dbSelectArea("SB1")
dbSetOrder(4)
SB1->(dbGoTop())

dbSelectArea("SB2")
dbSetOrder(1)

If AllTrim(cGrupo) == ''
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³TODOS os Grupos de Produtos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While SB1->(!EOF())
		If	SB1->B1_GRUPO $ "1001/1002/1003/1004/1005/1006/1007/1008/1009/1010/1011/1012/1013/1014/1015/1016/1017/1018/1019/1020/1021/1022/1023/1024/1025/1026/1027/1028/1029/1030" .Or. ;
			SB1->B1_GRUPO $ "2001/2002/2003/2004/2005/2006/2007/2008/2009/2010/2011/2012/2013/2014/2015/2016/2017/2018/2019/2020/2021/2022/2023/2024/2025/2026/2027/2028/2029/2030"

			nQtprod := 0
			If SB9->( dbSeek(xFilial("SB9") + SB1->B1_COD) ) //If SB2->( dbSeek(xFilial("SB1") + SB1->B1_COD) )
				If SB9->B9_QINI > 0 //SB2->B2_QATU > 0
					nQtprod := SB9->B9_QINI //nQtprod := SB2->B2_QATU
//				Else
//					MsgStop(OemToAnsi("Produto " + SB1->B1_COD + " não possui Quantidade em Estoque!"))
				EndIf
//			Else
//				MsgStop(OemToAnsi("Produto " + SB1->B1_COD + " não possui Quantidade em Estoque!"))
			EndIf
	
			//Adiciona Produto no Array de Produtos com espacos de Qt por Data
			aAdd(aProd,{SB1->B1_COD,SB1->B1_GRUPO,;
						nQtprod,nQtprod,nQtprod,nQtprod,nQtprod,;
						nQtprod,nQtprod,nQtprod,nQtprod,nQtprod,;
						nQtprod,nQtprod,nQtprod,nQtprod,nQtprod})
			aAdd(aProd2,{SB1->B1_COD,SB1->B1_GRUPO,;
						nQtprod,nQtprod,nQtprod,nQtprod,nQtprod,;
						nQtprod,nQtprod,nQtprod,nQtprod,nQtprod,;
						nQtprod,nQtprod,nQtprod,nQtprod,nQtprod})			
		EndIf
		
		SB1->(dbSkip())
	End
	
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³APENAS o Grupo de Produtos que foi selecionado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SB1->( dbSeek(xFilial("SB1")+cGrupo) )

		While SB1->(!EOF()) .And. cGrupo == SB1->B1_GRUPO

			If	SB1->B1_GRUPO $ "1001/1002/1003/1004/1005/1006/1007/1008/1009/1010/1011/1012/1013/1014/1015/1016/1017/1018/1019/1020" .Or. ;
				SB1->B1_GRUPO $ "2001/2002/2003/2004/2005/2006/2007/2008/2009/2010/2011/2012/2013/2014/2015/2016/2017/2018/2019/2020"

				nQtprod := 0
				If SB9->( dbSeek(xFilial("SB9") + SB1->B1_COD) ) 
					If SB9->B9_QINI > 0
						nQtprod := SB9->B9_QINI
//					Else
//						MsgStop(OemToAnsi("Produto " + SB1->B1_COD + " não possui Quantidade em Estoque!"))
					EndIf
//				Else
//					MsgStop(OemToAnsi("Produto " + SB1->B1_COD + " não possui Quantidade em Estoque!"))
				EndIf
			
				//Adiciona Produto no Array de Produtos com espacos de Qt por Data
//				aAdd(aProd,{SB1->B1_COD,SB1->B1_GRUPO,;
				aAdd(aProd,{SB1->B1_COD,SB1->B1_GRUPO,;
							nQtprod,nQtprod,nQtprod,nQtprod,nQtprod,;
							nQtprod,nQtprod,nQtprod,nQtprod,nQtprod,;
							nQtprod,nQtprod,nQtprod,nQtprod,nQtprod})
/*				aAdd(aProd2,{SB1->B1_COD,SB1->B1_GRUPO,;
							nQtprod,nQtprod,nQtprod,nQtprod,nQtprod,;
							nQtprod,nQtprod,nQtprod,nQtprod,nQtprod,;
							nQtprod,nQtprod,nQtprod,nQtprod,nQtprod}) */
				aAdd(aProd2,{SB1->B1_COD,SB1->B1_GRUPO,;
							0,0,0,0,0,;
							0,0,0,0,0,;
							0,0,0,0,0})
			EndIf
			
			SB1->(dbSkip())
		End
	Else
		MsgStop("Nenhum Produto Encontrado no Grupo Informado")
	EndIf	
EndIf

dbSelectArea("QRY")
QRY->( dbGoTop() )
//Varrer todo o array de produtos
For i:=1 to Len(aProd)
//Procurar em todo o QRY pelo Produto do array
	While QRY->( !EOF() )
		If QRY->PROD == aProd[i][1]
			//	varrer todo o array de datas verificando se a data se encaixa
			For j:=1 to Len(aData)
				If	( aData[j] >= CTOD(Right(QRY->Z1_DTCARGM,2) + "/" + Substr(QRY->Z1_DTCARGM,5,2) + "/" + Left(QRY->Z1_DTCARGM,4)) .And. ;
					  aData[j] <= CTOD(Right(QRY->Z1_DTVGM4,2) + "/" + Substr(QRY->Z1_DTVGM4,5,2) + "/" + Left(QRY->Z1_DTVGM4,4) ) ) //.Or.;
//					( CTOD(Right(QRY->Z1_DTEVINI,2) + "/" + Substr(QRY->Z1_DTEVINI,5,2) + "/" + Left(QRY->Z1_DTEVINI,4))  <= aData[j] .And. ;
//					  CTOD(Right(QRY->Z1_DTEVFIM,2) + "/" + Substr(QRY->Z1_DTEVFIM,5,2) + "/" + Left(QRY->Z1_DTEVFIM,4))  >= aData[j] )
				    aProd[i][j+2] -= QRY->QUANT //Previa
					If QRY->Z1_STATUS == 'E' .Or. QRY->Z1_STATUS == 'F'
						aProd2[i][j+2] += QRY->QUANT //Fechado
					EndIf
				EndIf
			Next
		EndIf		

    	QRY->(dbSkip())
    End
    QRY->(dbGoTop())
Next

cGrupo := ""
For i:=1 to Len(aProd)
	If cGrupo <> aProd[i][2]
		//controle de Grupos - Imprime cabecalho
		cGrupo := aProd[i][2]
		nLin := Cabecalho(nPagina,cGrupo,aData)	
	EndIf
//    @ nLin,00  PSAY PADC(aProd[i][1],16)
	If FieldPos("B1_APELIDO") > 0 .And. Alltrim(Posicione("SB1",1,xFilial("SB1")+aProd[i][1],"B1_APELIDO")) <> ""
			@ nLin,00  PSAY Alltrim(Posicione("SB1",1,xFilial("SB1")+aProd[i][1],"B1_APELIDO"))
	Else
	    @ nLin,00  PSAY Right(Alltrim(Posicione("SB1",1,xFilial("SB1")+aProd[i][1],"B1_DESC")),16)
	EndIf
    @ nLin,17  PSAY StrZero(aProd2[i][3] ,3) + "|" + StrZero(aProd[i][3] ,3)
    @ nLin,27  PSAY StrZero(aProd2[i][4] ,3) + "|" + StrZero(aProd[i][4] ,3)
    @ nLin,37  PSAY StrZero(aProd2[i][5] ,3) + "|" + StrZero(aProd[i][5] ,3)
    @ nLin,47  PSAY StrZero(aProd2[i][6] ,3) + "|" + StrZero(aProd[i][6] ,3)
    @ nLin,57  PSAY StrZero(aProd2[i][7] ,3) + "|" + StrZero(aProd[i][7] ,3)
    @ nLin,67  PSAY StrZero(aProd2[i][8] ,3) + "|" + StrZero(aProd[i][8] ,3)
    @ nLin,77  PSAY StrZero(aProd2[i][9] ,3) + "|" + StrZero(aProd[i][9] ,3)
   	@ nLin,87  PSAY StrZero(aProd2[i][10],3) + "|" + StrZero(aProd[i][10],3)
   	@ nLin,97  PSAY StrZero(aProd2[i][11],3) + "|" + StrZero(aProd[i][11],3)
   	@ nLin,107 PSAY StrZero(aProd2[i][12],3) + "|" + StrZero(aProd[i][12],3)
   	@ nLin,117 PSAY StrZero(aProd2[i][13],3) + "|" + StrZero(aProd[i][13],3)
   	@ nLin,127 PSAY StrZero(aProd2[i][14],3) + "|" + StrZero(aProd[i][14],3)
   	@ nLin,137 PSAY StrZero(aProd2[i][15],3) + "|" + StrZero(aProd[i][15],3)
   	@ nLin,147 PSAY StrZero(aProd2[i][16],3) + "|" + StrZero(aProd[i][16],3)
   	@ nLin,157 PSAY StrZero(aProd2[i][17],3) + "|" + StrZero(aProd[i][17],3)
    nLin++

	If nLin > 60 //70
		nPagina++
		nLin := Cabecalho(nPagina,cGrupo,aData)	//Cabecalho(nPagina,"0000",{})
	EndIf
	
Next
	    
dbSelectArea("QRY")
QRY->( dbCloseArea() )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡…o    ³CABECALHO º Autor ³ Microsiga          º Data ³ 15.07.10    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ IMPRIME CABECALHO                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Cabecalho(nPagina,cGrupo,aData)
Local cFolha := StrZero(nPagina,4)
Local nLinha := 0
`
Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,,,.F.)

nLinha	:= PRow()//+1
@ nLinha++,0 PSAY Space(40) + OemToAnsi("F - Quantidade Utilizada / P - Disponível para Prévia")
//Tamanho maximo: 131
If cGrupo == "0000"
	@ nLinha++,0 PSAY "GRUPO DE PRODUTOS: "
	Else
	@ nLinha++,0 PSAY "GRUPO DE PRODUTOS: " + Posicione( "SBM", 1, xFilial("SBM")+cGrupo, "BM_DESC")
EndIf
nLinha++

//If Len(aData) == 7
//	@ nLinha++,0 PSAY "PRODUTO          " + DTOC(aData[1]) + "  " + DTOC(aData[2]) + "  " + DTOC(aData[3]) + "  " + DTOC(aData[4]) + "  " + DTOC(aData[5]) + "  " + DTOC(aData[6]) + "  " + DTOC(aData[7])
//Else //15
	@ nLinha++,0 PSAY "PRODUTO          " + DTOC(aData[1]) + "  " + DTOC(aData[2]) + "  " + DTOC(aData[3]) + "  " + DTOC(aData[4]) + "  " + DTOC(aData[5]) + "  " + DTOC(aData[6]) + "  " + DTOC(aData[7]) + "  " + DTOC(aData[8]) + "  " + DTOC(aData[9]) + "  " + DTOC(aData[10]) + "  " + DTOC(aData[11]) + "  " + DTOC(aData[12]) + "  " + DTOC(aData[13]) + "  " + DTOC(aData[14]) + "  " + DTOC(aData[15])
	@ nLinha++,0 PSAY "                  F | P     F | P     F | P     F | P     F | P     F | P     F | P     F | P     F | P     F | P     F | P     F | P     F | P     F | P     F | P"
//EndIf
@ nLinha++,0 PSAY __PrtThinLine()

//"012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901"
//"0         1         2         3         4         5         6         7         8         9         0         1         2         3 "

//NNNNNNNNNNNNNNNNNNNNNNNNNN 12/34/56 12/34/56 12/34/56 12/34/56 12/34/56 12/34/56 12/34/56

Return nLinha
