//Por rapidez aun no valida si hay usuario logeado o no


/*
* Realtime Updates in collection category
*/
$('#lista_categorias').empty();
db.collection("category")
    .onSnapshot(function(snapshot) {
        snapshot.docChanges().forEach(function(change) {
            if (change.type === "added") {
                //Every time the page is loaded, all documents in the collection are loade here one by one, and this allow to charge content to the UI
                let doc = change.doc;
                let html  = '<div id="tag_'+doc.id+'" class="tag item_categoria" data-id="'+doc.id+'">';
                    html += '   <i class="fas fa-tag"></i>';
                    html += '   <span id="tag_span_'+doc.id+'">'+doc.data().label+'</span>';
                    html += '</div>';
                $('#lista_categorias').append(html);
            }
            if (change.type === "modified") {
                let doc = change.doc;
                $('#tag_span_'+doc.id).text(doc.data().label);
            }
            if (change.type === "removed") {
                console.log("Removed city: ", change.doc.data());
            }
        });
    });

/*
* Detect Click event in the elements with class tag
*/

function setDataValueToForm(id, value, dataid, datacollection, datacampo, pl){
    $('#'+id).val(value);
    $('#'+id).attr('data-id', dataid);
    $('#'+id).attr('data-collection', datacollection);
    $('#'+id).attr('data-campo', datacampo);
    $('#'+id).attr('placeholder', pl);
};

$('body').on('click', '.tag', function(){
    let id = $(this).attr('data-id');
    
    if (id.length > 0 && !$(this).hasClass('active')) {
        $('.tag').removeClass('active');
        $(this).addClass('active');
        db.collection('category').doc(id).get()
            .then( data => {
                if(data) {
                    console.log(data.data());
                    $('#data_form_categoria').find('input').val('');
                    $('#data_form_categoria').find('input').attr('data-id','');
                    $('#data_form_categoria').find('input').attr('data-collection','');
                    $('#data_form_categoria').find('input').attr('data-campo','');
                    
                    setDataValueToForm('categoria_label', data.data().label, data.id, 'category', '0|label', data.data().label);
                    setDataValueToForm('categoria_date',  data.data().register_date.toDate(), data.id, '0|category', 'register_date', data.data().register_date.toDate());
                    
                } else {
                    M.toast({html: 'Error, al obtener la iformación'});
                }
            }).catch( error => {
                M.toast({html: 'Error, no se pudo completar la operación'});
            });
    }
});

$('.input_form').keypress(function (e) {
    if(e.which ==13){ 
        if($(this).val().length > 0) {
            let d = {
                valor: $(this).val(),
                id: $(this).attr('data-id'),
                collection: $(this).attr('data-collection'),
                tipo: $(this).attr('data-campo').split('|')[0],
                campo: $(this).attr('data-campo').split('|')[1],
                old: $(this).attr('placeholder'),
            };

            db.collection(d.collection).doc(d.id).get()
                .then( doc => {
                    let data = doc.data();
                    if ( d.tipo === '0' ) {
                        data[d.campo] = d.valor;
                    }
                    console.log(data);
                    return db.collection(d.collection).doc(d.id).set(data);
                }).then( res => {
                    M.toast({html: 'Campo actualizado'});
                }).catch( error => {
                    M.toast({html: 'Error, no se pudo completar la operación'});
                });

        } else {
            $(this).val($(this).attr('placeholder'));
        }
    }
});

$('#reg_categoria').click(function(){
    let label = $('#reg_categoria_label').val();

    if( label.length > 0 ) {
        let d = {
            label: label,
            register_date: firebase.firestore.FieldValue.serverTimestamp()
        };
        db.collection('category').add(d)
            .then( docRef => {
                M.toast({html: 'Categoría registrada'});
                $('#reg_categoria_label').val('');
            }).catch( error => {
                console.log(error);
                M.toast({html: 'Error, no se pudo completar la operación'});
            });
    } else {
        M.toast({html: 'Error, existen campos incompletos'});
    }
});