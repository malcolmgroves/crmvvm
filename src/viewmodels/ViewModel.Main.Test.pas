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
    [Test]
    procedure TestDeleteConfirmed;
    procedure TestDeleteUnconfirmed;
  end;

implementation
uses
  Model.Contact, ViewModel.Contact, Common.ObjectStore;

procedure TMainViewModelTest.Setup;
begin
  CreateObjectStore(True);
  FViewModel := TMainViewModel.Create;
  FViewModel.OnEditContact := procedure(ViewModel : TMainViewModel; ContactViewModel : TContactViewModel)
                              begin
                                ContactViewModel.Save;
                              end;
end;

procedure TMainViewModelTest.TearDown;
begin
  FViewModel.Free;
  DestroyObjectStore;
end;

procedure TMainViewModelTest.TestAdd;
var
  LCount : Integer;
begin
  LCount := FViewModel.ContactCount;
  FViewModel.NewContact;
  Assert.AreEqual(LCount + 1, FViewModel.ContactCount);
end;

procedure TMainViewModelTest.TestDeleteConfirmed;
var
  LContact : TContact;
  LCount : Integer;
begin
  LContact := FviewModel.NewContact;
  LCount := FViewModel.ContactCount;

  FViewModel.OnConfirmDeleteContact := function(ViewModel : TMainViewModel; Contact : TContact): boolean
                                       begin
                                         Result := True;
                                       end;
  FViewModel.DeleteContact(LContact);
  Assert.AreEqual(LCount - 1, FViewModel.ContactCount);
end;

procedure TMainViewModelTest.TestDeleteUnconfirmed;
var
  LContact : TContact;
  LCount : Integer;
begin
  LContact := FviewModel.NewContact;
  LCount := FViewModel.ContactCount;

  FViewModel.OnConfirmDeleteContact := function(ViewModel : TMainViewModel; Contact : TContact): boolean
                                       begin
                                         Result := False;
                                       end;
  FViewModel.DeleteContact(LContact);
  Assert.AreEqual(LCount, FViewModel.ContactCount);
end;

procedure TMainViewModelTest.TestEditContactDelegation;
var
  LContact : TContact;
begin
  LContact := FViewModel.NewContact;
  FViewModel.OnEditContact := procedure(ViewModel : TMainViewModel; ContactViewModel : TContactViewModel)
                              begin
                                ContactViewModel.Contact.Firstname := 'Barney';
                                ContactViewModel.Save;
                              end;
  FviewModel.EditContact(LContact);
  Assert.AreEqual('Barney', LContact.Firstname);
end;

procedure TMainViewModelTest.TestEditContactDelegationAfterCancel;
var
  LContact : TContact;
begin
  LCOntact := TContact.Create;
  LContact.Firstname := 'Fred';
  FViewModel.AddContact(LContact);
  FViewModel.OnEditContact := procedure(ViewModel : TMainViewModel; ContactViewModel : TContactViewModel)
                              begin
                                ContactViewModel.Contact.Firstname := 'Barney';
                                ContactViewModel.Cancel;
                              end;
  FViewModel.EditContact(LContact);
  Assert.AreEqual('Fred', LContact.Firstname);
end;

initialization
  TDUnitX.RegisterTestFixture(TMainViewModelTest);
end.
