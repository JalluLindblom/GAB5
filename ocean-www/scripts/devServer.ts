
import nodemon from 'nodemon';

import * as bi from '../misc/buildInfo';

async function main() {

    const buildInfo = {
        date: Date.now(),
    };
    await bi.writeToFile(buildInfo, './buildInfo.json');

    const settings: nodemon.Settings = {
        script: 'index.ts',
        ignore: ['scripts/*']
    };

    nodemon(settings);

    nodemon.on('restart', (files) =>
        console.log(`Restarting due to file changes:\n${files?.map(f => '  - ' + f).join('\n')}`
    ));
}

main().catch(console.error);
