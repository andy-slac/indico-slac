#
# This script is to be sourced by docker-entrypoint.sh
# Do not make it executable
#

file_env 'INDICO_USER' 'indico'
file_env 'INDICO_DB' "$INDICO_USER"
file_env 'INDICO_PASSWORD'

psql -U postgres -c "CREATE ROLE $INDICO_USER WITH LOGIN PASSWORD '$INDICO_PASSWORD'"
psql -U postgres -c "CREATE DATABASE $INDICO_DB WITH OWNER=$INDICO_USER"
psql -U postgres -c "CREATE EXTENSION unaccent; CREATE EXTENSION pg_trgm;"