#Include "minigui.ch"
#define BM_WIDTH     1
#define BM_HEIGHT    2
******** jcssoft - 
Static lGridFreeze := .t.
Static oActiveX
STATIC oWActiveX

Function Main()

   SET LANGUAGE TO PORTUGUESE      
   Set Navigation Extended 
   SET ShowDetailError ON
   SET BROWSESYNC ON
   SET MULTIPLE OFF WARNING

   Public Nuevo    := .F.
   Public oServer	 := NIL
   PUBLIC oQueryUp := NIL
   PUBLIC nCounter := 0
   	    
	DEFINE WINDOW PROD_2;
	       AT 0,0 ;
 			 WIDTH 700;
          HEIGHT 340 ;
	       TITLE "Produtos"	;
			 ICON "TUTOR";
		    main ;
		    ON INIT ( AbriSql(),Desactivarprod(),Grid_prod())
		    
		DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 FLAT BORDER

			BUTTON PRIMERO 		;
				CAPTION '&Primero' 	;
				PICTURE 'primero'	;
				ACTION If(prod_2.Browse_1.value=1,MsgBox("Inicio do Arquivo"),prod_2.Browse_1.value:=1)

			BUTTON ANTERIOR 	;
				CAPTION '&Anterior' 	;
				PICTURE 'anterior'	;
				ACTION If(prod_2.Browse_1.value>1,prod_2.Browse_1.value:=prod_2.Browse_1.value-1,MsgInfo("Inicio de Dados"))

			BUTTON SIGUIENTE	;
				CAPTION '&Proximo' 	;
				PICTURE 'siguiente'	;
				ACTION (prod_2.Browse_1.value:=prod_2.Browse_1.value+1)

			BUTTON ULTIMO 		;
				CAPTION '&Ultimo' 	;
				PICTURE 'ultimo'	;
				ACTION (prod_2.Browse_1.value:=nCounter)  SEPARATOR 

			BUTTON BUSCAR 		;
				CAPTION '&Pesquisa' 	;
				PICTURE 'buscar'	;
				ACTION BuscarPROD()

			BUTTON Nuevo 		;
				CAPTION '&Novo' 	;
				PICTURE 'nuevo'	;
				ACTION ( Nuevo := .T. , NuevoPROD() )

			BUTTON EDITAR 		;
				CAPTION 'A&lterar' 	;
				PICTURE 'editar'	;
				ACTION ( ActivarPROD() , Nil )

			BUTTON ELIMINAR 	;
				CAPTION 'De&letar'	;
				PICTURE 'borrar'	;
				ACTION EliminarPROD() 
				
/*			BUTTON IMPRIMIR 	;
				CAPTION '&Imprimir'	;
				PICTURE 'imprimir2' ;
				ACTION ImprimirPROD() 
*/
			BUTTON CERRAR 	;
				CAPTION '&Fecha'	;
				PICTURE 'cerrar' ;
            ACTION PROD_2.release 

		END TOOLBAR

               @ 56,10 Grid Browse_1	                ;
                        WIDTH 210  				          ;
                        HEIGHT 210                      ; 
			               HEADERS { 'Codigo','Descrição'} ;
			               WIDTHS { 50, 180 }			;                        
   			            ON CHANGE ActualizaPROD()  ;
   			            ON DBLCLICK ( ActivarPROD() , DesactivarPROD() )

                     @ 70,250 LABEL AF ;
                              VALUE 'Codigo' ;
                              WIDTH 80           ;
                              HEIGHT 30           

                     @100,250 LABEL BF ;
                              VALUE 'Descrição'  ;
                              WIDTH 60           ;
                              HEIGHT 30           

			    	     @ 070,330 TEXTBOX T_CODPEC;
			    	               OF PROD_2 ;
   			                  WIDTH 100 

			    	     @ 100,330 TEXTBOX T_DESPEC;
			    	               OF PROD_2 ;
   			                  WIDTH 200 ;
                              ON ENTER PROD_2.Btn_SPROD.SetFocus

	                 @ 150,310 BUTTON Btn_SPROD Of PROD_2	;
                          CAPTION '&Salvar'             ;
                          ACTION AceptarPROD() ;
                          WIDTH 80 HEIGHT 27   ;                                 
                          TOOLTIP "Salvar Registro" ;
                          FLAT

	                 @ 150,410 BUTTON Btn_CPROD Of PROD_2	;
		                     CAPTION '&Cancelar'		;
                           ACTION CancelarPROD() ;
			                  WIDTH 80 HEIGHT 27		;
                           TOOLTIP "Cancelar Operação"	;
			               FLAT

	END WINDOW

   PROD_2.Browse_1.SetFocus
	
	CENTER WINDOW PROD_2

	ACTIVATE WINDOW PROD_2

