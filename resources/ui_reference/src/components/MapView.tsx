import { useState } from 'react';
import { MapPin, Navigation, X, Users, Calendar, AlertCircle } from 'lucide-react';
import { ImageWithFallback } from './figma/ImageWithFallback';
import { motion, AnimatePresence } from 'motion/react';
import { ClaimEventForm, EventFormData } from './ClaimEventForm';

type Pin = {
  id: string;
  type: 'urgent' | 'reported';
  position: { x: number; y: number };
  issue: {
    title: string;
    location: string;
    image: string;
    volunteers: number;
    date: string;
    description: string;
  };
};

const mockPins: Pin[] = [
  {
    id: '1',
    type: 'urgent',
    position: { x: 35, y: 45 },
    issue: {
      title: 'Overflowing garbage bins',
      location: 'Main Street, Downtown',
      image: 'https://images.unsplash.com/photo-1605600659908-0ef719419d41?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzdHJlZXQlMjBnYXJiYWdlJTIwbGl0dGVyfGVufDF8fHx8MTc2NDQyMzIxOHww&ixlib=rb-4.1.0&q=80&w=1080',
      volunteers: 3,
      date: 'Tomorrow, 9:00 AM',
      description: 'Multiple bins overflowing, attracting pests. Immediate cleanup needed.'
    }
  },
  {
    id: '2',
    type: 'urgent',
    position: { x: 65, y: 30 },
    issue: {
      title: 'Large pothole hazard',
      location: 'Oak Avenue & 5th St',
      image: 'https://images.unsplash.com/photo-1709934730506-fba12664d4e4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxyb2FkJTIwcG90aG9sZSUyMGRhbWFnZXxlbnwxfHx8fDE3NjQ0MDE3OTR8MA&ixlib=rb-4.1.0&q=80&w=1080',
      volunteers: 0,
      date: 'Dec 2, 2:00 PM',
      description: 'Deep pothole causing traffic issues. Requires city maintenance coordination.'
    }
  },
  {
    id: '3',
    type: 'reported',
    position: { x: 50, y: 60 },
    issue: {
      title: 'Park cleanup event',
      location: 'Central Park',
      image: 'https://images.unsplash.com/photo-1758599668299-beebedfabf7b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJrJTIwY2xlYW51cCUyMHZvbHVudGVlcnN8ZW58MXx8fHwxNzY0NDIzMjE3fDA&ixlib=rb-4.1.0&q=80&w=1080',
      volunteers: 15,
      date: 'Dec 5, 10:00 AM',
      description: 'Weekly community cleanup event. Bags and gloves provided. All welcome!'
    }
  },
  {
    id: '4',
    type: 'reported',
    position: { x: 25, y: 70 },
    issue: {
      title: 'Graffiti vandalism',
      location: 'Jefferson Street',
      image: 'https://images.unsplash.com/photo-1613894811137-b5ee44ba3cb3?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx1cmJhbiUyMGdyYWZmaXRpJTIwd2FsbHxlbnwxfHx8fDE3NjQzMTU3OTB8MA&ixlib=rb-4.1.0&q=80&w=1080',
      volunteers: 1,
      date: 'Dec 3, 3:00 PM',
      description: 'Unauthorized graffiti on public property. Paint supplies needed.'
    }
  }
];

interface MapViewProps {
  onJoinCleanup?: () => void;
  userType?: 'citizen' | 'ngo';
}

