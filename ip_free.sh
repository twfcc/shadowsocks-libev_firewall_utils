#! /bin/bash
# $author: twfcc@twitter
# $PROG: ip_free.sh
# $description: clear iptables INPUT chain of DROP rules which made by badip.sh
# $usage: crontab -e add new cronjob by add a line as below
# 0 3 * * * /path/to/ip_free.sh 
# Public Domain use as your own risk!

/sbin/iptables -L --line-number | grep -E '^[0-9]+.+DROP' | \
awk '{print $1}' | while read -r badip ; do
	 /sbin/iptables -D INPUT "$badip"
done

