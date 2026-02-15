import { useState } from 'react';
import { Award, Calendar, MapPin, Settings, TrendingUp } from 'lucide-react';
import { ImageWithFallback } from './figma/ImageWithFallback';

type Tab = 'reports' | 'events';

type Report = {
  id: string;
  title: string;
  status: 'resolved' | 'in-progress' | 'reported';
  image: string;
  date: string;
  likes: number;
};

const mockReports: Report[] = [
  {
    id: '1',
    title: 'Overflowing bins on Main St',
    status: 'resolved',
    image: 'https://images.unsplash.com/photo-1605600659908-0ef719419d41?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzdHJlZXQlMjBnYXJiYWdlJTIwbGl0dGVyfGVufDF8fHx8MTc2NDQyMzIxOHww&ixlib=rb-4.1.0&q=80&w=1080',
    date: 'Nov 25, 2025',
    likes: 24
  },
  {
    id: '2',
    title: 'Pothole on Oak Avenue',
    status: 'in-progress',
    image: 'https://images.unsplash.com/photo-1709934730506-fba12664d4e4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxyb2FkJTIwcG90aG9sZSUyMGRhbWFnZXxlbnwxfHx8fDE3NjQ0MDE3OTR8MA&ixlib=rb-4.1.0&q=80&w=1080',
    date: 'Nov 27, 2025',
    likes: 42
  },
  {
    id: '3',
    title: 'Graffiti vandalism',
    status: 'reported',
    image: 'https://images.unsplash.com/photo-1613894811137-b5ee44ba3cb3?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx1cmJhbiUyMGdyYWZmaXRpJTIwd2FsbHxlbnwxfHx8fDE3NjQzMTU3OTB8MA&ixlib=rb-4.1.0&q=80&w=1080',
    date: 'Nov 28, 2025',
    likes: 18
  }
];

const mockEvents = [
  {
    id: '1',
    title: 'Central Park Cleanup',
    date: 'Dec 5, 10:00 AM',
    location: 'Central Park',
    volunteers: 15,
    image: 'https://images.unsplash.com/photo-1758599668299-beebedfabf7b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJrJTIwY2xlYW51cCUyMHZvbHVudGVlcnN8ZW58MXx8fHwxNzY0NDIzMjE3fDA&ixlib=rb-4.1.0&q=80&w=1080',
    status: 'upcoming'
  },
  {
    id: '2',
    title: 'Beach Cleanup Drive',
    date: 'Nov 20, 9:00 AM',
    location: 'Sunset Beach',
    volunteers: 23,
    image: 'https://images.unsplash.com/photo-1758599668299-beebedfabf7b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJrJTIwY2xlYW51cCUyMHZvbHVudGVlcnN8ZW58MXx8fHwxNzY0NDIzMjE3fDA&ixlib=rb-4.1.0&q=80&w=1080',
    status: 'completed'
  }
];

