const url_createUser = 'https://us-central1-project-f1d8f.cloudfunctions.net/createUserInAuth';
//logout();
/*
* ADD USERs TO THE LIST VIEW - UI
*/
function addUsersToListView() {
	$('#lista_usuarios').empty();
	account_list.forEach( a => {
		person_list.forEach( p => {
			if( a.data.id_person === p.id ) {
				let html  = '<div class="item item_lista_usuarios" data-account="'+a.id+'" data-person="'+p.id+'">';
					html += '	<i class="fas fa-user"></i>';
					html += '	<span>'+ p.data.surnames.split(' ')[0] + ' ' + p.data.names.split(' ')[0]+'</span>';
					html += '</div>';	
				$('#lista_usuarios').append(html);
			}
		});
	});
}
	
var status_proceso = false;
//Detect click on items from users list
$('body').on('click','.item_lista_usuarios',function(){
	if( !status_proceso ) {
		if( ! $(this).hasClass('active') ) {
			//Change status process and loader
			status_proceso = true;
			changeStateLoader('loader_info_usuario', true);
			//Add background color to the selected list item
			$('.item_lista_usuarios').removeClass('active');
			$(this).addClass('active');

			let id_account = $(this).attr('data-account');
			let id_person = $(this).attr('data-person');

			let { type, state, email, recovery_email } = searchAndReturnObject(account_list, 'id', id_account).data;
			let { names, surnames, birthday, cellphone  } = searchAndReturnObject(person_list, 'id', id_person).data;

			//Clean UI Filed
			$('#form_info_usuario').find('input').val('');
			$('#form_info_usuario').find('select').val('none');

			//Set Data to UI
			setCamposTipoA('names', names, id_account, id_person, '0|names');
			setCamposTipoA('surnames', surnames, id_account, id_person, '0|surnames');
			setCamposTipoA('birthday', birthday, id_account, id_person, '0|birthday');
			setCamposTipoA('cellphone', cellphone, id_account, id_person, '0|cellphone');
			setCamposTipoA('type', type, id_account, id_person, '1|type');
			setCamposTipoA('state', state, id_account, id_person, '1|state');
			setCamposTipoA('email', email, id_account, id_person, '0|email');
			setCamposTipoA('recovery_email', recovery_email, id_account, id_person, '0|recovery_email');


			//Change status process and loader
			status_proceso = false;
			changeStateLoader('loader_info_usuario', false);
		}
	} else {
		M.toast({html: 'Existe otro proceso en ejecución'});
	}
});

function updateFieldSelectOrInput(tag){
	if( !status_proceso ) {
		//Change status process and loader
		status_proceso = true;
		changeStateLoader('loader_info_usuario', true);

		let d = {
			id_tag: tag.attr('id'),
			id_account: tag.attr('data-account'),
			id_person: tag.attr('data-person'),
			tipo: parseInt(tag.attr('data-target').split('|')[0]),
			campo: tag.attr('data-target').split('|')[1],
			new: tag.val(),
			old: tag.attr('placeholder'),
		};

		peticionAjaxServidor(d, 'POST', 'json', '/admin/updatePersonOrAccountField', data => {
			if( data.code === 0 ) {
				setCamposTipoA(d.id_tag, d.new, d.id_account, d.id_person, d.tipo+'|'+d.campo);
			} else {
				$('#'+d.id_tag).val(d.old);
			}
			M.toast({html: data.data});

			//Change status process and loader
			status_proceso = false;
			changeStateLoader('loader_info_usuario', false);
		});
	} else {
		M.toast({html: 'Existe otro proceso en ejecución'});
	}
}

//Detect Enter in input with class input_usuario_info to send data to be updated in Firestore
$('.input_usuario_info').keypress(function(e){
    if(e.which ==13){
		if( $(this).val().length > 0 ) {
			if($(this).val() !== $(this).attr('placeholder')){
				updateFieldSelectOrInput($(this));
			}
		} else {
			$(this).val( $(this).attr('placeholder') );
		}
	}
});

