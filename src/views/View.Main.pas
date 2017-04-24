unit View.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, ViewModel.Main,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, Data.Bind.Components, Data.Bind.ObjectScope, Data.Bind.GenData,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.MultiView, System.Actions, FMX.ActnList, EnumerableAdapter, Model.Contact;

type
  TMainView = class(TForm)
    ListView1: TListView;
    bindsrcContacts: TPrototypeBindSource;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    ToolBar1: TToolBar;
    layoutMain: TLayout;
    procedure FormDestroy(Sender: TObject);
    procedure bindsrcContactsCreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
  private
    FViewModel : TMainViewModel;
    function GetViewModel: TMainViewModel;
    { Private declarations }
  public
    { Public declarations }
    property ViewModel : TMainViewModel read GetViewModel;
  end;

var
  MainView: TMainView;

implementation

{$R *.fmx}

{ TviewMain }


procedure TMainView.bindsrcContactsCreateAdapter(Sender: TObject;
  var ABindSourceAdapter: TBindSourceAdapter);
begin
  ABindSourceAdapter := TEnumerableBindSourceAdapter<TContact>.Create(bindsrcContacts,
                                                                      ViewModel.Contacts);
end;

procedure TMainView.FormDestroy(Sender: TObject);
begin
  FViewModel.Free;
end;

function TMainView.GetViewModel: TMainViewModel;
begin
  if not Assigned(FViewModel) then
  begin
    FViewModel := TMainViewModel.Create;
    FViewModel.CreateDummyData;
  end;
  Result := FViewModel;
end;

end.
