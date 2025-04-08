unit VSoft.System.TimeProvider;

interface

uses
  System.DateUtils;

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

implementation

uses
{$IFDEF MSWINDOWS}
  WinApi.Windows,
{$ENDIF}
  System.SysUtils;

type
  TDefaultTimeProvider = class(TInterfacedObject, ITimeProvider)
  protected
    function GetLocalTimeZone : TTimeZone;
    function GetLocalNow : TDateTime;
    function GetUTCNow : TDateTime;
  end;


{ TTimeProvider }

class function TTimeProvider.Default: ITimeProvider;
begin
  result := TDefaultTimeProvider.Create;
end;

{ TDefaultTimeProvider }


function TDefaultTimeProvider.GetLocalNow: TDateTime;
begin
  result := System.SysUtils.Now();
end;

function TDefaultTimeProvider.GetLocalTimeZone: TTimeZone;
begin
  result := TTimeZone.Local;
end;

//borrowed from 12.3 rtl since earlier versions did not have nowutc
function TDefaultTimeProvider.GetUTCNow: TDateTime;
{$IFDEF MSWINDOWS}
var
  SystemTime: TSystemTime;
begin
  GetSystemTime(SystemTime);
  Result := EncodeDate(SystemTime.wYear, SystemTime.wMonth, SystemTime.wDay) +
    EncodeTime(SystemTime.wHour, SystemTime.wMinute, SystemTime.wSecond, SystemTime.wMilliseconds);
end;
{$ENDIF MSWINDOWS}
{$IFDEF POSIX}
var
  T: time_t;
  TV: timeval;
  UT: tm;
begin
  gettimeofday(TV, nil);
  T := TV.tv_sec;
  gmtime_r(T, UT);
  Result := EncodeDate(UT.tm_year + 1900, UT.tm_mon + 1, UT.tm_mday) +
    EncodeTime(UT.tm_hour, UT.tm_min, UT.tm_sec, TV.tv_usec div 1000);
end;
{$ENDIF POSIX}

end.
