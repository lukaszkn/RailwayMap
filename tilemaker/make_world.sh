cd /mnt/c/Projects/OsmDataExtract/tilemaker

# tilemaker --input ../Data/poland-latest.osm.pbf --output poland.mbtiles --config config_railways.json --process process_railways.lua
# ./tilemaker --input ../Data/poland-latest.osm.pbf --output poland.mbtiles --config config_railways.json --process process_railways.lua --fast

# ./tilemaker --input ../Data/europe-latest.osm.pbf --output europe.mbtiles --config config_railways.json --process process_railways.lua --skip-integrity --fast
# ./tilemaker --input ../Data/africa-latest.osm.pbf --output africa.mbtiles --config config_railways.json --process process_railways.lua --skip-integrity --fast
# ./tilemaker --input ../Data/asia-latest.osm.pbf --output asia.mbtiles --config config_railways.json --process process_railways.lua --skip-integrity --fast
# ./tilemaker --input ../Data/australia-oceania-latest.osm.pbf --output australia-oceania.mbtiles --config config_railways.json --process process_railways.lua --skip-integrity --fast
# ./tilemaker --input ../Data/central-america-latest.osm.pbf --output central-america.mbtiles --config config_railways.json --process process_railways.lua --skip-integrity --fast
# ./tilemaker --input ../Data/north-america-latest.osm.pbf --output north-america.mbtiles --config config_railways.json --process process_railways.lua --skip-integrity --fast
# ./tilemaker --input ../Data/south-america-latest.osm.pbf --output south-america.mbtiles --config config_railways.json --process process_railways.lua --skip-integrity --fast

./tilemaker --input ../Data/europe-latest.osm.pbf --output world-railways.mbtiles --config config_railways.json --process process_railways.lua --skip-integrity --fast
./tilemaker --input ../Data/africa-latest.osm.pbf --output world-railways.mbtiles --merge --config config_railways.json --process process_railways.lua --skip-integrity --fast
./tilemaker --input ../Data/asia-latest.osm.pbf --output world-railways.mbtiles --merge --config config_railways.json --process process_railways.lua --skip-integrity --fast
./tilemaker --input ../Data/australia-oceania-latest.osm.pbf --output world-railways.mbtiles --merge --config config_railways.json --process process_railways.lua --skip-integrity --fast
./tilemaker --input ../Data/central-america-latest.osm.pbf --output world-railways.mbtiles --merge --config config_railways.json --process process_railways.lua --skip-integrity --fast
./tilemaker --input ../Data/north-america-latest.osm.pbf --output world-railways.mbtiles --merge --config config_railways.json --process process_railways.lua --skip-integrity --fast
./tilemaker --input ../Data/south-america-latest.osm.pbf --output world-railways.mbtiles --merge --config config_railways.json --process process_railways.lua --skip-integrity --fast
