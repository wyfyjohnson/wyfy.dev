<script lang="ts">
	import { Sun, Moon, Palette } from 'lucide-svelte';
	import { onMount } from 'svelte';

	let isDark = $state(true);
	let currentTheme = $state('macchiato');
	let showDropdown = $state(false);

	const themes = [
		{ id: 'catppuccin', name: 'Catppuccin' },
		{ id: 'gruvbox', name: 'Gruvbox' },
		{ id: 'nord', name: 'Nord' },
		{ id: 'solarized', name: 'Solarized' },
		{ id: 'tokyo-night', name: 'Tokyo Night' }
	];

	onMount(() => {
		// Check localStorage for saved preferences
		const storedMode = localStorage.getItem('mode');
		const storedTheme = localStorage.getItem('theme');

		// Default to dark mode with catppuccin theme
		isDark = storedMode ? storedMode === 'dark' : true;
		currentTheme = storedTheme || 'catppuccin';

		updateTheme();
	});

	function updateTheme() {
		// Update mode (light/dark)
		if (isDark) {
			document.documentElement.classList.add('dark');
			localStorage.setItem('mode', 'dark');
		} else {
			document.documentElement.classList.remove('dark');
			localStorage.setItem('mode', 'light');
		}

		// Update theme
		document.documentElement.setAttribute('data-theme', currentTheme);
		localStorage.setItem('theme', currentTheme);
	}

	function toggleMode() {
		isDark = !isDark;
		updateTheme();
	}

	function selectTheme(themeId: string) {
		currentTheme = themeId;
		showDropdown = false;
		updateTheme();
	}

	function toggleDropdown() {
		showDropdown = !showDropdown;
	}

	// Close dropdown when clicking outside
	function handleClickOutside(event: MouseEvent) {
		const target = event.target as HTMLElement;
		if (!target.closest('.theme-dropdown')) {
			showDropdown = false;
		}
	}

	onMount(() => {
		document.addEventListener('click', handleClickOutside);
		return () => document.removeEventListener('click', handleClickOutside);
	});
</script>

<div class="fixed top-4 right-4 z-50 flex gap-2">
	<!-- Light/Dark Mode Toggle -->
	<button
		onclick={toggleMode}
		class="rounded-full bg-cat_base border border-cat_primary p-3 transition-all hover:bg-cat_primary/20 hover:border-cat_quaternary"
		aria-label="Toggle light/dark mode"
	>
		{#if isDark}
			<Sun class="h-5 w-5 text-cat_tertiary" />
		{:else}
			<Moon class="h-5 w-5 text-cat_tertiary" />
		{/if}
	</button>

	<!-- Theme Dropdown -->
	<div class="theme-dropdown relative">
		<button
			onclick={toggleDropdown}
			class="rounded-full bg-cat_base border border-cat_primary p-3 transition-all hover:bg-cat_primary/20 hover:border-cat_quaternary"
			aria-label="Select theme"
		>
			<Palette class="h-5 w-5 text-cat_secondary" />
		</button>

		{#if showDropdown}
			<div
				class="absolute right-0 mt-2 w-48 rounded-lg bg-cat_base border border-cat_primary shadow-lg overflow-hidden"
			>
				<div class="py-1">
					{#each themes as theme}
						<button
							onclick={() => selectTheme(theme.id)}
							class="w-full px-4 py-3 text-left transition-colors hover:bg-cat_primary/20 flex items-center justify-between {currentTheme ===
							theme.id
								? 'bg-cat_primary/30 text-cat_primary'
								: 'text-cat_text'}"
						>
							<span class="font-medium">{theme.name}</span>
							{#if currentTheme === theme.id}
								<span class="text-cat_primary">✓</span>
							{/if}
						</button>
					{/each}
				</div>
			</div>
		{/if}
	</div>
</div>

<style>
	/* Smooth transitions for theme changes */
	:global(html) {
		transition: background-color 0.3s ease, color 0.3s ease;
	}
</style>
