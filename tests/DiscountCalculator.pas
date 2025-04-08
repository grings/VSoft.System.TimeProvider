unit DiscountCalculator;

interface

uses
  VSoft.System.TimeProvider;

type
  TDiscountCalculator = class
  private
    FTimeProvider : ITimeProvider;
  public
    constructor Create(const timeProvider : ITimeProvider);
    function GetDiscountForToday : integer;
  end;

implementation

uses
    System.DateUtils;

{ TDicountCalculator }

constructor TDiscountCalculator.Create(const timeProvider: ITimeProvider);
begin
  FTimeProvider := timeProvider;
end;

function TDiscountCalculator.GetDiscountForToday: integer;
begin
  if DayOfTheWeek(FTimeProvider.Now) = 2 then
    result := 50
  else
    result := 0;
end;

end.
