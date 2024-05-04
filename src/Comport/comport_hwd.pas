unit comport_hwd;

interface

uses 
  winapi.windows, 
  system.sysutils, 
  system.strutils, 
  system.win.Registry, 
  system.Classes, 
  winapi.Messages, 
  vcl.forms,
  DTSetupApi_hwd,
  Vcl.Graphics
;

{==============================================================================}

type
  TExistingPort=record  
    COMPort : String;  //
    VID     : String;  //
    PID     : String;  //
    FrName  : String;  // 
  end;

  TExistingModem=record  
    VID     : String;//
    PID     : String;//
    MDMport : String;//
    ATport  : String;//
    DMport  : String;//
    GPSport : String;//
  end;

  TEgzistuojantysPortai=array of TExistingPort;
  TEgzistuojantysModemai=array of TExistingModem;

{==============================================================================}

function comport_init (portname : String; errcode : pdword) : dword ;
function comport_open (portn : String; hdw : pdword) : dword ; overload;
function comport_open(portn:String; var hdw:cardinal):dword ; overload;
function comport_close (hdw : pdword) : dword ;
function comport_setparams (hdw : dword) : dword ;
function comport_getparams (hdw : dword) : dword ;
function comport_gettimeouts (hdw : dword) : dword  ;
function comport_settimeouts (hdw : dword) : dword  ;
function comport_GetCommProp (hdw : dword) : dword ;
procedure comport_purge (hdw : dword) ;
procedure dcb_to_vars ;
procedure vars_to_dcb ;
procedure set_port_br(dw : dword) ;
function  get_port_br:dword;
procedure set_port_flags (dw : dword) ;
procedure set_port_XonLim (w : word) ;
procedure set_port_XoffLim (w : word) ;
procedure set_port_ByteSize (b : byte) ;
procedure set_port_inbuflen (dw : dword) ;
procedure set_port_outbuflen (dw : dword) ;
procedure set_port_parity(mode:byte);
procedure set_port_stopbits(mode:byte);
procedure set_port_XON(b:byte);
procedure set_port_XOFF(b:byte);
procedure set_port_EofChar (b : byte) ;
procedure set_port_ErrorChar (b : byte) ;
procedure set_port_EvtChar (b : byte) ;
function comport_write (hdw : dword; bufer : pbyte ; size : dword) : dword ;
function comport_read (hdw : dword; bufer : pbyte; receive : dword) : dword ;
function comport_getInputCount (hdw : dword) : dword ;
function set_port_params(hdw:dword;gid:byte;mid:cardinal):dword;
function GautiEgzistuojanciusPortus:TEgzistuojantysPortai;
function GautiEgzistuojanciusModemus:TEgzistuojantysPortai;
function GautiEgzistuojanciusPortusIrModemus:TEgzistuojantysPortai;
function IstrauktiComVardaIsDeskriptiono(str:String):String;
var port_RItimeout   : dword =100  ; // ReadIntervalTimeout
  port_RTTMtimeout : dword =100  ; // ReadTotalTimeoutMultiplier
  port_RTTCtimeout : dword =1000 ; // ReadTotalTimeoutConstant
  port_WTTMtimeout : dword =100  ; // WriteTotalTimeoutMultiplier
  port_WTTCtimeout : dword =1000 ;

{==============================================================================}

implementation

uses MainForm;

var

  buf_out          : array [0..$FFFF] of byte ;
  com_DCB          : _dcb          ;
  com_timeouts     : _commtimeouts ;
  com_status       : _ComStat      ;
  com_properties   : _COMMPROP     ;

  inbuflen         : dword ; // input buferio dydis
  outbuflen        : dword ; // output buferio dydis

  port_br          : dword ; // baudreitas
  port_flags       : dword ;
  port_XonLim      : word  ;
  port_XoffLim     : word  ;
  port_ByteSize    : byte  ;
  port_Parity      : byte  ;
  port_StopBits    : byte  ;
  port_XonChar     : AnsiChar  ;
  port_XoffChar    : AnsiChar  ;
  port_ErrorChar   : AnsiChar  ;
  port_EofChar     : AnsiChar  ;
  port_EvtChar     : AnsiChar  ;
   // WriteTotalTimeoutConstant

{==============================================================================}

function comport_init(portname:String; errcode:pdword):dword ;
var
  i         : dword ;
  ec        : dword ;
  comhandle : dword ; 
begin

  result:=0;
  comhandle:=$FFFFFFFF;
  i:=Length(portname);

  CopyMemory(@buf_out[0],@portname[1],i);
  buf_out[i]:=0;
  try
    comhandle:=CreateFileW(pchar(portname), GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, FILE_FLAG_OVERLAPPED) ;
    except on E:Exception do begin

    end;
  end;



  if comhandle=$FFFFFFFF then
  begin
    ec := getlasterror ;

    //with form1 do AddToDebugLog('FAIL ! Win. Error Code '+IntToStr(ec)+' Com handle = '+inttostr(comhandle));

    if ec=5 then
        i:=20         // 'Port already open !'
    else if ec=170 then
        i:=450   // 'The COM port uses another process!'
    else
        i:=24 ;  // 'Port unavailable'
    


    errcode^:=i ;
    result := 0 ;
  end
  else begin
    errcode^:=0 ;
    result := comhandle ;
  end;


  if (errcode^<>0)
  and(comhandle<>0)
  then closehandle (comhandle) ;

