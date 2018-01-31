# Default to JSON responses for remote calls
$j = jQuery
$j(document).on "turbolinks:load", ->

    $j("div#comment_success").hide()
    form = $j("form#new_comment")

    $j.ajaxSetup({
        dataType: 'json'
    })

    $j('#myModal').on('hidden.bs.modal', () ->
        form.show()
        $j("div#comment_success").hide()
    )

    $j("#new_comment").on("ajax:success", (e) ->
        data = e.detail[0]
        console.log data['status']
        form.hide()
        form.clear_form_fields()
        $j("div#comment_success").show()
        #$j("#clients").append("<li>" + data['name'] + "</li>")
        #$j("#clients").effect("highlight")
    ).on("ajax:error", (e) ->
        data = e.detail[0]
        console.log data['status']
        form.render_form_errors('comment', data['errors'])
    )

    $j.fn.render_form_errors = (model_name, errors) ->
      this.clear_form_errors()
      $j.each(errors, (field, messages) ->
        input = form.find('input, select, textarea').filter(->
              name = $(this).attr('name')
              if name
                  name.match(new RegExp(model_name + '\\[' + field + '\\(?'))
        )
        input.closest('.form-group').addClass('has-error')
        input.parent().append('<span class="help-block">' + $j.map(messages, (m) -> m.charAt(0).toUpperCase() + m.slice(1)).join('<br />') + '</span>')
      )

    $j.fn.clear_form_errors = () ->
      this.find('.form-group').removeClass('has-error')
      this.find('span.help-block').remove()

    $j.fn.clear_form_fields = () ->
      this.find('input, textarea').not(':submit, #comment_biography_id').val('')
      this.clear_form_errors()
