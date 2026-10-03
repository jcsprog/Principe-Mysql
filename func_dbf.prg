#Include "minigui.ch"
#include "winprint.ch"

FUNCTION clientes

   Public Nuevo := .F.

      	    
	DEFINE WINDOW clien_2;
	           AT 0,0 ;
 				  WIDTH 1000;
              HEIGHT 430;
	           TITLE 'Cadastro de Funcionários'     	;
				  ICON "TUTOR";
      		  CHILD ;
     		     ON MAXIMIZE ThisWindow.Center ;
		        ON INIT ( DesactivarEdicion(),Actualizar()) 

		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER

			BUTTON PRIMERO 		;
				CAPTION '&Primero' 	;
				PICTURE 'primero'	;
				ACTION ( CLI->(dBGoTop()) , Clien_2.Browse_1.Value := CLI->(RecNo()) ) 

			BUTTON ANTERIOR 	;
				CAPTION '&Anterior' 	;
				PICTURE 'anterior'	;
				ACTION ( CLI->(dBSkip ( -1 )) , Clien_2.Browse_1.Value := CLI->(RecNo()) ) 

			BUTTON SIGUIENTE	;
				CAPTION '&Proximo' 	;
				PICTURE 'siguiente'	;
				ACTION ( CLI->(dBSkip (1)) , if ( Eof() , CLI->(DbGoBottom()) , Nil ) , Clien_2.Browse_1.Value := CLI->(RecNo()) ) 

			BUTTON ULTIMO 		;
				CAPTION '&Ultimo' 	;
				PICTURE 'ultimo'	;
				ACTION ( CLI->(dBGoBottom () ), Clien_2.Browse_1.Value := CLI->(RecNo()) )  SEPARATOR 

			BUTTON BUSCAR 		;
				CAPTION '&Pesquisa' 	;
				PICTURE 'buscar'	;
				ACTION BuscarCLI()

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION ( Nuevo := .T., Nuevo(), NIL )

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;
				ACTION If ( CLI->(TREG() ) , ActivarEdicion() , Nil )

			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION Eliminar() 

			BUTTON IMPRIMIR 	;
				CAPTION '&Imprimir'	;
				PICTURE 'imprimir2' ;
            ACTION Imprimir() 

			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'cerrar' ;
            ACTION Clien_2.release 

		END TOOLBAR

                @ 56,10 BROWSE Browse_1				;
			            WIDTH 210  				;
                     HEIGHT 330                              ; 
			            HEADERS { 'Fantasia' ,'Telefone', 'Nome' }	;
			            WIDTHS { 190,190,300 }			;
			            WORKAREA cli			;
                     FIELDS { 'Cli->Fanta','CLI->TEL','Cli->descr' } ;
			            ON CHANGE Actualizar() ;
			            ON DBLCLICK ( ActivarEdicion() , If ( ! CLI->(TREG()) , DesactivarEdicion() , Nil ) )
 
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
                            OF Clien_2 ;
		                      WIDTH 250			;
                            TOOLTIP 'Nome Fantasia' ;
                            MAXLENGTH 20 ;
                            UPPERCASE         ;
                            ON ENTER ( Checa_Cli(clien_2.T_Fanta.Value) )
           
                    @100,310 TEXTBOX T_CGC  ;
                            OF Clien_2 ;
                            WIDTH 150 ;
                            TOOLTIP 'Informe Nº CPF'; 
                            MAXLENGTH 20   ;
                            on lostfocus IF(empty(Clien_2.T_CGC.Value),(Msginfo("Campo Obrigatorio Não Pode estar em Branco","ATENÇÃO"),Clien_2.T_CGC.Setfocus),.f.)
                            ON ENTER clien_2.T_Descr.SetFocus
	                     			
 		              @130,310 TEXTBOX T_Descr ;
                            OF Clien_2     ;
                            WIDTH 370       ;
                            MAXLENGTH 40   ;
                            ON ENTER clien_2.T_End.SetFocus
	         
                    @160,310 TEXTBOX T_End;
                            OF Clien_2 ;
                            WIDTH 300         ;
                            MAXLENGTH 40      ;
                            ON ENTER clien_2.T_Bairro.SetFocus
                            
	                @190,310 TEXTBOX T_Bairro	;
                            OF Clien_2 ;
		                    WIDTH 200                    ;
                            MAXLENGTH 20       ;
                            ON ENTER clien_2.T_Cidade.SetFocus
                         
                    @190,570 TEXTBOX T_Cidade ;
                            OF Clien_2 ;
                            WIDTH 200           ;
                            MAXLENGTH 15      ;
                            ON ENTER clien_2.T_UF.SetFocus

                    @190,820 TEXTBOX T_UF    ;
                            OF Clien_2 ;
                            WIDTH 45                    ;
                            MAXLENGTH 02       ;
                            ON ENTER clien_2.T_Cep.SetFocus
	                  
					    @220,310 TEXTBOX T_Cep	;
                            INPUTMASK '99999-999';
                            ON ENTER clien_2.T_Pais.SetFocus 
							
	                @220,480 TEXTBOX T_Pais	;
                            OF Clien_2 ;
                            WIDTH 150           ;
                            MAXLENGTH 20        ;
                            ON ENTER clien_2.T_Tel.SetFocus

	                @220,700 TEXTBOX T_TEL	;
                            OF Clien_2 ;
                            WIDTH 150           ;
                            MAXLENGTH 20                            

        		       @250,310 COMBOBOX C_cargo;
   			                ITEMSOURCE crg->descar ;	
					  		       VALUESOURCE crg->codcar;
  							       WIDTH 300 HEIGHT 120         		       

	             @ 280,670 BUTTON Btn_Scli Of clien_2	;
                          CAPTION '&Salvar'             ;
                          ACTION AceptarEdicion() ;
                          WIDTH 120 HEIGHT 27   ;                                 
                          TOOLTIP "Salvar Registro" ;
                          FLAT

	              @ 280,840 BUTTON Btn_Ccli Of clien_2	;
		                     CAPTION '&Cancelar'		;
                           ACTION CancelarEdicion() ;
			                  WIDTH 120 HEIGHT 27		;
                           TOOLTIP "Cancelar Operação"	;
			    FLAT

	END WINDOW

   clien_2.Browse_1.SetFocus
	
	clien_2.CENTER

	clien_2.ACTIVATE 

