import { useState } from 'react';
import { ArrowLeft, Mail, Lock, Eye, EyeOff, Phone } from 'lucide-react';

interface LoginScreenProps {
  onBack: () => void;
  onComplete: () => void;
}

export function LoginScreen({ onBack, onComplete }: LoginScreenProps) {
  const [formData, setFormData] = useState({
    identifier: '',
    password: ''
  });
  const [showPassword, setShowPassword] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // Simulate login
    setTimeout(() => {
      onComplete();
    }, 500);
  };

  const handleSocialLogin = (provider: string) => {
    // Simulate social login
    console.log(`Logging in with ${provider}`);
    setTimeout(() => {
      onComplete();
    }, 500);
  };

  return (
    <div className="h-screen flex flex-col bg-white">
      {/* Header */}
      <div className="px-6 pt-6 safe-area-top">
        <button onClick={onBack} className="p-2 -ml-2 hover:bg-gray-100 rounded-full transition-colors">
          <ArrowLeft className="w-6 h-6 text-gray-700" />
        </button>
      </div>

      {/* Content */}
      <div className="flex-1 flex flex-col px-6 py-8">
        {/* Logo and Title */}
        <div className="text-center mb-8">
          <div className="inline-flex items-center justify-center w-20 h-20 bg-emerald-600 rounded-full mb-4 shadow-lg">
            <span className="text-4xl">🌱</span>
          </div>
          <h1 className="text-emerald-700 mb-2">Red2Green</h1>
          <h2 className="text-gray-900 mb-1">Welcome Back!</h2>
          <p className="text-gray-600">Sign in to continue making a difference</p>
        </div>

        {/* Login Form */}
        <form onSubmit={handleSubmit} className="space-y-5 mb-6">
          {/* Email or Phone */}
          <div>
            <label className="block text-sm text-gray-700 mb-2">Email or Phone Number</label>
            <div className="relative">
              <Mail className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                type="text"
                value={formData.identifier}
                onChange={(e) => setFormData({ ...formData, identifier: e.target.value })}
                placeholder="Enter email or phone number"
                className="w-full pl-12 pr-4 py-4 border-2 border-gray-200 rounded-2xl focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent"
                required
              />
            </div>
          </div>

          {/* Password */}
          <div>
            <label className="block text-sm text-gray-700 mb-2">Password</label>
            <div className="relative">
              <Lock className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                type={showPassword ? 'text' : 'password'}
                value={formData.password}
                onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                placeholder="Enter your password"
                className="w-full pl-12 pr-12 py-4 border-2 border-gray-200 rounded-2xl focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent"
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
            <div className="text-right mt-2">
              <button
                type="button"
                className="text-sm text-emerald-600 hover:underline"
              >
                Forgot Password?
              </button>
            </div>
          </div>

          {/* Login Button */}
          <button
            type="submit"
            className="w-full bg-emerald-600 text-white py-4 rounded-2xl shadow-lg hover:bg-emerald-700 transition-colors"
          >
            Log In
          </button>
        </form>

        {/* Divider */}
        <div className="flex items-center gap-4 mb-6">
          <div className="flex-1 h-px bg-gray-300" />
          <span className="text-sm text-gray-500">Or continue with</span>
          <div className="flex-1 h-px bg-gray-300" />
        </div>

        {/* Social Login Buttons */}
        <div className="flex justify-center gap-4 mb-8">
          <button
            type="button"
            onClick={() => handleSocialLogin('google')}
            className="w-14 h-14 flex items-center justify-center bg-white border-2 border-gray-200 rounded-full hover:border-emerald-500 hover:bg-emerald-50 transition-all shadow-sm"
            title="Continue with Google"
          >
            <svg className="w-6 h-6" viewBox="0 0 24 24">
              <path
                fill="#4285F4"
                d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
              />
              <path
                fill="#34A853"
                d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
              />
              <path
                fill="#FBBC05"
                d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
              />
              <path
                fill="#EA4335"
                d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
              />
            </svg>
          </button>

          <button
            type="button"
            onClick={() => handleSocialLogin('phone')}
            className="w-14 h-14 flex items-center justify-center bg-white border-2 border-gray-200 rounded-full hover:border-emerald-500 hover:bg-emerald-50 transition-all shadow-sm"
            title="Continue with Phone/OTP"
          >
            <Phone className="w-6 h-6 text-emerald-600" />
          </button>
        </div>
      </div>
    </div>
  );
}
