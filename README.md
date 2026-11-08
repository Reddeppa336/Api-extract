<<<<<<< HEAD
🔍 Endpoints Extractor

A lightweight Bash-based web reconnaissance tool for extracting absolute HTTP and HTTPS URLs from webpage responses.

"Bash" (https://img.shields.io/badge/Language-Bash-green)
"Version" (https://img.shields.io/badge/Version-1.0.0-blue)
"Platform" (https://img.shields.io/badge/Platform-Linux-orange)
"License" (https://img.shields.io/badge/License-MIT-yellow)

📌 About

Endpoints Extractor is a command-line reconnaissance tool developed using Bash scripting.

It retrieves webpage content using "curl" and extracts absolute HTTP and HTTPS URLs using regular expressions.

The tool supports scanning individual URLs as well as multiple URLs supplied through a text file.

It is designed for cybersecurity learners and authorized security researchers who want to understand basic web reconnaissance automation.

✨ Features

- Extract HTTP and HTTPS URLs.
- Scan a single website.
- Scan multiple websites from a text file.
- Follow HTTP redirects.
- Remove duplicate URLs within individual webpage results.
- Save extracted results to a file.
- Display a custom ASCII banner.
- Command-line argument support.
- Basic error handling.

🛠️ Requirements

- Linux operating system.
- Bash shell.
- curl.
- grep.
- sort.
- Coreutils.

Install dependencies

For Kali Linux, Debian and Ubuntu:

sudo apt update
sudo apt install curl grep coreutils -y

📥 Installation

Clone the repository:

git clone https://github.com/YOUR_USERNAME/endpoints-extractor.git

Navigate into the directory:

cd endpoints-extractor

Give execution permission:

chmod +x endpoints.sh

🚀 Usage

1. Display help

./endpoints.sh -h

2. Scan a single URL

./endpoints.sh -u https://example.com

3. Scan a URL and save results

./endpoints.sh -u https://example.com -s results.txt

4. Scan multiple URLs

Create a URL list:

nano urls.txt

Add URLs:

https://example.com
https://example.org
https://example.net

Execute:

./endpoints.sh -l urls.txt

5. Scan multiple URLs and save results

./endpoints.sh -l urls.txt -s results.txt

⚙️ Command-Line Options

Option| Description
"-u URL"| Scan a single URL
"-l FILE"| Read multiple URLs from a file
"-s FILE"| Save extracted results
"-h"| Display help

🧠 Code Explanation

1. Shebang

#!/bin/bash

Specifies Bash as the script interpreter.

2. Version and author variables

VERSION="1.0.0"
AUTHOR="ReddySec"

These variables store the current project version and author information.

3. Banner function

banner() {
    [[ -t 1 ]] || return
    cat << "EOF"
    ASCII ART
EOF
}

Displays the tool's ASCII banner.

"[[ -t 1 ]]" checks whether standard output is connected to a terminal.

The heredoc ("<<") allows multiline text to be displayed without multiple echo commands.

4. Help function

show_help() {
    echo "Usage: $0 [OPTIONS]"
}

Displays the usage instructions.

"$0" represents the script name.

5. URL extraction function

extract_urls() {
    local content="$1"
    echo "$content" |
        grep -Eo 'https?://[^"'\''> ]+' |
        sort -u
}

This function performs URL extraction.

- "local": Creates a local variable.
- "$1": Receives the first function argument.
- "grep": Searches for matching URL patterns.
- "-E": Enables extended regular expressions.
- "-o": Prints only matching text.
- "sort -u": Sorts and removes duplicates within the current input.

6. Variable initialization

url=""
url_list=""
save_file=""
all_results=""

Initializes variables used throughout the program.

7. Argument parsing

while getopts "u:l:s:h" opt; do

Uses "getopts" to process command-line options.

The colon after "u", "l", and "s" indicates that those options require arguments.

8. Single URL processing

content=$(curl -s "$url")

Downloads the webpage content.

The command substitution "$()" captures the command output and stores it in the variable.

9. Multiple URL processing

while IFS= read -r line; do

Reads the URL list one line at a time.

- "IFS=" preserves surrounding whitespace.
- "read" reads each line.
- "-r" prevents backslash interpretation.
- "line" stores the current URL.

10. Saving results

echo "$all_results" | grep -v '^$' > "$save_file"

Writes the collected results into the specified file.

- "grep -v": Excludes matching lines.
- "^$": Matches empty lines.
- ">": Creates or overwrites the output file.

📊 Example Output

   ENDPOINTS EXTRACTOR

Scanning URL: https://example.com

https://example.com/
https://www.iana.org/domains/example

Results saved to results.txt

Actual results depend on the webpage response.

⚠️ Limitations

- Extracts absolute URLs only.
- Does not extract all relative endpoints.
- Does not execute JavaScript.
- Does not recursively crawl websites.
- Does not discover endpoints requiring authentication.
- Regular-expression extraction may include trailing punctuation.
- Duplicate removal is performed per webpage, not globally across all scanned websites.

🔐 Responsible Usage

Use this tool only against websites you own or have explicit permission to test.

Respect applicable laws, website terms of service, rate limits and security testing policies.

This project is intended for educational purposes and authorized security research.

🗺️ Future Improvements

Planned features:

- Relative endpoint extraction.
- JavaScript file discovery.
- HTTP response status detection.
- JSON endpoint extraction.
- Global duplicate removal.
- Output filtering.
- Improved error handling.

📜 License

Distributed under the MIT License. See the "LICENSE" (LICENSE) file.

👨‍💻 Author

ReddySec

GitHub: https://github.com/Reddeppa336

If you find this project useful, consider giving it a ⭐!
