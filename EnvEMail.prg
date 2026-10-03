ANNOUNCE RDDSYS

#include "minigui.ch"
#include "fileio.ch"
#define IDI_MAIN 1001

#define MsgInfo( c, t ) MsgInfo( c, t, , .f. )
#define MsgStop( c, t ) MsgStop( c, t, , .f. )

DECLARE WINDOW Form_2

*-----------------------------------------------------------------------------*
PROCEDURE Email( Silent, Compress, clog )
*-----------------------------------------------------------------------------*
LOCAL cPath := GetStartUpFolder() + "\", cFileName := cFileNoExt( GetExeFileName() )
LOCAL extraTitle := ''

   PRIVATE cCfgFile := cPath + Lower(cFileName) + ".ini"
   PRIVATE cLogFile := cPath + Lower(cFileName) + ".log"
   PRIVATE aEntry := {}, cCryptKey := REPL( "#$@%&", 2 )
   PRIVATE cDir       := DiskName()+":\"+CurDir()+"\PEDIDOS\"

   DEFAULT Silent to .F., Compress to '', Clog to .F.

   If valtype(Clog) == "C" .and. !empty(clog)
      clog := Lower(clog)
      clog := IF(clog=".t." .or. clog="clog" .or. clog="y" .or. val(clog)>0, .T., .F.)
   Endif

   If File( cLogFile )
      if clog .or. FileSize( cLogFile ) > 1000000
         Ferase( cLogFile )
      endif
   Endif

   aAdd( aEntry, "SMTP" )
   aAdd( aEntry, "From" )
   aAdd( aEntry, "To" )
   aAdd( aEntry, "CC" )
   aAdd( aEntry, "BCC" )
   aAdd( aEntry, "Subject" )
   aAdd( aEntry, "Attachment" )
   aAdd( aEntry, "Message" )
   aAdd( aEntry, "Login" )
   aAdd( aEntry, "LoginMD5" )
   aAdd( aEntry, "User" )
   aAdd( aEntry, "PassWord" )
   aAdd( aEntry, "HTML" )
   aAdd( aEntry, "Silent" )
   aAdd( aEntry, "Compress")

   SELE EMPRESA
   GO TOP
   MontaPedidos()
   set order to 1
   SEEK Pedidos->Cliente
   cDir+=Alltrim(Pedidos->Serie)+(strzero(Pedidos->Numero,7)+".TXT")
   cdRA:={cDir}

   aGet := ARRAY(15)

   DEFAULT aget[1] TO "Servidor EX: smtp.Globo.com"
   DEFAULT aget[2] TO "Seu endereço de Email"
   DEFAULT aget[3] TO "Endereço de Email Destino"
   DEFAULT aget[4] TO SPACE(30)
   DEFAULT aget[5] TO SPACE(30)
   DEFAULT aget[6] TO " "
   DEFAULT aget[7] TO {}
   DEFAULT aget[8] TO " "
   aGet[ 9] := .F.
   aGet[10] := .F.
   DEFAULT aget[11] TO ""
   DEFAULT aget[12] TO ""
   aGet[13] := 1
   DEFAULT aget[14] TO Silent

   If Pcount() >= 2
      Compress := Lower(Compress)
      Compress := STRTRAN(Compress, ".zip", "")
   EndIf

   DEFAULT aget[15] TO Compress

   IF File( cCfgFile )

      BEGIN INI FILE cCfgFile

         For i := 1 To Len(aEntry)
             GET aGet[i] SECTION "Data" ENTRY aEntry[i]
         Next i
         aGet[8]  := STRTRAN( aGet[8], Chr(250), CRLF )
         aGet[12] := CHARXOR( aGet[12], cCryptKey )

      END INI

   ENDIF

   SET CENTURY ON
   SET DATE FRENCH

   If Empty(Compress)
      compress := aget[15]
   Else
      aget[15] := Compress
   Endif

   If valtype(Silent) == "C" .and. !empty(Silent)
      silent := Lower(Silent)
      silent := IF(Silent=".t." .or. Silent="silent" .or. silent="y" .or. val(silent)>0, .T., .F.)
   Endif

   If Silent = .T.
      aget[14] := Silent
      M_Send()
      RETURN
   Else
      aget[14] := Silent
   Endif

   extratitle := " [O arquivo(s) anexado será enviado com o nome "+Compress+".Zip ]"

   SET CONTEXTMENUS OFF

    aget[2]= Alltrim(Empresa->Email)
    aget[3]= Alltrim(Clientes->Email)
    aget[6]= "Pedido Nº "+Alltrim(Pedidos->Serie)+[-]+Str(Pedidos->Numero,6)
    aget[7]= {cDir}
 //  MSGSTOP(CDIR)

   DEFINE WINDOW Form_1 ;
          AT 131,220 ;
          WIDTH 643 ;
          HEIGHT 486 + IF(IsXPThemeActive(), 6, 0) ;
          TITLE "Envio de Email" ;
          ICON IDI_MAIN ;
          MODAL ;
          FONT "MS Sans Serif" SIZE 10 ;
          ON RELEASE SaveData()

          DEFINE CONTEXT MENU
                MENUITEM "Adicionar Arquivo(s) Para Anexo" ACTION File_Attached(.F.,.F.,.T.) NAME ADDFILE
                MENUITEM "Remove lista" ACTION File_Attached(.T.,.T.,.T.) NAME DELFILE DISABLED
          END MENU

          @ 9,7 FRAME Frame_1 WIDTH 620 HEIGHT 50

          @ 15, 20 BUTTONEX PicButton_1 CAPTION "Envia Email" PICTURE "SEND" ACTION m_send() WIDTH 100 HEIGHT 40 SIZE 8 FONTCOLOR {128,0,0} BACKCOLOR {245,240,240} TOOLTIP "Enviar Email"
          @ 15, 121 BUTTONEX PicButton_2 CAPTION "Configuração" PICTURE "CONFIG" ACTION m_config() WIDTH 100 HEIGHT 40 SIZE 8 FONTCOLOR {128,0,0} BACKCOLOR {245,240,240} TOOLTIP "Configuração"
          @ 15,222 BUTTONEX PicButton_3 CAPTION "Limpa Anexo" PICTURE "TRASH" ACTION File_Attached(.T.) WIDTH 100 HEIGHT 40 SIZE 8 FONTCOLOR {128,0,0} BACKCOLOR {245,240,240} TOOLTIP "Limpa lista de Anexos"
          @ 15,342 BUTTONEX PicButton_5 CAPTION "Saida" PICTURE "EXIT" ACTION Form_1.Release WIDTH 100 HEIGHT 40 SIZE 8 FONTCOLOR {128,0,0} BACKCOLOR {245,240,240} TOOLTIP "Saida"

          @ 62,7 FRAME Frame_2 WIDTH 620 HEIGHT 390
          @ 205,15 FRAME Frame_3 WIDTH 115 HEIGHT 55

          @  84,24 LABEL Label_1 VALUE "Serv. SMTP:" WIDTH 100 HEIGHT 20
          @ 108,24 LABEL Label_2 VALUE "De..............:" WIDTH 100 HEIGHT 20
          @ 131,24 LABEL Label_3 VALUE "Para..........:" WIDTH 100 HEIGHT 20
          @ 158,24 LABEL Label_4 VALUE "Cc..............:" WIDTH 100 HEIGHT 20
          @ 158,357 LABEL Label_5 VALUE "Bcc........:" WIDTH 58 HEIGHT 20
          @ 185,24 LABEL Label_6 VALUE "Assunto...:" WIDTH 100 HEIGHT 20
          @ 210,24 LABEL Label_7 VALUE "Anexo" WIDTH 100 HEIGHT 20
          @ 262,24 LABEL Label_8 VALUE "Messagem" WIDTH 100 HEIGHT 20 

          @ 78,135 TEXTBOX Text_1 HEIGHT 23 WIDTH 480 ON CHANGE aget[1] := Form_1.Text_1.Value
          Form_1.Text_1.Value := aget[1]

          @ 104,135 TEXTBOX Text_2 HEIGHT 22 WIDTH 480 ON CHANGE aget[2] := Form_1.Text_2.Value
          Form_1.Text_2.Value := aget[2]

          @ 129,135 TEXTBOX Text_3 HEIGHT 22 WIDTH 480 ON CHANGE aget[3] := Form_1.Text_3.Value
          Form_1.Text_3.Value := aget[3]

          @ 155,135 TEXTBOX Text_4 HEIGHT 22 WIDTH 200 ON CHANGE aget[4] := Form_1.Text_4.Value
          Form_1.Text_4.Value := aget[4]

          @ 155,415 TEXTBOX Text_5 HEIGHT 22 WIDTH 200 ON CHANGE aget[5] := Form_1.Text_5.Value
          Form_1.Text_5.Value := aget[5]

          @ 180,135 TEXTBOX Text_6 HEIGHT 22 WIDTH 480 ON CHANGE aget[6] := Form_1.Text_6.Value
          Form_1.Text_6.Value := aget[6]

          @ 205,135 COMBOBOX Combo_7 ITEMS aget[7] HEIGHT 200 WIDTH 450 ON GOTFOCUS MCONTEXT(.T.) ;
                    ON CHANGE SetFcompress() ON LOSTFOCUS MCONTEXT(.F.)
          Form_1.Combo_7.Value := IF(Len(aget[7]) == 0, 0, 1)

          @ 205,590 BUTTON PicButton_6 PICTURE "OPEN" ACTION File_Attached() ;
                    WIDTH 24 HEIGHT 24 TOOLTIP "Selecione o Arq.(s) para anexo"

   //       @ 234,24 CHECKBOX Check_1 CAPTION "Zipar Arquivo" WIDTH 100 HEIGHT 20 ;
   //                VALUE ( !Empty(Form_1.Combo_7.DisplayValue) .and. !empty(Compress) ) ;
   //                ON CHANGE SetFcompress() 

          @ 286,24 RADIOGROUP Radio_1 OPTIONS { "Texto", "HTML" } VALUE aget[13] ;
                   WIDTH 64 TOOLTIP "Selecione o Formato da Messagem" ;
                   ON CHANGE aget[13] := Form_1.Radio_1.Value 

          @ 232,135 EDITBOX Edit_1 WIDTH 480 HEIGHT 205 ON CHANGE aget[8] := Form_1.Edit_1.Value NOHSCROLL
          Form_1.Edit_1.Value := aget[8]

          ON KEY ALT+S ACTION m_send()
          ON KEY ALT+C ACTION m_config()
          ON KEY ALT+T ACTION File_Attached(.T.)
          ON KEY ALT+X ACTION ReleaseAllWindows()

   END WINDOW

