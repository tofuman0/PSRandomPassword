Random Password Power Shell Module
----------------------------------

A powershell module for generating random passwords<br />
<br />
It looks for "randompassword.json" in the same folder and if it exists it'll load the strings in that file instead of using<br />
the hardcoded strings.<br />
<br />
basic json file structure:<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;"digits" : 3,<br />
&nbsp;&nbsp;&nbsp;&nbsp;"first" : [<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"firstwords",<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"..."<br />
&nbsp;&nbsp;&nbsp;&nbsp;],<br />
&nbsp;&nbsp;&nbsp;&nbsp;"second" : [<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"secondwords",<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"..."<br />
&nbsp;&nbsp;&nbsp;&nbsp;],<br />
&nbsp;&nbsp;&nbsp;&nbsp;"symbols" : [<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"!",<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"?",<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"%",<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"#"<br />
&nbsp;&nbsp;&nbsp;&nbsp;]<br />
&nbsp;&nbsp;&nbsp;&nbsp;"passwordtypes" : [<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{"standard" : "[Word1][Word2][0-9]{3}[symbol]"},<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{"o365" : "[CONSONANT][vowel][consonant][0-9]{5}"},<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{"gibberish" : "[random]{length}"}<br />
&nbsp;&nbsp;&nbsp;&nbsp;]<br />
}<br />
````CommandLine
Usage: Get-RandomPassword [-Count count] [-Seed seed] [-JsonFile jsonfile] [[-Type type] [-Length length] | [[-Lower] | [-Upper]] [-Digits count] | [-GenerateJson]]

Options:
    -Count count      Number of passwords to generate.
    -Type type        Types: standard, o365, gibberish, custom.
                      O365 password (3 letters 5 numbers).
                      Gibberish password (Random characters).
                      Custom password (similar to regex use Get-Help Get-RandomPassword -full for further help).
                      (Custom types can be added/removed/edited in a JSON file by generating a JSON file using
                      -GenerateJson).
    -Length length    Length of gibberish password and the Length variable used in {length}.
    -Lower            Passwords to be all lowercase.
    -Upper            Passwords to be all uppercase.
    -Digits count     Digit count in password. (100 limit).
    -Seed seed        RNG Seed. Uses time by default.
    -JsonFile file    Specify a JSON file to use instead of the default "randompassword.json".
    -GenerateJson     Generates a default JSON file.

Custom password:
    Custom password allows you to specify a random password based on specified expression.
    Similar to regular expressions.

    Usage: Get-RandomPassword -Type custom "EXPR"
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

    Example: Get-RandomPassword -Type custom:"[symbol][a-z]{4}[A-Z]{3}[0-9]{2}-[a-Z]{4}[symbol][symbol]"
             Could generate a password of: !efyrEKS48-GHsR?!
````
Example:<br />
Return 1 password:<br />
&nbsp;&nbsp;&nbsp;&nbsp;Get-RandomPassword<br />
<br />
Return 100 passwords:<br />
&nbsp;&nbsp;&nbsp;&nbsp;Get-RandomPassword -Count 100<br />
&nbsp;&nbsp;&nbsp;&nbsp;<br />
Return 10 passwords in lowercase:<br />
&nbsp;&nbsp;&nbsp;&nbsp;Get-RandomPassword -Count 10 -Lower<br />
&nbsp;&nbsp;&nbsp;&nbsp;<br />
Return 10 passwords with no digits:<br />
&nbsp;&nbsp;&nbsp;&nbsp;Get-RandomPassword -Count 10 -Digits 0<br />
&nbsp;&nbsp;&nbsp;&nbsp;<br />
Return office 365 password format:<br />
&nbsp;&nbsp;&nbsp;&nbsp;Get-RandomPassword -Type o365<br />
&nbsp;&nbsp;&nbsp;&nbsp;<br />
Return gibberish password 16 in length:<br />
&nbsp;&nbsp;&nbsp;&nbsp;Get-RandomPassword -Type gibberish -Length 16<br />
