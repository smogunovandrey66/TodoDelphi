program todo;

uses
  System.StartUpCopy,
  FMX.Forms,
  unMain in 'unMain.pas' {FormMain},
  unAddFrame in 'Frames\unAddFrame.pas' {FrameAdd: TFrame},
  unDataModule in 'Data\unDataModule.pas' {DataModuleMain: TDataModule},
  unTaskItemFrame in 'Frames\unTaskItemFrame.pas' {Frame1: TFrame},
  unTaskItem in 'Model\unTaskItem.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TDataModuleMain, DataModuleMain);
  Application.Run;
end.
