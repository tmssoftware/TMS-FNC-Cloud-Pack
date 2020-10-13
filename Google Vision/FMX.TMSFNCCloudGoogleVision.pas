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

unit FMX.TMSFNCCloudGoogleVision;

{$I FMX.TMSFNCDefines.inc}

{$IFDEF WEBLIB}
{$DEFINE LCLWEBLIB}
{$ENDIF}

{$IFDEF LCLLIB}
{$DEFINE LCLWEBLIB}
{$ENDIF}

interface

uses
  Classes, SysUtils, Types, FMX.TMSFNCCloudOAuth, FMX.TMSFNCCloudBase, FMX.TMSFNCTypes, FMX.TMSFNCUtils
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
  TTMSFNCCustomCloudGoogleVision = class;
  TTMSFNCCloudGoogleVisionResponse = class;
  TTMSFNCCloudGoogleVisionResponses = class;
  TTMSFNCCloudGoogleVisionDetectedObject = class;
  TTMSFNCCloudGoogleVisionDetectedObjects = class;
  TTMSFNCCloudGoogleVisionLabels = class;
  TTMSFNCCloudGoogleVisionLabel = class;
  TTMSFNCCloudGoogleVisionLogos = class;
  TTMSFNCCloudGoogleVisionLogo = class;
  TTMSFNCCloudGoogleVisionLandmarks = class;
  TTMSFNCCloudGoogleVisionLandmark = class;
  TTMSFNCCloudGoogleVisionSafeSearch = class;
  TTMSFNCCloudGoogleVisionWebDetection = class;
  TTMSFNCCloudGoogleVisionWebEntity = class;
  TTMSFNCCloudGoogleVisionWebEntities = class;
  TTMSFNCCloudGoogleVisionWebImagePageMatches = class;
  TTMSFNCCloudGoogleVisionWebImagePageMatch = class;
  TTMSFNCCloudGoogleVisionDetectedTexts = class;
  TTMSFNCCloudGoogleVisionDetectedFaces = class;
  TTMSFNCCloudGoogleVisionDetectedFace = class;
  TTMSFNCCloudGoogleVisionFaceLandmark = class;
  TTMSFNCCloudGoogleVisionFaceLandmarks = class;

  TTMSFNCCloudGoogleVisionPointArray = array of TPointF;

  TTMSFNCCloudGoogleVisionResponseEvent = procedure(Sender: TObject; const AResponse: TTMSFNCCloudGoogleVisionResponse; const ARequestResult: TTMSFNCCloudBaseRequestResult) of object;

  TTMSFNCCloudGoogleVisionResponsesCompleteEvent = procedure(Sender: TObject; const AResponses: TTMSFNCCloudGoogleVisionResponses; const ARequestResult: TTMSFNCCloudBaseRequestResult) of object;

  TTMSFNCCloudGoogleVisionDetectType = (dtObjects, dtText, dtDocumentText, dtImageLabels, dtLandMarks, dtLogos, dtSafeSearch, dtWeb, dtFaces);
  TTMSFNCCloudGoogleVisionDetectTypes = set of TTMSFNCCloudGoogleVisionDetectType;

  TTMSFNCCloudGoogleVisionFaceLandmark = class (TCollectionItem)
  private
    FName: string;
    FPoint: TPointF;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure FromJSON(jo: TJSONValue);
  published
    property Point: TPointF read FPoint write FPoint;
    property Name: string read FName write FName;
  end;

  TTMSFNCCloudGoogleVisionFaceLandmarks = class(TOwnedCollection)
  private
    FOwner: TTMSFNCCloudGoogleVisionDetectedFace;
    function GetItems(Index: Integer): TTMSFNCCloudGoogleVisionFaceLandmark;
    procedure SetItems(Index: Integer; const Value: TTMSFNCCloudGoogleVisionFaceLandmark);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TTMSFNCCloudGoogleVisionDetectedFace);
    function Add: TTMSFNCCloudGoogleVisionFaceLandmark;
    function Insert(Index: Integer):TTMSFNCCloudGoogleVisionFaceLandmark;
    function GetOwner: TPersistent; override;
    property Items[Index: Integer]: TTMSFNCCloudGoogleVisionFaceLandmark read GetItems write SetItems; default;
  end;

  TTMSFNCCloudGoogleVisionDetectedText = class(TCollectionItem)
  private
    FDescription: string;
    FLanguage: string;
    FPoints: TTMSFNCCloudGoogleVisionPointArray;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
    procedure FromJSON(jo: TJSONValue);
  published
    property Points: TTMSFNCCloudGoogleVisionPointArray read FPoints write FPoints;
    property language: string read FLanguage write FLanguage;
    property Description: string read FDescription write FDescription;
  end;

  TTMSFNCCLoudGoogleVisionDetectedTexts = class(TOwnedCollection)
  private
    FOwner: TPersistent;
    function GetItems(Index: Integer): TTMSFNCCLoudGoogleVisionDetectedText;
    procedure SetItems(Index: Integer; const Value: TTMSFNCCLoudGoogleVisionDetectedText);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TTMSFNCCloudGoogleVisionResponse);
    function GetOwner: TPersistent; override;
    function Add: TTMSFNCCLoudGoogleVisionDetectedText;
    function Insert(Index: Integer): TTMSFNCCLoudGoogleVisionDetectedText;
    property Items[Index: Integer]: TTMSFNCCLoudGoogleVisionDetectedText read GetItems write SetItems; default;
  end;

  TTMSFNCCloudGoogleVisionWebImagePageMatch = class(TCollectionItem)
  private
    FPageURL: string;
    FImageURL: TStringList;
    FPageTitle: String;
  public
    constructor Create(Collection: TCollection);  override;
    procedure Assign(Source: TPersistent); override;
    procedure FromJSON(jo: TJSONValue);
  published
    property PageURL: string read FPageURL write FPageURL;
    property ImageURL: TStringList read FImageURL write FImageURL;
    property PageTitle: string read FPageTitle write FPageTitle;
  end;

  TTMSFNCCloudGoogleVisionWebImagePageMatches = class(TOwnedCollection)
  private
    FOwner: TPersistent;
    function GetItems(Index: Integer): TTMSFNCCloudGoogleVisionWebImagePageMatch;
    procedure SetItems(Index: Integer; const Value: TTMSFNCCloudGoogleVisionWebImagePageMatch);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TTMSFNCCloudGoogleVisionWebDetection);
    function GetOwner: TPersistent; override;
    function Add: TTMSFNCCloudGoogleVisionWebImagePageMatch;
    function Insert(Index: Integer): TTMSFNCCloudGoogleVisionWebImagePageMatch;
    property Items[Index: Integer]: TTMSFNCCloudGoogleVisionWebImagePageMatch read GetItems write SetItems; default;
  end;

  TTMSFNCCloudGoogleVisionWebEntity = class(TCollectionItem)
  private
    FDescription: string;
    FScore: Double;
  public
    constructor Create(Collection: TCollection);  override;
    procedure Assign(Source: TPersistent); override;
    procedure FromJSON(jo: TJSONValue);
  published
    property Score: Double read FScore write FScore;
    property Description: string read FDescription write FDescription;
  end;

  TTMSFNCCloudGoogleVisionWebEntities = class(TOwnedCollection)
  private
    FOwner: TPersistent;
    function GetItems(Index: Integer): TTMSFNCCloudGoogleVisionWebEntity;
    procedure SetItems(Index: Integer; const Value: TTMSFNCCloudGoogleVisionWebEntity);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TTMSFNCCloudGoogleVisionWebDetection);
    function GetOwner: TPersistent; override;
    function Add: TTMSFNCCloudGoogleVisionWebEntity;
    function Insert(Index: Integer): TTMSFNCCloudGoogleVisionWebEntity;
    property Items[Index: Integer]: TTMSFNCCloudGoogleVisionWebEntity read GetItems write SetItems; default;
  end;

  TTMSFNCCloudGoogleVisionDetectedFace = class(TCollectionItem)
  private
    FLandmarks: TTMSFNCCloudGoogleVisionFaceLandmarks;
    FFacePoints: TTMSFNCCloudGoogleVisionPointArray;
    FPoints: TTMSFNCCloudGoogleVisionPointArray;
  public
    constructor Create(Collection: TCollection);  override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure FromJSON(jo: TJSONValue);
  published
    property FacePoints: TTMSFNCCloudGoogleVisionPointArray read FFacePoints write FFacePoints;
    property Points: TTMSFNCCloudGoogleVisionPointArray read FPoints write FPoints;
    property LandMarks: TTMSFNCCloudGoogleVisionFaceLandmarks read FLandmarks write FLandmarks;
  end;

  TTMSFNCCloudGoogleVisionDetectedFaces = class(TOwnedCollection)
  private
    FOwner: TPersistent;
    function GetItems(Index: Integer): TTMSFNCCloudGoogleVisionDetectedFace;
    procedure SetItems(Index: Integer; const Value: TTMSFNCCloudGoogleVisionDetectedFace);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TTMSFNCCloudGoogleVisionResponse);
    function GetOwner: TPersistent; override;
    function Add: TTMSFNCCloudGoogleVisionDetectedFace;
    function Insert(Index: Integer): TTMSFNCCloudGoogleVisionDetectedFace;
    property Items[Index: Integer]: TTMSFNCCloudGoogleVisionDetectedFace read GetItems write SetItems; default;
  end;

  TTMSFNCCloudGoogleVisionLandmark = class(TCollectionItem)
  private
    FDescription: string;
    FScore: Double;
    FPoints: TTMSFNCCloudGoogleVisionPointArray;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
    procedure FromJSON(jo: TJSONValue);
  published
    property Points: TTMSFNCCloudGoogleVisionPointArray read FPoints write FPoints;
    property Score: Double read FScore write FScore;
    property Description: string read FDescription write FDescription;
  end;

  TTMSFNCCloudGoogleVisionLandmarks = class(TOwnedCollection)
  private
    FOwner: TPersistent;
    function GetItems(Index: Integer): TTMSFNCCloudGoogleVisionLandmark;
    procedure SetItems(Index: Integer; const Value: TTMSFNCCloudGoogleVisionLandmark);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TTMSFNCCloudGoogleVisionResponse);
    function GetOwner: TPersistent; override;
    function Add: TTMSFNCCloudGoogleVisionLandmark;
    function Insert(Index: Integer): TTMSFNCCloudGoogleVisionLandmark;
    property Items[Index: Integer]: TTMSFNCCloudGoogleVisionLandmark read GetItems write SetItems; default;
  end;

  TTMSFNCCloudGoogleVisionLogo = class(TCollectionItem)
  private
    FDescription: string;
    FScore: Double;
    FPoints: TTMSFNCCloudGoogleVisionPointArray;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
    procedure FromJSON(jo: TJSONValue);
  published
    property Points: TTMSFNCCloudGoogleVisionPointArray read FPoints write FPoints;
    property Score: Double read FScore write FScore;
    property Description: string read FDescription write FDescription;
  end;

  TTMSFNCCloudGoogleVisionLogos = class(TOwnedCollection)
  private
    FOwner: TPersistent;
    function GetItems(Index: Integer): TTMSFNCCloudGoogleVisionLogo;
    procedure SetItems(Index: Integer; const Value: TTMSFNCCloudGoogleVisionLogo);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TTMSFNCCloudGoogleVisionResponse);
    function GetOwner: TPersistent; override;
    function Add: TTMSFNCCloudGoogleVisionLogo;
    function Insert(Index: Integer): TTMSFNCCloudGoogleVisionLogo;
    property Items[Index: Integer]: TTMSFNCCloudGoogleVisionLogo read GetItems write SetItems; default;
  end;

  TTMSFNCCloudGoogleVisionLabel = class(TCollectionItem)
  private
    FDescription: string;
    FScore: Double;
    FTopicality: Double;
  public
    constructor Create(Collection: TCollection);  override;
    procedure Assign(Source: TPersistent); override;
    procedure FromJSON(jo: TJSONValue);
  published
    property Topicality: Double read FTopicality write FTopicality;
    property Score: Double read FScore write FScore;
    property Description: string read FDescription write FDescription;
  end;

  TTMSFNCCloudGoogleVisionLabels = class(TOwnedCollection)
  private
    FOwner: TPersistent;
    function GetItems(Index: Integer): TTMSFNCCloudGoogleVisionLabel;
    procedure SetItems(Index: Integer; const Value: TTMSFNCCloudGoogleVisionLabel);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TTMSFNCCloudGoogleVisionResponse);
    function GetOwner: TPersistent; override;
    function Add: TTMSFNCCloudGoogleVisionLabel;
    function Insert(Index: Integer): TTMSFNCCloudGoogleVisionLabel;
    property Items[Index: Integer]: TTMSFNCCloudGoogleVisionLabel read GetItems write SetItems; default;
  end;

  TTMSFNCCloudGoogleVisionDetectedObject = class(TCollectionItem)
  private
    FName: string;
    FConfidence: Double;
    FPoints: TTMSFNCCloudGoogleVisionPointArray;
  public
    constructor Create(Collection: TCollection);  override;
    procedure Assign(Source: TPersistent); override;
    procedure FromJSON(jo: TJSONValue);
    procedure CalculateRectF(AFile: TTMSFNCUtilsFile; ABase64: string);
    property Confidence: double read FConfidence write FConfidence;
    property Name: string read Fname write Fname;
    property Points: TTMSFNCCloudGoogleVisionPointArray read FPoints write FPoints;
  end;

  TTMSFNCCloudGoogleVisionDetectedObjects = class(TOwnedCollection)
  private
    FOwner: TPersistent;
    function GetItems(Index: Integer): TTMSFNCCloudGoogleVisionDetectedObject;
    procedure SetItems(Index: Integer; const Value: TTMSFNCCloudGoogleVisionDetectedObject);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TTMSFNCCloudGoogleVisionResponse);
    function GetOwner: TPersistent; override;
    function Add: TTMSFNCCloudGoogleVisionDetectedObject;
    function Insert(Index: Integer): TTMSFNCCloudGoogleVisionDetectedObject;
    property Items[Index: Integer]: TTMSFNCCloudGoogleVisionDetectedObject read GetItems write SetItems; default;
  end;

  TTMSFNCCloudGoogleVisionWebDetection = class(TPersistent)
  private
    FWebEntities: TTMSFNCCloudGoogleVisionWebEntities;
    FMatchingWebPageImages: TTMSFNCCloudGoogleVisionWebImagePageMatches;
    FBestGuessLabels: TStringList;
    FVisualSimiliarImages: TStringlist;
  public
    constructor Create(AOwner: TTMSFNCCloudGoogleVisionResponse);
    destructor Destroy; override;
    property WebEntities: TTMSFNCCloudGoogleVisionWebEntities read FWebEntities write FWebEntities;
    property BestGuessLabels: TStringList read FBestGuessLabels write FBestGuessLabels;
    property SimiliarImages: TStringList read FVisualSimiliarImages write FVisualSimiliarImages;
    property MatchingWebPageImages: TTMSFNCCloudGoogleVisionWebImagePageMatches read FMatchingWebPageImages write FMatchingWebPageImages;
  end;

  TTMSFNCCloudGoogleVisionSafeSearch = class (TPersistent)
  private
    FMedical: string;
    FAdult: string;
    FSpoof: string;
    FViolence: string;
    FRacy: string;
  public
    constructor Create(AOwner: TTMSFNCCloudGoogleVisionResponse);
    destructor Destroy; override;
    procedure FromJSON(jo:TJSONValue);
    property Medical: string read FMedical write FMedical;
    property Adult: string read FAdult write FAdult;
    property Spoof: string read FSpoof write FSpoof;
    property Violence: string read FViolence write FViolence;
    property Racy: string read FRacy write FRacy;
  end;

  TTMSFNCCloudGoogleVisionResponse = class(TCollectionItem)
  private
    FOwner: TTMSFNCCloudGoogleVisionResponses;
    FDetectedObjects: TTMSFNCCloudGoogleVisionDetectedObjects;
    FDetectedFaces: TTMSFNCCloudGoogleVisionDetectedFaces;
    FImageLabels: TTMSFNCCloudGoogleVisionLabels;
    FDetectedLogos: TTMSFNCCloudGoogleVisionLogos;
    FDetectedLandmarks: TTMSFNCCloudGoogleVisionLandmarks;
    FSafeSearch: TTMSFNCCloudGoogleVisionSafeSearch;
    FWebDetection: TTMSFNCCloudGoogleVisionWebDetection;
    FDetectedText: TTMSFNCCloudGoogleVisionDetectedTexts;
    FBitmapFile: TTMSFNCUtilsFile;
    FBitmapBase64: string;
  public
    constructor Create(Collection: TCollection); Override;
    destructor Destroy; override;
    property DetectedObjects: TTMSFNCCloudGoogleVisionDetectedObjects read FDetectedObjects write FDetectedObjects;
    property ImageLabels: TTMSFNCCloudGoogleVisionLabels read FImageLabels write FImageLabels;
    property DetectedLogos: TTMSFNCCloudGoogleVisionLogos read FDetectedLogos write FDetectedLogos;
    property DetectedLandmarks: TTMSFNCCloudGoogleVisionLandmarks read FDetectedLandmarks write FDetectedLandmarks;
    property DetectedTexts: TTMSFNCCloudGoogleVisionDetectedTexts read FDetectedText write FDetectedText;
    property DetectedFaces: TTMSFNCCloudGoogleVisionDetectedFaces read FDetectedFaces write FDetectedFaces;
    property WebDetection: TTMSFNCCloudGoogleVisionWebDetection read FWebDetection write FWebDetection;
    property SafeSearch: TTMSFNCCloudGoogleVisionSafeSearch read FSafeSearch write FSafeSearch;
    property BitmapFile: TTMSFNCUtilsFile read FBitmapFile write FBitmapFile;
    property BitmapBase64: string read FBitmapBase64 write FBitmapBase64;
  end;

  TTMSFNCCloudGoogleVisionResponses = class (TOwnedCollection)
  private
    FOwner: TTMSFNCCustomCloudGoogleVision;
    function GetItems(Index: Integer): TTMSFNCCloudGoogleVisionResponse;
    procedure SetItems(Index: Integer; const Value: TTMSFNCCloudGoogleVisionResponse);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TTMSFNCCustomCloudGoogleVision);
    function GetOwner: TPersistent; override;
    function Add: TTMSFNCCloudGoogleVisionResponse;
    function Insert(Index: Integer): TTMSFNCCloudGoogleVisionResponse;
    property Items[Index: Integer]: TTMSFNCCloudGoogleVisionResponse read GetItems write SetItems; default;
  end;

  TTMSFNCCustomCloudGoogleVision = class(TTMSFNCSimpleCloudOAuth)
  private
    FResponses: TTMSFNCCloudGoogleVisionResponses;
    FDetectTypes: TTMSFNCCloudGoogleVisionDetectTypes;
    FResponseEvent: TTMSFNCCloudGoogleVisionResponseEvent;
    FResponsesCompleteEvent: TTMSFNCCloudGoogleVisionResponsesCompleteEvent;
    function AddFeatures(const AType: string; const AMax: Integer): string;
    procedure InternalScanImageBase64(const AFile: TTMSFNCUtilsFile;
      const ABase64: string; const AMaxResults: Integer);
  protected
    procedure DoRequestScanPicture(const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure DoScanImage(const AResponse: TTMSFNCCloudGoogleVisionResponse; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure DoScanImagesComplete(const AResponses: TTMSFNCCloudGoogleVisionResponses; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    property OnScanImagesComplete: TTMSFNCCloudGoogleVisionResponsesCompleteEvent read FResponsesCompleteEvent write FResponsesCompleteEvent;
    property OnScanImage: TTMSFNCCloudGoogleVisionResponseEvent read FresponseEvent write FResponseEvent;
    function GetVersion: string; override;
    property DetectTypes: TTMSFNCCloudGoogleVisionDetectTypes read FDetectTypes write FDetectTypes default [dtFaces];
    property Responses: TTMSFNCCloudGoogleVisionResponses read FResponses write FResponses;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ScanImage(const AFile: TTMSFNCUtilsFile; const AMaxResults: Integer = 0);
    procedure ScanImageBase64(const ABase64: string; const AMaxResults: Integer = 0);
  end;

  {$IFNDEF LCLLIB}
  [ComponentPlatformsAttribute(TMSPlatformsWeb)]
  {$ENDIF}
  TTMSFNCCloudGoogleVision = class(TTMSFNCCustomCloudGoogleVision)
  protected
    procedure RegisterRuntimeClasses; override;
  public
    property DetectTypes;
    property Responses;
  published
    property OnScanImage;
    property OnScanImagesComplete;
  end;

function GetJSONPoint(const jo: TJSONValue; const I: Integer): TPointF;
procedure Register;

implementation

{$IFDEF WEBLIB}
uses
  WEBLib.DesignIntf;
{$ENDIF}

procedure Register;
begin
  RegisterComponents('TMS FNC Cloud', [TTMSFNCCloudGoogleVision]);
end;

function TTMSFNCCustomCloudGoogleVision.AddFeatures(const AType: string; const AMax: Integer): string;
var
  sp, et: string;
begin
  sp := '    ';
  et := #13#10;
  Result := sp + sp + sp + '{' + et;
  Result := result + sp + sp + sp + sp + '"type": "' + AType + '",' + et;
  if (AMax <> 0) or not (AMax <= 0) then
    Result := result + sp + sp + sp + sp + '"maxResults": '+ inttostr(AMax) + et;
  Result := result + sp + sp + sp + '},' + et;
end;

constructor TTMSFNCCustomCloudGoogleVision.Create(AOwner: TComponent);
begin
  inherited;
  Service.DeveloperURL := 'https://console.cloud.google.com';
  Service.BaseURL := 'https://vision.googleapis.com';
  Service.Name := 'Google Vision';
  FResponses := TTMSFNCCloudGoogleVisionResponses.Create(Self);
  FDetectTypes := [dtFaces];
end;

destructor TTMSFNCCustomCloudGoogleVision.Destroy;
begin
  FResponses.Free;
  inherited;
end;

procedure TTMSFNCCustomCloudGoogleVision.DoRequestScanPicture(const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  j, ja, ja2, jo,  jo2, jo3: TJSONValue;
  I, I2: Integer;
  rs: TTMSFNCCloudGoogleVisionResponse;
  Obj: TTMSFNCCloudGoogleVisionDetectedObject;
  lbl: TTMSFNCCloudGoogleVisionLabel;
  lo: TTMSFNCCloudGoogleVisionLogo;
  la: TTMSFNCCloudGoogleVisionLandmark;
  ss: TTMSFNCCloudGoogleVisionSafeSearch;
  wl: TTMSFNCCloudGoogleVisionWebEntity;
  wmi: TTMSFNCCloudGoogleVisionWebImagePageMatch;
  dt: TTMSFNCCloudGoogleVisionDetectedText;
  ff: TTMSFNCCloudGoogleVisionDetectedFace;
begin
  rs := nil;
  if ARequestResult.ResultString <> '' then
  begin
    j := TTMSFNCUtils.ParseJSON(ARequestResult.ResultString);
    if Assigned(j) then
    begin
      try
        ja := TTMSFNCUtils.GetJSONValue(j, 'responses');
        if Assigned(ja) and (ja is TJSONArray) then
        begin
          for I := 0 to TTMSFNCUtils.GetJSONArraySize(ja as TJSONArray) - 1 do
          begin
            rs := FResponses.add;
            rs.FBitmapFile := ARequestResult.DataUpload;
            rs.FBitmapBase64 := ARequestResult.DataString;
            jo := TTMSFNCUtils.GetJSONArrayItem(ja as TJSONArray, I);
            if Assigned(jo) then
            begin
              ja2 := TTMSFNCUtils.GetJSONValue(jo, 'localizedObjectAnnotations');
              if Assigned(ja2) and (ja2 is TJSONArray) then
              begin
                for I2 := 0 to TTMSFNCUtils.GetJSONArraySize(ja2 as TJSONArray) - 1 do
                begin
                  jo2 := TTMSFNCUtils.GetJSONArrayItem(ja2 as TJSONArray, I2);
                  if Assigned(jo2) then
                  begin
                    obj := rs.FDetectedObjects.Add;
                    obj.FromJSON(jo2);
                    obj.CalculateRectF(ARequestResult.DataUpload, ARequestResult.DataString);
                  end;
                end;
              end;
              ja2 := TTMSFNCUtils.GetJSONValue(jo, 'textAnnotations');
              if Assigned(ja2) and (ja2 is TJSONArray) then
              begin
                for I2 := 0 to TTMSFNCUtils.GetJSONArraySize(ja2 as TJSONArray) - 1 do
                begin
                  jo2 := TTMSFNCUtils.GetJSONArrayItem(ja2 as TJSONArray, I2);
                   if Assigned(jo2) then
                   begin
                     dt := rs.FDetectedText.Add;
                     dt.FromJSON(jo2);
                   end;
                end;
              end;
              ja2 := TTMSFNCUtils.GetJSONValue(jo,'labelAnnotations');
              if Assigned(ja2) and (ja2 is TJSONArray) then
              begin
                for I2 := 0 to TTMSFNCUtils.GetJSONArraySize(ja2 as TJSONArray) - 1 do
                begin
                  jo2 := TTMSFNCUtils.GetJSONArrayItem(ja2 as TJSONArray, I2);
                  if Assigned(jo2) then
                  begin
                    lbl := rs.ImageLabels.Add;
                    lbl.FromJSON(jo2);
                  end;
                end;
              end;
              ja2 := TTMSFNCUtils.GetJSONValue(jo,'faceAnnotations');
              if Assigned(ja2) and (ja2 is TJSONArray) then
              begin
                for I2 := 0 to TTMSFNCUtils.GetJSONArraySize(ja2 as TJSONArray) - 1 do
                begin
                  jo2 := TTMSFNCUtils.GetJSONArrayItem(ja2 as TJSONArray, I2);
                  if Assigned(jo2) then
                  begin
                    ff := rs.FDetectedFaces.Add;
                    ff.FromJSON(jo2);
                  end;
                end;
              end;
              ja2 := TTMSFNCUtils.GetJSONValue(jo, 'logoAnnotations');
              if Assigned(ja2) and (ja2 is TJSONArray) then
              begin
                for I2 := 0 to TTMSFNCUtils.GetJSONArraySize(ja2 as TJSONArray) - 1 do
                begin
                  jo2 := TTMSFNCUtils.GetJSONArrayItem(ja2 as TJSONArray, I2);
                  if Assigned(jo2) then
                  begin
                    lo := rs.DetectedLogos.Add;
                    lo.FromJSON(jo2);
                  end;
                end;
              end;
              ja2 := TTMSFNCUtils.GetJSONValue(jo, 'landmarkAnnotations');
              if Assigned(ja2) and (ja2 is TJSONArray) then
              begin
                for I2 := 0 to TTMSFNCUtils.GetJSONArraySize(ja2 as TJSONArray) - 1 do
                begin
                  jo2 := TTMSFNCUtils.GetJSONArrayItem(ja2 as TJSONArray, I2);
                  if Assigned(jo2) then
                  begin
                    la := rs.FDetectedLandmarks.Add;
                    la.FromJSON(jo2);
                  end;
                end;
              end;
              jo2 := TTMSFNCUtils.GetJSONValue(jo, 'safeSearchAnnotation');
              if Assigned(jo2) then
              begin
                ss := rs.SafeSearch;
                ss.FromJSON(jo2);
              end;
              jo2 := TTMSFNCUtils.GetJSONValue(jo, 'webDetection');
              if Assigned(jo2) then
              begin
                ja2 := TTMSFNCUtils.GetJSONValue(jo2, 'webEntities');
                if Assigned(ja2) and (ja2 is TJSONArray) then
                begin
                  for I2 := 0 to TTMSFNCUtils.GetJSONArraySize(ja2 as TJSONArray) - 1 do
                  begin
                    jo3 := TTMSFNCUtils.GetJSONArrayItem(ja2 as TJSONArray, I2);
                    if Assigned(jo3) then
                    begin
                      wl := rs.FWebDetection.WebEntities.Add;
                      wl.FromJSON(jo3);
                    end;
                  end;
                end;
                ja2 := TTMSFNCUtils.GetJSONValue(jo2, 'visuallySimilarImages');
                if Assigned(ja2) and (ja2 is TJSONArray) then
                begin
                  for I2 := 0 to TTMSFNCUtils.GetJSONArraySize(ja2 as TJSONArray) - 1 do
                  begin
                    jo3 := TTMSFNCUtils.GetJSONArrayItem(ja2 as TJSONArray, I2);
                    if Assigned(jo3) then
                    begin
                      rs.WebDetection.SimiliarImages.Add(TTMSFNCUtils.GetJSONProp(jo3,'url'));
                    end;
                  end;
                end;
                ja2 := TTMSFNCUTils.GetJSONValue(jo2, 'pagesWithMatchingImages');
                if Assigned(ja2) and (ja2 is TJSONArray) then
                begin
                  for I2 := 0 to TTMSFNCUtils.GetJSONArraySize(ja2 as TJSONArray) - 1 do
                  begin
                    jo3 := TTMSFNCUtils.GetJSONArrayItem(ja2 as TJSONArray, I2);
                    if Assigned(jo3) then
                    begin
                      wmi := rs.WebDetection.MatchingWebPageImages.Add;
                      wmi.FromJSON(jo3);
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      finally
        j.Free;
      end;
    end;
  end;

  DoScanImage(rs, ARequestResult);

  if (GetRequestCount(True, 'SCAN IMAGE') = 0) then
    DoScanImagesComplete(FResponses, ARequestResult);
end;

procedure TTMSFNCCustomCloudGoogleVision.DoScanImage(const AResponse: TTMSFNCCloudGoogleVisionResponse; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if Assigned(OnScanImage) then
    OnScanImage(Self, AResponse, ARequestResult);
end;

procedure TTMSFNCCustomCloudGoogleVision.DoScanImagesComplete(const AResponses: TTMSFNCCloudGoogleVisionResponses; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if Assigned(OnScanImagesComplete) then
    OnScanImagesComplete(Self, AResponses, ARequestResult);
end;

function GetJSONPoint(const jo: TJSONValue; const I: Integer):TPointF;
var
  j ,ja ,jao: TJSONValue;
begin
  j := TTMSFNCUtils.GetJSONValue(jo, 'boundingPoly');
  if Assigned(j) then
  begin
    ja := TTMSFNCUtils.GetJSONValue(j, 'vertices');
    if Assigned(ja) and (ja Is TJSONArray) then
    begin
      jao := TTMSFNCUtils.GetJSONArrayItem(ja as TJSONArray, I);
      if Assigned(jao) then
      begin
        Result := PointF(TTMSFNCUtils.GetJSONDoubleValue(jao, 'x'),TTMSFNCUtils.GetJSONDoubleValue(jao, 'y'));
      end;
    end;
  end;
end;

function TTMSFNCCustomCloudGoogleVision.GetVersion: string;
begin
  Result := GetVersionNumber(MAJ_VER, MIN_VER, REL_VER, BLD_VER);
end;

procedure TTMSFNCCustomCloudGoogleVision.ScanImage(const AFile: TTMSFNCUtilsFile; const AMaxResults: Integer);
begin
  InternalScanImageBase64(AFile, TTMSFNCUtils.FileToBase64(AFile), AMaxResults);
end;

procedure TTMSFNCCustomCloudGoogleVision.ScanImageBase64(const ABase64: string;
  const AMaxResults: Integer);
{$IFDEF WEBLIB}
var
  f: TTMSFNCUtilsFile;
{$ENDIF}
begin
  {$IFDEF WEBLIB}
  f.Data := nil;
  f.Name := '';
  InternalScanImageBase64(f, ABase64, AMaxResults);
  {$ELSE}
  InternalScanImageBase64('', ABase64, AMaxResults);
  {$ENDIF}
end;

procedure TTMSFNCCustomCloudGoogleVision.InternalScanImageBase64(const AFile: TTMSFNCUtilsFile; const ABase64: string;
  const AMaxResults: Integer);
var
  s, sp, et: string;
begin
  sp := '    ';
  et := #13#10;

  s := '{' + et;
  s := s + sp + '"requests": [' + et;
  s := s + sp + '{' + et;
  s := s + sp + sp + '"image": {' + et;
  s := s + sp + sp + sp + '"content":"' + ABase64 + '"' + et;
  s := s + sp + sp + '},' + et;
  s := s + sp + sp + '"features": [' + et;
  if dtObjects in FDetectTypes then
    s := s + AddFeatures('OBJECT_LOCALIZATION', 0);
  if dtText in FDetectTypes then
    s := s + AddFeatures('TEXT_DETECTION', 0);
  if dtDocumentText in FDetectTypes then
    s := s + AddFeatures('DOCUMENT_TEXT_DETECTION', 0);
  if dtLandMarks in FDetectTypes then
    s := s + AddFeatures('LANDMARK_DETECTION', 0);
  if dtLogos in FDetectTypes then
    s := s + AddFeatures('LOGO_DETECTION', 0);
  if dtSafeSearch in FDetectTypes then
    s := s + AddFeatures('SAFE_SEARCH_DETECTION', 0);
  if dtWeb in FDetectTypes then
    s := s + AddFeatures('WEB_DETECTION', 0);
  if dtImageLabels in FDetectTypes then
    s := s + AddFeatures('LABEL_DETECTION', 0);
  if dtFaces in FDetectTypes then
    s := s + AddFeatures('FACE_DETECTION', 0);
  s := s + sp + sp + ']' + et;
  s := s + sp + '},' + et;
  s := s + sp + ']' + et;
  s := s + '}';

  if (GetRequestCount(True, 'SCAN IMAGE') = 0) then
    FResponses.Clear;

  Request.Clear;
  Request.Name := 'SCAN IMAGE';
  Request.Host := Service.BaseURL;
  Request.Path := '/v1/images:annotate';
  Request.Query := 'key=' + Authentication.Key;
  Request.Method := rmPOST;
  Request.AddHeader('Content-Type', 'application/json');
  Request.PostData := s;
  Request.DataString := ABase64;
  Request.DataUpload := AFile;
  ExecuteRequest({$IFDEF LCLWEBLIB}@{$ENDIF}DoRequestScanPicture);
end;

procedure TTMSFNCCloudGoogleVision.RegisterRuntimeClasses;
begin
  inherited;
  RegisterClass(TTMSFNCCloudGoogleVision);
end;

{ TTMSFNCCloudGoogleVisionDetectedObject }

procedure TTMSFNCCloudGoogleVisionDetectedObject.Assign(Source: TPersistent);
begin
   if (Source is TTMSFNCCloudGoogleVisionDetectedObject) then
  begin
    FPoints := (Source as TTMSFNCCloudGoogleVisionDetectedObject).FPoints;
    FName := (Source as TTMSFNCCloudGoogleVisionDetectedObject).FName;
    FConfidence := (Source as TTMSFNCCloudGoogleVisionDetectedObject).FConfidence;
  end
  else
    inherited;
end;

procedure TTMSFNCCloudGoogleVisionDetectedObject.CalculateRectF(AFile: TTMSFNCUtilsFile; ABase64: string);
var
  I: Integer;
  b: TTMSFNCBitmap;
  b64: string;
begin
  b := TTMSFNCBitmap.Create;
  try
    {$IFDEF WEBLIB}
    if ABase64 <> '' then
      b64 := 'data:image/png;base64,' + ABase64
    else
      b64 := 'data:image/png;base64,' + TTMSFNCUtils.FileToBase64(AFile);
    {$ELSE}
    if ABase64 <> '' then
      b64 := ABase64
    else
      b64 := TTMSFNCUtils.FileToBase64(AFile);
    {$ENDIF}

    b.LoadFromFile(b64);
    for I := 0 to High(Points) do
      Points[I] := PointF((Points[I].X * b.Width), (Points[I].Y * b.Height));
  finally
    b.Free;
  end;
end;

constructor TTMSFNCCloudGoogleVisionDetectedObject.Create(Collection: TCollection);
begin
  inherited;
  FName := EmptyStr;
  FConfidence := 0;
  SetLength(FPoints,4);
end;

procedure TTMSFNCCloudGoogleVisionDetectedObject.FromJSON(jo: TJSONValue);
var
 j, ja, jo2: TJSONValue;
  I: Integer;
begin
  FName := TTMSFNCUtils.GetJSONProp(jo, 'name');
  FConfidence := TTMSFNCUtils.GetJSONDoubleValue(jo, 'score');
  j := TTMSFNCUtils.GetJSONValue(jo,'boundingPoly');
  if Assigned(j) then
  begin
    ja  := TTMSFNCUtils.GetJSONValue(j,'normalizedVertices');
    if Assigned(ja) and (ja is TJSONArray) then
    begin
      for I := 0 to TTMSFNCUtils.GetJSONArraySize(ja as TJSONArray) - 1 do
      begin
        jo2 := TTMSFNCUtils.GetJSONArrayItem(ja as TJSONArray, I);
        if Assigned(jo2) then
          FPoints[I] := PointF(TTMSFNCUtils.GetJSONDoubleValue(jo2,'x'),TTMSFNCUtils.GetJSONDoubleValue(jo2,'y'))
      end;
    end;
  end;
end;

{ TTMSFNCCloudGoogleVisionDetectedObjects }

function TTMSFNCCloudGoogleVisionDetectedObjects.Add: TTMSFNCCloudGoogleVisionDetectedObject;
begin
   Result := TTMSFNCCloudGoogleVisionDetectedObject(inherited Add);
end;

constructor TTMSFNCCloudGoogleVisionDetectedObjects.Create(AOwner: TTMSFNCCloudGoogleVisionResponse);
begin
   inherited Create(AOwner, TTMSFNCCloudGoogleVisionDetectedObject);
  FOwner := AOwner;
end;

function TTMSFNCCloudGoogleVisionDetectedObjects.GetItems(Index: Integer): TTMSFNCCloudGoogleVisionDetectedObject;
begin
  Result := TTMSFNCCloudGoogleVisionDetectedObject(inherited Items[Index]);
end;

function TTMSFNCCloudGoogleVisionDetectedObjects.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TTMSFNCCloudGoogleVisionDetectedObjects.Insert(Index: Integer): TTMSFNCCloudGoogleVisionDetectedObject;
begin
  Result := TTMSFNCCloudGoogleVisionDetectedObject(inherited Insert(Index));
end;

procedure TTMSFNCCloudGoogleVisionDetectedObjects.SetItems(Index: Integer; const Value: TTMSFNCCloudGoogleVisionDetectedObject);
begin
  inherited Items[Index] := Value;
end;

procedure TTMSFNCCloudGoogleVisionDetectedObjects.Update(Item: TCollectionItem);
begin
  inherited;
end;

{ TTMSFNCCloudGoogleVisionResponse }

constructor TTMSFNCCloudGoogleVisionResponse.Create(Collection: TCollection);
begin
  inherited;
  FDetectedObjects := TTMSFNCCloudGoogleVisionDetectedObjects.Create(self);
  FDetectedFaces := TTMSFNCCloudGoogleVisionDetectedFaces.Create(self);
  FImageLabels := TTMSFNCCloudGoogleVisionLabels.Create(self);
  FDetectedLogos := TTMSFNCCloudGoogleVisionLogos.Create(self);
  FDetectedLandmarks := TTMSFNCCloudGoogleVisionLandmarks.Create(Self);
  FSafeSearch := TTMSFNCCloudGoogleVisionSafeSearch.Create(self);
  FWebDetection := TTMSFNCCloudGoogleVisionWebDetection.Create(self);
  FDetectedText := TTMSFNCCloudGoogleVisiondetectedTexts.Create(self);
  if Collection is TTMSFNCCloudGoogleVisionResponses then
  begin
    FOwner := Collection as TTMSFNCCloudGoogleVisionResponses;
  end;
end;

destructor TTMSFNCCloudGoogleVisionResponse.Destroy;
begin
  FDetectedObjects.Free;
  FImageLabels.Free;
  FDetectedLogos.Free;
  FDetectedLandmarks.Free;
  FDetectedFaces.Free;
  FSafeSearch.Free;
  FDetectedText.Free;
  FWebDetection.Free;
  inherited;
end;

{ TTMSFNCCloudGoogleVisionLabels }

function TTMSFNCCloudGoogleVisionLabels.Add: TTMSFNCCloudGoogleVisionLabel;
begin
  Result := TTMSFNCCloudGoogleVisionLabel(inherited Add);
end;

constructor TTMSFNCCloudGoogleVisionLabels.Create(AOwner: TTMSFNCCloudGoogleVisionResponse);
begin
  inherited Create(AOwner, TTMSFNCCloudGoogleVisionLabel);
  FOwner := AOwner;
end;

function TTMSFNCCloudGoogleVisionLabels.GetItems(Index: Integer): TTMSFNCCloudGoogleVisionLabel;
begin
  Result := TTMSFNCCloudGoogleVisionLabel(inherited Items[Index]);
end;

function TTMSFNCCloudGoogleVisionLabels.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TTMSFNCCloudGoogleVisionLabels.Insert(Index: Integer): TTMSFNCCloudGoogleVisionLabel;
begin
  Result := TTMSFNCCloudGoogleVisionLabel(inherited Insert(Index));
end;

procedure TTMSFNCCloudGoogleVisionLabels.SetItems(Index: Integer; const Value: TTMSFNCCloudGoogleVisionLabel);
begin
  inherited Items[Index] := Value;
end;

procedure TTMSFNCCloudGoogleVisionLabels.Update(Item: TCollectionItem);
begin
  inherited;

end;

{ TTMSFNCCloudGoogleVisionLabel }

procedure TTMSFNCCloudGoogleVisionLabel.Assign(Source: TPersistent);
begin
  if (Source is TTMSFNCCloudGoogleVisionLabel) then
  begin
    FDescription := (Source as TTMSFNCCloudGoogleVisionLabel).FDescription;
    FScore := (Source as TTMSFNCCloudGoogleVisionLabel).FScore;
    FTopicality := (Source as TTMSFNCCloudGoogleVisionLabel).FTopicality;
  end
  else
    inherited;
end;

constructor TTMSFNCCloudGoogleVisionLabel.Create(Collection: TCollection);
begin
  inherited;
  FDescription := EmptyStr;
  FScore := 0;
  FTopicality := 0;
end;

procedure TTMSFNCCloudGoogleVisionLabel.FromJSON(jo: TJSONValue);
begin
  FDescription := TTMSFNCUtils.GetJSONProp(jo,'description');
  FScore := TTMSFNCUtils.GetJSONDoubleValue(jo,'score');
  FTopicality := TTMSFNCUtils.GetJSONDoubleValue(jo,'topicality');
end;

{ TTMSFNCCloudGoogleVisionLogos }

function TTMSFNCCloudGoogleVisionLogos.Add: TTMSFNCCloudGoogleVisionLogo;
begin
  Result := TTMSFNCCloudGoogleVisionLogo(inherited Add);
end;

constructor TTMSFNCCloudGoogleVisionLogos.Create(AOwner: TTMSFNCCloudGoogleVisionResponse);
begin
  inherited Create(AOwner, TTMSFNCCloudGoogleVisionLogo);
  FOwner := AOwner;
end;

function TTMSFNCCloudGoogleVisionLogos.GetItems(Index: Integer): TTMSFNCCloudGoogleVisionLogo;
begin
  Result := TTMSFNCCloudGoogleVisionLogo(inherited Items[Index]);
end;

function TTMSFNCCloudGoogleVisionLogos.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TTMSFNCCloudGoogleVisionLogos.Insert(Index: Integer): TTMSFNCCloudGoogleVisionLogo;
begin
  Result := TTMSFNCCloudGoogleVisionLogo(inherited Insert(Index));
end;

procedure TTMSFNCCloudGoogleVisionLogos.SetItems(Index: Integer; const Value: TTMSFNCCloudGoogleVisionLogo);
begin
  inherited Items[Index] := Value;
end;

procedure TTMSFNCCloudGoogleVisionLogos.Update(Item: TCollectionItem);
begin
  inherited;

end;

{ TTMSFNCCloudGoogleVisionLogo }

procedure TTMSFNCCloudGoogleVisionLogo.Assign(Source: TPersistent);
begin
  if (Source is TTMSFNCCloudGoogleVisionLogo) then
  begin
    FDescription := (Source as TTMSFNCCloudGoogleVisionLogo).FDescription;
    FScore := (Source as TTMSFNCCloudGoogleVisionLogo).FScore;
    FPoints := (Source as TTMSFNCCloudGoogleVisionLogo).FPoints;
  end
  else
    inherited;
end;

constructor TTMSFNCCloudGoogleVisionLogo.Create(Collection: TCollection);
begin
  inherited;
  FDescription := EmptyStr;
  FScore := 0;
  SetLength(FPoints,4);
end;

procedure TTMSFNCCloudGoogleVisionLogo.FromJSON(jo: TJSONValue);
var
  i: Integer;
begin
  FDescription := TTMSFNCUtils.GetJSONProp(jo,'description');
  FScore := TTMSFNCUtils.GetJSONDoubleValue(jo,'score');
  for I := 0 to High(FPoints) do
    FPoints[I] := GetJSONPoint(jo, I);
end;

{ TTMSFNCCloudGoogleVisionLandmarks }

function TTMSFNCCloudGoogleVisionLandmarks.Add: TTMSFNCCloudGoogleVisionLandmark;
begin
  Result := TTMSFNCCloudGoogleVisionLandmark(inherited Add);
end;

constructor TTMSFNCCloudGoogleVisionLandmarks.Create(AOwner: TTMSFNCCloudGoogleVisionResponse);
begin
  inherited Create(AOwner, TTMSFNCCloudGoogleVisionLandmark);
  FOwner := AOwner;
end;

function TTMSFNCCloudGoogleVisionLandmarks.GetItems(Index: Integer): TTMSFNCCloudGoogleVisionLandmark;
begin
  Result := TTMSFNCCloudGoogleVisionLandmark(inherited Items[Index]);
end;

function TTMSFNCCloudGoogleVisionLandmarks.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TTMSFNCCloudGoogleVisionLandmarks.Insert(Index: Integer): TTMSFNCCloudGoogleVisionLandmark;
begin
  Result := TTMSFNCCloudGoogleVisionLandmark(inherited Insert(Index));
end;

procedure TTMSFNCCloudGoogleVisionLandmarks.SetItems(Index: Integer; const Value: TTMSFNCCloudGoogleVisionLandmark);
begin
  inherited Items[Index] := Value;
end;

procedure TTMSFNCCloudGoogleVisionLandmarks.Update(Item: TCollectionItem);
begin
  inherited;

end;

{ TTMSFNCCloudGoogleVisionLandmark }

procedure TTMSFNCCloudGoogleVisionLandmark.Assign(Source: TPersistent);
begin
  if (Source is TTMSFNCCloudGoogleVisionLandmark) then
  begin
    FDescription := (Source as TTMSFNCCloudGoogleVisionLandmark).FDescription;
    FScore := (Source as TTMSFNCCloudGoogleVisionLandmark).FScore;
    FPoints := (Source as TTMSFNCCloudGoogleVisionLandmark).FPoints;
  end
  else
    inherited;
end;

constructor TTMSFNCCloudGoogleVisionLandmark.Create(Collection: TCollection);
begin
  inherited;
  FDescription := EmptyStr;
  FScore := 0;
  SetLength(FPoints,4);
end;

procedure TTMSFNCCloudGoogleVisionLandmark.FromJSON(jo: TJSONValue);
var
  I: Integer;
begin
  FDescription := TTMSFNCUtils.GetJSONProp(jo,'description');
  FScore := TTMSFNCUtils.GetJSONDoubleValue(jo,'score');
  for I := 0 to High(FPoints) do
    FPoints[I] := GetJSONPoint(jo, I);
end;

{ TTMSFNCCloudGoogleVisionSafeSearch }

constructor TTMSFNCCloudGoogleVisionSafeSearch.Create(AOwner: TTMSFNCCloudGoogleVisionResponse);
begin

  FMedical := EmptyStr;
  FAdult := EmptyStr;
  FSpoof := EmptyStr;
  FViolence := EmptyStr;
  FRacy := EmptyStr;
end;

destructor TTMSFNCCloudGoogleVisionSafeSearch.Destroy;
begin

  inherited;
end;

procedure TTMSFNCCloudGoogleVisionSafeSearch.FromJSON(jo: TJSONValue);
begin
  FMedical := TTMSFNCUtils.GetJSONProp(jo,'medical');
  FAdult := TTMSFNCUtils.GetJSONProp(jo,'adult');
  FSpoof := TTMSFNCUtils.GetJSONProp(jo,'spoof');
  FViolence := TTMSFNCUtils.GetJSONProp(jo,'violence');
  FRacy := TTMSFNCUtils.GetJSONProp(jo,'racy');
end;

{ TTMSFNCCloudGoogleVisionWebLabels }

function TTMSFNCCloudGoogleVisionWebEntities.Add: TTMSFNCCloudGoogleVisionWebEntity;
begin
  Result := TTMSFNCCloudGoogleVisionWebEntity(inherited Add);
end;

constructor TTMSFNCCloudGoogleVisionWebEntities.Create( AOwner: TTMSFNCCloudGoogleVisionWebDetection);
begin
  inherited Create(AOwner, TTMSFNCCloudGoogleVisionWebEntity);
  FOwner := AOwner;
end;

function TTMSFNCCloudGoogleVisionWebEntities.GetItems(Index: Integer): TTMSFNCCloudGoogleVisionWebEntity;
begin
  Result := TTMSFNCCloudGoogleVisionWebEntity(inherited Items[Index]);
end;

function TTMSFNCCloudGoogleVisionWebEntities.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TTMSFNCCloudGoogleVisionWebEntities.Insert( Index: Integer): TTMSFNCCloudGoogleVisionWebEntity;
begin
  Result := TTMSFNCCloudGoogleVisionWebEntity(inherited Insert(Index));
end;

procedure TTMSFNCCloudGoogleVisionWebEntities.SetItems(Index: Integer;const Value: TTMSFNCCloudGoogleVisionWebEntity);
begin
  inherited Items[Index] := Value;
end;

procedure TTMSFNCCloudGoogleVisionWebEntities.Update(Item: TCollectionItem);
begin
  inherited;

end;

{ TTMSFNCCloudGoogleVisionWebLabel }

procedure TTMSFNCCloudGoogleVisionWebEntity.Assign(Source: TPersistent);
begin
  if (Source is TTMSFNCCloudGoogleVisionWebEntity) then
  begin
    FDescription := (Source as TTMSFNCCloudGoogleVisionWebEntity).FDescription;
    FScore := (Source as TTMSFNCCloudGoogleVisionWebEntity).FScore;
  end
  else
    inherited;
end;

constructor TTMSFNCCloudGoogleVisionWebEntity.Create(Collection: TCollection);
begin
  inherited;
  FDescription := EmptyStr;
  FScore := 0;
end;

procedure TTMSFNCCloudGoogleVisionWebEntity.FromJSON(jo: TJSONValue);
begin
  FDescription := TTMSFNCUtils.GetJSONProp(jo,'description');
  FScore := TTMSFNCUtils.GetJSONDoubleValue(jo,'score');
end;

{ TTMSFNCCloudGoogleVisionWebDetection }

constructor TTMSFNCCloudGoogleVisionWebDetection.Create(AOwner: TTMSFNCCloudGoogleVisionResponse);
begin
  FWebEntities := TTMSFNCCloudGoogleVisionWebEntities.Create(self);
  FMatchingWebPageImages := TTMSFNCCloudGoogleVisionWebImagePageMatches.Create(self);
  FBestGuessLabels := TStringList.Create;
  FVisualSimiliarImages := TStringList.Create;
end;

destructor TTMSFNCCloudGoogleVisionWebDetection.Destroy;
begin
  FWebEntities.Free;
  FMatchingWebPageImages.Free;
  FBestGuessLabels.Free;
  FVisualSimiliarImages.Free;
  inherited;
end;

{ TTMSFNCCloudGoogleVisionWebImagePageMatches }

function TTMSFNCCloudGoogleVisionWebImagePageMatches.Add: TTMSFNCCloudGoogleVisionWebImagePageMatch;
begin
  Result := TTMSFNCCloudGoogleVisionWebImagePageMatch(inherited Add);
end;

constructor TTMSFNCCloudGoogleVisionWebImagePageMatches.Create(AOwner: TTMSFNCCloudGoogleVisionWebDetection);
begin
  inherited Create(AOwner, TTMSFNCCloudGoogleVisionWebImagePageMatch);
  FOwner := AOwner;
end;

function TTMSFNCCloudGoogleVisionWebImagePageMatches.GetItems(Index: Integer): TTMSFNCCloudGoogleVisionWebImagePageMatch;
begin
  Result := TTMSFNCCloudGoogleVisionWebImagePageMatch(inherited Items[Index]);
end;

function TTMSFNCCloudGoogleVisionWebImagePageMatches.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TTMSFNCCloudGoogleVisionWebImagePageMatches.Insert(Index: Integer): TTMSFNCCloudGoogleVisionWebImagePageMatch;
begin
  Result := TTMSFNCCloudGoogleVisionWebImagePageMatch(inherited Insert(Index));
end;

procedure TTMSFNCCloudGoogleVisionWebImagePageMatches.SetItems(Index: Integer;const Value: TTMSFNCCloudGoogleVisionWebImagePageMatch);
begin
  inherited Items[Index] := Value;
end;

procedure TTMSFNCCloudGoogleVisionWebImagePageMatches.Update(Item: TCollectionItem);
begin
  inherited;

end;

{ TTMSFNCCloudGoogleVisionWebImagePageMatch }

procedure TTMSFNCCloudGoogleVisionWebImagePageMatch.Assign(Source: TPersistent);
begin
  if (Source is TTMSFNCCloudGoogleVisionWebImagePageMatch) then
  begin
    FPageURL := (Source as TTMSFNCCloudGoogleVisionWebImagePageMatch).FPageURL;
    FImageURL := (Source as TTMSFNCCloudGoogleVisionWebImagePageMatch).FImageURL;
    FPageTitle := (Source as TTMSFNCCloudGoogleVisionWebImagePageMatch).FPageTitle;
  end
  else
    inherited;
end;

constructor TTMSFNCCloudGoogleVisionWebImagePageMatch.Create(Collection: TCollection);
begin
  inherited;
  FPageURL := EmptyStr;
  FImageURL := TStringList.Create;
  FPageTitle := EmptyStr;
end;

procedure TTMSFNCCloudGoogleVisionWebImagePageMatch.FromJSON(jo: TJSONValue);
var
  j, j2: TJSONValue;
  I: Integer;
begin
  FPageURL := TTMSFNCUtils.GetJSONProp(jo,'url');
  FPageTitle := TTMSFNCUtils.GetJSONProp(jo,'pageTitle');
  j := TTMSFNCUtils.GetJSONValue(jo,'partialMatchingImages');
  if Assigned(j) and (j is TJSONArray) then
  begin
    for I := 0 to TTMSFNCUtils.GetJSONArraySize(j as TJSONArray) - 1 do
    begin
      j2 := TTMSFNCUtils.GetJSONArrayItem(j as TJSONArray, I);
      if Assigned(j2) then
      begin
        FImageURL.Add(TTMSFNCUtils.GetJSONProp(j2,'url'));
      end;
    end;
  end;
end;

{ TTMSFNCCloudGoogleVisionResponses }

function TTMSFNCCloudGoogleVisionResponses.Add: TTMSFNCCloudGoogleVisionResponse;
begin
  Result := TTMSFNCCloudGoogleVisionResponse(inherited Add);
end;

constructor TTMSFNCCloudGoogleVisionResponses.Create( AOwner: TTMSFNCCustomCloudGoogleVision);
begin
  inherited Create(AOwner, TTMSFNCCloudGoogleVisionResponse);
  FOwner := AOwner;
end;

function TTMSFNCCloudGoogleVisionResponses.GetItems(Index: Integer): TTMSFNCCloudGoogleVisionResponse;
begin
  Result := TTMSFNCCloudGoogleVisionResponse(inherited Items[Index]);
end;

function TTMSFNCCloudGoogleVisionResponses.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TTMSFNCCloudGoogleVisionResponses.Insert( Index: Integer): TTMSFNCCloudGoogleVisionResponse;
begin
  Result := TTMSFNCCloudGoogleVisionResponse(inherited Insert(Index));
end;

procedure TTMSFNCCloudGoogleVisionResponses.SetItems(Index: Integer; const Value: TTMSFNCCloudGoogleVisionResponse);
begin
  inherited Items[Index] := Value;
end;

procedure TTMSFNCCloudGoogleVisionResponses.Update(Item: TCollectionItem);
begin
  inherited;

end;

{ TTMSFNCCLoudGoogleVisionDetectedTexts }

function TTMSFNCCLoudGoogleVisionDetectedTexts.Add: TTMSFNCCloudGoogleVisiondetectedText;
begin
  Result := TTMSFNCCloudGoogleVisiondetectedText(inherited Add);
end;

constructor TTMSFNCCLoudGoogleVisionDetectedTexts.Create(AOwner: TTMSFNCCloudGoogleVisionResponse);
begin
  inherited Create(AOwner, TTMSFNCCloudGoogleVisiondetectedText);
  FOwner := AOwner;
end;

function TTMSFNCCLoudGoogleVisionDetectedTexts.GetItems(Index: Integer): TTMSFNCCloudGoogleVisiondetectedText;
begin
  Result := TTMSFNCCloudGoogleVisiondetectedText(inherited Items[Index]);
end;

function TTMSFNCCLoudGoogleVisionDetectedTexts.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TTMSFNCCLoudGoogleVisionDetectedTexts.Insert(Index: Integer): TTMSFNCCloudGoogleVisiondetectedText;
begin
  Result := TTMSFNCCloudGoogleVisiondetectedText(inherited Insert(Index));
end;

procedure TTMSFNCCLoudGoogleVisionDetectedTexts.SetItems(Index: Integer;const Value: TTMSFNCCloudGoogleVisiondetectedText);
begin
  inherited Items[Index] := Value;
end;

procedure TTMSFNCCLoudGoogleVisionDetectedTexts.Update(Item: TCollectionItem);
begin
  inherited;

end;

{ TTMSFNCCloudGoogleVisiondetectedText }

procedure TTMSFNCCloudGoogleVisiondetectedText.Assign(Source: TPersistent);
begin
  if (Source is TTMSFNCCloudGoogleVisiondetectedText) then
  begin
    FDescription := (Source as TTMSFNCCloudGoogleVisiondetectedText).FDescription;
    FLanguage := (Source as TTMSFNCCloudGoogleVisiondetectedText).FLanguage;
    FPoints := (Source as TTMSFNCCloudGoogleVisiondetectedText).FPoints;
  end
  else
    inherited;
end;

constructor TTMSFNCCloudGoogleVisiondetectedText.Create(Collection: TCollection);
begin
  inherited;
  FDescription := EmptyStr;
  FLanguage := EmptyStr;
  SetLength(FPoints, 4);
end;

procedure TTMSFNCCloudGoogleVisiondetectedText.FromJSON(jo: TJSONValue);
var
  I: Integer;
begin
  FDescription := TTMSFNCUtils.GetJSONProp(jo,'description');
  FLanguage := TTMSFNCUtils.GetJSONProp(jo,'locale');
  for I := 0 to High(FPoints) do
  begin
    FPoints[I] := GetJSONPoint(jo,I);
  end;
end;

{ TTMSFNCCloudGoogleVisionDetectedFaces }

function TTMSFNCCloudGoogleVisionDetectedFaces.Add: TTMSFNCCloudGoogleVisionDetectedFace;
begin
   Result := TTMSFNCCloudGoogleVisionDetectedFace(inherited Add);
end;

constructor TTMSFNCCloudGoogleVisionDetectedFaces.Create(AOwner: TTMSFNCCloudGoogleVisionResponse);
begin
  inherited Create(AOwner, TTMSFNCCloudGoogleVisionDetectedFace);
  FOwner := AOwner;
end;

function TTMSFNCCloudGoogleVisionDetectedFaces.GetItems(Index: Integer): TTMSFNCCloudGoogleVisionDetectedFace;
begin
  Result := TTMSFNCCloudGoogleVisionDetectedFace(inherited Items[Index]);
end;

function TTMSFNCCloudGoogleVisionDetectedFaces.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TTMSFNCCloudGoogleVisionDetectedFaces.Insert(Index: Integer): TTMSFNCCloudGoogleVisionDetectedFace;
begin
  Result := TTMSFNCCloudGoogleVisionDetectedFace(inherited Insert(Index));
end;

procedure TTMSFNCCloudGoogleVisionDetectedFaces.SetItems(Index: Integer; const Value: TTMSFNCCloudGoogleVisionDetectedFace);
begin
  inherited Items[Index] := Value;
end;

procedure TTMSFNCCloudGoogleVisionDetectedFaces.Update(Item: TCollectionItem);
begin
  inherited;

end;

{ TTMSFNCCloudGoogleVisionDetectedFace }

procedure TTMSFNCCloudGoogleVisionDetectedFace.Assign(Source: TPersistent);
begin
  if (Source is TTMSFNCCloudGoogleVisionDetectedFace) then
  begin
    FLandmarks := (Source as TTMSFNCCloudGoogleVisionDetectedFace).FLandmarks;
    FFacePoints := (Source as TTMSFNCCloudGoogleVisionDetectedFace).FFacePoints;
    FPoints := (Source as TTMSFNCCloudGoogleVisionDetectedFace).FPoints;
  end
  else
    inherited;
end;

constructor TTMSFNCCloudGoogleVisionDetectedFace.Create(Collection: TCollection);
begin
  inherited;
  FLandmarks := TTMSFNCCloudGoogleVisionFaceLandmarks.Create(self);
  SetLength(FFacePoints, 4);
  SetLength(FPoints, 4);
end;

destructor TTMSFNCCloudGoogleVisionDetectedFace.Destroy;
begin
  FLandmarks.Free;
  inherited;
end;

procedure TTMSFNCCloudGoogleVisionDetectedFace.FromJSON(jo: TJSONValue);
var
  j, ja, jao: TJSONValue;
  i: Integer;
  Landmark: TTMSFNCCloudGoogleVisionFaceLandmark;
begin
  for I := 0 to High(FPoints) do
    FPoints[I] := GetJSONPoint(jo, I);

  j := TTMSFNCUtils.GetJSONValue(jo, 'fdBoundingPoly');
  if Assigned(j) then
  begin
    ja := TTMSFNCUtils.GetJSONValue(j,'vertices');
    if Assigned(ja) and (ja is TJSONArray) then
    begin
      for I := 0 to TTMSFNCUtils.GetJSONArraySize(ja as TJSONArray) - 1 do
      begin
        jao := TTMSFNCUtils.GetJSONArrayItem(ja as TJSONArray, I);
        if Assigned(jao) then
          FFacePoints[I] := PointF(TTMSFNCUtils.GetJSONDoubleValue(jao,'x'),TTMSFNCUtils.GetJSONDoubleValue(jao,'y'));
      end;
    end;
  end;

  ja := TTMSFNCUtils.GetJSONValue(jo,'landmarks');
  if Assigned(ja) and (ja is TJSONArray) then
  begin
    for I := 0 to TTMSFNCUtils.GetJSONArraySize(ja as TJSONArray) - 1 do
    begin
      Landmark := FLandmarks.Add;
      Landmark.FromJSON(TTMSFNCUtils.GetJSONArrayItem(ja as TJSONArray, I));
    end;
  end;
end;

{ TTMSFNCCloudGoogleVisionFaceLandmarks }

function TTMSFNCCloudGoogleVisionFaceLandmarks.Add: TTMSFNCCloudGoogleVisionFaceLandmark;
begin
   Result := TTMSFNCCloudGoogleVisionFaceLandmark(inherited Add);
end;

constructor TTMSFNCCloudGoogleVisionFaceLandmarks.Create(AOwner: TTMSFNCCloudGoogleVisionDetectedFace);
begin
  inherited Create(AOwner, TTMSFNCCloudGoogleVisionFaceLandmark);
  FOwner := AOwner;
end;

function TTMSFNCCloudGoogleVisionFaceLandmarks.GetItems(Index: Integer): TTMSFNCCloudGoogleVisionFaceLandmark;
begin
  Result := TTMSFNCCloudGoogleVisionFaceLandmark(inherited Items[Index]);
end;

function TTMSFNCCloudGoogleVisionFaceLandmarks.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TTMSFNCCloudGoogleVisionFaceLandmarks.Insert(Index: Integer): TTMSFNCCloudGoogleVisionFaceLandmark;
begin
   Result := TTMSFNCCloudGoogleVisionFaceLandmark(inherited Insert(Index));
end;

procedure TTMSFNCCloudGoogleVisionFaceLandmarks.SetItems(Index: Integer; const Value: TTMSFNCCloudGoogleVisionFaceLandmark);
begin
   inherited Items[Index] := Value;
end;

procedure TTMSFNCCloudGoogleVisionFaceLandmarks.Update(Item: TCollectionItem);
begin
  inherited;

end;

{ TTMSFNCCloudGoogleVisionFaceLandmark }

procedure TTMSFNCCloudGoogleVisionFaceLandmark.Assign(Source: TPersistent);
begin
  if (Source is TTMSFNCCloudGoogleVisionFaceLandmark) then
  begin
    FName := (Source as TTMSFNCCloudGoogleVisionFaceLandmark).FName;
    FPoint := (Source as TTMSFNCCloudGoogleVisionFaceLandmark).FPoint;
  end
  else
    inherited;
end;

constructor TTMSFNCCloudGoogleVisionFaceLandmark.Create(Collection: TCollection);
begin
  inherited;
  FName := EmptyStr;
  FPoint := PointF(0,0);
end;

destructor TTMSFNCCloudGoogleVisionFaceLandmark.Destroy;
begin
  inherited;
end;

procedure TTMSFNCCloudGoogleVisionFaceLandmark.FromJSON(jo: TJSONValue);
var
  j: TJSONValue;
begin
  FName := TTMSFNCUtils.GetJSONProp(jo, 'type');
  j := TTMSFNCUtils.GetJSONValue(jo, 'position');
  if Assigned(j) then
    FPoint := PointF(TTMSFNCUtils.GetJSONDoubleValue(j, 'x'), TTMSFNCUtils.GetJSONDoubleValue(j, 'y'));
end;

end.
