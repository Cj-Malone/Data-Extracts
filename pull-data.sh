#!/usr/bin/env bash

OVERPASS_API="https://overpass-api.de/api/interpreter"

mkdir -p "data/"

for file in ./Queries/*.ql; do
	QUERY_NAME="${file:10:-3}"
	QUERY=$(cat "$file")
	echo "$QUERY_NAME"

	curl -G --data-urlencode "data=$QUERY" -o "data/$QUERY_NAME.osm" $OVERPASS_API
	ogr2ogr -skipfailures --config OSM_CONFIG_FILE "Queries/$QUERY_NAME.conf.ini" "data/$QUERY_NAME.points.geojson" "data/$QUERY_NAME.osm" points
	ogr2ogr -skipfailures --config OSM_CONFIG_FILE "Queries/$QUERY_NAME.conf.ini" "data/$QUERY_NAME.multipolygons.geojson" "data/$QUERY_NAME.osm" multipolygons
	# ogr2ogr data/$QUERY_NAME.shp data/$QUERY_NAME.osm
done