RETURN

Procedure AbriSql()
LOCAL cHostName:= "localhost"
LOCAL cUser	   := "root"
LOCAL cPassWord:= "175227"
LOCAL cDataBase:= "Escola"

oServer := TMySQLServer():New(cHostName, cUser, cPassWord )
If oServer:NetErr() 
  MsGInfo("Error de Abertura MySql Server: " + oServer:Error() )
  Release Window ALL
  Quit
Else               	
  MsgInfo("Conecção Estabelecida Banco MySql Server!")
EndIf

oServer:SelectDB( cDatabase )
If oServer:NetErr() 
  MsGInfo("Error Conecção Banco Escola "+cDatabase+": "+oServer:Error() )
  Release Window ALL
  Quit
Else
  MsgInfo("Conecção Estabelecida Banco Escola Tabelas Ativas!")
EndIf
Return Nil                     

*--------------------------------------------------------------*
Function Grid_prod(n_posicao)                     
*--------------------------------------------------------------*
Local oRow
Local i
Local oQuery
LOCAL nCounter:= 0
LOCAL oQueryUp
#define n_posicao 0

DELETE ITEM ALL FROM Browse_1 Of prod_2

oQuery := oServer:Query( "Select CODPEC,DESPEC From cadpecas ORDER BY despec" )
 
For i := 1 To oQuery:LastRec()
    nCounter++
    oRow := oQuery:GetRow(i)
    ADD ITEM { oRow:fieldGet(1), oRow:fieldGet(2)} TO Browse_1 Of prod_2
    oQuery:Skip(1)
Next
oQuery:Destroy()
prod_2.Browse_1.value:=1  
prod_2.Browse_1.SetFocus  
Return NIL

*------------------------------------------------------------------------------*
PROCEDURE DesactivarPROD
*------------------------------------------------------------------------------*
         PROD_2.Browse_1.Enabled:=.T.
         PROD_2.T_CODPEC.Enabled:=.F.
         PROD_2.T_DESPEC.Enabled:=.F.
         PROD_2.Btn_CPROD.Enabled:=.F.
   	   PROD_2.Btn_SPROD.Enabled:=.F.
         PROD_2.ToolBar_1.Enabled:=.T.
         PROD_2.Browse_1.SetFocus
RETURN
*------------------------------------------------------------------------------*
PROCEDURE ActivarPROD
*------------------------------------------------------------------------------*

         PROD_2.Browse_1.Enabled:=.F.
         PROD_2.T_DESPEC.Enabled:=.T.
	      PROD_2.ToolBar_1.Enabled:= .F.
         PROD_2.Btn_CPROD.Enabled:= .T.
      	PROD_2.Btn_SPROD.Enabled:= .T.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE CancelarPROD()
*------------------------------------------------------------------------------*
	DesactivarPROD()
	ActualizaPROD()
	Nuevo := .F.
RETURN
*------------------------------------------------------------------------------*
PROCEDURE AceptarPROD()
*------------------------------------------------------------------------------*
LOCAL oQueryUp
LOCAL c_codigo:=PegaValorDaColuna( "BROWSE_1" , "prod_2" ,1)

If nuevo
   cQuery:="INSERT INTO cadpecas (codpec,despec)"
   cQuery+=" values ('"+PROD_2.T_CODPEC.Value+"','"+PROD_2.T_DESPEC.value+")"
   nuevo:=.f.
Else
   cQuery:="UPDATE cadpecas SET despec='"+PROD_2.T_DESPEC.value+"' where codpec='"+PROD_2.T_CODPEC.Value+"'"
   msginfo("Atualizado com Exito")
   //UPDATE cadpecas SET despec='JOAO CARLOS' where codpec='00006'
   
EndIf
oQueryUp:=oServer:Query(cQuery)

Grid_prod()   
   
prod_2.Browse_1.Refresh

Desactivarprod()
Return

*------------------------------------------------------------------------------*
PROCEDURE ActualizaPROD()
*------------------------------------------------------------------------------*
local cQuery
LOCAL aQteProd
LOCAL c_codigo:=PegaValorDaColuna( "BROWSE_1" , "prod_2" ,1)

cQuery := oServer:Query( "Select * From cadpecas where codpec='"+c_codigo+"'")
aQteProd:=cQuery:LastRec()

