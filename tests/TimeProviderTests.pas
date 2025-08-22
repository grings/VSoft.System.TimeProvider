unit TimeProviderTests;

interface

uses
  System.TimeSpan,
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestTimeProviderFixture = class
  public
    [Test]
    procedure Discount_is_50_on_Tuesdays_UsingMock;
    [Test]
    procedure Discount_is_50_on_Tuesdays_UsingImpl;
  end;

implementation

uses
  System.SysUtils,
  VSoft.System.TimeProvider,
  Delphi.Mocks, DiscountCalculator;

type
  TTestTimeProvider = class(TInterfacedObject, ITimeProvider)
  private
    FNow : TDateTime;
    FNowUTC : TDateTime;
  protected
    function GetLocalNow : TDateTime;
    function GetUTCNow : TDateTime;
  public
    constructor Create(now : TDateTime; utcNow : TDateTime);
  end;


procedure TTestTimeProviderFixture.Discount_is_50_on_Tuesdays_UsingImpl;
var
  mockNow : TDateTime;
  timeProviderMock : ITimeProvider;
  discountCalc : TDiscountCalculator;
  discount : integer;
begin
   //arrange
    mockNow := EncodeDate(2025,4,1);   //a tuesday!
    //not using utc so ignore it for now
    timeProviderMock := TTestTimeProvider.Create(mockNow, mockNow);
    discountCalc := TDiscountCalculator.Create(timeProviderMock);
  //act
    discount := discountCalc.GetDiscountForToday;
  //assert
    Assert.AreEqual(50, discount);

end;

procedure TTestTimeProviderFixture.Discount_is_50_on_Tuesdays_UsingMock;
var
  mockNow : TDateTime;
  timeProviderMock : TMock<ITimeProvider>;
  discountCalc : TDiscountCalculator;
  discount : integer;
begin
   //arrange
    mockNow := EncodeDate(2025,4,1);   //a tuesday!
    timeProviderMock := TMock<ITimeProvider>.Create;
    timeProviderMock.Setup.WillReturn(mockNow).When.Now;
    discountCalc := TDiscountCalculator.Create(timeProviderMock);
  //act
    discount := discountCalc.GetDiscountForToday;
  //assert
    Assert.AreEqual(50, discount);
end;


{ TTestTimeProvider }

constructor TTestTimeProvider.Create(now: TDateTime; utcNow : TDateTime);
begin
  FNow := now;
  FNowUTC := utcnow;

end;

function TTestTimeProvider.GetLocalNow: TDateTime;
begin
  result := FNow;
end;

function TTestTimeProvider.GetUTCNow: TDateTime;
begin
  result := FNowUTC;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestTimeProviderFixture);

end.
