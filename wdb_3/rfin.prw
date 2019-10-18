#Include "Matr150.ch"
#Include "RWMAKE.Ch"                                                        
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFINR14  ºAutor  ³Luiz Alberto V Alvesº Data ³  12/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de Duplicatas Contas a Receber em Modo Grafico  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Inforshop Suprimentos Ltda                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFINR14()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cString :="SE1"
Private cPerg   :="RFIR14"
Private oFont, cCode, oPrn
Private cCGCPict, cCepPict
Private lPrimPag :=.t.
Private cNumero  := ""
Private cFornece := ""
Private cLoja    := ""
Private lEnc     := .f.
Private nPag     := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01	     	  Do Titulo                              ³
//³ mv_par02	     	  Da Serie  		                     ³
//³ mv_par03	     	  Ate Titulo	                         ³
//³ mv_par04              Ate Serie		            	     	 ³
//³ mv_par05              Acumula Titulos Sim ou Nao  	     	 ³
//³ mv_par06              No DE Ordem Só Em Caso de Acumulo   	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ValidPerg()

If !Pergunte(cPerg,.T.)
	Return
EndIF

RptStatus({|| R150Imp(cString)})

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R150IMP  ³ Autor ³ Luiz Alberto V Alves  ³ Data ³ 12/11/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RFINR14                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R150Imp(cString)

Private cDescri  := ""
Private cabec1   := ""
Private cabec2   := ""
Private cabec3   := ""
Private cContato := ""
Private cVar     := ""
Private cbCont   := 0
Private nItem    := 0
Private dEmissao, cCotaAnt := ""
Private cMsg,nLin, nOrdem, nLinha, nLinhaD, nLinhaO, cObs
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definir as pictures                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCepPict:=PesqPict("SA1","A1_CEP")
cCGCPict:=PesqPict("SA1","A1_CGC")

oFont1 := TFont():New( "Arial",,16,,.t.,,,,,.f. )
oFont2 := TFont():New( "Arial",,16,,.f.,,,,,.f. )
oFont3 := TFont():New( "Arial",,10,,.t.,,,,,.f. )
oFont4 := TFont():New( "Arial",,10,,.f.,,,,,.f. )
oFont5 := TFont():New( "Arial",,06,,.t.,,,,,.f. )
oFont6 := TFont():New( "Arial",,08,,.f.,,,,,.f. )
oFont7 := TFont():New( "Arial",,14,,.t.,,,,,.f. )
oFont8 := TFont():New( "Arial",,14,,.f.,,,,,.f. )
oFont9 := TFont():New( "Arial",,12,,.t.,,,,,.f. )
oFont10:= TFont():New( "Arial",,12,,.f.,,,,,.f. )

oFont1c := TFont():New( "Courier New",,16,,.t.,,,,,.f. )
oFont2c := TFont():New( "Courier New",,16,,.f.,,,,,.f. )
oFont3c := TFont():New( "Courier New",,10,,.t.,,,,,.f. )
oFont4c := TFont():New( "Courier New",,10,,.f.,,,,,.f. )
oFont5c := TFont():New( "Courier New",,09,,.t.,,,,,.f. )
oFont6c := TFont():New( "Courier New",,09,,.T.,,,,,.f. )
oFont7c := TFont():New( "Courier New",,14,,.t.,,,,,.f. )
oFont8c := TFont():New( "Courier New",,14,,.f.,,,,,.f. )
oFont9c := TFont():New( "Courier New",,12,,.t.,,,,,.f. )
oFont10c:= TFont():New( "Courier New",,12,,.f.,,,,,.f. )

li       := 1600
m_pag    := 1
nPag     := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa Numero da Cotacao                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE1")
dbSetOrder(1)
dbSeek(xFilial("SE1")+'1  '+mv_par01)

