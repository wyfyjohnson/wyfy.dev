<script lang="ts">
	import * as Avatar from '$lib/components/ui/avatar/index.js';
	import profilePictue from '$lib/images/profile.webp';
</script>

<Avatar.Root class="h-20 w-20 md:h-24 md:w-24">
	<Avatar.Image src={profilePictue} alt="BlackCat avatar WyfyDev uses a lot" />
	<Avatar.Fallback>CN</Avatar.Fallback>
</Avatar.Root>
