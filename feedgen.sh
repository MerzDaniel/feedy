
get_date() {
  date +%FT%R:00Z
}

get_basic_feed() {
  cat << EOF
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
<title>Title of your feed</title>
<subtitle>Subtitle of your feed</subtitle>
<link href="http://domain.com"/>
EOF

  echo "<updated>$(get_date)</updated>"
  cat << EOF
<author>
<name>Your Name</name>
<email>you@domain.com</email>
</author>
</feed>
EOF
}

get_entry() {
  cat << EOF
<entry>
<title>Your Title Here</title>
<link href="http://domain.com/page/ "/>
<id>urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a</id>
EOF

  echo "<updated>$(get_date)</updated>"
  cat << EOF
<summary>Short Summary</summary>
</entry>
EOF
}

feed=$1

if [[ $feed != *.atom ]] ; then echo nope ; exit 1; fi

if [ ! -f $feed ] ; then 
  get_basic_feed > $feed
fi

# remove closing feed for adding new entry
sed -i '$d' $feed

# add entry
get_entry >> $feed

# update last updated date
sed -i "0,/^.*updated.*$/s//<updated>$(get_date)<\/updated>/" $feed

# close feed
echo '</feed>' >> $feed

