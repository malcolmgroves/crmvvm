unit Model.Company;

interface
uses
  Generics.Collections, System.Classes, MVVM.Model, Aurelius.Mapping.Attributes;

type
  TCompany = class;

  TCompanies = class(TObjectEnumerable<TCompany>)
  public
    function AddCompany(Company : TCompany): Integer;
    procedure DeleteCompany(Company : TCompany);
  end;

  [Entity]
  [AutoMapping]
  TCompany = class(TPersistent)
  private
    FID: integer;
    FName: string;
    FWeb: string;
    function GetIsValid: boolean;
  protected
  public
    procedure Assign(Source: TPersistent); override;
    property ID: integer read FID write FID;
    property Name: string read FName write FName;
    property Web: string read FWeb write FWeb;
    property IsValid: boolean read GetIsValid;
  end;

implementation
uses
  Model.Exceptions;

{ TCompany }

procedure TCompany.Assign(Source: TPersistent);
begin
  if Source is TCompany then
  begin
    ID := TCompany(Source).ID;
    Name := TCompany(Source).Name;
    Web := TCompany(Source).Web;
  end
  else
    inherited Assign(Source);
end;

function TCompany.GetIsValid: boolean;
begin
  Result := (Length(Name) > 0);
end;


{ TCompanies }

function TCompanies.AddCompany(Company: TCompany): Integer;
begin
  if not Assigned(Company) then
    raise NilParamException.Create('Company passed in is not Assigned');

  if Contains(Company) then
    raise DuplicateObjectException.Create('CompanyList already contains this Company');

  Result := FObjects.Add(Company);
end;

procedure TCompanies.DeleteCompany(Company: TCompany);
begin
  if not Assigned(Company) then
    raise NilParamException.Create('Company passed in is not Assigned');

  if not Contains(Company) then
    raise UnknownObjectException.Create('CompanyList does not contain this Company');

  FObjects.Delete(FObjects.IndexOf(Company));
end;


end.
