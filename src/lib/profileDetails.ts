import profile from '$lib/images/profile.webp';
import { Github, Mail, ExternalLink } from 'lucide-svelte';
import CodebergIcon from '$lib/components/CodebergIcon.svelte';

export const profilePicture = profile;

export const Name = 'Wyatt';

export const Location = 'San Diego, California';

export const Profession = 'Learner';

export const Bio = `Welcome to my personal website! I write about software development, open source projects, and my various technical adventures. Check out my blog and projects below.`;

// Interests for scrolling marquee - customize with your interests!
export const Interests = [
	'Free &',
	'Open Source',
    'Software',
    'Gentoo',
	'NixOS',
	'Linux',
	'Rust',
    'Java',
    'Python',
	'Minecraft',
	'Path of Exile',
	'Learning',
	'Gardening',
    'Cooking'
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
			'This is yet another fetch program. This is a newbie attempt at neofetch meets rust.',
			'I wanted the project to ship with to display something more than just ascii art. So I started to learn what I could do to make that happen.'
		],
		link: '#' // Replace with actual link
	},
	{
		project: 'Backpackage',
		details: [
			'I wanted to see if I could learn Java again and see if I could be comfortable. Like I was years ago.',
			"This mod adds a backpack to the Create mod suite. It's a fantastic mod that just needed one more thing, a backpack!"
		],
		link: '#' // Replace with actual link
	}
	// Add more projects as needed
];

export const Links = [
	{
		name: 'Codeberg',
		url: 'https://codeberg.org/wyfy', // Update with your username
		icon: CodebergIcon
	},
	{
		name: 'GitHub',
		url: 'https://github.com/wyfyjohnson', // Update with your username
		icon: Github
	},
	{
		name: 'Email',
		url: 'mailto:your.email@example.com', // Update with your email
		icon: Mail
	},
	{
		name: 'Source Code',
		url: 'https://codeberg.org/wyfy/wyfy.dev', // Link to this site's source
		icon: ExternalLink
	}
];
