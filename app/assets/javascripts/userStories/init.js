dynamicInput();

function dynamicInput() {
  var AutosizeInputOptions = (function() {
    function AutosizeInputOptions(space) {
      if (typeof space === 'undefined') { space = 30; }
      this.space = space;
    }

    return AutosizeInputOptions;
  })();

  dynamicInput.AutosizeInputOptions = AutosizeInputOptions;

  var AutosizeInput = (function() {
    function AutosizeInput(input, options) {
      var _this = this;
      this._input = $(input);
      this._options = $.extend({}, AutosizeInput.getDefaultOptions(), options);

      this._mirror = $('<span style = "position: absolute; top: -999px; left: 0; white-space: pre;" />');

      $.each(['fontFamily', 'fontSize', 'fontWeight', 'fontStyle', 'letterSpacing', 'textTransform', 'wordSpacing', 'textIndent'], function (i, val) {
        _this._mirror[0].style[val] = _this._input.css(val);
      });
      $('body').append(this._mirror);

      this._input.on('keydown keyup input propertychange change', function(e) {
        _this.update();
      });

      (function () {
        _this.update();
      })();
    }

    AutosizeInput.prototype.getOptions = function() {
      return this._options;
    };

    AutosizeInput.prototype.update = function() {
      var value = this._input.val() || '';

      if (value === this._mirror.text()) {
        return;
      }

      this._mirror.text(value);

      var newWidth = this._mirror.width() + this._options.space;

      this._input.width(newWidth);
    };

    AutosizeInput.getDefaultOptions = function() {};

    AutosizeInput.getInstanceKey = function() {
      return 'autosizeInputInstance';
    };

    AutosizeInput._defaultOptions = new AutosizeInputOptions();
    return AutosizeInput;
  })();

  dynamicInput.AutosizeInput = AutosizeInput;

  (function($) {
    var pluginDataAttributeName = 'autosize-input';
    var validTypes = ['text', 'password', 'search', 'url', 'tel', 'email', 'number'];

    $(document).on('focus', ':input', function() {
      $(this).attr('autocomplete', 'off');
    });

    $.fn.autosizeInput = function (options) {
      return this.each(function () {

        if (!(this.tagName == 'INPUT' && $.inArray(this.type, validTypes) > -1)) {
          return;
        }

        var $this = $(this);

        if (!$this.data(dynamicInput.AutosizeInput.getInstanceKey())) {
          if (options == undefined) {
            options = $this.data(pluginDataAttributeName);
          }

          $this.data(dynamicInput.AutosizeInput.getInstanceKey(), new dynamicInput.AutosizeInput(this, options));
        }
      });
    };

    $(function () {
      $('input[data-' + pluginDataAttributeName + ']').autosizeInput();
    });
  })($);
}
