unit ViewModel.Main;

interface
uses
  Model.Contact, Generics.Collections, ViewModel.Contact, MVVM.ViewModel;

type
  TMainViewModel = class
  private
    FContacts : TContacts;
    FDoEditContact: TViewModelCommand<TContactViewModel>;
    FConfirmDeleteContact: TModelObjectConfirm<TMainViewModel, TContact, boolean>;
    function GetContacts: TEnumerable<TContact>;
    function GetContactCount: Integer;
    procedure DoOnContactsUpdated;
    procedure DoOnEditContact(ContactViewModel : TContactViewModel);
  public
    constructor Create;
    destructor Destroy; override;
//    procedure CreateDummyData;
    procedure AddContact(Contact : TContact);
    function NewContact : TContact;
    procedure EditContact(AContact : TContact);
    procedure DeleteContact(AContact : TContact);
    property Contacts : TEnumerable<TContact> read GetContacts;
    property ContactCount: Integer read GetContactCount;
    property DoEditContact : TViewModelCommand<TContactViewModel> read FDoEditContact write FDoEditContact;
    property ConfirmDeleteContact : TModelObjectConfirm<TMainViewModel, TContact, boolean> read FConfirmDeleteContact write FConfirmDeleteContact;
  end;


implementation

{ TMainViewModel }

uses Common.ObjectStore, Common.Messages, System.Messaging;

function TMainViewModel.NewContact : TContact;
begin
  Result := TContact.Create;
  AddContact(Result);
end;

procedure TMainViewModel.AddContact(Contact: TContact);
var
  LContactViewModel : TContactViewModel;
begin
  LContactViewModel := TContactViewModel.Create(Contact);
  LContactViewModel.DoSaveContact := procedure(ViewModel : TContactViewModel; Contact : TContact)
                                     begin
                                       FContacts.AddContact(Contact);
                                       ObjectStore.Manager.Save(Contact);
                                       DoOnContactsUpdated;
                                     end;
  LContactViewModel.DoCancelContact := procedure(ViewModel : TContactViewModel; Contact : TContact)
                                       begin
                                         Contact.Free;
                                       end;
  DoOnEditContact(LContactViewModel);
end;

constructor TMainViewModel.Create;
var
  LContacts : TList<TContact>;
begin
  FContacts := TContacts.Create(False);
  LContacts := ObjectStore.Manager.Find<TContact>.List;
  try
    FContacts.LoadFromList(LContacts);
  finally
    LContacts.Free;
  end;
  DoOnContactsUpdated;
end;

procedure TMainViewModel.DeleteContact(AContact: TContact);
begin
  if Assigned(FConfirmDeleteContact) then
    if FConfirmDeleteContact(self, AContact) then
    begin
      FContacts.DeleteContact(AContact);
      ObjectStore.Manager.Remove(AContact);
      DoOnContactsUpdated;
    end;
end;

destructor TMainViewModel.Destroy;
begin
  FContacts.Free;
  inherited;
end;

procedure TMainViewModel.DoOnContactsUpdated;
begin
  MessageManager.SendMessage(self, TOnContactsUpdated.Create(self, False));
end;

procedure TMainViewModel.DoOnEditContact(ContactViewModel: TContactViewModel);
begin
  if Assigned(FDoEditContact) then
    FDoEditContact(ContactViewModel);
end;

procedure TMainViewModel.EditContact(AContact: TContact);
var
  LContactViewModel : TContactViewModel;
begin
  LContactViewModel := TContactViewModel.Create(AContact);
  LContactViewModel.DoSaveContact := procedure(ViewModel : TContactViewModel; Contact : TContact)
                                     begin
                                       ObjectStore.Manager.Flush(Contact);
                                     end;
  DoOnEditContact(LContactViewModel);
end;

function TMainViewModel.GetContactCount: Integer;
begin
  Result := FContacts.Count;
end;

function TMainViewModel.GetContacts : TEnumerable<TContact>;
begin
  Result := FContacts.GetEnumerable;
end;

//procedure TMainViewModel.CreateDummyData;
//var
//  LContact : TContact;
//begin
//  // temporarily create some Contacts just to bootstrap things
//  LContact := FContacts.AddNewContact;
//  LContact.ID := 1;
//  LContact.Firstname := 'Fred';
//  LContact.Lastname := 'Flintstone';
//
//  LContact := FContacts.AddNewContact;
//  LContact.ID := 2;
//  LContact.Firstname := 'Wilma';
//  LContact.Lastname := 'Flintstone';
//end;

end.
