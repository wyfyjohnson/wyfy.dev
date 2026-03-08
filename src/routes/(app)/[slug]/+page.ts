import { error } from '@sveltejs/kit';
import type { Post } from '$lib/types';

export async function load({ params }) {
    // Load all posts to find neighbors
    const modules = import.meta.glob('/src/posts/*.md', { eager: true });

    const posts: Post[] = [];
    for (const path in modules) {
        const file = modules[path];
        const slug = path.split('/').at(-1)?.replace('.md', '');
        if (file && typeof file === 'object' && 'metadata' in file && slug) {
            const metadata = file.metadata as Omit<Post, 'slug'>;
            if (metadata.published) {
                posts.push({ ...metadata, slug });
            }
        }
    }

    // Sort newest first (same order as blog listing)
    posts.sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime());

    const currentIndex = posts.findIndex((p) => p.slug === params.slug);

    if (currentIndex === -1) {
        // Post not found in published list, try loading it directly
        try {
            const post = await import(`../../../posts/${params.slug}.md`);
            return {
                content: post.default,
                meta: post.metadata,
                prevPost: null,
                nextPost: null
            };
        } catch {
            error(404, `couldn't find ${params.slug}`);
        }
    }

    try {
        const post = await import(`../../../posts/${params.slug}.md`);

        // Previous = older (higher index), Next = newer (lower index)
        const prevPost = currentIndex < posts.length - 1 ? posts[currentIndex + 1] : null;
        const nextPost = currentIndex > 0 ? posts[currentIndex - 1] : null;

        return {
            content: post.default,
            meta: post.metadata,
            prevPost: prevPost ? { slug: prevPost.slug, title: prevPost.title } : null,
            nextPost: nextPost ? { slug: nextPost.slug, title: nextPost.title } : null
        };
    } catch {
        error(404, `couldn't find ${params.slug}`);
    }
}