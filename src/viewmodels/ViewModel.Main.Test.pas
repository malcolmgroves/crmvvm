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
    [Test]
    procedure TestDeleteUnconfirmed;
    [Test]
    procedure TestOnContactsChangedAfterAdd;
    [Test]
    procedure TestOnContactsChangedAfterDeleteConfirmed;
    [Test]
    procedure TestNoOnContactsChangedAfterDeleteUnconfirmed;
//    [Test]
//    procedure TestActiveViewDeleteDelegationForContact;
//    [Test]
//    procedure TestActiveViewDeleteDelegationForCompany;
//    [Test]
//    [TestCase('CompanyToContact', 'Company,Contact,Contact')]
//    [TestCase('ContactToCompany', 'Contact,Company,Company')]
//    [TestCase('ContactToContact', 'Contact,Contact,Contact')]
//    procedure TestChangeView(InitialView, NewView, ExpectedResult : TActiveViewModel);

  end;

implementation
uses
  Model.Contact, ViewModel.Contact, Model.Company, Common.ObjectStore, Common.Messages, System.Messaging;

procedure TMainViewModelTest.Setup;
begin
  CreateObjectStore(True);
  FViewModel := TMainViewModel.Create;
  FViewModel.ContactsViewModel.DoEditContact := procedure(ContactViewModel : TContactViewModel)
                                                begin
                                                  ContactViewModel.Save;
                                                end;
end;

procedure TMainViewModelTest.TearDown;
begin
  FViewModel.Free;
  DestroyObjectStore;
end;

//procedure TMainViewModelTest.TestActiveViewDeleteDelegationForCompany;
//begin
//  FViewModel.ActiveViewModel := TActiveViewModel.Companies;
//  FViewModel.ConfirmDeleteContact := function(ViewModel : TMainViewModel; Contact : TContact): boolean
//                                     begin
//                                       Result := False;
//                                       Assert.IsTrue(False);
//                                     end;
//  FViewModel.ConfirmDeleteCompany := function(ViewModel : TMainViewModel; Company : TCompany): boolean
//                                     begin
//                                       Result := False;
//                                       Assert.IsTrue(True); //Assert.Pass gives me Invalid Pointer operations
//                                     end;
//  FviewModel.Delete;
//end;
//
//procedure TMainViewModelTest.TestActiveViewDeleteDelegationForContact;
//begin
//  FViewModel.ActiveViewModel := TActiveViewModel.Contacts;
//  FViewModel.ConfirmDeleteContact := function(ViewModel : TMainViewModel; Contact : TContact): boolean
//                                     begin
//                                       Result := False;
//                                       Assert.IsTrue(True); //Assert.Pass gives me Invalid Pointer operations
//                                     end;
//  FViewModel.ConfirmDeleteCompany := function(ViewModel : TMainViewModel; Company : TCompany): boolean
//                                     begin
//                                       Result := False;
//                                       Assert.IsTrue(False);
//                                     end;
//  FviewModel.Delete;
//end;

procedure TMainViewModelTest.TestAdd;
var
  LCount : Integer;
begin
  LCount := FViewModel.ContactsViewModel.ContactCount;
  FViewModel.ContactsViewModel.NewContact;
  Assert.AreEqual(LCount + 1, FViewModel.ContactsViewModel.ContactCount);
end;

//procedure TMainViewModelTest.TestChangeView(InitialView, NewView,
//  ExpectedResult: TActiveViewModel);
//begin
//  FViewModel.ActiveViewModel := InitialView;
//  FViewModel.ActiveViewModel := NewView;
//  Assert.AreEqual<TActiveViewModel>(ExpectedResult, FViewModel.ActiveViewModel);
//end;

procedure TMainViewModelTest.TestDeleteConfirmed;
var
  LContact : TContact;
  LCount : Integer;
begin
  FViewModel.ActiveViewModel := TActiveViewModel.Contacts;
  LContact := FviewModel.ContactsViewModel.NewContact;
  LCount := FViewModel.ContactsViewModel.ContactCount;

  FViewModel.ContactsViewModel.QueryCurrentContact := function : TContact
                                                      begin
                                                        Result := LContact;
                                                      end;

  FViewModel.ContactsViewModel.ConfirmDeleteContact := function(Contact : TContact): boolean
                                                       begin
                                                         Result := True;
                                                       end;
  FViewModel.Delete;
  Assert.AreEqual(LCount - 1, FViewModel.ContactsViewModel.ContactCount);
end;

