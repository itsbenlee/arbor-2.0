// Bind key events to user roles being typed live, Ale
$('#user_story_role.role').on('keydown keyup', function(e) {
  prependGramaticallyCorrectArticle(this);
});

// On document ready
$(document).ready(function() {
  fixArticlesForRolesOnLab();
  fixArticlesForRolesOnBacklog();
});

function fixArticlesForRolesOnLab(){
  // for lab, look for articles and fix them accordingly, Ale
  if ($('.hypothesis').length > 0) {
    $('.role').each(function(index, currentValue) {
      if (currentValue.children.length > 0 &&
          currentValue.children[1].tagName == 'INPUT') {
        prependGramaticallyCorrectArticle(currentValue.children[1]);
      }
    });
  }
};

function fixArticlesForRolesOnBacklog(){
  // for backlog, look for articles and fix them accordingly, Ale
  if ($('.user-stories').length > 0) {
    $('.story-text').each(function(index, currentValue) {
      if (currentValue.children.length &&
          currentValue.children[1].tagName == 'SPAN') {
        prependGramaticallyCorrectArticle(currentValue.children[1]);
      }
    });
  }
};

function prependGramaticallyCorrectArticle(element){
  var article = 'a',
      textToArticleize = (element.tagName == 'SPAN') ? element.textContent : element.value;

  element.parentNode.children[0].textContent = 'As ' + article;
  if (textToArticleize.length > 0) {
    article = indefiniteArticle(textToArticleize);
    element.parentNode.children[0].textContent = 'As ' + article;
  }
}

var indefiniteArticle = function(word) {
  var l_word = word.toLowerCase(),
      alternativeCases = [],
      regexes = [/^e[uw]/, /^onc?e\b/, /^uni([^nmd]|mo)/, /^u[bcfhjkqrst][aeiou]/],
      toReturn;

  // Single letter word which should be preceeded by 'an'
  toReturn = (l_word.length == 1 && 'aedhilmnorsx'.indexOf(l_word) > -1 ) ? 'an' : 'a';

  // Capital words which should likely be preceeded by 'an'
  if (word.match(/(?!FJO|[HLMNS]Y.|RY[EO]|SQU|(F[LR]?|[HL]|MN?|N|RH?|S[CHKLMNPTVW]?|X(YL)?)[AEIOU])[FHLMNRSX][A-Z]/)) {
    toReturn = 'an';
  }

  // Special cases where a word that begins with a vowel should be preceeded by 'a'

  $.each(regexes, function(index, currentRegEx){
    if (l_word.match(currentRegEx)) toReturn = 'a';
  });

  // Special capital words (UK, UN)
  if (word.match(/^U[NK][AIEO]/)) {
    toReturn = 'a';
  }
  else if (word == word.toUpperCase()) {
    toReturn = ('aedhilmnorsx'.indexOf(l_word[0]) > -1) ? 'an' : 'a';
  }

  // Basic method of words that begin with a vowel being preceeded by 'an'
  if ('aeiou'.indexOf(l_word[0]) > -1) toReturn = "an";

  // Instances where y follwed by specific letters is preceeded by 'an'
  if (l_word.match(/^y(b[lor]|cl[ea]|fere|gg|p[ios]|rou|tt)/)) toReturn = 'an';

  // Specific words that should be preceeded by 'a'
  alternativeCases = ['user'];
  if (alternativeCases.indexOf(l_word) > -1) toReturn = 'a';

  // Specific start of words that should be preceeded by 'an'
  alternativeCases = ['honest', 'hour', 'hono', 'x-'];
  $.each(alternativeCases, function(index, currentValue){
    if(currentValue == l_word.substring(0, currentValue.length)) toReturn = 'an';
  });

  return toReturn;
};
