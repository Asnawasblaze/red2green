import { useState } from 'react';
import { ArrowLeft, Info, Send, Paperclip, Pin } from 'lucide-react';

type Message = {
  id: string;
  sender: string;
  senderType: 'user' | 'volunteer' | 'ngo';
  message: string;
  timestamp: string;
  avatar?: string;
};

const mockMessages: Message[] = [
  {
    id: '1',
    sender: 'Green Warriors NGO',
    senderType: 'ngo',
    message: 'Welcome everyone! Looking forward to cleaning up the park together 🌳',
    timestamp: '9:00 AM',
    avatar: '🌿'
  },
  {
    id: '2',
    sender: 'Mike Chen',
    senderType: 'volunteer',
    message: "I'll bring extra garbage bags and gloves for anyone who needs them",
    timestamp: '9:15 AM',
    avatar: 'M'
  },
  {
    id: '3',
    sender: 'You',
    senderType: 'user',
    message: 'Thanks Mike! What time should we arrive?',
    timestamp: '9:20 AM'
  },
  {
    id: '4',
    sender: 'Green Warriors NGO',
    senderType: 'ngo',
    message: "Meeting at the Main Gate at 10:00 AM sharp. We'll divide into teams from there.",
    timestamp: '9:25 AM',
    avatar: '🌿'
  },
  {
    id: '5',
    sender: 'Sarah M.',
    senderType: 'volunteer',
    message: 'Can I bring my friends? They want to help too!',
    timestamp: '9:30 AM',
    avatar: 'S'
  },
  {
    id: '6',
    sender: 'Green Warriors NGO',
    senderType: 'ngo',
    message: 'Absolutely! The more volunteers, the better. Please ask them to sign up on the app.',
    timestamp: '9:32 AM',
    avatar: '🌿'
  },
  {
    id: '7',
    sender: 'You',
    senderType: 'user',
    message: 'See you all tomorrow at 10 AM! 💪',
    timestamp: '9:45 AM'
  }
];

interface ChatRoomProps {
  eventTitle?: string;
  onBack: () => void;
}

export function ChatRoom({ eventTitle = 'Park Cleanup Team', onBack }: ChatRoomProps) {
  const [messageInput, setMessageInput] = useState('');
  const [messages, setMessages] = useState(mockMessages);

  const handleSend = () => {
    if (messageInput.trim()) {
      const newMessage: Message = {
        id: String(messages.length + 1),
        sender: 'You',
        senderType: 'user',
        message: messageInput,
        timestamp: new Date().toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' })
      };
      setMessages([...messages, newMessage]);
      setMessageInput('');
    }
  };

  return (
    <div className="h-full flex flex-col bg-gray-50">
      {/* Header */}
      <div className="bg-teal-700 text-white px-4 py-3 safe-area-top shadow-md">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <button onClick={onBack} className="p-2 -ml-2 hover:bg-white/10 rounded-full transition-colors">
              <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
              <h2 className="text-white">{eventTitle}</h2>
              <p className="text-xs text-emerald-100">12 members • 8 active now</p>
            </div>
          </div>
          <button className="p-2 hover:bg-white/10 rounded-full transition-colors">
            <Info className="w-5 h-5" />
          </button>
        </div>
      </div>

      {/* Pinned Message */}
      <div className="bg-amber-50 border-b border-amber-200 px-4 py-3 flex items-start gap-3">
        <Pin className="w-5 h-5 text-amber-600 flex-shrink-0 mt-0.5" />
        <div className="flex-1">
          <p className="text-sm text-amber-900">
            <span className="text-amber-700">Meeting Point:</span> Main Gate
          </p>
        </div>
      </div>

      {/* Messages */}
      <div className="flex-1 overflow-y-auto px-4 py-4 space-y-4">
        {messages.map((msg) => (
          <div
            key={msg.id}
            className={`flex gap-2 ${msg.senderType === 'user' ? 'flex-row-reverse' : 'flex-row'}`}
          >
            {/* Avatar */}
            {msg.senderType !== 'user' && (
              <div className="w-8 h-8 rounded-full bg-emerald-100 flex items-center justify-center flex-shrink-0 text-sm">
                {msg.avatar}
              </div>
            )}

            {/* Message Bubble */}
            <div className={`max-w-[75%] ${msg.senderType === 'user' ? 'items-end' : 'items-start'}`}>
              {msg.senderType !== 'user' && (
                <p className="text-xs text-gray-600 mb-1 px-3">
                  {msg.sender}
                  {msg.senderType === 'ngo' && (
                    <span className="ml-1 px-2 py-0.5 bg-emerald-100 text-emerald-700 rounded-full text-xs">
                      NGO
                    </span>
                  )}
                </p>
              )}
              <div
                className={`px-4 py-3 rounded-2xl ${
                  msg.senderType === 'user'
                    ? 'bg-emerald-600 text-white rounded-br-sm'
                    : 'bg-white text-gray-900 rounded-bl-sm shadow-sm'
                }`}
              >
                <p className="text-sm">{msg.message}</p>
              </div>
              <p className={`text-xs text-gray-500 mt-1 px-3 ${msg.senderType === 'user' ? 'text-right' : 'text-left'}`}>
                {msg.timestamp}
              </p>
            </div>
          </div>
        ))}
      </div>

      {/* Input Area */}
      <div className="bg-white border-t border-gray-200 px-4 py-3 safe-area-bottom">
        <div className="flex items-center gap-2">
          {/* Attachment Button */}
          <button className="p-2 text-gray-500 hover:bg-gray-100 rounded-full transition-colors">
            <Paperclip className="w-5 h-5" />
          </button>

          {/* Text Input */}
          <input
            type="text"
            value={messageInput}
            onChange={(e) => setMessageInput(e.target.value)}
            onKeyPress={(e) => e.key === 'Enter' && handleSend()}
            placeholder="Type a message..."
            className="flex-1 px-4 py-3 bg-gray-100 rounded-full focus:outline-none focus:ring-2 focus:ring-emerald-500"
          />

          {/* Send Button */}
          <button
            onClick={handleSend}
            disabled={!messageInput.trim()}
            className="p-3 bg-emerald-600 text-white rounded-full hover:bg-emerald-700 transition-colors disabled:bg-gray-300 disabled:cursor-not-allowed"
          >
            <Send className="w-5 h-5" />
          </button>
        </div>
      </div>
    </div>
  );
}
