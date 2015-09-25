<rg-context-menu>

	<div class="menu { visible: visible }">
		<div class="list">
			<div each="{ opts.items }" class="item { inactive: inactive }" onclick="{ selectItem }">
				<rg-raw if="{ content && !text }" content="{ content }"></rg-raw>
				<span if="{ text }">{ text }</span>
			</div>
			<yield/>
		</div>
	</div>

	<script>
		var handleClickOutside = e => {
			if (!this.root.contains(e.target)) {
				if (rg.isFunction(opts.onclose) && this.visible) opts.onclose(e)
				this.visible = false
				this.update()
			}
		}

		var openMenu = e => {
			e.preventDefault()
			if (rg.isFunction(opts.onopen)) opts.onopen(e)
			this.visible = true
			this.update()

			var x = e.pageX
			var y = e.pageY
			var dd = this.root.querySelector('.menu')
			var ddRect = dd.getBoundingClientRect()
				// Handle horizontal boundary
			if (x > (window.innerWidth + window.scrollX) - ddRect.width) // Its too close to the edge!
				x = (window.innerWidth + window.scrollX) - ddRect.width

			dd.style.left = x + 'px'

			// Handle vertical boundary
			if (y > (window.innerHeight + window.scrollY) - ddRect.height) // Its too close to the edge!
				y = (window.innerHeight + window.scrollY) - ddRect.height

			dd.style.top = y + 'px'
			this.update()
		}

		this.on('mount', () => {
			document.addEventListener('click', handleClickOutside)
			let targets = document.querySelectorAll('[rg-context-menu]')
			for (var i = 0, target; target = targets[i]; i++) {
				if (target.attributes['rg-context-menu'].value == opts.id)
					target.addEventListener('contextmenu', openMenu)
				else
					target.addEventListener('contextmenu', this.closeMenu)
			}
		});

		this.on('unmount', () => {
			document.removeEventListener('click', handleClickOutside)
			let targets = document.querySelectorAll('[rg-context-menu]')
			for (var i = 0, target; target = targets[i]; i++) {
				if (target.attributes['rg-context-menu'].value == opts.id)
					target.removeEventListener('contextmenu', openMenu)
				else
					target.removeEventListener('contextmenu', this.closeMenu)
			}
		})

		this.closeMenu = () => {
			this.visible = false
			this.update()
		}

		this.selectItem = e => {
			if (!e.item.inactive) {
				if (e.item.onselect) e.item.onselect(e.item)

				this.visible = false
			}
		}
	</script>

	<style scoped>
		.menu {
			display: none;
			position: absolute;
			background-color: white;
			border: 1px solid #D3D3D3;
			border-top: 0;
			text-align: left;
			-webkit-user-select: none;
			-moz-user-select: none;
			-ms-user-select: none;
			user-select: none;
			box-sizing: border-box;
			z-index: 2;
		}

		.menu.visible {
			display: block;
		}

		.item {
			cursor: pointer;
			padding: 10px;
			border-top: 1px solid #E8E8E8;
			background-color: #fff;
			white-space: nowrap;
			overflow: hidden;
			text-overflow: ellipsis;
		}

		.item:hover {
			background-color: #f3f3f3;
		}

		.item.inactive {
			color: #8a8a8a;
			font-style: italic;
		}

		.item.inactive:hover {
			background-color: #fff;
		}
	</style>

</rg-context-menu>