
/*!
sarine.viewer.dynamic.image - v0.1.0 -  Wednesday, May 13th, 2015, 1:46:22 PM 
 The source code, name, and look and feel of the software are Copyright © 2015 Sarine Technologies Ltd. All Rights Reserved. You may not duplicate, copy, reuse, sell or otherwise exploit any portion of the code, content or visual design elements without express written permission from Sarine Technologies Ltd. The terms and conditions of the sarine.com website (http://sarine.com/terms-and-conditions/) apply to the access and use of this software.
 */

(function() {
  var DynamicImage,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  DynamicImage = (function(_super) {
    __extends(DynamicImage, _super);

    function DynamicImage(options) {
      DynamicImage.__super__.constructor.call(this, options);
    }

    DynamicImage.prototype.convertElement = function() {
      this.canvas = $("<canvas>");
      this.ctx = this.canvas[0].getContext('2d');
      return this.element.append(this.canvas);
    };

    DynamicImage.prototype.first_init = function() {
      var defer;
      defer = $.Deferred();
      return defer;
    };

    DynamicImage.prototype.full_init = function() {
      var defer;
      defer = $.Deferred();
      return defer;
    };

    return DynamicImage;

  })(Viewer.Dynamic);

  this.DynamicImage = DynamicImage;

}).call(this);
