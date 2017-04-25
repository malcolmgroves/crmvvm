unit ViewModel.Sub.Contacts;

interface
uses
  Model.Contact, Generics.Collections, ViewModel.Contact, MVVM.ViewModel;

type
  TContactsSubViewModel = class
  private
    FContacts : TContacts;
    FDoEditContact: TViewModelCommand<TContactViewModel>;
    FConfirmDeleteContact: TModelObjectConfirm<TContact, boolean>;
    FQueryCurrentContact: TViewModelQuery<TContact>;
    procedure DoOnContactsUpdated;
    procedure DoOnEditContact(ContactViewModel : TContactViewModel);
    function GetContactCount: Integer;
    function CurrentContact : TContact;
    function GetContacts: TEnumerable<TContact>;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure AddContact(Contact : TContact);
    function NewContact : TContact;
    procedure Delete;
    procedure Edit;
    property Contacts : TEnumerable<TContact> read GetContacts;
    property DoEditContact : TViewModelCommand<TContactViewModel> read FDoEditContact write FDoEditContact;
    property ConfirmDeleteContact : TModelObjectConfirm<TContact, boolean> read FConfirmDeleteContact write FConfirmDeleteContact;
    property QueryCurrentContact : TViewModelQuery<TContact> read FQueryCurrentContact write FQueryCurrentContact;
    property ContactCount: Integer read GetContactCount;
  end;


implementation
uses Common.ObjectStore, Common.Messages, System.Messaging, Common.Exceptions;

{ TContactsSubViewModel }

procedure TContactsSubViewModel.AddContact(Contact: TContact);
var
  LContactViewModel : TContactViewModel;
begin
  LContactViewModel := TContactViewModel.Create(Contact);
  LContactViewModel.DoSaveModelObject := procedure(Contact : TContact)
                                         begin
                                           FContacts.AddContact(Contact);
                                           ObjectStore.Manager.Save(Contact);
                                           DoOnContactsUpdated;
                                         end;
  LContactViewModel.DoCancelModelObject := procedure(Contact : TContact)
                                           begin
                                             Contact.Free;
                                           end;
  DoOnEditContact(LContactViewModel);
end;

constructor TContactsSubViewModel.Create;
begin
  FContacts := TContacts.Create(False);
  FContacts.LoadFromList(ObjectStore.Manager.Find<TContact>.List);
  DoOnContactsUpdated;
end;

function TContactsSubViewModel.CurrentContact: TContact;
begin
  if Assigned(FQueryCurrentContact) then
    Result := FQueryCurrentContact
  else
    raise ViewModelMissingDelegateException.Create('QueryCurrentContact Delegate not Assigned');
end;

procedure TContactsSubViewModel.Delete;
var
  LContact : TContact;
begin
  if Assigned(FConfirmDeleteContact) then
  begin
    LContact := CurrentContact;
    if FConfirmDeleteContact(LContact) then
    begin
      FContacts.DeleteContact(LContact);
      ObjectStore.Manager.Remove(LContact);
      DoOnContactsUpdated;
    end;
  end;
end;

destructor TContactsSubViewModel.Destroy;
begin
  FContacts.Free;
  inherited;
end;

procedure TContactsSubViewModel.DoOnContactsUpdated;
begin
  MessageManager.SendMessage(self, TOnContactsUpdated.Create(self, False));
end;

procedure TContactsSubViewModel.DoOnEditContact(
  ContactViewModel: TContactViewModel);
begin
  if Assigned(FDoEditContact) then
    FDoEditContact(ContactViewModel);
end;

procedure TContactsSubViewModel.Edit;
var
  LContact : TContact;
  LContactViewModel : TContactViewModel;
begin
  LContact := CurrentContact;
  LContactViewModel := TContactViewModel.Create(LContact);
  LContactViewModel.DoSaveModelObject := procedure(Contact : TContact)
                                         begin
                                           ObjectStore.Manager.Flush(Contact);
                                         end;
  DoOnEditContact(LContactViewModel);
end;

function TContactsSubViewModel.GetContactCount: Integer;
begin
  Result := FContacts.Count;
end;

function TContactsSubViewModel.GetContacts: TEnumerable<TContact>;
begin
  Result := FContacts.GetEnumerable;
end;

function TContactsSubViewModel.NewContact: TContact;
begin
  Result := TContact.Create;
  AddContact(Result);
end;

end.
