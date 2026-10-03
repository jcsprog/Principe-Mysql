
#include "minigui.ch"

Function USUARIOS(x_prm)

PRM:=x_prm

DO CASE
   CASE PRM=1
        SINFO:="Inclusão"
   CASE PRM=2
        SINFO:="Alteração"
   CASE PRM=3
        SINFO:="Exclusão"
   CASE PRM=4
        SINFO:="Nova Senha"
ENDCASE
	    
	DEFINE WINDOW Usuario_1 ;
		AT 0,0 ;
		WIDTH 640 HEIGHT 450 ;
		TITLE 'Controle Usuarios e Senhas -> '+sinfo ;
		MODAL ;
      FONT 'Arial' SIZE 10 ;
		ON INIT OpenTables(prm) 

      @ 20,010 LABEL Usuario;
              VALUE 'Usuario' ;
              WIDTH 60           ;
              HEIGHT 30           
	                                            
      @ 20,080 TEXTBOX T_USUARIO ;
               OF Usuario_1 ;
               UPPERCASE ;
               WIDTH 300 ;
               MAXLENGTH 30 ;
					on enter GRID_BROWSE_1()  

      @ 50,010 LABEL SENHA;
              VALUE 'Senha' ;
              WIDTH 60           ;
              HEIGHT 30           

      @ 50,220 LABEL NSENHA;
              VALUE 'Nova Senha' ;
              WIDTH 120           ;
              HEIGHT 30           

      @ 50,080 TEXTBOX T_SENHA	;
               OF Usuario_1 ;
               PASSWORD		;                         
               FONT "Arial" SIZE 09	;             
               TOOLTIP "Senha de Acesso";
      		   MAXLENGTH 08	;
			      UPPERCASE		;
			      ON ENTER IF(PRM=1,CriaDadosUsu(),Tela_Usuario())

      @ 50,330 TEXTBOX T_NSENHA	;
               OF Usuario_1 ;
               PASSWORD		;                         
               FONT "Arial" SIZE 09	;             
               TOOLTIP "Nova Senha de Acesso";
      		   MAXLENGTH 08	;
			      UPPERCASE  ;		
			      ON ENTER Grava_NovaSenha()	

     @ 100,010 GRID Browse_1 ;
               WIDTH 610 ;                                                                              
               HEIGHT 250 ;                                                                              
               HEADERS { 'Modulo do Sistema' , 'Incluir' , 'Alterar', 'Excluir', 'Imprimir', 'Controle'} ;
               WIDTHS  { 350,60,60,60,80,80} ;
               ON DBLCLICK ( AltUsu() )

      @ 380,200 BUTTON CLUsu Of Usuario_1 ;
                CAPTION "&Retorna Tela Princial" ;
                ACTION Usuario_1.release ;
                WIDTH 200 HEIGHT 27	;	
			    FLAT

	END WINDOW

	CENTER WINDOW Usuario_1

	ACTIVATE WINDOW Usuario_1

Return Nil

Procedure OpenTables(prm)
Usuario_1.T_SENHA.ENABLED :=.t.
Usuario_1.T_NSENHA.ENABLED:=.F.
Usuario_1.Browse_1.enabled:=.F.
DO CASE
   CASE PRM=2
        Usuario_1.T_SENHA.ENABLED:=.F.
        Usuario_1.Browse_1.enabled:=.T.
   CASE PRM=4
        Usuario_1.T_SENHA.ENABLED:=.F.
        Usuario_1.T_NSENHA.ENABLED:=.T.
ENDCASE	     
Return NIL

