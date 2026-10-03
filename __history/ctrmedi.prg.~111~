#Include "minigui.ch"

PROCEDURE CTRMED

	DEFINE WINDOW ctrm_1;
	       AT 0,0 ;
 		   WIDTH 900				;
           HEIGHT 670    ;
	       TITLE 'Controle de Especialistas do Aluno' 	;
		   ICON "TUTOR";
		   CHILD 				;
		   FONT 'ARIAL' SIZE 11;	
		   ON MAXIMIZE ThisWindow.Center ;
		   ON INIT (Cria_aluno_m(),Desactivctrm(),Actualizarctrm())

		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER

			BUTTON PRIMERO 		;
				CAPTION '&Primero' 	;
				PICTURE 'primero'	;
				ACTION If(ctrm_1.Browse_1.value=1,MsgBox("Inicio do Arquivo"),ctrm_1.Browse_1.value:=1)

			BUTTON ANTERIOR 	;
				CAPTION '&Anterior' 	;
				PICTURE 'anterior'	;
				ACTION If(ctrm_1.Browse_1.value>1,ctrm_1.Browse_1.value:=ctrm_1.Browse_1.value-1,MsgInfo("Inicio de Dados")) 

			BUTTON SIGUIENTE	;
				CAPTION '&Proximo' 	;
				PICTURE 'siguiente'	;
				ACTION (ctrm_1.Browse_1.value:=ctrm_1.Browse_1.value+1)
            
			BUTTON ULTIMO 		;
				CAPTION '&Ultimo' 	;
				PICTURE 'ultimo'	;
				ACTION (ctrm_1.Browse_1.value:=nCounter)  SEPARATOR
				
			BUTTON BUSCAR 		;
				CAPTION '&Pesquisa' 	;
				PICTURE 'buscar'	;
				ACTION Buscarctrm()

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION (ctrm_1.nuevo.enabled:=.t.,ctrm_1.editar.enabled:=.f.,Nuevoctrm())

			BUTTON IMPRIMIR 	;
				CAPTION '&Imprimir'	;
				PICTURE 'imprimir2' ;
				ACTION Imprimirctrm() 

			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'cerrar' ;
            ACTION ctrm_1.release
            
		END TOOLBAR

            @ 56,10 grid Browse_1				;
		        	WIDTH 290 				;
                    HEIGHT 230                            ; 
			        HEADERS { 'RA. Aluno' , 'Aluno'}	;
		        	WIDTHS { 90, 200 }			;
			        ON CHANGE Actualizarctrm() ;
			        ON DBLCLICK ( Activarctrm() , If ( !ctrm->(TREG()) , Desactivctrm() , Nil ) )
		
                     @ 70,300 LABEL L_ra;
                              VALUE 'R.A';
						      WIDTH 40           ;
                              HEIGHT 30           

                     @ 70,570 LABEL L_med;
                              VALUE 'Medico';
						      WIDTH 100           ;
                              HEIGHT 30     

                     @ 100,300 LABEL L_dtmed;
                              VALUE 'Dt.Médico';
                              WIDTH 100           ;
                              HEIGHT 30           
                                                        
                     @ 130,300 LABEL L_des;
                              VALUE 'Descrição';
                              WIDTH 100           ;
                              HEIGHT 30 

                     @ 160,300 LABEL L_obsm;
                              VALUE 'Obs. Medicas';
                              WIDTH 110           ;
                              HEIGHT 30 

                     @ 260,300 LABEL L_dtmrt;
                              VALUE 'Dt.Retorno';
                              WIDTH 100           ;
                              HEIGHT 30

                     @ 290,300 LABEL L_obsrt;
                              VALUE 'Obs.Retorno';
                              WIDTH 110           ;
                              HEIGHT 30
																				                              
           			  @ 70,340 COMBOBOX T_RACTR;
   	   		              ITEMSOURCE alu->ra_aluno+"|"+alu->nome_alu ;	
					  		        VALUESOURCE alu->ra_aluno;
  							        WIDTH 210 HEIGHT 120
  							        
         			  @ 70,620 COMBOBOX T_codmed;
   	   		              ITEMSOURCE tbm->desmed ;	
					  		        VALUESOURCE tbm->codmed;
  							        WIDTH 200 HEIGHT 120
										 							 
                    DEFINE DATEPICKER D_dtmed
                           ROW 100
                           COL 380
                           WIDTH 120
                           HEIGHT 24
                           SHOWNONE .T. // .F. COM .T., ACEITA-SE DATA EM BRANCO ... 
                           DATEFORMAT ""
                    END DATEPICKER 
						  
						  @ 130,370 TEXTBOX T_DESCM;
                              OF ctrm_1 ;
		                        WIDTH 300			;
                              MAXLENGTH 30 ;
                              UPPERCASE         

                    @ 160,400 EDITBOX T_obsmed ;
                              WIDTH 400 ;
                              HEIGHT 90
                              
                    DEFINE DATEPICKER D_dtret
						         ROW 260
                           COL 380
                           WIDTH 120
                           HEIGHT 24
                           SHOWNONE .T. // .F. COM .T., ACEITA-SE DATA EM BRANCO ... 
                           DATEFORMAT ""
                    END DATEPICKER 

						  @ 290,400 EDITBOX T_obsret;
                              OF ctrm_1 ;
		                        WIDTH 400			;
                              HEIGHT 90 
                              
                    @ 420,10 FRAME F_Med ;
                             CAPTION  " Controle Médico" ;
			       				  WIDTH 500 ;
					      		  HEIGHT 190 ;
							        FONT 'ARIAL' SIZE 14   

                    @ 450,10 GRID G_ctrmedico ;
                 	           WIDTH 730 ;
		              	        HEIGHT 160 ;
			                    HEADERS { 'Medico', 'Dt.Exame','Descrição','Obs.Medicas','Dt.Ret.','Obs.Retorno','Cod.Med'} ;
			                    WIDTHS {100,90,150,150,100,130,100} ;	
									  TOOLTIP "Para Corrigir Lançamento Clik no Mesmo" ;			
                	           BACKCOLOR YELLOW    ;
			                    FONTCOLOR BLUE      ;
									  ON DBLCLICK ALTERA_G_m()                        
																  																		 									        
                    @ 390,380 BUTTON Btn_Sctrm Of ctrm_1        ;
                              CAPTION '&Salvar'             ;
                              ACTION Aceptarctrm() ;
                              WIDTH 100 HEIGHT 27         ;
                              FONT "Arial" SIZE 09          ;
                              TOOLTIP "Salvar Registro" ;
                            FLAT

                    @ 390,540 BUTTON Btn_Cctrm Of ctrm_1        ;
                              CAPTION '&Cancelar'		;
                              ACTION Cancelarctrm() ;
		                      WIDTH 100 HEIGHT 27		;
                              FONT "Arial" SIZE 09		;
                              TOOLTIP "Cancelar Operação"	;
			                FLAT

	END WINDOW

   ctrm_1.Browse_1.SetFocus
		
	ctrm_1.CENTER 

	ctrm_1.ACTIVATE  

