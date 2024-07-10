# Module manifest for module 'RandomPassword'
# Generated by: Danny Worth

@{
# Script module or binary module file associated with this manifest.
RootModule = 'PSRandomPassword.psm1'

# Version number of this module.
ModuleVersion = '1.0.3'

# ID used to uniquely identify this module
GUID = 'f16dcc65-09dd-44cf-8b8e-d3aa12e17261'

# Author of this module
Author = 'Danny Worth'

# Copyright statement for this module
Copyright = '(c) Danny Worth. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Random password generator with support for various password types, with the ability to customize password types and edit the word lists used for password generation.'

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @('Get-RandomPassword')

# Variables to export from this module
VariablesToExport = '*'

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{
    PSData = @{
        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('Password', 'Password-Generator', 'Random-Password')

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/tofuman0/PSRandomPassword'

        # ReleaseNotes of this module
        ReleaseNotes = 'First port of my RandomPassword ulility with added features.'
    } # End of PSData hashtable
} # End of PrivateData hashtable
}
