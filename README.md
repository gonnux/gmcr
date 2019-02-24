# gmcr
gonapps' simple macro
## Usage
### installation
```console
git clone https://github.com/gonapps-org/gmcr
cd gmcr
apt install liblua5.3-dev
apt install libboost-program-options-dev
apt install flex
apt install g++
apt install make
make
make install
```
### example
```console
gmcr -f args.json < template.gmcr
````
### args.json example
```json
{"branch": "master"}

```
### template.gmcr example
```text
FROM alpine:latest
#{{m branch = args.branch }}#
RUN apk update && apk add tmux
#{{m if branch == 'dev' then print('apk add git') }}#
#{{i partial.gmcr }}#
```

## License
Mozilla Public License 2.0
