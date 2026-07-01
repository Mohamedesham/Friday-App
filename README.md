# FRIDAY — AI Personal Assistant

> **F**ast, **R**esponsive, **I**ntelligent **D**igital **A**ssistant for **Y**ou

FRIDAY is a voice-enabled AI assistant mobile app built with Flutter, powered by Claude AI (Anthropic). It lets you have natural voice or text conversations with an AI assistant that can also search the web in real time to answer questions beyond its training data.

---

## 💡 Project Idea

The idea behind FRIDAY stems from a simple but meaningful question: *what if you had a personal AI assistant that truly felt like a conversation — not a search bar?*

Most people interact with information through typing queries and scrolling through results. FRIDAY takes a different approach — it combines the power of a large language model with real-time web search and full voice interaction, creating an experience that feels natural, fast, and intelligent.

The project was designed and built entirely by one developer as a showcase of integrating multiple modern APIs into a cohesive mobile experience. It demonstrates:

- How to connect a Flutter app to a production-grade AI model (Claude by Anthropic)
- How to extend AI capabilities with live data using a web search API (Tavily)
- How to build a seamless voice-first UX using Flutter's speech and TTS ecosystem

FRIDAY is not just a chat app — it is a foundation for what AI-powered mobile assistants can look like when built thoughtfully with Flutter.

---

## ✨ Features

- 🎙️ **Voice Input** — Speak naturally using `speech_to_text`; FRIDAY transcribes and processes your words instantly
- 🔊 **Voice Output** — Responses are read aloud via `flutter_tts` for a hands-free experience
- 🤖 **Claude AI** — Powered by Anthropic's Claude API for intelligent, context-aware conversations
- 🌐 **Web Search** — Integrated with Tavily Search API to answer questions with real-time information
- 💬 **Chat UI** — Clean, scrollable conversation interface with distinct user and assistant message bubbles
- 📱 **Cross-Platform** — Runs on Android and iOS from a single codebase

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| AI Model | Claude API (Anthropic) |
| Web Search | Tavily Search API |
| Speech to Text | `speech_to_text` package |
| Text to Speech | `flutter_tts` package |
| State Management | setState / FutureBuilder |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart SDK
- An [Anthropic API key](https://console.anthropic.com/)
- A [Tavily API key](https://tavily.com/)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Mohamedesham/Friday-App.git
   cd Friday-App
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**

   Create a `.env` file in the root of the project:
   ```env
   CLAUDE_API_KEY=your_anthropic_api_key_here
   TAVILY_API_KEY=your_tavily_api_key_here
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 🔐 Environment Variables

This project uses a `.env` file to keep API keys secure. The `.env` file is excluded from version control via `.gitignore` — **never commit your API keys to the repository.**

| Variable | Description |
|---|---|
| `CLAUDE_API_KEY` | Your Anthropic Claude API key |
| `TAVILY_API_KEY` | Your Tavily web search API key |

---

## 📁 Project Structure

```
lib/
├── main.dart               # App entry point
├── screens/
│   └── chat_screen.dart    # Main chat UI
├── services/
│   ├── claude_service.dart # Claude API integration
│   └── tavily_service.dart # Tavily search integration
└── widgets/
    └── message_bubble.dart # Chat message components
```

> Note: Structure may vary slightly — update this section to match your actual folders.

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome. Feel free to open an issue or submit a pull request.

---

## 👤 Author

**Mohamed Hesham**
- GitHub: [@Mohamedesham](https://github.com/Mohamedesham)
- LinkedIn: [mohamed-hesham-software](https://linkedin.com/in/mohamed-hesham-software)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

<div dir="rtl">

## نبذة عن المشروع

**FRIDAY** هو تطبيق مساعد ذكاء اصطناعي مبني بـ Flutter، يعتمد على نموذج Claude من Anthropic.  
يتيح لك التطبيق إجراء محادثات صوتية أو نصية مع مساعد ذكي قادر على البحث في الإنترنت للإجابة على أسئلتك بمعلومات حديثة.

**المميزات الرئيسية:**
- إدخال صوتي وإخراج صوتي
- محادثات ذكية مدعومة بـ Claude AI
- بحث على الإنترنت في الوقت الفعلي عبر Tavily
- واجهة محادثة سلسة وسهلة الاستخدام

</div>
