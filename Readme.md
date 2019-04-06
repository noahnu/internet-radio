# Internet Radio: Docker Container

## Purpose

Configure and deploy an internet radio media server with minimal overhead.

## Getting Started

1. Clone the repository.
1. Add mp3 files to `./audiofiles`.
1. In a shell execute `docker-compose build && docker-compose up`
1. In a separate shell execute `docker-machine ip Default` to find the IP of the docker network.
1. Navigate to `http://<ip>:8000` in your browser to access the Icecast admin. Username is "admin", password is "admin\_password". You can connect to `http://<ip>:8000/all` with VLC or other media client to listen to the stream.

You can change the icecast and liquidsoap settings by overriding environment variables in the docker-compose.yml file. A table of environment variables and default values are listed below:

```
| Env Variable | Default Value |
| ------------ | ------------- |
| SOURCE_PASSWORD | "source_password" |
| RELAY_PASSWORD | "relay_password" |
| ADMIN_USER | "admin" |
| ADMIN_PASSWORD | "admin_password" |
| N_CLIENTS | 250 |
| N_SOURCES | 30 |
| QUEUE_SIZE | 5242880 |
| CLIENT_TIMEOUT | 30 |
| HEADER_TIMEOUT | 20 |
| SOURCE_TIMEOUT | 80 |
| BURST_ON_CONNECT | 1 |
| BURST_SIZE | 65535 |
| DEFAULT_PORT | 8000 |
```

## Debugging

You can set the environment variable `DEBUG=1` to have the entrypoint script hang and thus keep the container live. You can then exec into the container to look at liquidsoap and icecast logs.

## LICENSE

MIT License

Copyright (c) [2019] [Noah Ulster <noah@noahnu.com>]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
