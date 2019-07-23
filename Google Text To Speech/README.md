<a href="http://www.tmssoftware.com/site/tmsfnccloudpack.asp"><img src="https://tmssoftware.com/site/img/github/tmsfnccloudpack.png" title="TMS FNC Cloud Pack" alt="TMS FNC Cloud Pack"></a>
# Cloud Google Text To Speech <img src="http://tmssoftware.com/site/img/github/tmsfnccloudgoogletexttospeech.png"/> #
Please follow the steps below to get started with Google Text To Speech, after following the <a href="https://github.com/tmssoftware/TMS-FNC-Cloud-Pack/blob/master/README.md">main</a> steps to install the components in the IDE.
<ol>
  <li>Enable Google Cloud Text-To-Speech API (https://cloud.google.com/service-usage/docs/enable-disable)
  <li>Create a new API key (https://console.developers.google.com)
  <li>Drop an instance of TTMSFNCCloudGoogleTextToSpeech on the form</li>  
  <li>Assign an API key to the Authentication.Key property

  ```delphi
  TMSFNCCloudGoogleTextToSpeech1.Authentication.Key := 'XXXXXXXXXXXXXXXXXXXXXXX';    
  ```
  
  </li>  
  <li>Call the asynchronous TextToSpeech method</li>
  
  ```delphi
  TMSFNCCloudGoogleTextToSpeech1.TextToSpeech('Hello World !');
  ```
  
  <li>Assign the event OnTextToSpeech and catch the result of the TextToSpeech call
  
  ```delphi
  TMSFNCCloudGoogleTextToSpeech1.OnTextToSpeech := DoTextToSpeech;  
  ```
  TMS FNC Core:
  ```delphi
  procedure TForm1.DoTextToSpeech(Sender: TObject; const ABase64Audio: string;
    const ARequestResult: TTMSFNCCloudBaseRequestResult);
  begin
    if ARequestResult.Success then
      TTMSFNCUtils.PlayAudio(ABase64Audio);
  end;
  ```
  
  WEB:
  ```delphi    
  procedure TForm1.DoTextToSpeech(Sender: TObject; const ABase64Audio: string;
    const ARequestResult: TTMSFNCCloudBaseRequestResult);
  var
    base64: string;
  begin
    if ARequestResult.Success then
    begin
      base64 := ABase64Audio;
      try
        asm
          var snd = new Audio("data:audio/mpeg;base64," + base64);
          snd.play();
        end;
      finally
      end;
    end;
  end;
  ```
  
  FMX:
  ```delphi
  procedure TForm1.DoTextToSpeech(Sender: TObject; const ABase64Audio: string;
    const ARequestResult: TTMSFNCCloudBaseRequestResult);
  var
    Encoder: TBase64Encoding;
    b: TBytesStream;
    bf: TBytes;
  begin
    if ARequestResult.Success then
    begin
      MediaPlayer1.Clear;
      Encoder := TBase64Encoding.Create;

      bf := Encoder.DecodeStringToBytes(ABase64Audio);
      b := TBytesStream.Create(bf);
      try
        b.SaveToFile('audio.mp3');
        MediaPlayer1.FileName := 'audio.mp3';
        MediaPlayer1.Play;
      finally
        Encoder.Free;
        b.Free;
      end;
    end;
  end;  
  ```
  
  </li>    
</ol>
