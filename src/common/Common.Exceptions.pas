unit Common.Exceptions;

interface
uses
  System.SysUtils;

type
  CRMVVMException = class(Exception);
    ModelException = class(CRMVVMException);
    ViewModelException = class(CRMVVMException);
    ViewException = class(CRMVVMException);

implementation

end.
