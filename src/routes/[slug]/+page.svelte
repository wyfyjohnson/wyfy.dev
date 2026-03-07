<script lang="ts">
	import { onMount } from 'svelte';
	import { formatDate } from '$lib/utils';
	import { Badge } from '$lib/components/ui/badge';
	import TableOfContents from '$lib/components/TableOfContents.svelte';

	let { data } = $props();

	let headings = $state([]);
	let activeId = $state('');

	onMount(() => {
		// Extract headings from the article
		const els = document.querySelectorAll('article h2, article h3');
		headings = Array.from(els).map((el) => ({
			id: el.id,
			text: el.textContent,
			level: el.tagName // 'H2' or 'H3'
		}));

		// Set up IntersectionObserver to track active heading
		const observer = new IntersectionObserver(
			(entries) => {
				entries.forEach((entry) => {
					if (entry.isIntersecting) activeId = entry.target.id;
				});
			},
			{ rootMargin: '0px 0px -80% 0px' }
		);

		document.querySelectorAll('article h2, article h3').forEach((el) => observer.observe(el));

		return () => observer.disconnect();
	});
</script>

<svelte:head>
	<title>{data.meta.title}</title>
	<meta property="og:type" content="article" />
	<meta property="og:title" content={data.meta.title} />
</svelte:head>

<div class="grid grid-cols-1 gap-8 lg:grid-cols-[1fr_250px]">
	<article
		class="prose lg:prose-lg text-cat_text prose-headings:mb-1 prose-headings:mt-1 prose-headings:text-cat_primary prose-p:mb-0 prose-a:text-cat_tertiary prose-blockquote:text-cat_text prose-strong:text-cat_quaternary prose-code:mb-2 prose-code:mt-2 prose-code:font-mono prose-li:marker:text-cat_secondary lg:prose-headings:mb-4 lg:prose-headings:mt-4"
	>
		<hgroup class="mb-0 text-cat_text">
			<h1>{data.meta.title}</h1>
			<p class="text-sm">
				Published at <span class="font-bold text-cat_tertiary">
					{formatDate(data.meta.date)}
				</span>
			</p>
		</hgroup>

		<div class="tags mt-2">
			{#each data.meta.categories as category}
				<Badge class=" mr-2 text-cat_quaternary outline-cat_primary">
					<span class="surface-4">&num;{category}</span>
				</Badge>
			{/each}
		</div>

		<div class="leading-7 lg:leading-normal">
			<data.content />
		</div>
	</article>

	<aside class="hidden lg:block">
		<TableOfContents {headings} {activeId} />
	</aside>
</div>
