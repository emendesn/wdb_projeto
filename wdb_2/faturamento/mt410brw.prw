# INCLUDE "Protheus.ch"
# INCLUDE "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT410TOK � Autor � Edilson Mendes     � Data �  11/10/10   ���
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
USER FUNCTION MT410BRW

	AADD( aRotina ,{ "Observacao", "U_OBS_PED()" ,0,3,0} )

RETURN


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT410TOK � Autor � Edilson Mendes     � Data �  11/10/10   ���
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
USER FUNCTION OBS_PED()

LOCAL cMsg
LOCAL nTam
LOCAL nOk

	IF EMPTY( SC5->C5_LIBEROK ) .AND. EMPTY( SC5->C5_NOTA ) .AND. EMPTY( SC5->C5_BLQ )
		
		IF Empty(SC5->C5_COD_OBS)
			cMsg := Space( 01 )
		Else
			cMsg := MSMM(SC5->C5_COD_OBS)
		EndIF
		
		DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
		DEFINE MSDIALOG oDlg TITLE OemToAnsi("Observa��o") From 196,042 TO 540,680 OF oMainWnd PIXEL		//"Mensagem Para o Funcion�rio"
		
		@ 027 , 005 GET oMemo VAR cMsg MEMO SIZE 310 , 135  FONT oFont OF oDlg PIXEL
		
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOk := 1,oDlg:End()},{||oDlg:End()}) CENTERED
		
		IF nOk == 1
			
			cMsg := NOACENTO( AnsiToOem( cMsg ) )
			nTam := TamSX3("YP_TEXTO")[1]
			MSMM( SC5->C5_COD_OBS, nTam,, cMsg, 1,,, "SC5", "C5_COD_OBS")
			
		ENDIF
		
	ENDIF
		
RETURN
