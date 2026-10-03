#Include "minigui.ch"
#include "winprint.ch"

FUNCTION clientes
     	                 
   Private a_Cargos:={}
	     	                 
	DEFINE WINDOW funci_2;
	           AT 0,0 ;
 				  WIDTH 1000;
              HEIGHT 430;
	           TITLE 'Cadastro de Funcionários'     	;
				  ICON "TUTOR";
      		  CHILD ;
     		     ON MAXIMIZE ThisWindow.Center ;
		        ON INIT ( AbrirFuncio(),C_Cargos(),DesactivaFuncio(),ActuaFuncio()) 

		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER

			BUTTON PRIMERO 		;
				CAPTION '&Primero' 	;
				PICTURE 'primero'	;
            ACTION If(funci_2.Browse_1.value=1,MsgBox("Inicio do Arquivo"),funci_2.Browse_1.value:=1)

			BUTTON ANTERIOR 	;
				CAPTION '&Anterior' 	;
				PICTURE 'anterior'	;
            ACTION If(funci_2.Browse_1.value>1,funci_2.Browse_1.value:=funci_2.Browse_1.value-1,MsgInfo("Inicio de Dados"))

			BUTTON SIGUIENTE	;
				CAPTION '&Proximo' 	;
				PICTURE 'siguiente'	;
            ACTION (funci_2.Browse_1.value:=funci_2.Browse_1.value+1)

			BUTTON ULTIMO 		;
				CAPTION '&Ultimo' 	;
				PICTURE 'ultimo'	;
            ACTION (funci_2.Browse_1.value:=nCounter)  SEPARATOR

			BUTTON BUSCAR 		;
				CAPTION '&Pesquisa' 	;
				PICTURE 'buscar'	;
				ACTION BuscarFuncio()

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION ( funci_2.Nuevo.enabled:=.t.,funci_2.EDITAR.enabled:=.F.,NuevoFuncio())

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;
				ACTION ( funci_2.Nuevo.enabled:=.F.,funci_2.EDITAR.enabled:=.T.,ActivarFuncio())
				
			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION ElimiFuncio() 

			BUTTON IMPRIMIR 	;
				CAPTION '&Imprimir'	;
				PICTURE 'imprimir2' ;
            ACTION ImprimiFuncio() 

			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'cerrar' ;
            ACTION funci_2.release 

		END TOOLBAR

                @ 56,10 Grid Browse_1				;
			            WIDTH 210  				;
                     HEIGHT 330                              ; 
			            HEADERS { 'Fantasia' ,'Nome','Telefone'}	;
			            WIDTHS { 90,140,90 }			;
			            ON CHANGE ActuaFuncio() ;
			            ON DBLCLICK ( ActivarFuncio(), DesactivaFuncio() )
 
                     @ 70,230 LABEL Label_Fanta ;
                              VALUE 'Fantasia'    ;
                              WIDTH 60           ;
                              HEIGHT 30           

                    @100,230 LABEL Label_CGC ;
                            VALUE 'Nº CPF  '  ;
                            WIDTH 60           ;
                            HEIGHT 30           
	                                            
	                @130,230 LABEL Label_Descr;
		                    VALUE 'Nome'	;
                            WIDTH 100           ;
		                    HEIGHT 30			
	         
                   @160,230 LABEL Label_End;
                            VALUE 'Endereço'              ;
                            WIDTH 60           ;
		                    HEIGHT 30		
                            
	                @190,230 LABEL Label_Bairro	;
		                    VALUE 'Bairro'		;
                            WIDTH 60                   ;
		                    HEIGHT 30			
                         
                   @190,520 LABEL Label_Cidade ;
                            VALUE 'Cidade'      ;
                            WIDTH 60           ;
                            HEIGHT 30           
                       
                   @190,800 LABEL Label_UF    ;
                            VALUE 'UF'          ;
                            WIDTH 45                    ;
		                    HEIGHT 30			
							
	                @220,230 LABEL Label_Cep	;
		                    VALUE 'Cep'		;
                            WIDTH 60           ;
		                    HEIGHT 30				
	                    
				       @220,445 LABEL Label_Pais	;
                            VALUE 'Pais'            ;
                            WIDTH 60                    ;
		                    HEIGHT 30			
	                    
                   @220,635 LABEL Label_Tel ;
                            VALUE 'Fone'  ;
                            WIDTH 60                    ;
		                    HEIGHT 30			

                   @250,230 LABEL Label_car ;
                            VALUE 'Cargo'  ;
                            WIDTH 60                    ;
		                      HEIGHT 30		

	                @ 70,310 TEXTBOX T_Fanta;
                            OF funci_2 ;
		                      WIDTH 250			;
                            TOOLTIP 'Nome Fantasia' ;
                            MAXLENGTH 20 ;
                            UPPERCASE         ;
                            ON ENTER ( Checa_Funcio(funci_2.T_Fanta.Value) )
           
                    @100,310 TEXTBOX T_CGC  ;
                            OF funci_2 ;
                            WIDTH 150 ;
                            TOOLTIP 'Informe Nº CPF'; 
                            MAXLENGTH 20   ;
                            on lostfocus IF(empty(funci_2.T_CGC.Value),(Msginfo("Campo Obrigatorio Não Pode estar em Branco","ATENÇÃO"),funci_2.T_CGC.Setfocus),.f.)
                            ON ENTER funci_2.T_Descr.SetFocus
	                     			
 		              @130,310 TEXTBOX T_Descr ;
                            OF funci_2     ;
                            WIDTH 370       ;
                            MAXLENGTH 40   ;
                            ON ENTER funci_2.T_End.SetFocus
	         
                    @160,310 TEXTBOX T_End;
                            OF funci_2 ;
                            WIDTH 300         ;
                            MAXLENGTH 40      ;
                            ON ENTER funci_2.T_Bairro.SetFocus
                            
	                @190,310 TEXTBOX T_Bairro	;
                            OF funci_2 ;
		                    WIDTH 200                    ;
                            MAXLENGTH 20       ;
                            ON ENTER funci_2.T_Cidade.SetFocus
                         
                    @190,570 TEXTBOX T_Cidade ;
                            OF funci_2 ;
                            WIDTH 200           ;
                            MAXLENGTH 15      ;
                            ON ENTER funci_2.T_UF.SetFocus

                    @190,820 TEXTBOX T_UF    ;
                            OF funci_2 ;
                            WIDTH 45                    ;
                            MAXLENGTH 02       ;
                            ON ENTER funci_2.T_Cep.SetFocus
	                  
					    @220,310 TEXTBOX T_Cep	;
                            INPUTMASK '99999-999';
                            ON ENTER funci_2.T_Pais.SetFocus 
							
	                @220,480 TEXTBOX T_Pais	;
                            OF funci_2 ;
                            WIDTH 150           ;
                            MAXLENGTH 20        ;
                            ON ENTER funci_2.T_Tel.SetFocus

	                @220,700 TEXTBOX T_TEL	;
                            OF funci_2 ;
                            WIDTH 150           ;
                            MAXLENGTH 20                            

        		       @250,310 COMBOBOX C_cargo;
        		                OF funci_2 ;
        		                WIDTH 300 ;
								    HEIGHT 120 ; 
        		                ITEMS {}
		       		       
	             @ 280,670 BUTTON Btn_Scli Of funci_2	;
                          CAPTION '&Salvar'             ;
                          ACTION Grava_Funcio() ;
                          WIDTH 120 HEIGHT 27   ;                                 
                          TOOLTIP "Salvar Registro" ;
                          FLAT

	              @ 280,840 BUTTON Btn_Ccli Of funci_2	;
		                     CAPTION '&Cancelar'		;
                           ACTION CancelarFuncio() ;
			                  WIDTH 120 HEIGHT 27		;
                           TOOLTIP "Cancelar Operação"	;
			    FLAT

	END WINDOW

   funci_2.Browse_1.SetFocus
	
	funci_2.CENTER

	funci_2.ACTIVATE 

