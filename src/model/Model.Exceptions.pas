unit Model.Exceptions;

interface
uses
  Common.Exceptions;

type
  NilParamException = class(ModelException);
  ObjectListException = class(ModelException);
    DuplicateObjectException = class(ObjectListException);


implementation

end.
