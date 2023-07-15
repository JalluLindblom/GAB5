
import path from 'path';

import express, { ErrorRequestHandler, NextFunction, Request, Response } from 'express';

import { renderContent } from './renderer';
import gameApiRouter from './gameApiRouter';
import adminApiRouter from './adminApiRouter';
import { indexAuth, userAuth, demoAuth, adminAuth } from '../middleware/auth';

const router = express.Router();

router.use(async (req: Request, res: Response, next: NextFunction) => {
    res.locals.title = '';
    return next();
});

router.use('/api/game', gameApiRouter);
router.use('/api/admin', adminApiRouter);

router.get('/', indexAuth, async (req: Request, res: Response) => {
    res.locals.title = 'index';
    return renderContent(res, '/content/index');
});

router.get('/admin', adminAuth, async (req: Request, res: Response) => {
    res.locals.title = 'admin';
    return renderContent(res, '/content/admin-index');
});
// router.get('/admin/trials', adminAuth, async (req: Request, res: Response) => {
//     res.locals.title = 'admin/trials';
//     return renderContent(res, '/content/admin-trials');
// });
router.get('/admin/users', adminAuth, async (req: Request, res: Response) => {
    res.locals.title = 'admin/users';
    return renderContent(res, '/content/admin-users');
});

router.use('/game', userAuth, express.static(path.join(__dirname, '../game/OceanProto')));
router.use('/demo', demoAuth, express.static(path.join(__dirname, '../demo/OceanProto')));

router.use(async (req: Request, res: Response) => {
    res.status(404);
    return renderContent(res, '/content/404');
});
router.use(async (err: ErrorRequestHandler, req: Request, res: Response, next: NextFunction) => {
    console.error(err);
    res.status(500);
    return renderContent(res, '/content/500.ejs');
});

export default router;
