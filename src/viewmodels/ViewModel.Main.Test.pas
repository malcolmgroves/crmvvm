unit ViewModel.Main.Test;

interface
uses
  DUnitX.TestFramework, ViewModel.Main;

type

  [TestFixture]
  TMainViewModelTest = class(TObject)
  private
    FViewModel : TMainViewModel;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestAdd;
    [Test]
    procedure TestEditContactDelegation;
    [Test]
    procedure TestEditContactDelegationAfterCancel;
  end;

implementation
uses
  Model.Contact, ViewModel.Contact;

procedure TMainViewModelTest.Setup;
begin
  FViewModel := TMainViewModel.Create;
  FViewModel.OnEditContact := procedure(ViewModel : TMainViewModel; ContactViewModel : TContactViewModel)
                              begin
                                ContactViewModel.Save;
                              end;
end;

procedure TMainViewModelTest.TearDown;
begin
  FViewModel.Free;
end;

procedure TMainViewModelTest.TestAdd;
var
  LCount : Integer;
begin
  LCount := FViewModel.ContactCount;
  FViewModel.Add;
  Assert.AreEqual(LCount + 1, FViewModel.ContactCount);
end;

procedure TMainViewModelTest.TestEditContactDelegation;
var
  LContact : TContact;
begin
  LContact := TContact.Create;
  try
    LContact.FirstName := 'Fred';
    FViewModel.OnEditContact := procedure(ViewModel : TMainViewModel; ContactViewModel : TContactViewModel)
                                begin
                                  ContactViewModel.Contact.Firstname := 'Barney';
                                  ContactViewModel.Save;
                                end;
    FViewModel.EditContact(LContact);
    Assert.AreEqual('Barney', LContact.Firstname);
  finally
    LContact.Free;
  end;
end;

procedure TMainViewModelTest.TestEditContactDelegationAfterCancel;
var
  LContact : TContact;
begin
  LContact := TContact.Create;
  try
    LContact.FirstName := 'Fred';
    FViewModel.OnEditContact := procedure(ViewModel : TMainViewModel; ContactViewModel : TContactViewModel)
                                begin
                                  ContactViewModel.Contact.Firstname := 'Barney';
                                  ContactViewModel.Cancel;
                                end;
    FViewModel.EditContact(LContact);
    Assert.AreEqual('Fred', LContact.Firstname);
  finally
    LContact.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TMainViewModelTest);
end.