*******************
PROCEDURE AltUsu

	DEFINE WINDOW DadosUsuario ;
   	AT 0,0 ;
		WIDTH 350 HEIGHT 250 ;
		TITLE 'Liberação p/ Usuario' ;
		MODAL;
      FONT 'Arial' SIZE 11 ;
		ON INIT ( CpDados())

      @ 20,10 LABEL Modulo;
              VALUE 'Modulo' ;
              WIDTH 60           ;
              HEIGHT 30           
	                                            
      @ 20,080 TEXTBOX T_MODULO ;
               OF DadosUsuario ;
               WIDTH 250 ;
               MAXLENGTH 20   

      DEFINE CHECKBOX T_Incluir
             ROW    50
             COL    10
             WIDTH  100
             HEIGHT 20
             CAPTION "Incluir"
             VALUE   .F.
             TOOLTIP  ""
             ONCHANGE  NIL
             ONGOTFOCUS  NIL
             ONLOSTFOCUS NIL
             FONTBOLD  .F.
             FONTITALIC .F.
             FONTUNDERLINE .F.
             FONTSTRIKEOUT .F.
             BACKCOLOR NIL
             FONTCOLOR NIL
             HELPID  NIL
             TABSTOP .T.
             VISIBLE .T.
             TRANSPARENT .F.
      END CHECKBOX
	
      DEFINE CHECKBOX T_Alterar
             ROW    80
             COL    10
             WIDTH  100
             HEIGHT 20
             CAPTION "Alterar"
             VALUE   .F.
             TOOLTIP  ""
             ONCHANGE  NIL
             ONGOTFOCUS  NIL
             ONLOSTFOCUS NIL
             FONTBOLD  .F.
             FONTITALIC .F.
             FONTUNDERLINE .F.
             FONTSTRIKEOUT .F.
             BACKCOLOR NIL
             FONTCOLOR NIL
             HELPID  NIL
             TABSTOP .T.
             VISIBLE .T.
             TRANSPARENT .F.
      END CHECKBOX

      DEFINE CHECKBOX T_Excluir
             ROW    110
             COL    10
             WIDTH  100
             HEIGHT 20
             CAPTION "Excluir"
             VALUE   .F.
             TOOLTIP  ""
             ONCHANGE  NIL
             ONGOTFOCUS  NIL
             ONLOSTFOCUS NIL
             FONTBOLD  .F.
             FONTITALIC .F.
             FONTUNDERLINE .F.
             FONTSTRIKEOUT .F.
             BACKCOLOR NIL
             FONTCOLOR NIL
             HELPID  NIL
             TABSTOP .T.
             VISIBLE .T.
             TRANSPARENT .F.
      END CHECKBOX

      DEFINE CHECKBOX T_Imprimir
             ROW    140
             COL    10
             WIDTH  100
             HEIGHT 20
             CAPTION "Imprimir"
             VALUE   .F.
             TOOLTIP  ""
             ONCHANGE  NIL
             ONGOTFOCUS  NIL
             ONLOSTFOCUS NIL
             FONTBOLD  .F.
             FONTITALIC .F.
             FONTUNDERLINE .F.
             FONTSTRIKEOUT .F.
             BACKCOLOR NIL
             FONTCOLOR NIL
             HELPID  NIL
             TABSTOP .T.
             VISIBLE .T.
             TRANSPARENT .F.
      END CHECKBOX

      DEFINE CHECKBOX T_Adm
             ROW    140
             COL    120
             WIDTH  100
             HEIGHT 20
             CAPTION "ADM"
             VALUE   .F.
             TOOLTIP  ""
             ONCHANGE  NIL
             ONGOTFOCUS  NIL
             ONLOSTFOCUS NIL
             FONTBOLD  .F.
             FONTITALIC .F.
             FONTUNDERLINE .F.
             FONTSTRIKEOUT .F.
             BACKCOLOR NIL
             FONTCOLOR NIL
             HELPID  NIL
             TABSTOP .T.
             VISIBLE .T.
             TRANSPARENT .F.
      END CHECKBOX
      @ 180,70 BUTTON SalvaUsu Of DadosUsuario	;
                CAPTION '&Salvar'             ;
                ACTION GravaUsuario() ;
                WIDTH 80 HEIGHT 27   ;                                 
                TOOLTIP "Salvar Registro" ;
             FLAT

      @ 180,200 BUTTON CancelaUsu Of DadosUsuario;
                CAPTION '&Cancelar'		;
                ACTION DadosUsuario.release ;
                WIDTH 80 HEIGHT 27		;
                TOOLTIP "Cancelar Operação"	;
			    FLAT

	END WINDOW

	DadosUsuario.CENTER 
   
	DadosUsuario.ACTIVATE 

RETURN NIL

PROCEDURE CpDados
FNT:=PegaValorDaColuna( "Browse_1" , "USUARIO_1" , 6 )
JCS->(DBGOTO(VAL(FNT)))
IF JCS->(TREG())
   DadosUsuario.T_Modulo.VALUE := JCS->DESCU
   DadosUsuario.T_Incluir.VALUE:= JCS->INCLU
   DadosUsuario.T_ALTERAR.VALUE:= JCS->ALTEU
   DadosUsuario.T_EXCLUIR.VALUE:= JCS->EXCLU
   DadosUsuario.T_IMPRIMIR.VALUE:=JCS->IMPRU
   DadosUsuario.T_Modulo.ENABLED:=.F.
ENDIF   
RETURN NIL

PROCEDURE GravaUsuario
JCS->INCLU:=DadosUsuario.T_Incluir.VALUE
JCS->ALTEU:=DadosUsuario.T_ALTERAR.VALUE
JCS->EXCLU:=DadosUsuario.T_EXCLUIR.VALUE 
JCS->IMPRU:=DadosUsuario.T_IMPRIMIR.VALUE
JCS->ADM  :=0
JCS->(DBUNLOCK())
GRID_BROWSE_1()
DadosUsuario.release
RETURN NIL

