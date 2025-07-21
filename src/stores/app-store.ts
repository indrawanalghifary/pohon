import { create } from 'zustand'
import { devtools, persist } from 'zustand/middleware'

interface User {
  id: string
  email: string
  name: string
}

interface AppState {
  user: User | null
  isLoading: boolean
  theme: 'light' | 'dark'
  
  // Actions
  setUser: (user: User | null) => void
  setLoading: (loading: boolean) => void
  toggleTheme: () => void
  logout: () => void
}

export const useAppStore = create<AppState>()(
  devtools(
    persist(
      (set) => ({
        user: null,
        isLoading: false,
        theme: 'light',
        
        setUser: (user) => set({ user }),
        setLoading: (isLoading) => set({ isLoading }),
        toggleTheme: () => set((state) => ({ 
          theme: state.theme === 'light' ? 'dark' : 'light' 
        })),
        logout: () => set({ user: null }),
      }),
      {
        name: 'app-storage',
        partialize: (state) => ({ 
          user: state.user, 
          theme: state.theme 
        }),
      }
    ),
    { name: 'app-store' }
  )
)
