#!/usr/bin/env bash

OVERPASS_API="https://overpass-api.de/api/interpreter"

mkdir -p "data/"

for file in ./Queries/*.ql; do
	QUERY_NAME="${file:10:-3}"
	QUERY=$(cat "$file")
	echo $QUERY

	curl -G --data-urlencode "data=$QUERY" -o "data/$QUERY_NAME.osm" $OVERPASS_API
	# ogr2ogr data/$QUERY_NAME.geojson data/$QUERY_NAME.osm
	# ogr2ogr data/$QUERY_NAME.shp data/$QUERY_NAME.osm
done