RETURN
*------------------------------------------------------------------------------*
PROCEDURE AbrirFuncio()
*------------------------------------------------------------------------------*
Local oRow
Local i
Local oQuery
LOCAL nCounter:= 0
LOCAL oQueryUp

DELETE ITEM ALL FROM Browse_1 Of funci_2

oQuery := oServer:Query( "Select Fanta,descr,tel From escola.cliente ORDER BY Fanta" )
 
For i := 1 To oQuery:LastRec()
    nCounter++
    oRow := oQuery:GetRow(i)
    ADD ITEM { oRow:fieldGet(1), oRow:fieldGet(2),oRow:fieldGet(3)} TO Browse_1 Of funci_2
    oQuery:Skip(1)
Next
oQuery:Destroy()
funci_2.Browse_1.value:=1  
funci_2.Browse_1.SetFocus  
Return NIL

*------------------------------------------------------------------------------*
PROCEDURE C_Cargos()
*------------------------------------------------------------------------------*
Local oRow
Local i
Local oQuery
LOCAL nCounter:= 0
LOCAL oQueryUp

funci_2.c_cargo.deleteallitems

oQuery := oServer:Query( "Select codcar,descar From escola.Cargos ORDER BY descar" )
 
For i := 1 To oQuery:LastRec()
    nCounter++
    oRow := oQuery:GetRow(i)
    ADD item str(oRow:fieldGet(1),6,2)+" | "+oRow:fieldGet(2) TO C_cargo Of funci_2 
    oQuery:Skip(1)
