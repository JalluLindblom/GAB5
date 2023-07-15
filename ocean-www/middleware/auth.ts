
import { NextFunction, Request, Response } from 'express';
import basicAuth from 'express-basic-auth';
import * as ev from "../envVars";

function createAuth(username: string, password: string) {

    if (username === '' && password === '') {
        // Return a passthrough handler.
        return (req: Request, res: Response, next: NextFunction) => {
            return next();
        };
    }

    const authorizer = (givenUsername: string, givenPassword: string) => {
        const userMatches: any = basicAuth.safeCompare(givenUsername, username);
        const passwordMatches: any = basicAuth.safeCompare(givenPassword, password);
        // Intentional bitwise operator
        return (userMatches & passwordMatches) ? true : false;
    };
    return basicAuth({
        authorizer: authorizer,
        challenge: true,
    });
}

export const indexAuth = createAuth(ev.indexUsername, ev.indexPassword);
export const userAuth = createAuth(ev.userUsername, ev.userPassword);
export const demoAuth = createAuth(ev.demoUsername, ev.demoPassword);
export const adminAuth = createAuth(ev.adminUsername, ev.adminPassword);
export const gameApiAuth = createAuth(ev.gameApiUsername, ev.gameApiPassword);
