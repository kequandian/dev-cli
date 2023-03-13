mkdir tmp
cp ../../../fatjar-cfr ./tmp/fatjar-cfr
cp ../../../fatjar-diff ./tmp/fatjar-diff
cp ../../../fatjar-find ./tmp/fatjar-find

## create docker driver for buildx
docker buildx create --name allinweb_buildx --use 

## start buildx
docker buildx build \
--push \
--platform linux/arm64/v8,linux/amd64 \
--tag zelejs/allin-web:git .

## use back default driver
docker buildx use default
docker buildx rm allinweb_buildx

rm -rf ./tmp
