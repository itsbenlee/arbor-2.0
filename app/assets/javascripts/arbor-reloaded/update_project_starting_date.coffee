$(document).ready ->
  return unless $('#project-starting-date-form').length
  $(document).on 'focusin', '.starting-date-form-element', ->
    $('.starting-date-form-button').show()
