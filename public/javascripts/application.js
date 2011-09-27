// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function remove_fields(link) {
    $(link).prev("input[type=hidden]").val("1");
    $(link).parent().parent().find(".item-total").val(0);
    $(link).closest(".fields").hide();
    updatePrices();
}

function add_fields(link, association, content) {
	var index = parseInt($("#invoice_items_index").val());
	var new_index = index + 1;
	$("#invoice_items_index").val(new_index);
    var new_id = new Date().getTime();
	var regexp = new RegExp("_replaceme_", "g");
    $('#newInvoiceItems').append(content.replace(regexp, index));
}


function itemQuantityChanged(element){
    
	var current_price = $(element).closest(".fields").find(".item-price").toNumber({
		region: 'es-CL'
	}).val();
	var new_price = current_price * $(element).val();
	$(element).closest(".fields").find(".item-total").val(new_price);
	updatePrices();

}

function itemPriceChanged(element) {
    
	var current_quantity = $(element).closest(".fields").find(".item-quantity").val();
	var new_total = current_quantity * $(element).toNumber({
		region: 'es-CL'
	}).val();
	if(isNaN(new_total)){
      new_total = 0;
    }
	$(element).closest(".fields").find(".item-total").val(new_total);
    updatePrices();

}

function sumNetPrice() {
    var sum = 0;
    $(".item-total").each(function() {
		value = parseInt($(this).toNumber({
            region: 'es-CL'
        }).val());

 		if(isNaN(value)){
			sum += 0;
		}
		else {
			sum += value;
		}
	});
    $(".netPrice").val(sum);
}

function sumTotalPrice(){
    var netPrice = parseInt($(".netPrice").toNumber({
        region: 'es-CL'
    }).val());
    var taxPrice = parseInt($(".taxPrice").toNumber({
        region: 'es-CL'
    }).val());
    var sum = netPrice + taxPrice;
    $(".totalPrice").val(sum);
}

function calcIva() {
    var iva = 0;
    var netPrice = parseInt($(".netPrice").toNumber({
        region: 'es-CL'
    }).val());
    if($("#invoice_taxed").attr('checked')){
        iva =  Math.round(netPrice * 1.19) - netPrice;
    }
    $(".taxPrice").val(iva)
}

function updatePrices() {
    sumNetPrice();
    calcIva();
    sumTotalPrice();
    formatInvoicePrice();
}

function formatInvoicePrice() {
    $('.item-price').formatCurrency({
        region: 'es-CL',
        roundToDecimalPlace: 0
    });
    $('.item-total').formatCurrency({
        region: 'es-CL',
        roundToDecimalPlace: 0
    });
    $('.priceNumber').formatCurrency({
        region: 'es-CL',
        roundToDecimalPlace: 0
    });
    $('.netPrice').formatCurrency({
        region: 'es-CL',
        roundToDecimalPlace: 0
    });
    $('.totalPrice').formatCurrency({
        region: 'es-CL',
        roundToDecimalPlace: 0
    });
    $('.taxPrice').formatCurrency({
        region: 'es-CL',
        roundToDecimalPlace: 0
    });
}

function enableIVA() {
    updatePrices();
}

function display_add_comment() {
    $("#add_comment_link").hide();
    $("#add_comment").show("slow");
}

function display_add_customer_details() {
	$("#add_customer_details_link").hide();
    $("#customer_optional").show("slow");
}

function display_invoice_filter() {
	$("#invoice_filter").hide().show();
	$("#show_filter").html("<a onclick='hide_invoice_filter(); return false;' href='#'>Ocultar Búsqueda</a>")
}

function hide_invoice_filter() {
	$("#invoice_filter").hide();
	$("#show_filter").html("<a onclick='display_invoice_filter(); return false;' href='#'>Búsqueda Avanzada</a>");
}


$().ready(function() {
	
	$.datepicker.setDefaults($.datepicker.regional['es']);
	$( ".datepicker" ).datepicker();
	
	if($("input#customer_name_invoice").val() == ""){
		$("input#customer_name_invoice").val("Escriba el nombre...");
		var disable_input = true;
		$("input#customer_name_invoice").focus(function(){
			if(disable_input){
		  		$("input#customer_name_invoice").val("")
				disable_input = false;
			}
		});
	}
	
	if($("input#search_number_equals").val() == ""){
				$("input#search_number_equals").val("Número de factura...");
				
				$("input#search_number_equals").focus(function(){
				  		$("input#search_number_equals").val("")
				});
			}
	
    $("input#customer_name_invoice, input#search_customer_name_like").autocomplete_for_customer("/customers/search.json",{
        dataType: "json",
		width: 400,
        parse: function(data) {
            return $.map(data, function(row){
                
                return {
                    data: row.customer,
                    id: row.customer.id,
                    value: row.customer.name,
                    rut: row.customer.rut
                }
            });
        },
        formatItem: function(item) {
            return item.name
        }
    });

    $("input#customer_name_invoice, input#search_customer_name_like").result(function(event, data, formatted) {
        $("#"+this.id).val(data.name);
        $("input#invoice_customer_id,input#search_customer_id_equals").val(data.id);
    });

    $('input[id$="_rut"]').Rut({
        on_error: function(){
            alert('Rut incorrecto');
            $('input[id$="_rut"]').val("");
        }
    });

	$(".notice").fadeOut(9000);


    formatInvoicePrice();

});

function number_to_currency(number, options) {
  try {
    var options   = options || {};
    var precision = options["precision"] || 0;
    var unit      = options["unit"] || "$";
    var separator = precision > 0 ? options["separator"] || "," : "";
    var delimiter = options["delimiter"] || ".";
  
    var parts = parseFloat(number).toFixed(precision).split(',');
    return unit + number_with_delimiter(parts[0], delimiter);
  } catch(e) {
    return e
  }
}

function number_with_delimiter(number, delimiter, separator) {
  try {
    var delimiter = delimiter || ",";
    var separator = separator || ".";
    
    var parts = number.toString().split('.');
    parts[0] = parts[0].replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1" + delimiter);
    return parts.join(separator);
  } catch(e) {
    return number
  }
}
