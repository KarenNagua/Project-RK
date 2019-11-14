//This script contains functions that can be used in many places
$('.collapsible').collapsible();

//Click event on btn_menu
$(document).ready(function(){
    $('.btn_menu').click(function(){
        let bloque = $(this).attr('data-tg');
        if( ! $('#'+bloque).hasClass('active') ) {

            $('.menu_item_li').removeClass('active');
            $(this).addClass('active');

            $('.caja_contenido_principal').removeClass('active');
            $('#'+bloque).addClass('active');

            switch( bloque ) {
                case 'caja_usuarios':
                    $('#input_busqueda').attr({
                        'data-collection': 'person',
                        'data-campo': 'names|surnames',
                        'data-lista': 'lista_usuarios',
                    });
                    break;
                case 'caja_categorias':
                    $('#input_busqueda').attr({
                        'data-collection': 'category',
                        'data-campo': 'label',
                        'data-lista': 'lista_categorias',
                    });
                    break;
                case 'caja_sitios':
                    $('#input_busqueda').attr({
                        'data-collection': 'site',
                        'data-campo': 'label',
                        'data-lista': 'lista_sitios',
                    });
                    break;
            }
        }
    });

    $('#input_busqueda').keyup(function(){
        let d = {
            tag: 'input_busqueda',
            collection: $(this).attr('data-collection'),
            campo: $(this).attr('data-campo'),
            lista_ui:  $(this).attr('data-lista'),
            search: $(this).val(),
        };
        
        if( d.collection.length > 0 && d.campo.length > 0 && d.lista_ui.length > 0) {
            if( d.collection === 'person' ) {
                searchPersonByData(d);
            } else if( d.collection === 'category' ) {
                searchCategoryByData(d);
            } else if( d.collection === 'site' ) {
                searchSiteByData(d);
            }
        }
    });

    $('#btn_logout').click(function(){
        logout();
    });
});

//Search in the list of person and return results, if the search parameter is equal to 'todo' all the filed are inserted in the list view
function searchPersonByData( { tag, collection, campo, lista_ui, search } ) {
    $('#lista_usuarios').empty();

    person_list.forEach( p => {
        let a = null;
        account_list.forEach( c => {
            if( c.data.id_person === p.id ) {
                a = c;
            }
        });

        if( a !== null ) {
            let html  = '<div class="item item_lista_usuarios" data-account="'+a.id+'" data-person="'+p.id+'">';
                html += '	<i class="fas fa-user"></i>';
                html += '	<span id="user_item_'+p.id+'">'+ p.data.surnames.split(' ')[0] + ' ' + p.data.names.split(' ')[0] +'</span>';
                html += '</div>';
            
            let name = p.data.names + ' ' + p.data.surnames;

            if( search.toLowerCase().includes('todo') || search.length === 0 || name.toLowerCase().includes(search.toLowerCase()) ) {
                $('#lista_usuarios').append(html);
            }

        }
    });
}

//Search in the list of categories and return results, if the search parameter is equal to 'todo' all the filed are inserted in the list view
function searchCategoryByData( { tag, collection, campo, lista_ui, search } ) {
    $('#lista_categorias').empty();
    category_list.forEach( c => {
        let html  = '<div class="item item_lista_categoria" data-category="'+c.id+'">';
			html += '	<i class="fas fa-tag"></i>';
			html += '	<span id="label_item_'+c.id+'">'+ c.data.label+'</span>';
            html += '</div>';

        if( search.toLowerCase().includes('todo') || search.length === 0 || c.data.label.toLowerCase().includes(search.toLowerCase()) ) {
            $('#lista_categorias').append(html);
        }
    });
}

//Search in the list of sites and return results, if the search parameter is equal to 'todo' all the filed are inserted in the list view
function searchSiteByData( { tag, collection, campo, lista_ui, search } ) {
    $('#lista_sitios').empty();
    site_list.forEach( s => {
        let html  = '<div class="item item_lista_sitios" data-site="'+s.id+'">';
            html += '	<i class="fas fa-map-marker-alt"></i>';
            html += '	<span id="sitio_item_'+s.id+'">'+ s.data.label +'</span>';
            html += '</div>';	

        if( search.toLowerCase().includes('todo') || search.length === 0 || s.data.label.toLowerCase().includes(search.toLowerCase()) ) {
            $('#lista_sitios').append(html);
        }
    });
}


//Set Data of actual user in the UI
function setDataUserInUI(){
    person_list.forEach( p => {
        if( account.data.id_person === p.id ) {
            $('#url_picture').attr('src', p.data.picture);
            $('#user_name').text(p.data.names.split(' ')[0] + ' ' + p.data.surnames.split(' ')[0]);
        }
    });    
}

//Set Info Counters
function setContadores(){
    let total_admin = 0;
    let total_users = 0;
    let categories = category_list.length;
    let sites = site_list.length;

    account_list.forEach( a => {
        if(a.data.type === 0) {
            total_admin += 1;
        } else {
            total_users += 1;
        }
    });

    $('#total_admins').text(total_admin);
    $('#total_users').text(total_users);
    $('#total_categorias').text(categories);
    $('#total_sitios').text(sites);

}

//Make an Ajax request and return data through a callback
function peticionAjaxServidor(d, type, dataType, url, cb) {
    $.ajax({
        url: url,
        type: type,
        cache: false,
        dataType: dataType,
        data: {
            data: JSON.stringify(d)
        }
    }).done(function (d) {
        cb(d);
    }).fail(function (jqXHR, textStatus, errorThrown) {
        cb({code: -2, data: ''});
    });
}

//Change the state of a button to active or no-active
function changeButtonState(id, state) {
    if( state ) {
        $('#' + id).addClass('noactive');
    } else {
        $('#' + id).removeClass('noactive');
    }
}

//Change the state of the loader, to visible or hidden
function changeStateLoader(id, state){
    if( state ) {
        $('#' + id).addClass('visible');
    } else {
        $('#' + id).removeClass('visible');
    }
}

//Set the value of a field and its attrs data-account data-person placeholder data-target (tipo|campo)
function setCamposTipoA(id, value, dc, dp, dt){
    $('#'+id).val(value);
    $('#'+id).attr('placeholder', value);
    $('#'+id).attr('data-account', dc);
    $('#'+id).attr('data-person', dp);
    $('#'+id).attr('data-target', dt);
}

//Set the value of a field and its attrs data-category placeholder data-target (tipo|campo)
function setCamposTipoB(id, value, did, dt){
    $('#'+id).val(value);
    $('#'+id).attr('placeholder', value);
    $('#'+id).attr('data-id', did);
    $('#'+id).attr('data-target', dt);
}

//Search for an object in an array, according to the value of the variable 'filed' and return it
function searchAndReturnObject(list, field, value) {
    let obj = null;
    list.forEach( o => {
        if (o[field] === value) {
            obj = o;
        }
    });
    return obj;
}

//Update Filed value on the list sent as parameter
function updateValueFieldOnTheList( list, field_a, condition, field_b, value, type){
    list.forEach( a => {
        if( a[field_a] === condition) {
            if( type === 0 ) {
                a.data[field_b] = value;
            } else if( type === 1 ) {
                a.data[field_b] = parseInt(value);
            } else if( type === 2 || type === 3) {
                a.data[field_b.split('.')[0]][field_b.split('.')[1]] = value;
            }
        }
    });
} 