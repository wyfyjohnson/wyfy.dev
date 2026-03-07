import profile from '$lib/images/profile.webp';
import { Github, Mail, ExternalLink } from 'lucide-svelte';

export const profilePicture = profile;

export const Name = 'Wyatt';

export const Location = 'San Diego, California';

export const Profession = 'Learner';

export const Bio = `Welcome to my personal website! I write about software development, open source projects, and my various technical adventures. Check out my blog and projects below.`;

// Interests for scrolling marquee - customize with your interests!
export const Interests = [
	'Software Development',
	'Open Source',
	'NixOS',
	'Linux',
	'Rust',
	'TypeScript',
	'SvelteKit',
	'Web Development',
	'System Administration'
];

// Work experience - customize this section with your actual work history
export const Work = [
	// Example format - replace or remove as needed:
	// {
	// 	link: 'https://company.com/',
	// 	position: 'Your Position',
	// 	company: 'Company Name',
	// 	isCurrent: true,
	// 	start_date: 'MM/YYYY',
	// 	end_date: 'Current',
	// 	responsibilities: [
	// 		'Description of what you did',
	// 		'Another responsibility',
	// 		'And another'
	// 	]
	// }
];

// Projects showcase - add your actual projects here
export const Projects = [
	{
		project: 'Huginn',
		details: [
			'Add details about your Huginn project here',
			'Describe features, tech stack, and what makes it interesting'
		],
		link: '#' // Replace with actual link
	},
	{
		project: 'Minecraft Mods',
		details: [
			'Add details about your Minecraft mods',
			'What mods have you created? What do they do?'
		],
		link: '#' // Replace with actual link
	}
	// Add more projects as needed
];

export const Links = [
	{
		name: 'Codeberg',
		url: 'https://codeberg.org/yourusername', // Update with your username
		icon: Github
	},
	{
		name: 'GitHub',
		url: 'https://github.com/yourusername', // Update with your username
		icon: Github
	},
	{
		name: 'Email',
		url: 'mailto:your.email@example.com', // Update with your email
		icon: Mail
	},
	{
		name: 'Source Code',
		url: 'https://codeberg.org/yourusername/wyfy.dev', // Link to this site's source
		icon: ExternalLink
	}
];
