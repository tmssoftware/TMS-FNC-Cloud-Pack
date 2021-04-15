{********************************************************************}
{                                                                    }
{ written by TMS Software                                            }
{            copyright (c) 2019                                      }
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

unit LCLTMSFNCCloudGoogleTranslate;

{$I LCLTMSFNCDefines.inc}

{$IFDEF WEBLIB}
{$DEFINE LCLWEBLIB}
{$ENDIF}

{$IFDEF LCLLIB}
{$DEFINE LCLWEBLIB}
{$ENDIF}

interface

uses
  Classes, LCLTMSFNCCloudOAuth, LCLTMSFNCCloudBase, LCLTMSFNCTypes, LCLTMSFNCUtils
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
  TTMSFNCCustomCloudGoogleTranslate = class;
  TTMSFNCCloudGoogleTranslateTranslation = class;
  TTMSFNCCloudGoogleTranslateTranslations = class;
  TTMSFNCCloudGoogleTranslateDetections = class;
  TTMSFNCCloudGoogleTranslateDetection = class;
  
  TTMSFNCCloudGoogleTranslateGetSupportedLanguagesEvent = procedure(Sender: TObject; const ALanguages: TStringList; const ARequestResult: TTMSFNCCloudBaseRequestResult) of object;
  TTMSFNCCloudGoogleTranslateTranslateTextEvent = procedure(Sender: TObject; const ATranslations: TTMSFNCCloudGoogleTranslateTranslations; const ARequestResult: TTMSFNCCloudBaseRequestResult) of object;
  TTMSFNCCloudGoogleTranslateDetectLanguageEvent = procedure(Sender: TObject; const ADetections: TTMSFNCCloudGoogleTranslateDetections; const ARequestResult: TTMSFNCCloudBaseRequestResult) of object;
  
  TTMSFNCCloudGoogleTranslateModel = (tmNMT, tmPBMT);

  TTMSFNCCloudGoogleTranslateTranslation = class(TCollectionItem)
  private
    FSourceLanguage: string;
    FTranslatedText: string;
    FSourceText: string;
    FModel: string;
  public
    constructor Create(ACollection: TCollection);  override;
    procedure Assign(Source: TPersistent); override;
    procedure FromJSON(jo: TJSONValue);
  published
    property SourceLanguage: string read FSourceLanguage write FSourceLanguage;
    property TranslatedText: string read FTranslatedText write FTranslatedText;
    property UsedModel: String read FModel write FModel;
    property SourceText: string read FSourceText write FSourceText;
  end;

  TTMSFNCCloudGoogleTranslateTranslations = class(TOwnedCollection)
  private
    FOwner: TTMSFNCCustomCloudBase;
    function GetItems(Index: Integer): TTMSFNCCloudGoogleTranslateTranslation;
    procedure SetItems(Index: Integer; const Value: TTMSFNCCloudGoogleTranslateTranslation);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TTMSFNCCustomCloudGoogleTranslate);
    function GetOwner: TPersistent; override;
    function Add: TTMSFNCCloudGoogleTranslateTranslation;
    function Insert(Index: Integer): TTMSFNCCloudGoogleTranslateTranslation;
    property Items[Index: Integer]: TTMSFNCCloudGoogleTranslateTranslation read GetItems write SetItems; default;
  end;

  TTMSFNCCloudGoogleTranslateDetection = class(TCollectionItem)
  private
    FSourceText: string;
    FSourceLang: string;
  public
    constructor Create(ACollection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
    procedure FromJSON(jo: TJSONValue);
  published
    property SourceText: string read FSourceText write FSourceText;
    property SourceLanguage: string read FSourceLang write FSourceLang;
  end;
  
  TTMSFNCCloudGoogleTranslateDetections = class(TOwnedCollection)
  private
    FOwner: TTMSFNCCustomCloudBase;
    function GetItems(Index: Integer): TTMSFNCCloudGoogleTranslateDetection;
    procedure SetItems(Index: Integer; const Value: TTMSFNCCloudGoogleTranslateDetection);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TTMSFNCCustomCloudGoogleTranslate);
    function GetOwner: TPersistent; override;
    function Add: TTMSFNCCloudGoogleTranslateDetection;
    function Insert(Index: Integer): TTMSFNCCloudGoogleTranslateDetection;
    property Items[Index: Integer]: TTMSFNCCloudGoogleTranslateDetection read GetItems write SetItems; default;
  end;
  
  TTMSFNCCustomCloudGoogleTranslate = class(TTMSFNCSimpleCloudOAuth)
  private
    FSupportedLanguages: TStringList;
    FTranslations: TTMSFNCCloudGoogleTranslateTranslations;
    FDetections: TTMSFNCCloudGoogleTranslateDetections;
    FTranslateModel: TTMSFNCCloudGoogleTranslateModel;
    FLanguagesEvent: TTMSFNCCloudGoogleTranslateGetSupportedLanguagesEvent;
    FTranslateEvent: TTMSFNCCloudGoogleTranslateTranslateTextEvent;
    FDetectLanguageEvent: TTMSFNCCloudGoogleTranslateDetectLanguageEvent;
  protected
    function GetVersion: string; override;
    procedure DoRequestGetSupportedLanguages(const ARequestResult: TTMSFNCCloudBaseRequestResult); virtual;
    procedure DoRequestTranslateText(const ARequestResult: TTMSFNCCloudBaseRequestResult); virtual;
    procedure DoRequestDetectLanguage(const ARequestResult: TTMSFNCCloudBaseRequestResult); virtual;

    procedure DoGetSupportedLanguages(const ALanguages: TStringList; const ARequestResult: TTMSFNCCloudBaseRequestResult); virtual;
    procedure DoTranslateText(const ATranslations: TTMSFNCCloudGoogleTranslateTranslations; const ARequestResult: TTMSFNCCloudBaseRequestResult); virtual;
    procedure DoDetectLanguage(const ADetections: TTMSFNCCloudGoogleTranslateDetections; const ARequestResult: TTMSFNCCloudBaseRequestResult); virtual;
    
    property OnGetSupportedLanguages: TTMSFNCCloudGoogleTranslateGetSupportedLanguagesEvent read FLanguagesEvent write FLanguagesEvent;
    property OnTranslateText: TTMSFNCCloudGoogleTranslateTranslateTextEvent read FTranslateEvent write FTranslateEvent;
    property OnDetectLanguage: TTMSFNCCloudGoogleTranslateDetectLanguageEvent read FDetectLanguageEvent write FDetectLanguageEvent;
    
    property TranslateModel: TTMSFNCCloudGoogleTranslateModel read FTranslateModel write FTranslateModel default tmNMT;
    property SupportedLanguages: TStringList read FSupportedLanguages;
    property Translations: TTMSFNCCloudGoogleTranslateTranslations read FTranslations write FTranslations;
    property Detections: TTMSFNCCloudGoogleTranslateDetections read FDetections write FDetections;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure TranslateText(const AText, ATarget: string); overload; virtual;
    procedure TranslateText(const AText: TStringList; const ATarget: string); overload; virtual;
    procedure GetSupportedLanguages(const ALanguage: string = 'en'); virtual;
    procedure DetectLanguage(const AText: string); overload; virtual;
    procedure DetectLanguage(const AText: TStringList); overload; virtual;
  end;

  {$IFNDEF LCLLIB}
  [ComponentPlatformsAttribute(TMSPlatformsWeb)]
  {$ENDIF}
  TTMSFNCCloudGoogleTranslate = class(TTMSFNCCustomCloudGoogleTranslate)
  protected
    procedure RegisterRuntimeClasses; override;
  public
    property SupportedLanguages;
    property Translations;
    property Detections;
  published
    property OnGetSupportedLanguages;
    property OnTranslateText;
    property OnDetectLanguage;
    property TranslateModel;
  end;

