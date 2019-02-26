# gmcr
## Introduction
GMCR is abbreviation Gonapps' simple MaCRo

It has similar syntax to mustache, yet it is more flexible because you can use lua code inside tags!
## Usage
### Installation
```console
git clone --recurse-submodules https://github.com/gonapps-org/gmcr
cd gmcr
apt install liblua5.3-dev
apt install libboost-dev
apt install libboost-program-options-dev
apt install nlohmann-json-dev
apt install flex
apt install libfl-dev
apt install g++
apt install make
apt install cmake
cd build
cmake ..
make
make install
```
## Syntax
- a gmcr tag must begin with '#{{' followed by mode modifier string
- a gmcr tag must end with single white space or newline followed by '}}#'
## Tags
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
