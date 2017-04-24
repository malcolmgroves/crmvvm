unit Model.Contact;

interface
uses
  Generics.Collections, System.Classes;

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

  TContact = class(TPersistent)
  private
    FID: integer;
    FFirstname: string;
    FLastname: string;
    FEmail: string;
    FPhone: string;
    function GetIsValid: boolean;
  protected
  public
    procedure Assign(Source: TPersistent); override;
    property ID: integer read FID write FID;
    property Firstname: string read FFirstname write FFirstname;
    property Lastname: string read FLastname write FLastname;
    property Email: string read FEmail write FEmail;
    property Phone: string read FPhone write FPhone;
    property IsValid: boolean read GetIsValid;
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

procedure TContact.Assign(Source: TPersistent);
begin
  if Source is TContact then
  begin
    ID := TContact(Source).ID;
    Firstname := TContact(Source).Firstname;
    Lastname := TContact(Source).Lastname;
    Email := TContact(Source).Email;
    Phone := TContact(Source).Phone;
  end
  else
    inherited Assign(Source);
end;

function TContact.GetIsValid: boolean;
begin
  Result := (Length(Firstname) > 0) and ((Length(Email) > 0) or (Length(Phone) > 0));
end;

end.
