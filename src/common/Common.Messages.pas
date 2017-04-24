unit Common.Messages;

interface
uses
  System.Messaging, ViewModel.Main;

type

  TOnContactsUpdated = class(TObjectMessage<TMainViewModel>);
  TOnCompaniesUpdated = class(TObjectMessage<TMainViewModel>);

function MessageManager : TMessageManager;

implementation

function MessageManager : TMessageManager;
begin
  Result := TMessageManager.DefaultManager;
end;

end.
