
Add-Type -assemblyname System.ServiceProcess

. "$PSScriptRoot\PSColorHelper.ps1"
. "$PSScriptRoot\FileInfo.ps1"
. "$PSScriptRoot\ServiceController.ps1"
. "$PSScriptRoot\MatchInfo.ps1"
. "$PSScriptRoot\ProcessInfo.ps1"



Function Get-PSColorConfig {
    [CmdletBinding()]
    Param()
    #generate path to json color defition file
    $PSColorTablePath = Join-Path -Path (Get-ChildItem $profile.CurrentUserCurrentHost).DirectoryName -Childpath PSColorTable.json

    #if the file doesn't exist, generate a template config objcet
    if (!(Test-Path $PSColorTablePath)) {
        $global:PSColor = @{
            File = @{
                Default    = @{ Color = 'White' }
                Directory  = @{ Color = 'Cyan'}
                Hidden     = @{ Color = 'DarkGray'; Pattern = '^\.' } 
                Code       = @{ Color = 'Magenta'; Pattern = '\.(java|c|cpp|cs|js|css|html|py)$' }
                Executable = @{ Color = 'Red'; Pattern = '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg|msi)$' }
                Machine    = @{ Color = 'Blue'; Pattern = '\.(bin|dll|iso|img|ovf|ova)$' }
                Text       = @{ Color = 'Yellow'; Pattern = '\.(txt|cfg|conf|ini|csv|log|config|xml|yml|md|markdown)$' }
                Image      = @{ Color = 'DarkYellow'; Pattern = '\.(jpg|gif|bmp|jpeg|tif|tiff|png|psd|ico)$' }
                Audio      = @{ Color = 'DarkBlue'; Pattern = '\.(mp3|aif|wav|wma|aif|iff|m4a)$' }
                Video      = @{ Color = 'DarkCyan'; Pattern = '\.(avi|mov|mpg|mp4|wmv|m4v)$' }
                Office     = @{ Color = 'DarkRed'; Pattern = '\.(xls|xlsx|xlsm|pdf|docx|doc|ppt|pptx|sdc|sdd|ott|odf|pub|rtf|vsd|vsdx)$' }
                Compressed = @{ Color = 'Green'; Pattern = '\.(7z|zip|tar|gz|rar|jar|war)$' }
                Temporary  = @{ Color = 'Red'; Pattern = '\.(tmp|old|foo|baz|bak)$' }
            }
            Service = @{
                Default = @{ Color = 'White' }
                Running = @{ Color = 'DarkGreen' }
                Stopped = @{ Color = 'DarkRed' }     
            }
            Match = @{
                Default    = @{ Color = 'White' }
                Path       = @{ Color = 'Cyan'}
                LineNumber = @{ Color = 'Yellow' }
                Line       = @{ Color = 'White' }
            }
            NoMatch = @{
                Default    = @{ Color = 'White' }
                Path       = @{ Color = 'Cyan'}
                LineNumber = @{ Color = 'Yellow' }
                Line       = @{ Color = 'White' }
            }
        }
        Write-Warning ("PSColorTable definition file not found at " + $PSColorTablePath + "`r`nCreating default configuration file.`r`nThis only happens if the file doesn't previously exist.")
        $global:PSColor | ConvertTo-Json | Out-File $PSColorTablePath
    }
    else {
        if ($global:PSColor) {
            Write-Verbose "Overwriting PSColor global variable"
            $OMP = get-module -ListAvailable | ?{$_.Name -match "oh-my-posh"}
            if ($OMP) {
                Write-Verbose "oh-my-posh detected, which instances it's own PSColor preference dictionary"
                Write-Verbose "This should work, but check for compatibility if you experience weirdness."
            }
        }
        $global:PSColor = @{}
        Write-Verbose "Loaded PSColors"
        (Get-Content $PSColorTablePath | ConvertFrom-Json).psobject.properties | ForEach-Object { $global:PSColor[$_.Name] = $_.Value }
    }
}



$script:showHeader=$true

function Out-Default {
    [CmdletBinding(HelpUri='http://go.microsoft.com/fwlink/?LinkID=113362', RemotingCapability='None')]
    param(
        [switch]
        ${Transcript},

        [Parameter(Position=0, ValueFromPipeline=$true)]
        [psobject]
        ${InputObject})

    begin
    {
        try {
            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
            {
                $PSBoundParameters['OutBuffer'] = 1
            }
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Core\Out-Default', [System.Management.Automation.CommandTypes]::Cmdlet)
            $scriptCmd = {& $wrappedCmd @PSBoundParameters }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline()
            $steppablePipeline.Begin($PSCmdlet)
        } catch {
            throw
        }
    }

    process
    {
        try {
            if(($_ -is [System.IO.DirectoryInfo]) -or ($_ -is [System.IO.FileInfo]))
            {
                FileInfo $_
                $_ = $null
            }

            elseif($_ -is [System.ServiceProcess.ServiceController])
            {
                ServiceController $_
                $_ = $null
            }

            elseif($_ -is [Microsoft.Powershell.Commands.MatchInfo])
            {
                MatchInfo $_
                $_ = $null
            }
            else {
                $steppablePipeline.Process($_)
            }
        } catch {
            throw
        }
    }

    end
    {
        try {
            write-host ""
            $script:showHeader=$true
            $steppablePipeline.End()
        } catch {
            throw
        }
    }
    <#

    .ForwardHelpTargetName Out-Default
    .ForwardHelpCategory Function

    #>
}

Export-ModuleMember Out-Default
Export-ModuleMember Get-PSColorConfig
