
import util from 'util';

import webpack from 'webpack';
const filewatcher = require('filewatcher');
import rimraf from 'rimraf';

import webpackConf from '../webpack.config';
import * as sassBuild from './sassBuild';

async function clearOutputDir() {
    const outputDir = './public/bundles';
    console.log(`Deleting all files in the output directory "${outputDir}"...`);
    await util.promisify(rimraf)(outputDir);
    console.log('Deleted');
}

async function watchSass() {

    try {
        const production = false;
        await sassBuild.compile(production);
    }
    catch (err) {
        console.error(err);
    }

    const watcher = filewatcher();
    console.log(`Sass compilation automation is watching "${sassBuild.inputDirectory}" for file changes...`);
    watcher.add(sassBuild.inputDirectory);
    watcher.on('change', (file: string) => {
        if (file === sassBuild.inputDirectory) {
            console.log(`A file was modified in "${file}".`);
            const production = false;
            sassBuild.compile(production).catch(console.error);
        }
    });
}

function watchWebpack() {
    
    const compileCallback = (err: Error|null|undefined, stats: webpack.Stats|undefined) => {
        if (err) {
            console.error(err);
            return;
        }
        if (!stats) {
            console.error('Webpack compilation failed for unknown reason (no stats object).');
            return;
        }
        console.log(stats.toString({ chunks: true, colors: true }));
    }

    console.log('Webpack is watching for file changes...');
    webpackConf.mode = 'development';
    webpackConf.devtool = 'source-map';
    webpack(webpackConf).watch({}, compileCallback);
}

async function main() {

    await clearOutputDir();

    watchWebpack();
    watchSass();
}

main().catch(console.error);
