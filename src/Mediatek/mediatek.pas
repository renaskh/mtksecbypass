unit mediatek;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms;

type
  damodes = (DEFAULT = 0, XFLASH = 1);
       da_hdr = record
      m_title: array[0..31] of Byte;
      m_version: array[0..63] of Byte;
      m_unknown: UInt32;
      m_magic: UInt32;
      m_count: UInt32;
  end;

     da_geometry = record
      m_offset: UInt32;
      m_length: UInt32;
      m_startaddr: UInt32;
      m_startoffset: UInt32;
      m_siglen: UInt32;
  end;

     da_entry = record
      m_magic: UInt16;
      m_hwcode: UInt16;
      m_hwsub: UInt16;
      m_hwver: UInt16;
      m_swver: UInt16;
      m_reserved1: UInt16;
      m_pagesize: UInt16;
      m_reserved3: UInt16;
      m_region_index: UInt16;
      m_region_count: UInt16;
      m_geometries: array [0..9] of da_geometry;
  end;

  DataType = (
    DT_PROTOCOL_FLOW = 1,
    DT_MESSAGE = 2
  );
  MtkTransHdr = packed record
    magic: UInt32;
    datatype: UInt32;
    length: UInt32;
  end;
  MtkEnvCmd = packed record
    daLogLevel: UInt32;
    logChannel: UInt32;
    systemOS: UInt32;
    ufsProvision: UInt32;
    unknown: UInt32;
  end;
  TCmdTmp = packed record
    Offset: UInt64;
    Length: UInt64;
  end;
  TMtkRam32Info = packed record
    SramType: UInt32;
    SramBaseAddress: UInt32;
    SramSize: UInt32;
    DramType: UInt32;
    DramBaseAddress: UInt32;
    DramSize: UInt32;
  end;
  TMtkRam64Info = packed record
    SramType: UInt64;
    SramBaseAddress: UInt64;
    SramSize: UInt64;
    DramType: UInt64;
    DramBaseAddress: UInt64;
    DramSize: UInt64;
  end;
  UFSInfo = record
    ufsType: Cardinal; // ufs or none.
    block_size: Cardinal;
    lu0_size: Int64;
    lu1_size: Int64;
    lu2_size: Int64;
    vendor_id: SmallInt;
    cid: array [0..19] of Char;
    fwver: array [0..7] of Char;
    serial: array [0..131] of Char;
    pre_eol_info: Char;
    life_time_est_a: Char;
    life_time_est_b: Char;
    stub1: Char;
    life_time_status: Cardinal;
  end;

  EMMCInfo = record
    emmcType: UInt32;
    block_size: UInt32;
    boot1_size: UInt64;
    boot2_size: UInt64;
    rpmb_size: UInt64;
    gp1_size: UInt64;
    gp2_size: UInt64;
    gp3_size: UInt64;
    gp4_size: UInt64;
    user_size: UInt64;
    cid: array [0..3] of Cardinal;
    fwver: array [0..7] of Char;
    pre_eol_info: Char;
    life_time_est_a: Char;
    life_time_est_b: Char;
    life_time_status: Cardinal;
  end;
type
  MTKIn = record
    portnum: string;
    hwcode: uint16;
    meid,socid: string;
    var1: Byte;
    watchdog: uint32;
    uart: uint32;
    brom_payload_addr: uint32;
    da_payload_addr: uint32;
    pl_payload_addr: uint32;
    gcpu_base: uint32;
    sej_base: uint32;
    dxcc_base: uint32;
    cqdma_base: uint32;
    ap_dma_mem: uint32;

    send_ptr: array [0..1] of uint32;
    blacklist: array [0..1] of array [0..1] of uint32 ;

    blacklist_count: uint32;

    ctrl_buffer: uint32;
    cmd_handler: uint32;
    brom_register_access: array [0..1] of uint32;
    meid_addr: uint32;
    socid_addr: uint32;
    prov_addr: uint32;
    misc_lock: uint32;
    efuse_addr: uint32;

    dacode: uint16;
    damode: damodes;
    name: string;
    description: string;

    ba: array of byte;
    u8: byte;
    u16: uint16;
    u32: uint32;

    payload: TBytes;

    emi: TBytes;

    da_entry: da_entry;

    da_buff: array [0..2] of TBytes;

  end;

    function bypass_auth(var info : MTKIn):boolean;
    function connect_device(var info : MTKIn):boolean;
    function find_mtk_port(var info : MTKIn):boolean;
    function handshake(var info : MTKIn):boolean;
    function ConnectBrom(var info : MTKIn):boolean;

    

