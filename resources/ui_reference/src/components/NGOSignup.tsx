import { useState } from 'react';
import { ArrowLeft, Building2, User, Mail, Phone, Shield, Info, Eye, EyeOff } from 'lucide-react';

interface NGOSignupProps {
  onBack: () => void;
  onComplete: () => void;
  onSwitchToLogin: () => void;
}

export function NGOSignup({ onBack, onComplete, onSwitchToLogin }: NGOSignupProps) {
  const [formData, setFormData] = useState({
    orgName: '',
    contactPerson: '',
    email: '',
    phone: '',
    ngoId: '',
    password: ''
  });
  const [showPassword, setShowPassword] = useState(false);
  const [showInfo, setShowInfo] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // Simulate verification and registration
    setTimeout(() => {
      onComplete();
    }, 1000);
  };

  return (
    <div className="h-screen flex flex-col bg-white overflow-y-auto">
      {/* Header */}
      <div className="bg-teal-800 text-white px-6 py-4 safe-area-top flex items-center gap-3">
        <button onClick={onBack} className="p-2 -ml-2 hover:bg-white/10 rounded-full transition-colors">
          <ArrowLeft className="w-5 h-5" />
        </button>
        <div className="flex items-center gap-2">
          <Building2 className="w-6 h-6" />
          <h1 className="text-white">NGO Partner Registration</h1>
        </div>
      </div>

      {/* Form */}
      <form onSubmit={handleSubmit} className="flex-1 px-6 py-6 space-y-5">
        <div className="bg-teal-50 border-l-4 border-teal-600 p-4 rounded-r-xl mb-4">
          <p className="text-sm text-teal-900">
            <span className="block mb-1">Official Partner Registration</span>
            <span className="text-teal-700">
              Your organization will be verified before being able to claim and coordinate cleanup events.
            </span>
          </p>
        </div>

        {/* Organization Name */}
        <div>
          <label className="block text-sm text-gray-700 mb-2">Organization Name</label>
          <div className="relative">
            <Building2 className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              value={formData.orgName}
              onChange={(e) => setFormData({ ...formData, orgName: e.target.value })}
              placeholder="Your NGO or organization name"
              className="w-full pl-12 pr-4 py-3 border-2 border-gray-200 rounded-2xl focus:outline-none focus:ring-2 focus:ring-teal-600 focus:border-transparent"
              required
            />
          </div>
        </div>

        {/* Contact Person */}
        <div>
          <label className="block text-sm text-gray-700 mb-2">Contact Person Name</label>
          <div className="relative">
            <User className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              value={formData.contactPerson}
              onChange={(e) => setFormData({ ...formData, contactPerson: e.target.value })}
              placeholder="Primary contact name"
              className="w-full pl-12 pr-4 py-3 border-2 border-gray-200 rounded-2xl focus:outline-none focus:ring-2 focus:ring-teal-600 focus:border-transparent"
              required
            />
          </div>
        </div>

        {/* Official Email */}
        <div>
          <label className="block text-sm text-gray-700 mb-2">Official Email Address</label>
          <div className="relative">
            <Mail className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="email"
              value={formData.email}
              onChange={(e) => setFormData({ ...formData, email: e.target.value })}
              placeholder="official@yourorg.org"
              className="w-full pl-12 pr-4 py-3 border-2 border-gray-200 rounded-2xl focus:outline-none focus:ring-2 focus:ring-teal-600 focus:border-transparent"
              required
            />
          </div>
        </div>

        {/* Phone Number */}
        <div>
          <label className="block text-sm text-gray-700 mb-2">Phone Number</label>
          <div className="relative">
            <Phone className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="tel"
              value={formData.phone}
              onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
              placeholder="+91 XXXXX XXXXX"
              className="w-full pl-12 pr-4 py-3 border-2 border-gray-200 rounded-2xl focus:outline-none focus:ring-2 focus:ring-teal-600 focus:border-transparent"
              required
            />
          </div>
        </div>

        {/* NGO Darpan ID - Prominent Field */}
        <div className="pt-2">
          <div className="flex items-center gap-2 mb-2">
            <label className="block text-sm text-gray-900">NGO Darpan ID (UIN)</label>
            <button
              type="button"
              onClick={() => setShowInfo(!showInfo)}
              className="p-1 text-teal-600 hover:bg-teal-50 rounded-full transition-colors"
            >
              <Info className="w-4 h-4" />
            </button>
          </div>
          
          {showInfo && (
            <div className="mb-3 p-3 bg-blue-50 border border-blue-200 rounded-xl text-xs text-blue-900">
              <p className="mb-1">The NGO Darpan Unique Identification Number (UIN) is issued by NITI Aayog.</p>
              <p>Find your UIN at: <span className="underline">ngodarpan.gov.in</span></p>
            </div>
          )}

          <div className="relative">
            <Shield className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-teal-600" />
            <input
              type="text"
              value={formData.ngoId}
              onChange={(e) => setFormData({ ...formData, ngoId: e.target.value })}
              placeholder="Enter your UIN (e.g., MH/2023/0123456)"
              className="w-full pl-12 pr-4 py-4 border-3 border-teal-300 rounded-2xl focus:outline-none focus:ring-2 focus:ring-teal-600 focus:border-teal-600 bg-teal-50/30"
              required
            />
          </div>
          <p className="text-xs text-gray-600 mt-2 flex items-start gap-1">
            <Shield className="w-3 h-3 mt-0.5 text-teal-600 flex-shrink-0" />
            Required for official verification to claim issues and organize events
          </p>
        </div>

        {/* Password */}
        <div>
          <label className="block text-sm text-gray-700 mb-2">Create Password</label>
          <div className="relative">
            <Shield className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type={showPassword ? 'text' : 'password'}
              value={formData.password}
              onChange={(e) => setFormData({ ...formData, password: e.target.value })}
              placeholder="Minimum 8 characters"
              className="w-full pl-12 pr-12 py-3 border-2 border-gray-200 rounded-2xl focus:outline-none focus:ring-2 focus:ring-teal-600 focus:border-transparent"
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

        {/* Submit Button */}
        <button
          type="submit"
          className="w-full bg-teal-700 text-white py-4 rounded-2xl shadow-lg hover:bg-teal-800 transition-colors flex items-center justify-center gap-2"
        >
          <Shield className="w-5 h-5" />
          <span>Verify & Register</span>
        </button>

        {/* Info Text */}
        <div className="bg-amber-50 border border-amber-200 rounded-xl p-3 text-xs text-amber-900">
          <p>⏱️ Verification typically takes 24-48 hours. You'll receive an email once approved.</p>
        </div>

        {/* Login Link */}
        <p className="text-center text-sm text-gray-600 pt-2">
          Already registered?{' '}
          <button
            type="button"
            onClick={onSwitchToLogin}
            className="text-teal-700 hover:underline"
          >
            Log In
          </button>
        </p>
      </form>
    </div>
  );
}