SetRegua(RecCount())
nCont := 1
nTotal := nDesconto := 0.00              
dEmissao:= SE1->E1_EMISSAO
dVencime:= SE1->E1_VENCTO
cA1_NOME:= SA1->A1_NOME
cA1_COD := SA1->A1_COD
cA1_END := SA1->A1_END
cA1_MUN := SA1->A1_MUN
cA1_EST := SA1->A1_EST
cA1_CEP := SA1->A1_CEP
cA1_ENDC:= SA1->A1_ENDCOB
cA1_CGC := SA1->A1_CGC
cA1_INSC:= SA1->A1_INSCRE

While xFilial("SE1") = E1_FILIAL .And. E1_NUM >= MV_PAR01 .And. E1_NUM <= MV_PAR03 .And. SE1->(!Eof())
	
	IncRegua()
	
	_cNome := Posicione('SA1',1,xFilial('SA1')+SE1->E1_CLIENTE,'A1_NOME')
		
	If nCont > 1
		li := 1500
		nCont := 0
	Else
		li := 0
	Endif
	
    If MV_PAR05 <> 1
		ImpDupl(li, SE1->E1_NUM, SE1->E1_VALOR, SE1->E1_PARCELA, SE1->E1_EMISSAO, ;
		SE1->E1_VENCTO, SE1->E1_DESCONT, SA1->A1_NOME, SA1->A1_COD, SA1->A1_END, ;
		SA1->A1_MUN, SA1->A1_EST, SA1->A1_CEP, SA1->A1_ENDCOB, SA1->A1_CGC, SA1->A1_INSCRE, MV_PAR06)
	Else      
		nTotal += SE1->E1_VALOR
		nDesconto += SE1->E1_DESCONT
	Endif
	
	nCont++
	
	dbSelectArea("SE1")
    dbSkip(1)

EndDo
If MV_PAR05 == 1
	li:=0
	ImpDupl(li, 'DIVERSOS', nTotal, 'A', dEmissao, dVencime, nDesconto, cA1_NOME, cA1_COD, cA1_END, cA1_MUN, cA1_EST, cA1_CEP, cA1_ENDC, cA1_CGC, cA1_INSC, MV_PAR06)
Endif

dbSelectArea("SE1")
Set Filter To
dbSetOrder(1)

dbSelectArea("SA5")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lEnc
	oPrn:Preview()
	MS_FLUSH()
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpDupl  ³ Autor ³ Luiz Alberto V Alves ³ Data ³ 23/11/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime as Duplicatas					                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ R150Imp                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpDupl(li, cFatura, nValor, cOrdem, dEmissao, dVencimento, nDesconto, cNome, cCod, cEnd, cMun, cEst, cCep, cEndC, cCgc, cInsc)

cMoeda := "1"
nPag++

If lPrimPag
	lPrimPag := .f.
	lEnc     := .t.
	oPrn  := TMSPrinter():New()
	oPrn:Setup()
EndIF



oPrn:Say( li, 0020, " ",oFont,100 ) // startando a impressora

//Cabecalho (Enderecos da Empresa e Fornecedor) 
oPrn:Box( 0050 + li, 0050, 1500 + li,2400) // Box Total
oPrn:Box( 0050 + li, 0050, 0409 + li,2400) // Box Divisao Cabecalho
oPrn:Box( 0050 + li, 0050, 0409 + li,1175) // Box do Logo Tipo
oPrn:Box( 0409 + li, 0050, 1500 + li,0400) // Box Assinatura do Emitente

oPrn:Box( 0409 + li, 0400, 0585 + li,1813) // Box Dados Duplicata 1

oPrn:Box( 0409 + li, 0400, 0585 + li,0643) // Box Dados FATURA
oPrn:Box( 0409 + li, 0400, 0491 + li,0643) // Box Dados FATURA 2
oPrn:Say( 0412 + li, 0460, "FATURA Nº",oFont6,100 )

