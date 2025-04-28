
# Initialize flags
nflag=0
vflag=0

# Parse options
while [[ "$1" == -* ]]; do
    case "$1" in
        -n) nflag=1 ;;
        -v) vflag=1 ;;
        -vn|-nv) nflag=1; vflag=1 ;;
        --help) 
            echo "Usage: $0 [-n] [-v] searchstring filename"
            echo "-n: show line numbers"
            echo "-v: invert match (show lines that do NOT match)"
            exit 0
            ;;
        *) 
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
    shift
done

# Now $1 is search string, $2 is filename
search=$1
file=$2

# Check if search string and file are provided
if [[ -z "$search" || -z "$file" ]]; then
    echo "Error: Missing search string or filename."
    echo "Use --help for usage information."
    exit 1
fi

# Check if file exists
if [[ ! -f "$file" ]]; then
    echo "Error: File not found: $file"
    exit 1
fi

# Read file line by line
linenumber=0
while IFS= read -r line
do
    ((linenumber++))
    
    # Search for string (case insensitive)
    echo "$line" | grep -i "$search" > /dev/null
    result=$?
    
    if [[ $vflag -eq 1 ]]; then
        # Inverted match: print if NOT matched
        if [[ $result -ne 0 ]]; then
            if [[ $nflag -eq 1 ]]; then
                echo "$linenumber:$line"
            else
                echo "$line"
            fi
        fi
    else
        # Normal match: print if matched
        if [[ $result -eq 0 ]]; then
            if [[ $nflag -eq 1 ]]; then
                echo "$linenumber:$line"
            else
                echo "$line"
            fi
        fi
    fi

done < "$file"