procedure Register;

implementation

{$IFDEF WEBLIB}
uses
  WEBLib.DesignIntf;
{$ENDIF}

procedure Register;
begin
  RegisterComponents('TMS FNC Cloud', [TTMSFNCCloudGoogleTranslate]);
end;

constructor TTMSFNCCustomCloudGoogleTranslate.Create(AOwner: TComponent);
begin
  inherited;
  Service.DeveloperURL := 'https://console.cloud.google.com';
  Service.BaseURL := 'https://translation.googleapis.com';
  Service.Name := 'Google Translate';
  FSupportedLanguages := TStringList.Create;
  FTranslations := TTMSFNCCloudGoogleTranslateTranslations.Create(Self);
  FDetections := TTMSFNCCloudGoogleTranslateDetections.Create(Self);
  FTranslateModel := tmNMT;
end;

destructor TTMSFNCCustomCloudGoogleTranslate.Destroy;
begin
  FSupportedLanguages.Free;
  FTranslations.Free;
  FDetections.Free;
  inherited;
end;

procedure TTMSFNCCustomCloudGoogleTranslate.DetectLanguage(const AText: TStringList);
var
  s: string;
  I: Integer;
  ts: TStringlist;
begin
  FDetections.Clear;
  if AText.Count <= 0 then
    Exit;

  s := '{' + #13#10;
  s := s + '  "q": [' + #13#10;

  for I := 0 to AText.Count - 1 do
    s := s + '    "' + AText[I] + '",' + #13#10;

  s := s + '  ]' + #13#10;
  s := s + '}';

  Request.Clear;
  Request.Host := Service.BaseURL;
  Request.Path := '/language/translate/v2/detect';
  Request.Name := 'DETECT LANGUAGES';
  Request.Query := 'key=' + Authentication.Key;
  Request.Method := rmPOST;
  Request.AddHeader('Content-Type','application/json');
  Request.PostData := s;

  ts := TStringList.Create;
  ts.Assign(AText);

  Request.DataObject := ts;
  ExecuteRequest({$IFDEF LCLWEBLIB}@{$ENDIF}DoRequestDetectLanguage);
