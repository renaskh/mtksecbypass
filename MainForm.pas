unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, comport_hwd, Thread,
  Vcl.ComCtrls;

type
  TMForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    RichEdit1: TRichEdit;
    ProgressBar1: TProgressBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure adlg(const text: string; clr:TColor; nline:boolean);
    procedure ok;
    procedure err;
  private
    { Private declarations }
  public
    mThread : TMyThread;

  end;

var
  MForm: TMForm;

implementation

{$R *.dfm}

procedure TMForm.adlg(const text: string; clr:TColor; nline:boolean);
var
  LastLine: string;
begin
  if nline then
      RichEdit1.Lines.Add(''); // Add a newline

  RichEdit1.SelAttributes.Color := clr;
  RichEdit1.SelStart := Length(RichEdit1.Text); // Move cursor to the end
  RichEdit1.SelText := Text; // Add the text

end;
procedure TMForm.ok;
begin
  adlg(' OK',clgreen,false);
end;
procedure TMForm.err;
begin
  adlg(' failed',clred,false);
end;
procedure TMForm.Button1Click(Sender: TObject);
var
VisiPortai: TEgzistuojantysPortai;
i : Integer;

begin
    richedit1.Clear;
mThread:=TMyThread.Create();
mThread.Start;
//VisiPortai:=GautiEgzistuojanciusPortus;
//if (VisiPortai<>nil) and(high(VisiPortai)>-1) then
//begin
//    for i:=0 to high(VisiPortai)
//    do begin
//       Memo1.Lines.Add('Port name '+VisiPortai[i].FrName);
//       Memo1.Lines.Add('Comport '+VisiPortai[i].COMPort);
//       Memo1.Lines.Add('VID '+VisiPortai[i].VID);
//       Memo1.Lines.Add('PID '+VisiPortai[i].PID);
//    end;
//  end;

end;

procedure TMForm.Button2Click(Sender: TObject);
begin
    mThread.Cancel;
end;

end.
