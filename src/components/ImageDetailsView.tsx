import React, { useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { Heart, Download, Share2, MapPin, Calendar, User, Eye, ArrowLeft, ZoomIn, ZoomOut, CheckCircle, RefreshCw } from 'lucide-react';
import { ImageItem } from '../types';

interface ImageDetailsViewProps {
  image: ImageItem;
  onBack: () => void;
  onFavoriteToggle: (id: string) => void;
}

export default function ImageDetailsView({
  image,
  onBack,
  onFavoriteToggle,
}: ImageDetailsViewProps) {
  const [zoomLevel, setZoomLevel] = useState(1);
  const [isFavorited, setIsFavorited] = useState(image.isFavorite || false);
  const [downloading, setDownloading] = useState(false);
  const [downloadProgress, setDownloadProgress] = useState(0);
  const [showShareModal, setShowShareModal] = useState(false);
  const [isCopied, setIsCopied] = useState(false);

  const handleFavoriteClick = () => {
    setIsFavorited(!isFavorited);
    onFavoriteToggle(image.id);
  };

  const handleDownloadClick = () => {
    if (downloading) return;
    setDownloading(true);
    setDownloadProgress(0);

    const interval = setInterval(() => {
      setDownloadProgress((prev) => {
        if (prev >= 100) {
          clearInterval(interval);
          setTimeout(() => {
            // Real browser download trigger fallback
            try {
              const link = document.createElement('a');
              link.href = image.imageUrl;
              link.target = '_blank';
              link.download = `${image.title.replace(/\s+/g, '_')}.jpg`;
              document.body.appendChild(link);
              link.click();
              document.body.removeChild(link);
            } catch (e) {
              console.log('Download trigger error: ', e);
            }
            setDownloading(false);
          }, 600);
          return 100;
        }
        return prev + 10;
      });
    }, 120);
  };

  const handleCopyLink = () => {
    navigator.clipboard.writeText(image.imageUrl);
    setIsCopied(true);
    setTimeout(() => setIsCopied(false), 2000);
  };

  return (
    <div className="w-full h-full bg-stone-950 flex flex-col relative overflow-hidden select-none">
      
      {/* 1. Header Toolbar Overlay */}
      <div className="absolute top-0 inset-x-0 z-30 p-5 bg-gradient-to-b from-stone-950/80 to-transparent flex items-center justify-between">
        <button
          onClick={onBack}
          className="w-10 h-10 rounded-full bg-stone-900/80 backdrop-blur-md flex items-center justify-center text-stone-200 border border-white/5 hover:bg-stone-850 cursor-pointer"
        >
          <ArrowLeft className="w-4 h-4" />
        </button>
        <span className="px-3.5 py-1 rounded-full bg-emerald-500/10 border border-emerald-500/20 text-[10px] font-bold text-emerald-400 font-mono uppercase tracking-widest">
          {image.category}
        </span>
        <button
          onClick={handleFavoriteClick}
          className="w-10 h-10 rounded-full bg-stone-900/80 backdrop-blur-md flex items-center justify-center text-stone-200 border border-white/5 hover:bg-stone-850 cursor-pointer"
        >
          <Heart className={`w-4 h-4 transition-colors ${isFavorited ? 'text-red-500 fill-red-500' : 'text-stone-300'}`} />
        </button>
      </div>

      {/* 2. Fullscreen Image with Zoom Container */}
      <div className="flex-1 w-full flex items-center justify-center bg-stone-950 relative overflow-hidden">
        <div 
          className="w-full h-[65%] flex items-center justify-center transition-transform duration-300"
          style={{ transform: `scale(${zoomLevel})` }}
        >
          <img
            src={image.imageUrl}
            alt={image.title}
            className="w-full h-full object-cover select-none pointer-events-none"
            referrerPolicy="no-referrer"
          />
        </div>

        {/* Ambient Blurred Background Glow */}
        <div 
          className="absolute inset-0 -z-10 opacity-30 blur-[60px]"
          style={{ backgroundImage: `url(${image.imageUrl})`, backgroundSize: 'cover' }}
        />

        {/* Zoom Controls Overlay */}
        <div className="absolute top-20 right-4 z-20 flex flex-col gap-2 bg-stone-900/60 backdrop-blur-md p-1.5 rounded-full border border-white/5">
          <button
            onClick={() => setZoomLevel((z) => Math.min(z + 0.25, 2.5))}
            className="w-8 h-8 rounded-full flex items-center justify-center text-stone-300 hover:text-white"
          >
            <ZoomIn className="w-4 h-4" />
          </button>
          <button
            onClick={() => setZoomLevel((z) => Math.max(z - 0.25, 1))}
            className="w-8 h-8 rounded-full flex items-center justify-center text-stone-300 hover:text-white"
          >
            <ZoomOut className="w-4 h-4" />
          </button>
        </div>
      </div>

      {/* 3. Sliding Glassmorphic Info Sheet */}
      <div className="w-full bg-stone-900/90 border-t border-stone-850 rounded-t-[32px] p-6 pb-26 relative z-10 space-y-4">
        
        {/* Detail Meta lines */}
        <div className="space-y-1.5">
          <div className="flex items-center gap-2 text-[10px] text-stone-400 font-mono">
            <span className="flex items-center gap-1">
              <Calendar className="w-3 h-3 text-emerald-500" />
              {image.uploadDate}
            </span>
            <span>•</span>
            <span className="flex items-center gap-1">
              <User className="w-3 h-3 text-lime-400" />
              {image.uploaderName}
            </span>
          </div>

          <h1 className="text-xl font-bold text-stone-100 font-sans tracking-tight leading-snug">
            {image.title}
          </h1>

          <p className="flex items-center gap-1 text-xs text-stone-400 font-mono">
            <MapPin className="w-3.5 h-3.5 text-red-400 shrink-0" />
            <span>{image.location || 'Global Sanctuary Habitat'}</span>
          </p>
        </div>

        {/* Short Species Report */}
        <div className="space-y-1">
          <span className="text-[9px] font-mono uppercase tracking-widest text-stone-500 font-bold">
            OBSERVATIONAL HIGHLIGHT
          </span>
          <p className="text-xs text-stone-300 font-sans leading-relaxed">
            {image.description}
          </p>
        </div>

        {/* Preset Hash tags */}
        {image.tags && image.tags.length > 0 && (
          <div className="flex flex-wrap gap-1.5 pt-1">
            {image.tags.map((tag) => (
              <span key={tag} className="px-2.5 py-1 rounded bg-stone-950 border border-stone-850 text-[9px] font-mono text-stone-400">
                #{tag}
              </span>
            ))}
          </div>
        )}

        {/* Action Button Row */}
        <div className="grid grid-cols-2 gap-3 pt-2.5">
          
          <button
            onClick={handleDownloadClick}
            className="flex items-center justify-center gap-2 py-3.5 bg-gradient-to-r from-emerald-500 to-emerald-600 text-stone-950 font-bold font-mono text-[11px] rounded-xl uppercase tracking-wider shadow-lg hover:brightness-105 cursor-pointer"
          >
            <Download className="w-3.5 h-3.5" />
            <span>Download</span>
          </button>

          <button
            onClick={() => setShowShareModal(true)}
            className="flex items-center justify-center gap-2 py-3.5 bg-stone-950 text-stone-200 border border-stone-800 font-bold font-mono text-[11px] rounded-xl uppercase tracking-wider hover:bg-stone-850 cursor-pointer"
          >
            <Share2 className="w-3.5 h-3.5 text-lime-400" />
            <span>Share</span>
          </button>

        </div>
      </div>

      {/* 4. Download HUD Progress Overlay */}
      <AnimatePresence>
        {downloading && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="absolute inset-0 bg-stone-950/90 backdrop-blur-md z-50 flex flex-col items-center justify-center p-6 text-center"
          >
            <motion.div
              initial={{ scale: 0.9, y: 10 }}
              animate={{ scale: 1, y: 0 }}
              className="max-w-xs space-y-5 bg-stone-900 border border-stone-800 p-6 rounded-[28px] shadow-2xl"
            >
              <div className="w-16 h-16 rounded-full bg-emerald-500/10 flex items-center justify-center mx-auto text-emerald-400 relative">
                <RefreshCw className="w-6 h-6 animate-spin" />
              </div>

              <div className="space-y-1.5">
                <h3 className="text-sm font-bold text-white uppercase font-mono tracking-wider">SAVING TO DEVICE</h3>
                <p className="text-[10px] text-stone-400 font-sans leading-relaxed">
                  Caching high-fidelity matrix colors of <strong>{image.title}</strong> directly to local storage.
                </p>
              </div>

              <div className="space-y-1">
                <div className="flex items-center justify-between text-[11px] font-mono text-emerald-400">
                  <span>Progress</span>
                  <span>{downloadProgress}%</span>
                </div>
                <div className="w-full h-1.5 bg-stone-800 rounded-full overflow-hidden">
                  <div
                    className="h-full bg-emerald-400 rounded-full transition-all duration-100"
                    style={{ width: `${downloadProgress}%` }}
                  />
                </div>
              </div>

              <div className="text-[9px] font-mono text-stone-500">
                GETX Downloader trigger • Native Android/iOS simulation
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* 5. Share Options Modal */}
      <AnimatePresence>
        {showShareModal && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="absolute inset-0 bg-stone-950/80 backdrop-blur-sm z-50 flex items-end justify-center"
          >
            <motion.div
              initial={{ y: '100%' }}
              animate={{ y: 0 }}
              exit={{ y: '100%' }}
              transition={{ type: 'spring', damping: 25, stiffness: 220 }}
              className="w-full bg-stone-900 border-t border-stone-800 rounded-t-[32px] p-6 pb-12 space-y-5"
            >
              <div className="flex items-center justify-between">
                <h3 className="text-xs uppercase font-mono tracking-widest text-stone-400 font-bold">Share Species Record</h3>
                <button
                  onClick={() => { setShowShareModal(false); setIsCopied(false); }}
                  className="w-7 h-7 rounded-full bg-stone-950 flex items-center justify-center text-stone-400"
                >
                  <XIcon className="w-3.5 h-3.5" />
                </button>
              </div>

              <div className="grid grid-cols-4 gap-3 text-center">
                <div className="space-y-1.5 cursor-pointer" onClick={handleCopyLink}>
                  <div className="w-11 h-11 bg-stone-950 rounded-2xl flex items-center justify-center mx-auto text-stone-200 hover:bg-stone-800">
                    🔗
                  </div>
                  <span className="text-[10px] text-stone-400 font-mono block">Copy URL</span>
                </div>
                <div className="space-y-1.5 cursor-pointer" onClick={handleCopyLink}>
                  <div className="w-11 h-11 bg-stone-950 rounded-2xl flex items-center justify-center mx-auto text-green-400 hover:bg-stone-800">
                    💬
                  </div>
                  <span className="text-[10px] text-stone-400 font-mono block">WhatsApp</span>
                </div>
                <div className="space-y-1.5 cursor-pointer" onClick={handleCopyLink}>
                  <div className="w-11 h-11 bg-stone-950 rounded-2xl flex items-center justify-center mx-auto text-sky-400 hover:bg-stone-800">
                    🐦
                  </div>
                  <span className="text-[10px] text-stone-400 font-mono block">Twitter</span>
                </div>
                <div className="space-y-1.5 cursor-pointer" onClick={handleCopyLink}>
                  <div className="w-11 h-11 bg-stone-950 rounded-2xl flex items-center justify-center mx-auto text-rose-500 hover:bg-stone-800">
                    📷
                  </div>
                  <span className="text-[10px] text-stone-400 font-mono block">Insta Stories</span>
                </div>
              </div>

              <AnimatePresence>
                {isCopied && (
                  <motion.div
                    initial={{ opacity: 0, scale: 0.95 }}
                    animate={{ opacity: 1, scale: 1 }}
                    exit={{ opacity: 0, scale: 0.95 }}
                    className="p-3 bg-emerald-950/20 border border-emerald-500/20 rounded-xl flex items-center gap-2 text-xs text-emerald-400 font-mono"
                  >
                    <CheckCircle className="w-4 h-4 shrink-0" />
                    <span>Copied photo sanctuary destination link!</span>
                  </motion.div>
                )}
              </AnimatePresence>

              <div className="text-[9px] text-stone-600 font-mono text-center">
                Image source: {image.imageUrl.slice(0, 48)}...
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>

    </div>
  );
}

// Quick inner X close icon helper
function XIcon(props: React.SVGProps<SVGSVGElement>) {
  return (
    <svg fill="none" stroke="currentColor" strokeWidth="2.5" viewBox="0 0 24 24" className={props.className}>
      <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
    </svg>
  );
}
