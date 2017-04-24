unit Common.ObjectStore;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, Aurelius.Drivers.Interfaces, Aurelius.Drivers.FireDAC,
  Aurelius.SQL.SQLite, Aurelius.Engine.DatabaseManager, Aurelius.Engine.ObjectManager,
  FireDAC.VCLUI.Wait, FireDAC.DApt, Aurelius.Schema.SQLite;

type
  TObjectStore = class(TDataModule)
    CrmvvmConnection: TFDConnection;
    procedure DataModuleDestroy(Sender: TObject);
  private
    FDBMgr : TDatabaseManager;
    FManager : TObjectManager;
    FTesting: boolean;
    function GetManager: TObjectManager;
    procedure SetTesting(const Value: boolean);
  protected
    function GetDBMgr: TDatabaseManager;
    property DBMgr : TDatabaseManager read GetDBMgr;
  public
    constructor Create(AOwner: TComponent; Testing : boolean = False); reintroduce; overload;
    property Testing : boolean read FTesting write SetTesting;
    property Manager : TObjectManager read GetManager;
  end;

function ObjectStore : TObjectStore;
procedure CreateObjectStore(Testing : Boolean = False);
procedure DestroyObjectStore;

implementation
uses
  IOUtils;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}
var
  UObjectStore: TObjectStore;

function ObjectStore : TObjectStore;
begin
  if not Assigned(UObjectStore) then
    CreateObjectStore;
  Result := UObjectStore;
end;

procedure CreateObjectStore(Testing : Boolean = False);
begin
  if not Assigned(UObjectStore) then
     UObjectStore := TObjectStore.create(nil, Testing);
end;

procedure DestroyObjectStore;
begin
  FreeAndNil(UObjectStore);
end;



constructor TObjectStore.Create(AOwner: TComponent; Testing : boolean);
begin
  inherited Create(AOwner);
  self.Testing := Testing;
end;

procedure TObjectStore.DataModuleDestroy(Sender: TObject);
begin
  FManager.Free;
  FDBMgr.Free;
end;

function TObjectStore.GetDBMgr: TDatabaseManager;
begin
  if not Assigned(FDBMgr) then
    FDBMgr := TDatabaseManager.Create(TFireDACConnectionAdapter.Create(CrmvvmConnection, False));
  Result := FDBMgr;
end;

function TObjectStore.GetManager: TObjectManager;
begin
  if not Assigned(FManager) then
    FManager := TObjectManager.create(DBMgr.Connection);
  Result := FManager;
end;

procedure TObjectStore.SetTesting(const Value: boolean);
begin
  FTesting := Value;
  if not Testing then
  begin
    CrmvvmConnection.Params.Database := TPath.GetDirectoryName(ParamStr(0)) + PathDelim + 'crmvvm.sqlite';
    if not TFile.Exists(CrmvvmConnection.Params.Database) then
      DBMgr.BuildDatabase;
    if not DBMgr.ValidateDatabase then
      DBMgr.UpdateDatabase;
  end
  else
  begin
    CrmvvmConnection.Params.Database := ':memory:';
    DBMgr.BuildDatabase;
  end;
end;

initialization
finalization
  DestroyObjectStore;

end.
