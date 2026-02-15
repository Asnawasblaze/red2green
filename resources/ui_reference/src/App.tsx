import { useState } from 'react';
import { WelcomeScreen } from './components/WelcomeScreen';
import { CitizenSignup } from './components/CitizenSignup';
import { NGOSignup } from './components/NGOSignup';
import { LoginScreen } from './components/LoginScreen';
import { HomeFeed } from './components/HomeFeed';
import { MapView } from './components/MapView';
import { ReportForm } from './components/ReportForm';
import { Profile } from './components/Profile';
import { ChatList } from './components/ChatList';
import { ChatRoom } from './components/ChatRoom';
import { SettingsPage } from './components/SettingsPage';
import { EditProfile } from './components/EditProfile';
import { Home, Map, Plus, User, MessageCircle } from 'lucide-react';

type Screen = 'welcome' | 'citizen-signup' | 'ngo-signup' | 'login' | 'home' | 'map' | 'report' | 'profile' | 'messages' | 'chat-room' | 'settings' | 'edit-profile';

export default function App() {
  // Start with welcome screen for new users, change to 'home' to skip onboarding
  const [activeScreen, setActiveScreen] = useState<Screen>('welcome');
  const [selectedChatId, setSelectedChatId] = useState<string | null>(null);
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  const handleChatSelect = (chatId: string) => {
    setSelectedChatId(chatId);
    setActiveScreen('chat-room');
  };

  const handleJoinCleanup = () => {
    setActiveScreen('chat-room');
  };

  const handleCompleteAuth = () => {
    setIsAuthenticated(true);
    setActiveScreen('home');
  };

  const handleLogout = () => {
    setIsAuthenticated(false);
    setActiveScreen('welcome');
  };

  const handleSaveProfile = () => {
    setActiveScreen('settings');
  };

  const renderScreen = () => {
    // Authentication screens
    if (!isAuthenticated) {
      switch (activeScreen) {
        case 'welcome':
          return (
            <WelcomeScreen
              onSelectCitizen={() => setActiveScreen('citizen-signup')}
              onSelectNGO={() => setActiveScreen('ngo-signup')}
              onLogin={() => setActiveScreen('login')}
            />
          );
        case 'citizen-signup':
          return (
            <CitizenSignup
              onBack={() => setActiveScreen('welcome')}
              onComplete={handleCompleteAuth}
              onSwitchToLogin={() => setActiveScreen('login')}
            />
          );
        case 'ngo-signup':
          return (
            <NGOSignup
              onBack={() => setActiveScreen('welcome')}
              onComplete={handleCompleteAuth}
              onSwitchToLogin={() => setActiveScreen('login')}
            />
          );
        case 'login':
          return (
            <LoginScreen
              onBack={() => setActiveScreen('welcome')}
              onComplete={handleCompleteAuth}
            />
          );
        default:
          return (
            <WelcomeScreen
              onSelectCitizen={() => setActiveScreen('citizen-signup')}
              onSelectNGO={() => setActiveScreen('ngo-signup')}
              onLogin={() => setActiveScreen('login')}
            />
          );
      }
    }

    // Main app screens (after authentication)
    switch (activeScreen) {
      case 'home':
        return <HomeFeed onSettingsClick={() => setActiveScreen('settings')} />;
      case 'map':
        return <MapView onJoinCleanup={handleJoinCleanup} />;
      case 'report':
        return <ReportForm onComplete={() => setActiveScreen('home')} />;
      case 'messages':
        return <ChatList onChatSelect={handleChatSelect} />;
      case 'chat-room':
        return <ChatRoom onBack={() => setActiveScreen('messages')} />;
      case 'profile':
        return <Profile />;
      case 'settings':
        return (
          <SettingsPage
            onBack={() => setActiveScreen('home')}
            onEditProfile={() => setActiveScreen('edit-profile')}
            onLogout={handleLogout}
          />
        );
      case 'edit-profile':
        return (
          <EditProfile
            onBack={() => setActiveScreen('settings')}
            onSave={handleSaveProfile}
          />
        );
      default:
        return <HomeFeed onSettingsClick={() => setActiveScreen('settings')} />;
    }
  };

  return (
    <div className="h-screen flex flex-col bg-gray-50">
      {/* Main Content */}
      <div className="flex-1 overflow-hidden">
        {renderScreen()}
      </div>

      {/* Bottom Navigation - Only show when authenticated */}
      {isAuthenticated && (
        <nav className="bg-white border-t border-gray-200 px-4 py-3 safe-area-bottom">
        <div className="flex justify-between items-center max-w-md mx-auto">
          <button
            onClick={() => setActiveScreen('home')}
            className={`flex flex-col items-center gap-1 px-3 py-2 rounded-2xl transition-colors ${
              activeScreen === 'home' ? 'text-emerald-600' : 'text-gray-500'
            }`}
          >
            <Home className="w-6 h-6" fill={activeScreen === 'home' ? 'currentColor' : 'none'} />
            <span className="text-xs">Watch</span>
          </button>
          
          <button
            onClick={() => setActiveScreen('map')}
            className={`flex flex-col items-center gap-1 px-3 py-2 rounded-2xl transition-colors ${
              activeScreen === 'map' ? 'text-emerald-600' : 'text-gray-500'
            }`}
          >
            <Map className="w-6 h-6" fill={activeScreen === 'map' ? 'currentColor' : 'none'} />
            <span className="text-xs">Do</span>
          </button>
          
          <button
            onClick={() => setActiveScreen('report')}
            className="flex items-center justify-center w-14 h-14 bg-emerald-600 rounded-full shadow-lg -mt-6 transition-transform hover:scale-105"
          >
            <Plus className="w-7 h-7 text-white" strokeWidth={3} />
          </button>
          
          <button
            onClick={() => setActiveScreen('messages')}
            className={`flex flex-col items-center gap-1 px-3 py-2 rounded-2xl transition-colors relative ${
              activeScreen === 'messages' || activeScreen === 'chat-room' ? 'text-emerald-600' : 'text-gray-500'
            }`}
          >
            <MessageCircle className="w-6 h-6" fill={activeScreen === 'messages' || activeScreen === 'chat-room' ? 'currentColor' : 'none'} />
            <span className="text-xs">Message</span>
            {/* Unread Badge */}
            <div className="absolute top-1 right-2 w-2 h-2 bg-red-500 rounded-full" />
          </button>
          
          <button
            onClick={() => setActiveScreen('profile')}
            className={`flex flex-col items-center gap-1 px-3 py-2 rounded-2xl transition-colors ${
              activeScreen === 'profile' ? 'text-emerald-600' : 'text-gray-500'
            }`}
          >
            <User className="w-6 h-6" fill={activeScreen === 'profile' ? 'currentColor' : 'none'} />
            <span className="text-xs">Profile</span>
          </button>
        </div>
      </nav>
      )}
    </div>
  );
}