// Form_1.Title := "Envio de Email" + IF(Form_1.Check_1.Value == .T., extratitle, "")

   CENTER WINDOW Form_1

   ACTIVATE WINDOW Form_1

RETURN

*-----------------------------------------------------------------------------*
STATIC FUNCTION MCONTEXT(ACT)
*-----------------------------------------------------------------------------*
DEFAULT ACT TO .T.

IF ACT
   DO EVENTS
   SET CONTEXTMENUS ON
   IF EMPTY(FORM_1.COMBO_7.DISPLAYVALUE)
       DISABLE MENUITEM DELFILE OF FORM_1
   ELSE
       ENABLE MENUITEM DELFILE OF FORM_1
   ENDIF
ELSE
   SET CONTEXTMENUS OFF
ENDIF

RETURN

*-----------------------------------------------------------------------------*
STATIC PROCEDURE SetFcompress()
*-----------------------------------------------------------------------------*
Local Compress := Lower( aGet[15] ), new := Lower( cFileNoExt( Form_1.Combo_7.DisplayValue ) )

If Form_1.Check_1.Value == .T. .and. !Empty(new)
   If !Empty(compress) .and. compress <> new
      PlayExclamation()
      If msgYesNo("O arquivo será substituido "+compress+".Zip" + CRLF + ;
                  "com o novo "+new+".Zip ?", "Confirmação", , IDI_MAIN, .f.)
         aGet[15] := new
      EndIf
   Else
      aGet[15] := new
   EndIf
