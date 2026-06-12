import React, { useState, useRef, useEffect } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { Camera, Image, Check, CheckCircle2, AlertCircle, X, ChevronRight, Loader2, Sparkles } from 'lucide-react';
import { MOCK_UPLOADS_PRESETS } from '../data';
import { CategoryType, ImageItem } from '../types';

interface UploadViewProps {
  onUploadComplete: (newImage: ImageItem) => void;
  onCancel: () => void;
  activeUserId?: string;
  activeUserName?: string;
}

export default function UploadView({
  onUploadComplete,
  onCancel,
  activeUserId = 'user_default',
  activeUserName = 'Amelia Rose',
}: UploadViewProps) {
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [category, setCategory] = useState<Exclude<CategoryType, 'All'>>('Animals');
  const [location, setLocation] = useState('Chamonix, France');
  const [imageUrl, setImageUrl] = useState('');
  const [uploading, setUploading] = useState(false);
  const [uploadProgress, setUploadProgress] = useState(0);
  const [isCameraActive, setIsCameraActive] = useState(false);
  const [errorText, setErrorText] = useState('');
  
  // Real camera streams support
  const videoRef = useRef<HTMLVideoElement>(null);
  const [stream, setStream] = useState<MediaStream | null>(null);

  useEffect(() => {
    return () => {
      if (stream) {
        stream.getTracks().forEach((track) => track.stop());
      }
    };
  }, [stream]);

  const startCamera = async () => {
    setIsCameraActive(true);
    try {
      if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
        const mediaStream = await navigator.mediaDevices.getUserMedia({ video: { facingMode: 'environment' } });
        setStream(mediaStream);
        if (videoRef.current) {
          videoRef.current.srcObject = mediaStream;
        }
      }
    } catch (e) {
      console.log('Camera capture fallback activated:', e);
    }
  };

  const stopCamera = () => {
    if (stream) {
      stream.getTracks().forEach((track) => track.stop());
      setStream(null);
    }
    setIsCameraActive(false);
  };

  const capturePhotoSimulated = () => {
    // Pick a gorgeous preset image at random as the snap results
    const randPresetIndex = Math.floor(Math.random() * MOCK_UPLOADS_PRESETS.length);
    const selectedCap = MOCK_UPLOADS_PRESETS[randPresetIndex];
    setImageUrl(selectedCap);
    stopCamera();
    
    // Auto-generate cute title if empty
    if (!title) {
      const generatedTitles = {
        Animals: ['Majestic Sentinel', 'Curious Meadow Goats', 'Charming Herd Companion'],
        Birds: ['Gilded Forest Wing', 'Sunlit Tree Sentinel', 'Azure Feather Watcher'],
        Nature: ['Alpine Canopy Glow', 'Misty Creek Cascade', 'Hidden Valley Sanctuary']
      };
      const titlesGroup = generatedTitles[category];
      const randomT = titlesGroup[Math.floor(Math.random() * titlesGroup.length)];
      setTitle(randomT);
    }
    setErrorText('');
  };

  const handlePresetSelect = (url: string) => {
    setImageUrl(url);
    setErrorText('');
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!imageUrl) {
      setErrorText('Please select or capture a sanctuary photo first.');
      return;
    }
    if (!title.trim()) {
      setErrorText('Please assign a title to your wildlife record.');
      return;
    }

    setUploading(true);
    setUploadProgress(0);

    // Dynamic GetX progress simulate
    const interval = setInterval(() => {
      setUploadProgress((prev) => {
        if (prev >= 100) {
          clearInterval(interval);
          setTimeout(() => {
            const newItem: ImageItem = {
              id: `custom_${Date.now()}`,
              title: title.trim(),
              description: description.trim() || `A pristine photograph of a wild ${category.slice(0, -1).toLowerCase()} residing inside a natural reserve habitat.`,
              category,
              imageUrl,
              uploadDate: new Date().toISOString().split('T')[0],
              uploaderName: activeUserName,
              downloadsCount: 0,
              likesCount: 0,
              userId: activeUserId,
              tags: [category, 'Sanctuary', 'Pristine'],
              location: location.trim() || 'Global Sanctuary'
            };
            onUploadComplete(newItem);
            setUploading(false);
          }, 400);
          return 100;
        }
        return prev + 25;
      });
    }, 150);
  };

  return (
    <div className="w-full h-full bg-stone-950 flex flex-col overflow-y-auto pb-10">
      
      {/* 1. Appbar and Title */}
      <div className="px-5 pt-6 pb-2.5 bg-stone-900/40 border-b border-stone-900 flex items-center justify-between sticky top-0 z-30 backdrop-blur-md">
        <button
          onClick={onCancel}
          className="w-8 h-8 rounded-full bg-stone-900 flex items-center justify-center text-stone-400 hover:text-white cursor-pointer"
        >
          <X className="w-4 h-4" />
        </button>
        <h2 className="text-sm font-bold text-stone-100 font-sans tracking-tight">Upload Capture</h2>
        <div className="w-8" /> {/* Balance */}
      </div>

      <form onSubmit={handleSubmit} className="p-5 space-y-5">
        
        {/* 2. Camera Frame Viewport */}
        <div className="relative w-full h-[220px] rounded-[24px] bg-stone-900/60 border border-stone-850 flex flex-col items-center justify-center overflow-hidden">
          
          <AnimatePresence mode="wait">
            {!imageUrl && !isCameraActive ? (
              <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                className="flex flex-col items-center space-y-3 p-4 text-center cursor-pointer"
              >
                <div className="w-14 h-14 bg-gradient-to-tr from-emerald-500/20 to-lime-500/20 rounded-full flex items-center justify-center text-emerald-400 border border-emerald-500/10">
                  <Camera className="w-6 h-6" />
                </div>
                <div>
                  <h3 className="text-xs font-bold text-stone-200">No Image Captured</h3>
                  <p className="text-[10px] text-stone-500 mt-0.5">Use camera shutter or pick gorgeous preset</p>
                </div>
                <div className="flex gap-2.5 pt-1.5">
                  <button
                    type="button"
                    onClick={startCamera}
                    className="px-4 py-2 bg-gradient-to-r from-emerald-500 to-lime-500 hover:from-emerald-600 hover:to-lime-650 text-stone-950 text-[10px] font-bold font-mono rounded-full uppercase tracking-wider transition-colors cursor-pointer"
                  >
                    Launch Camera
                  </button>
                </div>
              </motion.div>
            ) : isCameraActive ? (
              <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                className="absolute inset-0 w-full h-full flex flex-col items-center justify-between"
              >
                {/* Active scan overlay frame */}
                <div className="absolute inset-x-6 top-8 bottom-16 border border-dashed border-emerald-500/30 rounded-xl" />
                <div className="absolute top-2 left-3 z-10 flex items-center gap-1.5 font-mono text-[9px] text-emerald-400 uppercase tracking-widest bg-stone-950/80 px-2 py-0.5 rounded">
                  <span className="w-1.5 h-1.5 bg-red-500 rounded-full animate-ping" />
                  <span>Interactive Shutter</span>
                </div>

                {/* Stream or scan indicator */}
                {stream ? (
                  <video
                    ref={videoRef}
                    autoPlay
                    playsInline
                    className="w-full h-full object-cover"
                  />
                ) : (
                  <div className="w-full h-full bg-stone-950 flex flex-col items-center justify-center relative p-4 text-center">
                    <div className="absolute left-0 right-0 h-0.5 bg-emerald-500/40 top-[50%] animate-bounce pointer-events-none" />
                    <Sparkles className="w-8 h-8 text-emerald-500/60 animate-pulse mb-1.5" />
                    <p className="text-[10px] font-mono text-stone-400">CONNECTING CAMERA HARDWARE...</p>
                    <p className="text-[9px] text-stone-500 max-w-[200px] mt-1">Webcam stream requested. Snapping simulates matching a high-definition wildlife asset.</p>
                  </div>
                )}

                {/* Shutter buttons */}
                <div className="relative z-10 w-full bg-stone-950/90 py-2.5 px-4 flex items-center justify-between border-t border-stone-900">
                  <button
                    type="button"
                    onClick={stopCamera}
                    className="text-[10px] font-mono text-stone-400 hover:text-white uppercase tracking-wider"
                  >
                    Close
                  </button>
                  <button
                    type="button"
                    onClick={capturePhotoSimulated}
                    className="w-10 h-10 rounded-full bg-gradient-to-tr from-emerald-500 to-lime-400 p-0.5"
                  >
                    <div className="w-full h-full rounded-full bg-stone-950 flex items-center justify-center text-xs text-white">
                      📸
                    </div>
                  </button>
                  <div className="w-8" />
                </div>
              </motion.div>
            ) : (
              <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                className="absolute inset-0 w-full h-full"
              >
                <img
                  src={imageUrl}
                  alt="Captured Sanctuary"
                  className="w-full h-full object-cover"
                  referrerPolicy="no-referrer"
                />
                <button
                  type="button"
                  onClick={() => setImageUrl('')}
                  className="absolute top-3 right-3 w-7 h-7 rounded-full bg-stone-950/80 backdrop-blur-md flex items-center justify-center text-stone-300 hover:text-white border border-white/10"
                >
                  <X className="w-3.5 h-3.5" />
                </button>
              </motion.div>
            )}
          </AnimatePresence>

        </div>

        {/* 3. Preset Selection Gallery */}
        {!isCameraActive && (
          <div className="space-y-2">
            <label className="text-[10px] font-mono uppercase tracking-wider text-stone-400 font-bold block">
              Quick Gallery Presets
            </label>
            <div className="flex gap-2.5 overflow-x-auto pb-1 scrollbar-none">
              {MOCK_UPLOADS_PRESETS.map((preset, index) => (
                <div
                  key={index}
                  onClick={() => handlePresetSelect(preset)}
                  className={`w-14 h-14 rounded-xl overflow-hidden shrink-0 relative cursor-pointer border-2 transition-all ${
                    imageUrl === preset ? 'border-emerald-500 scale-95 shadow-md shadow-emerald-500/10' : 'border-stone-850 hover:border-stone-700'
                  }`}
                >
                  <img
                    src={preset}
                    alt={`Preset ${index + 1}`}
                    className="w-full h-full object-cover"
                    referrerPolicy="no-referrer"
                  />
                  {imageUrl === preset && (
                    <div className="absolute inset-0 bg-emerald-950/60 flex items-center justify-center">
                      <Check className="w-4 h-4 text-emerald-400" />
                    </div>
                  )}
                </div>
              ))}
            </div>
          </div>
        )}

        {/* 4. Category selector */}
        <div className="space-y-2">
          <label className="text-[10px] font-mono uppercase tracking-wider text-stone-400 font-bold block">
            Select Sanctuary Category
          </label>
          <div className="grid grid-cols-3 gap-2.5">
            {(['Animals', 'Birds', 'Nature'] as const).map((cat) => (
              <button
                key={cat}
                type="button"
                onClick={() => setCategory(cat)}
                className={`py-2 px-3 rounded-full text-xs font-mono font-medium tracking-wide transition-all ${
                  category === cat
                    ? 'bg-gradient-to-r from-emerald-500 to-lime-400 text-stone-950 font-bold'
                    : 'bg-stone-900 text-stone-400 border border-stone-850'
                }`}
              >
                {cat === 'Animals' ? '🐐 ' : cat === 'Birds' ? '🐦 ' : '🌲 '}
                {cat}
              </button>
            ))}
          </div>
        </div>

        {/* 5. Inputs */}
        <div className="space-y-4 pt-1">
          <div className="space-y-1.5">
            <label className="text-[10px] font-mono uppercase tracking-wider text-stone-400 font-bold block">
              Capture Title
            </label>
            <input
              type="text"
              placeholder="e.g. Golden Crested Crest"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              className="w-full px-4 py-3 bg-stone-900 border border-stone-850 rounded-2xl text-xs text-stone-200 placeholder-stone-600 focus:outline-none focus:border-emerald-500/50 transition-colors"
            />
          </div>

          <div className="space-y-1.5">
            <label className="text-[10px] font-mono uppercase tracking-wider text-stone-400 font-bold block">
              Observed Location
            </label>
            <input
              type="text"
              placeholder="e.g. Kyoto, Japan"
              value={location}
              onChange={(e) => setLocation(e.target.value)}
              className="w-full px-4 py-3 bg-stone-900 border border-stone-850 rounded-2xl text-xs text-stone-200 placeholder-stone-600 focus:outline-none focus:border-emerald-500/50 transition-colors"
            />
          </div>

          <div className="space-y-1.5">
            <label className="text-[10px] font-mono uppercase tracking-wider text-stone-400 font-bold block">
              Species & Native Habitat Description
            </label>
            <textarea
              placeholder="Provide information regarding current climate status, nesting depth, or unique behavioral notes..."
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              rows={3}
              className="w-full px-4 py-3 bg-stone-900 border border-stone-850 rounded-2xl text-xs text-stone-200 placeholder-stone-600 focus:outline-none focus:border-emerald-500/50 transition-colors resize-none"
            />
          </div>
        </div>

        {/* 6. Errors */}
        {errorText && (
          <div className="p-3 bg-red-950/20 border border-red-500/20 rounded-xl flex items-center gap-2.5 text-xs text-red-400 font-mono">
            <AlertCircle className="w-4 h-4 shrink-0" />
            <span>{errorText}</span>
          </div>
        )}

        {/* 7. Action Button */}
        <div className="pt-2">
          {uploading ? (
            <div className="space-y-3 p-4 bg-stone-900 border border-stone-850 rounded-2xl text-center">
              <div className="flex items-center justify-between text-xs font-mono text-stone-300">
                <span className="flex items-center gap-1.5 font-bold">
                  <Loader2 className="w-3.5 h-3.5 text-emerald-400 animate-spin" />
                  <span>TRANSMITTING IMAGE DATA</span>
                </span>
                <span>{uploadProgress}%</span>
              </div>
              <div className="w-full h-1.5 bg-stone-800 rounded-full overflow-hidden">
                <motion.div
                  initial={{ width: 0 }}
                  animate={{ width: `${uploadProgress}%` }}
                  className="h-full bg-gradient-to-r from-emerald-500 to-lime-400 rounded-full"
                />
              </div>
              <p className="text-[9px] text-stone-500 font-mono uppercase tracking-widest text-center mt-1">
                Updating local storage state store...
              </p>
            </div>
          ) : (
            <button
              type="submit"
              className="w-full py-4 bg-gradient-to-r from-emerald-500 to-lime-400 text-stone-950 text-xs font-bold font-mono tracking-wider items-center justify-center rounded-2xl uppercase shadow-lg shadow-emerald-500/5 transition-all hover:brightness-105 select-none cursor-pointer"
            >
              Upload Species Record
            </button>
          )}
        </div>

      </form>
    </div>
  );
}
