{********************************************************************}
{                                                                    }
{ written by TMS Software                                            }
{            copyright © 2019                                        }
{            Email : info@tmssoftware.com                            }
{            Web : http://www.tmssoftware.com                        }
{                                                                    }
{ The source code is given as is. The author is not responsible      }
{ for any possible damage done due to the use of this code.          }
{ The complete source code remains property of the author and may    }
{ not be distributed, published, given or sold in any form as such.  }
{ No parts of the source code can be included in any other component }
{ or application without written authorization of the author.        }
{********************************************************************}

unit WEBLib.TMSFNCCloudGoogleTextToSpeech;

{$I WEBLib.TMSFNCDefines.inc}

{$IFDEF WEBLIB}
{$DEFINE LCLWEBLIB}
{$ENDIF}

{$IFDEF LCLLIB}
{$DEFINE LCLWEBLIB}
{$ENDIF}

interface

uses
  Classes, SysUtils, WEBLib.TMSFNCCloudBase, WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils
  {$IFDEF WEBLIB}
  ,WEBLib.JSON, JS, Contnrs
  {$ENDIF}
  {$IFDEF FMXLIB}
  ,JSON, Generics.Collections
  {$ENDIF}
  {$IFDEF VCLLIB}
  ,JSON, Generics.Collections
  {$ENDIF}
  {$IFDEF LCLLIB}
  ,fpjson, jsonparser, fgl
  {$ENDIF}
  ;

const
  MAJ_VER = 1; // Major version nr.
  MIN_VER = 0; // Minor version nr.
  REL_VER = 0; // Release nr.
  BLD_VER = 0; // Build nr.

  //v1.0.0.0 : First release

type
  TTMSFNCCustomCloudGoogleTextToSpeech = class;
  TTMSFNCCloudGoogleTextToSpeechVoices = class;
  TTMSFNCCloudGoogleTextToSpeechVoice = class;

  TTMSFNCCloudGoogleTextToSpeechEvent = procedure(Sender: TObject; const ABase64Audio: string; const ARequestResult: TTMSFNCCloudBaseRequestResult) of object;

  TTMSFNCCloudGoogleVoiceListEvent = procedure(Sender: TObject; const AVoices: TTMSFNCCloudGoogleTextToSpeechVoices; const ARequestResult: TTMSFNCCloudBaseRequestResult) of object;

  TTMSFNCCloudGoogleTextToSpeechAudioEncoding = (tsLinear16, tsMP3, tsOGG_OPUS);
  TTMSFNCCloudGoogleTextToSpeechTextFormat = (tsText, tsSSML);

  TTMSFNCCloudGoogleTextToSpeechVoice = class(TCollectionItem)
  private
    FName: string;
    FGender: string;
    FLanguageCodes: Tstringlist;
    FSampleRateHertz: Integer;
    FSpeakingRate: double;
    FPitch: Double;
    FVolumeGain: Double;
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure FromJSON(jo: TJSONValue);
  published
    property Name: string read FName write FName;
    property Gender: string read FGender write FGender;
    property SampleRateHertz: Integer read FSampleRateHertz write FSampleRateHertz;
    property SpeakingRate: double read FSpeakingRate write FSpeakingRate;
    property Pitch: double read FPitch write FPitch;
    property VolumeGain: double read FVolumeGain write FVolumeGain;
    property Languagecodes: TStringList read FLanguageCodes write FLanguageCodes;
  end;

  TTMSFNCCloudGoogleTextToSpeechVoices = class(TownedCollection)
    private
    FOwner: TTMSFNCCustomCloudBase;
    function GetItems(Index: Integer): TTMSFNCCloudGoogleTextToSpeechVoice;
    procedure SetItems(Index: Integer; const Value: TTMSFNCCloudGoogleTextToSpeechVoice);
  public
    constructor Create(AOwner: TTMSFNCCustomCloudGoogleTextToSpeech);
    function Add: TTMSFNCCloudGoogleTextToSpeechVoice;
    function Insert(Index: Integer):TTMSFNCCloudGoogleTextToSpeechVoice;
    function GetOwner: TPersistent; override;
    property Items[Index: Integer]: TTMSFNCCloudGoogleTextToSpeechVoice read GetItems write SetItems; default;
  end;

  TTMSFNCCustomCloudGoogleTextToSpeech = class(TTMSFNCSimpleCloudBase)
  private
    FVoices: TTMSFNCCloudGoogleTextToSpeechVoices;
    FOnTextToSpeech: TTMSFNCCloudGoogleTextToSpeechEvent;
    FOnGetVoicesEvent: TTMSFNCCloudGoogleVoiceListEvent;
    FAudioEncoding: TTMSFNCCloudGoogleTextToSpeechAudioEncoding;
    FTextFormat: TTMSFNCCloudGoogleTextToSpeechTextFormat;
  protected
    procedure DoRequestGetVoices(const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure DoRequestTextToSpeech(const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure DoGetVoices(const AVoices: TTMSFNCCloudGoogleTextToSpeechVoices; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure DoTextToSpeech (const ABase64 :string ; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    function GetVersion: string; override;
    property OnGetVoices : TTMSFNCCloudGoogleVoiceListEvent read FOnGetVoicesEvent write FOnGetVoicesEvent;
    property OnTextToSpeech : TTMSFNCCloudGoogleTextToSpeechEvent Read FOnTextToSpeech write FOnTextToSpeech;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure TextToSpeech(const AText: String); overload;
    procedure TextToSpeech(const AText, ALanguagecode, AName: String); overload;
    procedure TextToSpeech(const AText, ALanguagecode: string; const AVoice: TTMSFNCCloudGoogleTextToSpeechVoice); overload;
    procedure GetVoices(); overload;
    procedure GetVoices(const AlanguageCode : string); overload;
  end;

  {$IFNDEF LCLLIB}
  [ComponentPlatformsAttribute(TMSPlatformsWeb)]
  {$ENDIF}
  TTMSFNCCloudGoogleTextToSpeech = class(TTMSFNCCustomCloudGoogleTextToSpeech)
  private
  protected
    procedure RegisterRuntimeClasses; override;
  published
    property OnGetVoices;
    property OnTextToSpeech;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS FNC Cloud', [TTMSFNCCloudGoogleTextToSpeech]);
end;

constructor TTMSFNCCustomCloudGoogleTextToSpeech.Create(AOwner: TComponent);
begin
  inherited;
  Service.DeveloperURL := 'https://console.cloud.google.com';
  Service.BaseURL := 'https://texttospeech.googleapis.com';
  Service.Name := 'Google TextToSpeech';
  FVoices := TTMSFNCCloudGoogleTextToSpeechVoices.Create(self);
  FAudioEncoding := tsLinear16;
  FTextFormat := tsSSML;
end;

destructor TTMSFNCCustomCloudGoogleTextToSpeech.Destroy;
begin
  FVoices.Free;
  inherited;
end;

procedure TTMSFNCCustomCloudGoogleTextToSpeech.DoRequestTextToSpeech(const ARequestResult: TTMSFNCCloudBaseRequestResult);
var 
  j :TJSONValue;
  base64 : string;
begin
  if ARequestResult.ResultString <> '' then
  begin
    j := TTMSFNCUtils.ParseJSON(ARequestResult.ResultString);
    try
      base64 := TTMSFNCUtils.GetJSONProp(j,'audioContent');
    finally
      j.Free;
    end;
  end;
  DoTextToSpeech(base64, ARequestResult);
end;

procedure TTMSFNCCustomCloudGoogleTextToSpeech.DoRequestGetVoices(const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  j, jo, ja: TJSONValue;
  I: integer;
  voice: TTMSFNCCloudGoogleTextToSpeechVoice;
begin
  if ARequestResult.ResultString <> '' then
  begin
    j := TTMSFNCUtils.ParseJSON(ARequestResult.ResultString);
    if Assigned(j) then
    try
      begin
        ja := TTMSFNCUtils.GetJSONValue(j,'voices');
        if Assigned(ja) and (ja is TJSONArray) then
        begin
          for I := 0 to TTMSFNCUtils.GetJSONArraySize(ja as TJSONArray) - 1  do
          begin
            jo := TTMSFNCUtils.GetJSONArrayItem(ja as TJSONArray, I);
            if Assigned(jo) then
            begin
              voice := FVoices.Add;
              voice.FromJSON(jo);
            end;
          end;
        end;
      end;
    finally
      j.free;
    end;
  end;
  DoGetVoices(FVoices, ARequestResult);
end;

procedure TTMSFNCCustomCloudGoogleTextToSpeech.DoTextToSpeech(const ABase64: string; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if Assigned(OnTextToSpeech) then
    OnTextToSpeech(self, ABase64, ARequestResult);
end;

procedure TTMSFNCCustomCloudGoogleTextToSpeech.DoGetVoices(const AVoices: TTMSFNCCloudGoogleTextToSpeechVoices; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if Assigned(OnGetVoices) then
    OnGetVoices(Self, AVoices, ARequestResult);
end;

procedure TTMSFNCCustomCloudGoogleTextToSpeech.GetVoices;
begin
  FVoices.Clear;

  Request.Clear;
  Request.Host := Service.BaseURL;
  Request.Path := '/v1/voices';
  Request.Query := 'key=' + Authentication.Key;
  Request.Method := rmGET;
  ExecuteRequest({$IFDEF LCLWEBLIB}@{$ENDIF}DoRequestGetVoices);
end;

procedure TTMSFNCCustomCloudGoogleTextToSpeech.GetVoices(const AlanguageCode: string);
begin
  FVoices.Clear;

  Request.Clear;
  Request.Host := Service.BaseURL;
  Request.Path := '/v1/voices';
  Request.Query := 'LanguageCode=' + AlanguageCode + '&key=' + Authentication.Key;
  Request.Method := rmGET;
  ExecuteRequest({$IFDEF LCLWEBLIB}@{$ENDIF}DoRequestGetVoices);
end;

function TTMSFNCCustomCloudGoogleTextToSpeech.GetVersion: string;
begin
  Result := GetVersionNumber(MAJ_VER, MIN_VER, REL_VER, BLD_VER);
end;

procedure TTMSFNCCustomCloudGoogleTextToSpeech.TextToSpeech(const AText, ALanguagecode: string; const AVoice: TTMSFNCCloudGoogleTextToSpeechVoice);
var
  InputType, audioCoding: string;
begin
  if FTextFormat = tsText then
    InputType := 'text';
  if FTextFormat = tsSSML then
    InputType := 'ssml';

  if FAudioEncoding = tsLinear16 then
    audioCoding := 'LINEAR16';
  if FAudioEncoding = tsMP3 then
    audioCoding := 'MP3';
  if FAudioEncoding = tsOGG_OPUS then
    audioCoding :='OGG_OPUS';

  Request.Clear;
  Request.Host := Service.BaseURL;
  Request.Path := '/v1/text:synthesize';
  Request.Query := '&key=' + Authentication.Key;
  Request.Method := rmPOST;
  Request.PostData := '{"input":'+ #13#10
  +'{"' + InputType + '":"' + AText + '"},' + #13#10 +
  '"voice":{"name":"' + AVoice.Name + '",' + #13#10 +
  '"languageCode":"' + ALanguagecode + '"},' + #13#10 +
  '"audioConfig":{"sampleRateHertz":' + IntToStr(AVoice.SampleRateHertz) + ',' + #13#10 +
  '"audioEncoding":"' + audioCoding + '",' +   #13#10 +
  '"speakingRate": '+ FloatToStr(AVoice.SpeakingRate) +',' + #13#10 +
  ' "pitch":' + FloatToStr(AVoice.Pitch) + ','+ #13#10 +
  ' "volumeGainDb" :' + FloatToStr(AVoice.VolumeGain) + #13#10 + '}}';
  Request.AddHeader('Content-Type','application/json');
  ExecuteRequest({$IFDEF LCLWEBLIB}@{$ENDIF}DoRequestTextToSpeech);
end;

procedure TTMSFNCCustomCloudGoogleTextToSpeech.TextToSpeech(const AText, ALanguageCode, AName: String);
var
  fVoice: TTMSFNCCloudGoogleTextToSpeechVoice;
begin
  fVoice := TTMSFNCCloudGoogleTextToSpeechVoice.Create(FVoices);
  fVoice.FName := AName;

  TextToSpeech(AText,ALanguagecode,fVoice);
  fVoice.Free;
end;

procedure TTMSFNCCustomCloudGoogleTextToSpeech.TextToSpeech(const AText: String);
begin
  TextToSpeech( AText, 'en-US-Wavenet-A', 'en-US');
end;

procedure TTMSFNCCloudGoogleTextToSpeech.RegisterRuntimeClasses;
begin
  inherited;
  RegisterClass(TTMSFNCCloudGoogleTextToSpeech);
end;

{ TTMSFNCCloudGoogleTextToSpeechVoice }

procedure TTMSFNCCloudGoogleTextToSpeechVoice.Assign(Source: TPersistent);
begin
  inherited;
  if (Source is TTMSFNCCloudGoogleTextToSpeechVoice) then
  begin
    FName := (Source as TTMSFNCCloudGoogleTextToSpeechVoice).FName;
    FGender := (Source as TTMSFNCCloudGoogleTextToSpeechVoice).FGender;
    FSampleRateHertz := (Source as TTMSFNCCloudGoogleTextToSpeechVoice).FSampleRateHertz;
  end
  else
    inherited;
end;

constructor TTMSFNCCloudGoogleTextToSpeechVoice.Create(ACollection: TCollection);
begin
  inherited;
  FName := EmptyStr;
  FGender := EmptyStr;
  FLanguageCodes := TStringList.Create;
  FSampleRateHertz := 24000;
  FSpeakingRate := 1.0;
  FPitch := 0.0;
  FVolumeGain := 0.0;
end;

destructor TTMSFNCCloudGoogleTextToSpeechVoice.Destroy;
begin
  FLanguageCodes.Free;
  inherited;
end;

procedure TTMSFNCCloudGoogleTextToSpeechVoice.FromJSON(jo: TJSONValue);
var
  ja: TJSONValue;
  i: Integer;
begin
  ja := TTMSFNCUtils.GetJSONValue(jo,'languageCodes');
  if Assigned(ja) and (ja is TJSONArray) then
  begin
    for I := 0 to TTMSFNCUtils.GetJSONArraySize(ja as TJSONArray) - 1 do
    begin
      fLanguageCodes.Add(TTMSFNCUtils.GetJSONArrayItem(ja as TJSONArray, I).Value)
    end;
  end;
  FName := TTMSFNCUtils.GetJSONProp(jo,'name');
  FGender := TTMSFNCUtils.GetJSONProp(jo,'ssmlGender');
  FSampleRateHertz := TTMSFNCUtils.GetJSONIntegerValue(jo,'naturalSampleRateHertz');
end;

{ TTMSFNCCloudGoogleTextToSpeechVoices }

function TTMSFNCCloudGoogleTextToSpeechVoices.Add: TTMSFNCCloudGoogleTextToSpeechVoice;
begin
   Result := TTMSFNCCloudGoogleTextToSpeechVoice(inherited Add);
end;

constructor TTMSFNCCloudGoogleTextToSpeechVoices.Create(AOwner: TTMSFNCCustomCloudGoogleTextToSpeech);
begin
  inherited Create(AOwner, TTMSFNCCloudGoogleTextToSpeechVoice);
end;

function TTMSFNCCloudGoogleTextToSpeechVoices.GetItems(Index: Integer): TTMSFNCCloudGoogleTextToSpeechVoice;
begin
  Result := TTMSFNCCloudGoogleTextToSpeechVoice(inherited Items[Index]);
end;

function TTMSFNCCloudGoogleTextToSpeechVoices.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TTMSFNCCloudGoogleTextToSpeechVoices.Insert(Index: Integer): TTMSFNCCloudGoogleTextToSpeechVoice;
begin
  Result := TTMSFNCCloudGoogleTextToSpeechVoice(inherited Insert(Index));
end;

procedure TTMSFNCCloudGoogleTextToSpeechVoices.SetItems(Index: Integer; const Value: TTMSFNCCloudGoogleTextToSpeechVoice);
begin
  inherited Items[Index] := Value;
end;

end.
