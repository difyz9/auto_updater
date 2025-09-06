## 1.1.0

* **NEW**: Add support for mandatory (forced) updates
* **NEW**: Add `installUpdateAndRestart()` method for immediate update installation
* **NEW**: Add `setMandatoryUpdates(bool)` method to enable/disable mandatory update mode
* **NEW**: Add `downloadUpdate()` method for background update downloading
* **NEW**: Add new event callbacks:
  - `onUpdaterMandatoryUpdateAvailable()` - called when a mandatory update is detected
  - `onUpdaterUpdateInstallationStarted()` - called when update installation begins
  - `onUpdaterUpdateInstallationCompleted()` - called when update installation completes
* **NEW**: Extend `AppcastItem` with `isMandatory` and `mandatoryMessage` fields
* **IMPROVEMENT**: Enhanced update flow control for better user experience
* **DOCS**: Add comprehensive mandatory updates usage guide

## 1.0.0

* First major release.
* [macos] Solve deprecate 'setFeedURL' (#66)

## 0.2.1 

* chore(windows): Support before-quit-for-update event

## 0.2.0

* feat: Convert to federated plugin
* feat: Add `UpdaterListener` to listen for update events
* chore: [windows] Upgrade to `WinSparkle-0.8.1`

## 0.1.7

* Bump flutter to 3.10.2
* [windows] fix sign_update script on 3.10.x #49 #37
* [windows] Upgrade to `WinSparkle-0.8.0` (#45)
* [windows] feat: add support for emitting events from winsparkle (#43)

## 0.1.6

* Add `setScheduledCheckInterval` method #28

## 0.1.5

* Add check update in background.

## 0.1.4

* Downgrade flutter version to 2.0.0 #7

## 0.1.3

* [windows] Add missing WinSparkle dll/lib/pdb files #4
* [windows] fix command path error #5

## 0.1.2

* [windows] Add missing WinSparkle dll/lib/pdb files

## 0.1.1

* Downgrade dart sdk version to 2.12.0

## 0.1.0

* first release.
