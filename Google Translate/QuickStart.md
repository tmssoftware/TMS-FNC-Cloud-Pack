```delphi
  if not TDirectory.Exists(targetpath + 'Google Vision\') then
    TDirectory.CreateDirectory(targetpath + 'Google Vision\');

  if not TDirectory.Exists(targetpath + 'Google Text To Speech\') then
    TDirectory.CreateDirectory(targetpath + 'Google Text To Speech\');

  if not TDirectory.Exists(targetpath + 'Google Translate\') then
    TDirectory.CreateDirectory(targetpath + 'Google Translate\');
```
