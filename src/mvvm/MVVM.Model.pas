unit MVVM.Model;

interface
uses
  Generics.Collections;

type
  TObjectEnumerable<TModelObject : class> = class
    FObjects : TObjectList<TModelObject>;
    function GetCount: Integer;
  public
    constructor Create(OwnsObjects : boolean = False); virtual;
    destructor Destroy; override;
    function GetEnumerable: TEnumerable<TModelObject>;
    function Contains(Item : TModelObject) : boolean;
    procedure LoadFromList(List : TList<TModelObject>; OwnsList : Boolean = True);
    property Count : Integer read GetCount;
  end;

implementation
uses
  Model.Exceptions;

{ TObjectEnumerable<TModelObject> }

function TObjectEnumerable<TModelObject>.Contains(
  Item: TModelObject): boolean;
begin
  if not Assigned(Item) then
    raise NilParamException.Create('Object passed in is not Assigned');

  Result := FObjects.Contains(Item);
end;

constructor TObjectEnumerable<TModelObject>.Create(OwnsObjects: boolean);
begin
  FObjects := TObjectList<TModelObject>.Create(OwnsObjects);
end;

destructor TObjectEnumerable<TModelObject>.Destroy;
begin
  FObjects.Free;
  inherited;
end;

function TObjectEnumerable<TModelObject>.GetCount: Integer;
begin
  Result := FObjects.Count;
end;

function TObjectEnumerable<TModelObject>.GetEnumerable: TEnumerable<TModelObject>;
begin
  Result := FObjects;
end;

procedure TObjectEnumerable<TModelObject>.LoadFromList(
  List: TList<TModelObject>; OwnsList : Boolean);
var
  LModelObject : TModelObject;
begin
  for LModelObject in List do
    FObjects.Add(LModelObject);
  if OwnsList then
    List.Free;
end;

end.
