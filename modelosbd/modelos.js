//Modelo Persona
var person = {
    id: String, //Firebase creates it automatically, but I put it here just as a reference
    names: String,
    surnames: String,
    birthday: String,
    cellphone: String,
    picture: String, //Profile picture URL
    register_date: TimeStamp, //Type of Date, which is used in Firebase Firestore
};

//Account Model
var account = {
    id: String, //Firebase creates it automatically, but I put it here just as a reference
    id_person: String,
    email: String,
    recovery_email: String,
    password: String,
    type: Number, //1 user is an admin, 0 user is a final user 
};

//Category Model
var category = {
    id: String, //Firebase creates it automatically, but I put it here just as a reference
    label: String, //Category name
    register_date: TimeStamp,
};

//Places Model
var site = {
    id: String, //Firebase creates it automatically, but I put it here just as a reference
    id_person: String, //ID of admin user who created it
    id_category: String, //ID of the category
    register_date: TimeStamp, //Type of Date, which is used in Firebase Firestore
    label: String, //Name or label of the site
    description: String, //Description of the site, max value.lenght 300
    address: {
        main: String,
        secondary: String,
        reference: String,
    },
    coordinates: geopoint, //Type Of Firebase Firestore for coordinates
};

//My Sites Model
var mysites = {
    id: String, //Firebase creates it automatically, but I put it here just as a reference
    id_site: String,
    id_person: String,
    register_date: TimeStamp,
};
