# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$j = jQuery
$j(document).on "turbolinks:load", ->
    $j('#static_content_body[data-provider="summernote"]').each ->
        $j(this).summernote
             callbacks: { onApplyCustomStyle: ($target, context, onFormatBlock)  ->
                 tagName = $target.prop('tagName')
                 onFormatBlock(tagName)
             }
             linkTargetBlank: false
             height: 500
             toolbar:   [
                        ['para', ['style', 'paragraph','ul', 'ol']],
                        ['font', ['bold', 'italic', 'underline', 'clear','superscript']],
                        ['fontsize', ['fontsize']],
                        ['color', ['color']],
                        ['link', ['link', 'picture']],
                        ['misc', ['codeview', 'undo', 'redo']]
                    ]
             styleTags: ['p',
                        {tag: 'blockquote', title: 'Quotation'},
                        {tag: 'h5', title: 'Section heading'}]
             onCreateLink: (url) -> url

    do $j('.dropdown-toggle').dropdown
