# INCLUDE "Protheus.ch"
# INCLUDE "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT410TOK � Autor � Edilson Mendes     � Data �  11/10/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada, ao clicar no bot�o OK no pedido de venda ���
�������������������������������������������������������������������������͹��
���Parametro �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Cliente WDB                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER FUNCTION MT410TOK

LOCAL k := 0

LOCAL nlQtdB2	:= 0
LOCAL nlDisp	:= 0
LOCAL clQryPAZ	:= ""
	
	nItem	:= Ascan( aHeader,{ |m| Alltrim(m[2]) == "C6_ITEM"    })
	nProd   := Ascan( aHeader,{ |m| Alltrim(m[2]) == "C6_PRODUTO" })	
	nQuant	:= Ascan( aHeader,{ |m| Alltrim(m[2]) == "C6_QTDVEN"  })
	nSub	:= Ascan( aHeader,{ |m| Alltrim(m[2]) == "C6_QTDSUB"  })
	nLoc	:= Ascan( aHeader,{ |m| Alltrim(m[2]) == "C6_LOCAL"   })

	For nC := 1 To Len(aCols)
		If !aCols[nC,Len(aHeader)+1]
			dbSelectArea("PAZ")
			dbGoTop()
			dbSetOrder(2)
			If dbSeek(xFilial("PAZ")+(PadR(M->C5_NUM,TamSx3("PAZ_PEDIDO")[1]))+(PadR(aCols[nC][nItem],TamSx3("PAZ_ITEM")[1])))
				If RecLock("PAZ",.F.)
					Replace PAZ->PAZ_QUANT With 0
					MsUnLock()
				EndIf
			EndIf
		EndIf
	Next nC

	For k := 1 to Len(aCols)

		If !aCols[k][Len(aHeader)+1]

			dbSelectArea("SB2")
			dbGotop()
			dbSetorder(1)
			If dbSeek(xFilial("SB2")+aCols[k][nProd]+aCols[k][nLoc])
				nlQtdB2:= SB2->B2_QATU
			EndIf

			If nlQtdB2 > 0
				nlTotd := U_FFilDisp(aCols[k][nProd],M->C5_DATAINI,M->C5_DATAFIM)
				TMPP->(dbCloseArea())

				nlDisp	:= nlQtdB2 - nlTotd

				If nlDisp > 0
					If aCols[k][nQuant] > nlDisp
						nlSubLoc := aCols[k][nQuant] - nlDisp

						aCols[k][nSub]		:= nlSubLoc
						Aviso("Aten��o","Produto de C�digo: "+Alltrim(aCols[k][nProd])+", foi sublocado em quantidade igual a "+Alltrim(Str(nlSubLoc))+".",{"Ok"})

					Else
						aCols[k][nSub]		:= 0
					EndIf
				Else

					aCols[k][nSub]:= aCols[k][nQuant]
					Aviso("Aten��o","Produto de C�digo: "+Alltrim(aCols[k][nProd])+", foi sublocado em quantidade igual a "+Alltrim(Str(aCols[k][nQuant]))+".",{"Ok"})

                EndIf

			Else
				If !Empty(aCols[k][nProd]) .AND.!aCols[k][Len(aHeader)+1]

					aCols[k][nSub]:= aCols[k][nQuant]
					Aviso("Aten��o","Produto de C�digo: "+Alltrim(aCols[k][nProd])+", foi sublocado em quantidade igual a "+Alltrim(Str(aCols[k][nQuant]))+".",{"Ok"})

                EndIf

			EndIf
		EndIf
	Next k

Return .T.