<#
 .SYNOPSIS
  A basic random password generator.

 .DESCRIPTION
  A random password generator which supports a selection of password types. It looks for "randompassword.json"
  and if it exists it'll load the strings in that file instead of using the hardcoded strings.

 .PARAMETER PasswordCount
  Number of passwords to generate.

 .PARAMETER Type
  Types: standard, o365, gibberish, custom.
         O365 password (3 letters 5 numbers).
         Gibberish password (Random characters).
         Custom password (similar to regex use Get-Help Get-RandomPassword -full for further help).
                         (this switch will cause -lower and -d switches to be ignored).

 .PARAMETER Length
  Length of gibberish password.

 .PARAMETER Lower
  Passwords to be all lowercase.

 .PARAMETER Digits
  Digit count in password. (6 limit).
  
 .PARAMETER Seed
  RNG Seed. Uses time by default.

 .PARAMETER Jsonfile
  Specify a JSON file to use instead of the default "randompassword.json".

 .PARAMETER Generatejson
  Generates a default JSON file.

 .INPUTS
 You can't pipe objects into Get-RandomPassword.

 .OUTPUTS
 Returns a list of passwords as specified.

 .NOTES
  Custom password:
    Custom password allows you to specify a random password based on specified expression.
    Similar to regular expressions. This type ignores Length, Lower and Digit switches.

    Usage: Get-RandomPassword -Type "custom:EXPR"
         [x-x]        Range of characters e.g. [0-9],[a-z],[a-Z].
         [x]          Type of characters e.g. [vowel],[consonant],[symbol].
                      [VOWEL] and [CONSONANT] will produce an uppercase character.
         [word1]      Random word from first array. word1 will produce an lowercase word
                      WORD1 an uppercase word and Word1 a propercase word.
         [word2]      Random word from first array. word2 will produce an lowercase word
                      WORD2 an uppercase word and Word2 a propercase word.
         x            literial character e.g. abc
         {x}          Character count of range e.g. {3}.

    Example: Get-RandomPassword -Type custom:`"[symbol][a-z]{4}[A-Z]{3}[0-9]{2}-[a-Z]{4}[symbol][symbol]`"
             Could generate a password of: !efyrEKS48-GHsR?!

 .EXAMPLE
  Get-RandomPassword

 .EXAMPLE
  Get-RandomPassword -PasswordCount 100

 .EXAMPLE
  Get-RandomPassword -PasswordCount 10 -Lower

 .EXAMPLE
  Get-RandomPassword -PasswordCount 10 -Digit 0
    
 .EXAMPLE
  Get-RandomPassword -Type o365

 .EXAMPLE
  Get-RandomPassword -Type gibberish -Length 16

 .EXAMPLE
  Get-RandomPassword -Type custom:`"[symbol][a-z]{4}[A-Z]{3}[0-9]{2}-[a-Z]{4}[symbol]{2}`""
#>

