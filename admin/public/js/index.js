function changeStateButtonLgin(state){
    if( state ) {
        $('#btn_login').addClass('noactive');
    } else {
        $('#btn_login').removeClass('noactive');
    }
}

$('.input_form').keypress(function (e) {
    if(e.which ==13){ 
        $('#btn_login').click();
    }
});

$('#btn_login').click(function(){
    let d = {
        email: $('#email').val(),
        password: $('#password').val()
    };

    if( d.email.length > 0  && d.password.length > 0 ) {
        changeStateButtonLgin(true);

        //Login with auth of Firebase, using email and password method
        auth.signInWithEmailAndPassword(d.email, d.password).catch(function(error) {
            changeStateButtonLgin(false);
            M.toast({html: error.message});
        });
    } else {
        M.toast({html: 'Error, existen campos incompletos'});
    }
});




