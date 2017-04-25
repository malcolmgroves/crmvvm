unit View.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, ViewModel.Main,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, Data.Bind.Components, Data.Bind.ObjectScope, Data.Bind.GenData,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.MultiView, System.Actions, FMX.ActnList, EnumerableAdapter, Model.Contact,
  FMX.Objects, MVVM.View.FMX.Form, FMX.Menus, System.ImageList, FMX.ImgList,
  FMX.TabControl, Model.Company, Fmx.Bind.GenData;

type
  TMainView = class(TFormView<TMainViewModel>)
    ListView1: TListView;
    bindsrcContacts: TPrototypeBindSource;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    ToolBar1: TToolBar;
    layoutMain: TLayout;
    SpeedButton3: TSpeedButton;
    ActionList1: TActionList;
    actAdd: TAction;
    Splitter1: TSplitter;
    Layout1: TLayout;
    Rectangle1: TRectangle;
    Layout2: TLayout;
    Line1: TLine;
    LinkPropertyToFieldText: TLinkPropertyToField;
    Layout3: TLayout;
    Label3: TLabel;
    Layout6: TLayout;
    Layout7: TLayout;
    Label5: TLabel;
    Layout8: TLayout;
    Label6: TLabel;
    Layout5: TLayout;
    Layout9: TLayout;
    Label2: TLabel;
    Layout10: TLayout;
    Label4: TLabel;
    LinkPropertyToFieldText2: TLinkPropertyToField;
    LinkPropertyToFieldText3: TLinkPropertyToField;
    SpeedButton4: TSpeedButton;
    actEdit: TAction;
    actDelete: TAction;
    PopupMenu1: TPopupMenu;
    MenuItem1: TMenuItem;
    MultiView1: TMultiView;
    SpeedButton1: TSpeedButton;
    TabControl1: TTabControl;
    tabContacts: TTabItem;
    tabCompanies: TTabItem;
    SpeedButton2: TSpeedButton;
    ImageList1: TImageList;
    SpeedButton5: TSpeedButton;
    actContacts: TAction;
    actCompanies: TAction;
    bindsrcCompanies: TPrototypeBindSource;
    ListView2: TListView;
    Splitter2: TSplitter;
    Layout4: TLayout;
    LinkListControlToField2: TLinkListControlToField;
    Layout11: TLayout;
    Layout12: TLayout;
    Layout13: TLayout;
    Label1: TLabel;
    Layout14: TLayout;
    Label7: TLabel;
    Layout15: TLayout;
    Label8: TLabel;
    Line2: TLine;
    LinkPropertyToFieldText4: TLinkPropertyToField;
    LinkPropertyToFieldText5: TLinkPropertyToField;
    Layout16: TLayout;
    Layout17: TLayout;
    Label9: TLabel;
    Layout18: TLayout;
    Label10: TLabel;
    LinkPropertyToFieldText6: TLinkPropertyToField;
    procedure bindsrcContactsCreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
    procedure actAddExecute(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actContactsExecute(Sender: TObject);
    procedure actCompaniesExecute(Sender: TObject);
    procedure bindsrcCompaniesCreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
    procedure LinkPropertyToFieldText6AssigningValue(Sender: TObject;
      AssignValueRec: TBindingAssignValueRec; var Value: TValue;
      var Handled: Boolean);
  private
    function ContactAdapter: TEnumerableBindSourceAdapter<TContact>;
    function CompanyAdapter: TEnumerableBindSourceAdapter<TCompany>;
  end;

var
  MainView: TMainView;

implementation

{$R *.fmx}

uses View.Contact, ViewModel.Contact, ViewModel.Company, Common.Messages, System.Messaging,
  View.Company;

{ TviewMain }

function TMainView.ContactAdapter: TEnumerableBindSourceAdapter<TContact>;
begin
  Result := TEnumerableBindSourceAdapter<TContact>(bindsrcContacts.InternalAdapter);
end;

function TMainView.CompanyAdapter: TEnumerableBindSourceAdapter<TCompany>;
begin
  Result := TEnumerableBindSourceAdapter<TCompany>(bindsrcCompanies.InternalAdapter);
end;

procedure TMainView.FormCreate(Sender: TObject);
begin
  ViewModel.ContactsViewModel.DoEditContact :=  procedure (ContactViewModel : TContactViewModel)
                                                var
                                                  LContactView : TContactView;
                                                begin
                                                  LContactView := TContactView.Create(nil, ContactViewModel);
                                                  LContactView.ShowModal(procedure(ModalResult : TModalResult)
                                                                         begin
                                                                           ContactViewModel.Free;
                                                                           bindsrcContacts.Refresh;
                                                                         end);
                                                end;
  ViewModel.CompaniesViewModel.DoEditCompany := procedure (CompanyViewModel : TCompanyViewModel)
                                                var
                                                  LCompanyView : TCompanyView;
                                                begin
                                                  LCompanyView := TCompanyView.Create(nil, CompanyViewModel);
                                                  LCompanyView.ShowModal(procedure(ModalResult : TModalResult)
                                                                         begin
                                                                           CompanyViewModel.Free;
                                                                           bindsrcCompanies.Refresh;
                                                                         end);
                                                end;
  ViewModel.DoChangeView :=  procedure (ViewModel : TMainViewModel)
                              begin
                                case ViewModel.ActiveViewModel of
                                  Contacts: TabControl1.ActiveTab := tabContacts;
                                  Companies: TabControl1.ActiveTab := tabCompanies;
                                end;
                              end;
  ViewModel.ContactsViewModel.ConfirmDeleteContact := function (Contact : TContact) : boolean
                                                      begin
                                                        Result := MessageDlg(Format('Are you sure you want to delete %s %s?', [COntact.Firstname, COntact.Lastname]),
                                                                             TMsgDlgType.mtConfirmation, mbOKCancel, 0) = mrOK;
                                                      end;

  ViewModel.CompaniesViewModel.ConfirmDeleteCompany :=  function (Company : TCompany) : boolean
                                                        begin
                                                          Result := MessageDlg(Format('Are you sure you want to delete %s?', [Company.Name]),
                                                                               TMsgDlgType.mtConfirmation, mbOKCancel, 0) = mrOK;
                                                        end;

  ViewModel.ContactsViewModel.QueryCurrentContact :=  function : TContact
                                                      begin
                                                        Result := ContactAdapter.Current;
                                                      end;

  ViewModel.CompaniesViewModel.QueryCurrentCompany :=  function : TCompany
                                                       begin
                                                         Result := CompanyAdapter.Current;
                                                       end;

  MessageManager.SubscribeToMessage(TOnContactsUpdated, procedure(const Sender : TObject; const M : TMessageBase)
                                                        begin
                                                          ContactAdapter.Reload;
                                                        end);
  MessageManager.SubscribeToMessage(TOnCompaniesUpdated,  procedure(const Sender : TObject; const M : TMessageBase)
                                                          begin
                                                            CompanyAdapter.Reload;
                                                          end);
end;

procedure TMainView.LinkPropertyToFieldText6AssigningValue(Sender: TObject;
  AssignValueRec: TBindingAssignValueRec; var Value: TValue;
  var Handled: Boolean);
var
  LName : string;
  LCurrentContact : TContact;
begin
  LName := '';
  LCurrentContact := ContactAdapter.Current;
  if (Assigned(LCurrentContact) and Assigned(LCurrentContact.Company)) then
    LName := ContactAdapter.Current.Company.Name;
  Label10.Text := Lname;
  Handled := True;
end;

procedure TMainView.actAddExecute(Sender: TObject);
begin
  ViewModel.New;
end;

procedure TMainView.actCompaniesExecute(Sender: TObject);
begin
  ViewModel.ActiveViewModel := TActiveViewModel.Companies;
end;

procedure TMainView.actContactsExecute(Sender: TObject);
begin
  ViewModel.ActiveViewModel := TActiveViewModel.Contacts;
end;

procedure TMainView.actDeleteExecute(Sender: TObject);
begin
  ViewModel.Delete;
end;

procedure TMainView.actEditExecute(Sender: TObject);
begin
  ViewModel.Edit;
end;

procedure TMainView.bindsrcCompaniesCreateAdapter(Sender: TObject;
  var ABindSourceAdapter: TBindSourceAdapter);
begin
  ABindSourceAdapter := TEnumerableBindSourceAdapter<TCompany>.Create(bindsrcCompanies,
                                                                      ViewModel.CompaniesViewModel.Companies);
end;

procedure TMainView.bindsrcContactsCreateAdapter(Sender: TObject;
  var ABindSourceAdapter: TBindSourceAdapter);
begin
  ABindSourceAdapter := TEnumerableBindSourceAdapter<TContact>.Create(bindsrcContacts,
                                                                      ViewModel.ContactsViewModel.Contacts);
end;


end.
