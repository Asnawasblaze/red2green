import { useState } from 'react';
import { Camera, Upload, Trash2, AlertTriangle, ArrowLeft, ArrowRight, Check } from 'lucide-react';
import { ImageWithFallback } from './figma/ImageWithFallback';
import { motion, AnimatePresence } from 'motion/react';

type Category = 'garbage' | 'pothole' | 'graffiti' | 'other';

interface ReportFormProps {
  onComplete: () => void;
}

export function ReportForm({ onComplete }: ReportFormProps) {
  const [step, setStep] = useState(1);
  const [uploadedImage, setUploadedImage] = useState<string | null>(null);
  const [selectedCategory, setSelectedCategory] = useState<Category | null>(null);
  const [description, setDescription] = useState('');
  const [location, setLocation] = useState('Current Location');

  const handleImageUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setUploadedImage(reader.result as string);
      };
      reader.readAsDataURL(file);
    }
  };

  const handleSubmit = () => {
    // Simulate submission
    setTimeout(() => {
      setStep(1);
      setUploadedImage(null);
      setSelectedCategory(null);
      setDescription('');
      onComplete();
    }, 1000);
  };

  const categories = [
    { id: 'garbage' as Category, label: 'Garbage', icon: Trash2, color: 'emerald' },
    { id: 'pothole' as Category, label: 'Pothole', icon: AlertTriangle, color: 'amber' },
    { id: 'graffiti' as Category, label: 'Graffiti', icon: Upload, color: 'red' },
    { id: 'other' as Category, label: 'Other', icon: AlertTriangle, color: 'gray' }
  ];

  return (
    <div className="h-full flex flex-col bg-white">
      {/* Header */}
      <div className="bg-teal-700 text-white px-6 py-4 safe-area-top">
        <div className="flex items-center justify-between mb-4">
          <h1>Report Issue</h1>
          <button
            onClick={onComplete}
            className="p-2 bg-white/20 rounded-full backdrop-blur"
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
        </div>

        {/* Progress Indicator */}
        <div className="flex gap-2">
          {[1, 2, 3].map((s) => (
            <div
              key={s}
              className={`h-1 flex-1 rounded-full transition-colors ${
                s <= step ? 'bg-white' : 'bg-white/30'
              }`}
            />
          ))}
        </div>
      </div>

      {/* Form Content */}
      <div className="flex-1 overflow-y-auto">
        <AnimatePresence mode="wait">
          {/* Step 1: Photo Upload */}
          {step === 1 && (
            <motion.div
              key="step1"
              initial={{ opacity: 0, x: 20 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -20 }}
              className="p-6 space-y-4"
            >
              <div>
                <h2 className="mb-2">Take a Photo</h2>
                <p className="text-gray-600">
                  Capture the issue you'd like to report
                </p>
              </div>

              {/* Upload Area */}
              <label className="block">
                <input
                  type="file"
                  accept="image/*"
                  capture="environment"
                  onChange={handleImageUpload}
                  className="hidden"
                />
                <div className="relative aspect-[4/3] bg-gray-100 rounded-2xl border-2 border-dashed border-gray-300 cursor-pointer hover:border-emerald-500 transition-colors overflow-hidden">
                  {uploadedImage ? (
                    <>
                      <ImageWithFallback
                        src={uploadedImage}
                        alt="Uploaded issue"
                        className="w-full h-full object-cover"
                      />
                      <button
                        onClick={(e) => {
                          e.preventDefault();
                          setUploadedImage(null);
                        }}
                        className="absolute top-4 right-4 p-2 bg-red-500 text-white rounded-full shadow-lg"
                      >
                        <ArrowLeft className="w-5 h-5" />
                      </button>
                    </>
                  ) : (
                    <div className="absolute inset-0 flex flex-col items-center justify-center">
                      <Camera className="w-16 h-16 text-gray-400 mb-3" />
                      <p className="text-gray-600">Tap to capture photo</p>
                      <p className="text-sm text-gray-500 mt-1">or upload from gallery</p>
                    </div>
                  )}
                </div>
              </label>

              <div className="bg-emerald-50 border border-emerald-200 rounded-2xl p-4 text-sm text-gray-700">
                <p>📸 Tips for good photos:</p>
                <ul className="mt-2 space-y-1 ml-4 list-disc">
                  <li>Ensure good lighting</li>
                  <li>Capture the full context</li>
                  <li>Show the severity clearly</li>
                </ul>
              </div>
            </motion.div>
          )}

          {/* Step 2: Category Selection */}
          {step === 2 && (
            <motion.div
              key="step2"
              initial={{ opacity: 0, x: 20 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -20 }}
              className="p-6 space-y-4"
            >
              <div>
                <h2 className="mb-2">Select Category</h2>
                <p className="text-gray-600">
                  What type of issue are you reporting?
                </p>
              </div>

              {/* Category Grid */}
              <div className="grid grid-cols-2 gap-4">
                {categories.map((category) => {
                  const Icon = category.icon;
                  const isSelected = selectedCategory === category.id;
                  return (
                    <button
                      key={category.id}
                      onClick={() => setSelectedCategory(category.id)}
                      className={`p-6 rounded-2xl border-2 transition-all ${
                        isSelected
                          ? `border-${category.color}-500 bg-${category.color}-50`
                          : 'border-gray-200 bg-white hover:border-gray-300'
                      }`}
                    >
                      <Icon
                        className={`w-10 h-10 mx-auto mb-3 ${
                          isSelected ? `text-${category.color}-600` : 'text-gray-400'
                        }`}
                      />
                      <p className={isSelected ? `text-${category.color}-700` : 'text-gray-700'}>
                        {category.label}
                      </p>
                    </button>
                  );
                })}
              </div>

              {/* Preview */}
              {uploadedImage && (
                <div className="rounded-2xl overflow-hidden border border-gray-200">
                  <ImageWithFallback
                    src={uploadedImage}
                    alt="Preview"
                    className="w-full h-32 object-cover"
                  />
                </div>
              )}
            </motion.div>
          )}

          {/* Step 3: Description */}
          {step === 3 && (
            <motion.div
              key="step3"
              initial={{ opacity: 0, x: 20 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -20 }}
              className="p-6 space-y-4"
            >
              <div>
                <h2 className="mb-2">Add Details</h2>
                <p className="text-gray-600">
                  Provide additional information about the issue
                </p>
              </div>

              {/* Location */}
              <div>
                <label className="block text-sm text-gray-700 mb-2">Location</label>
                <div className="flex items-center gap-2 px-4 py-3 bg-gray-100 rounded-2xl">
                  <div className="w-2 h-2 bg-emerald-500 rounded-full animate-pulse" />
                  <span className="text-gray-700">{location}</span>
                </div>
              </div>

              {/* Description */}
              <div>
                <label className="block text-sm text-gray-700 mb-2">Description</label>
                <textarea
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                  placeholder="Describe the issue in detail..."
                  rows={5}
                  className="w-full px-4 py-3 border border-gray-300 rounded-2xl focus:outline-none focus:ring-2 focus:ring-emerald-500 resize-none"
                />
              </div>

              {/* Summary Card */}
              <div className="bg-gray-50 rounded-2xl p-4 space-y-3">
                <h3 className="text-sm text-gray-700">Report Summary</h3>
                {uploadedImage && (
                  <div className="rounded-xl overflow-hidden">
                    <ImageWithFallback
                      src={uploadedImage}
                      alt="Summary"
                      className="w-full h-24 object-cover"
                    />
                  </div>
                )}
                <div className="flex items-center gap-2 text-sm">
                  <span className="px-3 py-1 bg-emerald-100 text-emerald-700 rounded-full">
                    {selectedCategory}
                  </span>
                  <span className="text-gray-600">• {location}</span>
                </div>
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </div>

      {/* Bottom Actions */}
      <div className="p-6 border-t border-gray-200 safe-area-bottom">
        <div className="flex gap-3">
          {step > 1 && (
            <button
              onClick={() => setStep(step - 1)}
              className="px-6 py-4 bg-gray-100 text-gray-700 rounded-2xl hover:bg-gray-200 transition-colors"
            >
              <ArrowLeft className="w-5 h-5" />
            </button>
          )}
          
          <button
            onClick={() => {
              if (step === 3) {
                handleSubmit();
              } else {
                setStep(step + 1);
              }
            }}
            disabled={
              (step === 1 && !uploadedImage) ||
              (step === 2 && !selectedCategory)
            }
            className="flex-1 flex items-center justify-center gap-2 bg-emerald-600 text-white py-4 rounded-2xl hover:bg-emerald-700 transition-colors disabled:bg-gray-300 disabled:cursor-not-allowed"
          >
            {step === 3 ? (
              <>
                <Check className="w-5 h-5" />
                <span>Submit Report</span>
              </>
            ) : (
              <>
                <span>Continue</span>
                <ArrowRight className="w-5 h-5" />
              </>
            )}
          </button>
        </div>
      </div>
    </div>
  );
}
