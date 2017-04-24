unit ViewModel.Contact.Test;

interface
uses
  DUnitX.TestFramework, ViewModel.Contact, Model.Contact;

type

  [TestFixture]
  TContactViewModelTest = class(TObject)
  private
    FContact : TContact;
    FViewModel : TContactViewModel;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestSave;
    [Test]
    procedure TestCancel;
  end;

implementation

const
  cFirstname = 'Fred';
  cLastname = 'Flintstone';

procedure TContactViewModelTest.Setup;
begin
  FContact := TContact.Create;
  FContact.Firstname := cFirstname;
  FContact.Lastname := cLastname;
  FViewModel := TContactViewModel.Create(FContact);
end;

procedure TContactViewModelTest.TearDown;
begin
  FViewModel.Free;
  FContact.Free;
end;


procedure TContactViewModelTest.TestCancel;
begin
  FViewModel.OnSaveContact := procedure (Sender : TContactViewModel; Contact : TContact)
                              begin
                                Assert.Fail;
                              end;
  FViewModel.Contact.Firstname := 'Barney';
  FViewModel.Contact.Lastname := 'Rubble';
  FViewModel.Cancel;
//  Assert.AreEqual(cFirstname, Contact.Firstname);
//  Assert.AreEqual(cLastname, Contact.Firstname);
end;

procedure TContactViewModelTest.TestSave;
begin
  FViewModel.OnSaveContact := procedure (Sender : TContactViewModel; Contact : TContact)
                              begin
                                Assert.AreEqual('Barney', Contact.Firstname);
                                Assert.AreEqual('Rubble', Contact.Lastname);
                              end;
  FViewModel.Contact.Firstname := 'Barney';
  FViewModel.Contact.Lastname := 'Rubble';
  FViewModel.Save;
end;

initialization
  TDUnitX.RegisterTestFixture(TContactViewModelTest);
end.