If aQteProd > 0
   oRow := cQuery:GetRow(1)
   
   PROD_2.T_CODPEC.VALUE := oRow:fieldGet(1)
	PROD_2.T_DESPEC.VALUE := oRow:fieldGet(2)
endif

Return
       	   
*------------------------------------------------------------------------------*
Procedure BuscarPROD
*------------------------------------------------------------------------------*
Local Buscar
Local nOption:=0 
local cQuery
local oQuery
LOCAL aQteprod
LOCAL aQteryUp

nOption:=MsgOptions(,,"Users.Bmp" , {"&Codigo","&Descrição"}, 2, 20 )

Do CASE
   CASE nOption = 1
        Buscar := Upper ( AllTrim ( InputBox( 'Informe Codigo' , 'Pesquisa' ) ) )
        cQuery := oServer:Query( "Select * From cadpecas where codpec="+buscar)
   CASE nOPTION=2
        Buscar := Upper ( AllTrim ( InputBox( 'Informe Descrição' , 'Pesquisa' ) ) )
        cQuery := oServer:Query( "Select * From cadpecas where despec="+buscar)
EndCase 			  

oQueryUp:=oServer:Query(cQuery)

aQteprod:=oQuery:LastRec()

IF aQteprod > 0
   oRow := oQuery:GetRow(1)

   PROD_2.T_CODPEC.VALUE := oRow:fieldGet(1)
	PROD_2.T_DESPEC.VALUE := oRow:fieldGet(2)

Else
   MsgExclamation('Não Encontrado Registro')
EndIf
   
oQuery:Destroy()
       
Return

*------------------------------------------------------------------------------*
PROCEDURE NuevoPROD()
*------------------------------------------------------------------------------*

PROD_2.T_CODPEC.Value:=REPLIC("0",5-LEN(LTRIM(STR(nCounter+1,5))))+LTRIM(STR(nCounter+1,5))
PROD_2.T_DESPEC.Value:=SPACE(15)
ActivarPROD()

RETURN

*------------------------------------------------------------------------------*
Procedure EliminarPROD
*------------------------------------------------------------------------------*
local cQuery
LOCAL aQteProd
LOCAL c_codigo:=PegaValorDaColuna( "BROWSE_1" , "prod_2" ,1)
If MsgYesNo ( "Confirma Exclusão ?","Atenção")
   cQuery := oServer:Query( "delete From cadpecas where codpec='"+c_codigo+"'")
   aQteProd:commit()
   Grid_prod()
	ActualizaPROD()
EndIf
Return

*--------------------------------------------------------*
FUNCTION ImprimirPROD()
*--------------------------------------------------------*
	CADP->(RecNo())
	
	DO REPORT								;
      title  empresa+'| Cadastro da Familia dos Produtos' ;
      headers  {'',''} , { 'Codigo', 'Descrição do Produto' } ;
      fields   {'cadp->codpec','cadp->despec'}   ;
      widths   {10,60}                                        ;
      totals   {.F.,.F.}                                      ;
      nformats {'',''}                                        ;
      workarea cadp                                                           ;
		LPP 50								;
		CPL 80								;
		LMARGIN 5							;
		PREVIEW							
Return

Function PegaValorDaColuna( xObj, xForm, nCol)
	 Local nPos := GetProperty ( xForm , xObj , 'Value' )
	 Local aRet := GetProperty ( xForm , xObj , 'Item' , nPos )
Return aRet[nCol]	
/*
 * MsgOptions([cText], [cTitle], [cImage], aOptions, [nDefaultOption], [nSeconds])
*/

