$j = jQuery

$j ->
    $j('[data-provider="summernote"]').each ->
        $j(this).summernote
             callbacks: { onApplyCustomStyle: ($target, context, onFormatBlock)  ->
                 tagName = $target.prop('tagName')
                 onFormatBlock(tagName)
             }
             height: 500
             toolbar:   [
                        ['para', ['style']],
                        ['font', ['bold', 'italic', 'underline', 'clear']],
                        ['link', ['link']],
                        ['misc', ['codeview']]
                    ]
             styleTags: ['p',
                        {tag: 'blockquote', title: 'Quotation'},
                        {tag: 'h5', title: 'Section heading'}]

    do $j('.dropdown-toggle').dropdown
