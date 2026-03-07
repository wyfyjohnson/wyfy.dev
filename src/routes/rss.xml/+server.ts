import type { Post } from '$lib/types';
import { Name, Bio } from '$lib/profileDetails';

export const prerender = true;

const siteUrl = 'https://wyfy.dev';
const siteTitle = `${Name}'s Blog`;
const siteDescription = Bio;

async function getPosts() {
	let posts: Post[] = [];

	const paths = import.meta.glob('/src/posts/*.md', { eager: true });

	for (const path in paths) {
		const file = paths[path];
		const slug = path.split('/').at(-1)?.replace('.md', '');

		if (file && typeof file === 'object' && 'metadata' in file && slug) {
			const metadata = file.metadata as Omit<Post, 'slug'>;
			const post = { ...metadata, slug } satisfies Post;
			// Only include published posts
			post.published && posts.push(post);
		}
	}

	posts = posts.sort(
		(first, second) => new Date(second.date).getTime() - new Date(first.date).getTime()
	);

	return posts;
}

function escapeXml(unsafe: string): string {
	return unsafe
		.replace(/&/g, '&amp;')
		.replace(/</g, '&lt;')
		.replace(/>/g, '&gt;')
		.replace(/"/g, '&quot;')
		.replace(/'/g, '&apos;');
}

function generateRssFeed(posts: Post[]): string {
	const lastBuildDate = new Date().toUTCString();
	const pubDate = posts.length > 0 ? new Date(posts[0].date).toUTCString() : lastBuildDate;

	const rssItems = posts
		.map((post) => {
			const postUrl = `${siteUrl}/${post.slug}`;
			const postDate = new Date(post.date).toUTCString();

			return `
		<item>
			<title>${escapeXml(post.title)}</title>
			<link>${escapeXml(postUrl)}</link>
			<guid isPermaLink="true">${escapeXml(postUrl)}</guid>
			<description>${escapeXml(post.description)}</description>
			<pubDate>${postDate}</pubDate>
			${post.categories.map((cat) => `<category>${escapeXml(cat)}</category>`).join('\n\t\t\t')}
		</item>`;
		})
		.join('\n');

	return `<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
	<channel>
		<title>${escapeXml(siteTitle)}</title>
		<link>${siteUrl}</link>
		<description>${escapeXml(siteDescription)}</description>
		<language>en</language>
		<lastBuildDate>${lastBuildDate}</lastBuildDate>
		<pubDate>${pubDate}</pubDate>
		<atom:link href="${siteUrl}/rss.xml" rel="self" type="application/rss+xml" />
		${rssItems}
	</channel>
</rss>`;
}

export async function GET() {
	const posts = await getPosts();
	const feed = generateRssFeed(posts);

	return new Response(feed, {
		headers: {
			'Content-Type': 'application/xml',
			'Cache-Control': 'max-age=0, s-maxage=3600'
		}
	});
}
