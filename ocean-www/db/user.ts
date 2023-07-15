
import mongoose from 'mongoose';

import User, { IUser } from "./models/user";

export async function create(userId: string, creationDate: Date): Promise<IUser> {
    const trial = new User({ userId, creationDate });
    return await trial.save();
}

export async function get(id: string|mongoose.Types.ObjectId): Promise<IUser|null> {
    if (!mongoose.isValidObjectId(id)) {
        return null;
    }
    return await User.findById(id).exec();
}

export async function getAll(): Promise<IUser[]> {
    return await User.find().sort({'creationDate': -1}).exec();
}

export async function findByUserId(userId: string): Promise<IUser|null> {
    return await User.findOne({ userId }).exec();
}

/// Returns the number of users deleted or null if failed to delete any.
export async function deleteByUserId(userId: string): Promise<number|null> {
    const val = await User.deleteOne({ userId }).exec();
    return val.acknowledged ? val.deletedCount : null;
}

export const userIdPattern = '^\\w+$';
