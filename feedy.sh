
feed=$1

get_date() {
  date +%FT%R:00Z
}

get_id() {
  echo urn:uuid:$(uuidgen)
}

get_basic_feed() {
  cat << EOF
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
<title>Title of your feed</title>
<subtitle>Subtitle of your feed</subtitle>
<link href="http://domain.com"/>
<link rel="self" href="/feed.atom"/>
EOF

  echo "<updated>$(get_date)</updated>"
  echo "<id>$(get_id)</id>"
  cat << EOF
<author>
<name>Your Name</name>
<email>you@domain.com</email>
</author>
</feed>
EOF
}

get_entry() {
  title=$1
  id=$2

  echo "<entry>"
  echo "<title>$title</title>"
  echo "<id>$id</id>"
  echo "<updated>$(get_date)</updated>"
  echo "<published>$(get_date)</published>"
  echo "</entry>"
}

if [[ $feed != *.atom ]] ; then echo No feed provided ; exit 1; fi

if [ ! -f $feed ] ; then 
  get_basic_feed > $feed
  echo The feed was just created. Please manually fill in the feed details. A dedicated domain is needed for ID generation. No Entry will be created
  echo Done
  exit 0
fi

entry_title="$2"

if [ "$entry_title" == "" ] ; then 
  echo No title for a new feed entry provided.
  exit 1
fi


# remove closing feed for adding new entry
sed -i '$d' $feed

# add entry
entry_id=$(get_id)
get_entry "$entry_title" "$entry_id" >> $feed

# update last updated date
sed -i "0,/^.*updated.*$/s//<updated>$(get_date)<\/updated>/" $feed

# close feed
echo '</feed>' >> $feed

echo Added new feed entry with ID $entry_id
