unit ViewModel.Company;

interface
uses
  Model.Company, Generics.Collections, MVVM.ViewModel;

type
  TCompanyViewModel = class
  private
    FOriginalCompany : TCompany;
    FCompany : TCompany;
    FDoSaveCompany: TModelObjectCommand<TCompanyViewModel, TCompany>;
    FDoCancelCompany: TModelObjectCommand<TCompanyViewModel, TCompany>;
    function GetCanSave: Boolean;
  public
    constructor Create(ACompany : TCompany); virtual;
    destructor Destroy; override;
    procedure Save;
    procedure Cancel;
    property Company : TCompany read FCompany;
    property CanSave : Boolean read GetCanSave;
    property DoSaveCompany : TModelObjectCommand<TCompanyViewModel, TCompany> read FDoSaveCompany write FDoSaveCompany;
    property DoCancelCompany : TModelObjectCommand<TCompanyViewModel, TCompany> read FDoCancelCompany write FDoCancelCompany;
  end;

implementation

{ TCompanyViewModel }

procedure TCompanyViewModel.Cancel;
begin
  // don't assign the staging back to FOriginalCompany
  if Assigned(FDoCancelCompany) then
    FDoCancelCompany(self, FOriginalCompany);
end;

constructor TCompanyViewModel.Create(ACompany: TCompany);
begin
  FOriginalCompany := ACompany;
  FCompany := TCompany.Create;
  FCompany.Assign(FOriginalCompany);
end;

destructor TCompanyViewModel.Destroy;
begin
  FCompany.Free;
  inherited;
end;

function TCompanyViewModel.GetCanSave: Boolean;
begin
  Result := FCompany.IsValid
end;

procedure TCompanyViewModel.Save;
begin
  FOriginalCompany.Assign(FCompany);
  if Assigned(FDoSaveCompany) then
    FDoSaveCompany(self, FOriginalCompany);
end;

end.
