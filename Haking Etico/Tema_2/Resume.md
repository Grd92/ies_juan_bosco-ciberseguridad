# Tema 2 - 1

## Introducción

La primera fase de ejecucción de un acceso a un sistema de terceros es el reconocimiento (footprinting)

definicion de alcance > reconocimiento
    * después de firmar los documentos necesarios y se elabore un plan de test de instrusuión.

### RECONOCIMIENTO PASIVO

Reconocimiento Pasivo >> OSINT ( Open Source Intelligence )

    - obtener información de la organización a partir de fuentes abiertas
    
    - Se buscará toda la información posible sobre la red y los sistemas del objetivo sin establecer conexión diredcta con el mismo.

    - La busqueda de información relativa en reconocimiento pasivo suele ser:
        - nombres de dominio
        - direcciones IP
        - organizaciones con las que se relaciona
        - tecnologías empleadas
        - infraestructura de red
        - direcciones de correo
        - nombres de empleados, cargos e información personal de los mismos
    
Google Hacking
    > técnica de búsqueda basada en combinacion de operadores de búsqueda para obtener resultados sensibles que afectan a un objetivo.
    
        - site:"sitioejemplo.es" (permite indicar el nombre del sitio o dominio para limitar las búquedas)

        - intext:"Windows" (buscara exclusivamente en el texto de la pág.)

        - related:bancoejemplo.es (buscar paginas con contenido similar a la indicada, sirve para buscar relacionados con la organización)

        -link:sitioejemplo.es (Busca únicamente en paginas que enlazan a este sitio web)

        - intitle: (Operador para buscar palabras en el titulo de la página)

        - inurl: (Busca de manera especifica direcciones URL que contengan un texto determinado)

        - filetype:pdf (permite buscar archivos si google los ha identificado por su extensión, este operador suele combinarse con site)


Otros motores de búsqueda
    > Los dos más conocidos son Shodan y Zoomeye, pero existen otros que pueden resultar interesantes, como Greynoise, Censys, Onyphe o Bynaryedge

Bases de datos WHOIS
    Servicios de resolución de nombres

? Principal servicio de resolución de nombres >> DNS (Domain Name System - Sistema de Nombres de Dominio)

TLD (Top Level Domains) >> Dominios del primer nivel  de estos cuelgan los dominios de segunto nivel y así sucesivamente.

ejemplo

    tomelloso.esp.centrodeocio.org
    >        >   >            > TLD - PRIMER NIVEL
    >        >   > Dominio segundo nivel
    >        > Domino tercer nivel
    > Dominio cuarto nivel

Los espacios de nombre de dominio tiene una estructura de árbol invertido, comienzan con un nodo raiz principal .

                    www
    org unesco
                    mail

                    www
.   es  elregional
                    sftp

                    smtp
    com gooble
                    www

// 1 nodo puede tener hasta 63 caracteres


FQDN (Fully Qualified Domain Name) Nombre de dominio completo 

    max 255 caracteres

**Info**

DNS                 * es un servidor de nombres de domino
Nombre de dominio   * es un alias de una dirección IP
FQDN                * es un nombre de dominio que identifica 
                        el trayecto completo hasta un equipo
URL                 * es el trayecto completo a un archivo o recurso de internet


Tipos de test de intrusión
    
    >> caja blanca
    >> caja gris
    >> caja negra


RIR (Reginal Internet Registry -- Registro Regional de Internet) >> organización que suverpvisa la asignación y el registro de recursos de números de Internet dentro de una región particulas del mundo.

BGP - Border Gateway Protocol
IANA - Internet Assigned Numbers Authority

IANA esta por encima de RIR

    Entre ambas gestionan la lista de asignación de direcciones IP



RIPE NCC  >> ?

!! COMANDS

WHOIS 
    whois www.seat.es
    whois -I www.seat.es // con -I primero consulta whois.iana.org y luego whois



### RECONOCIMIENTO ACTIVO

La diferencia entre _RECONOCIMENTO PASIVO_ y _RECONOCIMIENTO ACTIVO_ es que en el _reconocimiento pasivo_ no se interactúa con el objetivo, las técnicas en las que se intereactua con el objetivo se reconocen como técnicas de _reconocimiento activo_


DNS >> servicio de almacenamiento y consulta de información , guardando la información en una bsae de datos distribuida

    utiliza el puerto 53/UDP para atender consultas de nombres
    utiliza el peurto 53/TCP para transefrencias de zona entre servidores


DELEGACIÓN DEL SERVICIO DNS

    proceso por el cual el gestor de un determinado dominio delega la gestión del mismo a otra entridad.

    >> ICAN delega la gestión del ccTLD en la empresa pública Red.es
        por lo que ICAN ya no se encargará de gestionar X dominio


REGISTROS DE RECURSOS DNS

