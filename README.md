# Social Swap

A modern social media application built with Flutter, featuring AI-powered interactions and seamless user experience.

## 🌟 Features

- **AI Chat Assistant**: Intelligent chatbot powered by Gemini AI
- **Social Feed**: Dynamic post sharing and interaction
- **Modern UI**: Elegant design with smooth animations
- **User Authentication**: Secure login and signup
- **Real-time Updates**: Live feed updates
- **Responsive Design**: Works on all screen sizes

## 📱 Application Preview

### Chat Interface
![Chat Interface](assets/preview/chat_preview.png)
- Modern chat UI with message bubbles
- Real-time AI responses
- Loading indicators and animations
- User-friendly input field

### Feed Interface
![Feed Interface](assets/preview/feed_preview.png)
- Clean post layout
- Interactive elements
- Smooth scrolling
- Dynamic content loading

## 🛠️ Tech Stack

- **Frontend**: Flutter
- **Backend**: Supabase
- **AI Integration**: Google Gemini AI
- **State Management**: Provider
- **UI Components**: Custom widgets with Material Design 3

## 📦 Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/social_swap.git
```

2. Install dependencies:
```bash
flutter pub get
```

3. Set up environment variables:
Create a `.env` file in the root directory with:
```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
GEMINI_API_KEY=your_gemini_api_key
```

4. Run the application:
```bash
flutter run
```

## 📁 Project Structure

```
lib/
├── controllers/
│   ├── Services/
│   │   ├── Authentication/
│   │   ├── Chatbot/
│   │   └── Database/
│   └── input_controllers.dart
├── models/
│   └── user_model.dart
├── views/
│   ├── Authentication/
│   ├── Interface/
│   └── components/
└── main.dart
```

## 🔧 Configuration

### Required Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^1.10.25
  provider: ^6.1.1
  google_fonts: ^6.1.0
  iconsax: ^0.0.8
  http: ^1.1.0
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- Mahad Ghauri - Initial work

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Supabase for the backend infrastructure
- Google for the Gemini AI API
- All contributors and supporters

## 📞 Support

For support, email mahadghauri222@gmail.com.
