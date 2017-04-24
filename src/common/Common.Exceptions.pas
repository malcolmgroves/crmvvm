unit Common.Exceptions;

interface
uses
  System.SysUtils;

type
  CRMVVMException = class(Exception);
    ModelException = class(CRMVVMException);
    ViewModelException = class(CRMVVMException);
      ViewModelMissingDelegateException = class(ViewModelException);
    ViewException = class(CRMVVMException);

implementation

end.
