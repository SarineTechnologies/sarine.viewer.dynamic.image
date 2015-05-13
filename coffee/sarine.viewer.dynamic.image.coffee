###!
sarine.viewer.dynamic.image - v0.1.0 -  Wednesday, May 13th, 2015, 1:46:22 PM 
 The source code, name, and look and feel of the software are Copyright © 2015 Sarine Technologies Ltd. All Rights Reserved. You may not duplicate, copy, reuse, sell or otherwise exploit any portion of the code, content or visual design elements without express written permission from Sarine Technologies Ltd. The terms and conditions of the sarine.com website (http://sarine.com/terms-and-conditions/) apply to the access and use of this software.
###
class DynamicImage extends Viewer.Dynamic  

	
	constructor: (options) ->
		super(options)								

	convertElement : () ->
		@canvas = $("<canvas>")		
		@ctx = @canvas[0].getContext('2d')
		@element.append(@canvas)		

	first_init : ()->
		defer = $.Deferred()		
		defer
	
	full_init : ()->
		defer = $.Deferred()		
		defer	

		

@DynamicImage = DynamicImage
