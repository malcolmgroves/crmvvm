unit View.Company;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, MVVM.View.FMX.Form,
  ViewModel.Company, Data.Bind.GenData, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.ObjectScope, System.Actions, FMX.ActnList, FMX.Edit, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation;

type
  TCompanyView = class(TFormView<TCompanyViewModel>)
    ToolBar1: TToolBar;
    Button1: TButton;
    Button2: TButton;
    Layout1: TLayout;
    Rectangle1: TRectangle;
    Line1: TLine;
    Layout3: TLayout;
    Label3: TLabel;
    Layout14: TLayout;
    Layout15: TLayout;
    Layout16: TLayout;
    Label4: TLabel;
    Layout17: TLayout;
    Edit4: TEdit;
    ActionList1: TActionList;
    actSave: TAction;
    actCancel: TAction;
    bindsrcCompany: TPrototypeBindSource;
    BindingsList1: TBindingsList;
    LinkControlToField1: TLinkControlToField;
    LinkPropertyToFieldText: TLinkPropertyToField;
    Layout2: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    Label1: TLabel;
    Layout6: TLayout;
    Edit1: TEdit;
    LinkControlToField2: TLinkControlToField;
    procedure actSaveUpdate(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bindsrcCompanyCreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CompanyView: TCompanyView;

implementation
uses
  Model.Company;

{$R *.fmx}

procedure TCompanyView.actCancelExecute(Sender: TObject);
begin
  ViewModel.Cancel;
end;

procedure TCompanyView.actSaveExecute(Sender: TObject);
begin
  ViewModel.Save;
end;

procedure TCompanyView.actSaveUpdate(Sender: TObject);
begin
  actSave.Enabled := ViewModel.CanSave;
end;

procedure TCompanyView.bindsrcCompanyCreateAdapter(Sender: TObject;
  var ABindSourceAdapter: TBindSourceAdapter);
begin
  ABindSourceAdapter := TObjectBindSourceAdapter<TCompany>.Create(bindsrcCompany,
                                                               ViewModel.Company,
                                                               False);
  ABindSourceAdapter.AutoPost := True;
end;

procedure TCompanyView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

end.
