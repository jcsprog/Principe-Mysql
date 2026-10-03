#Include "minigui.ch"

PROCEDURE CTROBS

   Public Nuevo := .F.
	
	DEFINE WINDOW cto_1;
	           AT 0,0 ;
 				  WIDTH 900				;
              HEIGHT 630    ;
	           TITLE 'Controle de Observações do Aluno' 	;
				  ICON "TUTOR";
				  CHILD 				;
		        FONT 'ARIAL' SIZE 11;	
				  ON MAXIMIZE ThisWindow.Center ;
		        ON INIT (Cria_aluno(),Desactivcto(),Actualizarcto())

		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER

			BUTTON PRIMERO 		;
				CAPTION '&Primero' 	;
				PICTURE 'primero'	;
				ACTION If(cto_1.Browse_1.value=1,MsgBox("Inicio do Arquivo"),cto_1.Browse_1.value:=1)

			BUTTON ANTERIOR 	;
				CAPTION '&Anterior' 	;
				PICTURE 'anterior'	;
			   ACTION If(cto_1.Browse_1.value>1,cto_1.Browse_1.value:=cto_1.Browse_1.value-1,MsgInfo("Inicio de Dados"))
            
			BUTTON SIGUIENTE	;
				CAPTION '&Proximo' 	;
				PICTURE 'siguiente'	;
				ACTION (cto_1.Browse_1.value:=cto_1.Browse_1.value+1)

			BUTTON ULTIMO 		;
				CAPTION '&Ultimo' 	;
				PICTURE 'ultimo'	;
				ACTION (cto_1.Browse_1.value:=nCounter)  SEPARATOR 
				
			BUTTON BUSCAR 		;
				CAPTION '&Pesquisa' 	;
				PICTURE 'buscar'	;
				ACTION Buscarcto()

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION ( Nuevo := .T. , Nuevocto() )

			BUTTON IMPRIMIR 	;
				CAPTION '&Imprimir'	;
				PICTURE 'imprimir2' ;
				ACTION Imprimircto() 

			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'cerrar' ;
            ACTION cto_1.release
            
		END TOOLBAR

            @ 56,10 grid Browse_1				;
		        	     WIDTH 280 				;
                    HEIGHT 230                            ; 
			           HEADERS { 'RA. Aluno' , 'Aluno'}	;
		        	     WIDTHS { 90, 200 }			;
                    ON CHANGE Actualizarcto() ;
			           ON DBLCLICK ( Activarcto() , Desactivcto() )
		
                     @ 70,300 LABEL L_ra;
                              VALUE 'R.A';
						          	WIDTH 40           ;
                              HEIGHT 30           

                     @ 100,300 LABEL L_dto;
                              VALUE 'Dt.obs';
                              WIDTH 100           ;
                              HEIGHT 30           
                                                        
                     @ 130,300 LABEL L_obsm;
                              VALUE 'Observações';
                              WIDTH 300           ;
                              HEIGHT 30 

           			   @ 70,340 COMBOBOX T_RAobs;
   	   		               ITEMSOURCE alu->ra_aluno+"|"+alu->nome_alu ;	
					  		         VALUESOURCE alu->ra_aluno;
  							         WIDTH 210 HEIGHT 120
							        
                     DEFINE DATEPICKER D_dtobs
                            ROW 100
                            COL 380
                            WIDTH 120
                            HEIGHT 24
                            SHOWNONE .T. // .F. COM .T., ACEITA-SE DATA EM BRANCO ... 
                            DATEFORMAT ""
                     END DATEPICKER 

                     @ 150,300 EDITBOX T_obsalu ;
                               WIDTH 400 ;
                               HEIGHT 110
                              
                     @ 320,010 FRAME F_obs ;
                               CAPTION  " Observações" ;
							          WIDTH 500 ;
							          HEIGHT 190 ;
							          FONT 'ARIAL' SIZE 12   

                     @ 340,010 GRID G_obsealu ;
                 	            WIDTH 700 ;
		              	         HEIGHT 150 ;
			                     HEADERS { 'Data', 'Observações','Controle'} ;
			                     WIDTHS {100,520,100} ;
										TOOLTIP "Para Corrigir Lançamento Clik no Mesmo" ;			
                	            BACKCOLOR YELLOW    ;
			                     FONTCOLOR BLUE      ;
			                     ON DBLCLICK ALTERA_G_O()
																  																		 									        
                     @ 290,350 BUTTON Btn_Scto Of cto_1        ;
                              CAPTION '&Salvar'             ;
                              ACTION Aceptarcto() ;
                              WIDTH 100 HEIGHT 27         ;
                              FONT "Arial" SIZE 09          ;
                              TOOLTIP "Salvar Registro" ;
                            FLAT

                     @ 290,510 BUTTON Btn_Ccto Of cto_1        ;
                              CAPTION '&Cancelar'		;
                              ACTION Cancelarcto() ;
		                        WIDTH 100 HEIGHT 27		;
                              FONT "Arial" SIZE 09		;
                              TOOLTIP "Cancelar Operação"	;
			                   FLAT
							   
	END WINDOW

   cto_1.Browse_1.SetFocus
		
	cto_1.CENTER 

	cto_1.ACTIVATE  

