import { User, Building2 } from 'lucide-react';
import { ImageWithFallback } from './figma/ImageWithFallback';

interface WelcomeScreenProps {
  onSelectCitizen: () => void;
  onSelectNGO: () => void;
  onLogin?: () => void;
}

export function WelcomeScreen({ onSelectCitizen, onSelectNGO, onLogin }: WelcomeScreenProps) {
  return (
    <div className="h-screen flex flex-col bg-white">
      {/* Header */}
      <div className="px-6 pt-12 pb-6 text-center safe-area-top">
        <div className="inline-flex items-center gap-2 mb-2">
          <div className="w-10 h-10 bg-emerald-600 rounded-full flex items-center justify-center">
            <span className="text-white text-xl">🌱</span>
          </div>
          <h1 className="text-emerald-700">Red2Green</h1>
        </div>
      </div>

      {/* Illustration */}
      <div className="flex-1 flex items-center justify-center px-6">
        <div className="w-full max-w-md">
          <div className="relative aspect-square mb-8 rounded-3xl overflow-hidden">
            <ImageWithFallback
              src="https://images.unsplash.com/photo-1559027615-cd4628902d4a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxoYXBweSUyMG5laWdoYm9yaG9vZCUyMGNvbW11bml0eXxlbnwxfHx8fDE3NjQ0MjM4Nzl8MA&ixlib=rb-4.1.0&q=80&w=1080"
              alt="Clean neighborhood"
              className="w-full h-full object-cover"
            />
            <div className="absolute inset-0 bg-gradient-to-t from-emerald-50/50 to-transparent" />
          </div>

          <div className="text-center mb-8">
            <h2 className="text-gray-900 mb-3">Let's clean our city, together.</h2>
            <p className="text-gray-600">
              Join thousands of citizens, volunteers, and NGOs making our neighborhoods cleaner and greener.
            </p>
          </div>
        </div>
      </div>

      {/* Action Buttons */}
      <div className="px-6 pb-8 space-y-4 safe-area-bottom">
        <button
          onClick={onSelectCitizen}
          className="w-full flex items-center justify-center gap-3 bg-emerald-600 text-white py-4 rounded-2xl shadow-lg hover:bg-emerald-700 transition-colors"
        >
          <User className="w-6 h-6" />
          <span>I want to Report or Volunteer</span>
        </button>

        <button
          onClick={onSelectNGO}
          className="w-full flex items-center justify-center gap-3 bg-white border-2 border-emerald-600 text-emerald-700 py-4 rounded-2xl hover:bg-emerald-50 transition-colors"
        >
          <Building2 className="w-6 h-6" />
          <span>I am an NGO / Organizer</span>
        </button>

        <p className="text-center text-sm text-gray-600 pt-2">
          Already have an account?{' '}
          <button onClick={onLogin} className="text-emerald-600 hover:underline">
            Log In
          </button>
        </p>
      </div>
    </div>
  );
}
