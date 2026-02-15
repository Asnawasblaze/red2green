import { useState } from 'react';
import { ArrowLeft, User, Mail, Phone, Lock, Eye, EyeOff } from 'lucide-react';

interface CitizenSignupProps {
  onBack: () => void;
  onComplete: () => void;
  onSwitchToLogin: () => void;
}

export function CitizenSignup({ onBack, onComplete, onSwitchToLogin }: CitizenSignupProps) {
  const [formData, setFormData] = useState({
    fullName: '',
    email: '',
    phone: '',
    password: ''
  });
  const [showPassword, setShowPassword] = useState(false);
  const [primaryRole, setPrimaryRole] = useState<'reporter' | 'volunteer'>('reporter');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // Simulate account creation
    setTimeout(() => {
      onComplete();
    }, 500);
  };

  return (
    <div className="h-screen flex flex-col bg-white overflow-y-auto">
      {/* Header */}
      <div className="bg-emerald-600 text-white px-6 py-4 safe-area-top flex items-center gap-3">
        <button onClick={onBack} className="p-2 -ml-2 hover:bg-white/10 rounded-full transition-colors">
          <ArrowLeft className="w-5 h-5" />
        </button>
        <h1 className="text-white">Citizen Sign Up</h1>
      </div>

      {/* Form */}
      <form onSubmit={handleSubmit} className="flex-1 px-6 py-6 space-y-6">
        <div className="text-center mb-6">
          <p className="text-gray-600">
            Create your account to start reporting issues and joining cleanup events
          </p>
        </div>

        {/* Full Name */}
        <div>
          <label className="block text-sm text-gray-700 mb-2">Full Name</label>
          <div className="relative">
            <User className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              value={formData.fullName}
              onChange={(e) => setFormData({ ...formData, fullName: e.target.value })}
              placeholder="Enter your full name"
              className="w-full pl-12 pr-4 py-3 border-2 border-gray-200 rounded-2xl focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent"
              required
            />
          </div>
        </div>

        {/* Email */}
        <div>
          <label className="block text-sm text-gray-700 mb-2">Email Address</label>
          <div className="relative">
            <Mail className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="email"
              value={formData.email}
              onChange={(e) => setFormData({ ...formData, email: e.target.value })}
              placeholder="your.email@example.com"
              className="w-full pl-12 pr-4 py-3 border-2 border-gray-200 rounded-2xl focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent"
              required
            />
          </div>
        </div>

        {/* Phone */}
        <div>
          <label className="block text-sm text-gray-700 mb-2">Phone Number</label>
          <div className="relative">
            <Phone className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="tel"
              value={formData.phone}
              onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
              placeholder="+91 XXXXX XXXXX"
              className="w-full pl-12 pr-4 py-3 border-2 border-gray-200 rounded-2xl focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent"
              required
            />
          </div>
        </div>

        {/* Password */}
        <div>
          <label className="block text-sm text-gray-700 mb-2">Create Password</label>
          <div className="relative">
            <Lock className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type={showPassword ? 'text' : 'password'}
              value={formData.password}
              onChange={(e) => setFormData({ ...formData, password: e.target.value })}
              placeholder="Minimum 8 characters"
              className="w-full pl-12 pr-12 py-3 border-2 border-gray-200 rounded-2xl focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent"
              required
            />
            <button
              type="button"
              onClick={() => setShowPassword(!showPassword)}
              className="absolute right-4 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
            >
              {showPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
            </button>
          </div>
        </div>

        {/* Primary Role Toggle */}
        <div>
          <label className="block text-sm text-gray-700 mb-3">Primary Role</label>
          <div className="flex gap-2 p-1 bg-gray-100 rounded-2xl">
            <button
              type="button"
              onClick={() => setPrimaryRole('reporter')}
              className={`flex-1 py-3 rounded-xl transition-all ${
                primaryRole === 'reporter'
                  ? 'bg-emerald-600 text-white shadow-md'
                  : 'bg-transparent text-gray-700'
              }`}
            >
              Citizen Reporter
            </button>
            <button
              type="button"
              onClick={() => setPrimaryRole('volunteer')}
              className={`flex-1 py-3 rounded-xl transition-all ${
                primaryRole === 'volunteer'
                  ? 'bg-emerald-600 text-white shadow-md'
                  : 'bg-transparent text-gray-700'
              }`}
            >
              Active Volunteer
            </button>
          </div>
          <p className="text-xs text-gray-500 mt-2">
            {primaryRole === 'reporter'
              ? 'Report issues and track their resolution'
              : 'Join cleanup events and coordinate with teams'}
          </p>
        </div>

        {/* Submit Button */}
        <button
          type="submit"
          className="w-full bg-emerald-600 text-white py-4 rounded-2xl shadow-lg hover:bg-emerald-700 transition-colors"
        >
          Create Account
        </button>

        {/* Login Link */}
        <p className="text-center text-sm text-gray-600">
          Already have an account?{' '}
          <button
            type="button"
            onClick={onSwitchToLogin}
            className="text-emerald-600 hover:underline"
          >
            Log In
          </button>
        </p>
      </form>
    </div>
  );
}
