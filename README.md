# Social Swap

A modern social media application built with Flutter, featuring AI-powered interactions and seamless user experience.
![Social Swap](https://gttdwnnthusaqvujxoll.supabase.co/storage/v1/object/sign/app-icon/App%20Icon.jpeg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJhcHAtaWNvbi9BcHAgSWNvbi5qcGVnIiwiaWF0IjoxNzQyNzQxNTU0LCJleHAiOjE3NTEwNzQxNTU0fQ.yVPnwkj5nbnWspxG8adR28DKdDg4yw4CMyadFou6kvQ)

## 🌟 Features

- **AI Chat Assistant**: Intelligent chatbot powered by Gemini AI
- **Social Feed**: Dynamic post sharing and interaction
- **Modern UI**: Elegant design with smooth animations
- **User Authentication**: Secure login and signup
- **Real-time Updates**: Live feed updates
- **Responsive Design**: Works on all screen sizes

## 📱 Application Preview

### Login Interface
![Login Interface](https://gttdwnnthusaqvujxoll.supabase.co/storage/v1/object/sign/app-images/App%20SS%201.jpeg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJhcHAtaW1hZ2VzL0FwcCBTUyAxLmpwZWciLCJpYXQiOjE3NDI3NDE2MjcsImV4cCI6MTc1MTA3NDE2Mjd9.awQCGuGGLjXsvNTadsfNkJHUoBRaHKADlicwkolnHuk)
- Modern login UI with unique color combinations
- Loading indicators and animations
- User-friendly input field
- Secure Authentication

### Sign Up Interface
![Sign Up Interface](https://gttdwnnthusaqvujxoll.supabase.co/storage/v1/object/sign/app-images/App%20SS%202.jpeg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJhcHAtaW1hZ2VzL0FwcCBTUyAyLmpwZWciLCJpYXQiOjE3NDI3NDE3NTcsImV4cCI6MTc1MTA3NDE3NTd9.YRtZCn7mbaWy2eG2uNU4uqHqr3WlLY5Hy66334goCFM)
- Modern signup UI with unique color combinations
- Loading indicators and animations
- User-friendly input field
- Secure Authentication

### Feed Interface
![Feed Interface](https://gttdwnnthusaqvujxoll.supabase.co/storage/v1/object/sign/app-images/App%20SS%203.jpeg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJhcHAtaW1hZ2VzL0FwcCBTUyAzLmpwZWciLCJpYXQiOjE3NDI3NDE3OTcsImV4cCI6MTc1MTA3NDE3OTd9.YfuHM9IsVE7GopNWs1h31a8dgSf7beEHxsGIODqN4aE)
- Clean post layout
- Interactive elements
- Smooth scrolling
- Dynamic content loading

### Chat Interface
![Upload post Interface](https://gttdwnnthusaqvujxoll.supabase.co/storage/v1/object/sign/app-images/App%20SS%206.jpeg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJhcHAtaW1hZ2VzL0FwcCBTUyA2LmpwZWciLCJpYXQiOjE3NDI3NDE4NzcsImV4cCI6MTc1MTA3NDE4Nzd9.lYfPv9bZl1y2JadfKvHRqDfIsgZaqsoBcQ9pFR4Kj4w)
- Minimal Upload Post UI 
- Real-time Response
- Loading indicators and animations
- User-friendly input field

### Chat Bot Interface
![Chat Bot Interface](https://gttdwnnthusaqvujxoll.supabase.co/storage/v1/object/sign/app-images/App%20SS%205.jpeg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJhcHAtaW1hZ2VzL0FwcCBTUyA1LmpwZWciLCJpYXQiOjE3NDI3NDE5MzIsImV4cCI6MTc1MTA3NDE5MzJ9.OlRJ4pgvQHBvUTBcLPmp9jpfK8u-r7rHAhGUxNNA2KQ)
- Modern chat UI with message bubbles
- Real-time AI responses
- Loading indicators and animations
- User-friendly input field

### News Page Interface
![News Page Interface](https://gttdwnnthusaqvujxoll.supabase.co/storage/v1/object/sign/app-images/App%20SS%207.jpeg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJhcHAtaW1hZ2VzL0FwcCBTUyA3LmpwZWciLCJpYXQiOjE3NDI3NDE5NjEsImV4cCI6MTc1MTA3NDE5NjF9.mFi5g-zfUXYz_UTv3zpcjvmHN_3n6xAsblJatKkrP84)
- Minimal User Interface
- Real-time Responses
- Loading indicators and animations

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
