<script lang="ts">
    import { onMount, onDestroy } from 'svelte';

    type Heading = { id: string; text: string; level: number };

    let headings: Heading[] = $state([]);
    let activeId = $state('');
    let expanded = $state(false);
    let readProgress = $state(0);
    let observer: IntersectionObserver | null = null;

    onMount(() => {
        const nodes = document.querySelectorAll('article h2, article h3');
        headings = Array.from(nodes).map((el) => ({
            id: el.id,
            text: el.textContent ?? '',
            level: parseInt(el.tagName[1])
        }));

        observer = new IntersectionObserver(
            (entries) => {
                for (const entry of entries) {
                    if (entry.isIntersecting) activeId = entry.target.id;
                }
            },
            { rootMargin: '0px 0px -80% 0px' }
        );

        headings.forEach((h) => {
            const el = document.getElementById(h.id);
            if (el && observer) observer.observe(el);
        });

        window.addEventListener('scroll', updateProgress, { passive: true });
        document.addEventListener('click', handleClickOutside);
        updateProgress();
    });

    onDestroy(() => {
        observer?.disconnect();
        if (typeof window !== 'undefined') {
            window.removeEventListener('scroll', updateProgress);
        }
        if (typeof document !== 'undefined') {
            document.removeEventListener('click', handleClickOutside);
        }
    });

    function updateProgress() {
        const article = document.querySelector('article');
        if (!article) return;

        const rect = article.getBoundingClientRect();
        const articleTop = rect.top + window.scrollY;
        const articleHeight = rect.height;
        const scrollPos = window.scrollY + window.innerHeight;

        const progress = (scrollPos - articleTop) / articleHeight;
        readProgress = Math.min(Math.max(progress, 0), 1) * 100;
    }

    function handleClickOutside(e: MouseEvent) {
        const target = e.target as HTMLElement;
        if (!target.closest('.toc-bar')) {
            expanded = false;
        }
    }

    function activeHeadingText(): string {
        return headings.find((h) => h.id === activeId)?.text ?? headings[0]?.text ?? '';
    }

    function scrollTo(id: string) {
        expanded = false;
        const el = document.getElementById(id);
        if (el) {
            el.scrollIntoView({ behavior: 'smooth' });
        }
    }
</script>

{#if headings.length > 0}
    <div class="toc-bar sticky top-0 z-40 mb-6">
        <button
                class="flex w-full items-center gap-3 border-b border-cat_primary/30 bg-cat_base px-4 py-3 text-sm"
                onclick={() => (expanded = !expanded)}
        >
            <!-- Pie chart progress circle -->
            <div
                    class="h-3.5 w-3.5 shrink-0 rounded-full transition-all"
                    style="background: conic-gradient(
					rgb(var(--cat-primary)) {readProgress}%,
					rgb(var(--cat-primary) / 0.15) {readProgress}%
				);"
            ></div>

            <span class="truncate font-mono text-xs uppercase tracking-wider text-cat_text/80">
				{activeHeadingText()}
			</span>

            <div class="grow"></div>

            <svg
                    class="h-4 w-4 shrink-0 text-cat_text/50 transition-transform {expanded
					? 'rotate-180'
					: ''}"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
            >
                <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M19 9l-7 7-7-7"
                />
            </svg>
        </button>

        {#if expanded}
            <div
                    class="absolute left-0 right-0 border-b border-cat_primary/30 bg-cat_base shadow-lg"
            >
                <ul class="max-h-64 overflow-y-auto py-2">
                    {#each headings as heading}
                        <li>
                            <button
                                    onclick={() => scrollTo(heading.id)}
                                    class="w-full px-4 py-2 text-left text-sm transition-colors hover:bg-cat_primary/10
									{heading.level === 3 ? 'pl-8' : 'pl-4'}
									{activeId === heading.id
									? 'text-cat_tertiary font-semibold'
									: 'text-cat_text/60'}"
                            >
                                {heading.text}
                            </button>
                        </li>
                    {/each}
                </ul>
            </div>
        {/if}
    </div>
{/if}