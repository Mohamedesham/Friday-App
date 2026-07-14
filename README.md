# FRIDAY — AI Personal Assistant

> *"Good day. I'm FRIDAY. How can I assist you?"*

FRIDAY is an Iron Man-inspired AI personal assistant built with Flutter and powered by Claude AI. It supports voice commands, wake word detection, real-time web search, and device control — all in one app.

---

## Features

- **AI Brain** — Powered by Anthropic's Claude API for intelligent conversations
- **Voice Input** — Speak your commands naturally using speech-to-text
- **Voice Output** — FRIDAY speaks back every response using text-to-speech
- **Wake Word** — Just say "Friday" to activate her hands-free
- **Web Search** — Real-time information via Tavily API
- **Device Control** — Control flashlight, volume, calls, SMS, and screen lock
- **Conversation Memory** — FRIDAY remembers the full context of your conversation
- **Dark Iron Man UI** — Sleek dark themed interface inspired by the Iron Man HUD

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter / Dart |
| AI Brain | Claude API (Anthropic) |
| Voice Input | speech_to_text |
| Voice Output | flutter_tts |
| Wake Word | speech_to_text (keyword detection) |
| Web Search | Tavily API |
| HTTP | http package |
| Environment | flutter_dotenv |

---

## Project Structure

```
lib/
├── main.dart
├── core/
│   └── constants.dart
├── data/
│   ├── claude_service.dart
│   └── ui_message.dart
├── services/
│   ├── tts_service.dart
│   ├── stt_service.dart
│   ├── wake_word_service.dart
│   ├── search_service.dart
│   ├── device_control_service.dart
│   └── command_parser_service.dart
└── presentation/
    ├── chat_screen.dart
    └── widgets/
        ├── chat_app_bar.dart
        ├── chat_message_list.dart
        ├── chat_status_bar.dart
        ├── chat_input_bar.dart
        └── message_bubble.dart
```

---

## Getting Started

### Prerequisites

- Flutter SDK (3.x or higher)
- Android device or emulator (API 21+)
- Anthropic API Key → [console.anthropic.com](https://console.anthropic.com)
- Tavily API Key → [app.tavily.com](https://app.tavily.com)

### Installation

1. Clone the repository
```bash
git clone https://github.com/Mohamedesham/Friday-App.git
cd Friday-App
```

2. Install dependencies
```bash
flutter pub get
```

3. Create a `.env` file in the root of the project
```
CLAUDE_API_KEY=your_anthropic_api_key_here
TAVILY_API_KEY=your_tavily_api_key_here
```

4. Run the app
```bash
flutter run
```

---

## Voice Commands

| Command | Action |
|---|---|
| "Friday" | Wake up FRIDAY |
| "What's the weather today?" | Real-time weather info |
| "What's the dollar price?" | Live currency rates |
| "Turn on the flashlight" | Toggle flashlight |
| "Volume up / Volume down" | Adjust volume |
| "Mute" | Mute device |
| "Call 01234567890" | Make a phone call |
| "Text 01234567890 hello" | Send SMS |
| "Open YouTube" | Open app or website |
| "Lock the screen" | Lock device screen |
| "What's the latest news?" | Fetch latest headlines |

---

## Build Phases

| Phase | Description | Status |
|---|---|---|
| Phase 1 | AI chat with Claude API | ✅ Done |
| Phase 2 | Voice input & output | ✅ Done |
| Phase 3 | Wake word detection | ✅ Done |
| Phase 4 | Web search integration | ✅ Done |
| Phase 5 | Device control | ✅ Done |
| Bonus | Background service | 🔄 Coming soon |

---

## Environment Variables

| Variable | Description |
|---|---|
| `CLAUDE_API_KEY` | Your Anthropic Claude API key |
| `TAVILY_API_KEY` | Your Tavily web search API key |

> Never commit your `.env` file to GitHub!

---

## Android Permissions

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.CALL_PHONE"/>
<uses-permission android:name="android.permission.SEND_SMS"/>
<uses-permission android:name="android.permission.FLASHLIGHT"/>
```

---

## Developer

**Mohamed Hesham**
- GitHub: [github.com/Mohamedesham](https://github.com/Mohamedesham)
- LinkedIn: [linkedin.com/in/mohamed-hesham-software](https://linkedin.com/in/mohamed-hesham-software)

---

## License

This project is open source and available under the [MIT License](LICENSE).
