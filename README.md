PSColor
=======

Provides color highlighting for some basic PowerShell output. It currently rewrites "Out-Default" to colorize:
* FileInfo & DirectoryInfo objects (Get-ChildItem, dir, ls etc.)
* ServiceController objects (Get-Service)
* MatchInfo objects (Select-String etc.)

## Installation

(TODO) Publish this thing in the Powershell Gallery with a jaunty name that doesn't conflict.

Alternativly, you can just git clone this repo in your user profile's powershell module directory.

## Configuration

(TODO) A theme switcher would be swell: something that starts with a blank theme that doesn't hammer a Get-ChildItem when simply importing the module.

If you want PSColor to be ran automatically you can add `Import-Module PSColor` to your PowerShell Profile. To locate your profile, run `$profile`.

After importing the module, run `Get-PSColorConfig` to load the builtin color theme. This will instance a file `PSColorTable.json` in the same directory as your PowerShell Profile.

The next time you import the module, or re-run `Get-PSColorConfig`, you will get your new colors loaded.

You can configure PSColor by overriding the values of colors, patterns etc.



## The PowerShell object $global:PSColor
```powershell
$global:PSColor = @{
    File = @{
        Default    = @{ Color = 'White' }
        Directory  = @{ Color = 'Cyan'}
        Hidden     = @{ Color = 'DarkGray'; Pattern = '^\.' } 
        Code       = @{ Color = 'Magenta'; Pattern = '\.(java|c|cpp|cs|js|css|html|py)$' }
        Executable = @{ Color = 'Red'; Pattern = '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg|msi)$' }
        Machine    = @{ Color = 'Blue'; Pattern = '\.(bin|dll|iso|img|ovf|ova)$' }
        Text       = @{ Color = 'Yellow'; Pattern = '\.(txt|cfg|conf|ini|csv|log|config|xml|yml|md|markdown)$' }
	Image      = @{ Color = 'DarkYellow'; Pattern = '\.(jpg|gif|bmp|jpeg|tif|tiff|png|psd)$' }
	Audio      = @{ Color = 'DarkBlue'; Pattern = '\.(mp3|aif|wav|wma|aif|iff|m4a)$' }
	Video      = @{ Color = 'DarkCyan'; Pattern = '\.(avi|mov|mpg|mp4|wmv|m4v)$' }
	Office     = @{ Color = 'DarkRed'; Pattern = '\.(xls|xlsx|xlsm|pdf|docx|doc|ppt|pptx|sdc|sdd|ott|odf|pub|rtf)$' }
        Compressed = @{ Color = 'Green'; Pattern = '\.(7z|zip|tar|gz|rar|jar|war)$' }
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
```

## The JSON object that instances after the first run:

```json
{
  "File": {
    "Machine": {
      "Pattern": "\\.(bin|dll|iso|img|ovf|ova)$",
      "Color": "Blue"
    },
    "Audio": {
      "Pattern": "\\.(mp3|aif|wav|wma|aif|iff|m4a)$",
      "Color": "DarkBlue"
    },
    "Default": {
      "Color": "White"
    },
    "Hidden": {
      "Pattern": "^\\.",
      "Color": "DarkGray"
    },
    "Compressed": {
      "Pattern": "\\.(7z|zip|tar|gz|rar|jar|war)$",
      "Color": "Green"
    },
    "Image": {
      "Pattern": "\\.(jpg|gif|bmp|jpeg|tif|tiff|png|psd|ico)$",
      "Color": "DarkYellow"
    },
    "Code": {
      "Pattern": "\\.(java|c|cpp|cs|js|css|html|py)$",
      "Color": "Magenta"
    },
    "Executable": {
      "Pattern": "\\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg|msi)$",
      "Color": "Red"
    },
    "Video": {
      "Pattern": "\\.(avi|mov|mpg|mp4|wmv|m4v)$",
      "Color": "DarkCyan"
    },
    "Office": {
      "Pattern": "\\.(xls|xlsx|xlsm|pdf|docx|doc|ppt|pptx|sdc|sdd|ott|odf|pub|rtf|vsd|vsdx)$",
      "Color": "DarkRed"
    },
    "Text": {
      "Pattern": "\\.(txt|cfg|conf|ini|csv|log|config|xml|yml|md|markdown)$",
      "Color": "Yellow"
    },
    "Directory": {
      "Color": "Cyan"
    }
  },
  "NoMatch": {
    "LineNumber": {
      "Color": "Yellow"
    },
    "Line": {
      "Color": "White"
    },
    "Default": {
      "Color": "White"
    },
    "Path": {
      "Color": "Cyan"
    }
  },
  "Match": {
    "LineNumber": {
      "Color": "Yellow"
    },
    "Line": {
      "Color": "White"
    },
    "Default": {
      "Color": "White"
    },
    "Path": {
      "Color": "Cyan"
    }
  },
  "Service": {
    "Running": {
      "Color": "DarkGreen"
    },
    "Default": {
      "Color": "White"
    },
    "Stopped": {
      "Color": "DarkRed"
    }
  }
}
```
