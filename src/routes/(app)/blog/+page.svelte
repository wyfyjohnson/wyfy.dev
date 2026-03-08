<script lang="ts">
	import { formatDate } from '$lib/utils';
	import { Badge } from '$lib/components/ui/badge';

	let { data } = $props();
</script>

<svelte:head>
	<title>Blog</title>
	<meta property="og:type" content="website" />
	<meta property="og:title" content="Blog" />
</svelte:head>

<div class="mb-8">
	<h1 class="text-4xl font-bold text-cat_text mb-2">Blog</h1>
	<p class="text-cat_text opacity-80">All posts</p>
</div>

<div class="space-y-8">
	{#each data.posts as post}
		<article class="border border-cat_primary/30 rounded-lg p-6 hover:border-cat_tertiary transition-colors">
			<a href="/{post.slug}" class="block">
				<h2 class="text-2xl font-bold text-cat_primary hover:text-cat_tertiary mb-2 transition-colors">
					{post.title}
				</h2>
				<p class="text-sm text-cat_text opacity-60 mb-3">
					{formatDate(post.date)}
				</p>
				<p class="text-cat_text mb-4">
					{post.description}
				</p>
				<div class="flex flex-wrap gap-2">
					{#each post.categories as category}
						<Badge class="text-cat_quaternary outline-cat_primary">
							<span>&num;{category}</span>
						</Badge>
					{/each}
				</div>
			</a>
		</article>
	{/each}
</div>
