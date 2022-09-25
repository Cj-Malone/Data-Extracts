#!/usr/bin/env bash

OVERPASS_API="https://overpass-api.de/api/interpreter"

if [ ! -d "Data" ]; then
	mkdir "Data"
fi
PREFIX=$(date +"%Y-%m-%d")

for file in ./Queries/*.overpassql; do
	QUERY_NAME="${file:10:-3}"
	QUERY=$(cat "$file")
	echo "$QUERY_NAME"

	curl -G --data-urlencode "data=$QUERY" -o "Data/$QUERY_NAME.osm" $OVERPASS_API
	ogr2ogr -skipfailures --config OSM_CONFIG_FILE "Queries/$QUERY_NAME.conf.ini" "Data/$PREFIX-$QUERY_NAME.points.geojson" "Data/$QUERY_NAME.osm" points
	ogr2ogr -skipfailures --config OSM_CONFIG_FILE "Queries/$QUERY_NAME.conf.ini" "Data/$PREFIX-$QUERY_NAME.multipolygons.geojson" "Data/$QUERY_NAME.osm" multipolygons
	# ogr2ogr -skipfailures --config OSM_CONFIG_FILE "Queries/$QUERY_NAME.conf.ini" "Data/$PREFIX-$QUERY_NAME.points.shp" "Data/$QUERY_NAME.osm" points
	# ogr2ogr -skipfailures --config OSM_CONFIG_FILE "Queries/$QUERY_NAME.conf.ini" "Data/$PREFIX-$QUERY_NAME.multipolygons.shp" "Data/$QUERY_NAME.osm" multipolygons
done

