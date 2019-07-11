fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios test
```
fastlane ios test
```
Test Library
### ios development
```
fastlane ios development
```
Build Dev ipa
### ios beta
```
fastlane ios beta
```
Push a new beta build to TestFlight
### ios release
```
fastlane ios release
```
Push a new release build to AppStore
### ios bumpbuild
```
fastlane ios bumpbuild
```
Bump the build number
### ios bumpversionmajor
```
fastlane ios bumpversionmajor
```
Increment major version number (i.e.: X.0.0) + build bump
### ios bumpversionminor
```
fastlane ios bumpversionminor
```
Increment minor version number (i.e.: 1.X.0) + build bump
### ios bumpversionpatch
```
fastlane ios bumpversionpatch
```
Increment patch version number (i.e.: 1.1.X) + build bump

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
