import { useState } from 'react';
import { 
  ArrowLeft, 
  Camera, 
  MapPin, 
  Calendar, 
  Users, 
  Award,
  CheckCircle,
  Clock,
  Edit
} from 'lucide-react';
import { ImageWithFallback } from './figma/ImageWithFallback';

interface NGOProfileProps {
  onBack: () => void;
  isOwnProfile?: boolean;
}

type EventItem = {
  id: string;
  title: string;
  date: string;
  location: string;
  volunteers: number;
  status: 'upcoming' | 'ongoing' | 'completed';
};

const mockEvents: EventItem[] = [
  {
    id: '1',
    title: 'Park Cleanup Drive',
    date: 'Dec 10, 2025 • 10:00 AM',
    location: 'Central Park',
    volunteers: 15,
    status: 'upcoming'
  },
  {
    id: '2',
    title: 'Beach Cleanup Event',
    date: 'Dec 8, 2025 • 9:00 AM',
    location: 'Sunset Beach',
    volunteers: 23,
    status: 'ongoing'
  },
  {
    id: '3',
    title: 'Community Garden Cleanup',
    date: 'Dec 1, 2025 • 3:00 PM',
    location: 'Community Garden',
    volunteers: 12,
    status: 'completed'
  }
];

export function NGOProfile({ onBack, isOwnProfile = true }: NGOProfileProps) {
  const [verificationStatus, setVerificationStatus] = useState<'verified' | 'pending'>('verified');

  const stats = [
    { label: 'Issues Resolved', value: '75', icon: CheckCircle },
    { label: 'Volunteer Hours', value: '5,000', icon: Clock },
    { label: 'Active Volunteers', value: '234', icon: Users },
    { label: 'Impact Score', value: '892', icon: Award }
  ];

  return (
    <div className="h-full flex flex-col bg-white overflow-y-auto">
      {/* Header */}
      <div className="bg-teal-700 text-white px-6 py-4 safe-area-top flex items-center gap-3">
        <button onClick={onBack} className="p-2 -ml-2 hover:bg-white/10 rounded-full transition-colors">
          <ArrowLeft className="w-5 h-5" />
        </button>
        <h1 className="text-white">NGO Profile</h1>
      </div>

      {/* Banner Section */}
      <div className="relative">
        {/* Banner Image */}
        <div className="relative h-40 bg-gradient-to-r from-emerald-600 to-teal-600">
          <ImageWithFallback
            src="https://images.unsplash.com/photo-1758599668299-beebedfabf7b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJrJTIwY2xlYW51cCUyMHZvbHVudGVlcnN8ZW58MXx8fHwxNzY0NDIzMjE3fDA&ixlib=rb-4.1.0&q=80&w=1080"
            alt="NGO Banner"
            className="w-full h-full object-cover opacity-70"
          />
          {isOwnProfile && (
            <button className="absolute top-3 right-3 p-2 bg-black/40 backdrop-blur-sm text-white rounded-full hover:bg-black/60 transition-colors">
              <Camera className="w-5 h-5" />
            </button>
          )}
        </div>

        {/* Profile Photo */}
        <div className="absolute -bottom-12 left-6">
          <div className="relative">
            <div className="w-24 h-24 bg-white rounded-2xl shadow-lg p-2 border-4 border-white">
              <div className="w-full h-full bg-emerald-600 rounded-xl flex items-center justify-center text-white">
                <span className="text-3xl">🌿</span>
              </div>
            </div>
            {isOwnProfile && (
              <button className="absolute -bottom-1 -right-1 p-2 bg-emerald-600 text-white rounded-full shadow-lg hover:bg-emerald-700 transition-colors">
                <Edit className="w-4 h-4" />
              </button>
            )}
          </div>
        </div>
      </div>

      {/* Content */}
      <div className="pt-16 px-6 pb-6">
        {/* NGO Header Details */}
        <div className="mb-6">
          <div className="flex items-start justify-between mb-2">
            <div>
              <h2 className="text-gray-900 mb-1">Green Warriors NGO</h2>
              <div className="flex items-center gap-2">
                <MapPin className="w-4 h-4 text-gray-500" />
                <span className="text-sm text-gray-600">Mumbai, Maharashtra</span>
              </div>
            </div>
            <span
              className={`px-3 py-1.5 rounded-full text-xs flex items-center gap-1.5 ${
                verificationStatus === 'verified'
                  ? 'bg-emerald-100 text-emerald-700 border border-emerald-300'
                  : 'bg-amber-100 text-amber-700 border border-amber-300'
              }`}
            >
              {verificationStatus === 'verified' ? (
                <>
                  <CheckCircle className="w-3.5 h-3.5" />
                  VERIFIED
                </>
              ) : (
                <>
                  <Clock className="w-3.5 h-3.5" />
                  PENDING
                </>
              )}
            </span>
          </div>

          {/* Mission Statement */}
          <div className="mt-4 p-4 bg-teal-50 border-l-4 border-teal-600 rounded-r-xl">
            <h3 className="text-sm text-teal-900 mb-2">Mission Statement</h3>
            <p className="text-sm text-teal-800">
              Dedicated to creating cleaner, greener communities through grassroots environmental action. 
              We empower citizens to take ownership of their neighborhoods and drive sustainable change.
            </p>
          </div>
        </div>

        {/* Statistics Section */}
        <div className="mb-6">
          <h3 className="text-gray-900 mb-3">Impact Statistics</h3>
          <div className="grid grid-cols-2 gap-3">
            {stats.map((stat) => {
              const Icon = stat.icon;
              return (
                <div key={stat.label} className="bg-gradient-to-br from-emerald-50 to-teal-50 rounded-2xl p-4 border border-emerald-200">
                  <Icon className="w-6 h-6 text-emerald-600 mb-2" />
                  <p className="text-2xl text-gray-900 mb-1">{stat.value}</p>
                  <p className="text-xs text-gray-600">{stat.label}</p>
                </div>
              );
            })}
          </div>
        </div>

        {/* Active Events */}
        <div>
          <div className="flex items-center justify-between mb-3">
            <h3 className="text-gray-900">Active Events</h3>
            <span className="text-sm text-emerald-600">{mockEvents.length} events</span>
          </div>

          <div className="space-y-3">
            {mockEvents.map((event) => (
              <div
                key={event.id}
                className="bg-white border border-gray-200 rounded-2xl p-4 hover:shadow-md transition-shadow"
              >
                <div className="flex items-start justify-between mb-2">
                  <h4 className="text-gray-900 flex-1">{event.title}</h4>
                  <span
                    className={`px-2 py-1 rounded-full text-xs ${
                      event.status === 'upcoming'
                        ? 'bg-blue-100 text-blue-700'
                        : event.status === 'ongoing'
                        ? 'bg-emerald-100 text-emerald-700'
                        : 'bg-gray-100 text-gray-700'
                    }`}
                  >
                    {event.status.charAt(0).toUpperCase() + event.status.slice(1)}
                  </span>
                </div>

                <div className="space-y-1.5 text-sm text-gray-600">
                  <div className="flex items-center gap-2">
                    <Calendar className="w-4 h-4" />
                    <span>{event.date}</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <MapPin className="w-4 h-4" />
                    <span>{event.location}</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <Users className="w-4 h-4 text-emerald-600" />
                    <span className="text-emerald-600">{event.volunteers} volunteers joined</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
