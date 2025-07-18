unit unDataModule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  {$IFDEF ANDROID64}
   Androidapi.Log,
  {$ENDIF}
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, System.IOUtils, FireDAC.Comp.UI, unTaskItem,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, System.DateUtils, Generics.Collections;

type
  TDataModuleMain = class(TDataModule)
    FDConnectionMain: TFDConnection;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    qryInsert: TFDQuery;
    qryDelete: TFDQuery;
    qryUpdate: TFDQuery;
    qryLoad: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FBufferData: TList<TTaskItem>;
    procedure InitDatabase;
  public
    { Public declarations }
    function AddTodoItem(ATitle: string): TTaskItem;
    function DelTodoItem(AId: Integer): Boolean;
    procedure ToggleTodoItem(AId: Integer);
    function GetTasks: TList<TTaskItem>;
  end;

var
  DataModuleMain: TDataModuleMain;

implementation

const
  DB_FILE_NAME = 'todo.db';

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

function TDataModuleMain.AddTodoItem(ATitle: string): TTaskItem;
begin
  {
  INSERT INTO tasks(title, create_at) VALUES(:Title, :CreateAt);
  SELECT last_insert_rowid() as InsertedId
  }
  var LCreateAt := Now;

  qryInsert.Params.ParamByName('Title').Value := ATitle;
  qryInsert.Params.ParamByName('CreateAt').Value := DateToISO8601(LCreateAt);
  qryInsert.Open;

  var LId := qryInsert.FieldByName('InsertedId').AsInteger;

  Result.Id := LId;
  Result.Title := ATitle;
  Result.IsDone := False;
  Result.CreateAt := LCreateAt;
end;

procedure TDataModuleMain.DataModuleCreate(Sender: TObject);
begin
  FDConnectionMain.Params.Database := TPath.Combine(TPath.GetDocumentsPath, DB_FILE_NAME);
  FDConnectionMain.Connected := True;
  InitDatabase;
  {$IFDEF ANDROID64}
  LOGI('Log i text');
  Writeln('writeln text');
  {$ENDIF}
  FBufferData := TList<TTaskItem>.Create;
end;

procedure TDataModuleMain.DataModuleDestroy(Sender: TObject);
begin
  FBufferData.Free;
end;

function TDataModuleMain.DelTodoItem(AId: Integer): Boolean;
begin
  try
    qryDelete.ParamByName('Id').Value := AId;
    qryDelete.ExecSQL;
    Result := True;
  except
    on LException: Exception do begin
      Result := False;
    end;
  end;
end;

function TDataModuleMain.GetTasks: TList<TTaskItem>;
begin
  FBufferData.Clear;

  qryLoad.Close;
  qryLoad.Open;

  while not qryLoad.Eof do begin
    var LItem: TTaskItem;

    LItem.Id := qryLoad.FieldByName('id').AsInteger;
    LItem.Title := qryLoad.FieldByName('title').AsString;
    LItem.IsDone := qryLoad.FieldByName('isDone').AsInteger > 0;
    LItem.CreateAt := ISO8601ToDate(qryLoad.FieldByName('create_at').AsString);

    FBufferData.Add(LItem);

    qryLoad.Next;
  end;

  Result := FBufferData;
end;

procedure TDataModuleMain.InitDatabase;
begin
  FDConnectionMain.ExecSQL('''
    create table if not exists tasks(
      id integer primary key autoincrement,
      title text not null,
      isDone integer default 0,
      create_at text)
  ''');
end;

procedure TDataModuleMain.ToggleTodoItem(AId: Integer);
begin
  qryUpdate.ParamByName('Id').Value := AId;
  qryUpdate.ExecSQL;
end;

end.
