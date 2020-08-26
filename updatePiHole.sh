#!/bin/bash

# get this file:
#   wget https://raw.githubusercontent.com/losgehts/SVpihole-lists/master/updatePiHole.sh

# download filtered SV (RPiList) blacklists
repo="https://raw.githubusercontent.com/losgehts/SVpihole-lists/master/blacklists/"
curl -s -L "${repo}Corona-Blocklist" "${repo}Fake-Science" "${repo}Phishing-Angriffe" "${repo}Streaming " "${repo}Win10Telemetry" "${repo}child-protection" "${repo}crypto" "${repo}easylist" "${repo}gambling" "${repo}malware" "${repo}notserious" "${repo}samsung" "${repo}spam.mails" > filteredSVblacklist
mv filteredSVblacklist /var/www/html/filteredSVblacklist

# von Kuketz
# Download AdBlock Lists (EasyList, EasyPrivacy, Fanboy Annoyance / Social Blocking)
curl -s -L https://easylist.to/easylist/easylist.txt https://easylist.to/easylist/easyprivacy.txt https://easylist.to/easylist/fanboy-annoyance.txt https://easylist.to/easylist/fanboy-social.txt > adblock_tmp.unsorted

# Look for: ||domain.tld^
sort -u adblock_tmp.unsorted | grep ^\|\|.*\^$ | grep -v \/ > adblock_tmp.sorted

# Remove extra chars and put list under lighttpd web root
sed 's/[\|^]//g' < adblock_tmp.sorted > /var/www/html/adblock.sorted


# Remove files we no longer need
rm adblock_tmp.unsorted adblock_tmp.sorted


# update PiHole
pihole -g