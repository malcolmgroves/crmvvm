unit Common.Messages;

interface
uses
  System.Messaging, ViewModel.Sub.Contacts, ViewModel.Sub.COmpanies, ViewModel.Main;

type

  TOnContactsUpdated = class(TObjectMessage<TContactsSubViewModel>);
  TOnCompaniesUpdated = class(TObjectMessage<TCompaniesSubViewModel>);

function MessageManager : TMessageManager;

implementation

function MessageManager : TMessageManager;
begin
  Result := TMessageManager.DefaultManager;
end;

end.
