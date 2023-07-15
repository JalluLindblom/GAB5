
import mongoose from 'mongoose';

export interface IUser {
    userId: string,
    creationDate: Date,
}
export interface IUserDocument extends IUser, mongoose.Document {}

const userSchema = new mongoose.Schema({
    userId: {
        type: String,
        required: true,
        unique: true,
    },
    creationDate: {
        type: Date,
        required: true,
    }
});

export default mongoose.model<IUser>('user', userSchema);