RETURN

*------------------------------------------------------------------------------*
PROCEDURE DesactivarEdicion
*------------------------------------------------------------------------------*
        
         Clien_2.Browse_1.Enabled:= .T.
         Clien_2.T_Descr.Enabled:=.F.
         Clien_2.T_Fanta.Enabled:=.F.
         Clien_2.T_End.Enabled:=.F.
         Clien_2.T_Tel.Enabled:=.F.
         Clien_2.T_Cep.Enabled:=.F.
         Clien_2.T_Cidade.Enabled:=.F.
         Clien_2.T_Uf.Enabled:=.F.
         Clien_2.T_CGC.Enabled:=.F.
         Clien_2.T_BAIRRO.Enabled:=.F.       
         Clien_2.T_PAIS.Enabled:=.F.
         Clien_2.C_cargo.Enabled:=.F.
         Clien_2.Btn_Ccli.Enabled:= .F.
   	   Clien_2.Btn_Scli.Enabled:= .F.

         Clien_2.ToolBar_1.Enabled:= .T.

         Clien_2.Browse_1.SetFocus
			
RETURN
*------------------------------------------------------------------------------*
PROCEDURE ActivarEdicion
*------------------------------------------------------------------------------*
     
         clien_2.Browse_1.Enabled:= .F.
	      Clien_2.ToolBar_1.Enabled:= .F.
	      Clien_2.T_Descr.Enabled:=.T.
         Clien_2.T_Fanta.Enabled:=Nuevo
         Clien_2.T_End.Enabled:=.T.
         Clien_2.T_Tel.Enabled:=.T.
         Clien_2.T_Cep.Enabled:=.T.
         Clien_2.T_Cidade.Enabled:=.T.
         Clien_2.T_Uf.Enabled:=.T.
         Clien_2.T_CGC.Enabled:=.T.
         Clien_2.T_BAIRRO.Enabled:=.T.       
         Clien_2.T_PAIS.Enabled:=.T.
         Clien_2.C_cargo.Enabled:=.t.
         Clien_2.Btn_Ccli.Enabled:= .T.
    	 Clien_2.Btn_Scli.Enabled:= .T.
   	 
RETURN NIL
*------------------------------------------------------------------------------*
PROCEDURE CancelarEdicion()
*------------------------------------------------------------------------------*

	DesactivarEdicion()

	Actualizar()

	CLI->(DBUNLOCK())

	Nuevo := .F.

