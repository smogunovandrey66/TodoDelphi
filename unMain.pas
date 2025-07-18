unit unMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.DateUtils,
  FMX.Controls.Presentation, FMX.StdCtrls,
  {$IFDEF ANDROID64}
  Androidapi.Log,
  {$ENDIF}
  FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  Data.Bind.GenData, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.ObjectScope, System.ImageList, FMX.ImgList, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.Edit, unDataModule, unTaskItem, System.Math;

type
  TFormMain = class(TForm)
    ButtonTest: TButton;
    PrototypeBindSourceMain: TPrototypeBindSource;
    BindingsListMain: TBindingsList;
    ListViewMain: TListView;
    PanelBottom: TPanel;
    imglst: TImageList;
    LinkFillControlToField1: TLinkFillControlToField;
    SpeedButton1: TSpeedButton;
    PanelTop: TPanel;
    ButtonAdd: TButton;
    EditTitle: TEdit;
    procedure ButtonTestClick(Sender: TObject);
    procedure ListViewMainItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure ButtonAddClick(Sender: TObject);
    procedure ListViewMainDeletingItem(Sender: TObject; AIndex: Integer;
      var ACanDelete: Boolean);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure AddTaskItem(ATaskItem: TTaskItem);
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.fmx}
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.XLgXhdpiTb.fmx ANDROID}

procedure TFormMain.AddTaskItem(ATaskItem: TTaskItem);
begin
  var LListItem := ListViewMain.Items.Insert(0);
  LListItem.Data['Image'] := IfThen(ATaskItem.IsDone, 1);
  LListItem.Data['Text'] := ATaskItem.Title;
  LListItem.Data['Id'] := ATaskItem.Id;

  var LCompTitle := LListItem.Objects.FindObjectT<TListItemText>('Text');

  if ATaskItem.IsDone then
    LCompTitle.Font.Style := [TFontStyle.fsStrikeOut];
end;

procedure TFormMain.ButtonAddClick(Sender: TObject);
begin
  var LTitle := EditTitle.Text.Trim;
  if not LTitle.IsEmpty then begin
    var LTaskItem := DataModuleMain.AddTodoItem(LTitle);
    AddTaskItem(LTAskItem);
    EditTitle.Text := '';
  end;
end;

procedure TFormMain.ButtonTestClick(Sender: TObject);
begin
  {$IFDEF ANDROID64}
  LOGI('log i');
  LOGE('log e');
  LOGW('log w');
  LOGF('log f');
  {$ENDIF}

  Writeln('writeln text');
  ListViewMain.HeaderAppearanceName := 'aaaa';
  ListViewMain.FooterAppearanceName := 'bbbb';
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  for var LItem in DataModuleMain.GetTasks do begin
    AddTaskItem(LItem);
  end;
end;

procedure TFormMain.ListViewMainDeletingItem(Sender: TObject; AIndex: Integer;
  var ACanDelete: Boolean);
begin
  var LListItem := ListViewMain.Items[AIndex];
  var LDelIndex := LListItem.Data['Id'].AsInteger;

  ACanDelete := DataModuleMain.DelTodoItem(LDelIndex);
end;

procedure TFormMain.ListViewMainItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  //
  var LListItem := ListViewMain.Items[ItemIndex];
  var LTValueIndex := LListItem.Data['Image'];
  var LId := LListItem.Data['Id'].AsInteger;

  var LCompTitle := LListItem.Objects.FindObjectT<TListItemText>('Text');

  if LTValueIndex.AsInteger = 0 then begin
    LListItem.Data['Image'] := 1;
    LCompTitle.Font.Style := [TFontStyle.fsStrikeOut];
  end
    else begin
      LListItem.Data['Image'] := 0;
      LCompTitle.Font.Style := [];
    end;

  DataModuleMain.ToggleTodoItem(LId);
end;

end.
