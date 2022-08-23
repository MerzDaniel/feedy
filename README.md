# Feedy
This is a very simple CLI script for updating an Atom feed.

I had to hack together something as I couldn't find a simple CLI based atom feed generator.
It does no XML parsing or anything fancy, so it may break your existing feed if you use it ;-)

## Usage
    # Create a feed if it doesn't exist yet
    ./feedy.sh test.atom

    # You have to manually edit the feed and enter your Author name and host

    # Add a new entry to your feed
    ./feedy.sh test.atom 'Cool new feed entry'

## Deployment
Host the feed on a http server like Nginx or Apache

## Sources
- [W3 Atom description](https://validator.w3.org/feed/docs/atom.html)
- [Atom RFC](https://www.rfc-editor.org/rfc/rfc4287)
