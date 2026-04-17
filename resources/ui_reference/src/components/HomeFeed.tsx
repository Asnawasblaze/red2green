import { Heart, Share2, MapPin, Filter, Settings } from 'lucide-react';
import { ImageWithFallback } from './figma/ImageWithFallback';
import { useState } from 'react';

interface HomeFeedProps {
  onSettingsClick?: () => void;
}

type Issue = {
  id: string;
  reportedBy: string;
  timeAgo: string;
  status: 'reported' | 'resolved';
  image: string;
  title: string;
  location: string;
  distance: string;
  likes: number;
};

const mockIssues: Issue[] = [
  {
    id: '1',
    reportedBy: 'Sarah M.',
    timeAgo: '2 hours ago',
    status: 'reported',
    image: 'https://images.unsplash.com/photo-1530587191325-3db32d826c18?w=800',
    title: 'Overflowing garbage bin near park entrance',
    location: 'Central Park',
    distance: '0.5 km away',
    likes: 12
  },
  {
    id: '2',
    reportedBy: 'Raj K.',
    timeAgo: '5 hours ago',
    status: 'reported',
    image: 'https://images.unsplash.com/photo-1611284446314-60a58ac0deb9?w=800',
    title: 'Large pothole damaging vehicles',
    location: 'Main Street',
    distance: '1.2 km away',
    likes: 8
  },
  {
    id: '3',
    reportedBy: 'Green Warriors NGO',
    timeAgo: '1 day ago',
    status: 'resolved',
    image: 'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=800',
    title: 'Beach cleanup completed successfully!',
    location: 'Sunset Beach',
    distance: '3 km away',
    likes: 45
  }
];

export function HomeFeed({ onSettingsClick }: HomeFeedProps = {}) {
  const [likedIssues, setLikedIssues] = useState<Set<string>>(new Set());
  const [filterOpen, setFilterOpen] = useState(false);

  const toggleLike = (issueId: string) => {
    setLikedIssues(prev => {
      const newSet = new Set(prev);
      if (newSet.has(issueId)) {
        newSet.delete(issueId);
      } else {
        newSet.add(issueId);
      }
      return newSet;
    });
  };

  return (
    <div className="h-full flex flex-col bg-white">
      {/* Header */}
      <div className="bg-teal-700 text-white px-6 py-4 safe-area-top">
        <div className="flex items-center justify-between mb-3">
          <h1>Red2Green</h1>
          <button
            className="p-2 hover:bg-white/10 rounded-full transition-colors"
            onClick={onSettingsClick}
          >
            <Settings className="w-6 h-6" />
          </button>
        </div>

        {/* Location Filter Bar */}
        <div className="flex gap-2 overflow-x-auto pb-2 -mx-6 px-6 scrollbar-hide">
          <button className="flex items-center gap-2 px-4 py-2 bg-white/20 rounded-full whitespace-nowrap backdrop-blur">
            <MapPin className="w-4 h-4" />
            <span className="text-sm">Near Me</span>
          </button>
          <button
            onClick={() => setFilterOpen(!filterOpen)}
            className="flex items-center gap-2 px-4 py-2 bg-white/20 rounded-full whitespace-nowrap backdrop-blur"
          >
            <Filter className="w-4 h-4" />
            <span className="text-sm">All Issues</span>
          </button>
          <button className="px-4 py-2 bg-white/20 rounded-full text-sm whitespace-nowrap backdrop-blur">
            Garbage
          </button>
          <button className="px-4 py-2 bg-white/20 rounded-full text-sm whitespace-nowrap backdrop-blur">
            Potholes
          </button>
        </div>
      </div>

      {/* Feed */}
      <div className="flex-1 overflow-y-auto">
        <div className="max-w-2xl mx-auto">
          {mockIssues.map((issue) => (
            <div key={issue.id} className="bg-white mb-3 border-b border-gray-200">
              {/* Card Header */}
              <div className="px-4 py-3 flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 bg-emerald-100 rounded-full flex items-center justify-center">
                    <span className="text-emerald-700">{issue.reportedBy[0]}</span>
                  </div>
                  <div>
                    <p className="text-gray-900">{issue.reportedBy}</p>
                    <p className="text-xs text-gray-500">{issue.timeAgo}</p>
                  </div>
                </div>
                <span
                  className={`px-3 py-1 rounded-full text-xs ${issue.status === 'resolved'
                      ? 'bg-emerald-100 text-emerald-700'
                      : 'bg-amber-100 text-amber-700'
                    }`}
                >
                  {issue.status === 'resolved' ? 'Resolved' : 'Reported'}
                </span>
              </div>

              {/* Image */}
              <div className="relative aspect-square">
                <ImageWithFallback
                  src={issue.image}
                  alt={issue.title}
                  className="w-full h-full object-cover"
                />
              </div>

              {/* Actions */}
              <div className="px-4 py-3">
                <div className="flex items-center gap-4 mb-3">
                  <button
                    onClick={() => toggleLike(issue.id)}
                    className="flex items-center gap-2 transition-colors"
                  >
                    <Heart
                      className={`w-6 h-6 ${likedIssues.has(issue.id)
                          ? 'fill-red-500 text-red-500'
                          : 'text-gray-700'
                        }`}
                    />
                    <span className="text-sm text-gray-700">
                      {issue.likes + (likedIssues.has(issue.id) ? 1 : 0)}
                    </span>
                  </button>
                  <button className="flex items-center gap-2">
                    <Share2 className="w-6 h-6 text-gray-700" />
                  </button>
                </div>

                {/* Details */}
                <div className="space-y-1">
                  <p className="text-gray-900">{issue.title}</p>
                  <div className="flex items-center gap-2 text-sm text-gray-600">
                    <MapPin className="w-4 h-4" />
                    <span>{issue.location}</span>
                    <span>•</span>
                    <span>{issue.distance}</span>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}