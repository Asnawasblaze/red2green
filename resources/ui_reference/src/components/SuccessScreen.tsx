import { CheckCircle, Home, ArrowRight } from 'lucide-react';
import { motion } from 'motion/react';

export type SuccessType = 'login' | 'report' | 'verification' | 'claim';

interface SuccessScreenProps {
  type: SuccessType;
  onContinue: () => void;
}

type SuccessContent = {
  icon: string;
  title: string;
  body: string;
  nextStep: string;
};

const successContent: Record<SuccessType, SuccessContent> = {
  login: {
    icon: '👋',
    title: 'Welcome to Red2Green!',
    body: 'Your account has been created successfully. You can now start reporting issues and joining cleanup events in your community.',
    nextStep: 'Explore the Watch feed'
  },
  report: {
    icon: '📸',
    title: 'Issue Reported Successfully!',
    body: 'Thank you for making your community better. Your report has been submitted and is now visible to NGOs and volunteers. You will be notified when an NGO claims it.',
    nextStep: 'Continue to WATCH feed'
  },
  verification: {
    icon: '✅',
    title: 'NGO Verified Successfully!',
    body: 'Congratulations! Your organization has been verified. You can now claim issues, schedule cleanup events, and coordinate with volunteers.',
    nextStep: 'Start claiming issues'
  },
  claim: {
    icon: '🎉',
    title: 'Claim Confirmed Successfully!',
    body: 'Your cleanup event has been scheduled. A group chat has been created for coordination. Volunteers in the area will be notified about this event.',
    nextStep: 'Go to Messages'
  }
};

export function SuccessScreen({ type, onContinue }: SuccessScreenProps) {
  const content = successContent[type];

  return (
    <div className="h-screen flex flex-col items-center justify-center bg-gradient-to-br from-emerald-50 to-teal-50 p-6">
      <motion.div
        initial={{ scale: 0 }}
        animate={{ scale: 1 }}
        transition={{
          type: 'spring',
          stiffness: 200,
          damping: 20,
          delay: 0.1
        }}
        className="text-center max-w-md"
      >
        {/* Success Icon */}
        <motion.div
          initial={{ scale: 0 }}
          animate={{ scale: 1 }}
          transition={{
            type: 'spring',
            stiffness: 200,
            damping: 15,
            delay: 0.2
          }}
          className="mb-6 inline-block"
        >
          <div className="relative">
            <div className="w-32 h-32 bg-emerald-600 rounded-full flex items-center justify-center shadow-2xl">
              <CheckCircle className="w-16 h-16 text-white" strokeWidth={2.5} />
            </div>
            <motion.div
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              transition={{ delay: 0.4 }}
              className="absolute -top-2 -right-2 text-5xl"
            >
              {content.icon}
            </motion.div>
          </div>
        </motion.div>

        {/* Title */}
        <motion.h1
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
          className="text-gray-900 mb-4"
        >
          {content.title}
        </motion.h1>

        {/* Body Text */}
        <motion.p
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
          className="text-gray-600 mb-8 leading-relaxed"
        >
          {content.body}
        </motion.p>

        {/* Next Step */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5 }}
          className="space-y-4"
        >
          <div className="bg-white/60 backdrop-blur border border-emerald-200 rounded-2xl p-4">
            <p className="text-sm text-gray-700 mb-1">Next Step:</p>
            <p className="text-emerald-700">{content.nextStep}</p>
          </div>

          {/* Continue Button */}
          <button
            onClick={onContinue}
            className="w-full flex items-center justify-center gap-3 bg-emerald-600 text-white py-4 rounded-2xl shadow-lg hover:bg-emerald-700 transition-all hover:scale-105"
          >
            <span>Continue</span>
            <ArrowRight className="w-5 h-5" />
          </button>
        </motion.div>

        {/* Confetti Effect */}
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: [0, 1, 0] }}
          transition={{ duration: 2, delay: 0.3 }}
          className="absolute inset-0 pointer-events-none"
        >
          {[...Array(20)].map((_, i) => (
            <motion.div
              key={i}
              initial={{
                x: '50%',
                y: '50%',
                scale: 0,
                opacity: 1
              }}
              animate={{
                x: `${Math.random() * 100}%`,
                y: `${Math.random() * 100}%`,
                scale: [0, 1, 0.5],
                opacity: [1, 0.8, 0]
              }}
              transition={{
                duration: 1.5,
                delay: 0.3 + (i * 0.05),
                ease: 'easeOut'
              }}
              className="absolute w-2 h-2 bg-emerald-500 rounded-full"
            />
          ))}
        </motion.div>
      </motion.div>
    </div>
  );
}
