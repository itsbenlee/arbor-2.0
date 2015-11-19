var is_ipad     = navigator.userAgent.match(/iPad/i) !== null;
var is_phone    = navigator.userAgent.match(/iPhone/i) !== null;
var phones      = (/Android|webOS|iPhone|iPod|BlackBerry/i.test(navigator.userAgent));
var is_phones   = phones ? true : false;
var mobiles     = (/Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent));
var is_mobile   = mobiles ? true : false;
var body_height = $('body').height();
var html_height = $('html').height();
/*

Only on Safari this kind of constructor exists

An unique naming pattern in its naming of constructors.
This is the least durable method of all listed properties, because it's undocumented.
On the other hand, there's no benefit in renaming the constructor,
so it's likely to stay for a long while.

*/
var is_safari = Object.prototype.toString.call(window.HTMLElement).indexOf('Constructor') > 0;
