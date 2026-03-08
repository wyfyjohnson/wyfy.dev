<script lang="ts">
    import { formatDate } from '$lib/utils';
    import { Badge } from '$lib/components/ui/badge';
    import TableOfContents from '$lib/components/TableOfContents.svelte';
    import { ChevronLeft, ChevronRight } from 'lucide-svelte';

    let { data } = $props();
</script>

<svelte:head>
    <title>{data.meta.title}</title>
    <meta property="og:type" content="article" />
    <meta property="og:title" content={data.meta.title} />
</svelte:head>

<!-- ToC bar -->
<TableOfContents />

<!-- Hero Card -->
<div class="mb-6 rounded-lg border border-dashed border-cat_tertiary/50 bg-cat_base p-6 md:p-8">
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

<!-- Previous / Next Navigation -->
{#if data.prevPost || data.nextPost}
    <div class="mb-8 grid grid-cols-2 gap-4">
        {#if data.prevPost}
            <a
                    href="/{data.prevPost.slug}"
                    class="group flex items-center gap-3 rounded-lg border border-cat_primary/30 px-4 py-3 transition-colors hover:border-cat_quaternary"
            >
                <ChevronLeft
                        class="h-5 w-5 shrink-0 text-cat_text/40 transition-colors group-hover:text-cat_quaternary"
                />
                <div class="min-w-0">
                    <p class="text-xs font-mono uppercase tracking-wider text-cat_text/50">Previous</p>
                    <p class="truncate text-sm font-semibold text-cat_text group-hover:text-cat_quaternary transition-colors">
                        {data.prevPost.title}
                    </p>
                </div>
            </a>
        {:else}
            <div></div>
        {/if}

        {#if data.nextPost}
            <a
                    href="/{data.nextPost.slug}"
                    class="group flex items-center justify-end gap-3 rounded-lg border border-cat_primary/30 px-4 py-3 text-right transition-colors hover:border-cat_quaternary"
            >
                <div class="min-w-0">
                    <p class="text-xs font-mono uppercase tracking-wider text-cat_text/50">Next</p>
                    <p class="truncate text-sm font-semibold text-cat_text group-hover:text-cat_quaternary transition-colors">
                        {data.nextPost.title}
                    </p>
                </div>
                <ChevronRight
                        class="h-5 w-5 shrink-0 text-cat_text/40 transition-colors group-hover:text-cat_quaternary"
                />
            </a>
        {:else}
            <div></div>
        {/if}
    </div>
{/if}

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
    :global(.blog-content h1:first-of-type) {
        display: none !important;
    }
</style>