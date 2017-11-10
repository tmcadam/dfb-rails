# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$j = jQuery

moveTo = (hash) ->
    if hash.length > 0
        $j.scrollTo $j('span#'+hash)

onArrange = ->
    hash = location.hash.replace('#', '')
    moveTo hash

onAuthorClick = ->
    hash = $j(this).data("hash")
    location.hash = hash
    moveTo hash

$j(document).on "turbolinks:load", ->
    $j('span.author-link').click onAuthorClick
    $j('#authors').on 'layoutComplete', onArrange
    $j('#authors').isotope ->
        itemSelector: '.item'
