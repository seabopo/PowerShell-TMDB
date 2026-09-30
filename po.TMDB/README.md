
# PowerShell Module: TMDB (The Movie Database)

This module retrieves metadata about TV Shows and Movies from [TMDB (The Movie Database)](https://www.themoviedb.org)
using their publicly available [API](https://developer.themoviedb.org/docs/getting-started).

This module is not a wrapper of the complete TMDB API. It is a READ-ONLY implementation of the functions
required to apply metadata to local media files.

## TMDB Attribution and Terms of Use

<img src="https://www.themoviedb.org/assets/2/v4/logos/v2/blue_short-8e7b30f73a4020692ccca9c88bafe5dcb6f8a62a4c6bc55cd9ba82bb2cd95f6c.svg" alt="TMDB Logo" height="16">

This product uses TMDB and the TMDB APIs but is not endorsed, certified, or otherwise approved by TMDB.
All content retrieved by this API is the product of TMDB and its community.

Use of the TMDB API is subject to the [TMDB API Terms of Use](https://www.themoviedb.org/api-terms-of-use).
The API is free to use for non-commercial purposes as long as you attribute TMDB as the source of the data
and/or images (see [Logos & Attribution](https://www.themoviedb.org/about/logos-attribution)); commercial use
requires a separate agreement with TMDB.

To use the [API](https://developer.themoviedb.org/docs/getting-started) you will need an API key.
To get an API key, create a free [TMDB Account](https://www.themoviedb.org/signup) and request an API key
from the [API Settings](https://www.themoviedb.org/settings/api) section under your account profile.
The module reads the key from the `TMDB_API_TOKEN` environment variable.

## Licensing

This module's own code is licensed under the [MIT License](LICENSE). The data and images the module retrieves
belong to TMDB and its contributors, and are covered by the TMDB API Terms of Use above, not by this license.

## Module Installation
The po.TMDB PowerShell Module has only been tested with PowerShell 7.4 and above.

Install the po.TMDB PowerShell Module with PSResourceGet, which comes with PowerShell 7.4 and later:
```
Install-PSResource -Name po.TMDB -Repository PSGallery -Scope CurrentUser
```

po.TMDB depends on the [PowerShell-Toolkit](https://github.com/seabopo/PowerShell-Toolkit) and
[PowerShell-MediaClasses](https://github.com/seabopo/PowerShell-MediaClasses) PowerShell Modules:
```
Install-PSResource -Name po.Toolkit -Repository PSGallery -Scope CurrentUser
Install-PSResource -Name po.MediaClasses -Repository PSGallery -Scope CurrentUser
```

"Untrusted repository" prompt: PSGallery is untrusted by default. Add -TrustRepository to Install-PSResource to skip it.

Updating later: use Update-PSResource -Name po.TMDB.


## Using the Module
See the [sample-code](https://github.com/seabopo/PowerShell-TMDB/tree/main/sample-code) folder in the repo.
