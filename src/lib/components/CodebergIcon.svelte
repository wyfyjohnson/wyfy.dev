<script lang="ts">
	// Props to match lucide-svelte icon interface
	let {
		size = 24,
		color = 'currentColor',
		strokeWidth = 2,
		class: className = '',
		...props
	}: {
		size?: number | string;
		color?: string;
		strokeWidth?: number;
		class?: string;
		[key: string]: any;
	} = $props();
</script>

<svg
	width={size}
	height={size}
	viewBox="0 0 4.2333332 4.2333335"
	class={className}
	{...props}
>
	<defs>
		<linearGradient id="codeberg-gradient" x1="0%" y1="0%" x2="100%" y2="100%">
			<stop offset="0%" style="stop-color:#2185d0;stop-opacity:0" />
			<stop offset="49.5%" style="stop-color:#2185d0;stop-opacity:0.3" />
			<stop offset="100%" style="stop-color:#2185d0;stop-opacity:0.3" />
		</linearGradient>
	</defs>
	<g transform="matrix(0.06551432,0,0,0.06551432,-2.232417,-1.431776)">
		<!-- Mountain/Berg gradient part -->
		<path
			style="fill:url(#codeberg-gradient);fill-opacity:1;stroke:none"
			d="m 42519.285,-7078.7891 a 0.76086879,0.56791688 0 0 0 -0.738,0.6739 l 33.586,125.8886 a 87.182358,87.182358 0 0 0 39.381,-33.7636 l -71.565,-92.5196 a 0.76086879,0.56791688 0 0 0 -0.664,-0.2793 z"
			transform="matrix(0.37058478,0,0,0.37058478,-15690.065,2662.0533)"
		/>
		<!-- Sky/mountain solid part -->
		<path
			style="fill:{color};fill-opacity:1;stroke:none"
			d="m 11249.461,-1883.6961 c -12.74,0 -23.067,10.3275 -23.067,23.0671 0,4.3335 1.22,8.5795 3.522,12.2514 l 19.232,-24.8636 c 0.138,-0.1796 0.486,-0.1796 0.624,0 l 19.233,24.8646 c 2.302,-3.6721 3.523,-7.9185 3.523,-12.2524 0,-12.7396 -10.327,-23.0671 -23.067,-23.0671 z"
			transform="matrix(1.4006354,0,0,1.4006354,-15690.065,2662.0533)"
		/>
	</g>
</svg>
