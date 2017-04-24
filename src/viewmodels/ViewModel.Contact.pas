unit ViewModel.Contact;

interface
uses
  Model.Contact, Generics.Collections, MVVM.ViewModel, Model.Company;

type
  TContactViewModel = class
  private
    FOriginalContact : TContact;
    FContact : TContact;
    FDoSaveContact: TModelObjectCommand<TContactViewModel, TContact>;
    FDoCancelContact: TModelObjectCommand<TContactViewModel, TContact>;
    FCompanies: TCompanies;
    function GetCanSave: Boolean;
  public
    constructor Create(AContact : TContact); virtual;
    destructor Destroy; override;
    procedure Save;
    procedure Cancel;
    function GetCompanyByID(const ID : Integer) : TCompany;
    property Contact : TContact read FContact;
    property AllCompanies : TCompanies read FCompanies;
    property CanSave : Boolean read GetCanSave;
    property DoSaveContact : TModelObjectCommand<TContactViewModel, TContact> read FDoSaveContact write FDoSaveContact;
    property DoCancelContact : TModelObjectCommand<TContactViewModel, TContact> read FDoCancelContact write FDoCancelContact;
  end;

implementation

{ TContactViewModel }

uses Common.ObjectStore;

procedure TContactViewModel.Cancel;
begin
  // don't assign the staging back to FOriginalContact
  if Assigned(FDoCancelContact) then
    FDoCancelContact(self, FOriginalContact);
end;

constructor TContactViewModel.Create(AContact: TContact);
var
  LCompanies : TList<TCompany>;
begin
  FOriginalContact := AContact;
  FContact := TContact.Create;
  FContact.Assign(FOriginalContact);

  FCompanies := TCompanies.Create(False);
  LCompanies := ObjectStore.Manager.Find<TCompany>.List;
  try
    FCompanies.LoadFromList(LCompanies);
  finally
    LCompanies.Free;
  end;
end;

destructor TContactViewModel.Destroy;
begin
  FContact.Free;
  FCompanies.Free;
  inherited;
end;

function TContactViewModel.GetCanSave: Boolean;
begin
  Result := FContact.IsValid
end;

function TContactViewModel.GetCompanyByID(const ID: Integer): TCompany;
begin
  Result := ObjectStore.Manager.Find<TCompany>(ID);
end;

procedure TContactViewModel.Save;
begin
  FOriginalContact.Assign(FContact);
  if Assigned(FDoSaveContact) then
    FDoSaveContact(self, FOriginalContact);
end;

end.
