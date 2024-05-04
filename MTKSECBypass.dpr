program MTKSECBypass;

{$R *.dres}

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {MainForm},
  comport_hwd in 'src\Comport\comport_hwd.pas',
  DTSetupApi_hwd in 'src\Comport\DTSetupApi_hwd.pas',
  Thread in 'Thread.pas',
  mediatek in 'src\Mediatek\mediatek.pas',
  preloader in 'src\Mediatek\preloader.pas',
  brom_config in 'src\Mediatek\brom_config.pas',
  libusb in 'src\Comport\libusb.pas',
  devicehandler in 'src\Mediatek\devicehandler.pas',
  RHelper in 'src\Core\RHelper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMForm, MForm);
  Application.Run;

end.