RR (Resource Records)  / Cada fichero de zona organiza esta información en registros de recurso (RR)  los cuales se envian en las preguntas y respuestas entre clientes y servidor DNS

    // protoclo DNS defnido en la RFC 1035


    - nombre del dominio : 
    - TTL ( Time To Live ) : tiempo de vida en segundos, 
                                TTL = 0 indica que no se   almacena en cache
    - Clase : familia de protocolo utilizada, ejem. IN que representa una red TCP/IP
    - Tipo : varia en funcion del campo clase
    - Tipo de dato: Información asociada al nombre del dominio
                        Un registro de clase IN y tipo A especifica una dirección IP


TIPOS DE REGISTROS

NS - name server
A - address /host
AAAA - convierte nombre a ipv6
MX - registro mail
CNAME - Canonical Name : registro de nombre canonico
SOA - inicio de autoridad : cada zona contiene un registro 
                            de recrusos denominado inicio de autoridad
PTR - Pointer Record : correspondencia entre nombre de direcciones ipv4 e ipv6
TXT - Text : permite cualquier cadena de texto
SPF - Sender Policy Framework - Registro TXT
RP - Repsosible Person : registro informativo de la persona responasble de un dominio
SRV - Service Location : indica servicios disponibles 
                            para el dominio, nombre de equipo, puerto ..


HERRAMIENTAS PARA OBTENER INFORMACIÓN DE UN SERVIDOR DNS

- nslookup : permite resolver nombres de dominio
    type => establece el tipo de registro que queremos -- set type=A

- host : linea de comandos busqueas dns
    - ejemplo :: host -t a seat.es

- DNSRecon
    -t tld
    -d nombre-dominio

- nmap : obtención informacion sobre dns
- metasploit : herramienta de utilidad para todas las fases de un ataque


INGENERIA SOCIAL
    - phising / vishing / smishing -> correos electronicos / llamadas / sms
    - redes sociales -> busca relacionarse con la victima
    - dumpster diving -> rebuscar en la basura de la víctima 
                        de modo que se pueda obtener información personal o de la organización


# Tema 2 - 2

FASES DE EJECUCIÓN DE UN TEST DE INTRUSIÓN 
    > Enumeración
    > Flujo de la fase de enumeración
    > Descubrimiento de red
    > Escaneo de puertos
    > Escaneo de puertos con NMAP
    > Identificación de servicios y versiones
        > Identificación de servicios y versiones sin utilizar NMAP
        > Identificación de servicios y versiones utilizando NMAP
    > Enumeración del sistema operativo
        > Detección pasiva del sistema operativo
        > Detección activa del sistema operativo con NMAP ( -o )
    > Enumeración de servicios
        > Enumeración de servicios SMB y NETBIOS

____________________________________________________________________________

ENUMERACIÓN

fase de manera activa :> virificar ips validas y dominos obtenidas del reconocimiento
    ::> obtener nuevas ips de routers , firewalls , equipos , otros elementos de red

    ::> tambien se detectan puertos , versiones, usuarios y S.O. del sistema


1 . Descubrimiento de red

    Escaneo activo, es el equipo el que genera la mayor parte del trafico
    Escaneo pasivo, son los propios equipos de la res los que hacen peticiones ARP y quedan al descubierto
    
    Técnica TTL (time to live paq. ipv4) o HL (Hop Limit paq. ipv6) 
    - herramienta traceroute __ Linux
    - herramienta tracert __ Windows

    >> Network Sweep :: barrido de red ( fping , netdiscover )

2 . Escaneo de puertos
    
    - herramienta nmap

3 . Identificación de servicios y versiones

4 . Identificación del Sistema Operativo

5 . Enumeración de servicios y búsqeuda de vulenrabilidades

6 . Enumración de usuarios




EJECUCIÓN DE PASOS CON COMANDOS -- HACK

1 . Descubrimiento de red
    - ping sweep con ping // descubrimiento de todos los equipos en la red

    opcion 1 :: for i in {1..254}; do (ping –c 1 10.10.10.$i | grep “bytes from”); done
    opcion 2 :: fping
        fping -g -r 1 {ip/mask} 
                -r 1 solo 1 intento
        
        // solo ips activas en la red
        fping -a -g -r 1 -s 192.168.1.0/24 --quiet

    option 3 :: netdiscover

        netdiscover -i eth0 -r {ip/mask} -p

        netdiscove -i eth0 -r 192.168.1.0/24 -p
    
    option 4 :: nmap

        // descubrimiento de red con nmap guardando información a fichero
        nmap –sn 10.10.10.0/24 –oA nmap_descubrimiento 

2 . Escaneo de puertos
    
    opcion 1 :: nmap
        
        // -PE comportaamiento normal del ping, encontrar puertos abiertos
        // ICMP
        # nmap -PE {ip/mask}
        
        // -PP petición para sincronización
        // ICMP
        # nmap -PP {ip/mask}

        // -PM petición para encontrar la mascara de red
        // ICMP
        # nmap -PM {ip/mask}

3 . Identificación de servicios y versiones

4 . Identificación del Sistema Operativo

5 . Enumeración de servicios y búsqeuda de vulenrabilidades

6 . Enumración de usuarios