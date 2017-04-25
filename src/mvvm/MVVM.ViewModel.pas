unit MVVM.ViewModel;

interface
uses
  Generics.Collections, MVVM.Model;

type
  TViewModelCommand<TViewModel> = reference to procedure (ViewModel : TViewModel);

  TViewModelQuery<TReturnType> = reference to function : TReturnType;

  TModelObjectCommand<TModelObject> = reference to procedure (ModelObject : TModelObject);

  TModelObjectConfirm<TModelObject, TReturnType> = reference to function (ModelObject : TModelObject) : TReturnType;

  TBaseModalEditViewModel<TViewModel : class; TModelObject : class, constructor> = class
  protected
    FOriginalObject : TModelObject;
    FScratchObject : TModelObject;
    FDoSaveModelObject: TModelObjectCommand<TModelObject>;
    FDoCancelModelObject: TModelObjectCommand<TModelObject>;
    function GetCanSave: Boolean; virtual; abstract;
    procedure DoAssign(SourceObject, TargetObject : TModelObject); virtual; abstract;
  public
    constructor Create(AModelObject : TModelObject); virtual;
    destructor Destroy; override;
    procedure Save;
    procedure Cancel;
    property ModelObject : TModelObject read FScratchObject;
    property CanSave : Boolean read GetCanSave;
    property DoSaveModelObject : TModelObjectCommand<TModelObject> read FDoSaveModelObject write FDoSaveModelObject;
    property DoCancelModelObject : TModelObjectCommand<TModelObject> read FDoCancelModelObject write FDoCancelModelObject;
  end;

implementation



{ TBaseModalEditViewModel<TViewModel, TModelObject> }

procedure TBaseModalEditViewModel<TViewModel, TModelObject>.Cancel;
begin
  // don't assign the staging back to FOriginalObject
  if Assigned(FDoCancelModelObject) then
    FDoCancelModelObject(FOriginalObject);
end;

constructor TBaseModalEditViewModel<TViewModel, TModelObject>.Create(
  AModelObject: TModelObject);
begin
  FOriginalObject := AModelObject;
  FScratchObject := TModelObject.Create;
  DoAssign(FOriginalObject, FScratchObject);
//  FScratchObject.Assign(FOriginalObject);
end;

destructor TBaseModalEditViewModel<TViewModel, TModelObject>.Destroy;
begin
  FScratchObject.Free;
  inherited;
end;

procedure TBaseModalEditViewModel<TViewModel, TModelObject>.Save;
begin
//  FOriginalObject.Assign(FScratchObject);
  DoAssign(FScratchObject, FOriginalObject);
  if Assigned(FDoSaveModelObject) then
    FDoSaveModelObject(FOriginalObject);
end;

end.
