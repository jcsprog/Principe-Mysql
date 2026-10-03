#Include "minigui.ch"

PROCEDURE Cargo

	DEFINE WINDOW Cargo_1;
	           AT 0,0 ;
 				  WIDTH 660				;
              HEIGHT 370    ;
	           TITLE 'Cadastro de Cargos' 	;
				  ICON "TUTOR";
				  CHILD 				;
		        FONT 'ARIAL' SIZE 9;	
				  ON MAXIMIZE ThisWindow.Center ;
		        ON INIT ( AbrirCargo(),DesactivCargo(),ActualizarCargo())

		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER

			BUTTON PRIMERO 		;
				CAPTION '&Primero' 	;
				PICTURE 'primero'	;
				ACTION If(Cargo_1.Browse_1.value=1,MsgBox("Inicio do Arquivo"),Cargo_1.Browse_1.value:=1)

			BUTTON ANTERIOR 	;
				CAPTION '&Anterior' 	;
				PICTURE 'anterior'	;
				ACTION If(Cargo_1.Browse_1.value>1,Cargo_1.Browse_1.value:=Cargo_1.Browse_1.value-1,MsgInfo("Inicio de Dados"))

			BUTTON SIGUIENTE	;
				CAPTION '&Proximo' 	;
				PICTURE 'siguiente'	;
				ACTION (Cargo_1.Browse_1.value:=Cargo_1.Browse_1.value+1)

			BUTTON ULTIMO 		;
				CAPTION '&Ultimo' 	;
				PICTURE 'ultimo'	;
				ACTION (Cargo_1.Browse_1.value:=nCounter)  SEPARATOR

			BUTTON BUSCAR 		;
				CAPTION '&Pesquisa' 	;
				PICTURE 'buscar'	;
				ACTION BuscarCargo()

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION (Cargo_1.nuevo.enabled:=.t.,Cargo_1.editar.enabled:=.f.,NuevoCargo())

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;
				ACTION (Cargo_1.nuevo.enabled:=.F.,Cargo_1.editar.enabled:=.T.,ActivarCargo())

			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION EliminarCargo() 

			BUTTON IMPRIMIR 	;
				CAPTION '&Imprimir'	;
				PICTURE 'imprimir2' ;
				ACTION (ImprimirCargo()) 

			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'cerrar' ;
            ACTION Cargo_1.release
            
		END TOOLBAR

            @ 56,10 Grid Browse_1				;
		        	     WIDTH 230 				;
                    HEIGHT 230                            ; 
			           HEADERS { 'Codigo' , 'Descrição ' }	;
		        	     WIDTHS { 55, 195 }			;
			           ON CHANGE ActualizarCargo() ;
			           ON DBLCLICK ( ActivarCargo() , DesactivCargo() )
		
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
                                                        
                    @ 70,310 TEXTBOX T_CODCAR
							 
                    @ 100,310 TEXTBOX T_DESCAR;
                             OF Cargo_1 ;
		                      WIDTH 300			;
                            TOOLTIP 'Descrição do Cargoo' ;
                            MAXLENGTH 30 ;
                            UPPERCASE         
									 									        
                    @ 180,310 BUTTON Btn_SCargo Of Cargo_1        ;
                              CAPTION '&Salvar'             ;
                              ACTION Grava_Cargo();
                              WIDTH 100 HEIGHT 27         ;
                              FONT "Arial" SIZE 09          ;
                              TOOLTIP "Salvar Registro" ;
                            FLAT

                    @ 180,470 BUTTON Btn_CCargo Of Cargo_1        ;
                              CAPTION '&Cancelar'		;
                              ACTION CancelarCargo() ;
		                      WIDTH 100 HEIGHT 27		;
                              FONT "Arial" SIZE 09		;
                              TOOLTIP "Cancelar Operação"	;
			                FLAT

	END WINDOW

   Cargo_1.Browse_1.SetFocus
		
	Cargo_1.CENTER 

	Cargo_1.ACTIVATE  

