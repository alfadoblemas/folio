$(document).ready(function() {

	// Overwrite the submit of the new_comment form
	$("#new_comment").submitWithAjax();
	$("#new_customer").submitWithAjax();
	
	tags_for_invoice(); //
	attachments_for_invoice_form(); // Enable or disable the attch. forms
	select_tax_and_apply_to_invoice_form();
	$("#invoice_extra_info").tabs();
	
	// This show the floating dialog for 
	// adding a new customer in the Invoice Form
	$("#new_customer_ajax_dialog").click(function(){
		$("#new_customer_from_invoice").show();
		$(".floating_dialog").show();
		return false;
	});
	
	// This hide the floating dialog for 
	// adding a new customer in the Invoice Form
	$("#hide_ajax_dialog").click(function(){
		$("#new_customer_from_invoice").hide();
		$(".floating_dialog").hide();
		$("#new_customer").each(function(){
			this.reset();
		});
		return false;
	});
	

});

function select_tax_and_apply_to_invoice_form() {
	$("#invoice_tax_id").live("change", function(){
		var tax_id = $(this).val();
		if(tax_id == "") {
			$("#invoice_tax").val("0");
			$("#tax_rate").val(0);
			$("#tax_info").hide();
			updatePrices();
		} else {
			$.getJSON('/taxes/'+tax_id, function(data){
				$.each(data, function(key, val){
					$("#tax_rate").val(val.value);
					$("#tax_name").html(val.name);
					calcIva();
					updatePrices();
					if(!$("#tax_info").is(":visible")){
						$("#tax_info").show();
					}
				});
			});
		}
	});
}

function attachments_for_invoice_form() {
	$("#document_attachment").bind("change", function() {
		var filename=$(this).val();
		$("#attachment_upload_dialog_step1").hide()
		
		$("#attachment_file_name").text(filename);
		$("#new_document :submit").prop("disabled", false)
		$("#attachment_upload_dialog_step2").show();
	});
	
	$("#show_attachment_form").bind("click", function() {
		$(this).hide();
		$("#new_document :submit").prop("disabled", true)
		$("#attachment_upload_dialog").show();
	});
	
	$("#cancel_invoice_attachment").bind("click", function(){
		if($("#attachment_upload_dialog").is(":visible")) {
			$("#attachment_upload_dialog").hide();
			$("#show_attachment_form").show();
			$("#attachment_upload_dialog_step2").hide();
			$("#attachment_upload_dialog_step1").show()
			$("#new_document").each(function(){
				this.reset();
			});
			return false;
		}		
	});
	
}

function tags_for_invoice(){
	$.ajax({
		url: "/accounts/"+$("#invoice_account_id").val()+"/invoice_tags",
		dataType: "json",
		success: function(data){ 
			$("#invoice_tag_list").tagit({
				availableTags: data
			});

			$("input[type='text']#tagged_with").tagit({
				availableTags: data
			})
		},
		//async: false
	});		
}