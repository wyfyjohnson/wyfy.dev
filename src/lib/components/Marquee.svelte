<script lang="ts">
	interface Props {
		items: string[];
		speed?: number;
	}

	let { items, speed = 30 }: Props = $props();
</script>

<div class="relative w-full overflow-hidden border-y border-cat_primary/30 bg-cat_base py-4">
	<div class="marquee-container flex gap-8">
		<div class="marquee-content flex shrink-0 gap-8 animate-marquee">
			{#each items as item}
				<span class="text-lg font-medium text-cat_text whitespace-nowrap">
					{item}
					<span class="text-cat_primary">*</span>
				</span>
			{/each}
		</div>
		<!-- Duplicate for seamless loop -->
		<div class="marquee-content flex shrink-0 gap-8 animate-marquee" aria-hidden="true">
			{#each items as item}
				<span class="text-lg font-medium text-cat_text whitespace-nowrap">
					{item}
					<span class="text-cat_primary">*</span>
				</span>
			{/each}
		</div>
	</div>
</div>

<style>
	@keyframes marquee {
		from {
			transform: translateX(0);
		}
		to {
			transform: translateX(-100%);
		}
	}

	.animate-marquee {
		animation: marquee 30s linear infinite;
	}

	.marquee-container:hover .animate-marquee {
		animation-play-state: paused;
	}
</style>
