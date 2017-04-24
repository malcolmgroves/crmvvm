unit ViewModel.Company.Test;

interface
uses
  DUnitX.TestFramework, ViewModel.Company, Model.Company;

type

  [TestFixture]
  TCompanyViewModelTest = class(TObject)
  private
    FCompany : TCompany;
    FViewModel : TCompanyViewModel;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestSave;
    [Test]
    procedure TestCancel;
  end;

implementation

const
  cName = 'Acme';

procedure TCompanyViewModelTest.Setup;
begin
  FCompany := TCompany.Create;
  FCompany.Name := cName;
  FViewModel := TCompanyViewModel.Create(FCompany);
end;

procedure TCompanyViewModelTest.TearDown;
begin
  FViewModel.Free;
  FCompany.Free;
end;


procedure TCompanyViewModelTest.TestCancel;
begin
  FViewModel.DoSaveModelObject := procedure (ViewModel : TCompanyViewModel; Company : TCompany)
                                  begin
                                    Assert.Fail;
                                  end;
  FViewModel.ModelObject.Name := 'Amazon';
  FViewModel.Cancel;
end;

procedure TCompanyViewModelTest.TestSave;
begin
  FViewModel.DoSaveModelObject := procedure (ViewModel : TCompanyViewModel; Company : TCompany)
                                  begin
                                    Assert.AreEqual('Amazon', FViewModel.ModelObject.Name);
                                  end;
  FViewModel.ModelObject.Name := 'Amazon';
  FViewModel.Save;
end;


initialization
  TDUnitX.RegisterTestFixture(TCompanyViewModelTest);
end.

