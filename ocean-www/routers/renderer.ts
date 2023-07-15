
import express, { ErrorRequestHandler, NextFunction, Request, Response } from 'express';

export function renderContent(res: Response, contentPath: string): Response {
    res.render('main-template.ejs', {
        contentPath: contentPath
    });
    return res;
}
