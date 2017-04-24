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
  end;

implementation
uses
  Model.Contact, ViewModel.Contact, Common.ObjectStore, Common.Messages, System.Messaging;

procedure TMainViewModelTest.Setup;
begin
  CreateObjectStore(True);
  FViewModel := TMainViewModel.Create;
  FViewModel.DoEditContact := procedure(ContactViewModel : TContactViewModel)
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

  FViewModel.ConfirmDeleteContact := function(ViewModel : TMainViewModel; Contact : TContact): boolean
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

  FViewModel.ConfirmDeleteContact := function(ViewModel : TMainViewModel; Contact : TContact): boolean
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
  FViewModel.DoEditContact := procedure(ContactViewModel : TContactViewModel)
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
  FViewModel.DoEditContact := procedure(ContactViewModel : TContactViewModel)
                              begin
                                ContactViewModel.Contact.Firstname := 'Barney';
                                ContactViewModel.Cancel;
                              end;
  FViewModel.EditContact(LContact);
  Assert.AreEqual('Fred', LContact.Firstname);
end;

procedure TMainViewModelTest.TestNoOnContactsChangedAfterDeleteUnconfirmed;
var
  LContact : TContact;
begin
  LContact := FviewModel.NewContact;
  FViewModel.ConfirmDeleteContact := function(ViewModel : TMainViewModel; Contact : TContact): boolean
                                     begin
                                       Result := False;
                                     end;
  MessageManager.SubscribeToMessage(TOnContactsUpdated, procedure(const Sender : TObject; const M : TMessageBase)
                                                        begin
                                                          Assert.Fail;
                                                        end);
  FViewModel.DeleteContact(LContact);
end;

procedure TMainViewModelTest.TestOnContactsChangedAfterAdd;
begin
  MessageManager.SubscribeToMessage(TOnContactsUpdated, procedure(const Sender : TObject; const M : TMessageBase)
                                                        begin
                                                          Assert.IsTrue(True);
                                                        end);
  FViewModel.NewContact;
end;

procedure TMainViewModelTest.TestOnContactsChangedAfterDeleteConfirmed;
var
  LContact : TContact;
begin
  LContact := FviewModel.NewContact;
  FViewModel.ConfirmDeleteContact := function(ViewModel : TMainViewModel; Contact : TContact): boolean
                                     begin
                                       Result := True;
                                     end;
  MessageManager.SubscribeToMessage(TOnContactsUpdated, procedure(const Sender : TObject; const M : TMessageBase)
                                                        begin
                                                          Assert.IsTrue(True);
                                                        end);
  FViewModel.DeleteContact(LContact);
end;

initialization
  TDUnitX.RegisterTestFixture(TMainViewModelTest);
end.
