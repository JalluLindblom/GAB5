
import * as db from '../db';
import Trial, { ITrialDocument } from '../db/models/trial';
import { format } from '@fast-csv/format';
import fs from 'fs';

export async function getDataAsCsv(outFilename: string)
{
    await db.init();

    const headers = await db.trial.getHeaders();
    const transformer = (trial: ITrialDocument) => {
        const obj: any = {
            'date': trial.date,
        };
        for (const header of headers) {
            obj[header] = objectGetValueRecursively(trial.data, '.', header);
        }
        return obj;
    };
    // @ts-ignore
    const csvStream = format({ headers: true, delimiter: ';' }).transform(transformer);
    const filters = {};
    Trial.find(filters).cursor().pipe(csvStream);
    const outStream = fs.createWriteStream(outFilename);
    csvStream.pipe(outStream);
    await new Promise(fulfill => csvStream.on('finish', fulfill));
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

async function main() {

    const outFilename = process.argv[2];
    await getDataAsCsv(outFilename);

    console.log('');
    console.log('All done!');

}

main().catch(console.error);
