unit ViewModel.Company;

interface
uses
  Model.Company, Generics.Collections, MVVM.ViewModel;

type
  TCompanyViewModel = class(TBaseModalEditViewModel<TCompanyViewModel, TCompany>)
  protected
    function GetCanSave: Boolean; override;
    procedure DoAssign(SourceObject, TargetObject : TCompany); override;
  end;

implementation

{ TCompanyViewModel }

procedure TCompanyViewModel.DoAssign(SourceObject, TargetObject: TCompany);
begin
  TargetObject.Assign(SourceObject);
end;

function TCompanyViewModel.GetCanSave: Boolean;
begin
  Result := FScratchObject.IsValid
end;

end.
