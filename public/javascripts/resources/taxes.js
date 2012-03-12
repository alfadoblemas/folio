$(document).ready(function() {

	// Overwrite the submit of the new_comment form
	$("#new_tax").submitWithAjax();
	
	// live allows to delete inmediatly after is added
	$(".delete_tax").live("click",function(){
		$.post(this.href, {_method: 'delete'}, null, "script");
		return false;
	});

});