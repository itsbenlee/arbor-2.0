var isPhones     = (/Android|webOS|iPhone|iPod|BlackBerry/i.test(navigator.userAgent)),
    isSafari     = Object.prototype.toString.call(window.HTMLElement).indexOf('Constructor') > 0;
    isMobile     = (/Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent)),
    isMobileSize = function() {
      return $(window).width() <= 750;
    };
