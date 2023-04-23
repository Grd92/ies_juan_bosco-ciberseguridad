# Analisis Forense Utils

## Buscar un directorio - comando find
- find / -type d -name "\*brave\*" -print 2>/dev/null

## Buscar un fichero - comando find
- find / -type f -name "\*brave\*" -print 2>/dev/null

## Buscar un fichero - comando locate
- locate brave

## Buscar archivos con un determinado tipo en una ruta - comando grep
- grep -rl "SQLite*" /mnt/android