oPrn:Box( 0409 + li, 0643, 0585 + li,1175) // Box Dados VALOR FATURA
oPrn:Box( 0409 + li, 0643, 0491 + li,1175) // Box Dados VALOR FATURA 2

oPrn:Say( 0412 + li, 0762, "FATURA / DUPLICATA",oFont6,100 )
oPrn:Say( 0456 + li, 0819, "VALOR R$",oFont6,100 )

oPrn:Box( 0409 + li, 1175, 0585 + li,1404) // Box Dados DUPLICATA
oPrn:Box( 0409 + li, 1175, 0491 + li,1404) // Box Dados DUPLICATA  2

oPrn:Say( 0412 + li, 1213, "DUPLICATA",oFont6,100 )
oPrn:Say( 0456 + li, 1201, "Nº DE ORDEM",oFont6,100 )

oPrn:Box( 0409 + li, 1404, 0585 + li,1813) // Box Dados VENCIMENTO
oPrn:Box( 0409 + li, 1404, 0491 + li,1813) // Box Dados VENCIMENTO 2

oPrn:Say( 0412 + li, 1492, "VENCIMENTO",oFont6,100 )
oPrn:Say( 0412 + li, 1823, "PARA USO DA INST.FINANCEIRA",oFont5,100 )

oPrn:Box( 0585 + li, 0400, 0807 + li,1813) // Box Dados Duplicata

oPrn:Box( 0807 + li, 0400, 1050 + li,2400) // Box Dados Cliente

oPrn:Box( 1050 + li, 0400, 1250 + li,2400) // Box Valor Extenso

oPrn:Say( 0596 + li, 0424, "DESCONTO DE",oFont6,100 )
oPrn:Say( 0819 + li, 0424, "SACADO:",oFont6,100 )
oPrn:Say( 0819 + li, 2106, "CÓD:",oFont6,100 )
oPrn:Say( 0865 + li, 0424, "ENDEREÇO:",oFont6,100 )
oPrn:Say( 0911 + li, 0424, "MUNICÍPIO:",oFont6,100 )
oPrn:Say( 0911 + li, 1755, "ESTADO:",oFont6,100 )
oPrn:Say( 0911 + li, 2106, "CEP:",oFont6,100 )      
oPrn:Say( 0957 + li, 0424, "PÇA. PAGATO:",oFont6,100 )
oPrn:Say( 1003 + li, 0424, "INSCR.C.G.C.(MF) Nº:",oFont6,100 )
oPrn:Say( 1003 + li, 1755, "INSC.ESTADUAL:",oFont6,100 )

oPrn:Say( 1070 + li, 0424, "VALOR",oFont6,100 )
oPrn:Say( 1140 + li, 0424, "POR",oFont6,100 )
oPrn:Say( 1210 + li, 0424, "EXTENSO",oFont6,100 )

oPrn:Say( 1270 + li, 0424, "RECONHEÇO(EMOS) A EXATIDÃO DESTA DUPLICATA DE VENDA MERCANTIL NA IMPORTÂNCIA ACIMA QUE",oFont6,100 )
oPrn:Say( 1310 + li, 0424, "PAGAREI(EMOS) À INFORSHOP SUPRIMENTOS LTDA., OU A SUA ORDEM NA PRAÇA E VENCIMENTO INDICADOS.",oFont6,100 )

oPrn:Say( 1430 + li, 0424, "______/_____/_______",oFont6,100 )
oPrn:Say( 1460 + li, 0424, "   DATA DO ACEITE   ",oFont6,100 )

oPrn:Say( 1430 + li, 1755, "_____________________________",oFont6,100 )
oPrn:Say( 1460 + li, 1755, "     ASSINATURA DO SACADO",oFont6,100 )

//			li   	  col   li  	  col

oPrn:SayBitmap( 0070 + li,0200,"logo_inf.bmp",0800,0300)
//											  col   lin
oPrn:SayBitmap( 0526 + li,0070,"assinfor.bmp",0300,0800)

