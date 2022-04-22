;
; BIND data file for local loopback interface
;
$TTL	604800
@	IN	SOA	servidor.wearcar.autoupb.com. root.wearcar.autoupb.com. (
		       20220402         ; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			 604800 )	; Negative Cache TTL
;

					IN	NS	servidor.wearcar.autoupb.com.
3.0.0.0.0.0.0.0.c.a.a.a		IN	PTR	servidor.wearcar.autoupb.com.
1.0.0.0.0.0.0.0.c.a.a.a         IN	PTR	router.wearcar.autoupb.com.
3.0.0.0.0.0.0.0.c.a.a.a		IN	PTR	mail.wearcar.autoupb.com.
