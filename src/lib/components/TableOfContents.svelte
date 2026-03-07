<script lang="ts">
	interface Heading {
		id: string;
		text: string;
		level: string;
	}

	let { headings = [], activeId = '' }: { headings: Heading[]; activeId: string } = $props();
</script>

{#if headings.length > 0}
	<nav class="sticky top-4 rounded-lg border border-cat_primary/30 bg-cat_base/50 p-4 backdrop-blur-sm">
		<h2 class="mb-3 text-sm font-semibold uppercase tracking-wide text-cat_primary">
			On This Page
		</h2>
		<ul class="space-y-2 text-sm">
			{#each headings as heading}
				<li class={heading.level === 'H3' ? 'ml-4' : ''}>
					<a
						href="#{heading.id}"
						class="block transition-colors hover:text-cat_tertiary {activeId === heading.id
							? 'font-semibold text-cat_tertiary'
							: 'text-cat_text/70'}"
					>
						{heading.text}
					</a>
				</li>
			{/each}
		</ul>
	</nav>
{/if}
