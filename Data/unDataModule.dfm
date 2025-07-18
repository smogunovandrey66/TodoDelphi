object DataModuleMain: TDataModuleMain
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 480
  Width = 640
  object FDConnectionMain: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 72
    Top = 56
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 56
    Top = 152
  end
  object qryInsert: TFDQuery
    Connection = FDConnectionMain
    SQL.Strings = (
      'INSERT INTO tasks(title, create_at) VALUES(:Title, :CreateAt);'
      'SELECT last_insert_rowid() as InsertedId')
    Left = 144
    Top = 336
    ParamData = <
      item
        Name = 'TITLE'
        ParamType = ptInput
      end
      item
        Name = 'CREATEAT'
        ParamType = ptInput
      end>
  end
  object qryDelete: TFDQuery
    Connection = FDConnectionMain
    SQL.Strings = (
      'DELETE FROM tasks WHERE id = :Id')
    Left = 216
    Top = 336
    ParamData = <
      item
        Name = 'ID'
        ParamType = ptInput
      end>
  end
  object qryUpdate: TFDQuery
    Connection = FDConnectionMain
    SQL.Strings = (
      'UPDATE tasks SET isDone = iif(isDone = 0, 1, 0) WHERE id = :Id')
    Left = 288
    Top = 336
    ParamData = <
      item
        Name = 'ID'
        ParamType = ptInput
      end>
  end
  object qryLoad: TFDQuery
    Connection = FDConnectionMain
    SQL.Strings = (
      'SELECT * FROM tasks;')
    Left = 368
    Top = 344
  end
end