RETURN
*------------------------------------------------------------------------------*
PROCEDURE Cria_aluno_m()
*------------------------------------------------------------------------------*
Local oRow
Local i
Local oQuery
LOCAL nCounter:= 0

DELETE ITEM ALL FROM Browse_1 Of ctrm_1

oQuery := oServer:Query( "Select ra_aluno,nome_alu From escola.cad_alu ORDER BY nome_alu" )
 
For i := 1 To oQuery:LastRec()
    nCounter++
    oRow := oQuery:GetRow(i)
    ADD ITEM { oRow:fieldGet(1), oRow:fieldGet(2)} TO Browse_1 Of ctrm_1
    oQuery:Skip(1)
Next
oQuery:Destroy()
ctrm_1.Browse_1.value:=1  
ctrm_1.Browse_1.SetFocus  
return

*------------------------------------------------------------------------------*
PROCEDURE Desactivctrm
*------------------------------------------------------------------------------*
        ctrm_1.Browse_1.Enabled:= .T.
        ctrm_1.T_RACTR.Enabled:=.F.
	     ctrm_1.D_dtmed.Enabled:=.F.
	     ctrm_1.T_DESCM.Enabled:=.F.
	     ctrm_1.T_obsmed.Enabled:=.F.	
		  ctrm_1.D_dtret.Enabled:=.F.
		  ctrm_1.T_obsret.Enabled:=.F.
		  ctrm_1.T_codmed.Enabled:=.F.	     
        ctrm_1.Btn_Cctrm.Enabled:= .F.
	     ctrm_1.Btn_Sctrm.Enabled:= .F.

        ctrm_1.ToolBar_1.Enabled:= .T.

        ctrm_1.Browse_1.SetFocus

