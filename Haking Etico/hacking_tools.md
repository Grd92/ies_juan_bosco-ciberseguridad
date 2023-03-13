# Herramientas

_FPING_ :: Descubrir equipos en la red

    // buscar equipos en la red
    fping -g -r 1 {ip/mask} 
                -r 1 solo 1 intento
        
    // solo ips activas en la red
    fping -a -g -r 1 -s 192.168.1.0/24 --quiet

_NMAP_ :: Descubrir equipos en la red

    // descubrimiento de red con nmap guardando información a fichero
    nmap –sn 10.10.10.0/24 –oA nmap_descubrimiento     

    :: Descubrir puertos abiertos en los equipos de la red

    // -PE comportaamiento normal del ping, encontrar puertos abiertos
    # nmap -PE 

    // -PP petición para sincronización
    # nmap -PE 

    // -PM petición para encontrar la mascara de red
    # nmap -PE 

    // -PS petición para encontrar equipos y puertos
    // TCP SYN
    # nmap -PS {ip/mask}

    // -PA petición para encontrar equipos y puertos
    // TCP ACK
    # nmap -PA {ip/mask}

    // -PU petición para encontrar equipos y puertos
    // UDP
    # nmap -PA {ip/mask}

    // -PR petición para encontrar equipos y puertos basado con paquetes ARP
    // ARP
    # nmap -PA {ip/mask}

    // Desde un listado de IPs -iL
    nmap –Pn –iL listaIP

_NETDISCOVER_ :: Descubrir equipos en la red

    // -p pasive mode
    netdiscover -i eth0 -r {ip/mask} -p

    netdiscove -i eth0 -r 192.168.1.0/24 -p