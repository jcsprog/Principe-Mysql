#Include "minigui.ch"

PROCEDURE MEDIC

	DEFINE WINDOW medic_1;
	           AT 0,0 ;
 				  WIDTH 660				;
              HEIGHT 370    ;
	           TITLE 'Cadastro de Medicos' 	;
				  ICON "TUTOR";
				  CHILD 				;
		        FONT 'ARIAL' SIZE 9;	
				  ON MAXIMIZE ThisWindow.Center ;
		        ON INIT ( Abrirmedic(),Desactivmedic(),Actualizarmedic())

		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER

			BUTTON PRIMERO 		;
				CAPTION '&Primero' 	;
				PICTURE 'primero'	;
				ACTION If(medic_1.Browse_1.value=1,MsgBox("Inicio do Arquivo"),medic_1.Browse_1.value:=1)

			BUTTON ANTERIOR 	;
				CAPTION '&Anterior' 	;
				PICTURE 'anterior'	;
				ACTION If(medic_1.Browse_1.value>1,medic_1.Browse_1.value:=medic_1.Browse_1.value-1,MsgInfo("Inicio de Dados"))

			BUTTON SIGUIENTE	;
				CAPTION '&Proximo' 	;
				PICTURE 'siguiente'	;
				ACTION (medic_1.Browse_1.value:=medic_1.Browse_1.value+1)

			BUTTON ULTIMO 		;
				CAPTION '&Ultimo' 	;
				PICTURE 'ultimo'	;
				ACTION (medic_1.Browse_1.value:=nCounter)  SEPARATOR

			BUTTON BUSCAR 		;
				CAPTION '&Pesquisa' 	;
				PICTURE 'buscar'	;
				ACTION Buscarmedic()

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION ( medic_1.Nuevo.enabled:=.t.,medic_1.EDITAR.enabled:=.F.,Nuevomedic())

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;
				ACTION ( medic_1.Nuevo.enabled:=.f.,medic_1.EDITAR.enabled:=.t.,Activarmedic())

			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION Eliminarmedic() 

			BUTTON IMPRIMIR 	;
				CAPTION '&Imprimir'	;
				PICTURE 'imprimir2' ;
				ACTION Imprimirmedic() 

			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'cerrar' ;
            ACTION medic_1.release
            
		END TOOLBAR

            @ 56,10 grid Browse_1				;
		        	     WIDTH 230 				;
                    HEIGHT 230                            ; 
			           HEADERS { 'Codigo' , 'Descrição ' }	;
		        	     WIDTHS { 55, 195 }			;
			           ON CHANGE Actualizarmedic() ;
			           ON DBLCLICK ( Activarmedic() , Desactivmedic() )
		
                     @ 70,240 LABEL Label_CODPRO;
                              VALUE 'Codigo';
						          	WIDTH 100           ;
                              HEIGHT 30           ;
	                           FONT 'Arial' SIZE 09	
 
                     @ 100,240 LABEL Label_DESPRO;
                             VALUE 'Descrição';
                             WIDTH 100           ;
                             HEIGHT 30           ;
	                         FONT 'Arial' SIZE 09
                                                        
                    @ 70,310 TEXTBOX T_CODmed
							 
                    @ 100,310 TEXTBOX T_DESmed;
                             OF medic_1 ;
		                      WIDTH 300			;
                            TOOLTIP 'Descrição do medico' ;
                            MAXLENGTH 30 ;
                            UPPERCASE         
								 									        
                    @ 180,310 BUTTON Btn_Smedic Of medic_1        ;
                              CAPTION '&Salvar'             ;
                              ACTION Aceptarmedic() ;
                              WIDTH 100 HEIGHT 27         ;
                              FONT "Arial" SIZE 09          ;
                              TOOLTIP "Salvar Registro" ;
                            FLAT

                    @ 180,470 BUTTON Btn_Cmedic Of medic_1        ;
                              CAPTION '&Cancelar'		;
                              ACTION Cancelarmedic() ;
		                      WIDTH 100 HEIGHT 27		;
                              FONT "Arial" SIZE 09		;
                              TOOLTIP "Cancelar Operação"	;
			                FLAT

	END WINDOW

   medic_1.Browse_1.SetFocus
		
	medic_1.CENTER 

	medic_1.ACTIVATE  

RETURN

*------------------------------------------------------------------------------*
PROCEDURE Abrirmedic
*------------------------------------------------------------------------------*
Local oRow
Local i
Local oQuery
LOCAL nCounter:= 0
LOCAL oQueryUp

