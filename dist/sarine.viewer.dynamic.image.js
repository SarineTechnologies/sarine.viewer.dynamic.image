
/*!
sarine.viewer.dynamic.image - v0.5.0 -  Tuesday, January 2nd, 2018, 5:01:35 PM 
 The source code, name, and look and feel of the software are Copyright © 2015 Sarine Technologies Ltd. All Rights Reserved. You may not duplicate, copy, reuse, sell or otherwise exploit any portion of the code, content or visual design elements without express written permission from Sarine Technologies Ltd. The terms and conditions of the sarine.com website (http://sarine.com/terms-and-conditions/) apply to the access and use of this software.
 */

(function() {
  var DynamicImage,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  DynamicImage = (function(_super) {
    var amountOfImages, counter, downloadImagesArr, imagesArr, speed;

    __extends(DynamicImage, _super);

    amountOfImages = void 0;

    imagesArr = {};

    downloadImagesArr = {};

    speed = void 0;

    counter = 1;

    function DynamicImage(options) {
      var index, _i, _ref;
      DynamicImage.__super__.constructor.call(this, options);
      this.sliceDownload = options.sliceDownload, this.backOnEnd = options.backOnEnd, this.imageType = options.imageType, this.oneDigits = options.oneDigits, this.speed = options.speed, this.amountOfImages = options.amountOfImages, this.imageNamePrefix = options.imageNamePrefix;
      this.sliceDownload = this.sliceDownload || 1;
      this.speed = this.speed || 30;
      this.amountOfImages = this.amountOfImages || 200;
      this.imageNamePrefix = this.imageNamePrefix || '';
      this.imagesArr = {};
      this.downloadImagesArr = {};
      this.first_init_defer = $.Deferred();
      this.full_init_defer = $.Deferred();
      this.direction = "left";
      for (index = _i = 0, _ref = this.amountOfImages; 0 <= _ref ? _i <= _ref : _i >= _ref; index = 0 <= _ref ? ++_i : --_i) {
        this.imagesArr[index] = void 0;
      }
    }

    DynamicImage.prototype.convertElement = function() {
      this.canvas = $("<canvas>");
      this.ctx = this.canvas[0].getContext('2d');
      return this.element.append(this.canvas);
    };

    DynamicImage.prototype.first_init = function() {
      var defer, _t;
      defer = this.first_init_defer;
      defer.notify(this.id + " : start load first image");
      _t = this;
      this.loadImage(this.src + this.imageNamePrefix + (this.oneDigits ? "0" : "00") + (this.imageType ? this.imageType : ".png")).then(function(img) {
        _t.canvas.attr({
          'width': img.width,
          'height': img.height
        });
        if (img.src === _t.callbackPic) {
          _t.canvas.attr({
            'class': 'no_stone'
          });
        }
        _t.ctx.drawImage(img, 0, 0);
        return defer.resolve(_t);
      });
      return defer;
    };

    DynamicImage.prototype.loadParts = function(gap, defer) {
      var downloadImages, index, _t;
      gap = gap || 1;
      defer = defer || $.Deferred();
      downloadImages = [];
      _t = this;
      $.when.apply($, (function() {
        var _i, _len, _ref, _results;
        _ref = (function() {
          var _j, _len, _ref, _results1;
          _ref = Object.getOwnPropertyNames(this.imagesArr);
          _results1 = [];
          for (_j = 0, _len = _ref.length; _j < _len; _j++) {
            index = _ref[_j];
            if ((index + gap) % this.sliceDownload === 0) {
              _results1.push(index);
            }
          }
          return _results1;
        }).call(this);
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          index = _ref[_i];
          _results.push((function(index) {
            return _t.loadImage(_t.src + _t.imageNamePrefix + (index < 10 && !_t.oneDigits ? "0" + index : index) + (_t.imageType ? _t.imageType : ".png")).then(function(img) {
              return downloadImages.push(img);
            });
          })(index));
        }
        return _results;
      }).call(this)).then(function() {
        var img, _fn, _i, _len;
        _fn = function(img) {
          var index;
          index = parseInt(img.src.match(/\d+(?=.png|.jpg)/)[0]);
          return downloadImagesArr[index] = imagesArr[index] = img;
        };
        for (_i = 0, _len = downloadImages.length; _i < _len; _i++) {
          img = downloadImages[_i];
          _fn(img);
        }
        if (Object.getOwnPropertyNames(imagesArr).length === (_t.amountOfImages + 1)) {
          defer.resolve(_t);
        } else {
          _t.loadParts(++gap, defer);
        }
        return _t.delay = (_t.sliceDownload / gap) * _t.speed;
      });
      return defer;
    };

    DynamicImage.prototype.full_init = function() {
      var defer;
      defer = this.full_init_defer;
      defer.notify(this.id + " : start load all images");
      this.loadParts().then(defer.resolve);
      return defer;
    };

    DynamicImage.prototype.nextImage = function() {
      var indexer;
      indexer = Object.getOwnPropertyNames(downloadImagesArr).map(function(v) {
        return parseInt(v);
      });
      if (indexer.length > 1) {
        this.ctx.clearRect(0, 0, this.ctx.canvas.width, this.ctx.canvas.height);
        this.ctx.drawImage(downloadImagesArr[indexer[counter]], 0, 0);
        if (this.backOnEnd) {
          return this.chekDirection();
        } else {
          return counter = (counter + 1) % this.amountOfImages;
        }
      }
    };

    DynamicImage.prototype.chekDirection = function() {
      if (this.direction === "right") {
        counter--;
        if (counter % this.amountOfImages === 0) {
          return this.direction = "left";
        }
      } else {
        counter++;
        if (counter % this.amountOfImages === 0) {
          return this.direction = "right";
        }
      }
    };

    return DynamicImage;

  })(Viewer.Dynamic);

  this.DynamicImage = DynamicImage;

}).call(this);
