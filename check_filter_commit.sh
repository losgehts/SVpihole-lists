#!/bin/bash

# Das Script holt die Dateien vom SV-Repo (github.com/RPiList) runter
#  und löscht die Zeilen, die mit den Einträgen in der Datei 
#  WHITELIST beginnen.
#
# Es sollte noch dahingehend erweitert werden, dass die gefilterten
#   Listen auf ein eigenes Repo hochgeladen werden, damit sie dort
#   meiner Familie zur Verfügung stehen.
#
#
#


echo "==============================================================="
echo "==============================================================="
echo "Download der SemperVideo Blocklisten "
echo "   notserious      Streaming       Phishing-Angriffe"
echo "   spam.mails      Win10Telemetry  easylist      samsung"
echo "   pornblock1      pornblock2      pornblock3    pornblock4"
echo "   crypto          gambling        child-protection"
echo "   Fake-Science    Corona-Blocklist              malware"
echo ""
echo ""
echo "Die Dateien werden im Verzeichnis blacklists abgelegt"
echo "und die Domains der Datei whitelist werden herausgefiltert"
echo "==============================================================="

echo "" 
echo ""
echo " ** Download ** "
# get lists from SV RPiList repo
URL="https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten"
mkdir -p blacklists
wget -q "$URL"/notserious -O blacklists/notserious
wget -q "$URL"/Streaming -O blacklists/Streaming
wget -q "$URL"/Phishing-Angriffe -O blacklists/Phishing-Angriffe
wget -q "$URL"/spam.mails -O blacklists/spam.mails
wget -q "$URL"/Win10Telemetry -O blacklists/Win10Telemetry
wget -q "$URL"/easylist -O blacklists/easylist
wget -q "$URL"/samsung -O blacklists/samsung
wget -q "$URL"/pornblock1 -O blacklists/pornblock1
wget -q "$URL"/pornblock2 -O blacklists/pornblock2
wget -q "$URL"/pornblock3 -O blacklists/pornblock3
wget -q "$URL"/pornblock4 -O blacklists/pornblock4
wget -q "$URL"/crypto -O blacklists/crypto
wget -q "$URL"/gambling -O blacklists/gambling
wget -q "$URL"/child-protection -O blacklists/child-protection
wget -q "$URL"/Fake-Science -O blacklists/Fake-Science
wget -q "$URL"/Corona-Blocklist -O blacklists/Corona-Blocklist
wget -q "$URL"/malware -O blacklists/malware
echo "   Download fertig"

echo ""
echo " ** Domains herausfiltern ** "
if ! [ -f whitelist ]; then
  touch whitelist
fi

# remove whitelisted domains from the blacklists
while IFS= read -r domain
do
    # echo $domain

    if [[ -z "$domain" ]]; then
        echo ""         # empty line in whitelist
    else

        # grep -v ^$domain blacklist > tmp
        for blacklist in blacklists/* ; do
            grep -v ^$domain "$blacklist" > "$blacklist""_tmp"
            mv "$blacklist""_tmp" "$blacklist"
        done

    fi
done < whitelist
echo "   Filtern fertig"

echo ""
echo "** Check nach Änderungen **"
# check for changes
if ! [[ -d ".git" ]]; then
    # es gibt kein Repo
    if git --version; then
        git init
        git add -A
        git commit -m "first automated commit. blacklists filtered with whitelist"
          else
        echo "git existiert nicht ==>> Abbruch!"
        exit 1
    fi
fi

if git diff --quiet
then
  echo "everything up to date, nothing to do"
else
  echo "detected changes => update repository"
  git status
  git add -A
  git commit -m "automated update filtered with whitelist"
  echo "updated local repository"
  echo "please update remote repo:   git push origin master"
fi
echo "==============================================================="
echo "==============================================================="
