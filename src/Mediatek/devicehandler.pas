unit devicehandler;

interface
uses mediatek, Windows, Messages, SysUtils, Variants, Classes;
  function mtk_echo8(cmd: Byte): Boolean;
  function mtk_echo32(cmd: uint32): Boolean;
  function mtk_readData(var data: array of byte; mlength:uint32):boolean;
  function mtk_writeData(data: array of byte; mlength:uint32):boolean;
  function mtk_read8(var cmd: Byte): Boolean;
  function mtk_write8(cmd: Byte): Boolean;
  function mtk_read16(var cmd: uint16): Boolean;
  function mtk_write16(cmd: uint16): Boolean;
  function mtk_read32(var cmd: uint32): Boolean;
  function mtk_write32(cmd: uint32): Boolean;
  var
    pHandle : uint32;
implementation

uses comport_hwd, rhelper, preloader, MainForm, Math;


function mtk_readData(var data: array of Byte; mlength: uint32):boolean;
begin
    if not comport_read(pHandle,@data, mlength) = 1 then
        Exit(False);

    result := length(data) = mlength;
end;
function mtk_writeData(data: array of Byte; mlength: uint32):boolean;
begin
    if not comport_write(pHandle,@data, mlength) = 1 then
        Exit(False);

    result := length(data) = mlength;
end;

function mtk_read8(var cmd: Byte): Boolean;
begin
    if not comport_read(pHandle,@cmd, 1) = 1 then
        Exit(False);

    result := true;
end;
function mtk_write8(cmd: Byte): Boolean;
begin
    if not comport_write(pHandle,@cmd, 1) = 1 then
        Exit(False);

    result := true;
end;

function mtk_read16(var cmd: uint16): Boolean;
begin
    cmd := 0;
    if not comport_read(pHandle,@cmd, 2) = 1 then
        Exit(False);

    result := true;
end;
function mtk_write16(cmd: uint16): Boolean;
begin
    cmd := Swap16(cmd);
    if not comport_write(pHandle,@cmd, 2) = 1 then
        Exit(False);

    result := true;
end;

function mtk_read32(var cmd: uint32): Boolean;
begin
    if not comport_read(pHandle,@cmd, 4) = 1 then
        Exit(False);

    result := true;
end;
function mtk_write32(cmd: uint32): Boolean;
begin
    cmd := Swap32(cmd);
    if not comport_write(pHandle,@cmd, 4) = 1 then
        Exit(False);

    result := true;
end;
function mtk_echo8(cmd: Byte): Boolean;
var
    resp: byte;
begin
  if not mtk_write8(cmd) then
    Exit(False);
  if not mtk_read8(resp) then
    Exit(False);
  Result := resp = cmd;
end;

function mtk_echo32(cmd: uint32): Boolean;
var
  resp: uint32;
begin
  cmd := Swap32(cmd);
  if not comport_write(pHandle,@cmd, 4) = 1 then
    Exit(False);

  resp := 0;

  if not comport_read(pHandle,@resp, 4) = 1 then
    Exit(False);

  Result := resp = cmd;
end;
end.
