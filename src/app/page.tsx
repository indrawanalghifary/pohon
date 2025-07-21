'use client'

import { useEffect } from 'react'
import { Header } from '@/components/header'
import { AuthForm } from '@/components/auth-form'
import { useAppStore } from '@/stores/app-store'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { CheckCircle, Code, Database, Palette, Shield, Zap } from 'lucide-react'

export default function Home() {
  const { user, theme } = useAppStore()

  useEffect(() => {
    // Apply theme to document
    if (theme === 'dark') {
      document.documentElement.classList.add('dark')
    } else {
      document.documentElement.classList.remove('dark')
    }
  }, [theme])

  const features = [
    {
      icon: <Code className="h-6 w-6" />,
      title: 'Next.js 15',
      description: 'Framework React terbaru dengan App Router dan Server Components'
    },
    {
      icon: <Palette className="h-6 w-6" />,
      title: 'Tailwind CSS',
      description: 'Utility-first CSS framework untuk styling yang cepat'
    },
    {
      icon: <Zap className="h-6 w-6" />,
      title: 'Zustand',
      description: 'State management yang simpel dan powerful'
    },
    {
      icon: <Shield className="h-6 w-6" />,
      title: 'Zod',
      description: 'TypeScript-first schema validation'
    },
    {
      icon: <CheckCircle className="h-6 w-6" />,
      title: 'shadcn/ui',
      description: 'Komponen UI yang beautiful dan accessible'
    },
    {
      icon: <Database className="h-6 w-6" />,
      title: 'Supabase',
      description: 'Backend-as-a-service dengan PostgreSQL'
    }
  ]

  return (
    <div className="min-h-screen bg-background">
      <div className="container mx-auto p-4 space-y-6">
        <Header />
        
        <div className="grid gap-6 md:grid-cols-2">
          <div className="space-y-6">
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <CheckCircle className="h-5 w-5 text-green-500" />
                  Selamat Datang di Pohon!
                </CardTitle>
                <CardDescription>
                  Starter project lengkap dengan teknologi modern untuk membangun aplikasi web yang powerful
                </CardDescription>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  <div>
                    <h3 className="font-semibold mb-2">Status Project:</h3>
                    <div className="flex flex-wrap gap-2">
                      <Badge variant="secondary">Next.js ✓</Badge>
                      <Badge variant="secondary">TypeScript ✓</Badge>
                      <Badge variant="secondary">Tailwind CSS ✓</Badge>
                      <Badge variant="secondary">Zustand ✓</Badge>
                      <Badge variant="secondary">Zod ✓</Badge>
                      <Badge variant="secondary">shadcn/ui ✓</Badge>
                      <Badge variant="secondary">Lucide React ✓</Badge>
                      <Badge variant="secondary">Supabase ✓</Badge>
                    </div>
                  </div>
                  
                  {user && (
                    <div className="p-4 bg-green-50 dark:bg-green-900/20 rounded-lg">
                      <p className="text-green-700 dark:text-green-300">
                        🎉 Halo, <strong>{user.name}</strong>! Anda berhasil login.
                      </p>
                    </div>
                  )}
                  
                  <div className="space-y-2">
                    <h4 className="font-medium">Quick Start:</h4>
                    <ul className="text-sm text-muted-foreground space-y-1">
                      <li>• Setup Supabase dengan mengisi file .env.local</li>
                      <li>• Customize komponen sesuai kebutuhan</li>
                      <li>• Mulai develop fitur aplikasi Anda</li>
                    </ul>
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>Teknologi yang Digunakan</CardTitle>
                <CardDescription>
                  Stack teknologi modern untuk pengembangan yang efisien
                </CardDescription>
              </CardHeader>
              <CardContent>
                <div className="grid gap-4 sm:grid-cols-2">
                  {features.map((feature, index) => (
                    <div key={index} className="flex items-start space-x-3">
                      <div className="flex-shrink-0 text-primary">
                        {feature.icon}
                      </div>
                      <div>
                        <h3 className="font-medium">{feature.title}</h3>
                        <p className="text-sm text-muted-foreground">
                          {feature.description}
                        </p>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          </div>

          <div className="space-y-6">
            {!user && (
              <div>
                <AuthForm />
              </div>
            )}
            
            <Card>
              <CardHeader>
                <CardTitle>Dokumentasi</CardTitle>
                <CardDescription>
                  Link berguna untuk dokumentasi masing-masing teknologi
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-3">
                <Button variant="outline" className="w-full justify-start" asChild>
                  <a href="https://nextjs.org/docs" target="_blank" rel="noopener noreferrer">
                    Next.js Documentation
                  </a>
                </Button>
                <Button variant="outline" className="w-full justify-start" asChild>
                  <a href="https://tailwindcss.com/docs" target="_blank" rel="noopener noreferrer">
                    Tailwind CSS Docs
                  </a>
                </Button>
                <Button variant="outline" className="w-full justify-start" asChild>
                  <a href="https://docs.pmnd.rs/zustand/getting-started/introduction" target="_blank" rel="noopener noreferrer">
                    Zustand Documentation
                  </a>
                </Button>
                <Button variant="outline" className="w-full justify-start" asChild>
                  <a href="https://zod.dev/" target="_blank" rel="noopener noreferrer">
                    Zod Documentation
                  </a>
                </Button>
                <Button variant="outline" className="w-full justify-start" asChild>
                  <a href="https://ui.shadcn.com/" target="_blank" rel="noopener noreferrer">
                    shadcn/ui Components
                  </a>
                </Button>
                <Button variant="outline" className="w-full justify-start" asChild>
                  <a href="https://supabase.com/docs" target="_blank" rel="noopener noreferrer">
                    Supabase Documentation
                  </a>
                </Button>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </div>
  )
}
