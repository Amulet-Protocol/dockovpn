#!/bin/bash

source ./functions.sh

CLIENT_PATH="$(createConfig)"
CONTENT_TYPE=application/text
FILE_NAME=client.ovpn
FILE_PATH="$CLIENT_PATH/$FILE_NAME"

if (($#))
then

    # Parse string into chars:
    # z    Zip user config
    # p    User password for the zip archive
    FLAGS=$1

    # Switch statement
    case $FLAGS in
        z)
            zipFiles "$CLIENT_PATH"

            CONTENT_TYPE=application/zip
            FILE_NAME=client.zip
            FILE_PATH="$CLIENT_PATH/$FILE_NAME"
            ;;
        zp)
            # (()) engaes arthimetic context
            if (($# < 2))
            then
                echo "$(datef) Not enough arguments" && exit 1
            else
                zipFilesWithPassword "$CLIENT_PATH" "$2"

                CONTENT_TYPE=application/zip
                FILE_NAME=client.zip
                FILE_PATH="$CLIENT_PATH/$FILE_NAME"
            fi
            ;;
        o)
                cat "$FILE_PATH"
                exit 0
            ;;
        oz)
            zipFiles "$CLIENT_PATH" -q

            FILE_NAME=client.zip
            FILE_PATH="$CLIENT_PATH/$FILE_NAME"
            cat "$FILE_PATH"
            exit 0
            ;;
        ozp)
            if (($# < 2))
            then
                echo "$(datef) Not enough arguments" && exit 1
            else
                zipFilesWithPassword "$CLIENT_PATH" "$2" -q

                FILE_NAME=client.zip
                FILE_PATH="$CLIENT_PATH/$FILE_NAME"
                cat "$FILE_PATH"
                exit 0
            fi
            ;;
        *) echo "$(datef) Unknown parameters $FLAGS"
            ;;

    esac
fi
echo "$(datef) $FILE_PATH file has been generated"

echo "$(datef) Healthcheck server started"

while true; do echo -e "HTTP/1.1 200 OK\n\n $(date)" | nc -w0 -l 8080 ; done