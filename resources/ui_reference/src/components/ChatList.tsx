import { Search, MessageCircle } from 'lucide-react';
import { ImageWithFallback } from './figma/ImageWithFallback';

type Chat = {
  id: string;
  eventTitle: string;
  lastMessage: string;
  timestamp: string;
  status: 'active' | 'archived';
  unreadCount: number;
  icon: string;
};

const mockChats: Chat[] = [
  {
    id: '1',
    eventTitle: 'Koramangala Park Cleanup',
    lastMessage: 'Sarah: See you all tomorrow at 10 AM!',
    timestamp: '2 min ago',
    status: 'active',
    unreadCount: 3,
    icon: '🌳'
  },
  {
    id: '2',
    eventTitle: 'Main St. Cleanup',
    lastMessage: 'Mike: Brought extra gloves and bags',
    timestamp: '1 hour ago',
    status: 'active',
    unreadCount: 0,
    icon: '🧹'
  },
  {
    id: '3',
    eventTitle: 'Beach Cleanup Drive',
    lastMessage: 'Alex: Great job everyone! 45 bags collected',
    timestamp: 'Yesterday',
    status: 'archived',
    unreadCount: 0,
    icon: '🏖️'
  },
  {
    id: '4',
    eventTitle: 'Downtown Pothole Report',
    lastMessage: 'City Official: Work scheduled for next week',
    timestamp: '2 days ago',
    status: 'active',
    unreadCount: 1,
    icon: '🚧'
  },
  {
    id: '5',
    eventTitle: 'Park Cleanup Team',
    lastMessage: 'Green Warriors: Meeting Point: Main Gate',
    timestamp: '3 days ago',
    status: 'archived',
    unreadCount: 0,
    icon: '🌿'
  }
];

interface ChatListProps {
  onChatSelect: (chatId: string) => void;
}

export function ChatList({ onChatSelect }: ChatListProps) {
  return (
    <div className="h-full flex flex-col bg-white">
      {/* Header */}
      <div className="bg-teal-700 text-white px-6 py-4 safe-area-top">
        <h1>My Cleanups</h1>
      </div>

      {/* Search Bar */}
      <div className="px-4 py-3 bg-white border-b border-gray-200">
        <div className="relative">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
          <input
            type="text"
            placeholder="Search cleanups..."
            className="w-full pl-10 pr-4 py-3 bg-gray-100 rounded-2xl focus:outline-none focus:ring-2 focus:ring-emerald-500"
          />
        </div>
      </div>

      {/* Chat List */}
      <div className="flex-1 overflow-y-auto">
        {mockChats.map((chat) => (
          <button
            key={chat.id}
            onClick={() => onChatSelect(chat.id)}
            className="w-full flex items-center gap-3 px-4 py-4 border-b border-gray-100 hover:bg-gray-50 transition-colors"
          >
            {/* Icon */}
            <div className="w-14 h-14 bg-emerald-100 rounded-full flex items-center justify-center flex-shrink-0 text-2xl">
              {chat.icon}
            </div>

            {/* Content */}
            <div className="flex-1 min-w-0 text-left">
              <div className="flex items-center gap-2 mb-1">
                <h3 className="text-gray-900 truncate">{chat.eventTitle}</h3>
                <span
                  className={`px-2 py-0.5 rounded-full text-xs flex-shrink-0 ${
                    chat.status === 'active'
                      ? 'bg-emerald-100 text-emerald-700'
                      : 'bg-gray-100 text-gray-600'
                  }`}
                >
                  {chat.status === 'active' ? 'Active' : 'Archived'}
                </span>
              </div>
              <p className="text-sm text-gray-500 truncate">{chat.lastMessage}</p>
            </div>

            {/* Right Side */}
            <div className="flex flex-col items-end gap-1 flex-shrink-0">
              <span className="text-xs text-gray-500">{chat.timestamp}</span>
              {chat.unreadCount > 0 && (
                <div className="w-5 h-5 bg-emerald-600 rounded-full flex items-center justify-center">
                  <span className="text-xs text-white">{chat.unreadCount}</span>
                </div>
              )}
            </div>
          </button>
        ))}
      </div>

      {/* Empty State (if no chats) */}
      {mockChats.length === 0 && (
        <div className="flex-1 flex flex-col items-center justify-center p-8 text-center">
          <MessageCircle className="w-16 h-16 text-gray-300 mb-4" />
          <h2 className="text-gray-900 mb-2">No Cleanups Yet</h2>
          <p className="text-gray-600">
            Join a cleanup event to start coordinating with your team
          </p>
        </div>
      )}
    </div>
  );
}
