<script lang="ts">
    import { page } from '$app/stores';
    import { Links, profilePicture } from '$lib/profileDetails';
    import { ExternalLink } from 'lucide-svelte';

    const socialLinks = Links.filter((link) => link.name !== 'Email' && link.name !== 'Source Code');
    const sourceLink = Links.find((link) => link.name === 'Source Code');

    const navItems = [
        { href: '/', label: 'Home',  matchId: '/(app)' },
        { href: '/blog', label: 'Blog', matchId: '/(app)/blog' },
        { href: '/#projects', label: 'Projects', matchId: null }
    ];

    const activeStyles =
        'text-cat_primary underline decoration-cat_primary decoration-2 underline-offset-8';
    const hoverStyles = 'hover:text-cat_primary transition-colors';
</script>

<header class="border-b border-cat_primary/20 pb-4 mb-8">
    <nav class="flex flex-wrap items-center justify-between gap-4">
        <a href="/" class="flex items-center gap-3 group shrink-0">
            <div
                    class="h-10 w-10 overflow-hidden rounded-full border-2 border-cat_primary transition-colors group-hover:border-cat_quaternary"
            >
                <img src={profilePicture} alt="Home" class="h-full w-full object-cover" />
            </div>
            <span
                    class="font-mono text-lg font-bold text-cat_tertiary tracking-wider group-hover:text-cat_quaternary transition-colors uppercase"
            >
				Wyfy
			</span>
        </a>

        <div class="flex items-center gap-5 text-sm font-semibold uppercase tracking-wider">
            {#each navItems as item}
                {@const isActive = item.matchId && $page.route.id === item.matchId}
                <a
                        href={item.href}
                        class="flex items-center gap-1.5 {isActive
						? activeStyles
						: `${hoverStyles} text-cat_text`}"
                >
                    <span class="text-cat_secondary text-xs font-mono">{item.num}</span>
                    {item.label}
                </a>
            {/each}
        </div>

        <div class="flex items-center gap-3">
            {#each socialLinks as link}
                <a
                        href={link.url}
                        target="_blank"
                        rel="noopener noreferrer"
                        class="text-cat_text hover:text-cat_secondary transition-colors"
                        title={link.name}
                >
                    <svelte:component this={link.icon} class="h-5 w-5" />
                </a>
            {/each}
            {#if sourceLink}
                <a
                        href={sourceLink.url}
                        target="_blank"
                        rel="noopener noreferrer"
                        class="flex items-center gap-1.5 text-xs font-semibold text-cat_text hover:text-cat_tertiary transition-colors border border-cat_primary/30 rounded-full px-3 py-1.5 uppercase tracking-wider"
                >
                    <ExternalLink class="h-3.5 w-3.5" />
                    <span>Source</span>
                </a>
            {/if}
        </div>
    </nav>
</header>