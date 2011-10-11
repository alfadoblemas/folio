$(document).ready(function() {
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

});
