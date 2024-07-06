<#
 .SYNOPSIS
  A basic random password generator.

 .DESCRIPTION
  A random password generator which supports a selection of password types. It looks for "randompassword.json"
  and if it exists it'll load the strings in that file instead of using the hardcoded strings.

 .PARAMETER Count
  Number of passwords to generate.

 .PARAMETER Type
  Types: standard, o365, gibberish, custom.
         O365 password (3 letters 5 numbers).
         Gibberish password (Random characters).
         Custom password (similar to regex use Get-Help Get-RandomPassword -full for further help).
         Additional types can be specified in the JSON

 .PARAMETER Length
  Length of gibberish password.

 .PARAMETER Lower
  Passwords to be all lowercase.

 .PARAMETER Upper
  Passwords to be all uppercase.

 .PARAMETER Digits
  Digit count in password. (100 limit).
  
 .PARAMETER Seed
  RNG Seed. Uses time by default.

 .PARAMETER JsonFile
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
         [random]     A random character.
         x            literial character e.g. abc
         {x}          Character count of range e.g. {3}.
         {digits}     Character count set to digits value in JSON or if specified with -Digits.
         {length}     Character count set to length specified with -Length.

    Example: Get-RandomPassword -Type custom:`"[symbol][a-z]{4}[A-Z]{3}[0-9]{2}-[a-Z]{4}[symbol][symbol]`"
             Could generate a password of: !efyrEKS48-GHsR?!

 .EXAMPLE
  Get-RandomPassword

 .EXAMPLE
  Get-RandomPassword -Count 100

 .EXAMPLE
  Get-RandomPassword -Count 10 -Lower

 .EXAMPLE
  Get-RandomPassword -Count 10 -Digit 0
    
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
        `"accidentally`",
        `"accordingly`",
        `"additionally`",
        `"after`",
        `"afterwards`",
        `"almost`",
        `"already`",
        `"also`",
        `"always`",
        `"anyway`",
        `"besides`",
        `"certainly`",
        `"cheerfully`",
        `"conversely`",
        `"daily`",
        `"eagerly`",
        `"early`",
        `"easily`",
        `"enough`",
        `"especially`",
        `"ever`",
        `"exceptionally`",
        `"extremely`",
        `"far`",
        `"fast`",
        `"finally`",
        `"foolishly`",
        `"frequently`",
        `"fully`",
        `"generally`",
        `"generously`",
        `"hence`",
        `"however`",
        `"hungrily`",
        `"instead`",
        `"just`",
        `"kindly`",
        `"last`",
        `"late`",
        `"lately`",
        `"later`",
        `"likewise`",
        `"loudly`",
        `"moreover`",
        `"most`",
        `"much`",
        `"namely`",
        `"nearly`",
        `"neatly`",
        `"never`",
        `"nevertheless`",
        `"next`",
        `"normally`",
        `"now`",
        `"occasionally`",
        `"often`",
        `"once`",
        `"previously`",
        `"proudly`",
        `"quickly`",
        `"rapidly`",
        `"rarely`",
        `"really`",
        `"seldom`",
        `"since`",
        `"slightly`",
        `"sometimes`",
        `"somewhat`",
        `"still`",
        `"strangely`",
        `"suspiciously`",
        `"then`",
        `"today`",
        `"tomorrow`",
        `"tonight`",
        `"twice`",
        `"usually`",
        `"very`",
        `"virtually`",
        `"well`",
        `"yesterday`"
    ],
    `"second`" : [
        `"adventurous`",
        `"alert`",
        `"alive`",
        `"amused`",
        `"angry`",
        `"better`",
        `"bewildered`",
        `"blue`",
        `"brave`",
        `"breakable`",
        `"bright`",
        `"busy`",
        `"calm`",
        `"careful`",
        `"cautious`",
        `"cheerful`",
        `"clear`",
        `"cloudy`",
        `"colorful`",
        `"comfortable`",
        `"cooperative`",
        `"crowded`",
        `"curious`",
        `"dark`",
        `"different`",
        `"difficult`",
        `"distinct`",
        `"eager`",
        `"easy`",
        `"elated`",
        `"elegant`",
        `"encouraging`",
        `"energetic`",
        `"enthusiastic`",
        `"expensive`",
        `"famous`",
        `"fantastic`",
        `"fierce`",
        `"fragile`",
        `"frantic`",
        `"friendly`",
        `"frightened`",
        `"funny`",
        `"gentle`",
        `"gifted`",
        `"gleaming`",
        `"glorious`",
        `"good`",
        `"graceful`",
        `"happy`",
        `"hilarious`",
        `"important`",
        `"impossible`",
        `"inexpensive`",
        `"inquisitive`",
        `"jolly`",
        `"joyous`",
        `"kind`",
        `"light`",
        `"lively`",
        `"long`",
        `"lucky`",
        `"magnificent`",
        `"misty`",
        `"modern`",
        `"mysterious`",
        `"nice`",
        `"outrageous`",
        `"outstanding`",
        `"perfect`",
        `"plain`",
        `"pleasant`",
        `"poised`",
        `"powerful`",
        `"precious`",
        `"proud`",
        `"puzzled`",
        `"quaint`",
        `"real`",
        `"relieved`",
        `"rich`",
        `"scary`",
        `"sparkling`",
        `"splendid`",
        `"spotless`",
        `"stormy`",
        `"strange`",
        `"successful`",
        `"super`",
        `"talented`",
        `"tough`",
        `"vast`",
        `"victorious`",
        `"wandering`"
    ],
    `"symbols`" : [
        `"!`",
        `"?`",
        `"%`",
        `"#`",
        `"(`",
        `")`",
        `"^`"
    ],
    `"passwordtypes`" : [
        {`"standard`" : `"[Word1][Word2][0-9]{3}[symbol]`"},
        {`"o365`" : `"[CONSONANT][vowel][consonant][0-9]{5}`"},
        {`"gibberish`" : `"[random]{length}`"}
    ]
}"
#endregion

$global:JsonTables = $null

function LoadJsonData {
    param(
        [string] $JsonData,
        [string] $JsonFile
    )
    process {
        $JsonTablesLoad = $null

        if(($null -eq $JsonData -or $JsonData -eq "") -and $null -ne $JsonFile) {
            $JsonTablesLoad = (Get-Content -Path $JsonFile | ConvertFrom-Json)
        }
        elseif($null -ne $JsonData) {
            $JsonTablesLoad = ($JsonData | ConvertFrom-Json)
        }

        return $JsonTablesLoad
    }
}

function GeneratePasswords {
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string] $Expression,
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [int] $Count,
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [int] $Length,
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [int] $Digits
    )
    process {
        try {
            $Passwords = @()
            $Elements = @()
            $ExprOffset = 0

            while($ExprOffset -lt $Expression.Length) {
                $Offset = $Expression.IndexOf("[", $ExprOffset)
                [int]$ElementCount = 1
                if($Offset -ne -1) {
                    if(($Offset - $ExprOffset) -gt 0) {
                        $Token = $Expression.SubString($ExprOffset, $Offset - $ExprOffset)
                        if($Token.Contains("{") -and $Token.Contains("}")) {
                            $ElementCountCheck = $Token.Substring($Token.IndexOf("{") + 1, $Token.IndexOf("}") - ($Token.IndexOf("{") + 1))
                            if($ElementCountCheck -eq "length") {
                                $ElementCount = $Length
                            }
                            elseif($ElementCountCheck -eq "digits") {
                                $ElementCount = $Digits
                            }
                            elseif($ElementCountCheck -match "^\d+$") {
                                $ElementCount = [int]$ElementCountCheck
                            }
                            $Token = $Token.Substring(0, $Token.IndexOf("{"))
                            $ExprOffset = $Expression.IndexOf("}", $ExprOffset) + 1
                        }
                        else {
                            $ExprOffset += $Token.Length
                        }
                        $Elements += [PSCustomObject]@{
                            Type = "LITERIAL"
                            Token = $Token
                            Case = "NA"
                            Count = $ElementCount
                        }
                    }
                    
                    $ExprOffset = $Offset + 1
                    $Offset = $Expression.IndexOf("]", $ExprOffset)
                    if($Offset -ne -1) {
                        [string]$ElementValue = $Expression.SubString($ExprOffset, $Offset - $ExprOffset)
                        if(($Offset + 1) -lt $Expression.Length -and $Expression.SubString($Offset + 1, 1) -eq "{") {
                            if($Expression.IndexOf("}", $ExprOffset) -ne -1) {
                                $ElementCountCheck = $Expression.SubString($Offset + 2, $Expression.IndexOf("}", $ExprOffset) - ($Offset + 2))
                                if($ElementCountCheck -eq "length") {
                                    $ElementCount = $Length
                                }
                                elseif($ElementCountCheck -eq "digits") {
                                    $ElementCount = $Digits
                                }
                                elseif($ElementCountCheck -match "^\d+$") {
                                    $ElementCount = [int]$ElementCountCheck
                                }
                                $ExprOffset = $Expression.IndexOf("}", $ExprOffset) + 1
                            }
                        }
                        else {
                            $ExprOffset = $Offset + 1
                        }

                        if($ElementValue -ceq "vowel") {
                            $Elements += [PSCustomObject]@{
                                Type = "VOWEL"
                                Token = $null
                                Case = "LOWER"
                                Count = $ElementCount
                            }
                        }
                        elseif($ElementValue -ceq "VOWEL") {
                            $Elements += [PSCustomObject]@{
                                Type = "VOWEL"
                                Token = $null
                                Case = "UPPER"
                                Count = $ElementCount
                            }
                        }
                        elseif($ElementValue -ceq "consonant") {
                            $Elements += [PSCustomObject]@{
                                Type = "CONSONANT"
                                Token = $null
                                Case = "LOWER"
                                Count = $ElementCount
                            }
                        }
                        elseif($ElementValue -ceq "CONSONANT") {
                            $Elements += [PSCustomObject]@{
                                Type = "CONSONANT"
                                Token = $null
                                Case = "UPPER"
                                Count = $ElementCount
                            }
                        }
                        elseif($ElementValue -eq "symbol") {
                            $Elements += [PSCustomObject]@{
                                Type = "SYMBOL"
                                Token = $null
                                Case = "NA"
                                Count = $ElementCount
                            }
                        }
                        elseif($ElementValue -eq "random") {
                            $Elements += [PSCustomObject]@{
                                Type = "RANDOM"
                                Token = $null
                                Case = "NA"
                                Count = $ElementCount
                            }
                        }
                        elseif($ElementValue -ceq "word1") {
                            $Elements += [PSCustomObject]@{
                                Type = "WORD1"
                                Token = $null
                                Case = "LOWER"
                                Count = $ElementCount
                            }
                        }
                        elseif($ElementValue -ceq "Word1") {
                            $Elements += [PSCustomObject]@{
                                Type = "WORD1"
                                Token = $null
                                Case = "PROPER"
                                Count = $ElementCount
                            }
                        }
                        elseif($ElementValue -ceq "WORD1") {
                            $Elements += [PSCustomObject]@{
                                Type = "WORD1"
                                Token = $null
                                Case = "UPPER"
                                Count = $ElementCount
                            }
                        }
                        elseif($ElementValue -ceq "word2") {
                            $Elements += [PSCustomObject]@{
                                Type = "WORD2"
                                Token = $null
                                Case = "LOWER"
                                Count = $ElementCount
                            }
                        }
                        elseif($ElementValue -ceq "Word2") {
                            $Elements += [PSCustomObject]@{
                                Type = "WORD2"
                                Token = $null
                                Case = "PROPER"
                                Count = $ElementCount
                            }
                        }
                        elseif($ElementValue -ceq "WORD2") {
                            $Elements += [PSCustomObject]@{
                                Type = "WORD2"
                                Token = $null
                                Case = "UPPER"
                                Count = $ElementCount
                            }
                        }
                        else {
                            if($ElementValue.IndexOf("-") -ne -1) {
                                if($ElementValue[0] -cmatch "[A-z]") {
                                    $Elements += [PSCustomObject]@{
                                        Type = "ALPHA"
                                        Token = $ElementValue
                                        Case = "NA"
                                        Count = $ElementCount
                                    }
                                }
                                elseif($ElementValue[0] -cmatch "[0-9]") {
                                    $Elements += [PSCustomObject]@{
                                        Type = "NUMERIC"
                                        Token = $ElementValue
                                        Case = "NA"
                                        Count = $ElementCount
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    $Token = $Expression.SubString($ExprOffset, $Expression.Length - $ExprOffset)
                    if($Token.Contains("{") -and $Token.Contains("}")) {
                        $ElementCountCheck = $Token.Substring($Token.IndexOf("{") + 1, $Token.IndexOf("}") - ($Token.IndexOf("{") + 1))
                        if($ElementCountCheck -eq "length") {
                            $ElementCount = $Length
                        }
                        elseif($ElementCountCheck -eq "digits") {
                            $ElementCount = $Digits
                        }
                        elseif($ElementCountCheck -match "^\d+$") {
                            $ElementCount = [int]$ElementCountCheck
                        }
                        $Token = $Token.Substring(0, $Token.IndexOf("{"))
                        $ExprOffset = $Expression.IndexOf("}", $ExprOffset) + 1
                    }
                    else {
                        $ExprOffset += $Token.Length
                    }
                    $Elements += [PSCustomObject]@{
                        Type = "LITERIAL"
                        Token = $Token
                        Case = "NA"
                        Count = $ElementCount
                    }
                }
            }

            for($i = 0; $i -lt $Count; $i++) {
                $Password = ""
                foreach($Element in $Elements) {
                    switch ($Element.Type) {
                        "ALPHA" {
                            $Alpha = @('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z')
                            $Tokens = $Element.Token.Split("-")
                            if($Tokens.Count -eq 2) {
                                [int]$Offset1 = $Alpha.IndexOf([string]$Tokens[0][0])
                                [int]$Offset2 = $Alpha.IndexOf([string]$Tokens[1][0])
                                if($Offset1 -ne -1 -and $Offset2 -ne -1 -and $Offset1 -lt $Offset2) {
                                    for($j = 0; $j -lt $Element.Count; $j++) {
                                        $Password += $Alpha[(Get-Random -Minimum $Offset1 -Maximum $Offset2)]
                                    }
                                }
                                else {
                                    Write-Host "Alpha value: $($Element.Token) invalid. Ensure first alpha is lower in alphabetical and case order than the second alpha." -ForegroundColor Red
                                    Exit 1
                                }
                            }
                        }
                        "NUMERIC" {
                            $Tokens = $Element.Token.Split("-")
                            if($Tokens.Count -eq 2 -and $Tokens[0][0] -cmatch "[0-9]" -and $Tokens[1][0] -cmatch "[0-9]") {
                                [int]$FromValue = [int]$Tokens[0][0].ToString()
                                [int]$ToValue = [int]$Tokens[1][0].ToString() + 1
                                if($FromValue -lt $ToValue) {
                                    for($j = 0; $j -lt $Element.Count; $j++) {
                                        $Password += (Get-Random -Minimum $FromValue -Maximum $ToValue).ToString()
                                    }
                                }
                            }
                        }
                        "VOWEL" {
                            $Vowels = @('a', 'e', 'i', 'o', 'u')
                            for($j = 0; $j -lt $Element.Count; $j++) {
                                switch($Element.Case) {
                                    "UPPER" { $Password += $Vowels[(Get-Random -Maximum $Vowels.Count)].ToUpper() }
                                    default { $Password += $Vowels[(Get-Random -Maximum $Vowels.Count)] }
                                }
                            }
                        }
                        "CONSONANT" {
                            $Consonants = @('b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'y', 'z')

                            for($j = 0; $j -lt $Element.Count; $j++) {
                                switch($Element.Case) {
                                    "UPPER" { $Password += $Consonants[(Get-Random -Maximum $Consonants.Count)].ToUpper() }
                                    default { $Password += $Consonants[(Get-Random -Maximum $Consonants.Count)] }
                                }
                            }
                        }
                        "SYMBOL" {
                            for($j = 0; $j -lt $Element.Count; $j++) {
                                $Password += $global:JsonTables.symbols[(Get-Random -Maximum $global:JsonTables.symbols.Count)]
                            }
                        }
                        "LITERIAL" {
                            for($j = 0; $j -lt $Element.Count; $j++) {
                                $Password += $Element.Token
                            }
                        }
                        "RANDOM" {
                            $CharMap = [char[]] (48..(78+48))
                            for($j = 0; $j -lt $Element.Count; $j++) {
                                $Password += $CharMap[(Get-Random -Maximum 78)]
                            }
                        }
                        "WORD1" {
                            for($j = 0; $j -lt $Element.Count; $j++) {
                                $Word = ""
                                switch ($Element.Case) {
                                    "LOWER" {
                                        $Word = $global:JsonTables.first[(Get-Random -Maximum $global:JsonTables.first.Count)].ToLower()
                                    }
                                    "UPPER" {
                                        $Word = $global:JsonTables.first[(Get-Random -Maximum $global:JsonTables.first.Count)].ToUpper()
                                    }
                                    "PROPER" {
                                        $Word = ((Get-Culture).TextInfo).ToTitleCase($global:JsonTables.first[(Get-Random -Maximum $global:JsonTables.first.Count)])
                                    }
                                    default {
                                        $Word = $global:JsonTables.first[(Get-Random -Maximum $global:JsonTables.first.Count)]
                                    }
                                }
                                $Password += $Word
                            }
                        }
                        "WORD2" {
                            for($j = 0; $j -lt $Element.Count; $j++) {
                                $Word = ""
                                switch ($Element.Case) {
                                    "LOWER" {
                                        $Word = $global:JsonTables.second[(Get-Random -Maximum $global:JsonTables.second.Count)].ToLower()
                                    }
                                    "UPPER" {
                                        $Word = $global:JsonTables.second[(Get-Random -Maximum $global:JsonTables.second.Count)].ToUpper()
                                    }
                                    "PROPER" {
                                        $Word = ((Get-Culture).TextInfo).ToTitleCase($global:JsonTables.second[(Get-Random -Maximum $global:JsonTables.second.Count)])
                                    }
                                    default {
                                        $Word = $global:JsonTables.second[(Get-Random -Maximum $global:JsonTables.second.Count)]
                                    }
                                }
                                $Password += $Word
                            }
                        }
                        default {
                            for($j = 0; $j -lt $Element.Count; $j++) {
                                $Password += "?"
                            }
                        }
                    }
                }
                $Passwords += $Password
            }
            return $Passwords
        }
        catch {
            $e = $_.Exception
            $line = $_.InvocationInfo.ScriptLineNumber
            Write-Host -ForegroundColor Red "caught exception: $e at $line"
        }
    }
}

function Get-RandomPassword {
    param(
        [ValidateRange(1,1000)]
        [int] $Count = 1,
        [string] $Type = "none",
        [ValidateRange(1,256)]
        [int]$Length = 8,
        [switch]$Lower,
        [switch]$Upper,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateRange(0,100)]
        [int]$Digits = -1,
        [int]$Seed = (Get-Date -UFormat "%s"),
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [string]$JsonFile,
        [switch]$GenerateJson
    )
    process {
        $Passwords = @()
        if($Lower -and $Upper) {
            Write-Host "You can only use either -Lower or -Upper. Not both." -ForegroundColor Red
            exit 1
        }

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

        if($JsonFile -ne "") {
            if(Test-Path -Path $JsonFile) {
                $global:JsonTables = LoadJsonData -JsonFile $JsonFile
            }
            else {
                Write-Host "Unable to load $JsonFile" -ForegroundColor Red
                exit 1
            }
        }
        else {
            if(Test-Path -Path "$((Get-Location).Path)\randompassword.json") {
                $global:JsonTables = LoadJsonData -JsonFile "$((Get-Location).Path)\randompassword.json"
            }
            else {
                $global:JsonTables = LoadJsonData -JsonData $DefaultJsonFile
            }
        }

        if(($null -eq $global:JsonTables.digits) -or
            ($null -eq $global:JsonTables.first) -or
            ($null -eq $global:JsonTables.second) -or
            ($null -eq $global:JsonTables.symbols)) {
            Write-Host "Malformed JSON file." -ForegroundColor Red
            exit 1
        }

        Get-Random -SetSeed $Seed | Out-Null

        if($Digits -ne -1) {
            $global:JsonTables.digits = $Digits
        }

        if($Type -like "custom:*") {
            $Expr = $Type.SubString(7)
        }
        elseif($null -ne $global:JsonTables.passwordtypes -and
              ($global:JsonTables.passwordtypes | Where-Object {$null -ne $_.$Type}).Count -ne 0) {
            $Expr = $global:JsonTables.passwordtypes.$Type | Where-Object {$null -ne $_}
            if($Lower) {
                $Expr = $Expr.ToLower()
            }
            elseif($Upper) {
                $Expr = $Expr.ToUpper()
            }
        }
        else {
            if($Lower) {
                $Expr = "[word1][word2][0-9]{$($global:JsonTables.digits)}[symbol]"
            }
            elseif($Upper) {
                $Expr = "[WORD1][WORD2][0-9]{$($global:JsonTables.digits)}[symbol]"
            }
            else {
                $Expr = "[Word1][Word2][0-9]{$($global:JsonTables.digits)}[symbol]"
            }
        }

        $Passwords = GeneratePasswords -Expression $Expr -Count $Count -Length $Length -Digits $global:JsonTables.digits
        return $Passwords
    }
}

Export-ModuleMember -Function Get-RandomPassword