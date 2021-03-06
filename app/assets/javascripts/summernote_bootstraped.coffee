$j = jQuery
$j(document).on "turbolinks:load", ->
    $j('[data-provider="summernote"]').each ->
        $j(this).summernote
             callbacks: { onApplyCustomStyle: ($target, context, onFormatBlock)  ->
                 tagName = $target.prop('tagName')
                 onFormatBlock(tagName)
             }
             linkTargetBlank: false
             toolbar:   [
                        ['para', ['style']],
                        ['font', ['bold', 'italic', 'underline', 'clear']],
                        ['link', ['link']],
                        ['misc', ['codeview', 'undo', 'redo']]
                    ]
             styleTags: ['p',
                        {tag: 'blockquote', title: 'Quotation'},
                        {tag: 'h5', title: 'Section heading'}]
             onCreateLink: (url) -> url

    do $j('.dropdown-toggle').dropdown