Next
oQuery:Destroy()
funci_2.C_cargo.Value := 1
Return

*------------------------------------------------------------------------------*
PROCEDURE DesactivaFuncio
*------------------------------------------------------------------------------*
        
         funci_2.Browse_1.Enabled:= .T.
         funci_2.T_Descr.Enabled:=.F.
         funci_2.T_Fanta.Enabled:=.F.
         funci_2.T_End.Enabled:=.F.
         funci_2.T_Tel.Enabled:=.F.
         funci_2.T_Cep.Enabled:=.F.
         funci_2.T_Cidade.Enabled:=.F.
         funci_2.T_Uf.Enabled:=.F.
         funci_2.T_CGC.Enabled:=.F.
         funci_2.T_BAIRRO.Enabled:=.F.       
         funci_2.T_PAIS.Enabled:=.F.
         funci_2.C_cargo.Enabled:=.F.
         funci_2.Btn_Ccli.Enabled:= .F.
   	   funci_2.Btn_Scli.Enabled:= .F.

         funci_2.ToolBar_1.Enabled:= .T.                                                                             
         funci_2.Browse_1.SetFocus

			
RETURN
*------------------------------------------------------------------------------*
PROCEDURE ActivarFuncio
*------------------------------------------------------------------------------*
     
         funci_2.Browse_1.Enabled:= .F.
	      funci_2.ToolBar_1.Enabled:= .F.
	      funci_2.T_Descr.Enabled:=.T.
         funci_2.T_Fanta.Enabled:=funci_2.Nuevo.enabled
         funci_2.T_End.Enabled:=.T.
         funci_2.T_Tel.Enabled:=.T.
         funci_2.T_Cep.Enabled:=.T.
         funci_2.T_Cidade.Enabled:=.T.
         funci_2.T_Uf.Enabled:=.T.
         funci_2.T_CGC.Enabled:=.T.
         funci_2.T_BAIRRO.Enabled:=.T.       
         funci_2.T_PAIS.Enabled:=.T.
         funci_2.C_cargo.Enabled:=.t.
         funci_2.Btn_Ccli.Enabled:= .T.
    	 funci_2.Btn_Scli.Enabled:= .T.
   	 
RETURN NIL
*------------------------------------------------------------------------------*
PROCEDURE CancelarFuncio()
*------------------------------------------------------------------------------*

   funci_2.Nuevo.enabled :=.T.
	funci_2.EDITAR.enabled:=.T.
	DesactivaFuncio()

	ActuaFuncio()

RETURN
*------------------------------------------------------------------------------*
PROCEDURE Grava_Funcio()
*------------------------------------------------------------------------------*
LOCAL oQueryUp 
LOCAL cQuery
LOCAL c_codigo:=PegaValorDaColuna( "BROWSE_1" , "funci_2" ,1)
local n_pos:=funci_2.C_cargo.value
local g_cargo:=substr(funci_2.C_cargo.displayvalue,1,6) 

DesactivaFuncio()

If funci_2.nuevo.enabled == .T.
   cQuery:="INSERT INTO escola.cliente (descr,fanta,end,tel,cep,cidade,uf,cgc,bairro,pais,cargo)"
   cQuery+=" values ('"+funci_2.T_Descr.Value+"','"+funci_2.T_Fanta.Value+"','"+funci_2.T_End.Value
   cQuery+="','"+funci_2.T_Tel.Value+"','"+funci_2.T_Cep.Value+"','"+funci_2.T_Cidade.Value
   cQuery+="','"+funci_2.T_Uf.Value+"','"+funci_2.T_CGC.Value+"','"+funci_2.T_BAIRRO.value
   cQuery+="','"+funci_2.T_PAIS.Value+"','"+g_cargo+"')"
   oQueryUp:=oServer:Query(cQuery)
