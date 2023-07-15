
require('dotenv').config();
require('express-async-errors');

import path from 'path';

import "express-async-errors";
import express, { Request, Response, NextFunction, ErrorRequestHandler } from 'express';
import bodyParser from "body-parser";
import helmet from 'helmet';
import session from 'express-session';
import cookieParser from "cookie-parser";
import cors from 'cors';

import * as db from './db';
import * as ev from './envVars';
import mainRouter from './routers/mainRouter'
import { indexAuth } from './middleware/auth';

import * as bi from './misc/buildInfo';

async function main() {

    console.log(`Starting up at ${new Date()}...`);

    const dev = process.env.NODE_ENV?.trim() === 'development';

    const buildInfo = await bi.readFromFile('./buildInfo.json');
    if (buildInfo === undefined) {
        throw new Error('Failed to read build info.');
    }

    const app = express();

    if (dev) {
        // Allow a locally run GameMaker project to access the server.
        app.use(cors({
            origin: [
                'http://127.0.0.1:51264',
            ],
        }));
    }

    app.use(helmet({
        contentSecurityPolicy: {
            directives: {
                defaultSrc: ["'self'"],
                fontSrc: ["'self'", 'https://fonts.gstatic.com'],
                styleSrc: ["'self'", 'https://fonts.googleapis.com'],
                scriptSrc: ["'self'", 'https://ajax.googleapis.com', "'unsafe-inline'"] // need to allow inline scripts for GameMaker HTML5 export to work
            }
        }
    }));

    if (ev.sessionSecret.trim() === '') {
        throw new Error('Environment variable for session secret is required.');
    }
    
    app.use(cookieParser(ev.sessionSecret));

    if (dev) {
        app.use((req, res, next) => {
            console.log(req.method + " " + req.url);
            return next();
        });
    }

    app.use(async (req: Request, res: Response, next: NextFunction) => {
        
        res.locals.viewsDir = path.join(__dirname, 'views');
        res.locals.buildDate = buildInfo.date;

        return next();
    });
    
    app.use(indexAuth, express.static(path.join(__dirname, 'public')));

    app.set('view engine', 'ejs');

    // Set up body parsers.
    app.use(bodyParser.json());
    app.use(bodyParser.text());
    app.use(bodyParser.urlencoded({ extended: true }));

    app.use(session({
        secret: ev.sessionSecret,
        resave: false,
        saveUninitialized: false
    }));

    app.use(mainRouter);

    app.use(async (err: ErrorRequestHandler, req: Request, res: Response, next: NextFunction) => {
        console.error(err);
        return res.status(500).send('500');
    });

    await db.init();

    const port = process.env.PORT || 8000;
    app.listen(port, () => {
        console.log(`Listening on port ${port}.`);
    });

}

main().catch(console.error);
