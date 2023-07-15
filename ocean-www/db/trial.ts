
import mongoose from 'mongoose';

import Trial, { ITrial } from "./models/trial";

export async function create(date: Date, data: any): Promise<ITrial> {
    const trial = new Trial({ date, data });
    return await trial.save();
}

export async function createMany(trials: ITrial[])
{
    return await Trial.insertMany(trials);
}

export async function get(trialId: string|mongoose.Types.ObjectId): Promise<ITrial|null> {
    if (!mongoose.isValidObjectId(trialId)) {
        return null;
    }
    return await Trial.findById(trialId).exec();
}

export async function getAll(): Promise<ITrial[]> {
    return await Trial.find().exec();
}

export async function findAllByUserId(userId: string): Promise<ITrial[]> {
    return await Trial.find({ 'data.user_id': userId }).exec();
}

export async function getTotalTrialScoreOfUser(userId: string): Promise<number> {
    // TODO: Using aggregation would be more efficient.
    const trials = await Trial.find({ 'data.user_id': userId });
    const totalScore = trials.reduce(
        (prevValue, currentValue) => (prevValue + (currentValue.data.result.trial_score || 0)),
        0
    );
    return totalScore;
}

export async function getHeaders(): Promise<string[]> {
    
    // Here we should return all the headers that appear at least once in any of the trials
    // currently in the database. To do that, we'd have to iterate through all trial documents
    // but that's redundant work to do every time... So let's just return a cached, static version instead.

    return [
        'user_id',
        'config_version',
        'game_version',
        'seed',
        'level_info.play_order',
        'level_info.num_monsters',
        'level_info.num_food',
        'level_info.num_humans',
        'level_info.num_humans_h',
        'level_info.num_humans_0',
        'level_info.num_humans_1',
        'level_info.num_humans_2',
        'level_info.num_humans_3',
        'level_info.num_humans_4',
        'level_info.num_humans_5',
        'level_info.num_humans_6',
        'level_info.num_humans_7',
        'level_info.num_humans_8',
        'level_info.num_humans_9',
        'level_info.num_sand',
        'level_info.filename',
        'traits.extraversion',
        'traits.agreeableness',
        'traits.openness',
        'traits.neuroticism',
        'traits.conscientiousness',
        'result.time_left',
        'result.num_monsters_remaining',
        'result.num_food_remaining',
        'result.num_humans_remaining',
        'result.energy_remaining',
        'result.type',
        'result.trial_score',
    ];

    // Here's the code to actually iterate through all trial documents and get the headers (commented out):

    // const headersSet: Set<string> = new Set();
    // for await (const trial of Trial.find()) {
    //     const trialHeaders: string[] = [];
    //     objectGetKeysRecursively(trial.data, '', trialHeaders);
    //     for (const header of trialHeaders) {
    //         headersSet.add(header);
    //     }
    // }
    // return res.json(Array.from(headersSet));
}
