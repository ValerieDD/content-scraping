#!/bin/bash

# Create a file named assets.raw in the same directory where this script will be run from
# It should contain just the filenames from the full links on the archive.wikiwix.com page
# The rest of the URL to each image is the same, so we can hard-code that here in the script
#
# The benefit of knowing just the filename is that it can be used with the -O switch for
# wget so that it names the downloaded file instead of making a big long ugly filename that
# matches the entire URL being copied down.
#
# We also spoof the UserAgent string; many download sites will block something that contains
# wget in the user-agent string, which wget does by default. It's not foolproof, and should
# really be a valid User-Agent value.
# See https://www.whatismybrowser.com/guides/the-latest-user-agent/chrome for examples

urlbase='https://archive.wikiwix.com/cache/index2.php?url=http%3A%2F%2Fassets.brandarmy.com%2Fb1epm3r967e%2Fimages%2F'
referer='https://archive.wikiwix.com/cache/index2.php?url=unique-seagull.static.domains/jennypopach.html'

while read filename
do

  # Assemble the static URL component with the particular filename we want to retrieve
  urltoget="${urlbase}${filename}"

  # You can use this line to be sure that your variables are being set to values that you expect
  #echo "Running wget for ${urltoget} and outputting to ${filename}"

  # Do the actual get command. See https://man.archlinux.org/man/wget.1 for other wget options
  wget -nc --referer="${referer}" -U "Internet Exploder" -O ./${filename} "${urltoget}"

  # The site in the urlbase seems to have rate limiting enabled. Adding this sleep will wait between
  # file retrieval attempts to get around that. Yeah, it makes it really slow to pull stuff down, but
  # so far there doesn't seem to be another way.
  sleep 20
  
done < assets.raw
