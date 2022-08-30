
feed=$1

print_usage_err() {
  echo 'Usage: ./feedy.sh <feed_name>.atom                              | Creates the feed'
  echo 'Usage: ./feedy.sh <feed_name>.atom <entry_title> <entry_link>   | Creates a new entry for the feed'
  exit 1
}
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
  link=$3

  echo "<entry>"
  echo "<title>$title</title>"
  echo "<id>$id</id>"
  if [ "$link" != "" ] ; then echo "<link href=\"$link\" rel=\"alternate\"/>" ; fi
  echo "<updated>$(get_date)</updated>"
  echo "<published>$(get_date)</published>"
  echo "</entry>"
}

if [[ $feed != *.atom ]] ; then print_usage_err; fi

if [ ! -f $feed ] ; then 
  get_basic_feed > $feed
  echo The feed was just created. Please manually fill in the feed details. 
fi

entry_title="$2"
entry_link="$3"

if [ "$entry_title" == "" || "$entry_link" == "" ] ; then 
  print_usage_err
fi


# remove closing feed for adding new entry
sed -i '$d' $feed

# add entry
entry_id=$(get_id)
get_entry "$entry_title" "$entry_id" "$entry_link" >> $feed

# update last updated date
sed -i "0,/^.*updated.*$/s//<updated>$(get_date)<\/updated>/" $feed

# close feed
echo '</feed>' >> $feed

echo Added new feed entry with ID $entry_id