RETURN
*------------------------------------------------------------------------------*
PROCEDURE Cria_aluno()
*------------------------------------------------------------------------------*
LOCAL nCounter:= 0
DELETE ITEM ALL FROM Browse_1 OF cto_1
alu->(dbgotop())
do while alu->(!eof()) 
   nCounter++
   ADD ITEM { alu->ra_aluno,alu->nome_alu} TO Browse_1 OF cto_1 
   alu->(dbskip())
enddo
cto_1.Browse_1.value:=1  
cto_1.Browse_1.SetFocus
return
*------------------------------------------------------------------------------*
PROCEDURE Desactivcto
*------------------------------------------------------------------------------*
        cto_1.Browse_1.Enabled:= .T.
        cto_1.T_RAobs.Enabled:=.F.
	     cto_1.D_dtobs.Enabled:=.F.
	     cto_1.T_obsalu.Enabled:=.F.
        cto_1.Btn_Ccto.Enabled:= .F.
	     cto_1.Btn_Scto.Enabled:= .F.

        cto_1.ToolBar_1.Enabled:= .T.

        cto_1.Browse_1.SetFocus

RETURN
*------------------------------------------------------------------------------*
PROCEDURE Activarcto()
*------------------------------------------------------------------------------*

        cto_1.Browse_1.Enabled:= .F.
	     cto_1.ToolBar_1.Enabled:= .F.
        cto_1.T_RAobs.Enabled:=nuevo
	     cto_1.D_dtobs.Enabled:=.t.
	     cto_1.T_obsalu.Enabled:=.t.
		  cto_1.Btn_Ccto.Enabled:= .T.
     	  cto_1.Btn_Scto.Enabled:= .T.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE Cancelarcto()
*------------------------------------------------------------------------------*

	Desactivcto()

	Actualizarcto()

	cto->(dbunlock())

	Nuevo := .F.

RETURN
*------------------------------------------------------------------------------*
PROCEDURE Aceptarcto()
*------------------------------------------------------------------------------*

	Desactivcto()
		
	If Nuevo == .T.
	    cto->(DbAppend())
		Nuevo := .F.
    ENDIF		
																	  
    cto->RA_OBS   := cto_1.T_RAobs.value 
    cto->OBS_ALU  := cto_1.T_obsalu.value      
    cto->DT_OBS   := cto_1.D_dtobs.value

   cto_1.Browse_1.Refresh

	If Nuevo == .T.
       cto_1.Browse_1.Value := cto->(RecNo())
	EndIf

	cto->(dbunlock())
	Atualiza_G_O(cto_1.T_RAobs.value)
RETURN

*------------------------------------------------------------------------------*
PROCEDURE Actualizarcto()
*------------------------------------------------------------------------------*
local P_posicao:=""
P_posicao:=PegaValorDaColuna( "Browse_1" , "cto_1" , 1 )
cto->(dbseek(P_posicao))
cto_1.T_RAobs.value:=if(alu->(DbSeek(cto->RA_OBS)),alu->(recno()),0)   
cto_1.T_obsalu.value:=cto->OBS_ALU  
cto_1.D_dtobs.value:=cto->DT_OBS
Atualiza_G_O(cto->RA_OBS)
Return

