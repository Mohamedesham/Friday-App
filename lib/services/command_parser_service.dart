import 'device_control_service.dart';

class CommandParserService {
  final DeviceControlService _deviceControl = DeviceControlService();

  // Returns a response if it's a device command, null if not
  Future<String?> tryHandleCommand(String userMessage) async {
    final text = userMessage.toLowerCase().trim();

    // 🔦 Flashlight
    if (text.contains('flashlight') || text.contains('torch')) {
      if (text.contains('off') || text.contains('turn off')) {
        return await _deviceControl.toggleFlashlight(turnOn: false);
      }
      return await _deviceControl.toggleFlashlight(turnOn: true);
    }

    // 🔊 Volume
    if (text.contains('volume up') || text.contains('increase volume')) {
      return await _deviceControl.increaseVolume();
    }
    if (text.contains('volume down') || text.contains('decrease volume')) {
      return await _deviceControl.decreaseVolume();
    }
    if (text.contains('mute')) {
      return await _deviceControl.setVolume(0.0);
    }
    if (text.contains('max volume') || text.contains('full volume')) {
      return await _deviceControl.setVolume(1.0);
    }
    // Lock Screen
    if (text.contains('lock') ||
        text.contains('screen off') ||
        text.contains('lock screen')) {
      return await _deviceControl.lockScreen();
    }

    // 📞 Call (expects format: "call 01234567890")
    if (text.startsWith('call ')) {
      final number = text.replaceFirst('call ', '').trim();
      if (RegExp(r'^\+?[0-9]{8,15}$').hasMatch(number.replaceAll(' ', ''))) {
        return await _deviceControl.makeCall(number);
      }
    }

    // 💬 SMS (expects: "text 01234567890 hello there")
    if (text.startsWith('text ') || text.startsWith('sms ')) {
      final parts = text.replaceFirst(RegExp(r'^(text|sms) '), '').split(' ');
      if (parts.isNotEmpty) {
        final number = parts.first;
        final message = parts.skip(1).join(' ');
        if (RegExp(r'^\+?[0-9]{8,15}$').hasMatch(number)) {
          return await _deviceControl.sendSms(number, message);
        }
      }
    }

    // 📱 Open Native Apps (Strictly apps only)
    if (text.startsWith('open ')) {
      final target = text.replaceFirst('open ', '').trim();

      final nativeApps = {
        'whatsapp': 'com.whatsapp',
        'camera': 'com.android.camera2',
        'settings': 'com.android.settings',
        'calculator': 'com.android.calculator2',
        'maps': 'com.google.android.apps.maps',
        'spotify': 'com.spotify.music',
        'youtube': 'com.google.android.youtube',
        'instagram': 'com.instagram.android',
        'facebook': 'com.facebook.katana',
        'twitter': 'com.twitter.android',
        'snapchat': 'com.snapchat.android',
        'telegram': 'org.telegram.messenger',
        'gmail': 'com.google.android.gm',
        'chrome': 'com.android.chrome',
        'netflix': 'com.netflix.mediaclient',
        'tiktok': 'com.zhiliaoapp.musically',
        'photos': 'com.google.android.apps.photos',
        'contacts': 'com.android.contacts',
        'clock': 'com.android.deskclock',
        'files': 'com.android.documentsui',
        'play store': 'com.android.vending',
      };

      if (nativeApps.containsKey(target)) {
        return await _deviceControl.openApp(target, nativeApps[target]!);
      }

      // If the user says "open [something]" and it's not in the list,
      // we let it fall through to Claude who can explain she can't open it.
    }
    // Not a device command
    return null;
  }
}
