###!
sarine.viewer.dynamic.image - v0.3.0 -  Thursday, July 2nd, 2015, 12:03:58 PM 
 The source code, name, and look and feel of the software are Copyright © 2015 Sarine Technologies Ltd. All Rights Reserved. You may not duplicate, copy, reuse, sell or otherwise exploit any portion of the code, content or visual design elements without express written permission from Sarine Technologies Ltd. The terms and conditions of the sarine.com website (http://sarine.com/terms-and-conditions/) apply to the access and use of this software.
###

class Viewer
  rm = ResourceManager.getInstance();
  constructor: (options) ->
    console.log("")
    @first_init_defer = $.Deferred()
    @full_init_defer = $.Deferred()
    {@src, @element,@autoPlay,@callbackPic} = options
    @id = @element[0].id;
    @element = @convertElement()
    Object.getOwnPropertyNames(Viewer.prototype).forEach((k)-> 
      if @[k].name == "Error" 
          console.error @id, k, "Must be implement" , @
    ,
      @)
    @element.data "class", @
    @element.on "play", (e)-> $(e.target).data("class").play.apply($(e.target).data("class"),[true])
    @element.on "stop", (e)-> $(e.target).data("class").stop.apply($(e.target).data("class"),[true])
    @element.on "cancel", (e)-> $(e.target).data("class").cancel().apply($(e.target).data("class"),[true])
  error = () ->
    console.error(@id,"must be implement" )
  first_init: Error
  full_init: Error
  play: Error
  stop: Error
  convertElement : Error
  cancel : ()-> rm.cancel(@)
  loadImage : (src)-> rm.loadImage.apply(@,[src])
  setTimeout : (delay,callback)-> rm.setTimeout.apply(@,[@delay,callback]) 
    
@Viewer = Viewer 

class Viewer.Dynamic extends Viewer
	@playing = false
	nextImage : Error

	constructor: (options) -> 
		super(options)
		@delay = 50
		Object.getOwnPropertyNames(Viewer.Dynamic.prototype).forEach((k)-> 
			if @[k].name == "Error" 
				console.error @id, k, "Must be implement" , @
		,
			@)
	play: (force,delay) ->
		if force
			@playing = true;
		@nextImage.apply(@) 
		if(@playing)
			_t = @ 
			@setTimeout(@delay,_t.play)   
	stop: ()-> 
		@playing = false


 

class DynamicImage extends Viewer.Dynamic  

	amountOfImages = undefined		
	imagesArr = {}
	downloadImagesArr = {}	
	speed = undefined	
	counter = 1
	
	constructor: (options) ->
		super(options)	
		{@sliceDownload, @backOnEnd, @imageType, @oneDigits, @speed, @amountOfImages, @imageNamePrefix} = options		
		@sliceDownload = @sliceDownload || 1		
		@speed = @speed || 30
		@amountOfImages = @amountOfImages || 200
		@imageNamePrefix = @imageNamePrefix || ''
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
		
		@loadImage(@src + @imageNamePrefix + (if @oneDigits then "0" else "00") + (if @imageType then @imageType else ".png")).then((img)->
			_t.canvas.attr {'width':img.width, 'height': img.height} 			
			if img.src == _t.callbackPic then _t.canvas.attr {'class' : 'no_stone'}    
			_t.ctx.drawImage img , 0 , 0 			
			defer.resolve(_t) 
		)
		defer

	loadParts : (gap,defer)->
		gap = gap || 1
		defer = defer || $.Deferred()
		downloadImages = []
		_t = @
		$.when.apply($,for index in (index for index in Object.getOwnPropertyNames(@imagesArr) when (index + gap) % @sliceDownload == 0)
			do (index)->
				_t.loadImage(_t.src + _t.imageNamePrefix + (if index < 10 and not _t.oneDigits  then "0" + index else index)  + (if _t.imageType then _t.imageType else ".png")).then((img)-> downloadImages.push img )
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


