unit Model.Contact.Test;

interface
uses
  DUnitX.TestFramework, Model.Contact;

type
  [TestFixture]
  TContactTest = class(TObject)
  private
    FContact : TContact;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  end;

  [TestFixture]
  TContactsTest = class(TObject)
  private
    FContacts : TContacts;
    function CreateContact(const ID : Integer; const Firstname, Lastname : string): TContact;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestContainsAfterAdd;
    [Test]
    procedure TestContainsNoAdd;
    [Test]
    procedure TestAddTwice;
    [Test]
    procedure TestAddNil;
    [Test]
    procedure TestCountAfterAdd;
  end;


implementation
uses
  Model.Exceptions;

procedure TContactTest.Setup;
begin
  FContact := TContact.Create;
end;

procedure TContactTest.TearDown;
begin
  FContact.Free;
end;


{ TContactsTest }

function TContactsTest.CreateContact(const ID: Integer; const Firstname,
  Lastname: string): TContact;
var
  LContact : TContact;
begin
  LContact := TCOntact.Create;
  LContact.ID := ID;
  LContact.Firstname := Firstname;
  LContact.Lastname := Lastname;
  Result := LContact;
end;

procedure TContactsTest.Setup;
begin
  FContacts := TContacts.Create(True);
end;

procedure TContactsTest.TearDown;
begin
  FContacts.Free;
end;

procedure TContactsTest.TestAddNil;
var
  LContact : TContact;
  LCount : Integer;
begin
  LContact := nil;
  LCount := FContacts.Count;
  Assert.WillRaise(procedure
                   begin
                     FContacts.AddContact(LContact);
                   end, NilParamException);
  Assert.AreEqual(LCount, FContacts.Count);
end;

procedure TContactsTest.TestAddTwice;
var
  LContact : TContact;
  LCount : Integer;
begin
  LContact := CreateContact(1, 'Fred', 'Flintstone');
  FContacts.AddContact(LContact);
  LCount := FContacts.Count;
  Assert.WillRaise(procedure
                   begin
                     FContacts.AddContact(LContact);
                   end, DuplicateObjectException);
  Assert.AreEqual(LCount, FContacts.Count);
end;

procedure TContactsTest.TestContainsAfterAdd;
var
  LContact : TContact;
begin
  LContact := CreateContact(1, 'Fred', 'Flintstone');
  FContacts.AddContact(LContact);
  Assert.IsTrue(FContacts.Contains(LContact));
end;

procedure TContactsTest.TestContainsNoAdd;
var
  LContact : TContact;
begin
  LContact := CreateContact(1, 'Fred', 'Flintstone');
  Assert.IsFalse(FContacts.Contains(LContact));
end;

procedure TContactsTest.TestCountAfterAdd;
var
  LContact : TContact;
  LCount : Integer;
begin
  LCount := FContacts.Count;
  LContact := CreateContact(1, 'Fred', 'Flintstone');
  FContacts.AddContact(LContact);
  Assert.AreEqual(LCount + 1, FContacts.Count);
end;

initialization
  TDUnitX.RegisterTestFixture(TContactTest);
  TDUnitX.RegisterTestFixture(TContactsTest);
end.
