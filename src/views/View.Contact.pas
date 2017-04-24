unit View.Contact;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, ViewModel.Contact,
  FMX.Objects, FMX.StdCtrls, FMX.Layouts, FMX.Controls.Presentation,
  Data.Bind.GenData, Data.Bind.Components, Data.Bind.ObjectScope,
  System.Actions, FMX.ActnList, FMX.Edit, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, MVVM.View.FMX.Form;

type
  TContactView = class(TFormView<TContactViewModel>)
    ToolBar1: TToolBar;
    Layout1: TLayout;
    Rectangle1: TRectangle;
    Layout2: TLayout;
    Layout6: TLayout;
    Layout7: TLayout;
    Label5: TLabel;
    Layout8: TLayout;
    Line1: TLine;
    Layout3: TLayout;
    Label3: TLabel;
    Layout5: TLayout;
    Layout9: TLayout;
    Label2: TLabel;
    Layout10: TLayout;
    Edit1: TEdit;
    Edit2: TEdit;
    Layout4: TLayout;
    Layout11: TLayout;
    Layout12: TLayout;
    Label1: TLabel;
    Layout13: TLayout;
    Edit3: TEdit;
    Layout14: TLayout;
    Layout15: TLayout;
    Layout16: TLayout;
    Label4: TLabel;
    Layout17: TLayout;
    Edit4: TEdit;
    Button1: TButton;
    Button2: TButton;
    ActionList1: TActionList;
    actSave: TAction;
    actCancel: TAction;
    bindsrcContact: TPrototypeBindSource;
    BindingsList1: TBindingsList;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    LinkControlToField4: TLinkControlToField;
    LinkPropertyToFieldText: TLinkPropertyToField;
    procedure actSaveExecute(Sender: TObject);
    procedure actSaveUpdate(Sender: TObject);
    procedure bindsrcContactCreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
    procedure actCancelExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  end;

var
  ContactView: TContactView;

implementation
uses
  Model.Contact;

{$R *.fmx}

{ TContactView }

procedure TContactView.actCancelExecute(Sender: TObject);
begin
  ViewModel.Cancel;
end;

procedure TContactView.actSaveExecute(Sender: TObject);
begin
  ViewModel.Save;
end;

procedure TContactView.actSaveUpdate(Sender: TObject);
begin
  actSave.Enabled := ViewModel.CanSave;
end;


procedure TContactView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TContactView.bindsrcContactCreateAdapter(Sender: TObject;
  var ABindSourceAdapter: TBindSourceAdapter);
begin
  ABindSourceAdapter := TObjectBindSourceAdapter<TContact>.Create(bindsrcContact,
                                                               ViewModel.Contact,
                                                               False);
  ABindSourceAdapter.AutoPost := True;
end;

end.
