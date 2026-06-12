import { useState, useEffect } from 'react';
import { AnimatePresence, motion } from 'motion/react';
import { INITIAL_IMAGES } from './data';
import { ImageItem, ScreenType } from './types';
import SplashView from './components/SplashView';
import HomeView from './components/HomeView';
import UploadView from './components/UploadView';
import ImageDetailsView from './components/ImageDetailsView';
import MyUploadsView from './components/MyUploadsView';
import ProfileView from './components/ProfileView';
import SimulatorShell from './components/SimulatorShell';

export default function App() {
  const [activeScreen, setActiveScreen] = useState<ScreenType>('splash');
  const [images, setImages] = useState<ImageItem[]>([]);
  const [selectedImage, setSelectedImage] = useState<ImageItem | null>(null);
  const [isLightTheme, setIsLightTheme] = useState(false);
  const [toastMessage, setToastMessage] = useState<string | null>(null);

  // Load from local storage on mount
  useEffect(() => {
    const stored = localStorage.getItem('welcome_goats_vault');
    if (stored) {
      try {
        setImages(JSON.parse(stored));
      } catch (e) {
        setImages(INITIAL_IMAGES);
      }
    } else {
      setImages(INITIAL_IMAGES);
      localStorage.setItem('welcome_goats_vault', JSON.stringify(INITIAL_IMAGES));
    }
  }, []);

  const saveToStorage = (updatedList: ImageItem[]) => {
    setImages(updatedList);
    localStorage.setItem('welcome_goats_vault', JSON.stringify(updatedList));
  };

  const showToast = (message: string) => {
    setToastMessage(message);
    setTimeout(() => setToastMessage(null), 3000);
  };

  // 1. Add custom species record
  const handleUploadComplete = (newItem: ImageItem) => {
    const updated = [newItem, ...images];
    saveToStorage(updated);
    showToast(`📸 Succeeded: Published "${newItem.title}" into database!`);
    setActiveScreen('home');
  };

  // 2. Favorite toggle handler
  const handleFavoriteToggle = (id: string) => {
    const updated = images.map((img) => {
      if (img.id === id) {
        const nextState = !img.isFavorite;
        showToast(nextState ? `❤️ Marked "${img.title}" as favorite!` : `💔 Removed "${img.title}" from favorites`);
        return { ...img, isFavorite: nextState };
      }
      return img;
    });
    saveToStorage(updated);
  };

  // 3. Edit details handler
  const handleEditImage = (updatedItem: ImageItem) => {
    const updated = images.map((img) => (img.id === updatedItem.id ? updatedItem : img));
    saveToStorage(updated);
    showToast(`📝 Saved changes for "${updatedItem.title}"`);
    if (selectedImage?.id === updatedItem.id) {
      setSelectedImage(updatedItem);
    }
  };

  // 4. Delete handler
  const handleDeleteImage = (id: string) => {
    const updated = images.filter((img) => img.id !== id);
    saveToStorage(updated);
    showToast('🗑️ Wildlife capture removed completely.');
    if (selectedImage?.id === id) {
      setSelectedImage(null);
      setActiveScreen('home');
    }
  };

  // 5. Seed extra interactive elements
  const handleAddMockData = () => {
    const extraItems: ImageItem[] = [
      {
        id: `seed_${Date.now()}_1`,
        title: 'Snowy Aurora Fox',
        description: 'An elegant arctic fox staring intensely into the winter twilight beneath a swirling green geyser of northern lights.',
        category: 'Animals',
        imageUrl: 'https://images.unsplash.com/photo-1516467508483-a7212febe31a?q=80&w=600&auto=format&fit=crop',
        uploadDate: '2026-06-09',
        uploaderName: 'Denver Brooks',
        downloadsCount: 4210,
        likesCount: 2901,
        isFavorite: true,
        tags: ['Fox', 'Snow', 'Aurora', 'Arctic'],
        location: 'Lofoten, Norway'
      },
      {
        id: `seed_${Date.now()}_2`,
        title: 'Boreal Pygmy Owl',
        description: 'A tiny yet highly alert pygmy owl nested inside an old birch trunk knot, surrounded by spring forest lichen.',
        category: 'Birds',
        imageUrl: 'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?q=80&w=600&auto=format&fit=crop',
        uploadDate: '2026-06-08',
        uploaderName: 'Amelia Rose',
        downloadsCount: 1530,
        likesCount: 940,
        isFavorite: false,
        userId: 'user_default',
        tags: ['Owl', 'Boreal', 'Nesting', 'Plumage'],
        location: 'Sarek National Park, Sweden'
      },
      {
        id: `seed_${Date.now()}_3`,
        title: 'Svartifoss Cascade',
        description: 'Prismatic misty waterfall flowing down dark hexagonal rocky basalt columns in southern Iceland during early dawn.',
        category: 'Nature',
        imageUrl: 'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?q=80&w=600&auto=format&fit=crop',
        uploadDate: '2026-06-07',
        uploaderName: 'Marcus Cole',
        downloadsCount: 3120,
        likesCount: 1980,
        isFavorite: true,
        tags: ['Basalt', 'Waterfall', 'Iceland', 'Gorge'],
        location: 'Skaftafell, Iceland'
      }
    ];

    const updated = [...extraItems, ...images];
    saveToStorage(updated);
    showToast('🌟 Seeded 3 majestic custom animal captures successfully!');
  };

  // 6. Reset array presets back to default
  const handleResetData = () => {
    saveToStorage(INITIAL_IMAGES);
    setSelectedImage(null);
    setActiveScreen('home');
    showToast('♻️ Reset database list to initial presets.');
  };

  // Router dispatcher
  const renderInteractiveScreen = () => {
    switch (activeScreen) {
      case 'splash':
        return <SplashView onComplete={() => setActiveScreen('home')} />;
      case 'home':
        return (
          <HomeView
            images={images}
            onImageSelect={(img) => {
              setSelectedImage(img);
              setActiveScreen('details');
            }}
            onUploadClick={() => setActiveScreen('upload')}
            onProfileClick={() => setActiveScreen('profile')}
          />
        );
      case 'upload':
        return (
          <UploadView
            onUploadComplete={handleUploadComplete}
            onCancel={() => setActiveScreen('home')}
          />
        );
      case 'details':
        if (!selectedImage) {
          setActiveScreen('home');
          return null;
        }
        return (
          <ImageDetailsView
            image={selectedImage}
            onBack={() => setActiveScreen('home')}
            onFavoriteToggle={handleFavoriteToggle}
          />
        );
      case 'my_uploads':
        return (
          <MyUploadsView
            images={images}
            onImageSelect={(img) => {
              setSelectedImage(img);
              setActiveScreen('details');
            }}
            onEditImage={handleEditImage}
            onDeleteImage={handleDeleteImage}
          />
        );
      case 'profile':
        return (
          <ProfileView
            images={images}
            isLightTheme={isLightTheme}
            onThemeToggle={() => setIsLightTheme(!isLightTheme)}
            onLogout={() => {
              setActiveScreen('splash');
              showToast('👋 Session reset. Welcome!');
            }}
          />
        );
      default:
        return <SplashView onComplete={() => setActiveScreen('home')} />;
    }
  };

  return (
    <div className="relative w-full min-h-screen overflow-hidden">
      
      {/* Immersive interactive desktop frame shell container */}
      <SimulatorShell
        activeScreen={activeScreen}
        onScreenChange={(screen) => {
          setActiveScreen(screen);
          if (screen !== 'details') setSelectedImage(null);
        }}
        isLightTheme={isLightTheme}
        onThemeToggle={() => setIsLightTheme(!isLightTheme)}
        onAddMockData={handleAddMockData}
        onResetData={handleResetData}
      >
        {renderInteractiveScreen()}
      </SimulatorShell>

      {/* 2. Floating toast system notifications popups */}
      <AnimatePresence>
        {toastMessage && (
          <motion.div
            initial={{ opacity: 0, y: -40, scale: 0.95 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: -45, scale: 0.95 }}
            className="fixed top-24 left-1/2 -translate-x-1/2 z-55 w-full max-w-sm px-4"
          >
            <div className="p-3.5 bg-stone-900 border-2 border-emerald-500/40 rounded-2xl shadow-xl shadow-emerald-500/10 flex items-center gap-3 text-xs text-stone-200 font-mono text-left">
              <span className="text-base">🔔</span>
              <span>{toastMessage}</span>
            </div>
          </motion.div>
        )}
      </AnimatePresence>

    </div>
  );
}
