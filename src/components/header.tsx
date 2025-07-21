'use client'

import { Moon, Sun, User, LogOut, Settings } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Card } from '@/components/ui/card'
import { useAppStore } from '@/stores/app-store'

export function Header() {
  const { user, theme, toggleTheme, logout } = useAppStore()

  return (
    <Card className="w-full p-4">
      <div className="flex items-center justify-between">
        <div className="flex items-center space-x-4">
          <h1 className="text-2xl font-bold">Pohon</h1>
          <p className="text-muted-foreground">
            Starter project dengan Next.js, React, Tailwind CSS, Zustand, Zod, Lucide React, shadcn/ui, dan Supabase
          </p>
        </div>
        
        <div className="flex items-center space-x-2">
          <Button
            variant="outline"
            size="icon"
            onClick={toggleTheme}
            className="h-9 w-9"
          >
            {theme === 'light' ? (
              <Moon className="h-4 w-4" />
            ) : (
              <Sun className="h-4 w-4" />
            )}
          </Button>
          
          {user ? (
            <div className="flex items-center space-x-2">
              <div className="flex items-center space-x-2 px-3 py-2 rounded-md bg-muted">
                <User className="h-4 w-4" />
                <span className="text-sm font-medium">{user.name}</span>
              </div>
              
              <Button variant="outline" size="icon" className="h-9 w-9">
                <Settings className="h-4 w-4" />
              </Button>
              
              <Button 
                variant="outline" 
                size="icon" 
                onClick={logout}
                className="h-9 w-9"
              >
                <LogOut className="h-4 w-4" />
              </Button>
            </div>
          ) : (
            <div className="flex items-center space-x-2 px-3 py-2 rounded-md bg-muted">
              <User className="h-4 w-4" />
              <span className="text-sm">Belum login</span>
            </div>
          )}
        </div>
      </div>
    </Card>
  )
}