RETURN

*------------------------------------------------------------------------------*
PROCEDURE AbrirCargo()
*------------------------------------------------------------------------------*
Local oRow
Local i
Local oQuery
LOCAL nCounter:= 0
LOCAL oQueryUp

DELETE ITEM ALL FROM Browse_1 Of Cargo_1

oQuery := oServer:Query( "Select codcar,descar From escola.Cargos ORDER BY descar" )
 
For i := 1 To oQuery:LastRec()
    nCounter++
    oRow := oQuery:GetRow(i)
    ADD ITEM { str(oRow:fieldGet(1),6,2), oRow:fieldGet(2)} TO Browse_1 Of Cargo_1
    oQuery:Skip(1)
Next
oQuery:Destroy()
Cargo_1.Browse_1.value:=1  
Cargo_1.Browse_1.SetFocus  
Return NIL
              
*------------------------------------------------------------------------------*
PROCEDURE DesactivCargo()
*------------------------------------------------------------------------------*
        Cargo_1.Browse_1.Enabled:= .T.
        Cargo_1.T_CODCAR.Enabled:=.F.
	     Cargo_1.T_DESCAR.Enabled:=.F.
        Cargo_1.Btn_CCargo.Enabled:= .F.
	     Cargo_1.Btn_SCargo.Enabled:= .F.
        Cargo_1.ToolBar_1.Enabled:= .T.
        Cargo_1.Browse_1.SetFocus

RETURN
*------------------------------------------------------------------------------*
PROCEDURE ActivarCargo()
*------------------------------------------------------------------------------*

        Cargo_1.Browse_1.Enabled:= .F.
	     Cargo_1.ToolBar_1.Enabled:= .F.
	     Cargo_1.T_CODCAR.Enabled:=.F.
        Cargo_1.T_DESCAR.Enabled:=.T.
        Cargo_1.Btn_CCargo.Enabled:= .T.
     	  Cargo_1.Btn_SCargo.Enabled:= .T.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE CancelarCargo()
*------------------------------------------------------------------------------*

   Cargo_1.nuevo.enabled:=.T.
   Cargo_1.editar.enabled:=.T.
   
	DesactivCargo()

	ActualizarCargo()

	Nuevo := .F.

RETURN
*------------------------------------------------------------------------------*
PROCEDURE Grava_Cargo()
*------------------------------------------------------------------------------*
LOCAL oQueryUp
LOCAL c_codigo:=PegaValorDaColuna( "BROWSE_1" , "Cargo_1" ,1)

If Cargo_1.nuevo.enabled == .T.
   cQuery:="INSERT INTO escola.Cargos (codcar,descar)"
   cQuery+=" values ('"+Cargo_1.T_CODCAR.VALUE+"','"+Cargo_1.T_DESCAR.value+"')"
   oQueryUp:=oServer:Query(cQuery)
Elseif Cargo_1.nuevo.enabled == .F.
   cQuery:="UPDATE escola.Cargos SET descar='"+Cargo_1.T_DESCAR.value
   cQuery+="' where codcar='"+c_codigo+"'"
   oQueryUp:=oServer:Query(cQuery)
EndIf

AbrirCargo()   
   
Cargo_1.Browse_1.Refresh
Cargo_1.nuevo.enabled:=.T.
Cargo_1.editar.enabled:=.T.

DesactivCargo()
Return
*------------------------------------------------------------------------------*
PROCEDURE ActualizarCargo()
*------------------------------------------------------------------------------*
Cargo_1.T_CODCAR.VALUE := PegaValorDaColuna( "BROWSE_1" , "Cargo_1",1)
Cargo_1.T_DESCAR.VALUE := PegaValorDaColuna( "BROWSE_1" , "Cargo_1",2)
Return

*------------------------------------------------------------------------------*
Procedure BuscarCargo()
*------------------------------------------------------------------------------*
Local Buscar
Local nOption:=0 
local nPos:=0
LOCAL i, j