Function MsgOptions(cText, cTitle, cImage, aOptions, nDefaultOption, nSeconds )
   Local nItem:=0, nBtnWidth:=0, aBtn:=Array(Len(aOptions)), aImgInfo
   Local nBtnPosX:=10, nBtnPosY:=85, cOption:=""

   Default cText           To "SELECIONE UMA OPÇÃO"
   Default cTitle          To "P E S Q U I S A "
   Default cImage          To ""
   Default nDefaultOption  To 1
   Default nSeconds        To 0

   DEFINE FONT _Font_Options FONTNAME "MS Sans Serif" SIZE 12

   //Calcular anchura máxima de un botón para igualarlos todos
   For nItem:=1 To Len(aOptions)
      aOptions[nItem]:=Alltrim(aOptions[nItem])
      nBtnWidth:=Max( GetTextWidth(, aOptions[nItem], GetFontHandle("_Font_Options")), nBtnWidth )
   Next
   nBtnWidth+=5

   DEFINE WINDOW _Options  ;
      AT 0,0               ;
      WIDTH (Len(aOptions)*(10+nBtnWidth))+15 ;
      HEIGHT 155           ;
      TITLE cTitle         ;
      ICON "BUSCAR.ICO"    ;
      MODAL                ;
      NOSIZE               ;
      ON RELEASE IF( IsControlDefined( Timer_1, _Options ), _Options.Timer_1.Release, )

      ON KEY ESCAPE ACTION _Options.Release

      If !Empty(cImage)
         aImgInfo := BmpSize(cImage)
         If !Empty(aImgInfo [BM_WIDTH])
           @ 20, 10 IMAGE _Image PICTURE (cImage) WIDTH aImgInfo [BM_WIDTH] HEIGHT aImgInfo [BM_HEIGHT]
           @ 40, 55 LABEL _Label VALUE cText WIDTH (Len(aOptions)*(10+nBtnWidth))-50 HEIGHT 30 ;
             TRANSPARENT CENTERALIGN FONT "_Font_Options"
         Endif
      Else
           @ 40, 10 LABEL _Label VALUE cText WIDTH (Len(aOptions)*(10+nBtnWidth))-10 HEIGHT 30 ;
             TRANSPARENT CENTERALIGN FONT "_Font_Options"
      Endif

      For nItem:=1 To Len(aOptions)
         aBtn[nItem]:="_Btn_"+Ltrim(Str(nItem))
         cOption:=aBtn[nItem]
         @ nBtnPosY, nBtnPosX BUTTON &cOption CAPTION aOptions[nItem] WIDTH nBtnWidth HEIGHT 25 FONT "_Font_Options" ;
                   ACTION ( cOption:=GetProperty("_Options", This.Name, "Caption"), _Options.Release )
         nBtnPosX+=nBtnWidth+10
      Next

      DoMethod("_Options", aBtn[nDefaultOption], "SetFocus")

      If nSeconds>0
         DEFINE TIMER Timer_1 Interval nSeconds*1000  ;
                ACTION ( cOption:=aOptions[nDefaultOption], _Options.Release )
      Endif

   END WINDOW

   CENTER WINDOW _Options

   ACTIVATE WINDOW _Options

   RELEASE FONT _Font_Options

Return Ascan(aOptions,Alltrim(cOption))

/*
 * MsgLogo(cImage, [nSeconds])
*/

Function MsgLogo( cImage, nSeconds, lRound )

Local aImgInfo:=GetImageSize(cImage), width, height

Default nSeconds To 5, lRound To .F.

   If .Not. IsWindowDefined( _Logo ) .And. .Not. Empty( aImgInfo [BM_WIDTH] )

      width :=aImgInfo [BM_WIDTH]+GetBorderWidth()
      height:=aImgInfo [BM_HEIGHT]+GetBorderHeight()

      DEFINE WINDOW _Logo   ;
         AT 0,0             ;
         WIDTH width        ;
         HEIGHT height      ;
         CHILD TOPMOST      ;
         NOCAPTION          ;
         ON SIZE (_Logo.Width:=width, _Logo.Height:=height) ;
         ON MOUSECLICK _Logo.Release

         @ 0, 0 IMAGE _Image PICTURE (cImage) WIDTH aImgInfo [BM_WIDTH] HEIGHT aImgInfo [BM_HEIGHT]

         DEFINE TIMER Timer_1 INTERVAL nSeconds*1000 ACTION _Logo.Release

      END WINDOW

      If lRound
         SET REGION OF _Logo ROUNDRECT 68,68,width,height
      Endif

      CENTER WINDOW _Logo

      ACTIVATE WINDOW _Logo

   Else
      MsgInfo("No se ha podido llevar a cabo la operación", "Error")
   Endif

Return Nil

*-------------------------------------------------------------
Static Function GetImageSize( cImagePath )
*-------------------------------------------------------------
Local ObjImage, aRetArr:={0,0}

   If FILE( GetStartUpFolder() + '\ximage.dll' )

	objImage := CreateObject( "XStandard.Image" )

	if objImage:Load( cImagePath ) == .T.
		aRetArr[1] := objImage:Width
		aRetArr[2] := objImage:Height
	endif

	objImage := NIL

   Endif

Return aRetArr

*-------------------------------------------------------------
Static Function UnRegXImage()
*-------------------------------------------------------------

	If FILE( GetStartUpFolder() + '\ximage.dll' )
		EXECUTE FILE "regsvr32" PARAMETERS "/u /s XImage.dll" HIDE
	Endif

Return Nil
