
import express, { Request, Response } from 'express';

import { gameApiAuth } from '../middleware/auth';
import { Validator, validateAll } from '../misc/validator';
import * as db from '../db';

const router = express.Router();

router.use(gameApiAuth);

router.post('/trials', async (req: Request, res: Response) => {

    const trial = req.body;

    if (!validateAll([
        new Validator(trial, 'trial').required().isObject(),
    ])) {
        return res.status(400).send();
    }

    const date = new Date(Date.now());
    
    const result = await db.trial.create(date, trial);
    if (!result) {
        return res.status(500).send();
    }
    return res.status(200).send();
});

router.get('/levelsPerUser/:userId', async (req: Request, res: Response) => {
    const trials = await db.trial.findAllByUserId(req.params.userId);
    if (!trials) {
        return res.status(500).end();
    }
    return res.json(trials.map(trial => trial.data.level_info.filename));
});

// router.get('/trialsPerUser/:userId', async (req: Request, res: Response) => {
//     const fields = new Set(req.query.fields?.toString().split(","));
//     const trials = await db.trial.findAllByUserId(req.params.userId);
//     if (!trials) {
//         return res.status(500).end();
//     }
//     return res.json(trials.map(trial => {
//         const data: any = {};
//         for (const field in trial.data) {
//             if (fields.has(field)) {
//                 data[field] = trial.data[field];
//             }
//         }
//         return data;
//     }));
// });

router.get('/totalScorePerUser/:userId', async (req: Request, res: Response) => {
    const { userId } = req.params;
    const totalScore = await db.trial.getTotalTrialScoreOfUser(userId);
    return res.json({
        user_id: userId,
        total_score: totalScore,
    });
});

router.get('/userExists/:userId', async (req: Request, res: Response) => {
    const user = await db.user.findByUserId(req.params.userId);
    const exists = (user !== null && user !== undefined);
    return res.send(exists ? '1' : '0');
});

export default router;
