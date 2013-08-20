###
standalone: true
###

# App
class App extends BevryApp

	# Constructor
	constructor: (args...) ->
		# Prepare
		@config ?= {}
		@config.articleScrollOpts ?= {}
		@config.sectionScrollOpts ?= {}

		# Apply
		@config.articleScrollOpts.offsetTop = 100
		@config.sectionScrollOpts.offsetTop = 80

		# Resize
		$(window).on('resize', @resize)

		super

	onDomReady: =>
		# Make the sidebar a slide scroll panel
		$('.sidebar').slideScrollPanel({
			direction: 'left'
			keepVisibleBy: '20px'
			autoShowAbove: 0.7
			autoHideBelow: 0.3
			autoContentWidth: false
			autoContentHeight: false
			autoWrapWidth: true
			autoWrapHeight: true
			wrapStyles:
				margin: 0
				padding: 0
				position: 'fixed'
				top: '2.5em'
				left: 0
				overflow: 'auto'
				'z-index': 500
			contentStyles:
				margin: 0
				padding: 0
				width: '100%'
				display: 'inline-block'
		}).data('slidescrollpanel').showPanel()

		# Forward
		super

	resize: =>
		# Height Adjust
		$('.sidebar').find('.list-menu').height $(window).height() - $('.topbar').height()

		# Chain
		@

	# State Change
	stateChange: (event,data) =>
		# Fetch
		$sidebar = $('.sidebar')

		# Ensure our sidebar activity is the same as the remote
		$sidebarRemote = data?.$dataBody?.find('.sidebar')
		if $sidebarRemote and $sidebarRemote.length isnt 0
			# Remove active menu and item
			$sidebar.find('.active').removeClass('active').addClass('inactive')

			# Discover active menu and item in rmeote
			$activeMenuRemote = $sidebarRemote.find('.list-menu-category.active')
			$activeItemRemote = $activeMenuRemote.find('.list-menu-item.active')

			# Update corresponding local menu and item to be active
			if $activeItemRemote and $activeItemRemote.length isnt 0
				$activeMenuLocal = $sidebar.find('.list-menu-category').eq($activeMenuRemote.index()).removeClass('inactive').addClass('active')
				$activeItemLocal = $activeMenuLocal.find('.list-menu-item').eq($activeItemRemote.index()).removeClass('inactive').addClass('active')
		else
			# Discover active menu and item in rmeote
			$activeMenuLocal = $sidebar.find('.list-menu-category.active')
			$activeItemLocal = $activeMenuLocal.find('.list-menu-item.active')

		# Resize
		@resize()

		# Scroll to the active menu item
		$activeItemLocal = $sidebar.find('.list-menu-category:first').addClass('active')  if !$activeItemLocal or $activeItemLocal.length is 0
		$activeItemLocal.ScrollTo({
			onlyIfOutside: true
		})

		# Super
		super


# Create
app = new App()