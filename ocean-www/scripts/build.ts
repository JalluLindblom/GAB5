
import util from 'util';
import cp from 'child_process';

import webpack from 'webpack';
import rimraf from 'rimraf';
import fse from 'fs-extra';

import webpackConf from '../webpack.config';
import * as sassBuild from './sassBuild';
import * as bi from '../misc/buildInfo';

const exec = util.promisify(cp.exec);

async function clearDirectory(directory: string) {
    console.log(`Deleting all files in the directory "${directory}"...`);
    await util.promisify(rimraf)(directory);
    console.log('Deleted');
}

async function compileSass() {
    const production = true;
    await sassBuild.compile(production);
}

async function compileTypescript() {
    console.log('Compiling server side TypeScript...');
    await exec('tsc');
    console.log('Typescript compilation complete.');
}

async function compileBundledJs() {

    return new Promise<void>((resolve, reject) => {
        const compileCallback = (err: Error|null|undefined, stats: webpack.Stats|undefined) => {
            if (err) {
                console.error(err);
                return reject();
            }
            if (!stats) {
                console.error('Webpack compilation failed for unknown reason (no stats object).');
                return reject();
            }
            console.log(stats.toString({ chunks: false, colors: true }));
            console.log('Bundling complete.');
            return resolve();
        }
    
        console.log('Compiling bundled JS for browser...');
        webpackConf.mode = 'production';
        webpack(webpackConf).run(compileCallback);
    });
}

async function writeBuildInfo() {

    console.log('Writing build info...');

    const buildInfo = {
        date: Date.now(),
    };
    await bi.writeToFile(buildInfo, './dist/buildInfo.json');
}

async function copyFileOrDirectoryToBuild(srcName: string, destName: string = srcName) {
    const src = './' + srcName;
    const dest = './dist/' + destName;
    console.log(`Copying ${src} to ${dest}...`);
    await fse.copy(src, dest);
    console.log('Copied.');
}

async function main() {

    console.log('Starting build...');

    await clearDirectory('./dist');
    await clearDirectory('./public/bundles');

    await compileSass();
    await compileTypescript();
    await compileBundledJs();
    
    await copyFileOrDirectoryToBuild('public');
    await copyFileOrDirectoryToBuild('views');
    await copyFileOrDirectoryToBuild('package.json');
    await copyFileOrDirectoryToBuild('package-lock.json');
    await copyFileOrDirectoryToBuild('.app.yaml', 'app.yaml');
    await copyFileOrDirectoryToBuild('.env');
    
    await copyFileOrDirectoryToBuild('game');
    await copyFileOrDirectoryToBuild('demo');

    await writeBuildInfo();

    console.log('Build done.');
}

main().catch(console.error);
