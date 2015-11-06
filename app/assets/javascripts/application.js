//= require jquery
//= require jquery_ujs
//= require jquery-ui/sortable
//= require foundation
//= require mustache
//= require jquery.mustache
//= require jquery-ui/autocomplete
//= require assets/global-vars
//= require i18n
//= require i18n/translations
//= require init
//= require projects/projects.js.erb
//= require assets/customTextArea
//= require canvases/canvases
//= require hypotheses/hypotheses
//= require hypotheses/userStory
//= require hypotheses/goal
//= require userStories/userStories
//= require_tree ./vendor
//= require_tree ./attachments


/*

Only on Safari this kind of constructor exists

An unique naming pattern in its naming of constructors.
This is the least durable method of all listed properties, because it's undocumented.
On the other hand, there's no benefit in renaming the constructor,
so it's likely to stay for a long while.

*/
var is_safari = Object.prototype.toString.call(window.HTMLElement).indexOf('Constructor') > 0;