FUNCTION Tela_Usuario

       LOCAL CTRSENHA:=0, gg:=0       
                                          
       IF JCS->(DBSEEK(UPPER(Usuario_1.T_Usuario.Value)))
          IF !ALLTRIM(JCS->SENHAU) == ALLTRIM(Usuario_1.T_SENHA.Value)
             MsgInfo ("Senha Nao Confere!")
             GG++
             CTRSENHA++
             Usuario_1.T_NSENHA.ENABLED:=.F.
			 ENDIF
          IF !ALLTRIM(JCS->NOMEU) == ALLTRIM(UPPER(Usuario_1.T_Usuario.Value))
             MsgInfo ("Usuario Nao Confere!")
             GG++
             CTRSENHA++
             Usuario_1.T_NSENHA.ENABLED:=.F.
          ENDIF   
          IF GG>3
             MsgInfo ("Sistema CANCELADO !!!!!")
             dbcloseall()
             EXIT PROGRAM 
          ENDIF   
          IF CTRSENHA == 0
             //GRID_BROWSE_1()
             DO CASE
				    CASE PRM=2
				         Usuario_1.Browse_1.ENABLED:=.T.
                     Usuario_1.Browse_1.SETFOCUS
                CASE PRM=3
                     IF JCS->(DBSEEK(UPPER(Usuario_1.T_Usuario.Value)))
                        IF MSGYESNO("Confirma Exclusão de Usuario ?","ATENÇÃO !!!")
                     	   DO WHILE JCS->(!EOF()) .AND. JCS->NOMEU = Usuario_1.T_Usuario.Value 
                     	      IF JCS->(TREG())
                     	         JCS->(DBDELETE())
                       	         JCS->(DBUNLOCK())
                       	      ENDIF  
                        		JCS->(DBSKIP())
                      	   ENDDO
                     	   MSGinfo("Usuario Excluido !","Informação")
                           Usuario_1.release 
                       	ENDIF   
                     ENDIF
                 CASE PRM=4    
//                      MSGINFO("AKI")
                      Usuario_1.T_NSENHA.ENABLED:=.T.
				 ENDCASE      
             Usuario_1.Browse_1.Refresh
          ENDIF   
       ELSE
          gg++
          MsgInfo ("Usuario/Senha Nao Conferem!","Verifique") 
       ENDIF

RETURN NIL

PROCEDURE Grava_NovaSenha
IF JCS->(DBSEEK(UPPER(Usuario_1.T_Usuario.Value)))
   IF MSGYESNO("Confirma Modificação de Senha ?","ATENÇÃO !!!")
	   DO WHILE JCS->(!EOF()) .AND. JCS->NOMEU = Usuario_1.T_Usuario.Value 
	      IF JCS->(TREG())
	         JCS->SENHAU := Usuario_1.T_NSENHA.Value
  	         JCS->(DBUNLOCK())
 	      ENDIF
   		JCS->(DBSKIP())
 	   ENDDO
 	   MSGinfo("Senha Alterada !","Informação")
      Usuario_1.release 	   
 	ENDIF   
ENDIF
RETURN NIL
	
**************************** 	   
PROCEDURE CriaDadosUsu
****************************
IDC->(DBGOTOP())
DO WHILE IDC->(!EOF())
   JCS->(DBAPPEND())
   JCS->DESCU :=IDC->NBASE 
   JCS->COD   :=IDC->COD
   JCS->SENHAU:=Usuario_1.T_SENHA.Value
   JCS->NOMEU :=Usuario_1.T_Usuario.Value
   JCS->INCLU :=.F.
   JCS->ALTEU :=.F.
   JCS->EXCLU :=.F.
   JCS->IMPRU :=.F.
	JCS->(DBUNLOCK())
	IDC->(DBSKIP())
ENDDO
MSGinfo("Informe Liberações ","Usuario Criado Com Exito!")
Usuario_1.Browse_1.enabled:=.T.
GRID_BROWSE_1()
RETURN NIL	

******************************************
PROCEDURE GRID_BROWSE_1
******************************************
DELETE ITEM ALL FROM BROWSE_1 OF Usuario_1
IF JCS->(DBSEEK(UPPER(Usuario_1.T_Usuario.Value)))
   DO WHILE JCS->(!EOF()) .AND. JCS->NOMEU = Usuario_1.T_Usuario.Value 
      ADD ITEM { JCS->DESCU,IF(JCS->INCLU=.T.,"Sim","Não"),IF(JCS->ALTEU=.T.,"Sim","Não"),if(JCS->EXCLU=.T.,"Sim","Não"),if(JCS->IMPRU=.T.,"Sim","Não"),STR(JCS->(RECNO()),10)} TO BROWSE_1 OF USUARIO_1           
      JCS->(DBSKIP())
	ENDDO   
ENDIF	
RETURN NIL
