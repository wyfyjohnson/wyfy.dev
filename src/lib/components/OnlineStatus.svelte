<script lang="ts">
	let isOnline = $state(true);
</script>

<div class="inline-flex items-center gap-2 rounded-full border border-cat_primary/50 bg-cat_base/80 px-3 py-1.5 backdrop-blur-sm">
	<div class="relative">
		<div class="h-2.5 w-2.5 rounded-full {isOnline ? 'bg-green-400' : 'bg-gray-400'}"></div>
		{#if isOnline}
			<div class="absolute top-0 h-2.5 w-2.5 animate-ping rounded-full bg-green-400 opacity-75"></div>
		{/if}
	</div>
	<span class="text-sm font-medium text-cat_text">
		{isOnline ? 'Online' : 'Offline'}
	</span>
</div>
