<a href="http://www.tmssoftware.com/site/tmsfnccloudpack.asp"><img src="https://tmssoftware.com/site/img/github/tmsfnccloudpack.png" title="TMS FNC Cloud Pack" alt="TMS FNC Cloud Pack"></a>
# Cloud Google Vision <img src="http://tmssoftware.com/site/img/github/tmsfnccloudgooglevision.png"/> #
Please follow the steps below to get started with Google Vision, after following the <a href="https://github.com/tmssoftware/TMS-FNC-Cloud-Pack/blob/master/README.md">main</a> steps to install the components in the IDE.
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
  
  ```delphi
  TMSFNCCloudGoogleVision1.ScanImage();
  ```
  
  <li>Assign the event OnScanImage and catch the result of the ScanImage call
  
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
    end;
  end;
  ```
  
  </li>    
</ol>
