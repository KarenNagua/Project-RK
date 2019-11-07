//Detect Click evento on button with id registrar_usuario
$('#registrar_usuario').click(function(){
    if ( checkFields() ) {
        changeButtonState('registrar_usuario', true);

        let persona = getDataPerson();
        let cuenta = getDataAccount();

        console.log(persona);
        console.log(cuenta);

        //Uplaod picture to Firebase Storage
        

        //Save data Person to Firestore
        /*db.collection('person').add(persona)
            .then( docRef => {
                console.log(docRef.id);
            }).cath( error => {
                console.log(error);
            });*/
    }
});

function uploadFileToStorage( file ){

}

function changeButtonState(id, state) {
    if( state ) {
        $('#' + id).addClass('noactive');
    } else {
        $('#' + id).removeClass('noactive');
    }
}

function checkFields(){
    let status = false;

    console.log($('#reg_tipo').val());

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
        id_persona: '',
        email: $('#reg_email').val(),
        recovery_email: $('#reg_recovery_email').val(),
        password: $('#reg_password').val(),
        type: $('#reg_type').val(),
    };
}
