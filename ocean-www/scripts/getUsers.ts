
import * as db from '../db';
import fsp from 'fs/promises';

export async function getUsersToFile(outFilename: string)
{
    await db.init();

    const users = await db.user.getAll();
    const userIds = users.map(user => user.userId).join('\n');
    await fsp.writeFile(outFilename, userIds);
}

async function main() {

    const outFilename = process.argv[2];
    await getUsersToFile(outFilename);

    console.log('');
    console.log('All done!');

    process.exit();

}

main().catch(console.error);
