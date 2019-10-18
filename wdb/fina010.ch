#ifdef SPANISH
	#define STR0001 "bUscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Actualizacion de modalidades"
	#define STR0007 "Salir"
	#define STR0008 "Confirmar"
	#define STR0009 "¿Cuanto al borrado?     "
	#define STR0010 "Modalidades"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Insert "
		#define STR0004 "Edit  "
		#define STR0005 "Delete "
		#define STR0006 "Updating Class"
		#define STR0007 "Cancel "
		#define STR0008 "OK     "
		#define STR0009 "About Deleting? "
		#define STR0010 "Nature"
	#else
		Static STR0001 := "Pesquisar"
		Static STR0002 := "Visualizar"
		Static STR0003 := "Incluir"
		Static STR0004 := "Alterar"
		Static STR0005 := "Excluir"
		Static STR0006 := "Atualizaçäo de Naturezas"
		Static STR0007 := "Abandona"
		Static STR0008 := "Confirma"
		Static STR0009 := "Quanto à exclusäo?"
		Static STR0010 := "Naturezas"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Pesquisar"
			STR0002 := "Visualizar"
			STR0003 := "Incluir"
			STR0004 := "Alterar"
			STR0005 := "Excluir"
			STR0006 := "Atualizaçäo de Naturezas"
			STR0007 := "Abandonar"
			STR0008 := "Confirma"
			STR0009 := "Quanto à exclusão?"
			STR0010 := "Naturezas"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
