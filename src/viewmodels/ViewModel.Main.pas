unit ViewModel.Main;

interface
uses
  Model.Contact, Generics.Collections, ViewModel.Contact, ViewModel.Company,
  Model.Company, MVVM.ViewModel;

type
  TActiveView = (Contacts, Companies);
  TMainViewModel = class
  private
    FContacts : TContacts;
    FCompanies : TCompanies;
    FDoEditContact: TViewModelCommand<TContactViewModel>;
    FDoEditCompany: TViewModelCommand<TCompanyViewModel>;
    FConfirmDeleteContact: TModelObjectConfirm<TMainViewModel, TContact, boolean>;
    FConfirmDeleteCompany: TModelObjectConfirm<TMainViewModel, TCompany, boolean>;
    FActiveView : TActiveView;
    FDoChangeView: TViewModelCommand<TMainViewModel>;
    FQueryCurrentContact: TViewModelQuery<TMainViewModel, TContact>;
    FQueryCurrentCompany: TViewModelQuery<TMainViewModel, TCompany>;
    function GetContacts: TEnumerable<TContact>;
    function GetContactCount: Integer;
    procedure DoOnContactsUpdated;
    procedure DoOnEditContact(ContactViewModel : TContactViewModel);
    function GetCompanies: TEnumerable<TCompany>;
    function GetCompanyCount: Integer;
    procedure DoOnCompaniesUpdated;
    procedure DoOnEditCompany(CompanyViewModel : TCompanyViewModel);
    procedure SetActiveView (View : TActiveView);
    function CurrentContact : TContact;
    function CurrentCompany : TCompany;
  public
    constructor Create;
    destructor Destroy; override;
//    procedure CreateDummyData;
    procedure AddContact(Contact : TContact);
    procedure AddCompany(Company : TCompany);
    function NewContact : TContact;
    function NewCompany : TCompany;
    procedure Edit;
    procedure Delete;
    property ActiveView : TActiveView read FActiveView write SetActiveView;
    property Contacts : TEnumerable<TContact> read GetContacts;
    property ContactCount: Integer read GetContactCount;
    property DoEditContact : TViewModelCommand<TContactViewModel> read FDoEditContact write FDoEditContact;
    property Companies : TEnumerable<TCompany> read GetCompanies;
    property CompanyCount: Integer read GetCompanyCount;
    property DoEditCompany : TViewModelCommand<TCompanyViewModel> read FDoEditCompany write FDoEditCompany;
    property DoChangeView : TViewModelCommand<TMainViewModel> read FDoChangeView write FDoChangeView;
    property ConfirmDeleteContact : TModelObjectConfirm<TMainViewModel, TContact, boolean> read FConfirmDeleteContact write FConfirmDeleteContact;
    property ConfirmDeleteCompany : TModelObjectConfirm<TMainViewModel, TCompany, boolean> read FConfirmDeleteCompany write FConfirmDeleteCompany;
    property QueryCurrentContact : TViewModelQuery<TMainViewModel,TContact> read FQueryCurrentContact write FQueryCurrentContact;
    property QueryCurrentCompany : TViewModelQuery<TMainViewModel,TCompany> read FQueryCurrentCompany write FQueryCurrentCompany;
  end;


implementation

{ TMainViewModel }

uses Common.ObjectStore, Common.Messages, System.Messaging, Common.Exceptions;


function TMainViewModel.NewCompany: TCompany;
begin
  Result := TCompany.Create;
  AddCompany(Result);
end;

function TMainViewModel.NewContact : TContact;
begin
  Result := TContact.Create;
  AddContact(Result);
end;

procedure TMainViewModel.SetActiveView(View: TActiveView);
begin
  if FActiveView <> View then
  begin
    FActiveView := View;
    if Assigned(FDoChangeView) then
      FDoChangeView(self);
  end;
end;

procedure TMainViewModel.AddCompany(Company: TCompany);
var
  LCompanyViewModel : TCompanyViewModel;
begin
  LCompanyViewModel := TCompanyViewModel.Create(Company);
  LCompanyViewModel.DoSaveCompany := procedure(ViewModel : TCompanyViewModel; Company : TCompany)
                                     begin
                                       FCompanies.AddCompany(Company);
                                       ObjectStore.Manager.Save(Company);
                                       DoOnCompaniesUpdated;
                                     end;
  LCompanyViewModel.DoCancelCompany := procedure(ViewModel : TCompanyViewModel; Company : TCompany)
                                       begin
                                         Company.Free;
                                       end;
  DoOnEditCompany(LCompanyViewModel);
end;

procedure TMainViewModel.AddContact(Contact: TContact);
var
  LContactViewModel : TContactViewModel;
begin
  LContactViewModel := TContactViewModel.Create(Contact);
  LContactViewModel.DoSaveContact := procedure(ViewModel : TContactViewModel; Contact : TContact)
                                     begin
                                       FContacts.AddContact(Contact);
                                       ObjectStore.Manager.Save(Contact);
                                       DoOnContactsUpdated;
                                     end;
  LContactViewModel.DoCancelContact := procedure(ViewModel : TContactViewModel; Contact : TContact)
                                       begin
                                         Contact.Free;
                                       end;
  DoOnEditContact(LContactViewModel);
