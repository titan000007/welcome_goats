import { ImageItem } from './types';

export const INITIAL_IMAGES: ImageItem[] = [
  {
    id: 'img_1',
    title: 'Emerald Valley Goat',
    description: 'A majestic mountain goat grazing peacefully in the rich green clover fields high in the Alpine peaks during early sunrise.',
    category: 'Animals',
    imageUrl: 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?q=80&w=600&auto=format&fit=crop',
    uploadDate: '2026-06-01',
    uploaderName: 'Amelia Rose',
    isFavorite: true,
    downloadsCount: 1420,
    likesCount: 890,
    userId: 'user_default',
    tags: ['Goat', 'Alpine', 'Wildlife', 'Mountain'],
    location: 'Chamonix, France'
  },
  {
    id: 'img_2',
    title: 'Vibrant Eclectus Parrot',
    description: 'A striking tropical green parrot with stunning red and blue feathers, resting on a deep forest liana, echoing the rich wildlife biome.',
    category: 'Birds',
    imageUrl: 'https://images.unsplash.com/photo-1552728089-57bdde30ebd3?q=80&w=600&auto=format&fit=crop',
    uploadDate: '2026-06-03',
    uploaderName: 'Julian H.',
    isFavorite: false,
    downloadsCount: 680,
    likesCount: 520,
    userId: 'user_other',
    tags: ['Parrot', 'Tropical', '羽毛', 'Rainforest'],
    location: 'Queensland, Australia'
  },
  {
    id: 'img_3',
    title: 'Misty Pine Mountains',
    description: 'Breathtaking layers of pine forests and mist surrounding majestic gray rocky peaks, exuding tranquility and pristine air.',
    category: 'Nature',
    imageUrl: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?q=80&w=600&auto=format&fit=crop',
    uploadDate: '2026-05-28',
    uploaderName: 'Denver Brooks',
    isFavorite: true,
    downloadsCount: 2310,
    likesCount: 1750,
    userId: 'user_other',
    tags: ['Mist', 'Forest', 'Mountain', 'Landscape'],
    location: 'Rocky Mountains, USA'
  },
  {
    id: 'img_4',
    title: 'Highland Kid Companion',
    description: 'An adorable fluffy young goat checking out the camera with inquisitive black eyes, standing on top of a weathered mossy rock.',
    category: 'Animals',
    imageUrl: 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?q=80&w=600&auto=format&fit=crop',
    uploadDate: '2026-06-05',
    uploaderName: 'Amelia Rose',
    isFavorite: false,
    downloadsCount: 340,
    likesCount: 245,
    userId: 'user_default',
    tags: ['Goat', 'Baby', 'Cute', 'Meadow'],
    location: 'Inverness, Scotland'
  },
  {
    id: 'img_5',
    title: 'Azure Kingfisher Watcher',
    description: 'A small, incredibly fast-moving azure river kingfisher waiting patiently above crystal clear rapids for its silver fish feast.',
    category: 'Birds',
    imageUrl: 'https://images.unsplash.com/photo-1497250681960-ef046c08a56e?q=80&w=600&auto=format&fit=crop',
    uploadDate: '2026-06-04',
    uploaderName: 'Marcus Cole',
    isFavorite: false,
    downloadsCount: 950,
    likesCount: 810,
    userId: 'user_other',
    tags: ['Kingfisher', 'River', 'Predator', 'Plumage'],
    location: 'Kyoto, Japan'
  },
  {
    id: 'img_6',
    title: 'Forest Stream Glow',
    description: 'Light rays fracturing through ancient oak leaves, illuminating a vibrant emerald pathway flowing over smooth round river bed stones.',
    category: 'Nature',
    imageUrl: 'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?q=80&w=600&auto=format&fit=crop',
    uploadDate: '2026-06-07',
    uploaderName: 'Amelia Rose',
    isFavorite: true,
    downloadsCount: 890,
    likesCount: 720,
    userId: 'user_default',
    tags: ['Water', 'Calm', 'Sunrays', 'Creek'],
    location: 'Black Forest, Germany'
  },
  {
    id: 'img_7',
    title: 'Scarlet Macaw Flight',
    description: 'A close-up view of the majestic scarlet red macaw parrot showing off its incredibly bright primary colored feathers.',
    category: 'Birds',
    imageUrl: 'https://images.unsplash.com/photo-1591824438708-ce405f36ba3d?q=80&w=600&auto=format&fit=crop',
    uploadDate: '2026-06-02',
    uploaderName: 'Sarah Jenkins',
    isFavorite: false,
    downloadsCount: 1890,
    likesCount: 1205,
    userId: 'user_other',
    tags: ['Macaw', 'Exotic', 'Jungles', 'Flight'],
    location: 'Amazon Rainforest, Brazil'
  },
  {
    id: 'img_8',
    title: 'Pygmy Meadow Goat',
    description: 'A charming pygmy goat resting inside a sea of blooming yellow wildflowers beneath a brilliant blue summer sky.',
    category: 'Animals',
    imageUrl: 'https://images.unsplash.com/photo-1533105079780-92b9be482077?q=80&w=600&auto=format&fit=crop',
    uploadDate: '2026-06-08',
    uploaderName: 'Denver Brooks',
    isFavorite: false,
    downloadsCount: 420,
    likesCount: 310,
    userId: 'user_other',
    tags: ['Goat', 'Meadow', 'Summer', 'Flowers'],
    location: 'Appenzell, Switzerland'
  }
];

export const MOCK_UPLOADS_PRESETS = [
  'https://images.unsplash.com/photo-1516467508483-a7212febe31a?q=80&w=600&auto=format&fit=crop', // Beautiful Deer in forest
  'https://images.unsplash.com/photo-1513836279014-a89f7a76ae86?q=80&w=600&auto=format&fit=crop', // Tall majestic trees
  'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?q=80&w=600&auto=format&fit=crop', // Small cat/wildcat
  'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?q=80&w=600&auto=format&fit=crop', // Epic misty river nature
  'https://images.unsplash.com/photo-1475924156734-496f6cac6ec1?q=80&w=600&auto=format&fit=crop', // Sunrise ocean nature
];
