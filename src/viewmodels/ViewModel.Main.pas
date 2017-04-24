unit ViewModel.Main;

interface
uses
  Model.Contact, Generics.Collections, ViewModel.Contact;

type
  TMainViewModel = class;
  TOnEditContact = reference to procedure (ViewModel : TMainViewModel; ContactViewModel : TContactViewModel);
  TMainViewModel = class
  private
    FContacts : TContacts;
    FOnEditContact: TOnEditContact;
    function GetContacts: TEnumerable<TContact>;
    function GetContactCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure CreateDummyData;
    procedure Add;
    procedure EditContact(AContact : TContact);
    property Contacts : TEnumerable<TContact> read GetContacts;
    property ContactCount: Integer read GetContactCount;
    property OnEditContact : TOnEditContact read FOnEditContact write FOnEditContact;
  end;


implementation

{ TMainViewModel }

procedure TMainViewModel.Add;
var
  LContactViewModel : TContactViewModel;
  NewContact : TContact;
begin
  NewContact := TContact.Create;
  LContactViewModel := TContactViewModel.Create(NewContact);
  LContactViewModel.OnSaveContact := procedure(ViewModel : TContactViewModel; Contact : TContact)
                                     begin
                                       FCOntacts.AddContact(Contact);
                                     end;
  if Assigned(FOnEditContact) then
    FOnEditContact(self, LContactViewModel);
end;

constructor TMainViewModel.Create;
begin
  FContacts := TContacts.Create(True);
end;

destructor TMainViewModel.Destroy;
begin
  FContacts.Free;
  inherited;
end;

procedure TMainViewModel.EditContact(AContact: TContact);
var
  LContactViewModel : TContactViewModel;
begin
  LContactViewModel := TContactViewModel.Create(AContact);
  if Assigned(FOnEditContact) then
    FOnEditContact(self, LContactViewModel);
end;

function TMainViewModel.GetContactCount: Integer;
begin
  Result := FContacts.Count;
end;

function TMainViewModel.GetContacts : TEnumerable<TContact>;
begin
  Result := FContacts.GetEnumerable;
end;

procedure TMainViewModel.CreateDummyData;
var
  LContact : TContact;
begin
  // temporarily create some Contacts just to bootstrap things
  LContact := FContacts.AddNewContact;
  LContact.ID := 1;
  LContact.Firstname := 'Fred';
  LContact.Lastname := 'Flintstone';

  LContact := FContacts.AddNewContact;
  LContact.ID := 2;
  LContact.Firstname := 'Wilma';
  LContact.Lastname := 'Flintstone';
end;

end.
