#!/bin/bash

# Author: KAMAHOR LINDA KELLIA
# Class: s7
# Lecturer: VULNER
# Description: Network penetration testing automation script

# 1. Getting User Input

# Get the network to scan
echo "Enter the network to scan (e.g., 192.168.1.0/24):"
read network

# Validate network input (simple validation, might need improvement)
if [[ ! $network =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\/[0-9]+$ ]]; then
    echo "Invalid network format. Please provide a valid CIDR (e.g., 192.168.1.0/24)"
    exit 1
fi

# Get output directory name
echo "Enter the name for the output directory:"
read output_dir

# Ensure directory doesn't already exist
if [ -d "$output_dir" ]; then
    echo "Directory $output_dir already exists. Please choose another name."
    exit 1
fi

# Create the output directory
mkdir $output_dir

# Choose scan type (Basic or Full)
echo "Choose scan type ('Basic' or 'Full'):"
read scan_type

if [[ "$scan_type" != "Basic" && "$scan_type" != "Full" ]]; then
    echo "Invalid choice. Please choose 'Basic' or 'Full'."
    exit 1
fi

# 2. Weak Credentials

# Function to check for weak credentials using Hydra
check_weak_credentials() {
    echo "Checking for weak credentials..."
    if [ -f "$password_list" ]; then
        echo "Using password list: $password_list"
    else
        echo "Password list not found. Using default password.lst."
        password_list="password.lst"
    fi

    # Scan for weak credentials (SSH, FTP, RDP, TELNET) using Hydra
    hydra -L $username_list -P $password_list $network ssh ftp rdp telnet -o $output_dir/weak_credentials.txt
}

# Allow the user to provide their own password list
echo "Would you like to provide your own password list? (y/n):"
read use_custom_list
if [[ "$use_custom_list" == "y" ]]; then
    echo "Enter the path to your password list:"
    read password_list
fi

# 3. Mapping Vulnerabilities (Only for Full Scan)

map_vulnerabilities() {
    echo "Mapping vulnerabilities using Nmap Scripting Engine (NSE)..."
    nmap --script vuln $network -oN $output_dir/vulnerabilities.txt
    echo "Vulnerabilities mapped. Searching for related exploits using Searchsploit..."
    searchsploit -t $network > $output_dir/exploits.txt
}

# 4. Log Results

# Function to display results to the user
display_results() {
    echo "Scan results for $network saved in $output_dir."
    echo "Weak credentials can be found in $output_dir/weak_credentials.txt."
    if [ "$scan_type" == "Full" ]; then
        echo "Vulnerabilities can be found in $output_dir/vulnerabilities.txt and exploits in $output_dir/exploits.txt."
    fi
}

# Allow user to search inside the results
search_results() {
    echo "Would you like to search inside the results? (y/n):"
    read search_choice
    if [[ "$search_choice" == "y" ]]; then
        echo "Enter search term:"
        read search_term
        grep -i "$search_term" $output_dir/* > $output_dir/search_results.txt
        echo "Search results saved in $output_dir/search_results.txt."
    fi
}

# Allow user to save results into a Zip file
save_results() {
    echo "Would you like to save all results into a Zip file? (y/n):"
    read zip_choice
    if [[ "$zip_choice" == "y" ]]; then
        zip -r $output_dir/results.zip $output_dir
        echo "Results saved in $output_dir/results.zip."
    fi
}

# 5. Creativity

# Automate the scanning process based on the chosen scan type

# Start basic scan
if [[ "$scan_type" == "Basic" ]]; then
    echo "Starting basic scan for $network..."
    nmap -sS -sU -T4 -A -v $network -oN $output_dir/basic_scan_results.txt
    check_weak_credentials
    display_results
    search_results
    save_results
fi

# Start full scan (includes NSE and vulnerability mapping)
if [[ "$scan_type" == "Full" ]]; then
    echo "Starting full scan for $network..."
    nmap -sS -sU -T4 -A -v $network --script=default,vuln -oN $output_dir/full_scan_results.txt
    check_weak_credentials
    map_vulnerabilities
    display_results
    search_results
    save_results
fi

# End of script
