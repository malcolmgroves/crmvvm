unit ViewModel.Contact;

interface
uses
  Model.Contact, Generics.Collections, MVVM.ViewModel, Model.Company;

type
  TContactViewModel = class(TBaseModalEditViewModel<TContactViewModel, TContact>)
  private
    FCompanies: TCompanies;
  protected
    function GetCanSave: Boolean; override;
    procedure DoAssign(SourceObject, TargetObject : TContact); override;
  public
    constructor Create(AContact : TContact); override;
    destructor Destroy; override;
    function GetCompanyByID(const ID : Integer) : TCompany;
    property AllCompanies : TCompanies read FCompanies;
  end;

implementation

{ TContactViewModel }

uses Common.ObjectStore;

constructor TContactViewModel.Create(AContact: TContact);
begin
  inherited Create(AContact);
  FCompanies := TCompanies.Create(False);
  FCompanies.LoadFromList(ObjectStore.Manager.Find<TCompany>.List);
end;

destructor TContactViewModel.Destroy;
begin
  FCompanies.Free;
  inherited;
end;

procedure TContactViewModel.DoAssign(SourceObject, TargetObject: TContact);
begin
  TargetObject.Assign(SourceObject);
end;

function TContactViewModel.GetCanSave: Boolean;
begin
  Result := FScratchObject.IsValid
end;

function TContactViewModel.GetCompanyByID(const ID: Integer): TCompany;
begin
  Result := ObjectStore.Manager.Find<TCompany>(ID);
end;


end.
