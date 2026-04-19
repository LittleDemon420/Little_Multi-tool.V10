#!/bin/bash

# --- PALETA DE COLORES NEÓN ---
R='\033[1;31m' # Rojo
V='\033[1;32m' # Verde
A='\033[1;33m' # Oro
B='\033[1;34m' # Azul
M='\033[1;35m' # Magenta
C='\033[1;36m' # Cian
W='\033[1;37m' # Blanco
G='\033[0;90m' # Gris
NC='\033[0m'   # Reset

# --- DATOS DINÁMICOS ---
USUARIO=$(whoami | tr '[:lower:]' '[:upper:]')
KERNEL=$(uname -r)
SISTEMA=$(cat /etc/os-release | grep "^PRETTY_NAME" | cut -d= -f2 | tr -d '"')

# --- FUNCIONES DE SOPORTE VISUAL ---
animar_entrada() {
    clear
    echo -e "\n\n"
    echo -e "          ${B}┌──────────────────────────────────────────────────┐${NC}"
    echo -e "          ${B}│${NC}  ${W}INICIANDO PROTOCOLO:${NC} ${C}$1${NC}      ${B}│${NC}"
    echo -e "          ${B}└──────────────────────────────────────────────────┘${NC}"
    echo -ne "          "
    for i in {1..50}; do
        echo -ne "${V}█${NC}"
        sleep 0.01
    done
    echo -e " ${V}100%${NC}"
    sleep 0.3
    clear
}

titulo_seccion() {
    echo -e "${C}┌──────────────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${C}│${NC}  ${W}>> $1${NC}"
    echo -e "${C}└──────────────────────────────────────────────────────────────────────────┘${NC}\n"
}

get_status() {
    USB_PATH=$(lsblk -lp -o MOUNTPOINT,RM | awk '$2 == 1 && $1 != "" {print $1}' | head -n 1)
    if [ -n "$USB_PATH" ]; then ST_USB="${V}● CONECTADO${NC}"; else ST_USB="${R}○ DESCONECTADO${NC}"; fi
    ping -c 1 8.8.8.8 &>/dev/null && ST_NET="${V}● EN LÍNEA${NC}" || ST_NET="${R}○ SIN RED${NC}"
}

# --- INTERFAZ PRINCIPAL ---
dibujar_ui() {
    clear
    get_status
    echo -e "${B}╔══════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${B}║${NC}${C}    _      _ _   _   _        __  __        _ _   _   _____          _    ${NC}${B}║${NC}"
    echo -e "${B}║${NC}${C}   | |    (_) | | | | |      |  \/  |      | | | (_) |_   _|        | |   ${NC}${B}║${NC}"
    echo -e "${B}║${NC}${C}   | |     _| |_| |_| | ___  | \  / |_   _| | |_ _    | | ___   ___ | |   ${NC}${B}║${NC}"
    echo -e "${B}║${NC}${C}   | |    | | __| __| |/ _ \ | |\/| | | | | | __| |   | |/ _ \ / _ \| |   ${NC}${B}║${NC}"
    echo -e "${B}║${NC}${C}   | |____| | |_| |_| |  __/ | |  | | |_| | | |_| |   | | (_) | (_) | |   ${NC}${B}║${NC}"
    echo -e "${B}║${NC}${C}   |______|_|\__|\__|_|\___| |_|  |_|\____|_|\__|_|   \_/\___/ \___/|_|   ${NC}${B}║${NC}"
    echo -e "${B}╠══════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${B}║${NC} ${W}USER:${NC}${M}$USUARIO${NC}${B}│${NC} ${W}OS:${NC}${A}${SISTEMA}${NC}${B}│${NC} ${W}NET:${NC} $ST_NET ${B}│${NC} ${W}USB:${NC} $ST_USB ${B}║${NC}"
    echo -e "${B}╚══════════════════════════════════════════════════════════════════════════╝${NC}"
}

