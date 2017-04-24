object ObjectStore: TObjectStore
  OldCreateOrder = False
  OnDestroy = DataModuleDestroy
  Height = 461
  Width = 553
  object CrmvvmConnection: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 476
    Top = 245
  end
end
