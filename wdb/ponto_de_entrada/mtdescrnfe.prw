#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTDescrNFE  ºAutor  ³Alessandro Souza º Data ³ 06/05/08    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada - Descriminação dos Serviços - NF-e    	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Livros Fiscais                 							  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTDescrNFE()
//Variavel a ser retornada
Local cDescr := ""
//Verificar Itens da Nota Fiscal
SD2->(DbSetOrder(3))
SD2->(DbSeek(xFilial()+SF3->F3_NFISCAL+SF3->F3_SERIE+SF3->F3_CLIEFOR+SF3->F3_LOJA))
//Descrição do Produto
SB1->(DbSeek(xFilial()+SD2->D2_COD))
cDescr := Alltrim(SB1->B1_DESC)
  
SE1->(DbSetOrder(1))

SE1->(DbSeek(xFilial("SE1")+SF3->F3_SERIE+SF3->F3_NFISCAL,.T.))

_aVencto := {}

Do While !SE1->(Eof()) .And. SE1->E1_FILIAL == xFilial("SE1") .And. SE1->E1_PREFIXO == SF3->F3_SERIE .And. SE1->E1_NUM == SF3->F3_NFISCAL
	IF SE1->E1_CLIENTE <> SF3->F3_CLIEFOR
		SE1->(DBSKIP())
		LOOP
	Endif
	aAdd(_aVencto,SE1->E1_VENCREA)
	SE1->(DbSkip())
EndDo

//Contrato
//cDescr += "|Contrato   :" +Alltrim(SC6->C6_CONTRA)

//Mensagem

cDescr += "|" +Alltrim(SC5->C5_MENNOTA)
cDescr += "|" 
cDescr += "|" 
cDescr += "|(-) INSS - R$" +Alltrim(SE1->E1_INSS)
cDescr += "|(-) I.R -" +Alltrim(SC5->C5_MENNOTA)+"%"+"R$" +Alltrim(SE1->E1_IRRF)
cDescr += "|(-) CSLL -" +Alltrim(SC5->C5_MENNOTA)+"%"+"R$" +Alltrim(SE1->E1_CSLL)
cDescr += "|(-) PIS -" +Alltrim(SC5->C5_MENNOTA)+"%"+"R$" +Alltrim(SE1->E1_PIS)
cDescr += "|(-) COFINS -" +Alltrim(SC5->C5_MENNOTA)+"%"+"R$" +Alltrim(SE1->E1_COFINS)

//Vencimento

_cVenc := ""
For _nY := 1 to Len(_aVencto)
	If !Empty(_cVenc)
		_cVenc+="  -  "
	EndIf
	_cVenc += Dtoc(_aVencto[_nY])
Next _nY
cDescr += "|" 
cDescr += "|" 
cDescr += "|Valor Liquido a pagar :" +Alltrim(SE1->E1_VALOR)
cDescr += "|Vencimentos :" +_cVenc

//DADOS BANCAROIS
cDescr += "|" 
cDescr += "|" 
cDescr += "|Dados Bancarios:"
cDescr += "|Banco 033 (Santander)"
cDescr += "|Ag. 0134 (Faria Lima)"
cDescr += "|C/C: 13.003588-2"

//PEDIDO/JOB
cDescr += "|" 
cDescr += "|PEDIDO N.:" +Alltrim(SE1->E1_PEDIDO)


Return(cDescr)