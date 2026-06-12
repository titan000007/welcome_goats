import { useState } from 'react';
import { motion } from 'motion/react';
import { Search, Compass, TrendingUp, Sparkles, MapPin, Download, Heart, ArrowUpRight, Grid, User } from 'lucide-react';
import { ImageItem, CategoryType } from '../types';

interface HomeViewProps {
  images: ImageItem[];
  onImageSelect: (image: ImageItem) => void;
  onUploadClick: () => void;
  onProfileClick: () => void;
}

export default function HomeView({
  images,
  onImageSelect,
  onUploadClick,
  onProfileClick,
}: HomeViewProps) {
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<CategoryType>('All');

  // Filter logic
  const filteredImages = images.filter((img) => {
    const matchesSearch =
      img.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      img.description.toLowerCase().includes(searchQuery.toLowerCase()) ||
      img.tags?.some((t) => t.toLowerCase().includes(searchQuery.toLowerCase()));

    const matchesCategory = selectedCategory === 'All' || img.category === selectedCategory;

    return matchesSearch && matchesCategory;
  });

  const featuredImages = images.filter((img) => img.downloadsCount > 1000).slice(0, 4);
  const trendingImages = [...images].sort((a, b) => b.likesCount - a.likesCount).slice(0, 3);

  const categoryChips: { name: CategoryType; icon: string }[] = [
    { name: 'All', icon: '🌍' },
    { name: 'Animals', icon: '🐐' },
    { name: 'Birds', icon: '🐦' },
    { name: 'Nature', icon: '🌲' },
  ];

  return (
    <div className="w-full h-full flex flex-col overflow-y-auto pb-24 scrollbar-none scroll-smooth">
      
      {/* 1. Custom AppBar */}
      <div className="w-full px-5 pt-6 pb-2 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <button
            onClick={onProfileClick}
            className="w-10 h-10 rounded-full border-2 border-emerald-500/30 overflow-hidden shadow-md flex items-center justify-center bg-stone-900 cursor-pointer"
          >
            <img
              src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=150&auto=format&fit=crop"
              alt="Profile"
              className="w-full h-full object-cover"
              referrerPolicy="no-referrer"
            />
          </button>
          <div>
            <div className="flex items-center gap-1">
              <span className="text-[11px] text-stone-400 font-mono tracking-wider uppercase">Active Sanctuary</span>
              <span className="w-1.5 h-1.5 bg-emerald-400 rounded-full animate-ping" />
            </div>
            <h2 className="text-sm font-sans font-semibold text-stone-100 flex items-center gap-1">
              Hello, Amelia <span className="text-base">👋</span>
            </h2>
          </div>
        </div>

        <div className="flex items-center gap-2">
          {/* Notification / Badge */}
          <div className="relative w-9 h-9 rounded-full bg-stone-900/60 border border-stone-800 flex items-center justify-center text-stone-300">
            <Sparkles className="w-4 h-4 text-emerald-400" />
            <span className="absolute top-1 right-1 w-2 h-2 bg-lime-500 rounded-full" />
          </div>
        </div>
      </div>

      {/* Hero Motto */}
      <div className="px-5 py-3">
        <h1 className="text-xl font-bold text-stone-100 tracking-tight leading-snug">
          Discover Wildlife & <br/>
          <span className="text-transparent bg-clip-text bg-gradient-to-r from-emerald-400 to-lime-300">Companion Animals</span>
        </h1>
      </div>

      {/* 2. Enhanced Search Bar */}
      <div className="px-5 my-2">
        <div className="relative w-full flex items-center bg-stone-900/80 border border-stone-800 rounded-2xl p-0.5 shadow-inner">
          <div className="pl-3.5 pr-2 py-2 text-stone-500">
            <Search className="w-4 h-4 text-emerald-500/80" />
          </div>
          <input
            type="text"
            placeholder="Search sparrows, goats, forests..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full bg-transparent text-xs text-stone-200 placeholder-stone-500 focus:outline-none py-2.5"
          />
          {searchQuery && (
            <button
              onClick={() => setSearchQuery('')}
              className="px-2 text-xs font-mono text-stone-450 hover:text-white"
            >
              ×
            </button>
          )}
        </div>
      </div>

      {/* 3. Category Carousel Chips */}
      <div className="px-5 py-3.5">
        <div className="flex gap-2.5 overflow-x-auto scrollbar-none py-1">
          {categoryChips.map((chip) => {
            const isSelected = selectedCategory === chip.name;
            return (
              <motion.button
                key={chip.name}
                whileTap={{ scale: 0.95 }}
                onClick={() => setSelectedCategory(chip.name)}
                className={`flex items-center gap-2 px-4 py-2.5 rounded-full text-xs font-medium cursor-pointer transition-all duration-300 shrink-0 ${
                  isSelected
                    ? 'bg-gradient-to-r from-emerald-500 to-emerald-600 text-stone-950 shadow-md shadow-emerald-500/10 font-semibold'
                    : 'bg-stone-900/90 hover:bg-stone-800 text-stone-400 border border-stone-850'
                }`}
              >
                <span>{chip.icon}</span>
                <span>{chip.name}</span>
              </motion.button>
            );
          })}
        </div>
      </div>

      {/* 4. Featured Images Slider */}
      {selectedCategory === 'All' && !searchQuery && (
        <div className="py-2">
          <div className="px-5 flex items-center justify-between mb-3">
            <div className="flex items-center gap-1.5">
              <Compass className="w-4 h-4 text-emerald-400" />
              <h3 className="text-xs uppercase font-mono tracking-widest text-stone-300 font-bold">Featured Sanctuary</h3>
            </div>
            <span className="text-[10px] text-emerald-400 font-mono cursor-pointer">swipe all</span>
          </div>

          <div className="flex gap-4 overflow-x-auto px-5 pb-3 scrollbar-none snap-x">
            {featuredImages.map((img) => (
              <motion.div
                key={img.id}
                whileHover={{ y: -3 }}
                onClick={() => onImageSelect(img)}
                className="w-[240px] h-[160px] rounded-[24px] overflow-hidden relative shrink-0 snap-start shadow-xl border border-stone-850 flex-col justify-end p-3 flex group cursor-pointer"
              >
                <img
                  src={img.imageUrl}
                  alt={img.title}
                  className="absolute inset-0 w-full h-full object-cover transition-transform duration-700 group-hover:scale-115"
                  referrerPolicy="no-referrer"
                />
                
                {/* Emerald Dark gradient cover */}
                <div className="absolute inset-0 bg-gradient-to-t from-stone-950 via-stone-950/40 to-transparent" />
                <div className="absolute inset-0 bg-emerald-950/20 mix-blend-color" />

                {/* Detail Tag */}
                <div className="relative z-10 space-y-1">
                  <span className="px-2 py-0.5 rounded-full bg-emerald-500 text-[8px] text-stone-950 uppercase font-mono font-bold tracking-wider">
                    {img.category}
                  </span>
                  <p className="text-xs font-bold text-white tracking-tight leading-snug drop-shadow-md">
                    {img.title}
                  </p>
                  <div className="flex items-center gap-2 text-[9px] text-stone-300 font-mono">
                    <span className="flex items-center gap-0.5">
                      <MapPin className="w-2.5 h-2.5 text-lime-400" />
                      {img.location ? img.location.split(',')[0] : 'Global'}
                    </span>
                    <span>•</span>
                    <span className="flex items-center gap-0.5">
                      <Download className="w-2.5 h-2.5 text-stone-400" />
                      {img.downloadsCount}
                    </span>
                  </div>
                </div>

                <div className="absolute top-3 right-3 z-10 w-6 h-6 rounded-full bg-stone-900/80 backdrop-blur-sm flex items-center justify-center border border-white/10 text-stone-200">
                  <ArrowUpRight className="w-3.5 h-3.5 text-lime-400" />
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      )}

      {/* 5. Trending Section */}
      {selectedCategory === 'All' && !searchQuery && (
        <div className="py-2 px-5">
          <div className="flex items-center justify-between mb-3">
            <div className="flex items-center gap-1.5">
              <TrendingUp className="w-4 h-4 text-emerald-400" />
              <h3 className="text-xs uppercase font-mono tracking-widest text-stone-300 font-bold">Popular Captures</h3>
            </div>
          </div>

          <div className="space-y-3">
            {trendingImages.map((img) => (
              <div
                key={img.id}
                onClick={() => onImageSelect(img)}
                className="w-full bg-stone-900/60 border border-stone-850 rounded-[20px] p-2.5 flex items-center gap-3 hover:bg-stone-850/50 transition-colors cursor-pointer group"
              >
                <div className="w-16 h-16 rounded-[14px] overflow-hidden relative shrink-0">
                  <img
                    src={img.imageUrl}
                    alt={img.title}
                    className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
                    referrerPolicy="no-referrer"
                  />
                </div>
                <div className="flex-1 min-w-0">
                  <div className="flex items-center justify-between">
                    <span className="text-[9px] font-mono uppercase tracking-wider text-emerald-400 font-semibold">{img.category}</span>
                    <span className="text-[9px] font-mono text-stone-500">{img.uploadDate}</span>
                  </div>
                  <h4 className="text-xs font-bold text-stone-100 truncate mt-0.5 group-hover:text-emerald-300 transition-colors">
                    {img.title}
                  </h4>
                  <div className="flex items-center gap-3.5 text-[10px] text-stone-400 font-mono mt-1">
                    <span className="flex items-center gap-1">
                      <Heart className="w-3 h-3 text-red-500 fill-red-500/20" />
                      {img.likesCount}
                    </span>
                    <span className="flex items-center gap-1">
                      <Download className="w-3 h-3 text-emerald-400" />
                      {img.downloadsCount}
                    </span>
                    <span className="truncate max-w-[100px]">📍 {img.location}</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* 6. Recent Uploads Grid */}
      <div className="px-5 py-4">
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center gap-1.5">
            <Grid className="w-4 h-4 text-emerald-400" />
            <h3 className="text-xs uppercase font-mono tracking-widest text-stone-300 font-bold">
              {searchQuery || selectedCategory !== 'All' ? 'Matched Captures' : 'Recent Sanctuaries'}
            </h3>
          </div>
          <span className="text-[10px] font-mono text-stone-500">
            {filteredImages.length} results
          </span>
        </div>

        {filteredImages.length === 0 ? (
          <div className="w-full py-12 text-center bg-stone-900/40 rounded-3xl border border-dashed border-stone-800">
            <p className="text-xs text-stone-400 font-medium">No sanctuary photos match your criteria.</p>
            <button
              onClick={() => { setSearchQuery(''); setSelectedCategory('All'); }}
              className="text-emerald-400 font-mono text-[10px] mt-2 underline cursor-pointer"
            >
              Reset all filters
            </button>
          </div>
        ) : (
          <div className="grid grid-cols-2 gap-3.5">
            {filteredImages.map((img) => (
              <motion.div
                key={img.id}
                whileHover={{ scale: 1.02 }}
                onClick={() => onImageSelect(img)}
                className="bg-stone-900/40 border border-stone-850 rounded-[22px] p-2 flex flex-col cursor-pointer group hover:border-emerald-500/20 transition-all duration-300"
              >
                <div className="aspect-square w-full rounded-[16px] overflow-hidden relative">
                  <img
                    src={img.imageUrl}
                    alt={img.title}
                    className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"
                    referrerPolicy="no-referrer"
                  />
                  <div className="absolute top-2 left-2 z-10 px-1.5 py-0.5 rounded bg-stone-950/80 backdrop-blur-sm border border-white/5 text-[8px] text-emerald-400 font-mono font-bold uppercase">
                    {img.category}
                  </div>
                </div>

                <div className="p-1 px-1.5 pt-2 flex-grow flex flex-col justify-between">
                  <div>
                    <h4 className="text-xs font-bold text-stone-100 truncate group-hover:text-emerald-300">
                      {img.title}
                    </h4>
                    <p className="text-[10px] text-stone-450 truncate mt-0.5">
                      by {img.uploaderName}
                    </p>
                  </div>

                  <div className="flex items-center justify-between text-[9px] text-stone-400 font-mono mt-1 pt-1.5 border-t border-stone-850/60">
                    <span className="flex items-center gap-0.5 text-red-500">
                      <Heart className="w-2.5 h-2.5 fill-red-500/10" />
                      {img.likesCount}
                    </span>
                    <span className="text-[8px]">
                      {img.location ? img.location.split(',')[0] : 'Remote'}
                    </span>
                  </div>
                </div>
              </motion.div>
            ))}
          </div>
        )}
      </div>

      {/* 7. Floating Action Button FAB */}
      <motion.button
        whileHover={{ scale: 1.08 }}
        whileTap={{ scale: 0.92 }}
        onClick={onUploadClick}
        className="fixed bottom-24 right-8 w-14 h-14 bg-gradient-to-tr from-emerald-500 to-lime-400 text-stone-950 rounded-full flex items-center justify-center shadow-lg shadow-emerald-500/20 border-2 border-emerald-300/20 cursor-pointer z-40 transition-transform duration-300"
      >
        <span className="text-2xl font-semibold">+</span>
      </motion.button>

    </div>
  );
}
