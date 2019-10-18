#INCLUDE "RwMake.ch"    
#INCLUDE "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³ ValidEmail    ºAutor ³Edilson Mendes   º Data ³ 23/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida o Campo A1_EMAIL da tabela SA1.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION ValidEmail( cEmail )

LOCAL nResto
LOCAL cMens
LOCAL lRetValue := .T.

	IF INCLUI .OR. ALTERA .AND. .NOT. EMPTY( cEmail )
		
		IF UPPER( FUNNAME() ) == "MATA030" .OR. UPPER( FUNNAME() ) == "MATA103"
			cEmail := M->A1_EMAIL
		ELSEIF UPPER( FUNNAME() ) == "MATA020"
			cEmail := M->A2_EMAIL
		ELSEIF UPPER( FUNNAME() ) == "MATA040"
			cEmail := M->A3_EMAIL
		ELSEIF UPPER( FUNNAME() ) == "MATA050"
			cEmail := M->A4_EMAIL
		ENDIF
		
		cMens := "Todo E-mail tem que ter (@) e terminar com (.com) ou (.com.br)."+Chr(10)+Chr( 13)+" "
		cMens += +CHR(10)+CHR( 13)+"Exemplo:"+CHR(10)+CHR( 13)+"========"+CHR(10)+CHR( 13)
		cMens += +SPACE(02)+"vendas@superfinishing.com.br"+CHR(10)+CHR( 13)+SPACE(02)+"fulano@email.com"
		cMens += +CHR(10)+CHR(13)+" "+CHR(10)+CHR( 13)+"Foi digitado (("+ALLTRIM(cEmail) +"))"
		
		IF cEmail $ " {}()<>[]|\/&*$%?!^~`,;:= #"
			
			APMSGALERT(cMens,"Atencao !!! - E-mail invalido ...")
			lRetValue := .F.
			
		ELSE
			
			IF ( nResto := AT( "@", cEmail )) > 0 .AND. AT( "@", RIGHT( cEmail, LEN( cEmail ) - nResto )) == 0
				IF ( nResto := AT( ".", RIGHT( cEmail, LEN( cEmail ) - nResto ))) > 0
					lRetValue := .T.
				ELSE
					APMSGALERT(cMens,"Atencao !!! - E-mail invalido ...")
					lRetValue := .F.
				ENDIF
			ELSE
				APMSGALERT(cMens,"Atencao !!! - E-mail invalido ...")
				lRetValue := .F.
			ENDIF
			
		ENDIF
		
	ENDIF
	
RETURN( lRetValue )
