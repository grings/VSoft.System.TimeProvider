# VSoft.System.TimeProvider

This simple unit provides an abstraction over TDateTime.Now and TDateTime.NowUTC that makes it easier to write testable code.

Code that directly references `Now` or `NowUTC` is very difficult to unit test. Imagine you have a function that uses one of the many helper methods on `TDateTime.Now`, for example :

````Delphi
function TDiscountCalculator.GetDiscountForToday : integer;
begin
  if TDateTime.Now.DayOfWeek = 3 then
     result := 50
  else
    result := 0;
end;
````

Unit testing this function would be impossible. As simple fix to this is to inject an abstraction over `Now`

````Delphi
function TDiscountCalculator.GetDiscountForToday(const dateTimeProvider : IDateTimeProvider) : integer;
begin
  if dateTimeProvider.Now.DayOfWeek = 3 then
     result := 50
  else
    result := 0;
end;
````
Our `ITimeProvider` is mockable, so we can test this by either using a mocking framework, or providing our own implementation.

````Delphi
type
  {$M+} //mockable
  ITimeProvider = interface
  ['{6A876048-CA4D-47BC-93CE-E16382D43797}']
    function GetLocalNow : TDateTime;
    function GetUTCNow : TDateTime;

    property Now    : TDateTime read GetLocalNow;
    property NowUTC : TDateTime read GetUTCNow;
  end;

  TTimeProvider = class
  public
    class function Default : ITimeProvider;static;
  end;

````


````Delphi
procedure TDiscountTestFixture.Test_Discount_is_50_on_Tuesdays;
var
   discount : integer;
   dateTimeProviderMock : Mock<IDateTimeProvider>;
   mockNow L : TDateTime;
begin
   //arrange
    mockNow := EncodeDate(2025,4,1); 
    dateTimeProviderMock := TMock<IDateTimeProvider>.Create;
    dateTimeProviderMock.Setup.WillReturn(mockNow).When.Now();
  //act
    discount := FDiscountCalculator.GetDiscountForToday(dateTimeProviderMock);
  //assert
    Assert.AreEqual(50, discount);
end;
````

Use `TTimeProvider.Default` in your production code.  
