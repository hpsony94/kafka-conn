_api_connector_update () {
    name=$1
    config=$2
    $CURL_PUT --url http://$KAFKA_CONNECT_URL/connectors/$name/config --data @$config
}

_api_connector_delete () {
    name=$1
    rtcode=$($CURL_DELETE --url http://$KAFKA_CONNECT_URL/connectors/$name)
    if [ 204 == $rtcode ]; then
        printf "${YELLOW} Done ${NOCOLOR}\n"
    else
        printf "${YELLOW} ERROR ${NOCOLOR}"
        cat $CURL_LOG_PATH
        exit 1
    fi
}

f_apply () {
    jsfile=$(find $1 -type f)
    for js in $jsfile
    do
        printf "$js: "
        name=$(echo $js | rev | cut -d'/' -f1 | rev)
        rtcode=$(_api_connector_update $name $js)
        if [ 200 == $rtcode ]; then
            printf "${GREEN}$rtcode Updated successfully${NOCOLOR}"
        elif [ 201 == $rtcode ]; then
            printf "${YELLOW}$rtcode Created successfully${NOCOLOR}"
        else 
            printf "${RED}ERROR $rtcode ${NOCOLOR}"
            cat $CURL_LOG_PATH
            exit 1
        fi
        printf "\n"
    done
    exit 0
}



f_sync () {
    dir=$1
    l_conn=$( $CURL_GET --url http://$KAFKA_CONNECT_URL/connectors/ | jq . | grep -i "__" ) #Todo
    for conn in $l_conn
    do
        name=$(echo $conn | tr -d '",')
        printf "$name: "
        set +e
        count=$(find $dir -iname $name | grep -c $name)
        if [ 0 == $count ]; then
            printf "${RED} Deleting it: ${NOCOLOR}"
            _api_connector_delete $name
        else
            echo -e ${GREEN} Keep it ${NOCOLOR}
        fi
        set -e
    done
    exit 0
}