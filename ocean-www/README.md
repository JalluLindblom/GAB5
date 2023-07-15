# ocean-www

This is a [Node.js](https://nodejs.org) based server. The full MERN stack consists of:

| | |
| - | - |
| [MongoDB](https://www.mongodb.com) | Database |
| [Express](https://expressjs.com/) | Web framework |
| [React](https://react.dev/) | Front-end library |
| [Node.js](https://nodejs.org) | Back-end runtime |

In order to run the server, first install Node.js and npm. Then run `npm install` at the project root directory to install dependencies.

## Environment variables

Before you can launch the server, you need to set up the environment by creating a file called `.env` at the project root, where you'll need to define the following variables:

```ini
# Session secret token.
APP_SESSION_SECRET=""

# MongoDB database access authentication.
APP_MONGO_DATABASE_URL=""
APP_MONGO_DATABASE_NAME=""
APP_MONGO_DATABASE_AUTH_SOURCE=""
APP_MONGO_DATABASE_USERNAME=""
APP_MONGO_DATABASE_PASSWORD=""

# Authentication for accessing the / (index) page. Leave blank for no authentication.
APP_INDEX_USERNAME=""
APP_INDEX_PASSWORD=""

# Authentication for accessing the /game page. Leave blank for no authentication.
APP_USER_USERNAME=""
APP_USER_PASSWORD=""

# Authentication for accessing the /demo page. Leave blank for no authentication.
APP_DEMO_USERNAME=""
APP_DEMO_PASSWORD=""

# Authentication for accessing the /admin page. Leave blank for no authentication.
APP_ADMIN_USERNAME=""
APP_ADMIN_PASSWORD=""

# Authentication for accessing the API.
APP_GAME_API_USERNAME=""
APP_GAME_API_PASSWORD=""
```

## Commands

At the *project root directory*, you may run any of the following commands:

| Command | Description |
| - | - |
| `npm run dev` | This launches a local development server that will hot-reload and restart when changes are being made. Once you've got this running, you can open `http://localhost:8000/` to access the web page. |
| `npm run build` | This builds a production build of the server into the `/dist` directory. That directory is the one that you would deliver to your server machine. |

At the *build root directory*, you may run any of the following commands:

| Command | Description |
| - | - |
| `npm start` | Launches the server. |
| `npm run getData <filename>` | Fetches all trial data from the database and saves it into the given output file in CSV format. |
| `npm run getUsers <filename>` | Fetches all registered user IDs from the database and saves it to a the given output text file. |
