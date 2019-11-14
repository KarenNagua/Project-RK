/*
* ADD USERs TO THE LIST VIEW - UI
*/
function setCategoriesToListView() {
	$('#lista_categorias').empty();
	category_list.forEach( category => {
		let html  = '<div class="item item_lista_categoria" data-category="'+category.id+'">';
			html += '	<i class="fas fa-tag"></i>';
			html += '	<span id="label_item_'+category.id+'">'+ category.data.label+'</span>';
			html += '</div>';	
		$('#lista_categorias').append(html);
	});
}
	
var status_proceso_b = false;
//Detect click on items from users list
$('body').on('click','.item_lista_categoria',function(){
	if( !status_proceso_b ) {
		if( ! $(this).hasClass('active') ) {
			//Change status process and loader
			status_proceso_b = true;
			changeStateLoader('loader_info_categoria', true);
			//Add background color to the selected list item
			$('.item_lista_categoria').removeClass('active');
			$(this).addClass('active');

			let id_category = $(this).attr('data-category');
			let { label, register_date } = searchAndReturnObject(category_list, 'id', id_category).data;

			//Clean UI Filed
			$('#form_info_categoria').find('input').val('');

			//Set Data to UI
			setCamposTipoB('label', label, id_category, '0|label');
			let tmp = new firebase.firestore.Timestamp(register_date._seconds, register_date._nanoseconds);
			setCamposTipoA('register_date', tmp.toDate(), id_category, '0|register_date');

			//Change status process and loader
			status_proceso_b = false;
			changeStateLoader('loader_info_categoria', false);
		}
	} else {
		M.toast({html: 'Existe otro proceso en ejecución'});
	}
});

function updateFieldSelectOrInputB(tag){
	if( !status_proceso_b ) {
		//Change status process and loader
		status_proceso_b = true;
		changeStateLoader('loader_info_categoria', true);

		let d = {
			id_tag: tag.attr('id'),
			id_category: tag.attr('data-id'),
			tipo: parseInt(tag.attr('data-target').split('|')[0]),
			campo: tag.attr('data-target').split('|')[1],
			new: tag.val(),
			old: tag.attr('placeholder'),
		};

		peticionAjaxServidor(d, 'POST', 'json', '/admin/updateCategoryField', data => {
			if( data.code === 0 ) {
				setCamposTipoB(d.id_tag, d.new, d.id_category, d.tipo+'|'+d.campo);
				updateValueFieldOnTheList( category_list, 'id', d.id_category, d.campo, d.new, d.tipo);

				$('#label_item_'+d.id_category).text(d.new);
			} else {
				$('#'+d.id_tag).val(d.old);
			}
			M.toast({html: data.data});

			//Change status process and loader
			status_proceso_b = false;
			changeStateLoader('loader_info_categoria', false);
		});
	} else {
		M.toast({html: 'Existe otro proceso en ejecución'});
	}
}

//Detect Enter in input with class input_usuario_info to send data to be updated in Firestore
$('.input_categoria_info').keypress(function(e){
    if(e.which == 13){
		if( $(this).val().length > 0 ) {
			if($(this).val() !== $(this).attr('placeholder')){
				updateFieldSelectOrInputB($(this));
			}
		} else {
			$(this).val( $(this).attr('placeholder') );
		}
	}
});

function addCategoryToListViewUI(category) {
	let html  = '<div class="item item_lista_categoria" data-category="'+category.id+'">';
		html += '	<i class="fas fa-tag"></i>';
		html += '	<span id="label_item_'+category.id+'">'+ category.data.label+'</span>';
		html += '</div>';	
	$('#lista_categorias').append(html);
}

//Detect Click evento on button with id registrar_usuario
$('#registrar_categoria').click(function(){
    if ( checkFieldsB() ) {
		changeButtonState('registrar_categoria', true);
		changeStateLoader('loader_reg_categoria', true);

		let category = getDataCategory();
		peticionAjaxServidor(category, 'POST', 'json', '/admin/registerCategory', data => {
			console.log(data);
			if( data.code === 0 ) {
				category_list.push(data.category);
				addCategoryToListViewUI(data.category);

				//Clean all the fileds
				$('#form_registro_categoria').find('input').val('');

				//Set info of the four counters
				setContadores();
			}
			M.toast({html: data.data});

			//Enable button and hide loader
			changeButtonState('registrar_categoria', false);
			changeStateLoader('loader_reg_categoria', false);
		});
    }
});

function checkFieldsB(){
    let status = false;

    if( ! ($('#reg_label').val().length > 0) ) {
        M.toast({html: 'Error, debes ingresar el nombre de la categoría'});
    } else {
        status = true;
    }

    return status;
}

function getDataCategory() {
    return {
        label: $('#reg_label').val(),
        register_date: ''
    };
}
