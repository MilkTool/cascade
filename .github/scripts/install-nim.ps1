param(
  [parameter(mandatory)]
  [string] $nimVersion
)

set-strictMode -version 3
$ErrorActionPreference = 'Stop'

if (-not $isWindows) {
  $initPath = join-path $home "init.sh"

  $request = @{
    uri     = "https://nim-lang.org/choosenim/init.sh"
    outFile = $initPath
  }

  invoke-webrequest @request

  $env:CHOOSENIM_CHOOSE_VERSION = $nimVersion
  sh $initPath -y

  remove-item $initPath | out-null
} else {
  # TODO: use choosenim on Windows once x64 is supported
  # https://github.com/dom96/choosenim/issues/128

  $packageName = "nim-1.0.0"
  $zipPath = join-path (join-path $home ".gradle") "nim.zip"

  $request = @{
    uri     = "https://nim-lang.org/download/${packageName}_x64.zip"
    outFile = $zipPath
  }

  invoke-webrequest @request

  $extractDir = split-path $zipPath -parent
  expand-archive $zipPath -destinationPath $extractDir

  join-path $extractDir $packageName | set-location

  & .\finish
}
