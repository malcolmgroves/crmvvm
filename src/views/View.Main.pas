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
  FMX.Objects, MVVM.View.FMX.Form, FMX.Menus;

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
    procedure bindsrcContactsCreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
    procedure actAddExecute(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
  private
    function ContactAdapter: TEnumerableBindSourceAdapter<TContact>;
  end;

var
  MainView: TMainView;

implementation

{$R *.fmx}

uses View.Contact, ViewModel.Contact;

{ TviewMain }

function TMainView.ContactAdapter: TEnumerableBindSourceAdapter<TContact>;
begin
  Result := TEnumerableBindSourceAdapter<TContact>(bindsrcContacts.InternalAdapter);
end;

procedure TMainView.FormCreate(Sender: TObject);
begin
  ViewModel.OnEditContact :=  procedure (ViewModel : TMainViewModel; ContactViewModel : TContactViewModel)
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
  ViewModel.OnConfirmDeleteContact := function (ViewModel : TMainViewModel; Contact : TContact) : boolean
                                      begin
                                        Result := MessageDlg(Format('Are you sure you want to delete %s %s?', [COntact.Firstname, COntact.Lastname]),
                                                             TMsgDlgType.mtConfirmation, mbOKCancel, 0) = mrOK;
                                      end;
  ViewModel.OnContactsUpdated :=  procedure (ViewModel : TMainViewModel)
                                  begin
                                    ContactAdapter.Reload;
                                  end;
end;

procedure TMainView.actAddExecute(Sender: TObject);
begin
  ViewModel.NewContact;
end;

procedure TMainView.actDeleteExecute(Sender: TObject);
begin
  ViewModel.DeleteContact(ContactAdapter.Current);
end;

procedure TMainView.actEditExecute(Sender: TObject);
begin
  ViewModel.EditContact(ContactAdapter.Current);
end;

procedure TMainView.bindsrcContactsCreateAdapter(Sender: TObject;
  var ABindSourceAdapter: TBindSourceAdapter);
begin
  ABindSourceAdapter := TEnumerableBindSourceAdapter<TContact>.Create(bindsrcContacts,
                                                                      ViewModel.Contacts);
end;


end.
