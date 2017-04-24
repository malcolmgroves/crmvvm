unit Model.Contact;

interface
uses
  Generics.Collections;

type
  TContact = class;

  TContacts = class
    FContacts : TObjectList<TContact>;
    function GetCount: Integer;
  public
    constructor Create(OwnsObjects : boolean = False); virtual;
    destructor Destroy; override;
    procedure AddContact(Contact : TContact);
    function AddNewContact : TContact;
    function GetEnumerable: TEnumerable<TContact>;
    function Contains(Contact : TContact) : boolean;
    property Count : Integer read GetCount;
  end;

  TContact = class
  private
    FID: integer;
    FFirstname: string;
    FLastname: string;
  protected
  public
    property ID: integer read FID write FID;
    property Firstname: string read FFirstname write FFirstname;
    property Lastname: string read FLastname write FLastname;
  end;


implementation
uses
  Model.Exceptions;

procedure TContacts.AddContact(Contact: TContact);
begin
  if not Assigned(Contact) then
    raise NilParamException.Create('Contact passed in is not Assigned');

  if Contains(Contact) then
    raise DuplicateObjectException.Create('ContactList already contains this Contact');

  FContacts.Add(Contact);
end;

function TContacts.AddNewContact: TContact;
var
  LContact : TContact;
begin
  LContact := TContact.Create;
  AddContact(LContact);
  Result := LContact;
end;

function TContacts.Contains(Contact: TContact): boolean;
begin
  if not Assigned(Contact) then
    raise NilParamException.Create('Contact passed in is not Assigned');

  Result := FContacts.Contains(Contact);
end;

constructor TContacts.Create(OwnsObjects : boolean = False);
begin
  FContacts := TObjectList<TContact>.Create(OwnsObjects);
end;

destructor TContacts.Destroy;
begin
  FContacts.Free;
  inherited;
end;

function TContacts.GetCount: Integer;
begin
  Result := FContacts.Count;
end;

function TContacts.GetEnumerable: TEnumerable<TContact>;
begin
  Result := FContacts;
end;

{ TContact }


end.