nOption:=MsgOptions("Opçôes","Pesquisa","Users.Bmp" , {"&Codigo","&Descrição"}, 2, 20 )

  DO CASE
     CASE nOption=1
          Buscar := alltrim(InputBox( 'Informe Codigo' , 'Pesquisa' ) )  
          FOR i := 1 TO Cargo_1.Browse_1.ItemCount
              Cargo_1.Browse_1.value:=i
              if alltrim(PegaValorDaColuna( "BROWSE_1" , "Cargo_1",1)) = Buscar
                 nPos:=1
                 exit
              endif   
          NEXT i
     CASE nOPTION=2
          Buscar := AllTrim ( InputBox( 'Informe Descrição' , 'Pesquisa' ) )
          FOR i := 1 TO Cargo_1.Browse_1.ItemCount
              Cargo_1.Browse_1.value:=i
              if alltrim(PegaValorDaColuna( "BROWSE_1" , "Cargo_1",2)) = Buscar
                 nPos:=1
                 exit
              endif   
          NEXT i          
  ENDCASE 			  

IF nPos > 0
   ActualizarCargo()
Else
   MsgExclamation('Não Encontrado Registro')
EndIf
   
Cargo_1.Browse_1.Refresh
       
Return
*------------------------------------------------------------------------------*
PROCEDURE NuevoCargo()
*------------------------------------------------------------------------------*
local oRow
Local i
Local oQuery
LOCAL nCounter:= 0
LOCAL oQueryUp

oQuery := oServer:Query( "Select CODCAR,DESCAR From escola.Cargos ORDER BY codcar" )
 
For i := 1 To oQuery:LastRec()
    nCounter++
    oRow := oQuery:GetRow(i)
    oQuery:Skip(1)
Next                                                                                  
oQuery:Destroy()
nCounter++
Cargo_1.T_CODCAR.VALUE := STR(nCounter,6,2)
Cargo_1.T_DESCAR.VALUE := space(30) 

ActivarCargo()

RETURN

*------------------------------------------------------------------------------*
Procedure EliminarCargo()
*------------------------------------------------------------------------------*
local cQuery
LOCAL c_codigo:=PegaValorDaColuna( "BROWSE_1" , "Cargo_1" ,1)
If MsgYesNo ( "Confirma Exclusão da Cargo ?","Atenção")
   cQuery:= oServer:Query( "DELETE FROM escola.Cargos WHERE CODPRO='"+c_codigo+"'")
   cQuery:Destroy()
   AbrirCargo()
	ActualizarCargo()
EndIf
return 

*------------------------------------------------------------------------------*
Procedure ImprimirCargo()
*------------------------------------------------------------------------------*
#include "winprint.ch"
Local dirimp:=GetCurrentFolder()
Local oRow
Local i
Local oQuery
LOCAL nCounter:= 0
LOCAL oQueryUp
Local A_Cargos:={}

Request HB_CODEPAGE_PT850

TITULOIMP:="Cadastro de Cargos"
 
INIT PRINTSYS
SELECT BY DIALOG PREVIEW

IF HBPRNERROR>0
   release printsys
   SetCurrentFolder(dirimp)
   return nil
ENDIF

oQuery := oServer:Query( "Select codcar,descar From escola.Cargos ORDER BY descar" )
 
For i := 1 To oQuery:LastRec()
    nCounter++
    oRow := oQuery:GetRow(i)
    AADD(A_Cargos,{ str(oRow:fieldGet(1),6,2), oRow:fieldGet(2)})
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

for i:=1 to len(A_Cargos)
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
      @ ++LH,55 SAY "Relatorio de Cargos" TO PRINT
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

   @ LH,01 SAY A_Cargos[i,1] TO PRINT
	@ LH,15 SAY A_Cargos[i,2] TO PRINT

	LH+=5
next	
end page
end doc
release printsys
SetCurrentFolder(dirimp)
RETURN NIL 