export function MapView({ onJoinCleanup, userType = 'citizen' }: MapViewProps) {
  const [selectedPin, setSelectedPin] = useState<Pin | null>(null);
  const [showClaimForm, setShowClaimForm] = useState(false);

  const handleClaimIssue = () => {
    setShowClaimForm(true);
  };

  const handleConfirmClaim = (eventData: EventFormData) => {
    console.log('Event claimed:', eventData);
    setShowClaimForm(false);
    setSelectedPin(null);
    // Show success screen
  };

  return (
    <div className="h-full relative bg-gray-200">
      {/* Header */}
      <div className="absolute top-0 left-0 right-0 z-10 bg-teal-700 text-white px-6 py-4 safe-area-top shadow-lg">
        <div className="flex items-center justify-between">
          <h1>Explore Issues</h1>
          <button className="p-2 bg-white/20 rounded-full backdrop-blur">
            <Navigation className="w-5 h-5" />
          </button>
        </div>
      </div>

      {/* Map Container - Simplified visual representation */}
      <div className="h-full w-full bg-gradient-to-br from-gray-100 to-gray-300 relative">
        {/* Map Grid Pattern */}
        <div className="absolute inset-0 opacity-20">
          {[...Array(20)].map((_, i) => (
            <div
              key={`h-${i}`}
              className="absolute w-full border-t border-gray-400"
              style={{ top: `${i * 5}%` }}
            />
          ))}
          {[...Array(20)].map((_, i) => (
            <div
              key={`v-${i}`}
              className="absolute h-full border-l border-gray-400"
              style={{ left: `${i * 5}%` }}
            />
          ))}
        </div>

        {/* Mock Streets */}
        <div className="absolute w-full h-2 bg-white opacity-30 top-1/3 rotate-12" />
        <div className="absolute w-2 h-full bg-white opacity-30 left-1/4 -rotate-6" />
        <div className="absolute w-full h-2 bg-white opacity-30 top-2/3 -rotate-6" />

        {/* Location Pins */}
        {mockPins.map((pin) => (
          <button
            key={pin.id}
            onClick={() => setSelectedPin(pin)}
            className="absolute transform -translate-x-1/2 -translate-y-full transition-transform hover:scale-110"
            style={{
              left: `${pin.position.x}%`,
              top: `${pin.position.y}%`
            }}
          >
            <MapPin
              className={`w-10 h-10 drop-shadow-lg ${
                pin.type === 'urgent'
                  ? 'text-red-500 fill-red-500'
                  : 'text-amber-500 fill-amber-500'
              }`}
            />
          </button>
        ))}

        {/* Current Location Indicator */}
        <div className="absolute left-1/2 top-1/2 transform -translate-x-1/2 -translate-y-1/2">
          <div className="w-4 h-4 bg-blue-500 rounded-full border-4 border-white shadow-lg animate-pulse" />
        </div>
      </div>

      {/* Floating Legend */}
      <div className="absolute top-24 right-4 bg-white rounded-2xl shadow-lg p-3 space-y-2">
        <div className="flex items-center gap-2">
          <MapPin className="w-5 h-5 text-red-500 fill-red-500" />
          <span className="text-xs text-gray-700">Urgent</span>
        </div>
        <div className="flex items-center gap-2">
          <MapPin className="w-5 h-5 text-amber-500 fill-amber-500" />
          <span className="text-xs text-gray-700">Reported</span>
        </div>
      </div>

      {/* Bottom Drawer */}
      <AnimatePresence>
        {selectedPin && (
          <motion.div
            initial={{ y: '100%' }}
            animate={{ y: 0 }}
            exit={{ y: '100%' }}
            transition={{ type: 'spring', damping: 30, stiffness: 300 }}
            className="absolute bottom-0 left-0 right-0 bg-white rounded-t-3xl shadow-2xl max-h-[70%] overflow-hidden"
          >
            {/* Drawer Handle */}
            <div className="flex justify-center py-3">
              <div className="w-12 h-1 bg-gray-300 rounded-full" />
            </div>

            {/* Close Button */}
            <button
              onClick={() => setSelectedPin(null)}
              className="absolute top-4 right-4 p-2 bg-gray-100 rounded-full z-10"
            >
              <X className="w-5 h-5 text-gray-600" />
            </button>

            {/* Content */}
            <div className="px-6 pb-8 overflow-y-auto max-h-full">
              {/* Image */}
              <div className="relative w-full h-48 rounded-2xl overflow-hidden mb-4">
                <ImageWithFallback
                  src={selectedPin.issue.image}
                  alt={selectedPin.issue.title}
                  className="w-full h-full object-cover"
                />
                <div className="absolute top-3 left-3">
                  <span
                    className={`px-3 py-1 rounded-full text-xs ${
                      selectedPin.type === 'urgent'
                        ? 'bg-red-500 text-white'
                        : 'bg-amber-500 text-white'
                    }`}
                  >
                    {selectedPin.type === 'urgent' ? (
                      <span className="flex items-center gap-1">
                        <AlertCircle className="w-3 h-3" />
                        Urgent
                      </span>
                    ) : (
                      'Reported'
                    )}
                  </span>
                </div>
              </div>

              {/* Details */}
              <h2 className="mb-2">{selectedPin.issue.title}</h2>
              <p className="text-gray-600 mb-4">{selectedPin.issue.location}</p>

              <div className="flex items-center gap-4 mb-4 text-sm text-gray-700">
                <div className="flex items-center gap-2">
                  <Users className="w-5 h-5 text-emerald-600" />
                  <span>{selectedPin.issue.volunteers} volunteers</span>
                </div>
                <div className="flex items-center gap-2">
                  <Calendar className="w-5 h-5 text-emerald-600" />
                  <span>{selectedPin.issue.date}</span>
                </div>
              </div>

              <p className="text-gray-700 mb-6">{selectedPin.issue.description}</p>

              {/* Action Button */}
              {userType === 'ngo' ? (
                <button
                  onClick={handleClaimIssue}
                  className="w-full bg-emerald-600 text-white py-4 rounded-2xl shadow-lg hover:bg-emerald-700 transition-colors"
                >
                  Claim Issue
                </button>
              ) : (
                <button
                  onClick={() => {
                    onJoinCleanup?.();
                    setSelectedPin(null);
                  }}
                  className="w-full bg-emerald-600 text-white py-4 rounded-2xl shadow-lg hover:bg-emerald-700 transition-colors"
                >
                  Join Cleanup Event
                </button>
              )}
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Claim Event Form */}
      {showClaimForm && selectedPin && (
        <ClaimEventForm
          issueName={selectedPin.issue.title}
          issueLocation={selectedPin.issue.location}
          onClose={() => setShowClaimForm(false)}
          onConfirm={handleConfirmClaim}
        />
      )}
    </div>
  );
}