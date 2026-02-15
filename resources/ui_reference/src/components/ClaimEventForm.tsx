import { useState } from 'react';
import { X, Calendar, Clock, MapPin, AlertCircle } from 'lucide-react';
import { motion } from 'motion/react';

interface ClaimEventFormProps {
  issueName: string;
  issueLocation: string;
  onClose: () => void;
  onConfirm: (eventData: EventFormData) => void;
}

export type EventFormData = {
  date: string;
  time: string;
  meetingPoint: string;
};

export function ClaimEventForm({ issueName, issueLocation, onClose, onConfirm }: ClaimEventFormProps) {
  const [formData, setFormData] = useState<EventFormData>({
    date: '',
    time: '',
    meetingPoint: issueLocation
  });

  const getTodayDate = () => {
    const today = new Date();
    return today.toISOString().split('T')[0];
  };

  const isFormComplete = formData.date && formData.time && formData.meetingPoint;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (isFormComplete) {
      onConfirm(formData);
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4"
      onClick={onClose}
    >
      <motion.div
        initial={{ scale: 0.9, opacity: 0 }}
        animate={{ scale: 1, opacity: 1 }}
        exit={{ scale: 0.9, opacity: 0 }}
        onClick={(e) => e.stopPropagation()}
        className="bg-white rounded-3xl w-full max-w-md max-h-[90vh] overflow-hidden"
      >
        {/* Header */}
        <div className="bg-teal-700 text-white px-6 py-4">
          <div className="flex items-center justify-between">
            <h2 className="text-white">Schedule Cleanup Event</h2>
            <button
              onClick={onClose}
              className="p-2 hover:bg-white/10 rounded-full transition-colors"
            >
              <X className="w-5 h-5" />
            </button>
          </div>
        </div>

        {/* Form Content */}
        <form onSubmit={handleSubmit} className="p-6 space-y-5 overflow-y-auto max-h-[calc(90vh-140px)]">
          {/* Issue Info */}
          <div className="bg-teal-50 border border-teal-200 rounded-2xl p-4">
            <p className="text-sm text-teal-900 mb-1">Claiming Issue:</p>
            <p className="text-teal-800">{issueName}</p>
          </div>

          {/* Event Date */}
          <div>
            <label className="block text-sm text-gray-700 mb-2 flex items-center gap-2">
              <Calendar className="w-4 h-4 text-gray-500" />
              Event Date
            </label>
            <input
              type="date"
              value={formData.date}
              onChange={(e) => setFormData({ ...formData, date: e.target.value })}
              min={getTodayDate()}
              className="w-full px-4 py-3 border-2 border-gray-200 rounded-2xl focus:outline-none focus:ring-2 focus:ring-teal-600 focus:border-transparent"
              required
            />
            <p className="text-xs text-gray-500 mt-1">Cannot select past dates</p>
          </div>

          {/* Event Time */}
          <div>
            <label className="block text-sm text-gray-700 mb-2 flex items-center gap-2">
              <Clock className="w-4 h-4 text-gray-500" />
              Event Time
            </label>
            <input
              type="time"
              value={formData.time}
              onChange={(e) => setFormData({ ...formData, time: e.target.value })}
              className="w-full px-4 py-3 border-2 border-gray-200 rounded-2xl focus:outline-none focus:ring-2 focus:ring-teal-600 focus:border-transparent"
              required
            />
          </div>

          {/* Meeting Point */}
          <div>
            <label className="block text-sm text-gray-700 mb-2 flex items-center gap-2">
              <MapPin className="w-4 h-4 text-gray-500" />
              Meeting Point
            </label>
            <input
              type="text"
              value={formData.meetingPoint}
              onChange={(e) => setFormData({ ...formData, meetingPoint: e.target.value })}
              placeholder="Enter meeting point location"
              className="w-full px-4 py-3 border-2 border-gray-200 rounded-2xl focus:outline-none focus:ring-2 focus:ring-teal-600 focus:border-transparent"
              required
            />
            <p className="text-xs text-gray-500 mt-1">Default: Issue location</p>
          </div>

          {/* Info Box */}
          <div className="bg-blue-50 border border-blue-200 rounded-2xl p-4 flex gap-3">
            <AlertCircle className="w-5 h-5 text-blue-600 flex-shrink-0 mt-0.5" />
            <div className="text-sm text-blue-900">
              <p className="mb-1">Once confirmed:</p>
              <ul className="list-disc list-inside space-y-1 text-xs">
                <li>This issue will be marked as &quot;Claimed&quot;</li>
                <li>A group chat will be created for coordination</li>
                <li>Volunteers will be notified of the event</li>
              </ul>
            </div>
          </div>
        </form>

        {/* Action Button */}
        <div className="px-6 pb-6">
          <button
            onClick={handleSubmit}
            disabled={!isFormComplete}
            className="w-full bg-teal-700 text-white py-4 rounded-2xl shadow-lg hover:bg-teal-800 transition-colors disabled:bg-gray-300 disabled:cursor-not-allowed flex items-center justify-center gap-2"
          >
            <Calendar className="w-5 h-5" />
            <span>{isFormComplete ? 'Confirm Claim & Schedule' : 'Complete all fields'}</span>
          </button>
        </div>
      </motion.div>
    </motion.div>
  );
}
