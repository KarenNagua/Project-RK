const url_createUser = 'https://us-central1-project-f1d8f.cloudfunctions.net/createUserInAuth';

/*
* Realtime Updates in collection category
*/
$('#lista_usuarios').empty();
db.collection("account").orderBy('type')
    .onSnapshot(function(snapshot) {
        snapshot.docChanges().forEach(function(change) {
            if (change.type === "added") {
                //Every time the page is loaded, all documents in the collection are loade here one by one, and this allow to charge content to the UI
				let account = change.doc;
				getDataUserByAccountId(account.data().id_person, doc => {
					let person = doc;
					let html  = '<div class="item item_lista_usuarios" data-account="'+account.id+'" data-person="'+person.id+'">';
						html += '	<i class="fas fa-user"></i>';
						html += '	<span>'+ person.data().surnames.split(' ')[0] + ' ' + person.data().names.split(' ')[0]+'</span>';
						html += '</div>';
					
					$('#lista_usuarios').append(html);
				});
            }
            if (change.type === "modified") {
                let doc = change.doc;
            }
            if (change.type === "removed") {
                
            }
        });
	});
	
var status_items = false;
//Detect click on items from users list
$('body').on('click','.item_lista_usuarios',function(){
	if( !status_items ) {
		if( ! $(this).hasClass('active') ) {
			//Change status process and loader
			status_items = true;
			changeStateLoader('loader_info_usuario', true);


			$('.item_lista_usuarios').removeClass('active');
			$(this).addClass('active');

			let id_account = $(this).attr('data-account');
			let id_person = $(this).attr('data-person');

			let a = db.collection('account').doc(id_account).get();
			let b = db.collection('person').doc(id_person).get();
			Promise.all([a,b]).then( data => {
				let account = data[0];
				let person = data[1];
				
				//Clean UI Filed
				$('#form_info_usuario').find('input').val('');
				$('#form_info_usuario').find('select').val('none');

				//Set Data to UI
				setCamposTipoA('names', person.data().names, account.id, person.id, '0|names');
				setCamposTipoA('surnames', person.data().surnames, account.id, person.id, '0|surnames');
				setCamposTipoA('birthday', person.data().birthday, account.id, person.id, '0|birthday');
				setCamposTipoA('cellphone', person.data().cellphone, account.id, person.id, '0|cellphone');
				setCamposTipoA('type', account.data().type, account.id, person.id, '0|type');
				setCamposTipoA('email', account.data().email, account.id, person.id, '0|email');
				setCamposTipoA('recovery_email', account.data().recovery_email, account.id, person.id, '0|recovery_email');


				//Change status process and loader
				status_items = false;
				changeStateLoader('loader_info_usuario', false);
				
			}).catch( error => {
				$('.item_lista_usuarios').removeClass('active');
				M.toast({html: 'Error al obtener la información del usuario'});
			});
		}
	} else {
		M.toast({html: 'Existe otro proceso en ejecución'});
	}
});

function getDataUserByAccountId(id, cb) { 
	db.collection('person').doc(id).get().then( doc => {
		return cb(doc);
	}).catch( error => {
		return cb(null);
	}); 
}

//Detect Enter in input with class input_usuario_info to send data to be updated in Firestore
$('.input_usuario_info').keypress(function (e) {
    if(e.which ==13){
		if( $(this).val().length > 0 ) {
			if( !status_items ) {
				//Change status process and loader
				status_items = true;
				changeStateLoader('loader_info_usuario', true);

				let d = {
					id_tag: $(this).attr('id'),
					id_account: $(this).attr('data-account'),
					id_person: $(this).attr('data-person'),
					tipo: parseInt($(this).attr('data-target').split('|')[0]),
					campo: $(this).attr('data-target').split('|')[1],
					new: $(this).val(),
					old: $(this).attr('placeholder'),
				};

				let collection = ( d.campo === 'type' ) ? 'account' : 'person';
				let id_doc = ( d.campo === 'type' ) ? d.id_account : d.id_person;

				db.collection(collection).doc(id_doc).get()
					.then( doc => {
						let aux = doc.data();
						if( d.tipo === 0 ) {
							aux[ d.campo ] = d.new;
						}
						status_items = false;
						changeStateLoader('loader_info_usuario', false);
						return db.collection(collection).doc(id_doc).set(aux);
					}).then( res => {

						return M.toast({html: 'Campo "'+d.campo+'" actualizado con éxito'});
					}).catch( error => {
						M.toast({ html: 'Error, no se pudo completar la operación' });
					});
			} else {
				M.toast({html: 'Existe otro proceso en ejecución'});
			}
		} else {
			$(this).val( $(this).attr('placeholder') );
		}
	}
});


//Detect Click evento on button with id registrar_usuario
$('#registrar_usuario').click(function(){
    if ( checkFields() ) {
		changeButtonState('registrar_usuario', true);
		changeStateLoader('loader_reg_usuario', true);

        let persona = getDataPerson();
        let cuenta = getDataAccount();

        //Uplaod picture to Firebase Storage
        uploadFileToStorage( $('#reg_picture'), (code, urlORsms) => {
            if( code === 0 ) {
				//File URl in storage is data
				persona.picture = urlORsms;
				peticionAjaxServidor({email: cuenta.email, password: cuenta.password}, 'POST', 'json', url_createUser, d => {
					if( d.code === 0 ) {
						db.collection('person').add(persona)
							.then( docRef => {
								cuenta.id_person = docRef.id;
								return db.collection('account').doc(d.uid).set(cuenta);
							}).then( doc => {
								//Clean all the fileds
								$('#form_registro_usuario').find('input').val('');
								$('#form_registro_usuario').find('select').val('none');
								//Enable button and hide loader
								changeButtonState('registrar_usuario', false);
								changeStateLoader('loader_reg_usuario', false);
								//Show status message
								M.toast({ html: 'Usuario registrado con éxito' });
							}).catch( error => {
								M.toast({ html: 'Error, no se pudo completar la operación' });
							});
					} else {
						M.toast({ html: d.data });
					}
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
        register_date: firebase.firestore.FieldValue.serverTimestamp()
    };
}

function getDataAccount(){
    return {
        id_person: '',
        email: $('#reg_email').val(),
        recovery_email: $('#reg_recovery_email').val(),
        password: $('#reg_password').val(),
        type: parseInt($('#reg_type').val()),
    };
}