Else
   aGet[15] := ''
EndIf

If Empty(new)
   Form_1.Check_1.Value := .F.
   Form_1.Title := "Envio de Email"
Else
   Form_1.Title := "Envio de Email" + IF(Empty(aGet[15]), "", " [O arquivo(s) anexado será enviado com o nome "+aGet[15]+".Zip ]")
EndIf

RETURN

*-----------------------------------------------------------------------------*
STATIC PROCEDURE m_send()
*-----------------------------------------------------------------------------*
   LOCAL i, oSocket, cSMTP, cFrom, cTo, cSubject, cMsgBody, aAttachment
   LOCAL lLogin, lLoginMD5, cUserID, cPassWord, lHTML, cUser := ""
   LOCAL Silent, Fcompress :='', nCompress := 9

   cSMTP       := aget[ 1]
   cFrom       := aget[ 2]
   cTo         := aget[ 3]
   cCC         := aget[ 4]
   cBCC        := aget[ 5]
   cSubject    := aget[ 6]
   aAttachment := aget[ 7]
   cMsgBody    := aget[ 8]
   lLogin      := aGet[ 9]
   lLoginMD5   := aGet[10]
   cUserID     := aGet[11]
   cPassWord   := aGet[12]
   lHTML       := ( aget[13] == 2 )
   Silent      := aGet[14]
   Fcompress   := aGet[15]