end;

constructor TMainViewModel.Create;
var
  LContacts : TList<TContact>;
  LCompanies : TList<TCompany>;
begin
  FContacts := TContacts.Create(False);
  LContacts := ObjectStore.Manager.Find<TContact>.List;
  try
    FContacts.LoadFromList(LContacts);
  finally
    LContacts.Free;
  end;
  DoOnContactsUpdated;

  FCompanies := TCompanies.Create(False);
  LCompanies := ObjectStore.Manager.Find<TCompany>.List;
  try
    FCompanies.LoadFromList(LCompanies);
  finally
    LCompanies.Free;
  end;
  DoOnCompaniesUpdated;
end;

function TMainViewModel.CurrentCompany: TCompany;
begin
  if Assigned(FQueryCurrentCompany) then
    Result := FQueryCurrentCompany(self)
  else
    raise ViewModelMissingDelegateException.Create('QueryCurrentCompany Delegate not Assigned');
end;

function TMainViewModel.CurrentContact: TContact;
begin
  if Assigned(FQueryCurrentContact) then
    Result := FQueryCurrentContact(self)
  else
    raise ViewModelMissingDelegateException.Create('QueryCurrentContact Delegate not Assigned');
end;

procedure TMainViewModel.Delete;
var
  LContact : TContact;
  LCompany : TCompany;
begin
  case ActiveView of
    TActiveView.Contacts: if Assigned(FConfirmDeleteContact) then
                          begin
                            LContact := CurrentContact;
                            if FConfirmDeleteContact(self, LContact) then
                            begin
                              FContacts.DeleteContact(LContact);
                              ObjectStore.Manager.Remove(LContact);
                              DoOnContactsUpdated;
                            end;
                          end;
    TActiveView.Companies:  if Assigned(FConfirmDeleteCompany) then
                            begin
                              LCompany := CurrentCompany;
                              if FConfirmDeleteCompany(self, LCompany) then
                              begin
                                FCompanies.DeleteCompany(LCompany);
                                ObjectStore.Manager.Remove(LCompany);
                                DoOnCompaniesUpdated;
                              end;
                            end;
  end;
end;

destructor TMainViewModel.Destroy;
begin
  FContacts.Free;
  FCompanies.Free;
  inherited;
end;

procedure TMainViewModel.DoOnCompaniesUpdated;
begin
  MessageManager.SendMessage(self, TOnCompaniesUpdated.Create(self, False));
end;

procedure TMainViewModel.DoOnContactsUpdated;
begin
  MessageManager.SendMessage(self, TOnContactsUpdated.Create(self, False));
end;

procedure TMainViewModel.DoOnEditCompany(CompanyViewModel: TCompanyViewModel);
begin
  if Assigned(FDoEditCompany) then
    FDoEditCompany(CompanyViewModel);
end;

procedure TMainViewModel.DoOnEditContact(ContactViewModel: TContactViewModel);
begin
  if Assigned(FDoEditContact) then
    FDoEditContact(ContactViewModel);
end;

procedure TMainViewModel.Edit;
var
  LContact : TContact;
  LCompany : TCompany;
  LContactViewModel : TContactViewModel;
  LCompanyViewModel : TCompanyViewModel;
begin
  case ActiveView of
    TActiveView.Contacts: begin
                            LContact := CurrentContact;
                            LContactViewModel := TContactViewModel.Create(LContact);
                            LContactViewModel.DoSaveContact := procedure(ViewModel : TContactViewModel; Contact : TContact)
                                                               begin
                                                                 ObjectStore.Manager.Flush(Contact);
                                                               end;
                            DoOnEditContact(LContactViewModel);
                          end;
    TActiveView.Companies:  begin
                              LCompany := CurrentCompany;
                              LCompanyViewModel := TCompanyViewModel.Create(LCompany);
                              LCompanyViewModel.DoSaveCompany := procedure(ViewModel : TCompanyViewModel; Company : TCompany)
                                                                 begin
                                                                   ObjectStore.Manager.Flush(Company);
                                                                 end;
                              DoOnEditCompany(LCompanyViewModel);
                            end;
  end;
end;


function TMainViewModel.GetCompanies: TEnumerable<TCompany>;
begin
  Result := FCompanies.GetEnumerable;
end;

function TMainViewModel.GetCompanyCount: Integer;
begin
  Result := FCompanies.Count;
end;

function TMainViewModel.GetContactCount: Integer;
begin
  Result := FContacts.Count;
end;

function TMainViewModel.GetContacts : TEnumerable<TContact>;
begin
  Result := FContacts.GetEnumerable;
end;


//procedure TMainViewModel.CreateDummyData;
//var
//  LContact : TContact;
//begin
//  // temporarily create some Contacts just to bootstrap things
//  LContact := FContacts.AddNewContact;
//  LContact.ID := 1;
//  LContact.Firstname := 'Fred';
//  LContact.Lastname := 'Flintstone';
//
//  LContact := FContacts.AddNewContact;
//  LContact.ID := 2;
//  LContact.Firstname := 'Wilma';
//  LContact.Lastname := 'Flintstone';
//end;

end.
