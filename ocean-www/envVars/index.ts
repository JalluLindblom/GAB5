
require("dotenv").config();

import { getBoolEnvVar, getStringEnvVar, getIntEnvVar } from './utils';



export const sessionSecret = getStringEnvVar(
    "SESSION_SECRET",
    "please-change-me-for-production");



export const mongoDatabaseUrl = getStringEnvVar(
    "MONGO_DATABASE_URL",
    "mongodb://localhost");
export const mongoDatabaseName = getStringEnvVar(
    "MONGO_DATABASE_NAME",
    "");
export const mongoDatabaseAuthSource = getStringEnvVar(
    "MONGO_DATABASE_AUTH_SOURCE",
    "");
export const mongoDatabaseUsername = getStringEnvVar(
    "MONGO_DATABASE_USERNAME",
    "");
export const mongoDatabasePassword = getStringEnvVar(
    "MONGO_DATABASE_PASSWORD",
    "");



export const indexUsername = getStringEnvVar(
    "INDEX_USERNAME",
    "");
export const indexPassword = getStringEnvVar(
    "INDEX_PASSWORD",
    "");

export const userUsername = getStringEnvVar(
    "USER_USERNAME",
    "");
export const userPassword = getStringEnvVar(
    "USER_PASSWORD",
    "");

export const demoUsername = getStringEnvVar(
    "DEMO_USERNAME",
    "");
export const demoPassword = getStringEnvVar(
    "DEMO_PASSWORD",
    "");

export const adminUsername = getStringEnvVar(
    "ADMIN_USERNAME",
    "");
export const adminPassword = getStringEnvVar(
    "ADMIN_PASSWORD",
    "");

export const gameApiUsername = getStringEnvVar(
    "GAME_API_USERNAME",
    "");
export const gameApiPassword = getStringEnvVar(
    "GAME_API_PASSWORD",
    "");