end;

{==============================================================================}

function comport_close (hdw : pdword) : dword ;
var
  ec : longbool ;
  ew : dword ;
begin
  result:=0;
  ec:=false;

  if hdw^ = 0 then exit ;
 // with form1 do AddToDebugLog('close port, handler = ' + inttostr(hdw^)) ;
  try
    ec := closehandle (hdw^) ;
    except on E:Exception do begin
    //  with form1 do AddToDebugLog('exception close por: '+e.Message);
    end;
  end;
  if not ec then begin
    ew := getlasterror ;
   // with form1 do AddToDebugLog('error close port, WinAPI error code : ' + inttostr(ew));
  end
  else begin
    ew := 0 ;
    hdw^:=0 ;
  end;

  Application.ProcessMessages;
  result := ew ;
end;

{==============================================================================}

function comport_setparams (hdw : dword) : dword ;
var
  ec : longbool ;
  ew : dword ;
begin
  if hdw=0 then begin
    result:=167; // No COM port handle !
    exit ;
  end;

  inbuflen := $1000 ;    // laikinai
  outbuflen := $1000 ;   // laikinai

  vars_to_dcb;

  ec:=SetCommState(hdw, com_dcb);
  if ec then begin
    ec:=SetupComm(hdw, inbuflen, outbuflen);
    if ec
    then result:=comport_settimeouts (hdw)
    else begin
      ew := GetLastError; 
     // with form1 do AddToDebugLog('comport_setparams SetupComm win error : '+IntToStr(ew));
      result:=24; // port unavailable
    end;
  end
  else begin
    ew := GetLastError; 
   // with form1 do AddToDebugLog('comport_setparams SetCommState win error : '+IntToStr(ew));
    result:=24; // port unavailable
  end;

end;

{==============================================================================}

function comport_getparams (hdw : dword) : dword ;

begin
  getcommState (hdw, com_DCB) ;
  dcb_to_vars ;
  result := 0 ;
end;

{==============================================================================}

function comport_open(portn:String; hdw:pdword):dword ; overload;

var
  ec : dword ;
