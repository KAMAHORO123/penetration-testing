# Penetration Testing Automation Script

## Project: VULNER

This script automates penetration testing by scanning a network for open ports, services, weak credentials, and potential vulnerabilities. It helps security professionals assess and secure their systems efficiently.

## Features

- **Network Scanning**: Identifies open TCP and UDP ports.
- **Service Detection**: Determines running services and versions.
- **Weak Password Detection**: Checks for weak credentials on SSH, RDP, FTP, and Telnet.
- **Vulnerability Mapping**: Uses Nmap Scripting Engine (NSE) and Searchsploit for analysis (Full mode only).
- **Logging**: Saves scan results for later analysis.

## Prerequisites

Ensure you have the following installed on your system:

- **Kali Linux** (or a Linux system with penetration testing tools installed)
- **Nmap**
- **Hydra or Medusa** (for password cracking)
- **Searchsploit** (for vulnerability analysis)
- **Zip Utility** (for saving results)

Install missing dependencies using:

```bash
sudo apt update && sudo apt install nmap hydra medusa exploitdb zip -y
```

## Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/your-repo.git
   cd your-repo
   ```
2. Make the script executable:
   ```bash
   chmod +x second.sh
   ```
3. Run the script:
   ```bash
   ./second.sh
   ```
4. Provide input when prompted:
   - **Network to scan** (e.g., `10.0.2.0/24`)
   - **Output directory name** (e.g., `scan_results`)
   - **Scan type** (`Basic` or `Full`)

## Password List

- Default password list: `/usr/share/wordlists/rockyou.txt` (requires extraction if not already done).
- You can provide a custom password list when prompted.

## Output

- Results are saved in the specified output directory.
- Logs include open ports, weak credentials, and potential vulnerabilities.
- An option to zip results for easy sharing.

## Contribution

Contributions are welcome! Feel free to submit a pull request with improvements or bug fixes.

## Disclaimer

This script is for educational and authorized security testing only. Unauthorized use may violate laws and regulations.

## License

MIT License
