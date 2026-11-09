$log='C:\openclaw-leaf\tightvnc\scan2-log.txt'
Set-Content -Path $log -Value 'SCAN2_START'
Get-ChildItem 'C:\Users\yexiuli' -Directory -Force -ErrorAction SilentlyContinue | ForEach-Object {
  $s=(Get-ChildItem $_.FullName -Recurse -File -Force -ErrorAction SilentlyContinue|Measure-Object Length -Sum).Sum/1GB
  Add-Content -Path $log -Value ('{0,9:N1}GB {1}' -f $s,$_.Name)
}
Add-Content -Path $log -Value '--APPDATA.LOCAL--'
Get-ChildItem 'C:\Users\yexiuli\AppData\Local' -Directory -Force -ErrorAction SilentlyContinue | ForEach-Object {
  $s=(Get-ChildItem $_.FullName -Recurse -File -Force -ErrorAction SilentlyContinue|Measure-Object Length -Sum).Sum/1GB
  if($s -ge 0.5){ Add-Content -Path $log -Value ('{0,9:N1}GB AppData\Local\{1}' -f $s,$_.Name) }
}
Add-Content -Path $log -Value 'SCAN2_DONE'
