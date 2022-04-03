;
; BIND data file for local loopback interface
;
$TTL	604800
@	IN	SOA	servidor.wearcar.autoupb.com. root.wearcar.autoupb.com. (
		       20220402		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			 604800 )	; Negative Cache TTL
;

			IN	NS	servidor.wearcar.autoupb.com.
servidor		IN	A	192.168.70.147
router			IN	A	192.168.70.145
mail			IN	A	192.168.70.147
wearcar.autoupb.com	IN	MX 10	mail

servidor		IN	AAAA	2801:0:2e0:abcd:a:aaac::3
router			IN	AAAA	2801:0:2e0:abcd:a:aaac::1
mail			IN	AAAA	2801:0:2e0:abcd:a:aaac::3
wearcar.autoupb.com	IN	MX 10	mail