RETURN
*------------------------------------------------------------------------------*
PROCEDURE Activarctrm()
*------------------------------------------------------------------------------*

        ctrm_1.Browse_1.Enabled:= .F.
	     ctrm_1.ToolBar_1.Enabled:= .F.
	     ctrm_1.T_RACTR.Enabled:=nuevo
	     ctrm_1.D_dtmed.Enabled:=.t.
	     ctrm_1.T_DESCM.Enabled:=.t.
	     ctrm_1.T_obsmed.Enabled:=.t.	
		  ctrm_1.D_dtret.Enabled:=.t.
		  ctrm_1.T_obsret.Enabled:=.t.
		  ctrm_1.T_codmed.Enabled:=.t.		     
        ctrm_1.Btn_Cctrm.Enabled:= .T.
     	  ctrm_1.Btn_Sctrm.Enabled:= .T.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE Cancelarctrm()
*------------------------------------------------------------------------------*

	Desactivctrm()

	Actualizarctrm()

	Nuevo := .F.

RETURN
*------------------------------------------------------------------------------*
PROCEDURE Aceptarctrm()
*------------------------------------------------------------------------------*
LOCAL oQueryUp
LOCAL c_codigo:=ctrm_1.T_RACTR.value

If ctrm_1.nuevo.enabled == .T.
   cQuery:="INSERT INTO escola.ctrmed (RA_MED,DTENCAM,DESCENCA,OBSMED,RETFAM,OBSFAM,CODMED)"
   cQuery+=" values ('"+ctrm_1.T_RACTR.value+"','"+ctrm_1.D_dtmed.value
   cQuery+="','"+ctrm_1.T_DESCM.value+"','"+ctrm_1.T_obsmed.value
   cQuery+="','"+ctrm_1.D_dtret.value+"','"+ctrm_1.T_codmed.value+"')"	
   oQueryUp:=oServer:Query(cQuery)
Elseif ctrm_1.nuevo.enabled == .F.
   cQuery:="UPDATE escola.ctrmed SET DTENCAM='"+ctrm_1.D_dtmed.value
   cQuery+="',DESCENCA='"+ctrm_1.T_DESCM.value
	cQuery+="',OBSMED='"+ctrm_1.T_obsmed.value
   cQuery+="',RETFAM='"+ctrm_1.D_dtret.value
	cQuery+=+"',OBSFAM='"+ctrm_1.T_codmed.value
   cQuery+="' where RA_MED='"+c_codigo+"'"
   oQueryUp:=oServer:Query(cQuery)
EndIf                   

Atualiza_G_M(ctrm_1.T_RACTR.value)
	
RETURN

*------------------------------------------------------------------------------*
PROCEDURE Actualizarctrm()
*------------------------------------------------------------------------------*
local P_posicao:=""
P_posicao:=PegaValorDaColuna( "Browse_1" , "ctrm_1" , 1 )
CTRM->(dbseek(P_posicao))
ctrm_1.T_RACTR.value:=if(alu->(DbSeek(ctrm->ra_med)),alu->(recno()),0)   
ctrm_1.D_dtmed.value:=CTRM->DTENCAM  
ctrm_1.T_DESCM.value:=CTRM->DESCENCA 
ctrm_1.T_obsmed.value:=CTRM->OBSMED    
ctrm_1.D_dtret.value:=CTRM->RETFAM    
ctrm_1.T_obsret.value:=CTRM->OBSFAM 
ctrm_1.T_codmed.value:=CTRM->CODMED  
Atualiza_G_M(ctrm->ra_med)       
Return

*------------------------------------------------------------------------------*
Procedure Buscarctrm
*------------------------------------------------------------------------------*
Local Buscar
Local nOption:=0                                

  nOption:=MsgOptions(,,"Users.Bmp" , {"&Ra.Aluno","&Descrição"}, 1, 20 )
  
  if nOption = 1
     ctrm->(dbsetorder(1))
	  Buscar := Upper ( AllTrim ( InputBox( 'Informe Ra. ' , 'Pesquisa' ) ) )
	  BUSCAR := VAL(BUSCAR)
     If ctrm->(DbSeek(STR(buscar,6,2)))
	     ctrm_1.Browse_1.Value := ctrm->(RecNo())
	  Else
        MsgExclamation('Nao encontrado registro')
	  EndIf
  elseIF nOPTION=2
     ctrm->(dbsetorder(2))
     Buscar := Upper ( AllTrim ( InputBox( 'Informe Descrição ' , 'Pesquisa' ) ) )
     If ctrm->(DbSeek(buscar))
			ctrm_1.Browse_1.Value := ctrm->(RecNo())
		Else
         MsgExclamation('Nao encontrado registro')
		EndIf
  endif 			  

Return