oPrn:Say( 0070 + li, 1213, SM0->M0_NOMECOM,oFont1,100 )   
oPrn:Say( 0150 + li, 1213, UPPER(SM0->M0_ENDCOB) ,oFont6,100 )              
oPrn:Say( 0190 + li, 1213, "FONE: PABX: " + SM0->M0_TEL ,oFont6,100 )
oPrn:Say( 0190 + li, 1823, "FAX: " + SM0->M0_FAX ,oFont6,100 )
                                                                              
oPrn:Say( 0230 + li, 1213, "INSCRIÇÃO NO C.G.C.(M.F.): "+ Transform(SM0->M0_CGC,cCgcPict) ,oFont6,100 )
oPrn:Say( 0270 + li, 1213, "INSCRIÇÃO ESTADUAL Nº: " + InscrEst() ,oFont6,100 )

oPrn:Say( 0370 + li, 1213, "DATA DA EMISSÃO: " + DtoC(dEmissao) ,oFont6,100 )

If !Empty(MV_PAR06)
	oPrn:Say( 0526 + li, 0468, 'ANEXO' , oFont3c,100 )
	oPrn:Say( 0526 + li, 1205, (MV_PAR06 + If(!Empty(cOrdem),'/',' ') + cOrdem), oFont3c, 100 )
Else	
	oPrn:Say( 0526 + li, 0468, cFatura, oFont3c,100 )
	oPrn:Say( 0526 + li, 1205, (cFatura + If(!Empty(cOrdem),'/',' ') + cOrdem), oFont3c, 100 )
End	
oPrn:Say( 0526 + li, 0819, TransForm(nValor, "@EZ 999,999,999.99"), oFont3c,100 )
oPrn:Say( 0526 + li, 1521, DtoC(dVencimento), oFont3c, 100 )
oPrn:Say( 0596 + li, 0702, TransForm(nDesconto, "@EZ 999,999,999.99"), oFont3c, 100 )

oPrn:Say( 0819 + li, 0737, cNome, oFont3c, 100 )
oPrn:Say( 0819 + li, 2187, cCod, oFont3c, 100 )
oPrn:Say( 0865 + li, 0737, cEnd, oFont3c, 100 )
oPrn:Say( 0911 + li, 0737, cMun, oFont3c, 100 )
oPrn:Say( 0911 + li, 1907, cEst, oFont3c, 100 )
oPrn:Say( 0911 + li, 2187, Left(cCep,5)+"-"+Right(cCep,3), oFont3c, 100 )
oPrn:Say( 0957 + li, 0737, cEndC, oFont3c, 100 )
oPrn:Say( 1003 + li, 0737, Transform(cCgc,cCgcPict), oFont3c, 100 )
oPrn:Say( 1003 + li, 2012, cInsc, oFont3c, 100 )

cTexto := "(" + Extenso(nValor) + Replicate("*",200) + ")"
_cTexto1 := SubStr(cTexto,1,070)
_cTexto2 := SubStr(cTexto,071,070)
_cTexto3 := SubStr(cTexto,141,070)


oPrn:Say( 1070 + li, 0585, _cTexto1, oFont3c, 100 )
oPrn:Say( 1140 + li, 0585, _cTexto2, oFont3c, 100 )
oPrn:Say( 1210 + li, 0585, _cTexto3, oFont3c, 100 )


If li > 0
	oPrn:EndPage()
	oPrn:StartPage()
Endif	

//oPrn:Box( 0050, 0410, 0175,2550)
//oPrn:Box( 0050, 2550, 0175,3000)
//oPrn:Box( 0050, 3000, 0175,3345)

//oPrn:Box( 0175, 0410, 0420,1380)
//oPrn:Box( 0175, 1380, 0420,2550)
//oPrn:Box( 0175, 2550, 0420,3345)

