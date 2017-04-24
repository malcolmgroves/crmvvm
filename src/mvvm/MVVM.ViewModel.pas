unit MVVM.ViewModel;

interface

type
  TViewModelCommand<TViewModel> = reference to procedure (ViewModel : TViewModel);

  TModelObjectCommand<TViewModel, TModelObject> = reference to procedure (ViewModel : TViewModel; ModelObject : TModelObject);

  TModelObjectConfirm<TViewModel, TModelObject, TReturnType> = reference to function (ViewModel : TViewModel; ModelObject : TModelObject) : TReturnType;

implementation

end.