*------------------------------------------------------------------------------*
Procedure Buscarcto
*------------------------------------------------------------------------------*
Local Buscar
Local nOption:=0                                

  nOption:=MsgOptions(,,"Users.Bmp" , {"&Ra.Aluno","&Data"}, 1, 20 )
  
  if nOption = 1
     cto->(dbsetorder(1))
	  Buscar := Upper ( AllTrim ( InputBox( 'Informe Ra. ' , 'Pesquisa' ) ) )
	  BUSCAR := VAL(BUSCAR)
     If cto->(DbSeek(STR(buscar,6,2)))
	     cto_1.Browse_1.Value := cto->(RecNo())
	  Else
        MsgExclamation('Nao encontrado registro')
	  EndIf
  elseIF nOPTION=2
     cto->(dbsetorder(2))
     Buscar:=ctod("")
     Buscar := Upper ( AllTrim ( InputBox( 'Informe Data ' , 'Pesquisa' ) ) )
     If cto->(DbSeek(dtos(buscar)))
			cto_1.Browse_1.Value := cto->(RecNo())
		Else
         MsgExclamation('Nao encontrado registro')
		EndIf
  endif 			  
  cto->(dbsetorder(1))
Return


*------------------------------------------------------------------------------*
PROCEDURE Nuevocto()
*------------------------------------------------------------------------------*
    cto_1.T_RAobs.value:=0   
    cto_1.D_dtobs.value:=ctod("")  
    cto_1.T_obsalu.value:=""    

    Activarcto()

RETURN

*------------------------------------------------------------------------------*
Procedure Eliminarcto
*------------------------------------------------------------------------------*

	If MsgYesNo ('Confirma Exclusão?','ATENÇÃO')

		If cto->(TREG())
			cto->(dbdelete())
			cto->(dbgotop()) 
			cto->(DBUNLOCK())
         cto_1.Browse_1.Value := cto->(RecNo())
			Actualizarcto()
		EndIf
	EndIf

Return
*------------------------------------------------------------------------------*
Procedure Imprimircto()
*------------------------------------------------------------------------------*
Local Reccto

	Reccto := cto->(RecNo())
	
	DO REPORT								;
		TITLE 'Controle de Observações dos Alunos'						;
                HEADERS  {'',''} , {'RA Aluno','Dt.Medico'};
                FIELDS   {'cto->ra_obs','cto->DT_OBS'};
		WIDTHS   {10,20} 						;
		TOTALS   {.F.,.F.}					;
		WORKAREA cto		;
		LPP 50								;
		CPL 80								;
		LMARGIN 5							;
		PREVIEW							
	
	cto->(DbGoTo(Reccto))
	
Return

*------------------------------------------------------------------------------*
PROCEDURE Atualiza_G_O(x_Aluno)
*------------------------------------------------------------------------------*
   DELETE ITEM ALL FROM G_obsealu OF cto_1
   cto->(dbseek(x_Aluno))
   do while cto->(!eof()) .AND. cto->RA_OBS == x_Aluno
	   ADD ITEM { dtoc(cto->DT_OBS),cto->OBS_ALU,str(cto->(recno()),10)} TO G_obsealu OF cto_1 
      cto->(dbskip())
   enddo
Return

*------------------------------------------------------------------------------*
PROCEDURE ALTERA_G_O()
*------------------------------------------------------------------------------*
local NOPTION:=0
local P_posicao:=0
local r_ra:=0

P_posicao:=VAL(PegaValorDaColuna( "G_obsealu" , "cto_1" , 3 ))

nOption:=MsgOptions("Veja as Opções ?","O que deseja Realizar!","Users.Bmp" , {"&Altera","&Exclui","&Retorna"},1,30,60) 

DO CASE
   CASE NOPTION ==1
        cto->(DBGOTO(P_posicao))
        cto->(TREG())
        Nuevo := .F.
        cto_1.T_obsalu.value:=cto->OBS_ALU  
        cto_1.D_dtobs.value:=cto->DT_OBS
        Activarcto()

   CASE NOPTION ==2
        If MsgYesNo ( "Confirma Exclusão Observação ?","Atenção")
           cto->(DBGOTO(P_posicao))
           r_ra:=cto->RA_OBS
	     	  cto->(TREG())
     		  cto->(DBDELETE())
		     cto->(DBUNLOCK())
  		     Atualiza_G_O(r_ra)
  		     cto_1.G_obsealu.SETFOCUS
  		  ENDIF   
ENDCASE  		  
Return 
