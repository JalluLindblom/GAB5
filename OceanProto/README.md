# OceanProto

This is a [GameMaker](https://gamemaker.io) project that can be built into a Windows executable as well as a HTML5 Javascript-based client. It's intended to be used alongside the backend server that this client communicates with.

The GameMaker version of the project is IDE `v2022.0.0.19` (LTS), Runtime `v2022.0.0.12`.

## Building

### Building for Windows

The Windows build is generally intended to be a developer build, used by the developer and/or researchers, instead of a research subject.

To build a Windows executable, open the project in GameMaker and first set the following build target settings:
| | |
| - | - |
| Platform | Windows |
| Output | VM or YYC |
| Device | Default |
| Config | Default |

Then press Build -> Create Executable -> Package as Zip. Once the build is done, extract the zip, and you'll find the executable file at the root.

### Building for HTML5

The HTML5 build is intended to be the client that a research subject would be given to play.

To build a HTML5 client, open the project in GameMaker and first set the following build target settings:

| | |
| - | - |
| Platform | HTML5 |
| Output | JavaScript |
| Device | Default |
| Config | Release |

Then press Build -> Create Executable -> Package as Zip. Extract the zip file and you'll find the client files.

You'll find an index.html file in the build, but opening it directly in a browser will not launch the game properly. In order to launch the HTML5 client properly, you need to serve the index.html file through a web server, such as the one included in this repository.

### General

After building to either platform, you need to define the URL and authentication to the backend server for the build. This will let the client communicate with the server. Create a file called `.api_env.json` at the root of the build, and define the following keys in it:

```json
{
    // The URL to the server.
    "remote_url": "",

    // The username and password that the API requires.
    // These will need to match what you've defined when setting up the server.
    "api_username": "",
    "api_password": ""
}
```