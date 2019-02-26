# gmcr
gonapps' simple macro
## Usage
### Installation
```console
git clone https://github.com/gonapps-org/gmcr
cd gmcr
apt install liblua5.3-dev
apt install libboost-dev
apt install libboost-program-options-dev
apt install nlohmann-json-dev
apt install flex
apt install libfl-dev
apt install g++
apt install make
cd build
cmake ..
make
make install
```
## Grammer
- gmcr code shall begin with '#{{' followed by mode modifier string
- gmcr code shall end with single white space or newline followed by '}}#'
### Include
```text
#{{i FILEPATH }}#
```
### Code
Your args.json input is saved to the global variable 'args'
```text
#{{c print('any lua5.3 code here') }}#
```
### Example
```console
gmcr -a args.json < template.gmcr > output
````
### args.json example
```json
{"branch": "master"}

```
### template.gmcr example
```text
FROM alpine:latest
#{{c branch = args.branch }}#
RUN apk update && apk add tmux
#{{c if branch == 'dev' then print('apk add git') end }}#
#{{i partial.gmcr }}#
```

## License
Mozilla Public License 2.0