DELETE ITEM ALL FROM Browse_1 Of medic_1

oQuery := oServer:Query( "Select codmed,desmed From escola.tab_med ORDER BY desmed" )
 
For i := 1 To oQuery:LastRec()
    nCounter++
    oRow := oQuery:GetRow(i)
    ADD ITEM { str(oRow:fieldGet(1),6,2), oRow:fieldGet(2)} TO Browse_1 Of medic_1
    oQuery:Skip(1)
Next
oQuery:Destroy()
medic_1.Browse_1.value:=1  
medic_1.Browse_1.SetFocus  
Return NIL

*------------------------------------------------------------------------------*
PROCEDURE Desactivmedic
*------------------------------------------------------------------------------*
        medic_1.Browse_1.Enabled:= .T.
        medic_1.T_CODMED.Enabled:=.F.
	     medic_1.T_DESMED.Enabled:=.F.
        medic_1.Btn_Cmedic.Enabled:= .F.
	     medic_1.Btn_Smedic.Enabled:= .F.

        medic_1.ToolBar_1.Enabled:= .T.

        medic_1.Browse_1.SetFocus

RETURN
*------------------------------------------------------------------------------*
PROCEDURE Activarmedic
*------------------------------------------------------------------------------*

        medic_1.Browse_1.Enabled:= .F.
	     medic_1.ToolBar_1.Enabled:= .F.
	     medic_1.T_CODMED.Enabled:=.F.
        medic_1.T_DESMED.Enabled:=.T.
        medic_1.Btn_Cmedic.Enabled:= .T.
     	  medic_1.Btn_Smedic.Enabled:= .T.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE Cancelarmedic()
*------------------------------------------------------------------------------*

   medic_1.Nuevo.enabled:=.t.
	medic_1.EDITAR.enabled:=.t.
	Desactivmedic()

	Actualizarmedic()

RETURN
*------------------------------------------------------------------------------*
PROCEDURE Aceptarmedic()
*------------------------------------------------------------------------------*
LOCAL oQueryUp
LOCAL c_codigo:=PegaValorDaColuna( "BROWSE_1" , "medic_1" ,1)

If medic_1.nuevo.enabled == .T.
   cQuery:="INSERT INTO escola.tab_med (codmed,desmed)"
   cQuery+=" values ('"+medic_1.T_codmed.VALUE+"','"+medic_1.T_desmed.VALUE+"')"
   oQueryUp:=oServer:Query(cQuery)
Elseif medic_1.nuevo.enabled == .F.
   cQuery:="UPDATE escola.tab_med SET desmed='"+medic_1.T_desmed.VALUE
   cQuery+="' where codmed='"+c_codigo+"'"
   oQueryUp:=oServer:Query(cQuery)
EndIf

Abrirmedic()   
   
medic_1.Browse_1.Refresh
medic_1.nuevo.enabled:=.T.
medic_1.editar.enabled:=.T.

Desactivmedic()
Return

*------------------------------------------------------------------------------*
PROCEDURE Actualizarmedic()
*------------------------------------------------------------------------------*
medic_1.T_codmed.VALUE  := PegaValorDaColuna( "BROWSE_1" , "medic_1",1)
medic_1.T_desmed.VALUE  := PegaValorDaColuna( "BROWSE_1" , "medic_1",2)
Return

*------------------------------------------------------------------------------*
Procedure Buscarmedic
*------------------------------------------------------------------------------*
Local Buscar
Local nOption:=0 
local nPos:=0
LOCAL i, j

nOption:=MsgOptions("Opçôes","Pesquisa","Users.Bmp" , {"&Codigo","&Descrição"}, 2, 20 )

  DO CASE
     CASE nOption=1
          Buscar := alltrim(InputBox( 'Informe Codigo' , 'Pesquisa' ) )  
          FOR i := 1 TO medic_1.Browse_1.ItemCount
              medic_1.Browse_1.value:=i
              if alltrim(PegaValorDaColuna( "BROWSE_1" , "medic_1",1)) = Buscar
                 nPos:=1
                 exit
              endif   
          NEXT i
     CASE nOPTION=2
          Buscar := AllTrim ( InputBox( 'Informe Descrição' , 'Pesquisa' ) )
          FOR i := 1 TO medic_1.Browse_1.ItemCount
              medic_1.Browse_1.value:=i
              if alltrim(PegaValorDaColuna( "BROWSE_1" , "medic_1",2)) = Buscar
                 nPos:=1
                 exit
              endif   
          NEXT i          
  ENDCASE 			  

