program todo;

uses
  System.StartUpCopy,
  FMX.Forms,
  unMain in 'unMain.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
