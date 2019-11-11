const functions = require('firebase-functions');
const express = require('express');
const http = require('http');
const cors = require('cors');
const bodyParser = require('body-parser');
const { admin, db, auth } = require('./config/firebase_config');
const router = express.Router();
const moment = require('moment-timezone');

const app = express();
app.set('views', './views')
    .set('view engine', 'hbs')
    .use(cors({ origin: true })) // Automatically allow cross-origin requests
    .use(bodyParser.json())
    .use(bodyParser.urlencoded({
        extended: true
    }))
    .set('trust proxy', 1)
    .use((req, res, next) => {
        res.setHeader('Access-Control-Allow-Origin', '*');
        res.setHeader('Access-Control-Allow-Methods', 'GET, POST');
        res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');
        res.setHeader('Access-Control-Allow-Credentials', false);
        next();
    });

var hbs = require('hbs');
hbs.registerHelper('json', obj => {
	return new hbs.SafeString(JSON.stringify(obj))
});

hbs.registerHelper('comparar',  (v1, operator, v2, options) => {
    switch (operator) {
        case '==':
            return (v1 === v2) ? options.fn(this) : options.inverse(this);
        case '===':
            return (v1 === v2) ? options.fn(this) : options.inverse(this);
        case '!=':
            return (v1 !== v2) ? options.fn(this) : options.inverse(this);
        case '!==':
            return (v1 !== v2) ? options.fn(this) : options.inverse(this);
        case '<':
            return (v1 < v2) ? options.fn(this) : options.inverse(this);
        case '<=':
            return (v1 <= v2) ? options.fn(this) : options.inverse(this);
        case '>':
            return (v1 > v2) ? options.fn(this) : options.inverse(this);
        case '>=':
            return (v1 >= v2) ? options.fn(this) : options.inverse(this);
        case '&&':
            return (v1 && v2) ? options.fn(this) : options.inverse(this);
        case '||':
            return (v1 || v2) ? options.fn(this) : options.inverse(this);
        default:
            return options.inverse(this);
    }
});

/*Routes*/
var auth_routes = require('./routes/auth_routes');
app.use('/auth', auth_routes);

var admin_routes = require('./routes/admin_routes');
app.use('/admin', admin_routes);

/*var cliente_routes = require('./routes/cliente_routes');
app.use('/cliente', cliente_routes);

var newspoth_routes = require('./routes/newspoth_routes');
app.use('/newspoth', newspoth_routes);*/


/*Update code*/

router.get('/', (req, res) => {
    res.render('index');
});

app.use(router);

exports.app = functions.https.onRequest(app);