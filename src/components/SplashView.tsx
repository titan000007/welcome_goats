import { useEffect } from 'react';
import { motion } from 'motion/react';
import { Sparkles, Leaf } from 'lucide-react';

interface SplashViewProps {
  onComplete: () => void;
}

export default function SplashView({ onComplete }: SplashViewProps) {
  useEffect(() => {
    const timer = setTimeout(() => {
      onComplete();
    }, 2800);
    return () => clearTimeout(timer);
  }, [onComplete]);

  return (
    <div className="relative w-full h-full bg-gradient-to-b from-stone-900 via-emerald-950 to-stone-950 flex flex-col items-center justify-between p-8 overflow-hidden">
      {/* Background ambient circular blurs */}
      <div className="absolute top-[20%] left-[10%] w-72 h-72 bg-emerald-700/20 rounded-full blur-[80px]" />
      <div className="absolute bottom-[30%] right-[5%] w-60 h-60 bg-lime-600/10 rounded-full blur-[100px]" />

      {/* Skip Button */}
      <div className="w-full flex justify-end">
        <button
          onClick={onComplete}
          className="px-4 py-1.5 rounded-full bg-white/5 border border-white/10 text-xs text-stone-300 font-mono tracking-wider hover:bg-white/10 transition-colors uppercase cursor-pointer"
        >
          Skip
        </button>
      </div>

      {/* Main Brand Assembly */}
      <div className="flex flex-col items-center text-center space-y-6">
        <motion.div
          initial={{ scale: 0.3, opacity: 0 }}
          animate={{ scale: [1, 1.05, 1], opacity: 1 }}
          transition={{ duration: 1.5, ease: 'easeOut' }}
          className="relative w-28 h-28 bg-gradient-to-tr from-emerald-500 to-lime-400 rounded-[32px] p-0.5 shadow-2xl shadow-emerald-500/20 flex items-center justify-center"
        >
          <div className="w-full h-full bg-stone-950 rounded-[30px] flex items-center justify-center overflow-hidden relative">
            <span className="text-4xl">🐐</span>
            {/* Glowing active outline */}
            <div className="absolute inset-0 bg-gradient-to-tr from-emerald-500/10 to-transparent animate-pulse" />
          </div>

          <motion.div
            initial={{ rotate: 0 }}
            animate={{ rotate: 360 }}
            transition={{ repeat: Infinity, duration: 12, ease: 'linear' }}
            className="absolute -inset-2 rounded-[36px] border border-dashed border-emerald-400/30 pointer-events-none"
          />
        </motion.div>

        <div className="space-y-2">
          <motion.h1
            initial={{ y: 20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ delay: 0.3, duration: 0.8 }}
            className="text-3xl font-sans font-bold tracking-tight text-white"
          >
            Welcome <span className="text-transparent bg-clip-text bg-gradient-to-r from-emerald-400 to-lime-300">Goats</span>
          </motion.h1>
          
          <motion.p
            initial={{ y: 15, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ delay: 0.6, duration: 0.8 }}
            className="text-stone-400 text-sm max-w-[240px] leading-relaxed mx-auto"
          >
            The premium wildlife camera app & image ecosystem
          </motion.p>
        </div>
      </div>

      {/* Footer Branding */}
      <div className="w-full flex flex-col items-center space-y-4">
        {/* Loading Ring */}
        <div className="flex items-center space-y-2 flex-col">
          <div className="w-40 h-1 bg-stone-800 rounded-full overflow-hidden relative">
            <motion.div
              initial={{ left: '-100%' }}
              animate={{ left: '100%' }}
              transition={{ repeat: Infinity, duration: 2, ease: 'easeInOut' }}
              className="absolute top-0 bottom-0 w-1/3 bg-gradient-to-r from-emerald-500 to-lime-400 rounded-full"
            />
          </div>
          <div className="flex items-center gap-1.5 text-stone-500 text-[10px] uppercase font-mono tracking-widest mt-1">
            <Sparkles className="w-2.5 h-2.5 text-lime-400 animate-pulse" />
            <span>Establishing Sanctuary</span>
            <Leaf className="w-2.5 h-2.5 text-emerald-400" />
          </div>
        </div>

        <div className="text-center">
          <p className="text-[10px] text-stone-600 font-mono">v1.4.0 • PRODUCTION READY</p>
          <p className="text-[9px] text-emerald-500/50 font-mono mt-0.5">REACT HIGH CONTRAST ECOSYSTEM</p>
        </div>
      </div>
    </div>
  );
}