# --- BUCLE PRINCIPAL ---
while true; do
    dibujar_ui
    echo -e "\n ${G}┌───────────────────── OPCIONES DE LITTLE MULTI-TOOL ──────────────────────┐${NC}"
    echo -e "   ${V}[01]${NC} ${W}MANTENIMIENTO TOTAL${NC}  ${G}▶${NC} ${A}Limpieza del equipo${NC}"
    echo -e "   ${V}[02]${NC} ${W}DIAGNÓSTICO DE RED${NC}   ${G}▶${NC} ${A}Ping a Google, DNS o IP personalizada${NC}"
    echo -e "   ${V}[03]${NC} ${W}MONITOR DE RECURSOS${NC}  ${G}▶${NC} ${A}¿Qué programas consumen más RAM y CPU?${NC}"
    echo -e "   ${V}[04]${NC} ${W}INFO. DEL HARDWARE${NC}   ${G}▶${NC} ${A}Detalles de Procesador, RAM y Almacenamiento${NC}"
    echo -e "   ${V}[05]${NC} ${W}AUDITORÍA DE PUERTOS${NC} ${G}▶${NC} ${A}Revisar seguridad de una dirección IP${NC}"
    echo -e "   ${R}[06]${NC} ${W}CREDENCIALES SMR${NC}     ${G}▶${NC} ${A}Información del autor y versión${NC}"
    echo -e "   ${R}[07]${NC} ${W}SALIR DEL PROGRAMA${NC}   ${G}▶${NC} ${R}Cerrar consola y finalizar sesión${NC}"
    echo -e " ${G}└──────────────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -ne " ${M}LMT_COMMANDER:${NC}${W}# ${NC}"
    read opcion

    case $opcion in
        1|01)
            animar_entrada "MANTENIMIENTO_FULL"
            titulo_seccion "EJECUTANDO LIMPIEZA PROFUNDA"
            USB=$(lsblk -lp -o MOUNTPOINT,RM | awk '$2 == 1 && $1 != "" {print $1}' | head -n 1)
            
            if [ -n "$USB" ]; then
                echo -e "${A}[!] Limpieza de Dispositivo Empezando: "
                (
                    DESTINO="$USB"
                    FECHA=$(date +"%Y%m%d_%H%M")
                    tar -czf "$DESTINO/EXP_DATA_${FECHA}.tar.gz" "/home" --exclude=*/.cache* >/dev/null 2>&1
                    ip a | grep -oP '(\d{1,3}\.){3}\d{1,3}' | grep -v "127.0.0.1" > "$DESTINO/IPS_SIMPLES.txt"
                    ip a > "$DESTINO/DETALLES_RED_COMPLETO.txt"
                ) &
                BACKUP_PID=$!
                echo -e "${V}>> Limpieza de /home y Red iniciado...${NC}"
            fi

            echo -e "\n${W}Tareas de mantenimiento:${NC}"
            echo -ne "${C}[→]${NC} Limpiando APT caché...       "
            sudo apt-get clean && echo -e "${V}[OK]${NC}"
            echo -ne "${C}[→]${NC} Borrando miniaturas...      "
            rm -rf ~/.cache/thumbnails/* && echo -e "${V}[OK]${NC}"
            echo -ne "${C}[→]${NC} Purgando carpeta /tmp...    "
            sudo find /tmp -type f -atime +1 -delete 2>/dev/null && echo -e "${V}[OK]${NC}"

            if [ -n "$USB" ]; then
                echo -e "\n${A}Sincronizando archivos...${NC}"
                while kill -0 $BACKUP_PID 2>/dev/null; do echo -ne "${V}▓${NC}"; sleep 0.4; done
                echo -e "\n${V}✓ Limpieza Completada.${NC}"
            fi
            echo -e "\n${G}──────────────────────────────────────────────────${NC}"
            echo -e "${V}ESTADO: SISTEMA OPTIMIZADO${NC}"
            echo -ne "\n${W}Presione Enter para volver...${NC}"; read
            ;;

        2|02)
            animar_entrada "RED_DIAGNOSTIC"
            titulo_seccion "MODULO DE CONECTIVIDAD"
            echo -e " ${W}Seleccione destino para el test:${NC}"
            echo -e " ${G}1.${NC} Google (DNS)   ${G}2.${NC} Cloudflare    ${G}3.${NC} Personalizado"
            echo -ne "\n ${M}Selección:${NC} "
            read red_opc
            case $red_opc in
                1) TARGET="8.8.8.8" ;;
                2) TARGET="1.1.1.1" ;;
                *) echo -ne " ${M}IP/Host:${NC} "; read TARGET ;;
            esac
            echo -e "\n${C}Enviando paquetes a $TARGET...${NC}"
            ping -c 4 $TARGET | while read line; do echo -e "  ${G}║${NC} $line"; done
            echo -ne "\n${W}Presione Enter para continuar...${NC}"; read
            ;;

        3|03)
            animar_entrada "RECURSOS_SISTEMA"
            titulo_seccion "ESTADÍSTICAS DE CARGA"
            echo -e "${W}MEMORIA RAM:${NC}"
            free -h | awk 'NR==1{print "       "$1"       "$2"       "$3} NR==2{print "  RAM: "$2"  Used: "$3"  Free: "$4}'
            echo -e "\n${W}TOP 5 PROCESOS POR CPU:${NC}"
            echo -e "${C}  PID    %CPU   %MEM   COMMAND${NC}"
            ps -eo pid,pcpu,pmem,comm --sort=-pcpu | head -n 6 | tail -n 5 | sed 's/^/  /'
            echo -ne "\n${W}Presione Enter para continuar...${NC}"; read
            ;;

        4|04)
            animar_entrada "HARDWARE_INFO"
            titulo_seccion "ESPECIFICACIONES DEL NÚCLEO"
            CPU=$(grep -m1 "model name" /proc/cpuinfo | awk -F: '{print $2}' | xargs)
            CORES=$(nproc)
            ARCH=$(uname -m)
            echo -e " ${C}┌──────────────────────────────────────────┐${NC}"
            echo -e " ${C}│${NC} ${W}PROCESADOR:${NC} $CPU"
            echo -e " ${C}│${NC} ${W}NÚCLEOS:   ${NC} $CORES Hilos"
            echo -e " ${C}│${NC} ${W}ARQUITECT.:${NC} $ARCH"
            echo -e " ${C}│${NC} ${W}KERNEL:    ${NC} $KERNEL"
            echo -e " ${C}└──────────────────────────────────────────┘${NC}"
            echo -ne "\n${W}Presione Enter para continuar...${NC}"; read
            ;;

        5|05)
            animar_entrada "SEGURIDAD_SCAN"
            titulo_seccion "AUDITORÍA DE PUERTOS (NMAP)"
            echo -ne " ${M}Ingrese IP objetivo:${NC} "
            read target_ip
            echo -e "${A}[!] Iniciando escaneo rápido de TCP...${NC}\n"
            nmap -F $target_ip | grep "/tcp" | sed 's/^/  /'
            echo -e "\n${V}Escaneo completado.${NC}"
            echo -ne "\n${W}Presione Enter para volver...${NC}"; read 
            ;;

        6|06)
            clear
            echo -e "\n\n"
            echo -e "  ${M}      ██╗      ███╗   ███╗████████╗  ${NC}"
            echo -e "  ${M}      ██║      ████╗ ████║╚══██╔══╝  ${NC}"
            echo -e "  ${M}      ██║      ██╔████╔██║   ██║     ${NC}"
            echo -e "  ${M}      ██║      ██║╚██╔╝██║   ██║     ${NC}"
            echo -e "  ${M}      ███████╗ ██║ ╚═╝ ██║   ██║     ${NC}"
            echo -e "  ${M}      ╚══════╝ ╚═╝     ╚═╝   ╚═╝     ${NC}"
            titulo_seccion "INFO DEL DESARROLLADOR"
            echo -e "  ${W}AUTOR:     ${NC} ${M}@Ismael.1509${NC}"
            echo -e "  ${W}VERSIÓN:   ${NC} 10.0 Pro Edition"
            echo -e "  ${W}ACADEMIA:  ${NC} IFPS Puenteuropa - SMR1"
            echo -e "  ${W}AÑO:       ${NC} 2025/2026"
            echo -e "\n  ${G}Este script ha sido diseñado para entornos de ciberseguridad.${NC}"
            echo -ne "\n  ${W}Presione Enter para volver...${NC}"; read 
            ;;

        7|07)
            echo -e "\n${B}────────────────────────────────────────────────────────────${NC}"
            echo -e " ${V}👋 Little Multi-Tool v10 finalizada con éxito.${NC}"
            echo -e " ${W}¡Buen trabajo, $USUARIO!${NC}"
            echo -e "${B}────────────────────────────────────────────────────────────${NC}"
            sleep 1.2
            exit 0
            ;;

        *)
            echo -e "${R}Error: Opción no reconocida.${NC}"
            sleep 1
            ;;
    esac
done
