# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$j = jQuery

moveTo = (hash) ->
    if hash.length > 0
        $j('span#'+hash).parent().addClass("bg-info", 100)
        $j.scrollTo $j('span#'+hash)
        window.scrollBy(0,-100)
        callback = -> $j('span#'+hash).parent().removeClass("bg-info", 100)
        setTimeout callback, 100

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
