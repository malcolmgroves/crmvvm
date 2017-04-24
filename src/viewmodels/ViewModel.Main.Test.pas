unit ViewModel.Main.Test;

interface
uses
  DUnitX.TestFramework, ViewModel.Main;

type

  [TestFixture]
  TMainViewModelTest = class(TObject)
  private
    FViewModel : TMainViewModel;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  end;

implementation
uses
  Model.Contact;

procedure TMainViewModelTest.Setup;
begin
  FViewModel := TMainViewModel.Create;
end;

procedure TMainViewModelTest.TearDown;
begin
  FViewModel.Free;
end;


initialization
  TDUnitX.RegisterTestFixture(TMainViewModelTest);
end.
