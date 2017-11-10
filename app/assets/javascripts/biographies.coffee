# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$j = jQuery

$j(document).on "turbolinks:load", ->
    $('#authors-info').hide()
    $('body').removeClass('modal-open')
    $('.modal-backdrop').remove()
    console.log "찐자"
