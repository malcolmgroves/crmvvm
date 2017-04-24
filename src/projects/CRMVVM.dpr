program CRMVVM;

uses
  System.StartUpCopy,
  FMX.Forms,
  View.Main in '..\views\View.Main.pas' {MainView},
  Model.Contact in '..\model\Model.Contact.pas',
  Common.Exceptions in '..\common\Common.Exceptions.pas',
  Model.Exceptions in '..\model\Model.Exceptions.pas',
  ViewModel.Main in '..\viewmodels\ViewModel.Main.pas',
  EnumerableAdapter in '..\EnumerableAdapter.pas',
  View.Contact in '..\views\View.Contact.pas' {ContactView},
  ViewModel.Contact in '..\viewmodels\ViewModel.Contact.pas',
  MVVM.Model in '..\mvvm\MVVM.Model.pas',
  MVVM.ViewModel in '..\mvvm\MVVM.ViewModel.pas',
  MVVM.View.FMX.Form in '..\mvvm\MVVM.View.FMX.Form.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
