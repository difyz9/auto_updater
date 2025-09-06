import 'package:auto_updater/src/appcast.dart';
import 'package:auto_updater/src/updater_error.dart';

abstract mixin class UpdaterListener {
  void onUpdaterError(UpdaterError? error);
  void onUpdaterCheckingForUpdate(Appcast? appcast);
  void onUpdaterUpdateAvailable(AppcastItem? appcastItem);
  void onUpdaterUpdateNotAvailable(UpdaterError? error);
  void onUpdaterUpdateDownloaded(AppcastItem? appcastItem);
  void onUpdaterBeforeQuitForUpdate(AppcastItem? appcastItem);
  
  /// Called when a mandatory update is available
  void onUpdaterMandatoryUpdateAvailable(AppcastItem? appcastItem) {}
  
  /// Called when update installation begins (for mandatory updates)
  void onUpdaterUpdateInstallationStarted(AppcastItem? appcastItem) {}
  
  /// Called when update installation is completed
  void onUpdaterUpdateInstallationCompleted(AppcastItem? appcastItem) {}
}
