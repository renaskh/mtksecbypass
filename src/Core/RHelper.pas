unit RHelper;


interface
uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms;

function BytesToHex(const bytes: array of Byte): string;
function Swap16(const v: uint16): uint16;
function Swap32(Value: uint32): uint32;
function CardinalsToBytes(const uint32: array of uint32): TBytes;
function FindRecord(data: PAnsiChar; max_length: uint32; recordId: PAnsiChar): PAnsiChar;
function BytesToString(const Bytes: TBytes): string;
function HexSearch(const Data: TBytes; const Pattern: TBytes): Integer;
procedure AppendBytes(var Dest: TBytes; const Source: TBytes);
function BytesToUInt32(const Bytes: TBytes): UInt32;
function UInt32ToBytes(value: UInt32): TBytes;
function HexToByteArray(const HexString: string): TBytes;
function ReplaceBytes(const Source: TBytes; const OldPattern, NewPattern: TBytes): TBytes;
function ExtractBytes(const Source: TBytes; Offset, Count: Integer): TBytes;
function GetSize(bytes: UInt64): string;
implementation


function GetSize(bytes: UInt64): string;
begin
  var kb: UInt64 := 1024;
  var mb: UInt64 :=1024 * kb;
  var gb: UInt64 := 1024 * mb;
  var tb: UInt64 :=1024 * gb;
  // According to the Si standard KB is 1000 bytes, KiB is 1024
  // but on Windows sizes are calculated by dividing by 1024 so we do what they do.
  if bytes >= tb then
    Result := Format('%0.2f TB', [bytes / tb])
  else if bytes >= gb then
    Result := Format('%0.2f GB', [bytes / gb])
  else if bytes >= mb then
    Result := Format('%0.2f MB', [bytes / mb])
  else if bytes >= kb then
    Result := Format('%0.2f KB', [bytes / kb])
  else
    Result := Format('%d Byte', [bytes]);
end;
function BytesToHex(const bytes: array of Byte): string;
var
  i: Integer;
begin
  Result := '';
  for i := Low(bytes) to High(bytes) do
    Result := Result + IntToHex(bytes[i], 2);
end;

function Swap16(const v: uint16): uint16;
begin
  Result := (v shl 8) or (v shr 8);
end;
function Swap32(Value: uint32): uint32;
begin
  Result := ((Value and $000000FF) shl 24) or
            ((Value and $0000FF00) shl 8) or
            ((Value and $00FF0000) shr 8) or
            ((Value and $FF000000) shr 24);
end;
function CardinalsToBytes(const uint32: array of uint32): TBytes;
begin
  SetLength(Result, Length(uint32) * SizeOf(uint32));
  Move(uint32[0], Result[0], Length(uint32) * SizeOf(uint32));
end;
function ExtractBytes(const Source: TBytes; Offset, Count: Integer): TBytes;
begin
  SetLength(Result, Count);
  Move(Source[Offset], Result[0], Count);
end;
 function FindRecord(data: PAnsiChar; max_length: uint32; recordId: PAnsiChar): PAnsiChar;
var
  ptr: PAnsiChar;
  remaining_length: uint32;
begin
  ptr := data;

  if StrLen(recordId) > max_length then
    Exit(nil);

  remaining_length := max_length;
  repeat
    { fast scan for the first character only }
    ptr := StrScan(ptr, recordId[0]);
    if not Assigned(ptr) then
      Exit(nil);

    { first character matches, test entire string }
    if not CompareMem(ptr, recordId, StrLen(recordId)) then
      Exit(ptr);

    { no match; test onwards from the next possible position }
    Inc(ptr);

    { take care not to overrun end of data }
    if ptr >= data + max_length then
      Break;

    remaining_length := ptr - data;
  until False;

  Result := nil;
end;
function BytesToString(const Bytes: TBytes): string;
begin
  SetString(Result, PAnsiChar(Bytes), Length(Bytes) div SizeOf(Char));
end;
function HexSearch(const Data: TBytes; const Pattern: TBytes): Integer;
var
  I, J: Integer;
begin
  Result := -1;

  if Length(Pattern) = 0 then
    Exit;

  for I := 0 to High(Data) - High(Pattern) do
  begin
    for J := 0 to High(Pattern) do
    begin
      if Data[I + J] <> Pattern[J] then
        Break;
    end;

    if J = Length(Pattern) then
    begin
      Result := I;
      Break;
    end;
  end;
end;
procedure AppendBytes(var Dest: TBytes; const Source: TBytes);
var
  DestLength, SourceLength: Integer;
begin
  // Get the lengths of the source and destination arrays
  DestLength := Length(Dest);
  SourceLength := Length(Source);

  // Resize the destination array to accommodate the source array
  SetLength(Dest, DestLength + SourceLength);

  // Copy the elements from the source array to the destination array
  Move(Source[0], Dest[DestLength], SourceLength);
end;

function HexToByteArray(const HexString: string): TBytes;
begin
  SetLength(Result, Length(HexString) div 2);
  HexToBin(PChar(HexString), @Result[0], Length(Result));
end;
function UInt32ToBytes(value: UInt32): TBytes;
begin
  SetLength(Result, SizeOf(value));
  Move(value, Result[0], SizeOf(value));
end;
function BytesToUInt32(const Bytes: TBytes): UInt32;
var
  I: Integer;
begin
  Result := 0;
  for I := High(Bytes) downto Low(Bytes) do
    Result := (Result shl 8) or Bytes[I];
end;
function ReplaceBytes(const Source: TBytes; const OldPattern, NewPattern: TBytes): TBytes;
var
  SourceIndex, OldPatternIndex, NewPatternIndex: Integer;
begin
  Result := Source;
  SourceIndex := 0;

  while SourceIndex <= High(Source) do
  begin
    OldPatternIndex := 0;

    while (OldPatternIndex <= High(OldPattern)) and (Source[SourceIndex + OldPatternIndex] = OldPattern[OldPatternIndex]) do
      Inc(OldPatternIndex);

    if OldPatternIndex > High(OldPattern) then
    begin
      // Old pattern found, replace it with the new pattern
      SetLength(Result, Length(Result) - Length(OldPattern) + Length(NewPattern));
      Move(NewPattern[0], Result[SourceIndex], Length(NewPattern) * SizeOf(Byte));
      Inc(SourceIndex, Length(NewPattern));
    end
    else
      Inc(SourceIndex);
  end;
end;
end.
