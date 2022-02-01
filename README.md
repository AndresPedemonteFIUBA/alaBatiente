# Caso alaBatiente

## Condiciones de contorno personalizadas

### CalculiX

Compilar el adaptador de CalculiX reemplazando el archivo `uboun.f` del código fuente de CCX con el provisto en la carpeta `custom-CCX-BC`.

#### Dependencias adicionales

Para entornos conda instalados, la librería en paralelo mpicc necesita:
  - conda install openmpi-mpicc
  - conda install -c conda-forge sysroot_linux-64
  - conda install -c conda-forge c-compiler compilers cxx-compiler
  
  - sudo apt install flibc6-dev-i386      
  fuente: https://stackoverflow.com/questions/54082459/fatal-error-bits-libc-header-start-h-no-such-file-or-directory-while-compili/54082790

### OpenFOAM

Llevar la carpeta `custom-OF-BC` a, por ejemplo, `$FOAM_RUN`. En la carpeta, abrir la terminal y escribir `libso wmake`. Esperar a que termine. Listo, ya se puede usar la condición `rampAngularOscillatingDisplacement` en cualquier case de OpenFOAM.

## Utilidades

En la carpeta utilidades hay un archivo para habilitar el syntax highlighting para el formato de los archivos de CalculiX en `gedit`. Hay que colocarlo en `usr/share/gtksourceview-4/language-specs`. Se puede habilitar (en el gedit) también para cualquier otro formato de archivo (`.nam`, `.msh`).