Elseif funci_2.nuevo.enabled == .F.
   cQuery:="UPDATE escola.cliente SET descr='"+funci_2.T_Descr.Value
	cQuery+="',end='"+funci_2.T_End.Value
   cQuery+="',tel='"+funci_2.T_Tel.Value+"',cep='"+funci_2.T_Cep.Value
   cQuery+="',cidade='"+funci_2.T_Cidade.Value+"',uf='"+funci_2.T_Uf.Value
   cQuery+="',cgc='"+funci_2.T_CGC.Value+"',bairro='"+funci_2.T_BAIRRO.value
   cQuery+="',pais='"+funci_2.T_PAIS.Value+"',cargo='"+g_cargo
   cQuery+="' where fanta='"+c_codigo+"'"
   oQueryUp:=oServer:Query(cQuery)
EndIf

AbrirFuncio()   
   
funci_2.Browse_1.Refresh
funci_2.nuevo.enabled:=.T.
funci_2.editar.enabled:=.T.

DesactivaFuncio()
RETURN

*------------------------------------------------------------------------------*
PROCEDURE ActuaFuncio()
*------------------------------------------------------------------------------*
Local oRow
Local oQuery
LOCAL n_Pos:= 0
LOCAL c_codigo:=PegaValorDaColuna( "BROWSE_1" , "funci_2" ,1)

oQuery := oServer:Query( "Select descr,fanta,end,tel,cep,cidade,uf,cgc,bairro,pais,cargo From escola.cliente WHERE Fanta='"+c_codigo+"'")
                
If oQuery:LastRec() > 0 //N_Pos > 0
   oRow := oQuery:GetRow(1) 
   Cria__Gets_Funcio(@oRow)
endif   
oQuery:Destroy()   
Return
*------------------------------------------------------------------------------*
Procedure Cria__Gets_Funcio(oRow)
*------------------------------------------------------------------------------*
	funci_2.T_Descr.Value:=oRow:fieldGet(1) 
   funci_2.T_Fanta.Value:=oRow:fieldGet(2) 
   funci_2.T_End.Value  :=oRow:fieldGet(3)
   funci_2.T_Tel.Value  :=oRow:fieldGet(4) 
   funci_2.T_Cep.Value  :=oRow:fieldGet(5)
   funci_2.T_Cidade.Value:=oRow:fieldGet(6)
   funci_2.T_Uf.Value   :=oRow:fieldGet(7)
   funci_2.T_CGC.Value  :=oRow:fieldGet(8)
   funci_2.T_BAIRRO.value:=oRow:fieldGet(9)       
   funci_2.T_PAIS.value:=oRow:fieldGet(10)
   funci_2.C_cargo.value:=oRow:fieldGet(11)
return	       	   
*------------------------------------------------------------------------------*
Procedure BuscarFuncio()
*------------------------------------------------------------------------------*
Local Buscar
Local nOption:=0 
local nPos:=0
LOCAL i, j
Local oRow
Local oQuery
LOCAL c_codigo

nOption:=MsgOptions("Opçôes","Pesquisa","Users.Bmp" , {"&Fantasia","&Nome"}, 2, 20 )

  DO CASE
     CASE nOption=1
          Buscar := alltrim(InputBox( 'Informe Fantasia' , 'Pesquisa' ) )  
          FOR i := 1 TO funci_2.Browse_1.ItemCount
              funci_2.Browse_1.value:=i
              if alltrim(PegaValorDaColuna( "BROWSE_1" , "funci_2",1)) = Buscar
                 nPos:=1
                 exit
              endif   
          NEXT i
     CASE nOPTION=2
          Buscar := AllTrim ( InputBox( 'Informe Nome' , 'Pesquisa' ) )
          FOR i := 1 TO funci_2.Browse_1.ItemCount
              funci_2.Browse_1.value:=i
              if alltrim(PegaValorDaColuna( "BROWSE_1" , "funci_2",2)) = Buscar
                 nPos:=1
                 exit
              endif   
          NEXT i          
  ENDCASE 			  

If NPos > 0
   c_codigo:=PegaValorDaColuna( "BROWSE_1" , "funci_2" ,1)
   oQuery := oServer:Query( "Select descr,fanta,end,tel,cep,cidade,uf,cgc,bairro,pais,cargo From escola.cliente WHERE Fanta='"+c_codigo+"'")
   oRow := oQuery:GetRow(1) 
   Cria__Gets_Funcio(@oRow)
   oQuery:Destroy() 
