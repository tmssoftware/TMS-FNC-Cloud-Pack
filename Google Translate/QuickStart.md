# Cloud Google Translate #
Please follow the steps below to get started with Google Translate, after following the <a href="https://github.com/tmssoftware/TMS-FNC-Cloud-Pack/blob/master/README.md">main</a> steps to install the components in the IDE.
<ol>
  <li>Enable Google Cloud Translation API (https://cloud.google.com/service-usage/docs/enable-disable)
  <li>Create a new API key (https://console.developers.google.com)
  <li>Drop an instance of TTMSFNCCloudGoogleTranslate on the form</li>  
  <li>Assign an API key to the Authentication.Key property

  ```delphi
  TMSFNCCloudGoogleTranslate1.Authentication.Key := 'XXXXXXXXXXXXXXXXXXXXXXX';    
  ```
  
  </li>  
  <li>Call the asynchronous TranslateText method</li>
  
  ```delphi
  TMSFNCCloudGoogleTranslate1.TranslateText('Hello World !', 'de');
  ```
  
  <li>Assign the event OnTranslateText and catch the result of the TranslateText call
  
  ```delphi
  TMSFNCCloudGoogleTranslate1.OnTranslateText := DoTranslateText;  
  ```
  
  ```delphi    
  procedure TForm1.DoTranslateText(Sender: TObject;
    const ATranslations: TTMSFNCCloudGoogleTranslateTranslations;
    const ARequestResult: TTMSFNCCloudBaseRequestResult);
  var
    I: Integer;
  begin
    if ARequestResult.Success then
    begin
      for I := 0 to ATranslations.Count - 1 do
        ShowMessage(ATranslations[I].TranslatedText);
    end;
  end;
  ```
  
  </li>    
</ol>