//   If !Empty(Fcompress)
//      HB_ZIPFILE( Fcompress+".Zip", aAttachment, nCompress , , .T. , , .T. )
//      aAttachment := { Fcompress+".Zip" }
//   EndIf

   oSocket := TSMTP():New()

   IF oSocket:Connect( cSMTP )

      i := At("<", cFrom)
      IF i > 0
         cUser := Chr(34) + Alltrim(Left(cFrom, i-1)) + Chr(34)
         cFrom := Substr(cFrom, i+1, Len(cFrom)-i-1)
      ENDIF

      i := At("<", cTo)
      IF i > 0
         cTo := Substr(cTo, i+1, Len(cTo)-i-1)
      ENDIF

      i := At("<", cCC)
      IF i > 0
         cCC := Substr(cCC, i+1, Len(cCC)-i-1)
      ENDIF
      i := At("<", cBCC)
      IF i > 0
         cBCC := Substr(cBCC, i+1, Len(cBCC)-i-1)
      ENDIF

      oSocket:ClearData()
      oSocket:SetFrom( cUser, "<"+ cFrom +">")

      oSocket:AddTo( cUser, "<"+ cTo +">" )

      IF ! Empty( cCC )
         oSocket:AddCc( cUser,"<"+ cCC +">")
      ENDIF
      IF ! Empty( cBCC )
         oSocket:AddBcc( cUser, "<"+ cBCC +">" )
      ENDIF

      oSocket:SetSubject( cSubject )

      IF Len( aAttachment ) > 0
           For i := 1 TO Len( aAttachment )
               oSocket:AddAttach( aAttachment[i] )
           Next i
      ENDIF

      oSocket:SetData( cMsgBody, lHTML )

      IF lLogin
         IF lLoginMD5
            IF ! oSocket:LoginMD5( cUserID, cPassWord )
               If Silent
                  LogFile( cLogFile, {oSocket:GetLastError()+" Nome de usuário ou Senha invalida"} )
               Else
                  MsgStop( oSocket:GetLastError(), "Nome de usuário ou Senha invalida" )
               EndIf
               oSocket:Close()
               RETURN
            ENDIF
         ELSEIF ! oSocket:Login( cUserID, cPassWord )
            If Silent
               LogFile( cLogFile, {oSocket:GetLastError()+" Nome de usuário ou Senha invalida"} )
            Else
               MsgStop( oSocket:GetLastError(), " Nome de usuário ou Senha invalida" ) // While trying to login got an error messages from server
            EndIf
            oSocket:Close()
            RETURN
         ENDIF
      ENDIF

      IF ! oSocket:Send(.T.)
         If Silent
            LogFile( cLogFile, {oSocket:GetLastError()+" While trying to send data got an error messages from server"} )
         Else
            MsgStop( oSocket:GetLastError(), "While trying to send data got an error messages from server" )
         EndIf
         oSocket:Close()
         RETURN
      ENDIF

      oSocket:Close()

      If Silent
         LogFile( cLogFile, {"Email enviado para >> " + cTo + " << com  Successo!"} )
      Else
         MsgInfo( "Email enviado para >> " + cTo + " << com  Successo!", "Lista Email" )
      EndIf

   ELSE

      If Silent
         LogFile( cLogFile, {"Não foi possível conectar ao Servidor SMTP: " + cSMTP} )
      Else
         MsgStop( "Não foi possível conectar ao Servidor SMTP: " + cSMTP, "Erro ao tentar conectar com o Servidor SMTP " )
      EndIf

   ENDIF

