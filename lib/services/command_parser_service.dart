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

    // 🌐 Open website (expects: "open google.com" or "open youtube")
    if (text.startsWith('open ')) {
      final target = text.replaceFirst('open ', '').trim();
      // Simple shortcuts
      final shortcuts = {
        'youtube': 'youtube.com',
        'google': 'google.com',
        'whatsapp': 'wa.me',
        'facebook': 'facebook.com',
        'instagram': 'instagram.com',
      };
      final url = shortcuts[target] ?? target;
      return await _deviceControl.openUrl(url);
    }

    // Not a device command
    return null;
  }
}
