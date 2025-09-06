import 'package:auto_updater/auto_updater.dart';
import 'package:flutter/material.dart';

class UpdateManager extends StatefulWidget {
  const UpdateManager({super.key});

  @override
  State<UpdateManager> createState() => _UpdateManagerState();
}

class _UpdateManagerState extends State<UpdateManager> implements UpdaterListener {
  String _status = 'Ready';
  bool _isMandatoryMode = false;
  AppcastItem? _availableUpdate;

  @override
  void initState() {
    super.initState();
    autoUpdater.addListener(this);
  }

  @override
  void dispose() {
    autoUpdater.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: $_status'),
            const SizedBox(height: 20),
            
            // Mandatory Update Toggle
            SwitchListTile(
              title: const Text('Mandatory Update Mode'),
              subtitle: const Text('When enabled, updates will be forced'),
              value: _isMandatoryMode,
              onChanged: (value) {
                setState(() {
                  _isMandatoryMode = value;
                });
                autoUpdater.setMandatoryUpdates(value);
              },
            ),
            
            const SizedBox(height: 20),
            
            // Action Buttons
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () => autoUpdater.checkForUpdates(),
                  child: const Text('Check for Updates'),
                ),
                ElevatedButton(
                  onPressed: () => autoUpdater.downloadUpdate(),
                  child: const Text('Download Update'),
                ),
                if (_availableUpdate != null)
                  ElevatedButton(
                    onPressed: () => autoUpdater.installUpdateAndRestart(),
                    child: const Text('Install & Restart'),
                  ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Update Information
            if (_availableUpdate != null) ...[
              const Text('Available Update:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Version: ${_availableUpdate!.versionString ?? 'Unknown'}'),
                      Text('Title: ${_availableUpdate!.title ?? 'No title'}'),
                      if (_availableUpdate!.isMandatory == true) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '🚨 MANDATORY UPDATE', 
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                              ),
                              if (_availableUpdate!.mandatoryMessage?.isNotEmpty == true)
                                Text(_availableUpdate!.mandatoryMessage!),
                            ],
                          ),
                        ),
                      ],
                      if (_availableUpdate!.itemDescription?.isNotEmpty == true) ...[
                        const SizedBox(height: 8),
                        Text('Description: ${_availableUpdate!.itemDescription}'),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // UpdaterListener implementation
  @override
  void onUpdaterError(UpdaterError? error) {
    setState(() {
      _status = 'Error: ${error?.toString() ?? 'Unknown error'}';
    });
    _showSnackBar('Update error: ${error?.toString() ?? 'Unknown error'}', Colors.red);
  }

  @override
  void onUpdaterCheckingForUpdate(Appcast? appcast) {
    setState(() {
      _status = 'Checking for updates...';
    });
  }

  @override
  void onUpdaterUpdateAvailable(AppcastItem? appcastItem) {
    setState(() {
      _status = 'Optional update available';
      _availableUpdate = appcastItem;
    });
    _showSnackBar('Optional update available: ${appcastItem?.versionString}', Colors.blue);
  }

  @override
  void onUpdaterMandatoryUpdateAvailable(AppcastItem? appcastItem) {
    setState(() {
      _status = 'Mandatory update available';
      _availableUpdate = appcastItem;
    });
    
    // Show mandatory update dialog
    _showMandatoryUpdateDialog(appcastItem);
  }

  @override
  void onUpdaterUpdateNotAvailable(UpdaterError? error) {
    setState(() {
      _status = 'No updates available';
      _availableUpdate = null;
    });
    _showSnackBar('No updates available', Colors.green);
  }

  @override
  void onUpdaterUpdateDownloaded(AppcastItem? appcastItem) {
    setState(() {
      _status = 'Update downloaded, ready to install';
    });
    _showSnackBar('Update downloaded: ${appcastItem?.versionString}', Colors.orange);
  }

  @override
  void onUpdaterBeforeQuitForUpdate(AppcastItem? appcastItem) {
    setState(() {
      _status = 'Preparing to install update...';
    });
  }

  @override
  void onUpdaterUpdateInstallationStarted(AppcastItem? appcastItem) {
    setState(() {
      _status = 'Installing update...';
    });
    _showSnackBar('Update installation started', Colors.orange);
  }

  @override
  void onUpdaterUpdateInstallationCompleted(AppcastItem? appcastItem) {
    setState(() {
      _status = 'Update installation completed';
    });
    _showSnackBar('Update installation completed', Colors.green);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showMandatoryUpdateDialog(AppcastItem? appcastItem) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('🚨 Mandatory Update Required'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Version ${appcastItem?.versionString ?? 'Unknown'} is required.'),
              if (appcastItem?.mandatoryMessage?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                Text(appcastItem!.mandatoryMessage!),
              ],
              const SizedBox(height: 16),
              const Text('This update is mandatory and must be installed to continue using the application.'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                autoUpdater.installUpdateAndRestart();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Install Now'),
            ),
          ],
        );
      },
    );
  }
}