begin
  ec := 0 ;
  try
    hdw^ := comport_init (portn, @ec) ;
    if ec<>0 then begin
      hdw^ := comport_init ('\\.\'+portn, @ec) ;
    end;
    except on E:Exception do begin
      ec:=GetLastError;
    end;
  end;



  if ec=0 then
  begin

    ec:=comport_getparams (hdw^);
     mform.adlg('renas',clred,true);
    if ec=0 then
    begin
      ec:=comport_gettimeouts (hdw^) ;
    end;
  end;
  mform.adlg('renas',clred,true);

  if ec = 2 then
      ec := 6 ;


  result := ec ;
end;

{==============================================================================}

function comport_open(portn:String; var hdw:cardinal):dword ; overload;

var
  ec : dword ;
begin
  hdw:=0;

  ec := 0 ;

  try
    hdw := comport_init (portn, @ec) ;
    if ec<>0 then begin
      hdw := comport_init ('\\.\'+portn, @ec) ;
    end;
    except on E:Exception do begin
      ec:=GetLastError;
     // with form1 do AddToDebugLog(e.Message);
    end;
  end;

  if ec=0 then begin
    ec:=comport_getparams (hdw);
    if ec=0 then begin
      ec:=comport_gettimeouts (hdw) ;
    end;
  end;

 // if ec = 0
  //then with form1 do AddToDebugLog('Port open success, handler = ' + IntToStr(hdw))
  //else with form1 do AddToDebugLog('Port open fail, Win error #'+IntToStr(ec));

  if ec = 2
  then ec := 6 ;

  result := ec ; 

end;

{==============================================================================}

procedure dcb_to_vars ;

begin

  port_br        := com_dcb.BaudRate        ;
  port_flags     := com_dcb.Flags           ;
  port_XonLim    := com_dcb.XonLim          ;
  port_XoffLim   := com_dcb.XoffLim         ;
  port_ByteSize  := com_dcb.ByteSize        ;
  port_Parity    := com_dcb.Parity          ;
  port_StopBits  := com_dcb.StopBits        ;
  port_XonChar   := com_dcb.XonChar   ;
  port_XoffChar  := com_dcb.XoffChar  ;
  port_ErrorChar := com_dcb.ErrorChar ;
  port_EofChar   := com_dcb.EofChar   ;
  port_EvtChar   := com_dcb.EvtChar   ;

end;

{==============================================================================}

procedure vars_to_dcb ;

begin

  com_dcb.BaudRate  := port_br              ;
  com_dcb.Flags     := port_flags           ;
  com_dcb.XonLim    := port_XonLim          ;
  com_dcb.XoffLim   := port_XoffLim         ;
  com_dcb.ByteSize  := port_ByteSize        ;
  com_dcb.Parity    := port_Parity          ;
  com_dcb.StopBits  := port_StopBits        ;
  com_dcb.XonChar   := port_XonChar   ;
  com_dcb.XoffChar  := port_XoffChar  ;
  com_dcb.ErrorChar := port_ErrorChar ;
  com_dcb.EofChar   := port_EofChar   ;
  com_dcb.EvtChar   := port_EvtChar   ;

end;

{==============================================================================}

procedure set_port_br (dw : dword) ;
begin
  port_br := dw ;
end;

function get_port_br:dword;
begin

  result:=port_br;

end;

{------------------------------------------------------------------------------}


procedure set_port_flags (dw : dword) ;
begin
  port_flags := dw ;
end;

{------------------------------------------------------------------------------}

procedure set_port_XonLim (w : word) ;
begin
  port_XonLim := w ;
end;

{------------------------------------------------------------------------------}

procedure set_port_XoffLim (w : word) ;
begin
  port_XoffLim := w ;
end;

{------------------------------------------------------------------------------}

procedure set_port_ByteSize (b : byte) ;
begin
  port_ByteSize := b ;
end;

{------------------------------------------------------------------------------}

procedure set_port_inbuflen (dw : dword) ;
begin
  inbuflen := dw ;
end;

{------------------------------------------------------------------------------}

procedure set_port_outbuflen (dw : dword) ;
begin
  outbuflen := dw ;
end;

{------------------------------------------------------------------------------}

procedure set_port_parity(mode:byte);
// 0 = no
// 1 = odd
// 2 = even
// 3 = mark
// 4 = space
begin
  port_Parity:=mode;
end;

{------------------------------------------------------------------------------}

procedure set_port_StopBits(mode:byte);
// 0 = 1
// 1 = 1.5
// 2 = 2
begin
  port_StopBits:=mode;
end;

{------------------------------------------------------------------------------}

procedure set_port_XON(b:byte);
begin
  CopyMemory(@port_XonChar,@b,1);
end;

{------------------------------------------------------------------------------}
procedure set_port_XOFF(b:byte);
begin
  CopyMemory(@port_XoffChar,@b,1);
end;
{------------------------------------------------------------------------------}
procedure set_port_EofChar (b : byte) ;
begin
  CopyMemory(@port_EofChar,@b,1);
end;
{------------------------------------------------------------------------------}
procedure set_port_ErrorChar (b : byte) ;
begin
  CopyMemory(@port_ErrorChar,@b,1);
end;
{------------------------------------------------------------------------------}
procedure set_port_EvtChar (b : byte) ;
begin
  CopyMemory(@port_EvtChar,@b,1);
end;

{==============================================================================}

function comport_write (hdw : dword; bufer : pbyte ; size : dword) : dword ;
var
  writed : dword ;
  eb     : longbool ;
  ew     : dword ;
begin

  if hdw=0 then begin
    result:=167; // No COM port handle !
  //  with form1 do AddToDebugLog('"comport_write" error: No COM port handle !');
    exit ;
  end
  else result:=0;
//
 // with form1
//  do if dm
 //    then AddToDebugLog('write to port '+inttostr(hdw)+'('+IntToStr(size)+' B):'#$0D#$0A+buf_to_hex(@bufer[0],size,false,true));

  eb:=writefile (hdw , bufer^, size, writed, 0) ;

  if not eb then begin
    ew := getlasterror;
   // with form1 do AddToDebugLog('"comport_write" error, Win. Error code '+IntToStr(ew));
    result:=22; // Write to port error!
  end;

  if (result=0)and(writed<>size) then begin
    result:=22 ; // 'Write to port error !'
  //  with form1 do AddToDebugLog('"comport_write" error, writed<>size! (writed='+IntToStr(writed)+')');
  end;
end;

{==============================================================================}

function comport_gettimeouts (hdw : dword) : dword  ;
var
  eb     : longbool ;
  ew     : dword ;
begin
  eb := getcommtimeouts (hdw, com_timeouts) ;
  if not eb then begin
    ew := getlasterror;
   // with form1 do AddToDebugLog('comport_gettimeouts win. error='+IntToStr(ew));
    result:=24; // 'Port unavailable'
  end
  else begin
    port_RItimeout   := com_timeouts.ReadIntervalTimeout         ;
    port_RTTMtimeout := com_timeouts.ReadTotalTimeoutMultiplier  ;
    port_RTTCtimeout := com_timeouts.ReadTotalTimeoutConstant    ;
    port_WTTMtimeout := com_timeouts.WriteTotalTimeoutMultiplier ;
    port_WTTCtimeout := com_timeouts.WriteTotalTimeoutConstant   ;
    result:=0;
  end;

end;

{==============================================================================}

function comport_settimeouts (hdw : dword) : dword  ;
var
  eb     : longbool ;
//  pdw    : pbyte ;
begin
  if hdw = 0 then begin
    result:=167; // 'No COM port handle !'
    exit ;
  end;
  com_timeouts.ReadIntervalTimeout         := port_RItimeout   ;
  com_timeouts.ReadTotalTimeoutMultiplier  := port_RTTMtimeout ;
  com_timeouts.ReadTotalTimeoutConstant    := port_RTTCtimeout ;
  com_timeouts.WriteTotalTimeoutMultiplier := port_WTTMtimeout ;
  com_timeouts.WriteTotalTimeoutConstant   := port_WTTCtimeout ;
  eb := setcommtimeouts (hdw, com_timeouts) ;
  if not eb then begin
    result := getlasterror;
   // with form1 do AddToDebugLog('comport_settimeouts win. error='+IntToStr(result));
    result:=24; // 'Port unavailable'
  end
  else result := 0 ;
end;

{==============================================================================}

function comport_read (hdw : dword; bufer : pbyte; receive : dword) : dword ;
var
  ec : longbool ;
  dw : dword ;
begin


  if hdw=0 then begin
    result:=167; // No COM port handle !
  //  with form1 do AddToDebugLog('"comport_read" error: No COM port handle !');
    exit ;
  end
  else result:=0;

  if receive=0 then begin
   // with form1 do AddToDebugLog('"Warning !!! "comport_read" to read 0 bytes !');
    exit ;
  end;

  ec := readfile (hdw, bufer^, receive, dw, nil) ;

  if not ec then begin
    result := 23 ;
   // with form1 do AddToDebugLog('"comport_read" error, Win. Error code '+IntToStr(getlasterror));
    exit ;
  end;

  if (result=0)
  and(dw<>receive)
  then result := 23 //'Read from port error'
  else result := 0 ;

  if result=0
  then begin
  //  with form1
   // do if dm
   //    then AddToDebugLog('get from port '+inttostr(hdw)+' ('+inttostr(receive)+' B):'#$0D#$0A+buf_to_hex(bufer,receive,false,true));
  end;

end;

{==============================================================================}

function comport_getstatus (hdw : dword): dword ;
var
  ec  : longbool ;
  ew  : dword ;
begin
  if hdw = 0 then begin
    result:=24;
    exit ;
  end;
  ec := ClearCommError (hdw, ew, @com_status) ;
  if not ec then ew := getlasterror else ew := 0 ;
  result := ew ;
end;

{==============================================================================}

function comport_getInputCount (hdw : dword) : dword ;
var
//  dw  : dword ; // tyrinejimams
  ew  : dword ;
//  pdw : pbyte ;
begin
  result:=0;
  if hdw = 0 then exit ;
  ew := comport_getstatus (hdw) ;
  if ew = 0 then result := com_status.cbInQue
  else result := 0 ;
end;

{==============================================================================}

procedure comport_purge (hdw : dword) ;
begin
  if hdw = 0
  then exit ;
  purgecomm (hdw, PURGE_RXABORT) ;
  purgecomm (hdw, PURGE_RXCLEAR) ;
  purgecomm (hdw, PURGE_TXABORT) ;
  purgecomm (hdw, PURGE_TXCLEAR) ;
end;

{==============================================================================}

function comport_getMaxBr (hdw : dword; maxbr : pdword) : dword ;
var
  ew : dword ;
begin
  result:=0;
  maxbr^:=0;
  if hdw = 0 then exit ;
  ew := comport_GetCommProp (hdw) ;
  if ew = 0 then maxbr^ := com_properties.dwMaxBaud ;
  result := ew ;
end;

{==============================================================================}

function comport_GetCommProp (hdw : dword) : dword ;
var
  eb : longbool ;

begin
  if hdw = 0 then begin
    result:=24;
    exit ;
  end;
  eb := GetCommProperties (hdw, com_properties) ;
  if not eb then result := getlasterror
  else result := 0 ;
end;

{==============================================================================}

function set_port_params(hdw:dword;gid:byte;mid:cardinal):dword;
var
  ptime:dword;
  ri : dword ;
  rm : dword ;
  rc : dword ;
  wm : dword ;
  wc : dword ;
  xonlim:word;
  xoflim:word;
  br : integer;
  dw : cardinal;
  s : string;
begin

  ri := 100 ;
  rm := 10 ;
  rc := 1000 ;
  wm := 10 ;
  wc := 1000 ;

  ptime:=1;
  xonlim:= 2048 ;
  xoflim:= 512 ;
  br:=115200;

  comport_getparams(hdw);
  dw:=port_flags;

  case gid of

    1 : begin

          case mid of
             1 : ptime:=500;
             2 : ptime:=500;
            15 : begin
                   ptime:=1000;
                   ri := 150 ;
                   rm := 2 ;
                   rc := 10000 ;
                   wm := 10 ;
                   wc := 2000 ;
                   xonlim:= 2048 ;
                   xoflim:= 512 ;
                   br:=115200;
                 end;

            18 : begin             // iCON 225
                   ptime:=500;
                   ri := 150 ;
                   rm := 100 ;
                   rc := 1000 ;
                   wm := 10 ;
                   wc := 2000 ;
                 end;

            19 : begin             // GTM 378
                   ptime:=500;
                   ri := 150 ;
                   rm := 100 ;
                   rc := 1000 ;
                   wm := 10 ;
                   wc := 2000 ;
                 end;
          end;
        end;

    2 : begin
          br:=115200;
          ri := 3 ;
          rm := 2 ;
          rc := 15 ;
          wm := 2 ;
          wc := 1000 ;

          ptime:=1000;

        end;

    3 : begin
          br:=115200;

          if (mid<>46)and(mid<>48) then begin
            ri := 6 ;
            rm := 4 ;
            rc := 30 ;
            wm := 4 ;
            wc := 20 ;
          end
          else begin
            ri := 0 ;
            rm := 0 ;
            rc := $FFFFFFFF ;
            wm := 10 ;
            wc := 1000 ;
          end;

        end;

    7 : begin
          br:=460800;
          ri := 6 ;
          rm := 4 ;
          rc := 30 ;
          wm := 4 ;
          wc := 20 ;
        end;

    10: begin
          ri := 100 ;
          rm := 100 ;
          rc := 100 ;
          wm := 100 ;
          wc := 100 ;
          br := 115200;
        end;
    19: begin

          ri := 100 ;
          rm := 100 ;
          rc := 10 ;
          wm := 10 ;
          wc := 100 ;

          ptime:=100;
          xonlim:= 2048 ;
          xoflim:= 512 ;
          br:=460800;
          dw:=$2021;  // DTR=handshake, RTS=Handshake

        end;
  end;


  if gid in[2,4,6,19]then begin
//      dw:=dw or $00000020; // DTR=handshake (portmon -> shake:2)
//      dw:=dw or $00002000; // RTS=Handshake  (portmon -> replace:80)
    dw:=$2021;
  end;

  //if dm
 // then begin
 //  // s:='COM port settings:'+#$0D#$0A+
     //  'Baudrate   : '+IntToStr(br)+#$0D#$0A+
     //  'ByteSize   : 8'+#$0D#$0A+
     //  'Parity     : none'+#$0D#$0A+
     //  'Stopbits   : 1'+#$0D#$0A+
     //  'XON        : 0x11'+#$0D#$0A+
     //  'XOFF       : 0x13'+#$0D#$0A+
     //  'XonLim     : '+inttostr(XonLim)+#$0D#$0A+
     //  'XoffLim    : '+inttostr(XofLim)+#$0D#$0A+
     //  'Timeouts   : '+inttostr(ri)+', '+inttostr(rm)+', '+inttostr(rc)+', '+inttostr(wm)+', '+inttostr(wc)+#$0D#$0A+
    //   'port_flags : 0x'+IntToHex(dw,8);
  //  with form1 do AddToDebugLog(s);
 // end;

  set_port_br(br);
  set_port_XonLim(XonLim);
  set_port_XoffLim(XofLim);
  set_port_ByteSize (8) ;
  set_port_inbuflen($1000);
  set_port_outbuflen($1000);
  set_port_parity(0);
  set_port_stopbits(0); //}
  set_port_XON($11);
  set_port_XOFF($13);
  set_port_ErrorChar(0);
  set_port_EofChar($1A);
  set_port_EvtChar(0);

  port_RTTMtimeout:=rm;
  port_RItimeout:=ri;
  port_RTTCtimeout:=rc;
  port_WTTCtimeout:=wc;
  port_WTTMtimeout:=wm;

  set_port_flags(dw);



  result:=comport_setparams (hdw) ;


  if result=0 then begin
    sleep(ptime);
    comport_purge(hdw);
  end;

end;

{==============================================================================}

procedure SetupEnumAvailableComPorts(var pl:TstringList);
// Enumerates all serial communications ports that are available and ready to
// be used.

// For the setupapi unit see
// http://homepages.borland.com/jedi/cms/modules/apilib/visit.php?cid=4&lid=3

var
  RequiredSize:             Cardinal;
  GUIDSize:                 DWORD;
  Guid:                     TGUID;
  DevInfoHandle:            HDEVINFO;
  DeviceInfoData:           TSPDevInfoData;
  MemberIndex:              Cardinal;
  PropertyRegDataType:      DWord;
  RegProperty:              Cardinal;
  RegTyp:                   Cardinal;
  Key:                      Hkey;
  Info:                     TRegKeyInfo;
  S1,S2,s3:                 String;

begin
  pl.Clear;
  s1:='';
  s2:='';
  s3:='';

// If we cannot access the setupapi.dll then we return a empty list
//  if not LoadsetupAPI then exit;
//  try

    // get 'Ports' class guid from name
    GUIDSize := 1;    // missing from original code - need to tell function that the Guid structure contains a single GUID
    if SetupDiClassGuidsFromNameW('Ports',@Guid,GUIDSize,RequiredSize)
    then begin

       //get object handle of 'Ports' class to interate all devices
       DevInfoHandle:=SetupDiGetClassDevsW(@Guid,Nil,0,DIGCF_PRESENT); //   OR DIGCF_DEVICEINTERFACE
       if Cardinal(DevInfoHandle)<>Invalid_Handle_Value
       then begin
         try

           //iterate device list
           MemberIndex:=0;
           repeat

             //get device info that corresponds to the next memberindex
             ZeroMemory(@DeviceInfoData,SizeOf(DeviceInfoData));
             DeviceInfoData.cbSize:=SizeOf(DeviceInfoData);
             if Not SetupDiEnumDeviceInfo(DevInfoHandle,MemberIndex,DeviceInfoData)
             then break;

             //query friendly device name LIKE 'BlueTooth Communication Port (COM8)' etc
             RegProperty:=SPDRP_FriendlyName;{SPDRP_Driver, SPDRP_SERVICE, SPDRP_ENUMERATOR_NAME,SPDRP_PHYSICAL_DEVICE_OBJECT_NAME,SPDRP_FRIENDLYNAME,}

             SetupDiGetDeviceRegistryPropertyW(DevInfoHandle,DeviceInfoData,RegProperty,PropertyRegDataType,NIL,0,RequiredSize);

             SetLength(S1,RequiredSize);

             if SetupDiGetDeviceRegistryPropertyW(DevInfoHandle,DeviceInfoData,RegProperty,PropertyRegDataType,@S1[1],RequiredSize,RequiredSize)
             then begin

               KEY:=SetupDiOpenDevRegKey(DevInfoHandle,DeviceInfoData,DICS_FLAG_GLOBAL,0,DIREG_DEV,KEY_READ);
               if key<>INValid_Handle_Value
               then begin

                 //query the real port name from the registry value 'PortName'
                 ZeroMemory(@Info, SizeOf(Info));
                 if RegQueryInfoKeyW(Key, nil, nil, nil, @Info.NumSubKeys,@Info.MaxSubKeyLen, nil, @Info.NumValues, @Info.MaxValueLen,@Info.MaxDataLen, nil, @Info.FileTime) = ERROR_SUCCESS
                 then begin
                   RequiredSize:= Info.MaxValueLen + 1;
                   SetLength(S2,RequiredSize);
                   if RegQueryValueEx(KEY,'PortName',Nil,@Regtyp,@s2[1],@RequiredSize)=Error_Success
                   then begin
                     If (Pos('COM',S2)=1)
                     then begin
//Test if the device can be used
//                       hc:=CreateFile(pchar('\\.\'+S2+#0),
//                                      GENERIC_READ or GENERIC_WRITE,
//                                      0,
//                                      nil,
//                                      OPEN_EXISTING,
//                                      FILE_ATTRIBUTE_NORMAL,
//                                      0);
//                       if hc<> INVALID_HANDLE_VALUE then begin
                         //Result.Add(Strpas(PChar(S2))+': = '+StrPas(PChar(S1)));

                         s1:=StrPas(PChar(S1));
                         s2:=StrPas(PChar(S2));

//                         CloseHandle(hc);
//                       end else s2:='';
                     end else s2:='';
                   end else s2:='';

//****************************** eksperimentas *******************************//

                   RegProperty:=SPDRP_HARDWAREID;{SPDRP_Driver, SPDRP_SERVICE, SPDRP_ENUMERATOR_NAME,SPDRP_PHYSICAL_DEVICE_OBJECT_NAME,SPDRP_FRIENDLYNAME,}

                   SetupDiGetDeviceRegistryPropertyW(DevInfoHandle,DeviceInfoData,RegProperty,PropertyRegDataType,NIL,0,RequiredSize);

                   SetLength(S3,RequiredSize);
                   if SetupDiGetDeviceRegistryPropertyW(DevInfoHandle,DeviceInfoData,RegProperty,PropertyRegDataType,@S3[1],RequiredSize,RequiredSize)
                   then begin

                     //Result.Add('('+StrPas(PChar(S1))+')');
                     s3:=StrPas(PChar(S3));
                   end;

//****************************************************************************//

                 end;
                 RegCloseKey(key);
               end;
             end;

             if (s1<>'')and(s2<>'')and(s3<>'')
             then pl.Add(S2+'|'+S1+'|'+s3);
             s1:='';
             s2:='';
             s3:='';

             Inc(MemberIndex);
           until False;

         finally
           SetupDiDestroyDeviceInfoList(DevInfoHandle);
         end;
       end;
    end;
//  finally
//    UnloadSetupApi;
//  end;
end;

//----------------------------------------------------------------------------//

procedure SetupEnumAvailableModems(var pl:TstringList);
// Enumerates all serial communications ports that are available and ready to
// be used.

// For the setupapi unit see
// http://homepages.borland.com/jedi/cms/modules/apilib/visit.php?cid=4&lid=3

var
  RequiredSize:             Cardinal;
  GUIDSize:                 DWORD;
  Guid:                     TGUID;
  DevInfoHandle:            HDEVINFO;
  DeviceInfoData:           TSPDevInfoData;
  MemberIndex:              Cardinal;
  PropertyRegDataType:      DWord;
  RegProperty:              Cardinal;
  RegTyp:                   Cardinal;
  Key:                      Hkey;
  Info:                     TRegKeyInfo;
  S1,S2,s3:                    string;
//  hc:                       THandle;
begin
  pl.Clear;
  //result:=nil;
  s1:='';
  s2:='';
  s3:='';
//If we cannot access the setupapi.dll then we return a nil pointer.
//  if not LoadsetupAPI then exit;
//  try
// get 'Ports' class guid from name

    GUIDSize := 1;    // missing from original code - need to tell function that the Guid structure contains a single GUID
    if SetupDiClassGuidsFromNameW('Modem',@Guid,GUIDSize,RequiredSize) then begin
//get object handle of 'Ports' class to interate all devices
      DevInfoHandle:=SetupDiGetClassDevsW(@Guid,Nil,0,DIGCF_PRESENT);
       if Cardinal(DevInfoHandle)<>Invalid_Handle_Value then begin
         try
           MemberIndex:=0;
           //result:=TStringList.Create;
//iterate device list
           repeat
             FillChar(DeviceInfoData,SizeOf(DeviceInfoData),0);
             DeviceInfoData.cbSize:=SizeOf(DeviceInfoData);
//get device info that corresponds to the next memberindex
             if Not SetupDiEnumDeviceInfo(DevInfoHandle,MemberIndex,DeviceInfoData) then
               break;
//query friendly device name LIKE 'BlueTooth Communication Port (COM8)' etc
             RegProperty:=SPDRP_FRIENDLYNAME;{SPDRP_Driver, SPDRP_SERVICE, SPDRP_ENUMERATOR_NAME,SPDRP_PHYSICAL_DEVICE_OBJECT_NAME,SPDRP_FRIENDLYNAME,}

             SetupDiGetDeviceRegistryPropertyW(DevInfoHandle,
                                                   DeviceInfoData,
                                                   RegProperty,
                                                   PropertyRegDataType,
                                                   NIL,0,RequiredSize);
             SetLength(S1,RequiredSize);

             if SetupDiGetDeviceRegistryPropertyW(DevInfoHandle,DeviceInfoData,
                                                 RegProperty,
                                                 PropertyRegDataType,
                                                 @S1[1],RequiredSize,RequiredSize) then begin
               KEY:=SetupDiOpenDevRegKey(DevInfoHandle,DeviceInfoData,DICS_FLAG_GLOBAL,0,DIREG_DEV,KEY_READ);
               if key<>INValid_Handle_Value then begin
                 FillChar(Info, SizeOf(Info), 0);
//query the real port name from the registry value 'PortName'
                 if RegQueryInfoKeyW(Key, nil, nil, nil, @Info.NumSubKeys,@Info.MaxSubKeyLen, nil, @Info.NumValues, @Info.MaxValueLen,
                                                        @Info.MaxDataLen, nil, @Info.FileTime) = ERROR_SUCCESS then begin
                   RequiredSize:= Info.MaxValueLen + 1;
                   SetLength(S2,RequiredSize);
                   if RegQueryValueExW(KEY,'PortName',Nil,@Regtyp,@s2[1],@RequiredSize)=Error_Success then begin
                     If (Pos('COM',S2)=1) then begin
//Test if the device can be used
//                       hc:=CreateFile(pchar('\\.\'+S2+#0),
//                                      GENERIC_READ or GENERIC_WRITE,
//                                      0,
//                                      nil,
//                                      OPEN_EXISTING,
//                                      FILE_ATTRIBUTE_NORMAL,
//                                      0);
//                       if hc<> INVALID_HANDLE_VALUE then begin
                         //Result.Add(Strpas(PChar(S2))+': = '+StrPas(PChar(S1)));
                         s1:=StrPas(PChar(S1));
                         s2:=StrPas(PChar(S2));

//                         CloseHandle(hc);
//                       end else s2:='';
                     end else s2:='';
                   end else S2:='';

//****************************** eksperimentas *******************************//

                   RegProperty:=SPDRP_HARDWAREID;{SPDRP_Driver, SPDRP_SERVICE, SPDRP_ENUMERATOR_NAME,SPDRP_PHYSICAL_DEVICE_OBJECT_NAME,SPDRP_FRIENDLYNAME,}

                   SetupDiGetDeviceRegistryPropertyW(DevInfoHandle,
                                                    DeviceInfoData,
                                                    RegProperty,
                                                    PropertyRegDataType,
                                                    NIL,
                                                    0,
                                                    RequiredSize);
                   SetLength(S3,RequiredSize);
                   if SetupDiGetDeviceRegistryPropertyW(DevInfoHandle,
                                                       DeviceInfoData,
                                                       RegProperty,
                                                       PropertyRegDataType,
                                                       @S3[1],
                                                       RequiredSize,
                                                       RequiredSize)then begin

                     //Result.Add('('+StrPas(PChar(S1))+')');
                     s3:=StrPas(PChar(S3));

                   end;

//****************************************************************************//

                 end;
                 RegCloseKey(key);
               end;
             end;

             if (s1<>'')and(s2<>'')and(s3<>'') then pl.Add(S2+'|'+S1+'|'+s3);
             s1:='';
             s2:='';
             s3:='';


             Inc(MemberIndex);
           until False;

           //If we did not found any free com.
//           if Result.Count=0 then begin
//             //Result.Free;
//             //Result:=NIL;
//             Result.Clear;
//           end
         finally
           SetupDiDestroyDeviceInfoList(DevInfoHandle);
         end;
       end;
    end;
//  finally
//    UnloadSetupApi;
//  end;
end;

//----------------------------------------------------------------------------//

function GautiEgzistuojanciusPortus:TEgzistuojantysPortai;

var
  l                          : integer;
  i                          : integer;
  c                          : integer;
  rp                         : TStringList;
  EgzistuojanciuPortuSarasas : TStringList;

begin
  rp:=TStringList.Create;
  SetLength(result,0);
  EgzistuojanciuPortuSarasas:=TStringList.Create;

  SetupEnumAvailableComPorts(rp);
  if (rp<>nil)and(rp.Count>0)then for i:=0 to rp.Count-1 do EgzistuojanciuPortuSarasas.Add(rp.Strings[i]);

  if EgzistuojanciuPortuSarasas.Count>0 then begin

    SetLength(result,EgzistuojanciuPortuSarasas.Count);

    for i:=0 to EgzistuojanciuPortuSarasas.Count-1 do begin
      l:=length(EgzistuojanciuPortuSarasas.Strings[i]);

      // vid
      c:=pos('vid_',lowercase(EgzistuojanciuPortuSarasas.Strings[i]));
      if c<>0 then result[i].VID:=LowerCase(MidStr(EgzistuojanciuPortuSarasas.Strings[i],c+4,4))else result[i].VID:='';

      // pid
      c:=pos('pid_',lowercase(EgzistuojanciuPortuSarasas.Strings[i]));
      if c<>0 then result[i].PID:=LowerCase(MidStr(EgzistuojanciuPortuSarasas.Strings[i],c+4,4))
      else begin

        c:=pos('subclass_',lowercase(EgzistuojanciuPortuSarasas.Strings[i]));
        if c<>0 then result[i].PID:=LowerCase(MidStr(EgzistuojanciuPortuSarasas.Strings[i],c+9,2))

        else result[i].PID:='';
      end;

      c:=1;
      repeat
        result[i].COMPort:=result[i].COMPort+EgzistuojanciuPortuSarasas.Strings[i][c];
        inc(c);
      until (EgzistuojanciuPortuSarasas.Strings[i][c]='|')or(c>=l);

      inc(c);
      repeat
        result[i].FrName:=result[i].FrName+EgzistuojanciuPortuSarasas.Strings[i][c];
        inc(c);
      until (EgzistuojanciuPortuSarasas.Strings[i][c]='|')or(c>=l);
    end;
  end;

  EgzistuojanciuPortuSarasas.Free;
  rp.Free;
end;

//----------------------------------------------------------------------------//

function GautiEgzistuojanciusModemus:TEgzistuojantysPortai;

var
  l                          : integer;
  i                          : integer;
  c                          : integer;
  rp                         : TStringList;
  EgzistuojanciuPortuSarasas : TStringList;

begin
  rp:=TStringList.Create;

  SetLength(result,0);
  EgzistuojanciuPortuSarasas:=TStringList.Create;

  SetupEnumAvailableModems(rp);
  if (rp<>nil)and(rp.Count>0)then for i:=0 to rp.Count-1 do EgzistuojanciuPortuSarasas.Add(rp.Strings[i]);

  if EgzistuojanciuPortuSarasas.Count>0 then begin

    SetLength(result,EgzistuojanciuPortuSarasas.Count);

    for i:=0 to EgzistuojanciuPortuSarasas.Count-1 do begin
      l:=length(EgzistuojanciuPortuSarasas.Strings[i]);

      // vid
      c:=pos('vid_',lowercase(EgzistuojanciuPortuSarasas.Strings[i]));
      if c<>0 then result[i].VID:=LowerCase(MidStr(EgzistuojanciuPortuSarasas.Strings[i],c+4,4))
      else result[i].VID:='';

      // pid
      c:=pos('pid_',lowercase(EgzistuojanciuPortuSarasas.Strings[i]));
      if c<>0 then result[i].PID:=LowerCase(MidStr(EgzistuojanciuPortuSarasas.Strings[i],c+4,4))
      else begin
        c:=pos('subclass_',lowercase(EgzistuojanciuPortuSarasas.Strings[i]));
        if c<>0 then result[i].PID:=LowerCase(MidStr(EgzistuojanciuPortuSarasas.Strings[i],c+9,2))
        else result[i].PID:='';
      end;

      c:=1;
      repeat
        result[i].COMPort:=result[i].COMPort+EgzistuojanciuPortuSarasas.Strings[i][c];
        inc(c);
      until (EgzistuojanciuPortuSarasas.Strings[i][c]='|')or(c>=l);

      inc(c);
      repeat
        result[i].FrName:=result[i].FrName+EgzistuojanciuPortuSarasas.Strings[i][c];
        inc(c);
      until (EgzistuojanciuPortuSarasas.Strings[i][c]='|')or(c>=l);
    end;
  end;

  EgzistuojanciuPortuSarasas.Free;
  rp.Free;
end;

//----------------------------------------------------------------------------//

function GautiEgzistuojanciusPortusIrModemus:TEgzistuojantysPortai;
var
  VisiModemai : TEgzistuojantysPortai;
  VisiPortai : TEgzistuojantysPortai;
  ModemCount, PortCount : integer;
  i,c : integer;
begin
  SetLength(VisiModemai,0);
  SetLength(VisiPortai,0);

  VisiModemai:=GautiEgzistuojanciusModemus;
  VisiPortai:=GautiEgzistuojanciusPortus;

  if VisiModemai<>nil then ModemCount:=high(VisiModemai)+1 else ModemCount:=0;
  if VisiPortai<>nil then PortCount:=high(VisiPortai)+1 else PortCount:=0;

  SetLength(result,ModemCount+PortCount);

  if (result<>nil)
  and(high(result)>-1)
  then begin
    i:=0;
    if ModemCount>0 then begin
      for c:=0 to high(VisiModemai)do begin
        Result[i]:=VisiModemai[c];
        inc(i);
      end;
    end;

    if PortCount>0 then begin
      for c:=0 to high(VisiPortai)do begin
        Result[i]:=VisiPortai[c];
        inc(i);
      end;
    end;
  end;

  SetLength(VisiModemai,0);
  SetLength(VisiPortai,0);
end;

{==============================================================================}

function IstrauktiComVardaIsDeskriptiono(str:String):String;

var
  i, p : integer; 

begin
  result:='';
  if str<>''then begin
    p:=pos('COM',str);
    if p>0 then begin
      i:=length(str);
      result:='COM';
      inc(p,3);
      while(p<=i)
      and(CharInSet(str[p],['0','1','2','3','4','5','6','7','8','9']))
      do begin
        result:=result+str[p];
        inc(p);
      end;
    end;
  end;
end;

{==============================================================================}

end.
