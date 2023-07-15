
import express, { Request, Response } from 'express';
import { format } from '@fast-csv/format';

import { adminAuth } from '../middleware/auth';
import { Validator, validateAll } from '../misc/validator';
import * as db from '../db';
import Trial, { ITrialDocument } from '../db/models/trial';

const router = express.Router();

router.use(adminAuth);

// router.get('/trials', async (req: Request, res: Response) => {

//     const filters: any = {};
//     for (const key in req.query) {
//         if (key === 'format') {
//             continue;
//         }
//         const fullKey = (key === 'date') ? key : ('data.' + key);
//         filters[fullKey] = { $regex: req.query[key] };
//     }

//     switch (req.query.format) {
        
//         case 'csv': {
//             const headers = await db.trial.getHeaders();
//             const transformer = (trial: ITrialDocument) => {
//                 const obj: any = {
//                     'date': trial.date,
//                 };
//                 for (const header of headers) {
//                     obj[header] = objectGetValueRecursively(trial.data, '.', header);
//                 }
//                 return obj;
//             };
//             res.setHeader('Content-disposition', 'attachment; filename=trials.csv');
//             res.setHeader('Content-Type', 'text/csv');
//             // @ts-ignore
//             const csvStream = format({ headers: true, delimiter: ';' }).transform(transformer);
//             return Trial.find(filters).cursor().pipe(csvStream).pipe(res);
//         }
        
//         default: case 'json': {
//             const trials = await Trial.find(filters).exec();
//             if (!trials) {
//                 return res.status(500).end();
//             }
//             res.setHeader('Content-disposition', 'attachment; filename=trials.json');
//             return res.json(trials);
//         }
//     }
// });

// router.get('/trial-data-headers', async (req: Request, res: Response) => {
//     return res.json(await db.trial.getHeaders());
// });

// router.get('/users', async (req: Request, res: Response) => {
//     const users = await db.user.getAll();
//     if (!users) {
//         return res.status(500).end();
//     }
//     return res.json(users);
// });

// router.delete('/users', async (req: Request, res: Response) => {

//     const userIds: string[] = req.body.userIds;
//     if (!new Validator(userIds, 'userIds').required().isArray().validate()) {
//         return res.status(400).end();
//     }

//     if (!validateAll(userIds.map(userId => new Validator(userId, 'userId').required().isString()))) {
//         return res.status(400).end();
//     }

//     console.log(userIds);

//     for (const userId of userIds) {
//         const numDeleted = await db.user.deleteByUserId(userId);
//         console.log(`Deleted ${numDeleted || 0} user(s) with user ID "${userId}".`);
//     }
//     return res.sendStatus(200);
// });

// router.get('/users/:userId', async (req: Request, res: Response) => {

//     const user = await db.user.findByUserId(req.params.userId);
//     if (!user) {
//         return res.status(404).end();
//     }
//     return res.json(user);
// });

router.post('/users', async (req: Request, res: Response) => {

    const userIds: string[] = req.body.userIds;
    if (!new Validator(userIds, 'userIds').required().isArray().validate()) {
        return res.status(400).end();
    }

    if (!validateAll(userIds.map(userId => new Validator(userId, 'userId').required().isString()))) {
        return res.status(400).end();
    }

    const createdUsers = [];
    for (const userId of userIds) {
        // Check if a user with the given ID exists already.
        if (await db.user.findByUserId(userId)) {
            continue;
        }
        const user = await db.user.create(userId, new Date(Date.now()));
        createdUsers.push(user);
    }
    
    return res.json(createdUsers);
});

export default router;


function objectGetKeysRecursively(object: any, prefix: string, outKeys: string[])
{
    for (const key in object) {
        var value = object[key];
        if (typeof(value) === 'object') {
            objectGetKeysRecursively(value, key + '.', outKeys);
        }
        else {
            outKeys.push(prefix + key);
        }
    }
}

function objectGetValueRecursively(object: any, separator: string, name: string): any
{
    const nameParts = name.split(separator);
    for (let i = 0; i < nameParts.length; ++i) {
        const namePart = nameParts[i];
        if (i == nameParts.length - 1) {
            return object[namePart];
        }
        else {
            object = object[namePart];
        }
    }
}
