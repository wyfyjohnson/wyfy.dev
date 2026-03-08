<script lang="ts">
    import { formatDate } from '$lib/utils';
    import { Badge } from '$lib/components/ui/badge';
    import TableOfContents from '$lib/components/TableOfContents.svelte';

    let { data } = $props();
</script>

<svelte:head>
    <title>{data.meta.title}</title>
    <meta property="og:type" content="article" />
    <meta property="og:title" content={data.meta.title} />
</svelte:head>

<!-- Single ToC instance — it self-manages mobile vs desktop visibility -->
<TableOfContents />

<!-- Hero Card -->
<div class="mb-8 rounded-lg border border-cat_tertiary/50 bg-cat_base p-6 md:p-8">
    <div class="mb-4 flex flex-wrap items-center gap-3 text-xs font-mono uppercase tracking-wider">
		<span class="rounded border border-cat_secondary/40 px-2.5 py-1 text-cat_secondary">
			{formatDate(data.meta.date)}
		</span>
    </div>

    <h1
            class="font-mono text-2xl font-bold uppercase leading-tight tracking-wide text-cat_text md:text-3xl lg:text-4xl"
    >
        {data.meta.title}
    </h1>

    <div class="mt-4 flex flex-wrap gap-2">
        {#each data.meta.categories as category}
            <Badge class="font-mono text-xs uppercase text-cat_quaternary outline-cat_primary">
                <span>&num;{category}</span>
            </Badge>
        {/each}
    </div>
</div>

<!-- Article content -->
<article
        class="blog-content prose text-cat_text lg:prose-lg
		prose-headings:mb-1 prose-headings:mt-1 prose-headings:text-cat_primary
		prose-p:mb-0
		prose-a:text-cat_tertiary
		prose-blockquote:text-cat_text
		prose-strong:text-cat_quaternary
		prose-code:mb-2 prose-code:mt-2 prose-code:font-mono
		prose-li:marker:text-cat_secondary
		lg:prose-headings:mb-4 lg:prose-headings:mt-4"
>
    <div class="leading-7 lg:leading-normal">
        <data.content />
    </div>
</article>

<style>
    /* Hide the first H1 from markdown — title is already in the hero card */
    :global(.blog-content h1:first-of-type) {
        display: none !important;
    }
</style>