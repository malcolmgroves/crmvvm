unit ViewModel.Sub.Companies;

interface
uses
  Model.Company, Generics.Collections, ViewModel.Company, MVVM.ViewModel;

type
  TCompaniesSubViewModel = class
  private
    FCompanies : TCompanies;
    FDoEditCompany: TViewModelCommand<TCompanyViewModel>;
    FConfirmDeleteCompany: TModelObjectConfirm<TCompany, boolean>;
    FQueryCurrentCompany: TViewModelQuery<TCompany>;
    function GetCompanies: TEnumerable<TCompany>;
    function GetCompanyCount: Integer;
    procedure DoOnCompaniesUpdated;
    procedure DoOnEditCompany(CompanyViewModel : TCompanyViewModel);
    function CurrentCompany : TCompany;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure AddCompany(Company : TCompany);
    function NewCompany : TCompany;
    procedure Delete;
    procedure Edit;
    property Companies : TEnumerable<TCompany> read GetCompanies;
    property CompanyCount: Integer read GetCompanyCount;
    property DoEditCompany : TViewModelCommand<TCompanyViewModel> read FDoEditCompany write FDoEditCompany;
    property ConfirmDeleteCompany : TModelObjectConfirm<TCompany, boolean> read FConfirmDeleteCompany write FConfirmDeleteCompany;
    property QueryCurrentCompany : TViewModelQuery<TCompany> read FQueryCurrentCompany write FQueryCurrentCompany;
  end;

implementation
uses Common.ObjectStore, Common.Messages, System.Messaging, Common.Exceptions;


procedure TCompaniesSubViewModel.AddCompany(Company: TCompany);
var
  LCompanyViewModel : TCompanyViewModel;
begin
  LCompanyViewModel := TCompanyViewModel.Create(Company);
  LCompanyViewModel.DoSaveModelObject := procedure(Company : TCompany)
                                         begin
                                           FCompanies.AddCompany(Company);
                                           ObjectStore.Manager.Save(Company);
                                           DoOnCompaniesUpdated;
                                         end;
  LCompanyViewModel.DoCancelModelObject := procedure(Company : TCompany)
                                           begin
                                             Company.Free;
                                           end;
  DoOnEditCompany(LCompanyViewModel);
end;

constructor TCompaniesSubViewModel.Create;
begin
  FCompanies := TCompanies.Create(False);
  FCompanies.LoadFromList(ObjectStore.Manager.Find<TCompany>.List);
  DoOnCompaniesUpdated;
end;

function TCompaniesSubViewModel.CurrentCompany: TCompany;
begin
  if Assigned(FQueryCurrentCompany) then
    Result := FQueryCurrentCompany
  else
    raise ViewModelMissingDelegateException.Create('QueryCurrentCompany Delegate not Assigned');
end;

procedure TCompaniesSubViewModel.Delete;
var
  LCompany : TCompany;
begin
  if Assigned(FConfirmDeleteCompany) then
  begin
    LCompany := CurrentCompany;
    if FConfirmDeleteCompany(LCompany) then
    begin
      FCompanies.DeleteCompany(LCompany);
      ObjectStore.Manager.Remove(LCompany);
      DoOnCompaniesUpdated;
    end;
  end;
end;

destructor TCompaniesSubViewModel.Destroy;
begin
  FCompanies.Free;
  inherited;
end;

procedure TCompaniesSubViewModel.DoOnCompaniesUpdated;
begin
  MessageManager.SendMessage(self, TOnCompaniesUpdated.Create(self, False));
end;

procedure TCompaniesSubViewModel.DoOnEditCompany(
  CompanyViewModel: TCompanyViewModel);
begin
  if Assigned(FDoEditCompany) then
    FDoEditCompany(CompanyViewModel);
end;

procedure TCompaniesSubViewModel.Edit;
var
  LCompany : TCompany;
  LCompanyViewModel : TCompanyViewModel;
begin
  LCompany := CurrentCompany;
  LCompanyViewModel := TCompanyViewModel.Create(LCompany);
  LCompanyViewModel.DoSaveModelObject := procedure(Company : TCompany)
                                         begin
                                           ObjectStore.Manager.Flush(Company);
                                         end;
  DoOnEditCompany(LCompanyViewModel);
end;

function TCompaniesSubViewModel.GetCompanies: TEnumerable<TCompany>;
begin
  Result := FCompanies.GetEnumerable;
end;

function TCompaniesSubViewModel.GetCompanyCount: Integer;
begin
  Result := FCompanies.Count;
end;

function TCompaniesSubViewModel.NewCompany: TCompany;
begin
  Result := TCompany.Create;
  AddCompany(Result);
end;

end.