IF nPos > 0
   Actualizarmedic()
Else
   MsgExclamation('Não Encontrado Registro')
EndIf
   
medic_1.Browse_1.Refresh
Return


*------------------------------------------------------------------------------*
PROCEDURE Nuevomedic()
*------------------------------------------------------------------------------*
local oRow
Local i
Local oQuery
LOCAL nCounter:= 0
LOCAL oQueryUp

oQuery := oServer:Query( "Select codmed,desmed From escola.tab_med ORDER BY codmed" ) 
For i := 1 To oQuery:LastRec()
    nCounter++
    oRow := oQuery:GetRow(i)
    oQuery:Skip(1)
Next                                                                                  
oQuery:Destroy()
nCounter++
medic_1.T_codmed.VALUE := STR(nCounter,6,2)
medic_1.T_DESMED.VALUE := space(30) 

ActivarMEDIC()
RETURN

*------------------------------------------------------------------------------*
Procedure Eliminarmedic
*------------------------------------------------------------------------------*
local cQuery
LOCAL c_codigo:=PegaValorDaColuna( "BROWSE_1" , "medic_1" ,1)
If MsgYesNo ( "Confirma Exclusão?","Atenção")
   cQuery:= oServer:Query( "DELETE FROM escola.tab_med WHERE CODMED='"+c_codigo+"'")
   cQuery:Destroy()
   Abrirmedic()
	ActualizarMEDIC()
EndIf
return 
*------------------------------------------------------------------------------*
Procedure Imprimirmedic()
*------------------------------------------------------------------------------*
#include "winprint.ch"
Local dirimp:=GetCurrentFolder()
Local oRow
Local i
Local oQuery
LOCAL nCounter:= 0
LOCAL oQueryUp
Local A_Medic:={}

Request HB_CODEPAGE_PT850

TITULOIMP:="Cadastro de Medicos"
 
INIT PRINTSYS
SELECT BY DIALOG PREVIEW

IF HBPRNERROR>0
   release printsys
   SetCurrentFolder(dirimp)
   return nil
ENDIF

oQuery := oServer:Query( "Select codmed,desmed From escola.tab_med ORDER BY codmed" )
For i := 1 To oQuery:LastRec()
    nCounter++
    oRow := oQuery:GetRow(i)
    AADD(A_Medic,{ str(oRow:fieldGet(1),6,2), oRow:fieldGet(2)})
    oQuery:Skip(1)
Next
oQuery:Destroy()

HB_SETCODEPAGE( "PT850" )

SET UNITS MM
// Definição das fontes.
define font "ft08" name "times new roman" size 08
define font "ft10" name "times new roman" size 10
define font "ft12" name "times new roman" size 12 //bold=negrita
define font "ft14" name "times new roman" size 14
define font "ft18" name "times new roman" size 18

// Definição das Linhas.
define pen "p0" style PS_SOLID width 1 color 0x000000
define pen "p1" style PS_DOT width 1 color 0xFF0000
define pen "p2" style PS_NULL

set page orientation DMORIENT_PORTRAIT papersize DMPAPER_A4 font "ft10"
start doc name TituloImp
start page
   
PAG:=0
LH:=0

for i:=1 to len(A_Medic)
   IF LH > 48 .OR. PAG=0   
      IF PAG<>0
         end page
         start page
      ENDIF
      PAG++
      LH:=1
      select font "ft12"
      @ LH,01 SAY Empresa[1]+space(70)+SUBSTR(DTOC(DATE()),1,6)+str(year(DATE()),4) TO PRINT
      LH+=8
      @ ++LH,55 SAY "Relatorio de Médicos" TO PRINT
      LH+=5
      select font "ft10"

      @ LH,00,LH+5,14 RECTANGLE
      @ LH,14,LH+5,56 RECTANGLE
      @ LH,01 SAY "Codigo" TO PRINT
	   @ LH,15 SAY "Descrição" TO PRINT

		LH+=5
	endif

   @ LH,00,LH+5,14 RECTANGLE
   @ LH,14,LH+5,56 RECTANGLE

   @ LH,01 SAY A_Medic[i,1] TO PRINT
	@ LH,15 SAY A_Medic[i,2] TO PRINT

	LH+=5
next	
end page
end doc
release printsys
SetCurrentFolder(dirimp)
RETURN NIL 