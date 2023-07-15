
/*
An interface for querying and updating the MongoDB database.
*/

import mongoose from 'mongoose';

import * as ev from '../envVars';

export async function init(): Promise<void> {

    if (ev.mongoDatabaseUrl.trim() === '') {
        throw new Error('Environment variable for Mongo database URL is required.');
    }
    if (ev.mongoDatabaseName.trim() === '') {
        throw new Error('Environment variable for Mongo database name is required.');
    }
    if (ev.mongoDatabaseUsername.trim() === '') {
        throw new Error('Environment variable for Mongo database username is required.');
    }
    if (ev.mongoDatabaseName.trim() === '') {
        throw new Error('Environment variable for Mongo database password is required.');
    }

    const options: mongoose.ConnectOptions = {
        dbName: ev.mongoDatabaseName,
        user: ev.mongoDatabaseUsername,
        pass: ev.mongoDatabasePassword
    };
    if (ev.mongoDatabaseAuthSource !== "") {
        options.authSource = ev.mongoDatabaseAuthSource;
    }

    mongoose.connection.on('error', (error) => {
        console.error(`Failed to connect to MongoDB database: ${error}`);
    });
    mongoose.connection.once('open', () => {
        console.log('Connected to MongoDB database.');
    });

    const url = ev.mongoDatabaseUrl;
    console.log(`Connecting to MongoDB database at: ${url} ...`);

    await mongoose.connect(url, options);
}

/**
 * Checks if the given ID is in a form that could be a valid ID.
 * @param id
 * @return True iff the id is valid.
 */
export function isValidId(id: any): boolean {
    return mongoose.isValidObjectId(id);
}

export * as trial from './trial';
export * as user from './user';
