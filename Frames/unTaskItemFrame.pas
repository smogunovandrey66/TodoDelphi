unit unTaskItemFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Gestures, FMX.Controls.Presentation;

type
  TFrame1 = class(TFrame)
    chTaskItem: TCheckBox;
    GestureManager1: TGestureManager;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
