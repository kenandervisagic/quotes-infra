#!/bin/bash

set -e

echo "[*] Fetching Cloudflare IP ranges..."

IPV4_URL="https://www.cloudflare.com/ips-v4"
IPV6_URL="https://www.cloudflare.com/ips-v6"

IPV4_TMP=$(mktemp)
IPV6_TMP=$(mktemp)

curl -s "$IPV4_URL" -o "$IPV4_TMP"
curl -s "$IPV6_URL" -o "$IPV6_TMP"

echo "[*] Removing existing Cloudflare UFW rules for ports 80/443..."

# Remove existing 80/443 rules
EXISTING_RULES=$(sudo ufw status numbered | grep -E "80|443" | grep -E "ALLOW IN" | grep -E "Cloudflare|cf" | awk -F'[][]' '{print $2}' | tac)

for rule_num in $EXISTING_RULES; do
    echo "Deleting UFW rule number $rule_num"
    sudo ufw --force delete "$rule_num"
done

echo "[*] Adding updated Cloudflare IPv4 rules..."
while read -r ip; do
    sudo ufw allow from "$ip" to any port 80,443 proto tcp comment "Cloudflare IPv4"
done < "$IPV4_TMP"

echo "[*] Adding updated Cloudflare IPv6 rules..."
while read -r ip; do
    sudo ufw allow from "$ip" to any port 80,443 proto tcp comment "Cloudflare IPv6"
done < "$IPV6_TMP"

rm -f "$IPV4_TMP" "$IPV6_TMP"

echo "[*] Reloading UFW..."
sudo ufw reload

echo "[+] Cloudflare IPs synced with UFW."

