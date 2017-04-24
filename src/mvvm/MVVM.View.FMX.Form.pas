unit MVVM.View.FMX.Form;

interface
uses
  FMX.Forms, System.Classes;

type
  TFormView<TViewModel: class, constructor> = class(TForm)
  private
    FViewModel : TViewModel;
    FOwnsViewModel : Boolean;
    function GetViewModel: TViewModel;
  protected
    property ViewModel : TViewModel read GetViewModel;
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; AViewModel : TViewModel); reintroduce; overload;
    destructor Destroy; override;
  end;


implementation

{ TFormView<TViewModel> }

constructor TFormView<TViewModel>.Create(AOwner: TComponent);
begin
  inherited;
  FOwnsViewModel := True;
end;

constructor TFormView<TViewModel>.Create(AOwner: TComponent;
  AViewModel: TViewModel);
begin
  FViewModel := AViewModel;  // before rest of constructor to ensure ViewModel is stored before OnAdapter event of BindSource runs
  Create(AOwner);
  FOwnsViewModel := False;
end;

destructor TFormView<TViewModel>.Destroy;
begin
  if FOwnsViewModel then
    FViewModel.Free;
  inherited;
end;

function TFormView<TViewModel>.GetViewModel: TViewModel;
begin
  if not Assigned(FViewModel) then
    FViewModel := TViewModel.Create;
  Result := FViewModel;
end;

end.
