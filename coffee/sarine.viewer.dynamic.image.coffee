###!
sarine.viewer.dynamic.image - v0.1.0 -  Thursday, May 14th, 2015, 4:14:37 PM 
 The source code, name, and look and feel of the software are Copyright © 2015 Sarine Technologies Ltd. All Rights Reserved. You may not duplicate, copy, reuse, sell or otherwise exploit any portion of the code, content or visual design elements without express written permission from Sarine Technologies Ltd. The terms and conditions of the sarine.com website (http://sarine.com/terms-and-conditions/) apply to the access and use of this software.
###
class DynamicImage extends Viewer.Dynamic  

	amountOfImages = undefined		
	imagesArr = {}
	downloadImagesArr = {}	
	speed = undefined	
	counter = 1
	
	constructor: (options) ->
		super(options)	
		{@sliceDownload, @backOnEnd, @imageType, @oneDigits, @speed, @amountOfImages} = options		
		@sliceDownload = @sliceDownload || 3
		@oneDigits = @oneDigits || true
		@backOnEnd = @backOnEnd || false
		@speed = @speed || 30
		@amountOfImages = @amountOfImages || 200
		@imagesArr = {}
		@downloadImagesArr = {}
		@first_init_defer = $.Deferred()
		@full_init_defer = $.Deferred()
		@direction = "left"		
		for index in [0..@amountOfImages]
			@imagesArr[index] = undefined								

	convertElement : () ->
		@canvas = $("<canvas>")		
		@ctx = @canvas[0].getContext('2d')
		@element.append(@canvas)		

	first_init : ()->
		defer = @first_init_defer
		defer.notify(@id + " : start load first image")
		_t = @
		
		@loadImage(@src + 'img' + (if @oneDigits then "0" else "00") + (if @imageType then @imageType else ".png")).then((img)->
			_t.canvas.attr {'width':img.width, 'height': img.height}
			_t.ctx.drawImage img , 0 , 0 			
			defer.resolve(_t) 
		)
		defer

	loadParts : (gap,defer)->
		gap = gap || 0
		defer = defer || $.Deferred()
		downloadImages = []
		_t = @
		$.when.apply($,for index in (index for index in Object.getOwnPropertyNames(@imagesArr) when (index + gap) % @sliceDownload == 0)
			do (index)->
				_t.loadImage(_t.src + 'img' + (if index < 10 and not _t.oneDigits  then "0" + index else index)  + (if _t.imageType then _t.imageType else ".png")).then((img)-> downloadImages.push img )
			).then(()->
					for img in downloadImages
						do (img)->
							index = parseInt(img.src.match(/\d+(?=.png|.jpg)/)[0])
							downloadImagesArr[index] = imagesArr[index] = img
					if Object.getOwnPropertyNames(imagesArr).length == (_t.amountOfImages + 1)
						defer.resolve(_t)
					else
						_t.loadParts(++gap,defer)
					_t.delay = (_t.sliceDownload / gap) * _t.speed  
				)
		return defer

	
	full_init : ()->
		defer = @full_init_defer
		defer.notify(@id + " : start load all images")
		@loadParts().then(defer.resolve)  				
		defer		

	nextImage : ()->		
		indexer = Object.getOwnPropertyNames(downloadImagesArr).map((v)-> parseInt(v)) 
		if indexer.length > 1
			@ctx.clearRect 0, 0, @ctx.canvas.width, @ctx.canvas.height
			@ctx.drawImage downloadImagesArr[indexer[counter]] , 0 , 0	
			if @backOnEnd
				@chekDirection()
			else
				counter = (counter + 1) % @amountOfImages	
				
	
	chekDirection : ()->
		if @direction == "right"
				counter--
				if counter % @amountOfImages == 0 
					@direction = "left"
		else
			counter++
			if counter % @amountOfImages == 0 
				@direction = "right" 

@DynamicImage = DynamicImage
