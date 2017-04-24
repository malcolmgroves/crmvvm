unit ViewModel.Contact;

interface
uses
  Model.Contact, Generics.Collections, MVVM.ViewModel;

type
  TContactViewModel = class
  private
    FOriginalContact : TContact;
    FContact : TContact;
    FOnSaveContact: TOnModelObjectNotify<TContactViewModel, TContact>;
    FOnCancelContact: TOnModelObjectNotify<TContactViewModel, TContact>;
    function GetCanSave: Boolean;
  public
    constructor Create(AContact : TContact); virtual;
    destructor Destroy; override;
    procedure Save;
    procedure Cancel;
    property Contact : TContact read FContact;
    property CanSave : Boolean read GetCanSave;
    property OnSaveContact : TOnModelObjectNotify<TContactViewModel, TContact> read FOnSaveContact write FOnSaveContact;
    property OnCancelContact : TOnModelObjectNotify<TContactViewModel, TContact> read FOnCancelContact write FOnCancelContact;
  end;

implementation

{ TContactViewModel }

procedure TContactViewModel.Cancel;
begin
  // don't assign the staging back to FOriginalContact
  if Assigned(FOnCancelContact) then
    FOnCancelContact(self, FOriginalContact);
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
  if Assigned(FOnSaveContact) then
    FOnSaveContact(self, FOriginalContact);
end;

end.
