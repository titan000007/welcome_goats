import React, { useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { Edit2, Trash2, Download, ExternalLink, RefreshCw, X, AlertCircle } from 'lucide-react';
import { ImageItem, CategoryType } from '../types';

interface MyUploadsViewProps {
  images: ImageItem[];
  onImageSelect: (image: ImageItem) => void;
  onEditImage: (updatedImage: ImageItem) => void;
  onDeleteImage: (id: string) => void;
  activeUserId?: string;
}

export default function MyUploadsView({
  images,
  onImageSelect,
  onEditImage,
  onDeleteImage,
  activeUserId = 'user_default',
}: MyUploadsViewProps) {
  const myUploads = images.filter((img) => img.userId === activeUserId);

  const [editingItem, setEditingItem] = useState<ImageItem | null>(null);
  const [editTitle, setEditTitle] = useState('');
  const [editDescription, setEditDescription] = useState('');
  const [editCategory, setEditCategory] = useState<Exclude<CategoryType, 'All'>>('Animals');
  const [editLocation, setEditLocation] = useState('');
  const [showDeleteConfirmId, setShowDeleteConfirmId] = useState<string | null>(null);

  // Trigger Edit details Modal load
  const openEditModal = (item: ImageItem) => {
    setEditingItem(item);
    setEditTitle(item.title);
    setEditDescription(item.description);
    setEditCategory(item.category as Exclude<CategoryType, 'All'>);
    setEditLocation(item.location || 'Global');
  };

  const handleSaveEdit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!editingItem) return;

    const updated: ImageItem = {
      ...editingItem,
      title: editTitle.trim(),
      description: editDescription.trim(),
      category: editCategory,
      location: editLocation.trim(),
    };

    onEditImage(updated);
    setEditingItem(null);
  };

  const handleConfirmDelete = (id: string) => {
    onDeleteImage(id);
    setShowDeleteConfirmId(null);
  };

  const startFakeDownload = (img: ImageItem) => {
    const link = document.createElement('a');
    link.href = img.imageUrl;
    link.target = '_blank';
    link.download = `${img.title.replace(/\s+/g, '_')}_my_upload.jpg`;
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  return (
    <div className="w-full h-full flex flex-col overflow-y-auto pb-24 scrollbar-none">
      
      {/* 1. App header */}
      <div className="px-5 pt-6 pb-4 bg-stone-900/40 border-b border-stone-900">
        <span className="text-[10px] font-mono tracking-widest text-emerald-400 uppercase">My Vault</span>
        <h1 className="text-xl font-bold text-white tracking-tight leading-snug">My Uploaded Species</h1>
      </div>

      {myUploads.length === 0 ? (
        <div className="flex-1 p-8 flex flex-col items-center justify-center text-center mt-12 space-y-4">
          <div className="w-16 h-16 rounded-full bg-stone-900 flex items-center justify-center text-stone-500 text-2xl border border-stone-850">
            🌱
          </div>
          <div>
            <h2 className="text-sm font-bold text-stone-300">Sanctuary Vault is Empty</h2>
            <p className="text-xs text-stone-500 max-w-[220px] mt-1 mx-auto leading-relaxed">
              You haven't uploaded any personal nature photos yet. Click on the <strong>+</strong> button below to capture your first species records.
            </p>
          </div>
        </div>
      ) : (
        <div className="p-5 space-y-4">
          
          <div className="p-3 bg-emerald-950/20 border border-emerald-500/15 rounded-2xl flex items-center justify-between">
            <div className="text-[11px] text-stone-400 font-mono">
              <span className="text-emerald-400 font-bold">{myUploads.length}</span> / 50 Active Submissions
            </div>
            <span className="text-[9px] font-mono bg-stone-900 text-lime-400 px-2 py-0.5 rounded border border-lime-500/10">
              Synced to Local Storage
            </span>
          </div>

          <div className="space-y-3.5">
            {myUploads.map((img) => (
              <div
                key={img.id}
                className="bg-stone-900/40 border border-stone-850 rounded-2xl p-3 flex gap-3 relative group"
              >
                
                {/* Image */}
                <div 
                  onClick={() => onImageSelect(img)}
                  className="w-20 h-20 rounded-xl overflow-hidden shrink-0 relative cursor-pointer group-hover:opacity-90"
                >
                  <img
                    src={img.imageUrl}
                    alt={img.title}
                    className="w-full h-full object-cover"
                    referrerPolicy="no-referrer"
                  />
                  <div className="absolute inset-0 bg-stone-950/20 hover:bg-transparent" />
                </div>

                {/* Info and Actions */}
                <div className="flex-1 min-w-0 flex flex-col justify-between pt-0.5">
                  <div>
                    <div className="flex items-center justify-between">
                      <span className="text-[8px] font-mono bg-emerald-500/10 text-emerald-400 px-1.5 py-0.5 rounded font-bold uppercase tracking-wider">
                        {img.category}
                      </span>
                      <span className="text-[9px] text-stone-500 font-mono">{img.uploadDate}</span>
                    </div>
                    <h3 
                      onClick={() => onImageSelect(img)}
                      className="text-xs font-bold text-stone-100 truncate mt-1 pointer-events-auto hover:text-emerald-300 transition-colors cursor-pointer"
                    >
                      {img.title}
                    </h3>
                    <p className="text-[10px] text-stone-400 font-mono truncate">📍 {img.location || 'Sanctuary'}</p>
                  </div>

                  {/* Button row */}
                  <div className="flex items-center gap-1.5 pt-2">
                    
                    <button
                      onClick={() => openEditModal(img)}
                      className="flex items-center gap-1 px-2.5 py-1.5 rounded bg-stone-900 text-[10px] text-stone-300 font-mono border border-stone-850 hover:bg-stone-800"
                    >
                      <Edit2 className="w-3 h-3 text-emerald-400" />
                      <span>Edit</span>
                    </button>

                    <button
                      onClick={() => startFakeDownload(img)}
                      className="flex items-center gap-1 px-2.5 py-1.5 rounded bg-stone-950 text-[10px] text-stone-300 font-mono border border-stone-850 hover:bg-stone-800"
                    >
                      <Download className="w-3 h-3 text-sky-400" />
                      <span>Fetch</span>
                    </button>

                    <button
                      onClick={() => setShowDeleteConfirmId(img.id)}
                      className="flex items-center gap-1 px-2.5 py-1.5 rounded bg-stone-950/40 text-[10px] text-red-400 font-mono border border-red-500/10 hover:bg-red-950/20"
                    >
                      <Trash2 className="w-3 h-3" />
                      <span>Delete</span>
                    </button>

                  </div>
                </div>

                {/* Inline Delete Confirm overlay */}
                <AnimatePresence>
                  {showDeleteConfirmId === img.id && (
                    <motion.div
                      initial={{ opacity: 0 }}
                      animate={{ opacity: 1 }}
                      exit={{ opacity: 0 }}
                      className="absolute inset-0 bg-stone-950/95 rounded-2xl flex flex-col items-center justify-center p-3 text-center z-10 space-y-2 border border-red-500/20"
                    >
                      <div className="flex items-center gap-1 text-red-400 text-xs font-bold font-mono">
                        <AlertCircle className="w-3.5 h-3.5" />
                        <span>CONFIRM IRREVERSIBLE DELETION?</span>
                      </div>
                      <div className="flex gap-2">
                        <button
                          onClick={() => handleConfirmDelete(img.id)}
                          className="px-3 py-1 bg-red-600 text-white font-bold font-mono text-[9px] rounded uppercase cursor-pointer"
                        >
                          Yes, Delete
                        </button>
                        <button
                          onClick={() => setShowDeleteConfirmId(null)}
                          className="px-3 py-1 bg-stone-900 text-stone-300 font-mono text-[9px] rounded uppercase cursor-pointer"
                        >
                          Cancel
                        </button>
                      </div>
                    </motion.div>
                  )}
                </AnimatePresence>

              </div>
            ))}
          </div>
        </div>
      )}

      {/* 2. Interactive Editing Modal popup */}
      <AnimatePresence>
        {editingItem && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="absolute inset-0 bg-stone-950/80 backdrop-blur-sm z-50 flex items-center justify-center p-5"
          >
            <motion.div
              initial={{ scale: 0.95 }}
              animate={{ scale: 1 }}
              exit={{ scale: 0.95 }}
              className="w-full bg-stone-900 border border-stone-800 p-5 rounded-3xl space-y-4"
            >
              <div className="flex items-center justify-between border-b border-stone-850 pb-2.5">
                <h3 className="text-xs font-mono uppercase tracking-widest text-emerald-400 font-bold">
                  Edit Species Credentials
                </h3>
                <button
                  onClick={() => setEditingItem(null)}
                  className="w-6 h-6 rounded-full bg-stone-950 flex items-center justify-center text-stone-400 cursor-pointer"
                >
                  <X className="w-3 h-3" />
                </button>
              </div>

              <form onSubmit={handleSaveEdit} className="space-y-3">
                <div className="space-y-1">
                  <label className="text-[9px] font-mono uppercase text-stone-500 font-bold">Category</label>
                  <div className="grid grid-cols-3 gap-2">
                    {(['Animals', 'Birds', 'Nature'] as const).map((cat) => (
                      <button
                        key={cat}
                        type="button"
                        onClick={() => setEditCategory(cat)}
                        className={`py-1.5 rounded-full text-[10px] font-mono transition-all ${
                          editCategory === cat
                            ? 'bg-gradient-to-r from-emerald-500 via-emerald-600 to-lime-400 text-stone-950 font-bold'
                            : 'bg-stone-950 text-stone-400'
                        }`}
                      >
                        {cat}
                      </button>
                    ))}
                  </div>
                </div>

                <div className="space-y-1 text-left">
                  <label className="text-[9px] font-mono uppercase text-stone-500 font-bold">Species Name</label>
                  <input
                    type="text"
                    value={editTitle}
                    onChange={(e) => setEditTitle(e.target.value)}
                    className="w-full bg-stone-950 px-3.5 py-2.5 border border-stone-800 rounded-xl text-xs text-stone-200 placeholder-stone-600 focus:outline-none"
                    required
                  />
                </div>

                <div className="space-y-1 text-left">
                  <label className="text-[9px] font-mono uppercase text-stone-500 font-bold">Location Coordinates</label>
                  <input
                    type="text"
                    value={editLocation}
                    onChange={(e) => setEditLocation(e.target.value)}
                    className="w-full bg-stone-950 px-3.5 py-2.5 border border-stone-800 rounded-xl text-xs text-stone-200 placeholder-stone-600 focus:outline-none"
                    required
                  />
                </div>

                <div className="space-y-1 text-left">
                  <label className="text-[9px] font-mono uppercase text-stone-500 font-bold">Habitat & Species Bio</label>
                  <textarea
                    value={editDescription}
                    onChange={(e) => setEditDescription(e.target.value)}
                    rows={3}
                    className="w-full bg-stone-950 px-3.5 py-2.5 border border-stone-800 rounded-xl text-xs text-stone-200 focus:outline-none resize-none"
                    required
                  />
                </div>

                <div className="pt-2">
                  <button
                    type="submit"
                    className="w-full py-3 bg-gradient-to-r from-emerald-500 to-lime-400 text-stone-950 text-xs font-bold font-mono tracking-wider items-center justify-center rounded-xl uppercase transition-colors hover:brightness-105 cursor-pointer"
                  >
                    Save Changes
                  </button>
                </div>
              </form>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>

    </div>
  );
}
