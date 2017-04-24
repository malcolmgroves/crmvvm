unit Model.Contact;

interface
uses
  Generics.Collections, System.Classes, MVVM.Model, Aurelius.Mapping.Attributes, Model.Company, Aurelius.Types.Nullable;

type
  TContact = class;

  TContacts = class(TObjectEnumerable<TContact>)
  public
    function AddContact(Contact : TContact): Integer;
    procedure DeleteContact(Contact : TContact);
  end;

  [Entity]
  [AutoMapping]
  TContact = class(TPersistent)
  private
    FID: integer;
    FFirstname: string;
    FLastname: string;
    FEmail: string;
    FPhone: string;
    FCompany: TCompany;
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
    property Company: TCompany read FCompany write FCompany;
  end;


implementation
uses
  Model.Exceptions;

function TContacts.AddContact(Contact: TContact): Integer;
begin
  if not Assigned(Contact) then
    raise NilParamException.Create('Contact passed in is not Assigned');

  if Contains(Contact) then
    raise DuplicateObjectException.Create('ContactList already contains this Contact');

  Result := FObjects.Add(Contact);
end;

procedure TContacts.DeleteContact(Contact: TContact);
begin
  if not Assigned(Contact) then
    raise NilParamException.Create('Contact passed in is not Assigned');

  if not Contains(Contact) then
    raise UnknownObjectException.Create('ContactList does not contain this Contact');

  FObjects.Delete(FObjects.IndexOf(Contact));
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
    FCompany := TContact(Source).Company;
  end
  else
    inherited Assign(Source);
end;

function TContact.GetIsValid: boolean;
begin
  Result := (Length(Firstname) > 0) and ((Length(Email) > 0) or (Length(Phone) > 0));
end;



end.
