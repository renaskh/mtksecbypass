unit Thread;

interface

uses
  System.Classes, SysUtils, Windows;

type
  TMyThread = class(TThread)
  private
    FCancelled: Boolean;
  public
    constructor Create;
    procedure Execute; override;
    procedure Cancel;
    property Cancelled: Boolean read FCancelled;
  end;

implementation

{ TMyThread }

uses
MainForm,Mediatek,Vcl.Graphics;

constructor TMyThread.Create;
begin
  inherited Create(True); // Create suspended
  FreeOnTerminate := True;
  FCancelled := False;
end;

procedure TMyThread.Execute;
var
  i: Integer;
  info : MTKIn;
begin
  try
      connect_device(info);
  except
    on E: Exception do
    begin
        mform.err;
        mform.adlg(E.Message,clred,true);
    end;
  end;
end;

procedure TMyThread.Cancel;
begin
  FCancelled := True;
  Terminate;
end;

end.

