
import fs from 'fs';
const fsp = fs.promises;

export interface IBuildInfo {
    date: number,
}

export async function writeToFile(buildInfo: IBuildInfo, filename: string) {
    await fsp.writeFile(filename, JSON.stringify(buildInfo));
}

export async function readFromFile(filename: string): Promise<IBuildInfo|undefined> {
    const obj = JSON.parse((await fsp.readFile(filename)).toString());
    return {
        date: obj.date,
    };
}