end;

procedure TTMSFNCCustomCloudGoogleTranslate.DetectLanguage(const AText: string);
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    sl.Add(AText);
    DetectLanguage(sl);
  finally
    sl.Free;
  end;
end;

procedure TTMSFNCCustomCloudGoogleTranslate.DoDetectLanguage(const ADetections: TTMSFNCCloudGoogleTranslateDetections; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if Assigned(OnDetectLanguage) then
    OnDetectLanguage(self, ADetections, ARequestResult);
end;

procedure TTMSFNCCustomCloudGoogleTranslate.DoGetSupportedLanguages(const ALanguages: TStringList; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if Assigned(OnGetSupportedLanguages) then
    OnGetSupportedLanguages(Self, ALanguages, ARequestResult);
end;

procedure TTMSFNCCustomCloudGoogleTranslate.DoTranslateText(const ATranslations: TTMSFNCCloudGoogleTranslateTranslations; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if Assigned(OnTranslateText) then
    OnTranslateText(Self, ATranslations, ARequestResult);
end;

procedure TTMSFNCCustomCloudGoogleTranslate.DoRequestDetectLanguage(const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  j, jo, jo2, ja, ja2: TJSONValue;
  dt: TTMSFNCCloudGoogleTranslateDetection;
  tp : TStringList;
  I, I2: Integer;
begin
  tp := TStringList(ARequestResult.DataObject);
  if Assigned(tp) then
  begin
    try
      if ARequestResult.ResultString <> '' then
      begin
        j := TTMSFNCUtils.ParseJSON(ARequestResult.ResultString);
        if Assigned(j) then
        try
          jo := TTMSFNCUtils.GetJSONValue(j, 'data');
          if Assigned(jo) then
          begin
            ja := TTMSFNCUtils.GetJSONValue(jo, 'detections');
            if Assigned(ja) and(ja is TJSONArray) and (TTMSFNCUtils.GetJSONArraySize(ja as TJSONArray) = tp.Count) then
            begin
              for I := 0 to TTMSFNCUtils.GetJSONArraySize(ja as TJSONArray) - 1 do
              begin
                ja2 := TTMSFNCUtils.GetJSONArrayItem(ja as TJSONArray, I);
                if Assigned(ja2) and (ja2 is TJSONArray) then
                begin
                  for I2 := 0 to TTMSFNCUtils.GetJSONArraySize(ja2 as TJSONArray) - 1 do
                  begin
                    jo2 := TTMSFNCUtils.GetJSONArrayItem(ja2 as TJSONArray, I2);
                    if Assigned(jo2) then
                    begin
                      dt := FDetections.Add;
                      dt.FromJSON(jo2);
                      dt.FSourceText := tp[I];
                    end;
                    Break;
                  end;
                end;
              end;
            end;
          end;
        finally
          j.Free;
        end;
      end;
      DoDetectLanguage(FDetections, ARequestResult);
    finally
      tp.Free;
    end;
  end;
end;

procedure TTMSFNCCustomCloudGoogleTranslate.DoRequestGetSupportedLanguages(const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  j, ja, jo, jo2: TJSONValue;
  I: Integer;
  s1, s2: string;
begin
  if ARequestResult.ResultString <> '' then
  begin
    j := TTMSFNCUtils.ParseJSON(ARequestResult.ResultString);
    if Assigned(j) then
    try
      jo := TTMSFNCUtils.GetJSONValue(j, 'data');
      if Assigned(jo) then
      begin
        ja := TTMSFNCUtils.GetJSONValue(jo, 'languages');
        if Assigned(ja) and(ja is TJSONArray) then
        begin
          FSupportedLanguages.Clear;
          for I := 0 to TTMSFNCUtils.GetJSONArraySize(ja as TJSONArray) - 1 do
          begin
            jo2 := TTMSFNCUtils.GetJSONArrayItem((ja as TJSONArray), I);
            if Assigned(jo2) then
            begin
              s1 := TTMSFNCUTils.GetJSONProp(jo2, 'language');
              s2 := TTMSFNCUTils.GetJSONProp(jo2, 'name');
              if s2 = '' then
                FSupportedLanguages.Add(s1)
              else
                FSupportedLanguages.Add(s2 + '=' + s1);
            end;
          end;
        end;
      end;
    finally
      j.Free;
    end;
  end;
  DoGetSupportedLanguages(FSupportedLanguages, ARequestResult);
end;

procedure TTMSFNCCustomCloudGoogleTranslate.DoRequestTranslateText(const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  j, jo, ja, jao: TJSONValue;
  I: Integer;
  t: TTMSFNCCloudGoogleTranslateTranslation;
  ts: TStringList;
begin
  ts := TStringList(ARequestResult.DataObject);
  if Assigned(ts) then
  begin
    try
      if ARequestResult.ResultString <> '' then
      begin
        j := TTMSFNCUtils.ParseJSON(ARequestResult.ResultString);
        if Assigned(j) then
        try
          jo := TTMSFNCUtils.GetJSONValue(j, 'data');
          if Assigned(jo) then
          begin
            ja := TTMSFNCUtils.GetJSONValue(jo, 'translations');
            if Assigned(ja) and (ja is TJSONArray) and (TTMSFNCUtils.GetJSONArraySize(ja as TJSONArray) = ts.Count) then
            begin
              for I := 0 to TTMSFNCUtils.GetJSONArraySize(ja as TJSONArray) - 1 do
              begin
                jao := TTMSFNCUtils.GetJSONArrayItem(ja as TJSONArray, I);
                if Assigned(jao) then
                begin
                  t := FTranslations.Add;
                  t.FromJSON(jao);
                  t.SourceText := ts[I];
                end;
              end;
            end;
          end;
        finally
          j.Free;
        end;
      end;
      DoTranslateText(FTranslations, ARequestResult);
    finally
      ts.free
    end;
  end;
end;

function TTMSFNCCustomCloudGoogleTranslate.GetVersion: string;
begin
  Result := GetVersionNumber(MAJ_VER, MIN_VER, REL_VER, BLD_VER);
end;

procedure TTMSFNCCustomCloudGoogleTranslate.GetSupportedLanguages(const ALanguage: string = 'en');
var
  Model: string;
begin
  if FTranslateModel = tmNMT then
    Model := 'nmt'
  else
    Model := 'base';

  Request.Clear;
  Request.Host := Service.BaseURL;
  Request.Path := '/language/translate/v2/languages';
  Request.Name := 'REQUEST LANGUAGE LIST';
  Request.Query := 'key=' + Authentication.Key + '&model=' + Model;
  if ALanguage <> '' then
    Request.Query := Request.Query + '&target=' + ALanguage;
  Request.Method := rmGET;
  ExecuteRequest({$IFDEF LCLWEBLIB}@{$ENDIF}DoRequestGetSupportedLanguages);
end;

procedure TTMSFNCCustomCloudGoogleTranslate.TranslateText(const AText, ATarget: string);
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    sl.Add(AText);
    TranslateText(sl, ATarget);
  finally
    sl.Free;
  end;
end;

procedure TTMSFNCCustomCloudGoogleTranslate.TranslateText(const AText: TStringList; const ATarget: string);
var
  s: string;
  I: Integer;
  html: boolean;
  ts: TStringList;
begin
  FTranslations.Clear;

  if ATarget = '' then
    Exit;

  if AText.Count <= 0 then
    Exit;

  html := False;
  for I := 0 to AText.Count - 1 do
  begin
    if TTMSFNCUtils.IsHTML(Atext[I]) then
      html := True;
    Break;
  end;

  s := '{' + #13#10;
  s := s + '  "q": [' +  #13#10;

  for I := 0 to AText.Count - 1 do
    s := s + '    "' + AText[I] + '",' + #13#10;

  s := s + '  ],' + #13#10;
  s := s + '  "target":"' + ATarget + '",' + #13#10;

  if FTranslateModel = tmNMT then
    s := s + '  "model": "nmt",' + #13#10
  else
    s := s + '  "model": "base",' + #13#10;

  if html then
    s := s + '  "format": "html"' + #13#10
  else
    s := s + '  "format": "text"' + #13#10;

  s := s + '}';

  Request.Clear;
  Request.Host := Service.BaseURL;
  Request.Path := '/language/translate/v2';
  Request.Name := 'TRANSLATE TEXT';
  Request.Method := rmPOST;
  Request.Query := '&key=' + Authentication.Key;
  Request.PostData := s;

  ts := TStringList.Create;
  ts.Assign(AText);

  Request.DataObject := ts;
  ExecuteRequest({$IFDEF LCLWEBLIB}@{$ENDIF}DoRequestTranslateText);
end;

procedure TTMSFNCCloudGoogleTranslate.RegisterRuntimeClasses;
begin
  inherited;
  RegisterClass(TTMSFNCCloudGoogleTranslate);
end;

{ TTMSFNCCloudGoogleTranslateTranslation }

procedure TTMSFNCCloudGoogleTranslateTranslation.Assign(Source: TPersistent);
begin
  if (Source is TTMSFNCCloudGoogleTranslateTranslation) then
  begin
    FSourceLanguage := (Source as TTMSFNCCloudGoogleTranslateTranslation).FSourceLanguage;
    FTranslatedText := (Source as TTMSFNCCloudGoogleTranslateTranslation).FTranslatedText;
    FModel := (Source as TTMSFNCCloudGoogleTranslateTranslation).FModel;
    FSourceText := (Source as TTMSFNCCloudGoogleTranslateTranslation).FSourceText
  end
  else
    inherited;
end;

constructor TTMSFNCCloudGoogleTranslateTranslation.Create(ACollection: TCollection);
begin
  inherited;
  FSourceLanguage := '';
  FTranslatedText := '';
  FModel := '';
  FSourceText := '';
end;

procedure TTMSFNCCloudGoogleTranslateTranslation.FromJSON(jo: TJSONValue);
begin
  FSourceLanguage := TTMSFNCUtils.GetJSONProp(jo, 'detectedSourceLanguage');
  FTranslatedText := TTMSFNCUtils.GetJSONProp(jo, 'translatedText');
  FModel := TTMSFNCUtils.GetJSONProp(jo, 'model');
end;

{ TTMSFNCCloudGoogleTranslateTranslations }

function TTMSFNCCloudGoogleTranslateTranslations.Add: TTMSFNCCloudGoogleTranslateTranslation;
begin
   Result := TTMSFNCCloudGoogleTranslateTranslation(inherited Add);
end;

constructor TTMSFNCCloudGoogleTranslateTranslations.Create(AOwner: TTMSFNCCustomCloudGoogleTranslate);
begin
  inherited Create(AOwner, TTMSFNCCloudGoogleTranslateTranslation);
  FOwner := AOwner;
end;

function TTMSFNCCloudGoogleTranslateTranslations.GetItems(Index: Integer): TTMSFNCCloudGoogleTranslateTranslation;
begin
  Result := TTMSFNCCloudGoogleTranslateTranslation(inherited Items[Index]);
end;

function TTMSFNCCloudGoogleTranslateTranslations.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TTMSFNCCloudGoogleTranslateTranslations.Insert(Index: Integer): TTMSFNCCloudGoogleTranslateTranslation;
begin
  Result := TTMSFNCCloudGoogleTranslateTranslation(inherited Insert(Index));
end;

procedure TTMSFNCCloudGoogleTranslateTranslations.SetItems(Index: Integer; const Value: TTMSFNCCloudGoogleTranslateTranslation);
begin
  inherited Items[Index] := Value;
end;

procedure TTMSFNCCloudGoogleTranslateTranslations.Update(Item: TCollectionItem);
begin
  inherited;
end;

{ TTMSFNCCloudGoogleTranslateDetections }

function TTMSFNCCloudGoogleTranslateDetections.Add: TTMSFNCCloudGoogleTranslateDetection;
begin
  Result := TTMSFNCCloudGoogleTranslateDetection(inherited Add);
end;

constructor TTMSFNCCloudGoogleTranslateDetections.Create(AOwner: TTMSFNCCustomCloudGoogleTranslate);
begin
  inherited Create(AOwner, TTMSFNCCloudGoogleTranslateDetection);
  FOwner := AOwner;
end;

function TTMSFNCCloudGoogleTranslateDetections.GetItems(Index: Integer): TTMSFNCCloudGoogleTranslateDetection;
begin
  Result := TTMSFNCCloudGoogleTranslateDetection(inherited Items[Index]);
end;

function TTMSFNCCloudGoogleTranslateDetections.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TTMSFNCCloudGoogleTranslateDetections.Insert(Index: Integer): TTMSFNCCloudGoogleTranslateDetection;
begin
  Result := TTMSFNCCloudGoogleTranslateDetection(inherited Insert(Index));
end;

procedure TTMSFNCCloudGoogleTranslateDetections.SetItems(Index: Integer; const Value: TTMSFNCCloudGoogleTranslateDetection);
begin
  inherited Items[Index] := Value;
end;

procedure TTMSFNCCloudGoogleTranslateDetections.Update(Item: TCollectionItem);
begin
  inherited;
end;

{ TTMSFNCCloudGoogleTranslateDetection }

procedure TTMSFNCCloudGoogleTranslateDetection.Assign(Source: TPersistent);
begin
  if (Source is TTMSFNCCloudGoogleTranslateTranslation) then
  begin
    FSourceText := (Source as TTMSFNCCloudGoogleTranslateDetection).FSourceText;
    FSourceLang := (Source as TTMSFNCCloudGoogleTranslateDetection).FSourceLang;
  end
  else
    inherited;
end;

constructor TTMSFNCCloudGoogleTranslateDetection.Create(ACollection: TCollection);
begin
  inherited;
  FSourceText := '';
  FSourceLang := '';
end;

procedure TTMSFNCCloudGoogleTranslateDetection.FromJSON(jo: TJSONValue);
begin
  FSourceLang := TTMSFNCUtils.GetJSONProp(jo, 'language');
end;

end.