export function Profile() {
  const [activeTab, setActiveTab] = useState<Tab>('reports');

  const stats = [
    { label: 'Reports Submitted', value: '15', icon: TrendingUp, color: 'emerald' },
    { label: 'Cleanups Joined', value: '5', icon: Calendar, color: 'blue' },
    { label: 'Impact Score', value: '247', icon: Award, color: 'amber' }
  ];

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'resolved':
        return 'bg-emerald-100 text-emerald-700';
      case 'in-progress':
        return 'bg-blue-100 text-blue-700';
      case 'reported':
        return 'bg-amber-100 text-amber-700';
      default:
        return 'bg-gray-100 text-gray-700';
    }
  };

  const getStatusLabel = (status: string) => {
    switch (status) {
      case 'in-progress':
        return 'In Progress';
      default:
        return status.charAt(0).toUpperCase() + status.slice(1);
    }
  };

  return (
    <div className="h-full flex flex-col bg-white">
      {/* Header */}
      <div className="bg-teal-700 text-white px-6 pt-4 pb-6 safe-area-top">
        <div className="flex items-center justify-between mb-6">
          <h1>Profile</h1>
          <button className="p-2 bg-white/20 rounded-full backdrop-blur">
            <Settings className="w-5 h-5" />
          </button>
        </div>

        {/* User Info */}
        <div className="flex items-center gap-4 mb-6">
          <div className="w-20 h-20 bg-emerald-400 rounded-full flex items-center justify-center text-white shadow-lg">
            <span className="text-2xl">SM</span>
          </div>
          <div>
            <h2 className="text-white mb-1">Sarah Martinez</h2>
            <p className="text-emerald-100">Active Citizen • Level 3</p>
            <div className="flex items-center gap-1 mt-1">
              <MapPin className="w-4 h-4" />
              <span className="text-sm text-emerald-100">Downtown District</span>
            </div>
          </div>
        </div>

        {/* Stats Grid */}
        <div className="grid grid-cols-3 gap-3">
          {stats.map((stat) => {
            const Icon = stat.icon;
            return (
              <div key={stat.label} className="bg-white/10 backdrop-blur rounded-2xl p-3">
                <Icon className="w-5 h-5 mb-2 text-emerald-200" />
                <p className="text-2xl mb-1">{stat.value}</p>
                <p className="text-xs text-emerald-100 leading-tight">{stat.label}</p>
              </div>
            );
          })}
        </div>
      </div>

      {/* Tabs */}
      <div className="flex border-b border-gray-200 bg-white px-6">
        <button
          onClick={() => setActiveTab('reports')}
          className={`flex-1 py-4 text-center transition-colors relative ${
            activeTab === 'reports' ? 'text-emerald-600' : 'text-gray-500'
          }`}
        >
          My Reports
          {activeTab === 'reports' && (
            <div className="absolute bottom-0 left-0 right-0 h-0.5 bg-emerald-600" />
          )}
        </button>
        <button
          onClick={() => setActiveTab('events')}
          className={`flex-1 py-4 text-center transition-colors relative ${
            activeTab === 'events' ? 'text-emerald-600' : 'text-gray-500'
          }`}
        >
          My Events
          {activeTab === 'events' && (
            <div className="absolute bottom-0 left-0 right-0 h-0.5 bg-emerald-600" />
          )}
        </button>
      </div>

      {/* Content */}
      <div className="flex-1 overflow-y-auto bg-gray-50">
        {activeTab === 'reports' ? (
          <div className="p-4 space-y-3">
            {mockReports.map((report) => (
              <div key={report.id} className="bg-white rounded-2xl overflow-hidden shadow-sm">
                <div className="flex gap-3 p-3">
                  <div className="w-20 h-20 rounded-xl overflow-hidden flex-shrink-0">
                    <ImageWithFallback
                      src={report.image}
                      alt={report.title}
                      className="w-full h-full object-cover"
                    />
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-start justify-between gap-2 mb-2">
                      <h3 className="text-gray-900 line-clamp-2">{report.title}</h3>
                      <span className={`px-2 py-1 rounded-full text-xs whitespace-nowrap ${getStatusColor(report.status)}`}>
                        {getStatusLabel(report.status)}
                      </span>
                    </div>
                    <div className="flex items-center gap-3 text-sm text-gray-600">
                      <span>{report.date}</span>
                      <span>•</span>
                      <span>{report.likes} likes</span>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        ) : (
          <div className="p-4 space-y-3">
            {mockEvents.map((event) => (
              <div key={event.id} className="bg-white rounded-2xl overflow-hidden shadow-sm">
                <div className="relative h-32">
                  <ImageWithFallback
                    src={event.image}
                    alt={event.title}
                    className="w-full h-full object-cover"
                  />
                  <div className="absolute top-3 right-3">
                    <span className={`px-3 py-1 rounded-full text-xs text-white ${
                      event.status === 'upcoming' ? 'bg-emerald-600' : 'bg-gray-600'
                    }`}>
                      {event.status === 'upcoming' ? 'Upcoming' : 'Completed'}
                    </span>
                  </div>
                </div>
                <div className="p-4">
                  <h3 className="text-gray-900 mb-2">{event.title}</h3>
                  <div className="space-y-1 text-sm text-gray-600">
                    <div className="flex items-center gap-2">
                      <Calendar className="w-4 h-4" />
                      <span>{event.date}</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <MapPin className="w-4 h-4" />
                      <span>{event.location}</span>
                    </div>
                    <div className="flex items-center gap-2 text-emerald-600">
                      <Award className="w-4 h-4" />
                      <span>{event.volunteers} volunteers joined</span>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
