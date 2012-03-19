$(document).ready(function() {
	$("#account_default_tax_id").live("change", function(){
		$(".edit_account").submitWithAjax();
		$(".edit_account").submit();
		$("#tax_"+$(this).val()+" li").effect("highlight", null, 1500);
	});
});