//Cabecalho Produto da Cotação
//oPrn:Box( 0420, 0010, 0480,0140)
//oPrn:Box( 0420, 0140, 0480,0410)
//oPrn:Box( 0420, 0410, 0480,2019)
//oPrn:Box( 0420, 2019, 0480,2105)
//oPrn:Box( 0420, 2105, 0480,2280)
//oPrn:Box( 0420, 2280, 0480,2550)
//oPrn:Box( 0420, 2550, 0480,2715)
//oPrn:Box( 0420, 2715, 0480,2850)
//oPrn:Box( 0420, 2850, 0480,3130)
//oPrn:Box( 0420, 3130, 0480,3345)

//Espaco dos Itens da Cotação
//oPrn:Box( 0480, 0010, 1730,0145)
//oPrn:Box( 0480, 0140, 1730,0410)
//oPrn:Box( 0480, 0410, 1730,2019)
//oPrn:Box( 0480, 2019, 1730,2105)
//oPrn:Box( 0480, 2105, 1730,2280)
//oPrn:Box( 0480, 2280, 1730,2550)
//oPrn:Box( 0480, 2550, 1730,2715)
//oPrn:Box( 0480, 2715, 1730,2850)
//oPrn:Box( 0480, 2850, 1730,3130)
//oPrn:Box( 0480, 3130, 1730,3345)

//oPrn:SayBitmap( 0100,0040,"KBMP.bmp",0360,0200 )

//oPrn:Say( 0080, 0620, "PCM/S - SOLICITAÇÃO DE COTAÇÃO DE MATERIAL E/OU SERVIÇO",oFont1,100 )
//oPrn:Say( 0085, 2600, "PCM/S Nº",oFont3,100 )

//oPrn:Say( 0080, 3015, "FOLHA:" ,oFont3,100 )
//oPrn:Say( 0080, 3182, Alltrim(StrZero(nPag,2))+" / "+Alltrim(StrZero(nPagD,2)) ,oFont3,100 )
//oPrn:Say( 0080, 3182, Alltrim(StrZero(nPag,2)) ,oFont3,100 )

//Itens das Empresas
//oPrn:Say( 0185, 0430, "EMPRESA",oFont3,100 )
//oPrn:Say( 0185, 1400, "FORNECEDOR",oFont3,100 )
//oPrn:Say( 0185, 2570, "DATA EMISSÃO:" ,oFont3,100 )
//oPrn:Say( 0185, 2940, DTOC(SC8->C8_EMISSAO) ,oFont4,100 )

//oPrn:Say( 0230, 0430, SM0->M0_NOMECOM ,oFont6,100 )
//oPrn:Say( 0230, 1400, Alltrim(Substr(SA2->A2_NOME,1,28))+" - ("+SA2->A2_COD+")" ,oFont6,100 )

//oPrn:Say( 0265, 0430, UPPER(SM0->M0_ENDENT) ,oFont6,100 )
//oPrn:Say( 0265, 1400, UPPER(Substr(SA2->A2_END,1,30)+ Substr(SA2->A2_BAIRRO,1,10)) ,oFont6,100 )
//oPrn:Say( 0275, 2570, UPPER("Cod. Ativo: ") ,oFont5,100 )

//oPrn:Say( 0300, 0430, UPPER("CEP: "+Trans(SM0->M0_CEPENT,cCepPict)),oFont6,100 )
//oPrn:Say( 0300, 1060, UPPER(Trim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT) ,oFont6,100 )
//oPrn:Say( 0300, 1400, Upper(Trim(SA2->A2_MUN)+"   "+SA2->A2_EST+" "+"CEP: "+SA2->A2_CEP) ,oFont6,100 )
//oPrn:Say( 0300, 2170, "FAX: " + "("+Substr(SA2->A2_DDD,1,3)+") "+SA2->A2_FAX ,oFont6,100 )
//oPrn:Say( 0320, 2570, "SOLICITANTE : ",oFont5,100 )
//oPrn:Say( 0320, 2820, "Zenaide",oFont6,100 )

