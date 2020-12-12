f_check_json () {
    file $1
    cat $file | jq -c .
    if [ 0 == $(echo $?) ]; then
        echo 0
    else
        echo 1
    fi
}

f_validate_data () {
    jsfile=$(find $1 -type f)
    for js in $jsfile
    do
        cat $js | python -c "import sys,json;json.loads(sys.stdin.read());print('Validating $js: ${GREEN}OK${NOCOLOR}')"
    done
    exit 0
}