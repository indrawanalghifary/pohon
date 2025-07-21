import { z } from 'zod'

export const userSchema = z.object({
  id: z.string().uuid(),
  email: z.string().email('Email tidak valid'),
  name: z.string().min(2, 'Nama minimal 2 karakter'),
  avatar: z.string().url().optional(),
  createdAt: z.string().datetime().optional(),
})

export const loginSchema = z.object({
  email: z.string().email('Email tidak valid'),
  password: z.string().min(6, 'Password minimal 6 karakter'),
})

export const registerSchema = z.object({
  email: z.string().email('Email tidak valid'),
  password: z.string().min(6, 'Password minimal 6 karakter'),
  confirmPassword: z.string(),
  name: z.string().min(2, 'Nama minimal 2 karakter'),
}).refine((data) => data.password === data.confirmPassword, {
  message: "Password tidak cocok",
  path: ["confirmPassword"],
})

export const postSchema = z.object({
  title: z.string().min(1, 'Judul diperlukan').max(100, 'Judul maksimal 100 karakter'),
  content: z.string().min(1, 'Konten diperlukan'),
  published: z.boolean().default(false),
  tags: z.array(z.string()).optional(),
})

export type User = z.infer<typeof userSchema>
export type LoginInput = z.infer<typeof loginSchema>
export type RegisterInput = z.infer<typeof registerSchema>
export type PostInput = z.infer<typeof postSchema>
