# Konexea

A modern social media application built with Flutter, featuring AI-powered interactions and seamless user experience.
![Konexea](https://vfazqatlbiewmmsbiboh.supabase.co/storage/v1/object/public/appicon//Icon.png)

## 📱 Current Version: v1.3.0

### What's New in v1.3.0
- Enhanced UI/UX with improved animations and transitions
- Optimized performance for smoother scrolling and loading
- Added new visualization features for better data representation
- Improved error handling and user feedback
- Bug fixes and stability improvements

## 🌟 Features


- **User Authentication**: Secure login and signup
- **Social Feed**: Dynamic post sharing and interaction
- **Modern UI**: Elegant design with smooth animations
- **AI Chat Assistant**: Intelligent chatbot powered by Gemini AI
- **Messaging**: Realtime chating
- **Integrated E-Commerce**: Integrated marketplace
- **Real-time Updates**: Live feed updates
- **Responsive Design**: Works on all screen sizes

## 🛠️ Tech Stack

- **Frontend**: Flutter
- **Backend**: Supabase
- **AI Integration**: Google Gemini AI
- **State Management**: Provider
- **UI Components**: Custom widgets with Material Design 3

## 📦 Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/Konexea.git
```

2. Install dependencies:
```bash
flutter pub get
```

3. Set up environment variables:
Update the `consts.dart` file in the root directory with:
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
├── lib/                     # Main application code
│   ├── Controllers/         # Business logic and services
│   │   ├── Services/
│   │   │   ├── Database/
│   │   │   └── Auth/
│   │   └── Providers/
│   ├── Model/              # Data models
│   ├── Utils/              # Utility functions and constants
│   └── Views/              # UI components
│       ├── Interface/      # Main app screens
│       └── components/     # Reusable widgets
├── assets/                 # Static assets
│   ├── images/            # Image assets
│   ├── categories/        # Category icons
│   ├── carousel/          # Carousel images
│   └── lottie/            # Lottie animations
```

## 🔧 Configuration

### Required Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  # Core
  cupertino_icons: ^1.0.2
  provider: ^6.1.1
  google_fonts: ^6.1.0
  intl: ^0.19.0
  
  # UI Components
  iconsax: ^0.0.8
  shimmer: ^3.0.0
  lottie: ^3.3.1
  curved_navigation_bar: ^1.0.3
  font_awesome_flutter: ^10.7.0
  carousel_slider: ^5.0.0
  cached_network_image: ^3.3.1
  photo_view: ^0.14.0
  
  # Media
  image_picker: ^1.0.7
  video_player: ^2.8.2
  visibility_detector: ^0.4.0+2
  
  # Backend
  firebase_core: ^3.12.1
  cloud_firestore: ^5.6.5
  supabase_flutter: ^2.3.4
  
  # Utilities
  http: ^1.1.0
  fluttertoast: ^8.2.4
  google_mlkit_translation: ^0.13.0
```


# Konexea Project Visualization

## Project Architecture Overview

```mermaid
graph TB
    subgraph Frontend
        A[Flutter UI] --> B[State Management]
        B --> C[Controllers]
        C --> D[Services]
    end
    
    subgraph Backend
        E[Firebase] --> F[Authentication]
        E --> G[Cloud Storage]
        E --> H[Cloud Functions]
        
        I[Supabase] --> J[PostgreSQL DB]
        I --> K[Storage]
        I --> L[Real-time Subscriptions]
    end
    
    D --> E
    D --> I
```

## Development Workflow

```mermaid
graph LR
    A[Setup] --> B[Development]
    B --> C[Testing]
    C --> D[Deployment]
    
    subgraph Setup
        A1[Clone Repo] --> A2[Install Dependencies]
        A2 --> A3[Configure Services]
    end
    
    subgraph Development
        B1[Create Branch] --> B2[Implement Feature]
        B2 --> B3[Code Review]
    end
    
    subgraph Testing
        C1[Unit Tests] --> C2[Widget Tests]
        C2 --> C3[Integration Tests]
    end
    
    subgraph Deployment
        D1[Build] --> D2[Sign]
        D2 --> D3[Deploy]
    end
```

## Feature Implementation Flow

```mermaid
graph TB
    A[Feature Request] --> B{Analysis}
    B -->|Approved| C[Development]
    B -->|Rejected| D[Document]
    
    C --> E[Testing]
    E -->|Pass| F[Code Review]
    E -->|Fail| C
    
    F -->|Approved| G[Deployment]
    F -->|Changes Needed| C
    
    G --> H[Monitoring]
    H --> I[Documentation]
```

## Project Structure

```mermaid
graph TB
    subgraph Project Root
        A[social_swap/] --> B[lib/]
        A --> C[assets/]
        A --> D[test/]
        A --> E[platform/]
    end
    
    subgraph lib/
        B --> B1[Controllers/]
        B --> B2[Model/]
        B --> B3[Utils/]
        B --> B4[Views/]
        B --> B5[main.dart]
    end
    
    subgraph platform/
        E --> E1[android/]
        E --> E2[ios/]
        E --> E3[web/]
    end
```

## State Management Flow

```mermaid
graph LR
    A[UI] --> B[Provider/Bloc]
    B --> C[Controllers]
    C --> D[Services]
    D --> E[Backend]
    
    E --> D
    D --> C
    C --> B
    B --> A
```

## Testing Strategy

```mermaid
graph TB
    A[Testing] --> B[Unit Tests]
    A --> C[Widget Tests]
    A --> D[Integration Tests]
    
    B --> B1[Controllers]
    B --> B2[Services]
    B --> B3[Utils]
    
    C --> C1[UI Components]
    C --> C2[Screens]
    
    D --> D1[Feature Flows]
    D --> D2[End-to-End]
```

## Deployment Pipeline

```mermaid
graph LR
    A[Code] --> B[Build]
    B --> C[Test]
    C --> D[Deploy]
    
    subgraph Build
        B1[Flutter Build] --> B2[Asset Processing]
        B2 --> B3[Bundle Creation]
    end
    
    subgraph Deploy
        D1[Version Update] --> D2[Sign]
        D2 --> D3[Store Upload]
    end
```

## Security Flow

```mermaid
graph TB
    A[User] --> B[Authentication]
    B --> C[Authorization]
    C --> D[Resource Access]
    
    subgraph Authentication
        B1[Login] --> B2[Token Generation]
        B2 --> B3[Session Management]
    end
    
    subgraph Authorization
        C1[Role Check] --> C2[Permission Verify]
        C2 --> C3[Access Grant]
    end
```

## Error Handling Flow

```mermaid
graph TB
    A[Error Occurs] --> B{Error Type}
    B -->|Network| C[Retry Logic]
    B -->|Validation| D[User Feedback]
    B -->|System| E[Logging]
    
    C --> F[Recovery]
    D --> F
    E --> F
    
    F --> G[Continue Flow]
    F --> H[Fallback]
```

# Konexea Class Diagram


## Class Diagram

```mermaid
classDiagram
    class User {
        +String id
        +String username
        +String email
        +String profileImage
        +DateTime createdAt
        +updateProfile()
        +deleteAccount()
    }

    class Post {
        +String id
        +String userId
        +String content
        +List~String~ mediaUrls
        +DateTime createdAt
        +int likeCount
        +createPost()
        +deletePost()
        +updatePost()
    }

    class Comment {
        +String id
        +String postId
        +String userId
        +String content
        +DateTime createdAt
        +addComment()
        +deleteComment()
    }

    class AuthService {
        +signUp()
        +signIn()
        +signOut()
        +resetPassword()
    }

    class PostService {
        +createPost()
        +getPosts()
        +updatePost()
        +deletePost()
    }

    class UserService {
        +getUserProfile()
        +updateUserProfile()
        +followUser()
        +unfollowUser()
    }

    class StorageService {
        +uploadMedia()
        +deleteMedia()
        +getMediaUrl()
    }

    User "1" -- "many" Post : creates
    User "1" -- "many" Comment : writes
    Post "1" -- "many" Comment : has
    AuthService --> User : manages
    PostService --> Post : manages
    UserService --> User : manages
    StorageService --> Post : stores media
```



# Konexea Activity Diagrams

## System Architecture

```mermaid
graph TB
    subgraph Frontend
        A[Flutter UI] --> B[State Management]
        B --> C[Controllers]
        C --> D[Services]
    end
    
    subgraph Backend
        E[Firebase] --> F[Authentication]
        E --> G[Cloud Storage]
        E --> H[Cloud Functions]
        
        I[Supabase] --> J[PostgreSQL DB]
        I --> K[Storage]
        I --> L[Real-time Subscriptions]
    end
    
    D --> E
    D --> I
    
    subgraph External Services
        M[Image Processing]
        N[Push Notifications]
        O[Analytics]
    end
    
    E --> M
    E --> N
    E --> O
```

## User Authentication Flow

```mermaid
sequenceDiagram
    participant User
    participant App
    participant Firebase
    participant Supabase
    
    User->>App: Open App
    App->>User: Show Login/Register Screen
    
    alt New User
        User->>App: Click Register
        App->>Firebase: Create Account
        Firebase-->>App: Account Created
        App->>Supabase: Create User Profile
        Supabase-->>App: Profile Created
        App->>User: Show Home Screen
    else Existing User
        User->>App: Enter Credentials
        App->>Firebase: Authenticate
        Firebase-->>App: Authentication Success
        App->>Supabase: Fetch User Profile
        Supabase-->>App: Profile Data
        App->>User: Show Home Screen
    end
```

## Post Creation Flow

```mermaid
sequenceDiagram
    participant User
    participant App
    participant Firebase
    participant Supabase
    
    User->>App: Click Create Post
    App->>User: Show Post Creation UI
    
    User->>App: Add Content & Media
    App->>Firebase: Upload Media
    Firebase-->>App: Media URLs
    
    App->>Supabase: Save Post Data
    Supabase-->>App: Post Created
    
    App->>User: Show Success Message
    App->>User: Update Feed
```

## Social Interaction Flow

```mermaid
graph TB
    A[User] --> B{Action}
    B -->|Like| C[Update Like Count]
    B -->|Comment| D[Add Comment]
    B -->|Share| E[Create Share]
    B -->|Follow| F[Update Followers]
    
    C --> G[Update UI]
    D --> G
    E --> G
    F --> G
    
    G --> H[Real-time Updates]
    H --> I[Other Users]
```

## Content Discovery Flow

```mermaid
graph LR
    A[User] --> B[Search]
    A --> C[Explore]
    A --> D[Feed]
    
    B --> E[Results]
    C --> F[Trending]
    D --> G[Following]
    
    E --> H[Content]
    F --> H
    G --> H
    
    H --> I[Interact]
    I --> J[Update Feed]
```

## Data Flow Architecture

```mermaid
graph TB
    subgraph Client
        A[UI Components] --> B[State Management]
        B --> C[API Services]
    end
    
    subgraph API Layer
        C --> D[Firebase SDK]
        C --> E[Supabase Client]
    end
    
    subgraph Backend Services
        D --> F[Auth Service]
        D --> G[Storage Service]
        E --> H[Database Service]
        E --> I[Real-time Service]
    end
    
    subgraph External APIs
        J[Image Processing]
        K[Push Notifications]
        L[Analytics]
    end
    
    F --> J
    G --> K
    H --> L
```
## Detailed Sequence Diagrams

### User Registration Sequence

```mermaid
sequenceDiagram
    participant User
    participant UI
    participant AuthService
    participant UserService
    participant StorageService
    participant Database

    User->>UI: Enter Registration Details
    UI->>AuthService: Register User
    AuthService->>Database: Create Auth Record
    Database-->>AuthService: Auth Created
    
    AuthService->>UserService: Create User Profile
    UserService->>Database: Save User Data
    Database-->>UserService: Profile Created
    
    User->>UI: Upload Profile Picture
    UI->>StorageService: Upload Image
    StorageService->>Database: Update Profile Image URL
    Database-->>UI: Profile Complete
    UI-->>User: Show Home Screen
```

### Post Interaction Sequence

```mermaid
sequenceDiagram
    participant User
    participant UI
    participant PostService
    participant StorageService
    participant Database
    participant NotificationService

    User->>UI: Create New Post
    UI->>PostService: Initiate Post Creation
    
    alt With Media
        PostService->>StorageService: Upload Media
        StorageService-->>PostService: Media URLs
    end
    
    PostService->>Database: Save Post Data
    Database-->>PostService: Post Created
    
    PostService->>NotificationService: Notify Followers
    NotificationService-->>Database: Update Feed
    
    Database-->>UI: Update Feed
    UI-->>User: Show Success Message
```

### Social Interaction Sequence

```mermaid
sequenceDiagram
    participant UserA
    participant UserB
    participant UI
    participant SocialService
    participant Database
    participant NotificationService

    UserA->>UI: Follow UserB
    UI->>SocialService: Process Follow Request
    SocialService->>Database: Update Followers
    Database-->>SocialService: Update Complete
    
    SocialService->>NotificationService: Send Notification
    NotificationService-->>UserB: New Follower Alert
    
    UserB->>UI: View New Follower
    UI->>SocialService: Get Follower Details
    SocialService-->>UI: Follower Information
    UI-->>UserB: Display Follower Profile
```

### Content Discovery Sequence

```mermaid
sequenceDiagram
    participant User
    participant UI
    participant SearchService
    participant RecommendationService
    participant Database

    User->>UI: Search Content
    UI->>SearchService: Process Search Query
    SearchService->>Database: Query Content
    Database-->>SearchService: Search Results
    
    SearchService->>RecommendationService: Get Recommendations
    RecommendationService->>Database: Fetch Related Content
    Database-->>RecommendationService: Related Items
    
    RecommendationService-->>UI: Combined Results
    UI-->>User: Display Results
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

- Mahad Ghauri
- Mahateer Muhammad

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Supabase for the backend infrastructure
- Google for the Gemini AI API
- All contributors and supporters

## 📞 Support

For support, email mahadghauri222@gmail.com.
For support, email mahateermuhammad100@gmail.com.
