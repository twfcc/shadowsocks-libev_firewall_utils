#! /bin/bash
# $author: twfcc@twitter
# $PROG: badip.sh
# $description: ban the IP tries to crack ss-server's password
# rules: ERROR greater than 50 times from ss.log will be blocked.
# $usage: crontab -e add line */15 * * * * /path/to/badip.sh
#         clear block list at 03:00am with crontab -e
#         0 3 * * * /sbin/iptables -F
#         clear ss.log at 03:00am with crontab -e
#         0 3 * * * : > /path/to/ss.log
# works on shadowsocks-libev only, execute ss-server with '-v' argument
# ex: nohup ss-server -v -u -c /path/to/whatever.json &>> /path/to/ss.log &
# Public domain use as your own risk!

logfile="$HOME/ss.log" #change if it is not your ss.log directory
awk '$0 ~ /^.+ERROR: .+[1-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/{
	ip[$NF]++
}END{
	for (x in ip)
		if (ip[x] > 50)
			print x
}' "$logfile" | while read -r bad_ip ; do
	if ! /sbin/iptables -L | grep -qE "^DROP.+ $bad_ip" ; then 
		/sbin/iptables -A INPUT -s "$bad_ip" -j DROP
		echo "$bad_ip blocked."
	else
		echo "$bad_ip already in block list."
	fi
done
exit 0
