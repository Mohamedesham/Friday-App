import 'package:flutter/services.dart';
import 'package:torch_light/torch_light.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class DeviceControlService {
  bool _flashlightOn = false;
  final VolumeController _volumeController = VolumeController();
  static const _channel = MethodChannel('com.example.friday/device');

  // 🔦 Flashlight
  Future<String> toggleFlashlight({bool? turnOn}) async {
    try {
      final shouldTurnOn = turnOn ?? !_flashlightOn;

      if (shouldTurnOn) {
        await TorchLight.enableTorch();
        _flashlightOn = true;
        return 'Flashlight is on, boss.';
      } else {
        await TorchLight.disableTorch();
        _flashlightOn = false;
        return 'Flashlight is off.';
      }
    } catch (e) {
      return 'Sorry, I could not control the flashlight.';
    }
  }

  // 🔊 Volume control (0.0 to 1.0)
  Future<String> setVolume(double level) async {
    try {
      _volumeController.setVolume(level.clamp(0.0, 1.0));
      return 'Volume set to ${(level * 100).toInt()}%.';
    } catch (e) {
      return 'Sorry, I could not adjust the volume.';
    }
  }

  Future<String> increaseVolume() async {
    try {
      final current = await _volumeController.getVolume();
      final newVolume = (current + 0.2).clamp(0.0, 1.0);
      _volumeController.setVolume(newVolume);
      return 'Volume increased.';
    } catch (e) {
      return 'Sorry, I could not increase the volume.';
    }
  }

  Future<String> decreaseVolume() async {
    try {
      final current = await _volumeController.getVolume();
      final newVolume = (current - 0.2).clamp(0.0, 1.0);
      _volumeController.setVolume(newVolume);
      return 'Volume decreased.';
    } catch (e) {
      return 'Sorry, I could not decrease the volume.';
    }
  }

  // Lock Screen
  Future<String> lockScreen() async {
    try {
      final isLocked = await _channel.invokeMethod<bool>('lockScreen');

      if (isLocked == false) {
        // Not admin yet — request admin
        await _channel.invokeMethod('requestAdmin');
        return 'Please enable FRIDAY as device admin, then try again.';
      }

      return 'Locking screen now, boss.';
    } catch (e) {
      return 'Sorry, I could not lock the screen.';
    }
  }

  // 📞 Make a call
  Future<String> makeCall(String phoneNumber) async {
    try {
      final uri = Uri.parse('tel:$phoneNumber');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return 'Calling $phoneNumber now.';
      } else {
        return 'Sorry, I could not open the dialer.';
      }
    } catch (e) {
      return 'Sorry, something went wrong while calling.';
    }
  }

  // 💬 Send SMS
  Future<String> sendSms(String phoneNumber, String message) async {
    try {
      final uri = Uri.parse(
        'sms:$phoneNumber?body=${Uri.encodeComponent(message)}',
      );
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return 'SMS ready to send to $phoneNumber.';
      } else {
        return 'Sorry, I could not open messages.';
      }
    } catch (e) {
      return 'Sorry, something went wrong while sending SMS.';
    }
  }

  // 🌐 Open a website/app
  Future<String> openUrl(String url) async {
    try {
      final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return 'Opening $url now.';
      } else {
        return 'Sorry, I could not open that.';
      }
    } catch (e) {
      return 'Sorry, something went wrong.';
    }
  }
}
