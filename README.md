# wyfy.dev

Personal website and blog built with SvelteKit.

## Tech Stack

- **Framework**: SvelteKit
- **Template**: [buriburi-folio](https://github.com/aarsh21/buriburi-folio)
- **Styling**: TailwindCSS v4 with Catppuccin Macchiato theme
- **Content**: MDsveX (Markdown in Svelte)
- **Build System**: Nix Flakes for reproducible builds
- **IDE**: WebStorm (included in dev environment)

## Development

### Quick Start

```bash
# Enter Nix dev environment
nix develop

# Install dependencies
npm install

# Start dev server
npm run dev

# Open in WebStorm (optional)
webstorm .
```

### Creating Blog Posts

```bash
nix run .#new-post -- "Your Post Title"
```

This creates a new markdown file in `src/posts/` with the proper frontmatter format.

### Building for Production

```bash
# With npm
npm run build

# With Nix
nix build
```

## Configuration

Edit `src/lib/profileDetails.ts` to customize:
- Personal information (name, location, profession)
- Bio
- Work experience
- Projects showcase
- Social links

## Project Structure

```
src/
├── lib/
│   ├── components/     # Svelte components
│   ├── profileDetails.ts  # Your personal config
│   └── images/         # Static images
├── posts/              # Blog posts (markdown)
└── routes/             # SvelteKit routes
```

## Customization

- **Colors**: Edit `tailwind.config.js` (currently using Catppuccin Macchiato)
- **Code highlighting**: Modify theme in `svelte.config.js`
- **Profile image**: Replace `src/lib/images/profile.webp`

## Deployment

The site is pre-rendered as static HTML and can be deployed to:
- Vercel
- Netlify
- Cloudflare Pages
- GitHub Pages
- Any static hosting

Build output is in `.svelte-kit/output/`

## License

This project uses the [buriburi-folio](https://github.com/aarsh21/buriburi-folio) template, distributed under the MIT License.
