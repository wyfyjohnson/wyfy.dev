<script lang="ts">
	import { Sun, Moon } from 'lucide-svelte';
	import { onMount } from 'svelte';

	let isDark = $state(true);

	onMount(() => {
		// Check localStorage or system preference
		const stored = localStorage.getItem('theme');
		const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;

		isDark = stored ? stored === 'dark' : prefersDark;
		updateTheme();
	});

	function updateTheme() {
		if (isDark) {
			document.documentElement.classList.add('dark');
			localStorage.setItem('theme', 'dark');
		} else {
			document.documentElement.classList.remove('dark');
			localStorage.setItem('theme', 'light');
		}
	}

	function toggleTheme() {
		isDark = !isDark;
		updateTheme();
	}
</script>

<button
	onclick={toggleTheme}
	class="fixed top-4 right-4 z-50 rounded-full bg-cat_base border border-cat_primary p-3 transition-all hover:bg-cat_primary/20 hover:border-cat_quaternary"
	aria-label="Toggle theme"
>
	{#if isDark}
		<Sun class="h-5 w-5 text-cat_tertiary" />
	{:else}
		<Moon class="h-5 w-5 text-cat_tertiary" />
	{/if}
</button>
