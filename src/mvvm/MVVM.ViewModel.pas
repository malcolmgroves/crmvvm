unit MVVM.ViewModel;

interface

type
  TOnEditModelObject<TViewModel, TChildViewModel> = reference to procedure (ViewModel : TViewModel; ChildViewModel : TChildViewModel);

  TOnSaveModelObject<TViewModel, TModelObject> = reference to procedure (ViewModel : TViewModel; ModelObject : TModelObject);

implementation

end.
