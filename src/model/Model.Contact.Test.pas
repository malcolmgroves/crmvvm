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
    [Test]
    [TestCase('AllFields', 'Fred,Flintstone,fred@flintstone.com,1234567,True')]
    [TestCase('NoFirstname', ',Flintstone,fred@flintstone.com,1234567,False')]
    [TestCase('NoPhone', 'Fred,Flintstone,fred@flintstone.com,,true')]
    [TestCase('NoPhoneOrEmail', 'Fred,Flintstone,,,false')]
    procedure TestIsValid(const Firstname, Lastname, Email, Phone : string; ExpectedResult : boolean);
    [Test]
    procedure TestAssign;
  end;

  [TestFixture]
  TContactsTest = class(TObject)
  private
    FContacts : TContacts;
    function CreateContact(const Firstname, Lastname : string): TContact;
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
    [Test]
    procedure TestDelete;
    [Test]
    procedure TestDeleteUnknown;
    [Test]
    procedure TestDeleteNil;
  end;


implementation
uses
  Model.Exceptions, SysUtils;

procedure TContactTest.Setup;
begin
  FContact := TContact.Create;
end;

procedure TContactTest.TearDown;
begin
  FContact.Free;
end;


procedure TContactTest.TestAssign;
var
  LContact : TContact;
begin
  LContact := TContact.Create;
  try
    LContact.Firstname := 'Barney';
    LContact.Lastname := 'Rubble';
    FContact.Assign(LContact);
    Assert.AreEqual(LContact.Firstname, FContact.Firstname);
    Assert.AreEqual(LContact.Lastname, FContact.Lastname);
  finally
    LContact.Free;
  end;
end;

procedure TContactTest.TestIsValid(const Firstname, Lastname, Email,
  Phone: string; ExpectedResult: boolean);
begin
  FContact.Firstname := Firstname;
  FContact.Lastname := Lastname;
  FContact.Email := Email;
  FContact.Phone := Phone;
  Assert.AreEqual(ExpectedResult, FContact.IsValid);
end;

{ TContactsTest }

function TContactsTest.CreateContact(const Firstname,
  Lastname: string): TContact;
var
  LContact : TContact;
begin
  LContact := TCOntact.Create;
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
  LContact := CreateContact('Fred', 'Flintstone');
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
  LContact := CreateContact('Fred', 'Flintstone');
  FContacts.AddContact(LContact);
  Assert.IsTrue(FContacts.Contains(LContact));
end;

procedure TContactsTest.TestContainsNoAdd;
var
  LContact : TContact;
begin
  LContact := CreateContact('Fred', 'Flintstone');
  Assert.IsFalse(FContacts.Contains(LContact));
end;

procedure TContactsTest.TestCountAfterAdd;
var
  LContact : TContact;
  LCount : Integer;
begin
  LCount := FContacts.Count;
  LContact := CreateContact('Fred', 'Flintstone');
  FContacts.AddContact(LContact);
  Assert.AreEqual(LCount + 1, FContacts.Count);
end;

procedure TContactsTest.TestDelete;
var
  LContact : TContact;
  LCount : Integer;
begin
  LContact := CreateContact('Fred', 'Flintstone');
  FContacts.AddContact(LContact);
  LCount := FContacts.Count;

  FContacts.DeleteContact(LContact);
  Assert.AreEqual(LCount - 1, FContacts.Count);
end;

procedure TContactsTest.TestDeleteNil;
var
  LContact : TContact;
  LCount : Integer;
begin
  LContact := nil;
  LCount := FContacts.Count;
  Assert.WillRaise(procedure
                   begin
                     FContacts.DeleteContact(LContact);
                   end, NilParamException);
  Assert.AreEqual(LCount, FContacts.Count);
end;

procedure TContactsTest.TestDeleteUnknown;
var
  LContact : TContact;
  LCount : Integer;
begin
  LContact := CreateContact('Fred', 'Flintstone');
  LCount := FContacts.Count;
  Assert.WillRaise(procedure
                   begin
                     FContacts.DeleteContact(LContact);
                   end, UnknownObjectException);
  Assert.AreEqual(LCount, FContacts.Count);
end;

initialization
  TDUnitX.RegisterTestFixture(TContactTest);
  TDUnitX.RegisterTestFixture(TContactsTest);
end.
