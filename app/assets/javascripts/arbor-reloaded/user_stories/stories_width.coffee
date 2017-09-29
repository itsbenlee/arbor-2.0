$(document).on 'click', 'a.cancel', ->
  storyId = $(this).data('id')
  storySelector = '#story-text-' + storyId
  $(storySelector).removeClass 'shorten-story'

$(document).on 'click', 'a.delete-story, a.color-story', ->
  storyId = $(this).data('id')
  storySelector = '#story-text-' + storyId

  if $(storySelector).hasClass('shorten-story')
    $(storySelector).removeClass 'shorten-story'
  else
    $(storySelector).addClass 'shorten-story'
