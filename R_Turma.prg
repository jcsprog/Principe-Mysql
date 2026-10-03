#include "minigui.ch"
#include "winprint.ch"

PROCEDURE Rlturma

	DEFINE WINDOW rTurma;
	       AT 0,0 ;
 			 WIDTH 340	;
          HEIGHT 170 ;
			 font 'arial' size 11 ;
	       TITLE 'Relatório Turmas';
			 ICON "TUTOR";
			 CHILD ;
		    ON MAXIMIZE ThisWindow.Center 
			 
          @ 10,10 LABEL rTurma ;
                  VALUE 'Turma'    ;
                  WIDTH 80           ;
                  HEIGHT 30 

          @ 30,10 COMBOBOX R_turma;
                  of rTurma ;
   		         ITEMSOURCE prod->DESPRO+"|"+PROD->HINC+" a "+PROD->Hfim ;	
					  	VALUESOURCE prod->CODPRO;
  						WIDTH 300 HEIGHT 120 
  						
          @ 70,20 BUTTON B_turmaC Of rTurma ;
                  CAPTION '&Confirma'             ;
                  ACTION ImpriTurma(rTurma.R_turma.value) ;
                  WIDTH 100 HEIGHT 27         ;
                  FONT "Arial" SIZE 09          ;
                  TOOLTIP "Imprimir Relatório" ;
                FLAT

          @ 70,150 BUTTON BturmaR_Cctrm Of rTurma ;
                  CAPTION '&Cancelar'		;
                  ACTION rTurma.release ;
		            WIDTH 100 HEIGHT 27		;
                  FONT "Arial" SIZE 09		;
                  TOOLTIP "Cancelar Operação"	;
			       FLAT  	
   END WINDOW

   rTurma.R_turma.SetFocus
		
	rTurma.CENTER 

	rTurma.ACTIVATE  
        
Return
*--------------------------------------------
procedure ImpriTurma(xTurma)
*--------------------------------------------
#include "winprint.ch"
Local dirimp:=GetCurrentFolder()

Request HB_CODEPAGE_PT850

if alu->cod_hor # xTurma
   msginfo("Não Encontrada Alunos Está Turma")  
   return nil
endif
						 
TITULOIMP:="Relatório Turmas"
 
INIT PRINTSYS
SELECT BY DIALOG PREVIEW

IF HBPRNERROR>0
   release printsys
   SetCurrentFolder(dirimp)
   return nil
ENDIF

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
//set page orientation DMORIENT_LANDSCAPE papersize DMPAPER_A4 font "ft10"
start doc name TituloImp
start page
   
PAG:=0
LH:=0
select font "ft12"
select pen "p0"
alu->(dbsetorder(4))
alu->(ordScope(0,str(xTurma,6,2)))
alu->(OrdScope(1,str(xTurma,6,2)))
alu->(DbGoTop())

do while alu->(!eof())

   IF LH > 260 .OR. PAG=0
      select font "ft14"
      @ 10,005 SAY EMPRESA TO PRINT
      select font "ft12"
      @ 20,050 SAY 'Turmas :'+if(prod->(dbseek(str(ALU->COD_HOR,6,2))),alltrim(prod->DESPRO)+"|"+PROD->HINC+" a "+PROD->Hfim,"") to print
      LH:=25
      @ LH,010 SAY "R.A                Nome do Aluno" TO PRINT
      LH+=5
		pag++			 
	endif
	
	@ lh,010 say alu->ra_aluno+"   "+alu->nome_alu to print
	lh+=5
	alu->(dbskip())
enddo	
end page
end doc
release printsys
SetCurrentFolder(dirimp)
alu->(ordScope(0,nil))
alu->(ordScope(1,nil))
alu->(dbsetorder(1))	
rTurma.RELEASE
RETURN NIL           