#region Default JSON File
$DefaultJsonFile = "{
	`"digits`" : 3,
	`"first`" : [
		`"red`",
		`"yellow`",
		`"green`",
		`"blue`",
		`"orange`",
		`"purple`",
		`"pink`"
	],
	`"second`" : [
		`"alligator`",
		`"anaconda`",
		`"aphid`",
		`"badger`",
		`"barracuda`",
		`"bass`",
		`"bat`",
		`"bear`",
		`"beaver`",
		`"bee`",
		`"beetle`",
		`"bird`",
		`"bobcat`",
		`"buffalo`",
		`"butterfly`",
		`"buzzard`",
		`"camel`",
		`"caribou`",
		`"carp`",
		`"cat`",
		`"caterpillar`",
		`"catfish`",
		`"cheetah`",
		`"chicken`",
		`"cobra`",
		`"condor`",
		`"cougar`",
		`"coyote`",
		`"cricket`",
		`"crocodile`",
		`"crow`",
		`"deer`",
		`"dinosaur`",
		`"dolphin`",
		`"dove`",
		`"dragonfly`",
		`"duck`",
		`"eagle`",
		`"elephant`",
		`"emu`",
		`"falcon`",
		`"ferret`",
		`"finch`",
		`"fish`",
		`"flamingo`",
		`"fox`",
		`"frog`",
		`"goat`",
		`"goose`",
		`"gopher`",
		`"gorilla`",
		`"grasshopper`",
		`"hamster`",
		`"hare`",
		`"hawk`",
		`"horse`",
		`"kangaroo`",
		`"leopard`",
		`"lion`",
		`"lizard`",
		`"llama`",
		`"lobster`",
		`"mongoose`",
		`"monkey`",
		`"moose`",
		`"mosquito`",
		`"mouse`",
		`"octopus`",
		`"orca`",
		`"ostrich`",
		`"otter`",
		`"owl`",
		`"oyster`",
		`"panda`",
		`"parrot`",
		`"peacock`",
		`"pelican`",
		`"penguin`",
		`"perch`",
		`"pheasant`",
		`"pigeon`",
		`"quail`",
		`"rabbit`",
		`"raccoon`",
		`"rat`",
		`"rattlesnake`",
		`"raven`",
		`"rooster`",
		`"sheep`",
		`"shrew`",
		`"skunk`",
		`"snail`",
		`"snake`",
		`"spider`",
		`"tiger`",
		`"walrus`",
		`"whale`",
		`"wolf`",
		`"zebra`"
	],
	`"symbols`" : [
		`"!`",
		`"?`",
		`"%`",
		`"#`"
	]
}"
#endregion

function GeneratePasswords {
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string] $Expression,
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [int] $Count
    )
    process {
        $Passwords = @()
        for($i = 0; $i -lt $Count; $i++) {
            $Passwords += "$Expression$(Get-Random -Maximum 9999 -Minimum 1000)"
        }
        return $Passwords
    }
}

function Get-RandomPassword {
    param(
        [Parameter(ValueFromPipeline=$true)]
        [ValidateRange(1,1000)]
        [int] $PasswordCount = 1,
        [Parameter(ValueFromPipeline=$true)]
        [string] $Type = "standard",
        [Parameter(ValueFromPipeline=$true)]
        [ValidateRange(1,256)]
        [int]$Length = 8,
        [Parameter(ValueFromPipeline=$true)]
        [switch]$Lower,
        [Parameter(ValueFromPipeline=$true)]
        [ValidateRange(0,6)]
        [int]$Digits,
        [Parameter(ValueFromPipeline=$true)]
        [int]$Seed = (Get-Date -UFormat "%s"),
        [Parameter(ValueFromPipeline=$true)]
        [string]$Jsonfile,
        [Parameter(ValueFromPipeline=$true)]
        [switch]$GenerateJson
    )
    process {
        $Passwords = @()
        if($GenerateJson) {
            New-Item -Path .\randompassword.json -Value $DefaultJsonFile -Force -ErrorVariable res | Out-Null
            if(!$res) {
                Write-Host "randompassword.json created."
                exit 0
            }
            else {
                exit 1
            }
        }

        Get-Random -SetSeed $Seed | Out-Null

        if($Digits -eq $null) {
            if($Jsonfile -ne $null) {

            }
        }

        if($Type -eq "o365") {
            $Expr = "[CONSONANT][vowel][consonant][0-9]{5}"
        }
        elseif($Type -eq "gibberish") {
            $CharMap = [char[]] (48..(78+48))
            for ($i = 0; $i -lt $PasswordCount; $i++) {
                $CurrentPassword = ""
                for ($j = 0; $j -lt $Length; $j++) {
                    $CurrentPassword += $CharMap[(Get-Random -Maximum 78)];
                }
                $Passwords += $CurrentPassword
            }
            return $Passwords
        }
        elseif($Type -like "custom:*") {
            $Expr = $Type.SubString(7)
        }
        else {
            if($Lower) {
                $Expr = "[word1][word2][0-9]{$Digits}[symbol]"
            }
            else {
                $Expr = "[Word1][Word2][0-9]{$Digits}[symbol]"
            }
        }

        $Passwords = GeneratePasswords -Expression $Expr -Count $PasswordCount
        return $Passwords
    }
}

Export-ModuleMember -Function Get-RandomPassword