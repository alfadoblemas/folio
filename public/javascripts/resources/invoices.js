jQuery.ajaxSetup ({
	'beforeSend': function (xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})


jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

$(document).ready(function() {

	// Overwrite the submit of the new_comment form
	$("#new_comment").submitWithAjax();

	var tags = [];
	
	/** TODO: Obtenemos los tags de forma sincronica,
		para usar la función de autocompletado de tags que viene
		en la librería. Debemos pensar si es mejor cambiarla
		**/
		
	$.ajax({
		url: "/accounts/"+$("#invoice_account_id").val()+"/invoice_tags",
		dataType: "json",
		success: function(data){ tags = data},
		async: false
	})		
	
    $("#invoice_tag_list").tagit({
		availableTags: tags
	});
	
	$("input[type='text']#tagged_with").tagit({
		availableTags: tags
	})
	
	$("#invoice_extra_info").tabs();
	
	$("#document_attachment").bind("change", function() {
		var filename=$(this).val();
		$("#attachment_upload_dialog_step1").hide()
		
		$("#attachment_file_name").append(filename);
		$("#new_document :submit").prop("disabled", false)
		$("#attachment_upload_dialog_step2").show();
	});
	
	$("#show_attachment_form").bind("click", function() {
		$(this).hide();
		$("#new_document :submit").prop("disabled", true)
		$("#attachment_upload_dialog").show();
	})

});
