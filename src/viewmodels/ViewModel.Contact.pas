unit ViewModel.Contact;

interface
uses
  Model.Contact, Generics.Collections, MVVM.ViewModel;

type
  TViewModelState = (Viewing, Editing);
  TContactViewModel = class
  private
    FOriginalContact : TContact;
    FContact : TContact;
    FDoSaveContact: TModelObjectCommand<TContactViewModel, TContact>;
    FDoCancelContact: TModelObjectCommand<TContactViewModel, TContact>;
    function GetCanSave: Boolean;
  public
    constructor Create(AContact : TContact); virtual;
    destructor Destroy; override;
    procedure Save;
    procedure Cancel;
    property Contact : TContact read FContact;
    property CanSave : Boolean read GetCanSave;
    property DoSaveContact : TModelObjectCommand<TContactViewModel, TContact> read FDoSaveContact write FDoSaveContact;
    property DoCancelContact : TModelObjectCommand<TContactViewModel, TContact> read FDoCancelContact write FDoCancelContact;
  end;

implementation

{ TContactViewModel }

procedure TContactViewModel.Cancel;
begin
  // don't assign the staging back to FOriginalContact
  if Assigned(FDoCancelContact) then
    FDoCancelContact(self, FOriginalContact);
end;

constructor TContactViewModel.Create(AContact: TContact);
begin
  FOriginalContact := AContact;
  FContact := TContact.Create;
  FContact.Assign(FOriginalContact);
end;

destructor TContactViewModel.Destroy;
begin
  FContact.Free;
  inherited;
end;

function TContactViewModel.GetCanSave: Boolean;
begin
  Result := FContact.IsValid
end;

procedure TContactViewModel.Save;
begin
  FOriginalContact.Assign(FContact);
  if Assigned(FDoSaveContact) then
    FDoSaveContact(self, FOriginalContact);
end;

end.
