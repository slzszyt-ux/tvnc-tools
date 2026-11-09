$log='C:\openclaw-leaf\tightvnc\scan-log.txt'
Set-Content -Path $log -Value 'SCAN_START'
Get-CimInstance Win32_PageFileUsage | ForEach-Object { Add-Content -Path $log -Value ('PAGEFILE '+$_.Name+' '+$_.AllocatedBaseSize+'MB') }
$dirs=@(
'C:\Users\yexiuli\.ollama',
'C:\Users\yexiuli\AppData\Local\npm-cache',
'C:\Users\yexiuli\AppData\Local\nvm',
'C:\nvm4w',
'C:\Users\yexiuli\Downloads',
'C:\Users\yexiuli\AppData\Local\Temp',
'C:\Users\yexiuli\AppData\Local\Docker',
'C:\Users\yexiuli\.trae',
'C:\Users\yexiuli\AppData\Local\Trae',
'C:\Users',
'C:\Windows',
'C:\Program Files',
'C:\Program Files (x86)',
'C:\ProgramData')
foreach($x in $dirs){
  if(Test-Path $x){
    $s=(Get-ChildItem $x -Recurse -File -Force -ErrorAction SilentlyContinue|Measure-Object Length -Sum).Sum/1GB
    Add-Content -Path $log -Value ('{0,9:N1}GB {1}' -f $s,$x)
  } else {
    Add-Content -Path $log -Value ('   SKIP '+$x)
  }
}
Add-Content -Path $log -Value 'SCAN_DONE'
