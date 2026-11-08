#!/bin/bash


VERSION="1.0.0"
AUTHOR="ReddySec"

banner() {
    # Only print banner when stdout is a terminal (keeps piped output clean)
    [[ -t 1 ]] || return
    cat << "EOF"

  ______           _       _             _   
 |  ____|         | |     | |           | |  
 | |__   _ __   __| |_ __ | |_   _  __ _| |_ ___  _ __ 
 |  __| | '_ \ / _` | '_ \| | | | |/ _` | __/ _ \| '__|
 | |____| | | | (_| | |_) | | |_| | (_| | || (_) | |   
 |______|_| |_|\__,_| .__/|_|\__,_|\__, |\__\___/|_|   
                    | |             __/ |              
                    |_|            |___/               

        Endpoints Extractor v${VERSION}
        Author : ${AUTHOR}
========================================================

EOF
}

# ----------------------------------------------------------
#  Function to display help
# ----------------------------------------------------------
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -u URL    Specify a single URL to scan for endpoints."
    echo "  -l FILE   Specify a file containing a list of URLs to scan."
    echo "  -s FILE   Save the output to a specified file."
    echo "  -h        Display this help message."
    exit 0
}

# ----------------------------------------------------------
#  Function to extract URLs from HTML, JS, and JSON
# ----------------------------------------------------------
extract_urls() {
    local content="$1"
    echo "$content" | grep -Eo 'https?://[^"'\''> ]+' | sort -u
}

# ----------------------------------------------------------
#  Variables
# ----------------------------------------------------------
url=""
url_list=""
save_file=""
all_results=""

# ----------------------------------------------------------
#  Show banner
# ----------------------------------------------------------
banner

# ----------------------------------------------------------
#  Parse options
# ----------------------------------------------------------
while getopts "u:l:s:h" opt; do
    case $opt in
        u) url="$OPTARG" ;;
        l) url_list="$OPTARG" ;;
        s) save_file="$OPTARG" ;;
        h) show_help ;;
        *) show_help ;;
    esac
done

# ----------------------------------------------------------
#  Ensure at least one input is provided
# ----------------------------------------------------------
if [[ -z $url && -z $url_list ]]; then
    echo "Error: Either -u or -l must be specified." >&2
    show_help
fi

# ----------------------------------------------------------
#  Process a single URL
# ----------------------------------------------------------
if [[ -n $url ]]; then
    echo "Scanning URL: $url" >&2
    content=$(curl -s "$url") || { echo "Error fetching $url" >&2; exit 1; }
    urls=$(extract_urls "$content")
    echo "$urls"
    all_results+="$urls"$'\n'
fi

# ----------------------------------------------------------
#  Process a list of URLs
# ----------------------------------------------------------
if [[ -n $url_list ]]; then
    if [[ ! -f $url_list ]]; then
        echo "Error: File $url_list does not exist." >&2
        exit 1
    fi
    echo "Scanning URL list from file: $url_list" >&2
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        echo "Scanning URL: $line" >&2
        content=$(curl -s "$line") || { echo "Error fetching $line" >&2; continue; }
        urls=$(extract_urls "$content")
        echo "$urls"
        all_results+="$urls"$'\n'
    done < "$url_list"
fi

# ----------------------------------------------------------
#  Save to a file if -s option is provided
# ----------------------------------------------------------
if [[ -n $save_file ]]; then
    echo "$all_results" | grep -v '^$' > "$save_file"
    echo "Results saved to $save_file" >&2
fi
