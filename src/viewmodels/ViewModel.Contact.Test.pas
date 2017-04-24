unit ViewModel.Contact.Test;

interface
uses
  DUnitX.TestFramework, ViewModel.Contact, Model.Contact, Model.COmpany;

type

  [TestFixture]
  TContactViewModelTest = class(TObject)
  private
    FContact : TContact;
    FCompany : TCompany;
    FViewModel : TContactViewModel;
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
  cFirstname = 'Fred';
  cLastname = 'Flintstone';

procedure TContactViewModelTest.Setup;
begin
  FCompany := TCompany.Create;
  FCompany.Name := 'Code Partners Pty Ltd';
  FCompany.Web := 'https://www.code-partners.com';
  FCompany.ID := 1;

  FContact := TContact.Create;
  FContact.Firstname := cFirstname;
  FContact.Lastname := cLastname;
  FContact.Company := FCompany;
  FViewModel := TContactViewModel.Create(FContact);
end;

procedure TContactViewModelTest.TearDown;
begin
  FViewModel.Free;
  FContact.Free;
  FCompany.Free;
end;


procedure TContactViewModelTest.TestCancel;
begin
  FViewModel.DoSaveContact := procedure (ViewModel : TContactViewModel; Contact : TContact)
                              begin
                                Assert.Fail;
                              end;
  FViewModel.Contact.Firstname := 'Barney';
  FViewModel.Contact.Lastname := 'Rubble';
  FViewModel.Cancel;
end;

procedure TContactViewModelTest.TestSave;
begin
  FViewModel.DoSaveContact := procedure (ViewModel : TContactViewModel; Contact : TContact)
                              begin
                                Assert.AreEqual('Barney', FViewModel.Contact.Firstname);
                                Assert.AreEqual('Rubble', FViewModel.Contact.Lastname);
                              end;
  FViewModel.Contact.Firstname := 'Barney';
  FViewModel.Contact.Lastname := 'Rubble';
  FViewModel.Save;
end;


initialization
  TDUnitX.RegisterTestFixture(TContactViewModelTest);
end.
