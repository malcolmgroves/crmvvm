unit ViewModel.Main;

interface
uses
  Model.Contact, Generics.Collections, ViewModel.Contact, MVVM.ViewModel;

type
  TMainViewModel = class
  private
    FContacts : TContacts;
    FOnEditContact: TOnChildViewModelNotify<TMainViewModel, TContactViewModel>;
    FOnContactsUpdated: TOnViewModelNotify<TMainViewModel>;
    FOnConfirmDeleteContact: TOnModelObjectFunc<TMainViewModel, TContact, boolean>;
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
    property OnEditContact : TOnChildViewModelNotify<TMainViewModel, TContactViewModel> read FOnEditContact write FOnEditContact;
    property OnConfirmDeleteContact : TOnModelObjectFunc<TMainViewModel, TContact, boolean> read FOnConfirmDeleteContact write FOnConfirmDeleteContact;
    property OnContactsUpdated : TOnViewModelNotify<TMainViewModel> read FOnContactsUpdated write FOnContactsUpdated;
  end;


implementation

{ TMainViewModel }

uses Common.ObjectStore;

function TMainViewModel.NewContact : TContact;
var
  LContactViewModel : TContactViewModel;
begin
  Result := TContact.Create;
  AddContact(Result);
end;

procedure TMainViewModel.AddContact(Contact: TContact);
var
  LContactViewModel : TContactViewModel;
begin
  LContactViewModel := TContactViewModel.Create(Contact);
  LContactViewModel.OnSaveContact := procedure(ViewModel : TContactViewModel; Contact : TContact)
                                     begin
                                       FContacts.AddContact(Contact);
                                       ObjectStore.Manager.Save(Contact);
                                       DoOnContactsUpdated;
                                     end;
  LContactViewModel.OnCancelContact := procedure(ViewModel : TContactViewModel; Contact : TContact)
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
  if Assigned(FOnConfirmDeleteContact) then
    if FOnConfirmDeleteContact(self, AContact) then
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
  if Assigned(FOnContactsUpdated) then
    FOnContactsUpdated(self);
end;

procedure TMainViewModel.DoOnEditContact(ContactViewModel: TContactViewModel);
begin
  if Assigned(FOnEditContact) then
    FOnEditContact(self, ContactViewModel);
end;

procedure TMainViewModel.EditContact(AContact: TContact);
var
  LContactViewModel : TContactViewModel;
begin
  LContactViewModel := TContactViewModel.Create(AContact);
  LContactViewModel.OnSaveContact := procedure(ViewModel : TContactViewModel; Contact : TContact)
                                     begin
                                       ObjectStore.Manager.Update(Contact);
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