$('.select_usuario_info').change(function(){
	if($(this).val() !== $(this).attr('placeholder')){
		updateFieldSelectOrInput($(this));
	}
});

function addUserToListViewUI({person,account}) {
	let html  = '<div class="item item_lista_usuarios" data-account="'+account.id+'" data-person="'+person.id+'">';
		html += '	<i class="fas fa-user"></i>';
		html += '	<span>'+ person.data.surnames.split(' ')[0] + ' ' + person.data.names.split(' ')[0]+'</span>';
		html += '</div>';	
	$('#lista_usuarios').append(html);
}

//Detect Click evento on button with id registrar_usuario
$('#registrar_usuario').click(function(){
    if ( checkFields() ) {
		changeButtonState('registrar_usuario', true);
		changeStateLoader('loader_reg_usuario', true);

		let info = {
			person: getDataPerson(),
			account: getDataAccount(),
		};
	
        //Uplaod picture to Firebase Storage
		uploadFileToStorage( $('#reg_picture'), (code, urlORsms) => {
            if( code === 0 ) {
				//File URl in storage is data
				info.person.picture = urlORsms;
				peticionAjaxServidor(info, 'POST', 'json', '/admin/registerUserAdminOrFinal', data => {
					console.log(data);
					if( data.code === 0 ) {
						person_list.push(data.person);
						account_list.push(data.account);
						addUserToListViewUI(data);

						//Clean all the fileds
						$('#form_registro_usuario').find('input').val('');
						$('#form_registro_usuario').find('select').val('none');
					}
					M.toast({html: data.data});

					//Enable button and hide loader
					changeButtonState('registrar_usuario', false);
					changeStateLoader('loader_reg_usuario', false);
				});
            } else {
                M.toast({ html: urlORsms });
            }
        });
    }
});

function uploadFileToStorage( file, cb ){
    let name = file[0].files[0].name;
    storage.child('pictures/'+name).put(file[0].files[0])
        .then( snapshot => {
            return snapshot.ref.getDownloadURL();
        }).then( url => {
            return cb(0, url);
        }).catch(function(error) {
			console.log(error);
            return cb(-1, 'Error al subir el archivo a storage');
        });  
}

function checkFields(){
    let status = false;

    if( ! ($('#reg_names').val().length > 0) ) {
        M.toast({html: 'Error, debes ingresar los nombres de la persona'});
    } else if( ! ($('#reg_surnames').val().length > 0) ) {
        M.toast({html: 'Error, debes ingresar los apellidos de la persona'});
    } else if( ! ($('#reg_birthday').val().length > 0) ) {
        M.toast({html: 'Error, debes ingresar la fecha de nacimiento'});
    } else if( ! ($('#reg_cellphone').val().length > 0) ) {
        M.toast({html: 'Error, debes ingresar el celular'});
    } else if( ! ($('#reg_picture')[0].files && $('#reg_picture')[0].files[0]) ) {
        M.toast({html: 'Error, debes seleccionar la foto de perfil'});
    } else if( ! ($('#reg_type').val() !== null) ) {
        M.toast({html: 'Error, seleccionar el tipo de usuario a registrar'});
    } else if( ! ($('#reg_email').val().length > 0) ) {
        M.toast({html: 'Error, debes ingresar el email'});
    } else if( ! ($('#reg_password').val().length > 0) ) {
        M.toast({html: 'Error, debes ingresar la contraseña'});
    } else {
        status = true;
    }

    return status;
}

function getDataPerson() {
    return {
        names: $('#reg_names').val(),
        surnames: $('#reg_surnames').val(),
        birthday: $('#reg_birthday').val(),
        cellphone: $('#reg_cellphone').val(),
        picture: '',
        register_date: ''
    };
}

function getDataAccount(){
    return {
        id_person: '',
        email: $('#reg_email').val(),
        recovery_email: $('#reg_recovery_email').val(),
        password: $('#reg_password').val(),
		type: parseInt($('#reg_type').val()),
		state: 0,
    };
}
