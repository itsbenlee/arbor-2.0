$(document).on 'click', '.user-stories-container .color-story', (event) ->
  event.preventDefault()
  event.stopPropagation()
  $(this).parent().next('.color-tags').toggleClass 'visible'
