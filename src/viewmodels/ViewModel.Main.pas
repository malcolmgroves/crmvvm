unit ViewModel.Main;

interface
uses
  Model.Contact, Generics.Collections, ViewModel.Contact, ViewModel.Company,
  Model.Company, MVVM.ViewModel, ViewModel.Sub.Contacts, ViewModel.Sub.Companies;

type
  TActiveViewModel = (Contacts, Companies);
  TMainViewModel = class
  private
    FContactsViewModel : TContactsSubViewModel;
    FCompaniesViewModel : TCompaniesSubViewModel;
    FActiveViewModel : TActiveViewModel;
    FDoChangeView: TViewModelCommand<TMainViewModel>;
    procedure SetActiveView (View : TActiveViewModel);
  public
    constructor Create;
    destructor Destroy; override;
    //SubViewModels
    property ContactsViewModel : TContactsSubViewModel read FContactsViewModel;
    property CompaniesViewModel : TCompaniesSubViewModel read FCompaniesViewModel;
    // General
    procedure Edit;
    procedure Delete;
    procedure New;
    property ActiveViewModel : TActiveViewModel read FActiveViewModel write SetActiveView;
    property DoChangeView : TViewModelCommand<TMainViewModel> read FDoChangeView write FDoChangeView;
  end;


implementation

uses Common.ObjectStore, Common.Messages, System.Messaging, Common.Exceptions;

procedure TMainViewModel.SetActiveView(View: TActiveViewModel);
begin
  if FActiveViewModel <> View then
  begin
    FActiveViewModel := View;
    if Assigned(FDoChangeView) then
      FDoChangeView(self);
  end;
end;

constructor TMainViewModel.Create;
begin
  FContactsViewModel := TContactsSubViewModel.Create;
  FCompaniesViewModel := TCompaniesSubViewModel.Create;
end;

procedure TMainViewModel.Delete;
begin
  case ActiveViewModel of
    TActiveViewModel.Contacts: ContactsViewModel.Delete;
    TActiveViewModel.Companies: CompaniesViewModel.Delete;
  end;
end;

destructor TMainViewModel.Destroy;
begin
  FContactsViewModel.Free;
  FCompaniesViewModel.Free;
  inherited;
end;

procedure TMainViewModel.Edit;
begin
  case ActiveViewModel of
    TActiveViewModel.Contacts: ContactsViewModel.Edit;
    TActiveViewModel.Companies: CompaniesViewModel.Edit;
  end;
end;

procedure TMainViewModel.New;
begin
  case ActiveViewModel of
    Contacts: ContactsViewModel.NewContact;
    Companies: CompaniesViewModel.NewCompany;
  end;

end;

end.
