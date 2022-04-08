# Caso alaBatiente

## Ramas

Actualmente:
* `conBlockMesh` branch -> malla hecha a manopla con blockMesh. blockMeshDict paramétrico.

Dentro de poco, imagen de cómo está construida la malla con blockMesh.

## Condiciones de contorno personalizadas

### CalculiX

Compilar el adaptador de CalculiX reemplazando el archivo `uboun.f` del código fuente de CCX con el provisto en la carpeta `custom-CCX-BC`.

### OpenFOAM

Llevar la carpeta `custom-OF-BC` a, por ejemplo, `$FOAM_RUN`. En la carpeta, abrir la terminal y escribir `wmake libso`. Esperar a que termine. Listo, ya se puede usar la condición `rampAngularOscillatingDisplacement` en cualquier case de OpenFOAM.

Para usar los 8 núcleos de la compu del labo: `mpirun --use-hwthread-cpus ...`

## PostProcessing

En la carpeta `fluid/system` ya están los archivos necesarios para correr:

`pimpleFoam -postProcess -func forcesIncompressible [-time a:b]` (el último parámetro es opcional para calcular solo desde el instante `a` hasta el `b`)


y
`pimpleFoam -postProcess -func forceCoeffsIncompressible [-time a:b]` (coeficientes de fuerzas)

Para juntar archivos `forceCoeffs_*.dat` usar `head -9 forceCoeffs.dat > forceCoefficients.dat && tail -n +10 -q forceCoeff*.dat >> forceCoefficients.dat`

## Distintas frecuencias de pitching

Para ajustar la frecuencia hay que modificar en dos lugares:

* En FOAM, en el archivo `pointDisplacement` en la carpeta `0` hay que modificar el valor de `f`. Va en hertz.
* En ala.inp, cambiar el primer número en la línea siguiente a `*CONDUCTIVITY`. Va en hertz y debe ser el mismo valor que el especificado en `pointDisplacement`.
## ¿Problemas al compilar?

Si tenés Anaconda, usar `conda deactivate` antes de compilar los programas.

https://github.com/precice/openfoam-adapter/issues/202
https://github.com/precice/openfoam-adapter/pull/203

## Utilidades

En la carpeta utilidades hay un archivo para habilitar el syntax highlighting para el formato de los archivos de CalculiX en `gedit`. Hay que colocarlo en `usr/share/gtksourceview-4/language-specs`. Se puede habilitar (en el gedit) también para cualquier otro formato de archivo (`.nam`, `.msh`).

## Videos





| Frecuencia de forzado | Video                                                                                                 |
|-----------------------|-------------------------------------------------------------------------------------------------------|
|    10 Hz              | https://user-images.githubusercontent.com/67233283/162450629-338a0054-5fb6-4418-9409-78406615b3ab.mp4 |
|-----------------------|-------------------------------------------------------------------------------------------------------|
|    12 Hz              | https://user-images.githubusercontent.com/67233283/162450802-1edf8ea3-df82-408d-a870-a89cb404e90c.mp4 |
|-----------------------|-------------------------------------------------------------------------------------------------------|
|    14 Hz              | https://user-images.githubusercontent.com/67233283/162450892-e684f0d0-e2f9-4bce-8406-9ca54a04c924.mp4 |
|-----------------------|-------------------------------------------------------------------------------------------------------|
|    16 Hz              |                                                                                                       |
|-----------------------|-------------------------------------------------------------------------------------------------------|
|    18 Hz              |                                                                                                       |
|-----------------------|-------------------------------------------------------------------------------------------------------|
|    20 Hz              | https://user-images.githubusercontent.com/67233283/162451126-128a5b93-1687-4bc5-92d5-624a8ff0ae4e.mp4 |
|-----------------------|-------------------------------------------------------------------------------------------------------|


