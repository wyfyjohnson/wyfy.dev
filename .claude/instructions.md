# Blog Post Page — Fix Spec v4

This spec is written against the actual current code. Do not do anything not listed here.

---

## Pre-flight

Open `src/lib/types.ts` and report the exact field name used for post tags — is it `tags`, `categories`, or something else? Report before making any changes.

---

## Fix 1: Prev/Next — always render both slots

### Current code (lines ~17–35 of `[slug]/+page.svelte`)

```svelte
{#if data.prevPost || data.nextPost}
    <nav ...>
        {#if data.prevPost}...<a>...</a>{/if}
        {#if data.nextPost}...<a>...</a>{/if}
    </nav>
{/if}
```

### Problem

When only one of `prevPost` or `nextPost` is null, that slot disappears entirely and the remaining card stretches to fill the full width. The reference design always shows two slots — if one has no post, it renders as an empty placeholder (no link, dimmed).

### Fix

Replace the entire `<nav>` block with this pattern:

```svelte
<nav class="mb-8 flex flex-row gap-4">
    <!-- Previous slot — always rendered -->
    {#if data.prevPost}
        <a
            href="/{data.prevPost.slug}"
            class="flex-1 block p-4 border transition-colors hover:border-cat_tertiary"
        >
            <div class="text-xs uppercase tracking-wide mb-1 opacity-60">← Previous</div>
            <div class="text-sm font-medium">{data.prevPost.title}</div>
        </a>
    {:else}
        <div class="flex-1 p-4 border opacity-20 cursor-default"></div>
    {/if}

    <!-- Next slot — always rendered -->
    {#if data.nextPost}
        <a
            href="/{data.nextPost.slug}"
            class="flex-1 block p-4 border text-right transition-colors hover:border-cat_tertiary"
        >
            <div class="text-xs uppercase tracking-wide mb-1 opacity-60">Next →</div>
            <div class="text-sm font-medium">{data.nextPost.title}</div>
        </a>
    {:else}
        <div class="flex-1 p-4 border opacity-20 cursor-default"></div>
    {/if}
</nav>
```

The outer `{#if data.prevPost || data.nextPost}` wrapper should also be removed — the nav renders unconditionally (there will always be at least one post in either direction once you have more than one post, and the empty placeholder handles the edge case gracefully).

---

## Fix 2: Move header out of article prose, fix heading colours

### Current problem

The `<hgroup>` containing the post title, date and tags is nested inside `<article class="prose ... prose-headings:text-cat_primary ...">`. This has two bad effects:

1. The post `<h1>` title is coloured green by `prose-headings:text-cat_primary`
2. All article headings (`h2`, `h3`) are also coloured fully green — but the `tailwind.config.js` typography plugin correctly sets only `h2::before` to the accent colour. The `prose-headings:text-cat_primary` utility on the article element overrides this and colours the entire heading text.

### Fix — two steps

**Step A:** Move the `<hgroup>` and the tags `<div>` out of the `<article>` element entirely. They should sit above the grid (above the `<div class="grid ...">`) or inside the grid's article column but outside the `<article>` tag. The simplest approach: move them above the grid div, alongside the prev/next nav.

The structure should be:

```
[header card — hgroup with title, date, tags]   ← outside article, outside grid
[prev/next nav]                                  ← outside article, outside grid
[grid]
  [aside — ToC]
  [article — prose content only, no hgroup]
```

**Step B:** Remove `prose-headings:text-cat_primary` from the `<article>` class list.

The `tailwind.config.js` already has the correct `h2::before` colour set via the typography plugin. Once `prose-headings:text-cat_primary` is removed, the plugin's config will take effect and only the `//` prefix will be in the accent colour. The heading text itself will inherit the prose default (light/white).

Do not change `tailwind.config.js` — it is already correct.

---

## Fix 3: Header card styling

The `<hgroup>` currently has no border. Once it is moved outside the article (Fix 2 Step A), add a border to it:

```svelte
<hgroup class="mb-6 p-4 border border-cat_tertiary text-cat_text">
```

This matches the reference design's bordered header card. Use `border-cat_tertiary` which is already defined in `tailwind.config.js` as a Tailwind colour.

The date and tags remain inside the hgroup. Do not change their existing styles.

---

## Fix 4: h1 inside article body

Once the `<hgroup>` is moved out of `<article>`, check whether the markdown content itself starts with a `# Title` line that renders as a second `h1` inside the article body.

Open one `.md` file in `src/posts/` and check. Report what you find.

- If the markdown starts with `# Title`: add this scoped style to `[slug]/+page.svelte`:
```svelte
<style>
    article :global(h1:first-child) {
        display: none;
    }
</style>
```
- If the markdown does not start with `# Title`: do nothing.

---

## Summary of changes to `[slug]/+page.svelte`

1. Remove `prose-headings:text-cat_primary` from `<article>` class
2. Move `<hgroup>` and tags `<div>` above the grid
3. Add `border border-cat_tertiary p-4 mb-6` to the hgroup
4. Replace prev/next nav with always-two-slot version
5. Add `<style>` block to hide `h1:first-child` in article if needed

---

## Files to modify

| File | Change |
|------|--------|
| `src/routes/[slug]/+page.svelte` | All fixes above |

## Files to leave completely alone

Everything else. Specifically:
- `tailwind.config.js` — already correct, do not touch
- `src/app.css`
- `src/lib/components/TableOfContents.svelte`
- `src/routes/[slug]/+page.ts`
- Any file not listed above