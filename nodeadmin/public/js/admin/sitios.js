/*
* ADD USERs TO THE LIST VIEW - UI
*/
function addSitesToListView() {
	$('#lista_sitios').empty();
	site_list.forEach( s => {
		let html  = '<div class="item item_lista_sitios" data-site="'+s.id+'">';
			html += '	<i class="fas fa-map-marker-alt"></i>';
			html += '	<span id="sitio_item_'+s.id+'">'+ s.data.label +'</span>';
			html += '</div>';	
		$('#lista_sitios').append(html);
	});
}
	
var status_proceso_c = false;
//Detect click on items from users list
$('body').on('click','.item_lista_sitios',function(){
	if( !status_proceso_c ) {
		if( ! $(this).hasClass('active') ) {
			//Change status process and loader
			status_proceso_c = true;
			changeStateLoader('loader_info_sitios', true);
			//Add background color to the selected list item
			$('.item_lista_sitios').removeClass('active');
			$(this).addClass('active');

			let id_site = $(this).attr('data-site');
			let { register_date, label, id_person, id_category, description, coordinates, address, estado } = searchAndReturnObject(site_list, 'id', id_site).data;

			//Clean UI Filed
			$('#form_info_sitios').find('input').val('');
			$('#form_info_sitios').find('select').val('none');

			console.log(address.main);
			console.log($('#address.main').attr('id'));

			//Set Data to UI
			setCamposTipoB('site_label', label, id_site, '0|label');
			setCamposTipoB('id_category', id_category, id_site, '0|id_category');
			setCamposTipoB('description', description, id_site, '0|description');
			setCamposTipoB('address_main', address.main, id_site, '2|address.main');
			setCamposTipoB('address_secondary', address.secondary, id_site, '2|address.secondary');
			setCamposTipoB('address_reference', address.reference, id_site, '2|address.reference');
			setCamposTipoB('coordinates_lat', coordinates.lat, id_site, '3|coordinates.lat');
			setCamposTipoB('coordinates_lng', coordinates.lng, id_site, '3|coordinates.lng');
			setCamposTipoB('estado', estado, id_site, '1|estado');

			let tmp = new firebase.firestore.Timestamp(register_date._seconds, register_date._nanoseconds);
			setCamposTipoB('site_register_date', tmp.toDate(), id_site, '0|register_date');


			//Change status process and loader
			status_proceso_c = false;
			changeStateLoader('loader_info_sitios', false);
		}
	} else {
		M.toast({html: 'Existe otro proceso en ejecución'});
	}
});

function updateFieldSelectOrInputC(tag){
	if( !status_proceso_c ) {
		//Change status process and loader
		status_proceso_c = true;
		changeStateLoader('loader_info_sitios', true);

		let d = {
			id_tag: tag.attr('id'),
			id_site: tag.attr('data-id'),
			tipo: parseInt(tag.attr('data-target').split('|')[0]),
			campo: tag.attr('data-target').split('|')[1],
			new: tag.val(),
			old: tag.attr('placeholder'),
		};

		peticionAjaxServidor(d, 'POST', 'json', '/admin/updateSiteField', data => {
			if( data.code === 0 ) {
				setCamposTipoB(d.id_tag, d.new, d.id_site, d.tipo+'|'+d.campo);
				updateValueFieldOnTheList( site_list, 'id', d.id_site, d.campo, d.new, d.tipo);

				if( d.campo === 'label') {
					//user_item_
					let s = searchAndReturnObject(site_list, 'id', d.id_site);
					$('#sitio_item_'+s.id).text(s.data.label);
				}
			} else {
				$('#'+d.id_tag).val(d.old);
			}
			M.toast({html: data.data});

			//Change status process and loader
			status_proceso_c = false;
			changeStateLoader('loader_info_sitios', false);
		});
	} else {
		M.toast({html: 'Existe otro proceso en ejecución'});
	}
}

//Detect Enter in input with class input_usuario_info to send data to be updated in Firestore
$('.input_sitio_info').keypress(function(e){
    if(e.which ==13){
		if( $(this).val().length > 0 ) {
			if($(this).val() !== $(this).attr('placeholder')){
				updateFieldSelectOrInputC($(this));
			}
		} else {
			$(this).val( $(this).attr('placeholder') );
		}
	}
});

$('.select_sitio_info').change(function(){
	if($(this).val() !== $(this).attr('placeholder')){
		updateFieldSelectOrInputA($(this));
	}
});

function addSiteToListViewUI(s) {
	let html  = '<div class="item item_lista_sitios" data-site="'+s.id+'">';
		html += '	<i class="fas fa-map-marker-alt"></i>';
		html += '	<span id="sitio_item_'+s.id+'">'+ s.data.label +'</span>';
		html += '</div>';	
	$('#lista_sitios').append(html);
}

//Detect Click evento on button with id registrar_usuario
$('#registrar_sitio').click(function(){
    if ( checkFieldsC() ) {
		changeButtonState('registrar_sitio', true);
		changeStateLoader('loader_reg_sitio', true);

		let d = getDataSite();

		peticionAjaxServidor(d, 'POST', 'json', '/admin/registerSite', data => {
			console.log(data);
			if( data.code === 0 ) {
				site_list.push(data.sitio);
				addSiteToListViewUI(data.sitio);

				//Clean all the fileds
				$('#form_registro_sitio').find('input').val('');
				$('#form_registro_sitio').find('select').val('none');

				//Set info of the four counters
				setContadores();
			}
			M.toast({html: data.data});

			//Enable button and hide loader
			changeButtonState('registrar_sitio', false);
			changeStateLoader('loader_reg_sitio', false);
		});
    }
});


function checkFieldsC(){
	let status = false;
	
    if( ! ($('#reg_site_label').val().length > 0) ) {
        M.toast({html: 'Error, debes ingresar el nombre del sitio'});
    } else if( ! ($('#reg_id_category').val() !== null) ) {
        M.toast({html: 'Error, debes seleccionar la categoría'});
    } else if( ! ($('#reg_description').val().length > 0) ) {
        M.toast({html: 'Error, debes ingresar la descripción del lugar'});
    } else if( ! ($('#reg_address_main').val().length > 0) ) {
        M.toast({html: 'Error, debes ingresar la calle principal'});
    } else if( ! ($('#reg_address_secondary').val().length > 0 ) ){
        M.toast({html: 'Error, debes ingresar la calle secundaria'});
    } else if( ! ($('#reg_address_reference').val().length > 0) ) {
        M.toast({html: 'Error, debes ingresar la referencia del sitio'});
    } else if( ! ($('#reg_coordinates_lat').val().length > 0) ) {
        M.toast({html: 'Error, debes ingresar la latitud'});
    } else if( ! ($('#reg_coordinates_lng').val().length > 0) ) {
        M.toast({html: 'Error, debes ingresar la longitud'});
    } else {
        status = true;
    }

    return status;
}

function getDataSite() {
    return {
		label: $('#reg_site_label').val(),
		id_category: $('#reg_id_category').val(),
		id_person: account.data.id_person,
		description: $('#reg_description').val(),
		address: {
			main: $('#reg_address_main').val(),
			secondary: $('#reg_address_secondary').val(),
			reference: $('#reg_address_reference').val(),
		},
		coordinates: {
			lat: parseFloat($('#reg_coordinates_lat').val()),
			lng: parseFloat($('#reg_coordinates_lng').val()),
		},
		register_date: '',
		estado: 0, //0 = Active, -1 Deleted, 1 Not showing
    };
}
