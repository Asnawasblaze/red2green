import { 
  ArrowLeft, 
  Edit, 
  Star, 
  Share2, 
  FileText, 
  Heart, 
  Mail, 
  MessageSquare, 
  LogOut,
  ChevronRight
} from 'lucide-react';

interface SettingsPageProps {
  onBack: () => void;
  onEditProfile: () => void;
  onLogout: () => void;
}

type MenuItem = {
  id: string;
  label: string;
  icon: typeof Edit;
  color: string;
  action: () => void;
};

export function SettingsPage({ onBack, onEditProfile, onLogout }: SettingsPageProps) {
  const handleRateApp = () => {
    console.log('Rate app');
  };

  const handleShareApp = () => {
    console.log('Share app');
  };

  const handleTerms = () => {
    console.log('View terms');
  };

  const handleDonate = () => {
    console.log('Donate');
  };

  const handleContact = () => {
    console.log('Contact us');
  };

  const handleFeedback = () => {
    console.log('Send feedback');
  };

  const menuItems: MenuItem[] = [
    {
      id: 'edit-profile',
      label: 'Edit Profile',
      icon: Edit,
      color: 'text-blue-600',
      action: onEditProfile
    },
    {
      id: 'rate-app',
      label: 'Rate App',
      icon: Star,
      color: 'text-amber-600',
      action: handleRateApp
    },
    {
      id: 'share-app',
      label: 'Share App',
      icon: Share2,
      color: 'text-emerald-600',
      action: handleShareApp
    },
    {
      id: 'terms',
      label: 'Terms & Conditions',
      icon: FileText,
      color: 'text-gray-600',
      action: handleTerms
    },
    {
      id: 'donate',
      label: 'Donate Us',
      icon: Heart,
      color: 'text-red-600',
      action: handleDonate
    },
    {
      id: 'contact',
      label: 'Contact',
      icon: Mail,
      color: 'text-teal-600',
      action: handleContact
    },
    {
      id: 'feedback',
      label: 'Feedback',
      icon: MessageSquare,
      color: 'text-purple-600',
      action: handleFeedback
    }
  ];

  return (
    <div className="h-full flex flex-col bg-white">
      {/* Header */}
      <div className="bg-teal-700 text-white px-6 py-4 safe-area-top">
        <div className="flex items-center gap-3">
          <button onClick={onBack} className="p-2 -ml-2 hover:bg-white/10 rounded-full transition-colors">
            <ArrowLeft className="w-5 h-5" />
          </button>
          <h1 className="text-white">Settings</h1>
        </div>
      </div>

      {/* Menu Items */}
      <div className="flex-1 overflow-y-auto">
        {/* User Info Section */}
        <div className="px-6 py-6 border-b border-gray-200">
          <div className="flex items-center gap-4">
            <div className="w-16 h-16 bg-emerald-400 rounded-full flex items-center justify-center text-white shadow-md">
              <span className="text-2xl">SM</span>
            </div>
            <div>
              <h3 className="text-gray-900">Sarah Martinez</h3>
              <p className="text-sm text-gray-600">sarah.m@example.com</p>
            </div>
          </div>
        </div>

        {/* Menu List */}
        <div className="py-2">
          {menuItems.map((item) => {
            const Icon = item.icon;
            return (
              <button
                key={item.id}
                onClick={item.action}
                className="w-full flex items-center justify-between px-6 py-4 hover:bg-gray-50 transition-colors"
              >
                <div className="flex items-center gap-4">
                  <div className="w-10 h-10 bg-gray-100 rounded-full flex items-center justify-center">
                    <Icon className={`w-5 h-5 ${item.color}`} />
                  </div>
                  <span className="text-gray-900">{item.label}</span>
                </div>
                <ChevronRight className="w-5 h-5 text-gray-400" />
              </button>
            );
          })}
        </div>

        {/* Logout Button */}
        <div className="px-6 py-4">
          <button
            onClick={onLogout}
            className="w-full flex items-center justify-center gap-3 px-6 py-4 bg-red-50 text-red-600 rounded-2xl hover:bg-red-100 transition-colors"
          >
            <LogOut className="w-5 h-5" />
            <span>Log Out</span>
          </button>
        </div>

        {/* App Version */}
        <div className="px-6 py-4 text-center text-sm text-gray-500">
          Version 1.0.0
        </div>
      </div>
    </div>
  );
}