*------------------------------------------------------------------------------*
PROCEDURE Nuevoctrm()
*------------------------------------------------------------------------------*
    ctrm_1.T_RACTR.value:=0   
    ctrm_1.D_dtmed.value:=ctod("")  
    ctrm_1.T_DESCM.value:=space(30) 
    ctrm_1.T_obsmed.value:=""    
    ctrm_1.D_dtret.value:=ctod("")    
    ctrm_1.T_obsret.value:="" 
    ctrm_1.T_codmed.value :=0 
    Activarctrm()

RETURN

*------------------------------------------------------------------------------*
Procedure Eliminarctrm
*------------------------------------------------------------------------------*

	If MsgYesNo ('Confirma Exclusão?','ATENÇÃO')

		If ctrm->(TREG())
			ctrm->(dbdelete())
			ctrm->(dbgotop()) 
			ctrm->(DBUNLOCK())
         ctrm_1.Browse_1.Value := ctrm->(RecNo())
			Actualizarctrm()
		EndIf
	EndIf

Return
*------------------------------------------------------------------------------*
Procedure Imprimirctrm()
*------------------------------------------------------------------------------*
Local Recctrm

	Recctrm := ctrm->(RecNo())
	
	DO REPORT								;
		TITLE 'Controle de Especialistas dos Alunos'						;
                HEADERS  {'',''} , {'RA Aluno','Dt.Medico'};
                FIELDS   {'CTRM->RA_MED','CTRM->DTENCAM'};
		WIDTHS   {10,20} 						;
		TOTALS   {.F.,.F.}					;
		WORKAREA ctrm		;
		LPP 50								;
		CPL 80								;
		LMARGIN 5							;
		PREVIEW							
	
	ctrm->(DbGoTo(Recctrm))
	
Return  

*------------------------------------------------------------------------------*
PROCEDURE Atualiza_G_M(x_Aluno)
*------------------------------------------------------------------------------*
Local oRow
Local i
Local oQuery
LOCAL nCounter:= 0

DELETE ITEM ALL FROM G_ctrmedico OF ctrm_1

oQuery:=oServer:Query("Select tab_med.desmed,ctrmed.DTENCAM,ctrmed.DESCENCA,ctrmed.OBSMED,ctrmed.RETFAM,ctrmed.OBSFAM"
                oQuery+=" From escola.ctrmed INNER JOIN tab_med ON ctrmed.codmed = tab_med.codmed"
					 oQuery+=" where ctrmed.ra_med ='"+x_Aluno+"'")
                
For i := 1 To oQuery:LastRec()
    nCounter++
    oRow := oQuery:GetRow(i)
    ADD ITEM { oRow:fieldGet(1),dtoc(oRow:fieldGet(2)),oRow:fieldGet(3),oRow:fieldGet(4),dtoc(oRow:fieldGet(5),oRow:fieldGet(6),oRow:fieldGet(7)} TO G_ctrmedico Of ctrm_1
    oQuery:Skip(1)
Next
oQuery:Destroy()
Return

*------------------------------------------------------------------------------*
PROCEDURE ALTERA_G_M()
*------------------------------------------------------------------------------*
local NOPTION:=0
local r_ra:=ctrm_1.T_RACTR.value
local cQuery

nOption:=MsgOptions("Veja as Opções ?","O que deseja Realizar!","Users.Bmp" , {"&Altera","&Exclui","&Retorna"},1,30,60) 

DO CASE
   CASE NOPTION ==1
        ctrm_1.D_dtmed.value:=ctod(PegaValorDaColuna( "G_ctrmedico" , "ctrm_1" , 2 )) 
        ctrm_1.T_DESCM.value:=PegaValorDaColuna( "G_ctrmedico" , "ctrm_1" , 3 ) 
        ctrm_1.T_obsmed.value:=PegaValorDaColuna( "G_ctrmedico" , "ctrm_1" , 4 )    
        ctrm_1.D_dtret.value:(ctodPegaValorDaColuna( "G_ctrmedico" , "ctrm_1" , 5 ))    
        ctrm_1.T_obsret.value:=PegaValorDaColuna( "G_ctrmedico" , "ctrm_1" , 6 ) 
        ctrm_1.T_codmed.value:=PegaValorDaColuna( "G_ctrmedico" , "ctrm_1" , 6 )  

        Activarctrm()
		  
   CASE NOPTION ==2
        If MsgYesNo ( "Confirma Exclusão Da Consulta ?","Atenção")
           cQuery:= oServer:Query( "DELETE FROM escola.ctrmed WHERE CODPRO='"+c_codigo+"'")
           cQuery:Destroy()
        EndIf
ENDCASE

Atualiza_G_M(r_ra)
ctrm_1.G_ctrmedico.SETFOCUS
Return 