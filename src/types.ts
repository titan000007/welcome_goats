export interface ImageItem {
  id: string;
  title: string;
  description: string;
  category: 'Animals' | 'Birds' | 'Nature';
  imageUrl: string;
  uploadDate: string;
  uploaderName: string;
  isFavorite?: boolean;
  downloadsCount: number;
  likesCount: number;
  userId?: string;
  tags?: string[];
  location?: string;
}

export type ScreenType = 'splash' | 'home' | 'upload' | 'details' | 'my_uploads' | 'profile';

export type CategoryType = 'All' | 'Animals' | 'Birds' | 'Nature';

export interface UserProfile {
  name: string;
  title: string;
  avatarUrl: string;
  totalUploads: number;
  totalFavorites: number;
  totalDownloads: number;
}
