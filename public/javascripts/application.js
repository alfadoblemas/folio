// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function remove_fields(link) {
    $(link).prev("input[type=hidden]").val("1");
    $(link).parent().siblings(".item-total").children().val(0);
    $(link).closest(".fields").hide();
    sumNetPrice();
    formatInvoicePrice();
}

function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var id = 0;
    $(".item-total").children().each(id++);
    var regexp = new RegExp(id+"_" + association, "g");
    //$(link).parent().before.before(content.replace(regexp, new_id));
    $('#newInvoiceItems').append(content)
}


function itemQuantityChanged(element){

    var regexp = /\d+/;
    id= element.id.match(regexp);
    var currentPrice = $("#invoice_invoice_items_attributes_"+id+"_price").toNumber({
        region: 'es-CL'
    }).val();
    var newPrice = currentPrice * element.value;
    $("#invoice_invoice_items_attributes_"+id+"_total").val(newPrice);
    updatePrices();
}

function itemPriceChanged(element) {

    var regexp = /\d+/;
    id= element.id.match(regexp);
    var current_quantity = $("#invoice_invoice_items_attributes_"+id+"_quantity").val();
    var new_total = current_quantity * $(element).toNumber({
        region: 'es-CL'
    }).val();
    $("#invoice_invoice_items_attributes_"+id+"_total").val(new_total);
    
    updatePrices()
}

function sumNetPrice() {
    var sum = 0;
    $(".item-total").each(function() {
        sum += parseInt($(this).toNumber({
            region: 'es-CL'
        }).val());
    });
    if(isNaN(sum)){
      sum = 0;
    }
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

$().ready(function() {
	
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
	
	if($("input#search").val() == ""){
		$("input#search").val("Número de factura...");
		var disable_input = true;
		$("input#search").focus(function(){
			if(disable_input){
		  		$("input#search").val("")
				disable_input = false;
			}
		});
	}
	
    $("input#customer_name_invoice").autocomplete("/customers/search.json",{
        dataType: "json",
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

    $("input#customer_name_invoice").result(function(event, data, formatted) {
        $("input#customer_name_invoice").val(data.name);
        $("input#invoice_customer_id").val(data.id);
    });

    $('#customer_rut').Rut({
        on_error: function(){
            alert('Rut incorrecto');
            $('input#customer_rut').val("");
        }
    });

    formatInvoicePrice();
});
