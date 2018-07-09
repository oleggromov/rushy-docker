# rushy-docker

A simple Docker image for [rushy](https://github.com/luchkonikita/rushy), Google lighthouse runner that supports multiple URLs and splitting these URLs into chunks to process in parallel.

It has google chrome and rushy installed, so you can run performance checks in your CI environment, and provides a simple API.

## Usage

Please pull the image from [oleggromov/rushy](https://hub.docker.com/r/oleggromov/rushy/):

```
docker pull oleggromov/rushy
```

The image provides the following "API" with _mounted volumes_ and _environment variables_.

### Volumes

- `/var/config` - you should mount a directory with your rushy config here. It should be read-only, `:ro`!
- `/var/rushy/{config.storeDir}` - and a directory where you want rushy to put reports here

Please notice that `config.storeDir` comes from your config. So in case you have the following in your config:

```
  "storeDir": "./reports",
```

You should mount it to `/var/rushy/reports`.

### Environment Variables

Since `rushy` expects at least `--config` to be set, you should provide your container with the following environment variables:

- `RUSHY_CONFIG` - config name relative to `/var/rushy/{config.storeDir}`
- `RUSHY_WORKER` - the corresponding `--worker` parameter
- `RUSHY_WORKER_COUNT` - `--workers-count` parameter.

For more about rushy parameters, please take a look at the [Usage section](https://github.com/luchkonikita/rushy#usage) of the Readme.

### Logging

Don't forget to switch to using `serial` rushy logger since Docker by default disables interactive shell and you won't see any progress.

### Example

Here's how you can run your container with rushy started as a single worker

```sh
docker run \
  -v /rushy/config:/var/config/:ro \
  -v /rushy/reports:/var/rushy/reports\
  -e "RUSHY_CONFIG=rushy.json" \
  -e RUSHY_WORKER=0 \
  -e RUSHY_WORKER_COUNT=1 \
  oleggromov/rushy
```

and in case you've got your config in `/rushy/config/rushy.json`:

```json
{
  "urls": [
    "https://www.oleggromov.com/"
  ],
  "reporter": "html",
  "logger": "serial",
  "storeDir": "./reports",
}

```

The reports will be stored in `$(pwd)/reports` inside the container and put into `/rushy/reports` on your host machine.

## License

MIT License

Copyright © 2018 Oleg Gromov

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
