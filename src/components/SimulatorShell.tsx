import React, { useState, useEffect } from 'react';
import { motion } from 'motion/react';
import { Sparkles, Phone, Monitor, Info, Code, Play, Laptop, HelpCircle, HardDrive, RefreshCw } from 'lucide-react';
import { ScreenType } from '../types';

interface SimulatorShellProps {
  children: React.ReactNode;
  activeScreen: ScreenType;
  onScreenChange: (screen: ScreenType) => void;
  isLightTheme: boolean;
  onThemeToggle: () => void;
  onAddMockData: () => void;
  onResetData: () => void;
}

export default function SimulatorShell({
  children,
  activeScreen,
  onScreenChange,
  isLightTheme,
  onThemeToggle,
  onAddMockData,
  onResetData,
}: SimulatorShellProps) {
  const [timeStr, setTimeStr] = useState('12:20');

  useEffect(() => {
    const updateTime = () => {
      const now = new Date();
      let hours = now.getHours();
      let minutes = now.getMinutes();
      const hStr = hours < 10 ? `0${hours}` : hours;
      const mStr = minutes < 10 ? `0${minutes}` : minutes;
      setTimeStr(`${hStr}:${mStr}`);
    };
    updateTime();
    const interval = setInterval(updateTime, 60000);
    return () => clearInterval(interval);
  }, []);

  return (
    <div className={`min-h-screen w-full transition-colors duration-500 flex flex-col justify-between ${
      isLightTheme ? 'bg-stone-50 text-stone-900' : 'bg-stone-950 text-stone-100'
    }`}>
      
      {/* 1. Universal Glass Header */}
      <header className={`w-full py-4 px-6 border-b flex flex-col md:flex-row items-center justify-between gap-4 backdrop-blur-md sticky top-0 z-40 transition-colors ${
        isLightTheme ? 'bg-white/90 border-stone-200' : 'bg-stone-900/40 border-stone-900'
      }`}>
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 bg-gradient-to-tr from-emerald-500 to-lime-400 rounded-xl flex items-center justify-center text-stone-950 shadow-md">
            <span className="text-xl">🐐</span>
          </div>
          <div className="text-left">
            <div className="flex items-center gap-2">
              <h1 className="text-base font-bold font-sans tracking-tight">Welcome Goats</h1>
              <span className="px-2 py-0.5 rounded-full bg-emerald-500/10 border border-emerald-500/30 text-[9px] font-mono font-bold text-emerald-500">
                PRO ACTIVE MOCKUP
              </span>
            </div>
            <p className="text-[11px] text-stone-500 font-sans">
              Interactive Species Sanctuary & Wildlife Dashboard
            </p>
          </div>
        </div>

        {/* Global Control Widgets */}
        <div className="flex items-center gap-3">
          <button
            onClick={onThemeToggle}
            className={`p-2 rounded-xl border flex items-center gap-1.5 text-xs font-mono transition-colors cursor-pointer ${
              isLightTheme ? 'bg-stone-100 border-stone-200 hover:bg-stone-200' : 'bg-stone-900 border-stone-800 hover:bg-stone-850'
            }`}
            title="Toggle theme inside prototype"
          >
            <span>{isLightTheme ? '☀️ Light' : '🌙 Nature Dark'}</span>
          </button>
        </div>
      </header>

      {/* 2. Main Simulator Split View layout */}
      <main className="flex-1 max-w-7xl w-full mx-auto p-4 md:p-8 grid grid-cols-1 lg:grid-cols-12 gap-8 items-center justify-center">
        
        {/* Left Side: Dynamic Instruction Console & Seed Deck (Lg target: 5 cols) */}
        <div className="lg:col-span-5 space-y-6 text-left order-2 lg:order-1">
          
          <div className={`p-6 rounded-3xl border transition-colors ${
            isLightTheme ? 'bg-white border-stone-200 shadow-sm' : 'bg-stone-900/30 border-stone-900'
          }`}>
            <span className="text-[9px] font-mono uppercase tracking-widest text-emerald-500 font-bold block mb-1">
              Interactive Blueprint
            </span>
            <h2 className="text-xl font-bold font-sans tracking-tight mb-2.5">
              Experience the Nature sanctuary inside a mobile simulator
            </h2>
            <p className="text-xs text-stone-500 leading-relaxed mb-4">
              To perfectly handle high fidelity, we created a fully responsive smartphone emulator with 6 custom views. Feel free to interact with any screen inside the device frame. Upload records, toggle favorites, trigger fake high-speed downloads, or swap layouts dynamically using the quick dashboard triggers.
            </p>

            {/* Quick Navigation Trigger Toolbar */}
            <div className="space-y-2">
              <span className="text-[10px] font-mono text-stone-400 block font-bold">SCREEN JUMP SWITCHER</span>
              <div className="grid grid-cols-3 gap-2">
                {[
                  { id: 'splash', label: 'Splash Screen' },
                  { id: 'home', label: 'Sanctuary Feed' },
                  { id: 'upload', label: 'Upload Capture' },
                  { id: 'details', label: 'Image Details' },
                  { id: 'my_uploads', label: 'My Submissions' },
                  { id: 'profile', label: 'User Profile' }
                ].map((s) => (
                  <button
                    key={s.id}
                    onClick={() => onScreenChange(s.id as ScreenType)}
                    className={`py-2 px-1 text-[10px] font-mono rounded-lg transition-all border text-center ${
                      activeScreen === s.id
                        ? 'bg-emerald-500/10 border-emerald-500/40 text-emerald-500 font-bold'
                        : isLightTheme
                          ? 'bg-stone-50 border-stone-200 text-stone-600 hover:bg-stone-100'
                          : 'bg-stone-900/60 border-stone-850 text-stone-400 hover:bg-stone-850'
                    }`}
                  >
                    {s.label}
                  </button>
                ))}
              </div>
            </div>
          </div>

          {/* Quick simulator operations */}
          <div className={`p-6 rounded-3xl border transition-colors ${
            isLightTheme ? 'bg-white border-stone-200 shadow-sm' : 'bg-stone-900/30 border-stone-900'
          }`}>
            <h3 className="text-xs font-mono uppercase tracking-widest text-stone-400 font-bold mb-3">
              Simulator Seed Operations
            </h3>
            
            <div className="grid grid-cols-2 gap-3">
              <button
                onClick={onAddMockData}
                className="p-3 text-left bg-emerald-500/10 border border-emerald-500/20 rounded-2xl group hover:bg-emerald-500/15 transition-all text-xs font-medium cursor-pointer"
              >
                <div className="text-emerald-500 text-sm mb-1">🐾</div>
                <h4 className="text-stone-300 font-bold">Seed Elements</h4>
                <p className="text-[10px] text-stone-500 mt-0.5 leading-snug">Adds simulated wildlife camera records instantly.</p>
              </button>

              <button
                onClick={onResetData}
                className="p-3 text-left bg-stone-900/60 border border-stone-850 rounded-2xl group hover:bg-stone-800/80 transition-all text-xs font-medium cursor-pointer"
              >
                <div className="text-stone-300 text-sm mb-1">♻️</div>
                <h4 className="text-stone-400 font-bold">Reset Presets</h4>
                <p className="text-[10px] text-stone-500 mt-0.5 leading-snug">Reverts local submissions to default clean arrays.</p>
              </button>
            </div>
          </div>

          {/* Live metadata telemetry line */}
          <div className="flex items-center gap-2 p-3 px-4 rounded-xl bg-emerald-500/5 border border-emerald-500/10 text-[10px] text-stone-400 font-mono">
            <span className="w-2 h-2 rounded-full bg-emerald-500 animate-ping" />
            <span>Interactive sandbox synced with React State & LocalStorage.</span>
          </div>

        </div>

        {/* Right Side: Virtual Phone Deck (Lg target: 7 cols) */}
        <div className="lg:col-span-7 flex justify-center order-1 lg:order-2 py-4">
          
          <div className="relative w-[340px] h-[700px] bg-stone-900 rounded-[50px] p-[10px] shadow-[0_25px_60px_-15px_rgba(0,0,0,0.6)] border-[4px] border-stone-800 relative ring-12 ring-stone-950/80">
            
            {/* Phone Speaker & Camera Notch */}
            <div className="absolute top-2 left-1/2 -translate-x-1/2 w-32 h-6 bg-stone-900 rounded-b-2xl z-40 flex items-center justify-center gap-2 border-b border-white/5">
              <div className="w-10 h-1 bg-stone-800 rounded-full" /> {/* Ear Speaker */}
              <div className="w-2.5 h-2.5 bg-sky-950 rounded-full border border-sky-900" /> {/* Front Camera lens */}
            </div>

            {/* Inner Phone Screen Container */}
            <div className={`w-full h-full rounded-[40px] overflow-hidden relative flex flex-col transition-colors duration-500 ${
              isLightTheme ? 'bg-stone-950' : 'bg-stone-950'
            }`}>
              
              {/* Virtual Telephone Notch Bar */}
              <div className="absolute top-0 inset-x-0 h-7 bg-stone-950/30 z-40 flex items-center justify-between px-6 select-none pointer-events-none text-[10px] font-mono text-stone-300">
                <span className="font-bold">{timeStr}</span>
                <div className="flex items-center gap-1.5 opacity-90">
                  <span>📶</span>
                  <span>📶</span>
                  <span>🔋 98%</span>
                </div>
              </div>

              {/* Display Main Screen Content slot */}
              <div className="flex-1 w-full h-full relative overflow-hidden pt-7">
                {children}
              </div>

              {/* Bottom Navigation Pills (Styled exactly like Flutter custom appbars or screens) */}
              {activeScreen !== 'splash' && (
                <div className="absolute bottom-4 inset-x-4 bg-stone-900/90 backdrop-blur-md border border-stone-850 h-16 rounded-[24px] z-45 flex items-center justify-around px-2 shadow-lg">
                  
                  {/* Home menu button */}
                  <button
                    onClick={() => onScreenChange('home')}
                    className={`flex flex-col items-center justify-center w-12 h-12 rounded-xl transition-all ${
                      activeScreen === 'home' ? 'text-emerald-400 bg-stone-850/60' : 'text-stone-500 hover:text-stone-300'
                    }`}
                  >
                    <span className="text-lg">🏕️</span>
                    <span className="text-[8px] font-mono mt-0.5">Feed</span>
                  </button>

                  {/* Upload launch button */}
                  <button
                    onClick={() => onScreenChange('upload')}
                    className={`flex flex-col items-center justify-center w-12 h-12 rounded-xl transition-all ${
                      activeScreen === 'upload' ? 'text-lime-400 bg-stone-850/60' : 'text-stone-500 hover:text-stone-300'
                    }`}
                  >
                    <span className="text-lg">📸</span>
                    <span className="text-[8px] font-mono mt-0.5">Upload</span>
                  </button>

                  {/* My Uploads menu button */}
                  <button
                    onClick={() => onScreenChange('my_uploads')}
                    className={`flex flex-col items-center justify-center w-12 h-12 rounded-xl transition-all ${
                      activeScreen === 'my_uploads' ? 'text-emerald-400 bg-stone-850/60' : 'text-stone-500 hover:text-stone-300'
                    }`}
                  >
                    <span className="text-lg">📁</span>
                    <span className="text-[8px] font-mono mt-0.5">My Vault</span>
                  </button>

                  {/* User Profile menu button */}
                  <button
                    onClick={() => onScreenChange('profile')}
                    className={`flex flex-col items-center justify-center w-12 h-12 rounded-xl transition-all ${
                      activeScreen === 'profile' ? 'text-emerald-400 bg-stone-850/60' : 'text-stone-500 hover:text-stone-300'
                    }`}
                  >
                    <span className="text-lg">👤</span>
                    <span className="text-[8px] font-mono mt-0.5">Profile</span>
                  </button>

                </div>
              )}

              {/* Simulated Home Screen Drag Pill Indicator */}
              <div className="absolute bottom-1 left-1/2 -translate-x-1/2 w-28 h-1 bg-stone-700/65 rounded-full z-45" />

            </div>
          </div>

        </div>

      </main>

      {/* 3. Global Footer copyright */}
      <footer className={`py-6 px-6 text-center border-t text-[11px] font-mono transition-colors ${
        isLightTheme ? 'bg-stone-100 border-stone-200 text-stone-500' : 'bg-stone-900/30 border-stone-900 text-stone-600'
      }`}>
        <p>© 2026 Welcome Goats Sanctuary Ecosystem • Designed with React & Tailwind CSS</p>
        <p className="text-emerald-500/50 mt-1 uppercase text-[9px] font-bold">STATE ENGINE POWERED BY WEB LOCAL STORAGE PERSISTENCE</p>
      </footer>

    </div>
  );
}
