unit ViewModel.Main;

interface
uses
  Model.Contact, Generics.Collections;

type
  TMainViewModel = class
  private
    FContacts : TContacts;
    function GetContacts: TEnumerable<TContact>;
    function GetContactCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure CreateDummyData;
    property Contacts : TEnumerable<TContact> read GetContacts;
    property ContactCount: Integer read GetContactCount;
  end;


implementation

{ TMainViewModel }


constructor TMainViewModel.Create;
begin
  FContacts := TContacts.Create(True);
end;

destructor TMainViewModel.Destroy;
begin
  FContacts.Free;
  inherited;
end;

function TMainViewModel.GetContactCount: Integer;
begin
  Result := FContacts.Count;
end;

function TMainViewModel.GetContacts : TEnumerable<TContact>;
begin
  Result := FContacts.GetEnumerable;
end;

procedure TMainViewModel.CreateDummyData;
var
  LContact : TContact;
begin
  // temporarily create some Contacts just to bootstrap things
  LContact := FContacts.AddNewContact;
  LContact.ID := 1;
  LContact.Firstname := 'Fred';
  LContact.Lastname := 'Flintstone';

  LContact := FContacts.AddNewContact;
  LContact.ID := 2;
  LContact.Firstname := 'Wilma';
  LContact.Lastname := 'Flintstone';
end;

end.