//oPrn:Say( 0335, 0430, "TEL: " + SM0->M0_TEL ,oFont6,100 )
//oPrn:Say( 0335, 1060, "FAX: " + SM0->M0_FAX ,oFont6,100 )
//oPrn:Say( 0335, 1400, "VENDEDOR: " + Upper(Substr(SC8->C8_CONTATO,1,10)),oFont6,100 )
//oPrn:Say( 0335, 2170, "FONE: " + "("+Substr(SA2->A2_DDD,1,3)+") "+Substr(SA2->A2_TEL,1,15) ,oFont6,100 )

dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("A2_CGC")
cCGC := Alltrim(X3TITULO())
nOrden = IndexOrd()

//oPrn:Say( 0370, 0430, (cCGC) + " "+ Transform(SM0->M0_CGC,cCgcPict) ,oFont6,100 )
//oPrn:Say( 0370, 1060, "IE:" + InscrEst() ,oFont6,100 )

dbSelectArea("SA2")
dbSetOrder(nOrden)
//oPrn:Say( 0370, 1400, "CNPJ: " + Alltrim(SA2->A2_CGC) ,oFont6,100 )
//oPrn:Say( 0370, 2170, "IE: " + SA2->A2_INSCR ,oFont6,100 )
//oPrn:Say( 0370, 2570, "EMAIL : " ,oFont5,100 )
//oPrn:Say( 0370, 2770, Alltrim(MV_PAR13) ,oFont6,100 )

//oPrn:Say( 0435, 0035, "Item"  ,oFont3,100 )
//oPrn:Say( 0435, 0165, "Código" ,oFont3,100 )
//oPrn:Say( 0435, 0430, "Descrição do Material e/ou Serviço" ,oFont3,100 ) 
//oPrn:Say( 0435, 1400, "Observações" ,oFont3,100 )
//oPrn:Say( 0435, 2034, "UM" ,oFont3,100 )
//oPrn:Say( 0435, 2148, "Qtde"  ,oFont3,100 )
//oPrn:Say( 0435, 2300, "Valor Unitário" ,oFont3,100 )
//oPrn:Say( 0435, 2575, "%Desc" ,oFont3,100 )
//oPrn:Say( 0435, 2750, "IPI%" ,oFont3,100 )
//oPrn:Say( 0435, 2895, "Valor Total" ,oFont3,100 )
//oPrn:Say( 0435, 3140, "Data Entrega" ,oFont3,100 )
                     
//cSubject := "Cotação de Preços nr."+SC8->C8_NUM+" / "+AllTrim(Left(SA2->A2_NOME,30))
//cEmailEnd:= SA2->A2_EMAIL
//aAdd(aEmail,{nPag,cEmailEnd,cSubject})

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpRodape³ Autor ³ Daniel G.Jr.TI1239    ³ Data ³ 22/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o rodape do formulario e salta para a proxima folha³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpRodape(Void)   			         					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 					                     				      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RCOMR02                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpRodape()

oPrn:Say( 1730, 0070, "CONTINUA ..." ,oFont3,100 )

Return .T.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³VALIDPERG ³ Autor³Adalberto Moreno Batista³ Data ³11.02.2000³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg()

Local _aAlias := Alias(), aRegs
cPerg := padr(cperg,10)

dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Do Titulo ?","","","mv_ch1","C",6,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Da Serie ?","","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Ate Titulo ?","","","mv_ch3","C",6,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Da Serie ?","","","mv_ch4","C",3,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Acumula ?","","","mv_ch5","N",1 ,0,0,"C","","MV_PAR05","Sim"      ,"","","","","Nao"          ,"","","","","","","","","","","","","","","","","","","","","",""   })
aAdd(aRegs,{cPerg,"06","No. Ordem?","","","mv_ch6","C",6,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_aAlias)

Return