RETURN

*-----------------------------------------------------------------------------*
STATIC PROCEDURE m_config()
*-----------------------------------------------------------------------------*
   DEFINE WINDOW Form_2 ;
      AT 199,144 WIDTH 374 HEIGHT 221 ;
      TITLE "Configuração" ;
      ICON IDI_MAIN ;
      MODAL NOSIZE ;
      ON INIT Form_2.Button_1.Setfocus ;
      FONT "MS Sans Serif" SIZE 10

      @ 8,8 FRAME Frame_1 WIDTH 350 HEIGHT 138

      @ 22,25 CHECKBOX CheckBox_1 CAPTION "Meu Servidor Requer Autenticação" ;
              WIDTH 240 HEIGHT 22 ON CHANGE aget[9] := Form_2.CheckBox_1.Value 
      Form_2.CheckBox_1.Value := aget[9]

      @ 46,45 CHECKBOX CheckBox_2 CAPTION "MD5 Autenticação da Senha" ;
              WIDTH 200 HEIGHT 22 ON CHANGE aget[10] := Form_2.CheckBox_2.Value
      Form_2.CheckBox_2.Value := aget[10]

      @  81,25 LABEL Label_1 VALUE "Usuário" WIDTH 90 HEIGHT 22  
      @ 107,25 LABEL Label_2 VALUE "Senha" WIDTH 92 HEIGHT 22

      @ 76,125 TEXTBOX Text_1 HEIGHT 22 WIDTH 222 ON CHANGE aget[11] := Form_2.Text_1.Value
      Form_2.Text_1.Value := aget[11]

      @ 103,125 TEXTBOX Text_2 HEIGHT 22 WIDTH 222 PASSWORD ON CHANGE aget[12] := Form_2.Text_2.Value
      Form_2.Text_2.Value := aget[12]

      @ 156,140 BUTTONEX Button_1 CAPTION "OK" ACTION Form_2.Release WIDTH 80 HEIGHT 26 FONTCOLOR {128,0,0} BACKCOLOR {245,240,240} DEFAULT

      ON KEY ESCAPE ACTION Form_2.Button_1.OnClick

   END WINDOW

   CENTER WINDOW Form_2

   ACTIVATE WINDOW Form_2