RETURN
*------------------------------------------------------------------------------*
PROCEDURE AceptarEdicion()
*------------------------------------------------------------------------------*

	DesactivarEdicion()

	If Nuevo == .T.
		Cli->(DbAppend())
		Nuevo := .F.
	EndIf
           CLI->DESCR  := Clien_2.T_Descr.Value 
           CLI->FANTA  := Clien_2.T_Fanta.Value 
           CLI->END    := Clien_2.T_End.Value 
           CLI->TEL    := Clien_2.T_Tel.Value 
           CLI->CEP    := Clien_2.T_Cep.Value 
           CLI->CIDADE := Clien_2.T_Cidade.Value 
           CLI->UF     := Clien_2.T_Uf.Value 
           CLI->CGC    := Clien_2.T_CGC.Value 
           CLI->PAIS   := Clien_2.T_PAIS.Value 
           CLI->BAIRRO := Clien_2.T_BAIRRO.Value 
           CLI->CARGO  := Clien_2.C_cargo.VALUE

	Clien_2.Browse_1.Refresh

	If Nuevo == .T.
       clien_2.Browse_1.Value := Cli->(RecNo())
	EndIf

	CLI->(DBUNLOCK())

RETURN

*------------------------------------------------------------------------------*
PROCEDURE Actualizar()
*------------------------------------------------------------------------------*
    	
         CLI->(DBGOTO(CLI->(RECNO())))
         Clien_2.T_Descr.Value   := Cli->Descr
         Clien_2.T_Fanta.Value   := cli->fanta
         Clien_2.T_End.Value     := cli->end
         Clien_2.T_Tel.Value     := cli->tel
         Clien_2.T_Cep.Value     := cli->cep
         Clien_2.T_Cidade.Value  := cli->cidade
         Clien_2.T_Uf.Value      := cli->uf
         Clien_2.T_CGC.Value     := cli->cgc
         Clien_2.T_BAIRRO.Value  := cli->bairro       
         Clien_2.T_PAIS.Value    := cli->pais
         Clien_2.C_cargo.VALUE   := if(crg->(dbseek(str(CLI->CARGO,6,2))),crg->(recno()),0)
         	     
Return

      	   
*------------------------------------------------------------------------------*
Procedure BuscarCLI
*------------------------------------------------------------------------------*
Local Buscar                                               
Local nOption:=0 

  nOption:=MsgOptions(,,"Users.Bmp" , {"&Fantasia","&Nome"}, 2, 20 )

  DO CASE
     CASE nOption = 1
          cli->(dbsetorder(1))
          Buscar := Upper ( AllTrim ( InputBox( 'Informe Fantasia' , 'Pesquisa' ) ) )
     CASE nOPTION=2
          cli->(dbsetorder(2))
          Buscar := Upper ( AllTrim ( InputBox( 'Informe Nome' , 'Pesquisa' ) ) )
  ENDCASE 			  
         
  If .Not. Empty(Buscar)
   	SET SOFTSEEK ON
		cli->(DbSeek(Buscar))
      Clien_2.Browse_1.Value := Cli->(RecNo())
		SET SOFTSEEK OFF
	EndIf
Return


*------------------------------------------------------------------------------*
PROCEDURE Nuevo()
*------------------------------------------------------------------------------*
 
	      Clien_2.T_Descr.Value:=""
         Clien_2.T_Fanta.Value:=""
         Clien_2.T_End.Value := ""
         Clien_2.T_Tel.Value := ""
         Clien_2.T_Cep.Value := ""
         Clien_2.T_Cidade.Value := ""
         Clien_2.T_Uf.Value := ""
         Clien_2.T_CGC.Value := ""

         ActivarEdicion()
       
RETURN

*------------------------------------------------------------------------------*
Procedure Eliminar
*------------------------------------------------------------------------------*
	If MsgYesNo ( "Confirma Exclusão de Cliente ?","Atenção")
		If CLI->(TREG())
			Cli->(dbdelete())
			Cli->(dbunlock())
			Cli->(dbgotop()) 
			clien_2.Browse_1.Value := Cli->(RecNo())
			Actualizar()
		EndIf
	EndIf
Return NIL

**************************************
PROCEDURE Imprimir
**************************************
Local Reccli 

	Reccli := cli->(RecNo())
	
	DO REPORT								;
        TITLE 'Cadastro Funcionarios';
                HEADERS  {'','','','',''} , {'Fantasia','Nome','Cidade','Uf','Telefone'};
                FIELDS   {'cli->fanta','cli->descr','CLI->CIDADE','CLI->UF','cli->tel'};
		WIDTHS   {20,30,20,5,20} 						;
		TOTALS   {.F.,.F.,.F.,.F.,.F.}					;
		WORKAREA cli						;
		LPP 50								;
		CPL 80								;
		LMARGIN 5							;
		PREVIEW							
	
	cli->(DbGoTo(Reccli))
Return

Procedure Checa_Cli()
**********************************
* verifica possibilidade de inclusão
**********************************
If cli->(DbSeek(clien_2.T_Fanta.Value))
   Msginfo("Nome Fantasia Já Cadastrado!","Verifique")
   CancelarEdicion()
EndIf   
Return NIL           