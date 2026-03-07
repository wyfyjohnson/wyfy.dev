# Profile Image

Replace `profile.webp` with your own profile picture.

## Requirements:
- Format: WebP, PNG, or JPG
- Recommended size: 400x400px (square)
- Name it: `profile.webp` (or update `profileDetails.ts`)

## How to add your image:

1. **Copy your image here:**
   ```bash
   cp /path/to/your/photo.jpg src/lib/images/profile.webp
   ```

2. **Or convert to WebP for better performance:**
   ```bash
   # Using imagemagick (already in your nix shell)
   convert your-photo.jpg -resize 400x400^ -gravity center -extent 400x400 src/lib/images/profile.webp
   ```

3. **Or use a different format:**
   - Update `src/lib/profileDetails.ts`
   - Change: `import profile from '$lib/images/profile.webp';`
   - To: `import profile from '$lib/images/profile.png';` (or .jpg)

For now, the site uses the default placeholder image from the template.