RETURN
*-----------------------------------------------------------------------------*
STATIC PROCEDURE File_Attached( lClear, lcOne, oAdd )
*-----------------------------------------------------------------------------*
   LOCAL i, cNewAtt, c := .F., v := aget[7], cv := Form_1.Combo_7.Value

   Default lClear to .F., lcOne to .F., oAdd to .F.

   if len(v) > 0 .and. !lClear .and. Form_1.Combo_7.ItemCount > 0
      if !oadd
         PlayExclamation()
         c := !msgYesno("Adicionar um novo arquivo?", "Escolha", , IDI_MAIN, .f.)
      endif
   endif

   if !lClear
      cNewAtt := GetFile( { {"All Files", "*.*"}, ;
         {"ZIP Archives", "*.zip"}, {"RAR Archives", "*.rar"} }, ;
         "Selecione um arquivo(s) para Anexo", , .T. )
   endif

   if !empty( cNewAtt )

      If C
         aGet[7] := {}
         Form_1.Combo_7.DeleteAllItems
         v := {}
      Endif

      if valtype(cNewAtt) == 'C'

         If ascan(v,cNewAtt) < 1
            Form_1.Combo_7.AddItem(cNewAtt)
            aAdd(aGet[7], cNewAtt)
         Endif

      elseif valtype(cNewAtt) == 'A'

         for i := 1 to len(cNewAtt)

             if ascan(v,cNewAtt) < 1
                Form_1.Combo_7.AddItem(cNewAtt[i])
                aAdd(aGet[7], cNewAtt[i])
             Endif

         next i

      endif

      Form_1.Combo_7.Value := 1

   elseif lClear

      if LcOne
         Form_1.Combo_7.DeleteItem( cv )
         DO EVENTS
         Form_1.Combo_7.Value := IF( cv >= 1, 1, cv -1 )
         aGet[7] := {}
         AEVAL( GetComboArray("Combo_7", "Form_1"), {|x,y| IF(y #cv, aAdd(aGet[7], x), '')} )
      else
         aGet[7] := {}
         Form_1.Combo_7.DeleteAllItems
         Form_1.Check_1.Value := .F.
         aGet[15] := ''
      Endif

   endif

   DO EVENTS

   If EMPTY(FORM_1.COMBO_7.DISPLAYVALUE)
       DISABLE MENUITEM DELFILE OF FORM_1
   Else
       ENABLE MENUITEM DELFILE OF FORM_1
   Endif

   SetFCompress()

RETURN

*-----------------------------------------------------------------------------*
STATIC PROCEDURE SaveData()
*-----------------------------------------------------------------------------*
   LOCAL i, s := aget[14], q := .T.

   SET DECIMALS TO

   if !s
      PlayExclamation()
      q := msgYesno("Deseja Salvar as Modificações?", "Confirmação", q, IDI_MAIN, .f.)
   endif

   if q
      BEGIN INI FILE cCfgFile

            For i := 1 To Len(aEntry)
                IF i == 8
                   aGet[i] := STRTRAN( aGet[i], CRLF, Chr(250) )
                ELSEIF i == 12
                   aGet[i] := CHARXOR( aGet[i], cCryptKey )
                ENDIF
                SET SECTION "Data" ENTRY aEntry[i] TO aGet[i]
            Next i

      END INI
   endif

RETURN

*-----------------------------------------------------------------------------*
STATIC PROCEDURE LogFile( cFileName, acInfo )
*-----------------------------------------------------------------------------*
   LOCAL hFile, cLine := DToC( Date() ) + " " + Time() + " : ", n

   For n = 1 to Len( acInfo )
      cLine += acInfo[ n ] + Chr( 9 )
   Next
   cLine += CRLF

   if ! File( cFileName )
      FClose( FCreate( cFileName ) )
   endif

   if( ( hFile := FOpen( cFileName, FO_WRITE + FO_SHARED ) ) != -1 )
      FSeek( hFile, 0, FS_END )
      FWrite( hFile, cLine, Len( cLine ) )
      FClose( hFile )
   endif

Return

*-----------------------------------------------------------------------------*
STATIC Function GetComboArray( ControlName, ParentWindow )
*-----------------------------------------------------------------------------*
Local idx := GetControlIndex( ControlName, ParentWindow )
Return _HMG_aControlMiscData1 [idx] [4]
