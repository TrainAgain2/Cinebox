# Cinebox branding

This directory contains the original visual identity used by the Cinebox fork. The Android and default interface palette uses a vivid ruby-red accent; it replaces the previous Kodi blue focus color. The launch art uses a compact **C + INEBOX** lockup on a flat dark-ruby background, so the monogram is the single initial letter in the Cinebox name. The C encloses an original film-reel symbol and is used consistently across package icons.

## Applied resources

| Resource | Source asset | Application target |
| --- | --- | --- |
| Launch and fanart artwork | `generated/cinebox-fanart-ruby-shadow.png` | Android launch screen, in-app splash, banners, Windows splash, macOS disk image, and tvOS top shelf |
| Cross-platform C/reel icon | `generated/cinebox-red-c-reel-icon.png` | Android, Linux, macOS, iOS, Windows, webOS, notifications, and vendor icon |
| Transparent C + INEBOX wordmark | `generated/cinebox-logo-transparent.png` | Default Estuary home and login vendor logo, plus the tvOS foreground layer |
| Palette configuration | Android resource XML and `addons/skin.estuary/colors/defaults.xml` | Red focus, launch progress, navigation, primary surfaces, and Estuary selection states |

The source artwork is retained here so package-specific asset sizes can be regenerated consistently by running `branding/apply_assets.sh`.