procedure TMainViewModelTest.TestDeleteUnconfirmed;
var
  LContact : TContact;
  LCount : Integer;
begin
  FViewModel.ActiveViewModel := TActiveViewModel.Contacts;
  LContact := FviewModel.ContactsViewModel.NewContact;
  LCount := FViewModel.ContactsViewModel.ContactCount;

  FViewModel.ContactsViewModel.QueryCurrentContact := function : TContact
                                                      begin
                                                        Result := LContact;
                                                      end;

  FViewModel.ContactsViewModel.ConfirmDeleteContact := function(Contact : TContact): boolean
                                                       begin
                                                         Result := False;
                                                       end;
  FViewModel.Delete;
  Assert.AreEqual(LCount, FViewModel.ContactsViewModel.ContactCount);
end;

procedure TMainViewModelTest.TestEditContactDelegation;
var
  LContact : TContact;
begin
  FViewModel.ActiveViewModel := TActiveViewModel.Contacts;
  LContact := FViewModel.ContactsViewModel.NewContact;
  FViewModel.ContactsViewModel.QueryCurrentContact := function : TContact
                                                      begin
                                                        Result := LContact;
                                                      end;
  FViewModel.ContactsViewModel.DoEditContact := procedure(ContactViewModel : TContactViewModel)
                                                begin
                                                  ContactViewModel.ModelObject.Firstname := 'Barney';
                                                  ContactViewModel.Save;
                                                end;
  FviewModel.Edit;
  Assert.AreEqual('Barney', LContact.Firstname);
end;

procedure TMainViewModelTest.TestEditContactDelegationAfterCancel;
var
  LContact : TContact;
begin
  FViewModel.ActiveViewModel := TActiveViewModel.Contacts;
  LCOntact := TContact.Create;
  LContact.Firstname := 'Fred';
  FViewModel.ContactsViewModel.AddContact(LContact);
  FViewModel.ContactsViewModel.QueryCurrentContact := function : TContact
                                                      begin
                                                        Result := LContact;
                                                      end;
  FViewModel.ContactsViewModel.DoEditContact := procedure(ContactViewModel : TContactViewModel)
                                                begin
                                                  ContactViewModel.ModelObject.Firstname := 'Barney';
                                                  ContactViewModel.Cancel;
                                                end;
  FViewModel.Edit;
  Assert.AreEqual('Fred', LContact.Firstname);
end;

procedure TMainViewModelTest.TestNoOnContactsChangedAfterDeleteUnconfirmed;
var
  LContact : TContact;
begin
  FViewModel.ActiveViewModel := TActiveViewModel.Contacts;
  LContact := FviewModel.ContactsViewModel.NewContact;
  FViewModel.ContactsViewModel.QueryCurrentContact := function : TContact
                                                      begin
                                                        Result := LContact;
                                                      end;

  FViewModel.ContactsViewModel.ConfirmDeleteContact := function(Contact : TContact): boolean
                                                       begin
                                                         Result := False;
                                                       end;
  MessageManager.SubscribeToMessage(TOnContactsUpdated, procedure(const Sender : TObject; const M : TMessageBase)
                                                        begin
                                                          Assert.Fail;
                                                        end);
  FViewModel.Delete;
end;

procedure TMainViewModelTest.TestOnContactsChangedAfterAdd;
begin
  MessageManager.SubscribeToMessage(TOnContactsUpdated, procedure(const Sender : TObject; const M : TMessageBase)
                                                        begin
                                                          Assert.IsTrue(True);
                                                        end);
  FViewModel.ContactsViewModel.NewContact;
end;

procedure TMainViewModelTest.TestOnContactsChangedAfterDeleteConfirmed;
var
  LContact : TContact;
begin
  FViewModel.ActiveViewModel := TActiveViewModel.Contacts;
  LContact := FviewModel.ContactsViewModel.NewContact;
  FViewModel.ContactsViewModel.QueryCurrentContact := function : TContact
                                                      begin
                                                        Result := LContact;
                                                      end;
  FViewModel.ContactsViewModel.ConfirmDeleteContact := function (Contact : TContact): boolean
                                                       begin
                                                         Result := True;
                                                       end;
  MessageManager.SubscribeToMessage(TOnContactsUpdated, procedure(const Sender : TObject; const M : TMessageBase)
                                                        begin
                                                          Assert.IsTrue(True);
                                                        end);
  FViewModel.Delete;
end;

initialization
  TDUnitX.RegisterTestFixture(TMainViewModelTest);
end.
