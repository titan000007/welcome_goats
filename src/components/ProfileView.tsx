import { useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { User, ShieldAlert, Award, Grid, Heart, Download, BookOpen, Moon, Sun, ArrowRight, Settings, Info, LogOut } from 'lucide-react';
import { ImageItem } from '../types';

interface ProfileViewProps {
  images: ImageItem[];
  onThemeToggle: () => void;
  isLightTheme: boolean;
  onLogout: () => void;
}

export default function ProfileView({
  images,
  onThemeToggle,
  isLightTheme,
  onLogout,
}: ProfileViewProps) {
  const [showLogoutAlert, setShowLogoutAlert] = useState(false);

  // Dynamic metrics calculation
  const totalUploads = images.filter((img) => img.userId === 'user_default').length;
  const totalFavorites = images.filter((img) => img.isFavorite).length;
  const totalDownloadsSum = images
    .filter((img) => img.userId === 'user_default')
    .reduce((acc, curr) => acc + (curr.downloadsCount || 0), 0);

  return (
    <div className="w-full h-full flex flex-col overflow-y-auto pb-24 scrollbar-none">
      
      {/* 1. Header Banner */}
      <div className="relative w-full h-[140px] bg-gradient-to-tr from-emerald-950 via-stone-900 to-lime-950 flex items-end px-5 pb-4 shrink-0 overflow-hidden">
        {/* Abstract background blobs */}
        <div className="absolute top-2 right-4 w-32 h-32 bg-emerald-400/10 rounded-full blur-[30px]" />
        <div className="absolute -bottom-8 -left-8 w-40 h-40 bg-lime-400/5 rounded-full blur-[40px]" />

        <div className="relative z-10 flex items-center gap-4">
          <div className="w-16 h-16 rounded-2xl border-2 border-emerald-400/60 overflow-hidden shadow-xl bg-stone-900 flex items-center justify-center p-0.5">
            <img
              src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=150&auto=format&fit=crop"
              alt="Avatar"
              className="w-full h-full object-cover rounded-[14px]"
              referrerPolicy="no-referrer"
            />
          </div>
          <div className="text-left space-y-0.5">
            <div className="flex items-center gap-1.5">
              <span className="text-[9px] font-mono font-bold tracking-widest bg-emerald-500 text-stone-950 px-1.5 py-0.5 rounded uppercase">
                Pro Explorer
              </span>
              <span className="w-2 h-2 rounded-full bg-lime-400 animate-pulse" />
            </div>
            <h2 className="text-base font-bold text-stone-100 font-sans tracking-tight">Amelia Rose</h2>
            <p className="text-[10px] text-stone-400 font-mono">amelia.rose@sanctuary.org</p>
          </div>
        </div>
      </div>

      {/* 2. Main content and grids */}
      <div className="p-5 space-y-5">
        
        {/* 3. Grid Metrics Dashboard */}
        <div className="grid grid-cols-3 gap-2.5">
          <div className="bg-stone-900/60 border border-stone-850 p-3 rounded-2xl text-center space-y-1 shadow-sm">
            <div className="w-7 h-7 rounded-lg bg-emerald-500/10 flex items-center justify-center mx-auto text-emerald-400">
              <Grid className="w-4 h-4" />
            </div>
            <p className="text-xs font-mono font-bold text-stone-100">{totalUploads}</p>
            <p className="text-[8px] text-stone-500 uppercase tracking-wider font-mono">My uploads</p>
          </div>

          <div className="bg-stone-900/60 border border-stone-850 p-3 rounded-2xl text-center space-y-1 shadow-sm">
            <div className="w-7 h-7 rounded-lg bg-red-500/10 flex items-center justify-center mx-auto text-red-400">
              <Heart className="w-4 h-4 fill-red-400/20" />
            </div>
            <p className="text-xs font-mono font-bold text-stone-100">{totalFavorites}</p>
            <p className="text-[8px] text-stone-500 uppercase tracking-wider font-mono">Favorites</p>
          </div>

          <div className="bg-stone-900/60 border border-stone-850 p-3 rounded-2xl text-center space-y-1 shadow-sm">
            <div className="w-7 h-7 rounded-lg bg-sky-500/10 flex items-center justify-center mx-auto text-sky-450">
              <Download className="w-4 h-4" />
            </div>
            <p className="text-xs font-mono font-bold text-stone-100">{totalDownloadsSum + 120}</p>
            <p className="text-[8px] text-stone-500 uppercase tracking-wider font-mono">Downloads</p>
          </div>
        </div>

        {/* Short Bio Block */}
        <div className="bg-stone-900/40 p-3.5 rounded-2xl border border-stone-850 text-left">
          <p className="text-[9px] font-mono uppercase tracking-widest text-emerald-400 font-bold mb-1">Species Bio</p>
          <p className="text-stone-300 text-xs leading-relaxed font-sans">
            Senior Wildlife Biologist & Alpine Goats Caretaker. Documenting endangered flora, high-climbing mammals, and river birds species. ⛰️🦅🐾
          </p>
        </div>

        {/* 4. Settings Section */}
        <div className="space-y-2">
          <h3 className="text-[10px] font-mono uppercase tracking-widest text-stone-500 font-bold text-left px-1">
            Application Preferences / Controls
          </h3>

          <div className="bg-stone-900/60 border border-stone-850 rounded-[24px] divide-y divide-stone-850/60 overflow-hidden">
            
            {/* Theme Toggle option */}
            <div className="p-4 flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-full bg-stone-950 flex items-center justify-center text-stone-400">
                  {isLightTheme ? <Sun className="w-4 h-4 text-amber-400" /> : <Moon className="w-4 h-4 text-emerald-400" />}
                </div>
                <div className="text-left">
                  <h4 className="text-xs font-bold text-stone-200">Visual Aesthetic Theme</h4>
                  <p className="text-[9px] text-stone-500 font-mono">Current: {isLightTheme ? 'Light Mode' : 'Nature Dark Mode'}</p>
                </div>
              </div>
              <button
                onClick={onThemeToggle}
                className="w-12 h-6 rounded-full bg-stone-950 p-0.5 flex relative border border-stone-800 cursor-pointer"
              >
                <motion.div
                  animate={{ x: isLightTheme ? 24 : 0 }}
                  className="w-5 h-5 rounded-full bg-gradient-to-tr from-emerald-500 to-lime-400"
                />
              </button>
            </div>

            {/* Support / FAQ */}
            <div className="p-4 flex items-center justify-between cursor-pointer hover:bg-stone-850/30 transition-colors">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-full bg-stone-950 flex items-center justify-center text-stone-400">
                  <BookOpen className="w-4 h-4 text-emerald-400" />
                </div>
                <div className="text-left">
                  <h4 className="text-xs font-bold text-stone-200">Species Sanctuary Guidelines</h4>
                  <p className="text-[9px] text-stone-500 font-mono">Fidelity wildlife terms of action</p>
                </div>
              </div>
              <ArrowRight className="w-4 h-4 text-stone-500" />
            </div>

            {/* Security Credits */}
            <div className="p-4 flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-full bg-stone-950 flex items-center justify-center text-stone-400">
                  <Award className="w-4 h-4 text-lime-400" />
                </div>
                <div className="text-left">
                  <h4 className="text-xs font-bold text-stone-200">Device Coordinates GPS</h4>
                  <p className="text-[9px] text-stone-500 font-mono">Precision: High Fidelity Simulator</p>
                </div>
              </div>
              <span className="text-[9px] font-mono text-emerald-500 uppercase font-semibold">Active</span>
            </div>

          </div>
        </div>

        {/* 5. Logout Trigger button */}
        <div className="pt-3">
          <button
            onClick={() => setShowLogoutAlert(true)}
            className="w-full py-3.5 bg-red-950/25 text-red-400 hover:bg-red-950/45 text-xs font-bold font-mono tracking-wider flex items-center justify-center gap-2 rounded-2xl uppercase border border-red-500/20 transition-all cursor-pointer"
          >
            <LogOut className="w-4 h-4" />
            <span>Simulate Sign Out</span>
          </button>
        </div>

      </div>

      {/* 6. Logout confirmation overlay banner */}
      <AnimatePresence>
        {showLogoutAlert && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="absolute inset-0 bg-stone-950/90 backdrop-blur-sm z-50 flex items-center justify-center p-6 text-center"
          >
            <motion.div
              initial={{ scale: 0.95 }}
              animate={{ scale: 1 }}
              exit={{ scale: 0.95 }}
              className="max-w-xs space-y-4 bg-stone-900 border border-stone-850 p-5 rounded-3xl"
            >
              <div className="w-12 h-12 rounded-full bg-red-500/10 flex items-center justify-center mx-auto text-red-500">
                <ShieldAlert className="w-6 h-6" />
              </div>
              <div className="space-y-1">
                <h4 className="text-sm font-bold text-stone-100 uppercase font-mono">Sign Out session?</h4>
                <p className="text-xs text-stone-400">
                  This simulates session invalidation. In the previewer, this resets your temporary state and returns you to the Splash screen.
                </p>
              </div>
              <div className="flex gap-2.5 pt-1">
                <button
                  onClick={onLogout}
                  className="w-full py-2 bg-red-600 hover:bg-red-700 text-white font-bold font-mono text-xs rounded-xl uppercase cursor-pointer"
                >
                  Confirm Sign Out
                </button>
                <button
                  onClick={() => setShowLogoutAlert(false)}
                  className="w-full py-2 bg-stone-950 border border-stone-800 text-stone-300 font-mono text-xs rounded-xl uppercase cursor-pointer"
                >
                  Cancel
                </button>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>

    </div>
  );
}
