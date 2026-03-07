<script lang="ts">
	import { page } from '$app/stores';
	import { Links } from '$lib/profileDetails';
	import { ExternalLink } from 'lucide-svelte';

	const activeStyles =
		'text-cat_primary underline decoration-cat_primary decoration-2 underline-offset-8';
	const hoverStyles = 'hover:text-cat_primary transition-colors';

	// Filter out email and find source code link
	const socialLinks = Links.filter((link) => link.name !== 'Email');
	const sourceLink = Links.find((link) => link.name === 'Source Code');
</script>

<header class="border-b border-cat_primary/20 pb-4 mb-8">
	<nav class="flex flex-wrap items-center justify-between gap-4">
		<!-- Main Navigation Links -->
		<div class="flex items-center gap-6 text-lg font-semibold">
			<a
				href="/"
				class={$page.route.id === '/(app)' ? `${activeStyles}` : `${hoverStyles} text-cat_text`}
			>
				Home
			</a>
			<a
				href="/blog"
				class={$page.route.id === '/(app)/blog'
					? `${activeStyles}`
					: `${hoverStyles} text-cat_text`}
			>
				Blog
			</a>
			<a href="/#projects" class={`${hoverStyles} text-cat_text`}> Projects </a>
		</div>

		<!-- Social Links -->
		<div class="flex items-center gap-4">
			{#each socialLinks as link}
				<a
					href={link.url}
					target="_blank"
					rel="noopener noreferrer"
					class="flex items-center gap-2 text-sm font-medium text-cat_text hover:text-cat_secondary transition-colors"
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
					class="flex items-center gap-1.5 text-sm font-medium text-cat_text hover:text-cat_tertiary transition-colors border border-cat_primary/30 rounded-full px-3 py-1.5"
				>
					<ExternalLink class="h-4 w-4" />
					<span>Source</span>
				</a>
			{/if}
		</div>
	</nav>
</header>
