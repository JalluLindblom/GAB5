
import mongoose, { Schema } from 'mongoose';

export interface ITrial {
    date: Date,
    data: any,
}
export interface ITrialDocument extends ITrial, mongoose.Document {}

const trialSchema = new mongoose.Schema({
    date: {
        type: Date,
        required: true,
    },
    data: {
        type: Schema.Types.Mixed,
        required: true,
    },
});

export default mongoose.model<ITrial>('trial', trialSchema);
