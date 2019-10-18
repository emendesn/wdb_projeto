
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ M410LIOK บ Autor ณ Edilson Mendes     บ Data ณ  11/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de entrada na valida็ใo do LinhaOK da getdados no    บฑฑ
ฑฑบ          ณ pedido de venda.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cliente WDB                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
USER FUNCTION M410LIOK()

LOCAL nPos
LOCAL clProd := ""
LOCAL llRet  := .T.
LOCAL alCpy  := aClone(aCols)

	alCpy := aSort(alCpy,,,{|x,y| x[GDFIELDPOS("C6_PRODUTO")] < y[GDFIELDPOS("C6_PRODUTO")]} )
	
	IF( LEN( alCpy ) -1 ) > 0
		
		FOR nPos := 1 TO LEN(alCpy)
			IF .NOT. alCpy[nPos][Len(aHeader)+1])
				IF clProd <> Alltrim(alCpy[nPos][GDFIELDPOS("C6_PRODUTO")])
					clProd := Alltrim(alCpy[nPos][GDFIELDPOS("C6_PRODUTO")])
				ELSE
					Aviso("Aten็ใo","O produto "+Alltrim(alCpy[n][GDFIELDPOS("C6_PRODUTO")])+" jแ foi informado.",{"OK"})
					oGetDad:OBROWSE:NCOLPOS := GDFIELDPOS("C6_PRODUTO")
					llRet	:= .F.
					EXIT
				ENDIF
			ENDIF
		NEXT
		
	ENDIF
	    
RETURN( llRet )