implementation

uses MainForm,Preloader,brom_config,devicehandler,comport_hwd;

function bypass_auth(var info : MTKIn):boolean;
begin
  if not connect_device(info) then
      exit(false);
  result:=true;
end;
function ConnectBrom(var info : MTKIn):boolean;
var
  i:integer;
  ploader:TPreloader;
  config: Tbrom_config;
begin
    if not find_mtk_port(info) then
        exit(false);
    if not handshake(info) then
        exit(false);
    if not ploader.read_hw_codes(info) then
        exit(false);
    if not config.configuration(info) then
        exit(false);
    if not ploader.get_blver(info) then
        exit(false);
    if not ploader.get_hw_sw_ver(info) then
        exit(false);
    if not ploader.get_meid(info) then
        exit(false);
    if not ploader.get_socid(info) then
        exit(false);
    if not ploader.get_target_config(info) then
        exit(false);
    if not ploader.setreg_disablewatchdogtimer(info) then
        exit(false);
    if not ploader.exploit2(info) then
        exit(false);
    comport_close(0);

    result:=true;
end;

function connect_device(var info : MTKIn):boolean;
begin
    if not ConnectBrom(info) then
        exit(false);

    result:=true;
end;

function handshake(var info : MTKIn):boolean;
var
    startcmd: array of Byte;
    i: Integer;
    res: Byte;
begin
    MForm.adlg('Handshaking protocol...',clblack,true);
    startcmd := [$A0,$0A,$50,$05];
    for i := 0 to 3 do
    begin
        if not comport_write(pHandle,@startcmd[i], 1) = 1 then
            raise Exception.Create('[HANDSHAKE] Can not write cmd');
        if not comport_read(pHandle,@res, 1) = 1 then
            raise Exception.Create('[HANDSHAKE] Can not read cmd');
        if res <> (not (startcmd[i]) and $FF) then
            raise Exception.Create('[HANDSHAKE] Invalid response from device');
    end;
    mform.ok;
    Result := True;
end;

function find_mtk_port(var info : MTKIn):boolean;
var
    i,i2:integer;
    ConnectedPorts: TEgzistuojantysPortai;
begin
    MForm.adlg('Waiting for mtk connection...',clblack ,false);
    for I := 0 to 200 do
    begin
      ConnectedPorts:=GautiEgzistuojanciusPortus;
      if (ConnectedPorts<>nil) and(high(ConnectedPorts)>-1) then
      begin
          for i2:=0 to high(ConnectedPorts) do
          begin
             if (ConnectedPorts[i2].VID = '0e8d') and (ConnectedPorts[i2].PID = '0003')
             or (ConnectedPorts[i2].VID = '0e8d') and (ConnectedPorts[i2].PID = '2000')
             or (ConnectedPorts[i2].VID = '0e8d') and (ConnectedPorts[i2].PID = '2001')
             or (ConnectedPorts[i2].VID = '0e8d') and (ConnectedPorts[i2].PID = '2006')
             or (ConnectedPorts[i2].VID = '22d9') and (ConnectedPorts[i2].PID = '0006')
             or (ConnectedPorts[i2].VID = '1004') and (ConnectedPorts[i2].PID = '6000') then
             begin
                 MForm.adlg(' Found',clgreen,false);
                 MForm.adlg('Connected port : ',clblack,true);
                 MForm.adlg(ConnectedPorts[i2].FrName,clblue,false);
                 info.portnum := ConnectedPorts[i2].COMPort;

                 MForm.adlg('Opening comport...',clblack,true);
                 if not comport_open(info.portnum, pHandle) = 0 then
                 begin
                     raise Exception.Create('Can not open comport');
                 end;
                 set_port_params(pHandle, 19, 0);
                 mform.ok;
                 exit(true);
             end;
          end;
      end;
      Sleep(100);
    end;
    raise Exception.Create('connection timeout');
    exit(false);
end;
end.
