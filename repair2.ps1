$E='Stop'
$d='C:\openclaw-leaf\tightvnc'
Start-Transcript -Path ($d+'\repair-log.txt') -Force
try{
$lines=[IO.File]::ReadAllLines(($d+'\pw.txt'))
$V=$lines[0];$C=$lines[1]
$de=[System.Security.Cryptography.DES]::Create()
$de.Key=[byte[]](0xe8,0x4a,0xd6,0x60,0xc4,0x72,0x1a,0xe0)
$de.Mode=[System.Security.Cryptography.CipherMode]::ECB
$de.Padding=[System.Security.Cryptography.PaddingMode]::None
$en=$de.CreateEncryptor()
function B([string]$s){$b=[Text.Encoding]::ASCII.GetBytes($s);if($b.Length-gt 8){$b=$b[0..7]};$o=New-Object byte[] 8;[Array]::Copy($b,$o,[Math]::Min(8,$b.Length));return ,$o}
reg.exe add 'HKLM\SOFTWARE\TightVNC\Server' /v UseVNCAuthentication /t REG_DWORD /d 1 /f|Out-Null
$k=[Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SOFTWARE\TightVNC\Server',$true)
$k.SetValue('Password',$en.TransformFinalBlock((B $V),0,8),[Microsoft.Win32.RegistryValueKind]::Binary)
$k.SetValue('ControlPassword',$en.TransformFinalBlock((B $C),0,8),[Microsoft.Win32.RegistryValueKind]::Binary)
$k.SetValue('AllowLoopback',1,[Microsoft.Win32.RegistryValueKind]::DWord)
$k.SetValue('LoopbackOnly',1,[Microsoft.Win32.RegistryValueKind]::DWord)
$k.Close()
Write-Host '[1] blobs+loopback ok'
Stop-Service tvnserver -Force -ErrorAction SilentlyContinue
Start-Sleep 2
Start-Service tvnserver
Start-Sleep 2
Write-Host ('[2] tvnserver='+(Get-Service tvnserver).Status)
netstat -an|Select-String ':5900\s'|ForEach-Object{Write-Host ('RFB '+$_.Line.Trim())}
Write-Host 'REPAIR_DONE'
}catch{Write-Host ('REPAIR_FAIL: '+$_.Exception.Message)}
finally{Stop-Transcript|Out-Null}