Else
   MsgExclamation('Não Encontrado Registro')
endif   

funci_2.Browse_1.Refresh
       
Return
*------------------------------------------------------------------------------*
PROCEDURE NuevoFuncio()
*------------------------------------------------------------------------------*
 
	      funci_2.T_Descr.Value:=""
         funci_2.T_Fanta.Value:=""
         funci_2.T_End.Value := ""
         funci_2.T_Tel.Value := ""
         funci_2.T_Cep.Value := ""
         funci_2.T_Cidade.Value := ""
         funci_2.T_Uf.Value := ""
         funci_2.T_CGC.Value := ""
         funci_2.T_BAIRRO.value:=""       
         funci_2.T_PAIS.value:=""
         funci_2.C_cargo.value:=""
         ActivarFuncio()
       
RETURN

*------------------------------------------------------------------------------*
Procedure ElimiFuncio()
*------------------------------------------------------------------------------*
local cQuery
LOCAL c_codigo:=PegaValorDaColuna( "BROWSE_1" , "funci_2" ,1)
If MsgYesNo ( "Confirma Exclusão ?","Atenção")
   cQuery:= oServer:Query( "DELETE FROM escola.cidade WHERE fanta='"+c_codigo+"'")
   cQuery:Destroy()
   Abrirturma()
	Actualizarturma()
EndIf
Return NIL

Procedure Checa_Funcio()
**********************************
* verifica possibilidade de inclusão
**********************************
local cQuery
oQuery := oServer:Query( "Select fanta From escola.cliente WHERE Fanta='"+funci_2.T_Fanta.Value+"'")
if oQuery:LastRec() > 0
   Msginfo("Nome Fantasia Já Cadastrado!","Verifique")
   CancelarFuncio()
EndIf   
oQuery:Destroy()
Return NIL           

**************************************
PROCEDURE ImprimiFuncio()
*************************************
#include "winprint.ch"
Local dirimp:=GetCurrentFolder()
Local oRow
Local i
Local oQuery
LOCAL nCounter:= 0
LOCAL oQueryUp
Local A_Clientes:={}

Request HB_CODEPAGE_PT850

TITULOIMP:="Relatório Funcionários"
 
INIT PRINTSYS
SELECT BY DIALOG PREVIEW

IF HBPRNERROR>0
   release printsys
   SetCurrentFolder(dirimp)
   return nil
ENDIF

oQuery := oServer:Query( "Select descr,fanta,end,tel,cep,cidade,uf,cgc,bairro,pais,cargo From escola.cliente ORDER BY descr")
 
For i := 1 To oQuery:LastRec()
    nCounter++
    oRow := oQuery:GetRow(i)
    AADD(A_Clientes,{ oRow:fieldGet(1), oRow:fieldGet(2), oRow:fieldGet(3), oRow:fieldGet(4),oRow:fieldGet(5), oRow:fieldGet(6), oRow:fieldGet(7),oRow:fieldGet(8), oRow:fieldGet(9), oRow:fieldGet(10),str(oRow:fieldGet(11),6,2)})
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

for i:=1 to len(A_Clientes)
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
      @ ++LH,55 SAY "Relatorio de Funcionários" TO PRINT
      LH+=5
      select font "ft10"

      @ LH,00,LH+5,24 RECTANGLE
      @ LH,24,LH+5,96 RECTANGLE
      @ LH,96,LH+5,120 RECTANGLE
      @ LH,120,LH+5,170 RECTANGLE

      @ LH,01 SAY "Fantasia" TO PRINT
	   @ LH,25 SAY "Nome" TO PRINT
      @ LH,97 SAY "Telefone" TO PRINT
      @ LH,121 SAY "Endereço" TO PRINT

		LH+=5
	endif

      @ LH,00,LH+5,24 RECTANGLE
      @ LH,24,LH+5,96 RECTANGLE
      @ LH,96,LH+5,120 RECTANGLE
      @ LH,120,LH+5,170 RECTANGLE

   @ LH,01 SAY A_Clientes[i,2] TO PRINT
	@ LH,25 SAY A_Clientes[i,1] TO PRINT
   @ LH,97 SAY A_Clientes[i,4] TO PRINT
   @ LH,121 SAY A_Clientes[i,3] TO PRINT

	LH+=5
next	
end page
end doc
release printsys
SetCurrentFolder(dirimp)
RETURN NIL 
