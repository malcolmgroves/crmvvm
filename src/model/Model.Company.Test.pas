unit Model.Company.Test;

interface
uses
  DUnitX.TestFramework, Model.Company;

type
  [TestFixture]
  TCompanyTest = class(TObject)
  private
    FCompany : TCompany;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    [TestCase('AllFields', 'Acme,True')]
    [TestCase('NoName', ',False')]
    procedure TestIsValid(const Name : string; ExpectedResult : boolean);
    [Test]
    procedure TestAssign;
  end;

  [TestFixture]
  TCompaniesTest = class(TObject)
  private
    FCompanies : TCompanies;
    function CreateCompany(const Name : string): TCompany;
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

procedure TCompanyTest.Setup;
begin
  FCompany := TCompany.Create;
end;

procedure TCompanyTest.TearDown;
begin
  FCompany.Free;
end;


procedure TCompanyTest.TestAssign;
var
  LCompany : TCompany;
begin
  LCompany := TCompany.Create;
  try
    LCompany.Name := 'Acme';
    FCompany.Assign(LCompany);
    Assert.AreEqual(LCompany.Name, FCompany.Name);
  finally
    LCompany.Free;
  end;
end;

procedure TCompanyTest.TestIsValid(const Name: string; ExpectedResult: boolean);
begin
  FCompany.Name := Name;
  Assert.AreEqual(ExpectedResult, FCompany.IsValid);
end;

{ TCompaniesTest }

function TCompaniesTest.CreateCompany(const Name: string): TCompany;
var
  LCompany : TCompany;
begin
  LCompany := TCompany.Create;
  LCompany.Name := Name;
  Result := LCompany;
end;

procedure TCompaniesTest.Setup;
begin
  FCompanies := TCompanies.Create(True);
end;

procedure TCompaniesTest.TearDown;
begin
  FCompanies.Free;
end;

procedure TCompaniesTest.TestAddNil;
var
  LCompany : TCompany;
  LCount : Integer;
begin
  LCompany := nil;
  LCount := FCompanies.Count;
  Assert.WillRaise(procedure
                   begin
                     FCompanies.AddCompany(LCompany);
                   end, NilParamException);
  Assert.AreEqual(LCount, FCompanies.Count);
end;

procedure TCompaniesTest.TestAddTwice;
var
  LCompany : TCompany;
  LCount : Integer;
begin
  LCompany := CreateCompany('Acme');
  FCompanies.AddCompany(LCompany);
  LCount := FCompanies.Count;
  Assert.WillRaise(procedure
                   begin
                     FCompanies.AddCompany(LCompany);
                   end, DuplicateObjectException);
  Assert.AreEqual(LCount, FCompanies.Count);
end;

procedure TCompaniesTest.TestContainsAfterAdd;
var
  LCompany : TCompany;
begin
  LCompany := CreateCompany('Acme');
  FCompanies.AddCompany(LCompany);
  Assert.IsTrue(FCompanies.Contains(LCompany));
end;

procedure TCompaniesTest.TestContainsNoAdd;
var
  LCompany : TCompany;
begin
  LCompany := CreateCompany('Acme');
  Assert.IsFalse(FCompanies.Contains(LCompany));
end;

procedure TCompaniesTest.TestCountAfterAdd;
var
  LCompany : TCompany;
  LCount : Integer;
begin
  LCount := FCompanies.Count;
  LCompany := CreateCompany('Acme');
  FCompanies.AddCompany(LCompany);
  Assert.AreEqual(LCount + 1, FCompanies.Count);
end;

procedure TCompaniesTest.TestDelete;
var
  LCompany : TCompany;
  LCount : Integer;
begin
  LCompany := CreateCompany('Acme');
  FCompanies.AddCompany(LCompany);
  LCount := FCompanies.Count;

  FCompanies.DeleteCompany(LCompany);
  Assert.AreEqual(LCount - 1, FCompanies.Count);
end;

procedure TCompaniesTest.TestDeleteNil;
var
  LCompany : TCompany;
  LCount : Integer;
begin
  LCompany := nil;
  LCount := FCompanies.Count;
  Assert.WillRaise(procedure
                   begin
                     FCompanies.DeleteCompany(LCompany);
                   end, NilParamException);
  Assert.AreEqual(LCount, FCompanies.Count);
end;

procedure TCompaniesTest.TestDeleteUnknown;
var
  LCompany : TCompany;
  LCount : Integer;
begin
  LCompany := CreateCompany('Acme');
  LCount := FCompanies.Count;
  Assert.WillRaise(procedure
                   begin
                     FCompanies.DeleteCompany(LCompany);
                   end, UnknownObjectException);
  Assert.AreEqual(LCount, FCompanies.Count);
end;

initialization
  TDUnitX.RegisterTestFixture(TCompanyTest);
  TDUnitX.RegisterTestFixture(TCompaniesTest);
end.
