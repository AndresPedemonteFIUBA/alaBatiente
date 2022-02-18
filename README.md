# Caso alaBatiente

## Ramas

Actualmente:
* `main` branch -> malla hecha con snappy (podría mejorarse un poco; quizás necesitas algunos puntos más en la capa límite).
* `conBlockMesh` branch -> malla hecha a manopla con blockMesh. blockMeshDict paramétrico. Podría limpiarse un poco.

Dentro de poco, imagen de cómo está construida la malla con blockMesh.

## Condiciones de contorno personalizadas

### CalculiX

Compilar el adaptador de CalculiX reemplazando el archivo `uboun.f` del código fuente de CCX con el provisto en la carpeta `custom-CCX-BC`.

### OpenFOAM

Llevar la carpeta `custom-OF-BC` a, por ejemplo, `$FOAM_RUN`. En la carpeta, abrir la terminal y escribir `wmake libso`. Esperar a que termine. Listo, ya se puede usar la condición `rampAngularOscillatingDisplacement` en cualquier case de OpenFOAM.

### Arranque

Si se quiere arranque "suave" (aumentos progresivos de amplitud y frecuencia entre 0 y 1 segundo), comentar la línea 154 de `uboun.f` y dejar sin comentar las líneas 148 a 152. 

Para un arranque con amplitud y frecuencia "nominales" de una, comentar las líneas 148 a 152 y descomentar la 154 de `uboun.f`. Cambiar la condición de contorno del patch `cylinder` de `rampAngularOscillatingDisplacement` a `angularOscillatingDisplacement` en `0/pointDisplacement`.

## Distintas frecuencias de pitching

Para ajustar la frecuencia hay que modificar en dos lugares:

* En FOAM, en el archivo `pointDisplacement` en la carpeta `0` hay que modificar el valor de `omega`. Va en radianes.
* Al cambiar la frecuencia hay que recompilar CalculiX. Hay que ir a la fuente de CCX y modificar la variable `omega` en el archivo `uboun.f`; después recompilar `ccx_precice`.

## ¿Problemas al compilar?

Si tenés Anaconda, usar `conda deactivate` antes de compilar los programas.

https://github.com/precice/openfoam-adapter/issues/202
https://github.com/precice/openfoam-adapter/pull/203

## Utilidades

En la carpeta utilidades hay un archivo para habilitar el syntax highlighting para el formato de los archivos de CalculiX en `gedit`. Hay que colocarlo en `usr/share/gtksourceview-4/language-specs`. Se puede habilitar (en el gedit) también para cualquier otro formato de archivo (`.nam`, `.msh`).
