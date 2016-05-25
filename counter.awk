# Mesure shadowsocks-libev server's attackers, infomation from log of ss-libev
# usage: awk -f counter.awk /path/to/whatever_of_shadowsocks-libev_log
$0 ~ /^.+ERROR: .+[1-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/{
	ip[$NF]++
}END{
	for (x in ip)
		print x, "ERROR", ip[x], " times"
}

