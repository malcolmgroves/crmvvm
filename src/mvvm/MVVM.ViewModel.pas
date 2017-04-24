unit MVVM.ViewModel;

interface

type
  TOnChildViewModelNotify<TViewModel, TChildViewModel> = reference to procedure (ViewModel : TViewModel; ChildViewModel : TChildViewModel);

  TOnModelObjectNotify<TViewModel, TModelObject> = reference to procedure (ViewModel : TViewModel; ModelObject : TModelObject);

  TOnModelObjectFunc<TViewModel, TModelObject, TReturnType> = reference to function (ViewModel : TViewModel; ModelObject : TModelObject) : TReturnType;

  TOnViewModelNotify<TViewModel> = reference to procedure(ViewModel : TViewModel);

implementation

end.
