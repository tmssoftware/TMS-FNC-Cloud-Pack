<a href="http://www.tmssoftware.com/site/tmsfnccloudpack.asp"><img src="https://tmssoftware.com/site/img/github/tmsfnccloudpack.png" title="TMS FNC Cloud Pack" alt="TMS FNC Cloud Pack"></a>
# Cloud Google Vision <img src="http://tmssoftware.com/site/img/github/tmsfnccloudgooglevision.png"/> #
Please follow the steps below to get started with Google Vision, after following the <a href="https://github.com/tmssoftware/TMS-FNC-Cloud-Pack/blob/master/README.md">main</a> steps to install the components in the IDE. The sample below is based on a TTMSFNCImage which is available in the <a href="http://www.tmssoftware.com/site/tmsfncuipack.asp">TMS FNC UI Pack</a>.
<ol>
  <li>Enable Google Cloud Vision API (https://cloud.google.com/service-usage/docs/enable-disable)
  <li>Create a new API key (https://console.developers.google.com)
  <li>Drop an instance of TTMSFNCCloudGoogleVision on the form</li>  
  <li>Assign an API key to the Authentication.Key property

  ```delphi
  TMSFNCCloudGoogleVision1.Authentication.Key := 'XXXXXXXXXXXXXXXXXXXXXXX';    
  ```
  
  </li>  
  <li>Call the asynchronous ScanImage method</li>
  <BR/>
  WEB
  ```delphi
    TMSFNCCloudGoogleVision1.ScanImageBase64(StringReplace(TMSFNCImage1.Canvas.GetBase64Image, 'data:image/png;base64,', '', [rfReplaceAll]));
  ```
  FMX/VCL/LCL
  ```delphi
  procedure TForm1.ScanImage;
  var
    m: TBytesStream;
  begin
    m := TBytesStream.Create;
    try
      TMSFNCImage1.Bitmap.SaveToStream(m);
      TMSFNCCloudGoogleVision1.ScanImageBase64(TTMSFNCUtils.Encode64(m.Bytes));
    finally
      m.Free;
    end;
  end;
  ```
    
  <li>Assign the event OnScanImage and repaint the TTMSFNCImage instance
  
  ```delphi
  TMSFNCCloudGoogleVision1.OnScanImage := DoScanImage;  
  ```
  
  ```delphi    
  procedure TForm1.DoScanImage(Sender: TObject;
    const AResponse: TTMSFNCCloudGoogleVisionResponse; 
    const ARequestResult: TTMSFNCCloudBaseRequestResult);
  begin
    if ARequestResult.Success then
    begin
      TMSFNCImage1.Invalidate;
    end;
  end;
  ```
  
  </li>   
  
  <li>Assign a bitmap to the TTMSFNCImage instance and preset some properties for image aspect ratio and stretching.
  
  ```delphi
  TMSFNCImage1.AspectRatio := False;
  TMSFNCImage1.AutoSize := True;
  TMSFNCImage1.Stretch := False;
  ```
</ol>
