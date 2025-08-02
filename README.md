# Cifrado Afín (Affine Cipher) en MIPS Assembly
# Arquitectura de Computadores y Laboratorio UdeA
# Programación en ensamblador MIPS-32

## Descripción
Este proyecto implementa la técnica de cifrado afín en lenguaje ensamblador MIPS. Toma un archivo de texto (≤ 1 KiB), lo cifra con la ecuación

$$
C(x) = (a \cdot x + b)\bmod 98
$$

y guarda el resultado en `criptogram.txt`. Luego descifra ese archivo usando

$$
P(x) = a^{-1}\,\bigl(C(x) - b\bigr)\bmod 98
$$

y genera `decoded.txt`, idéntico al original.

Si desea conocer en detalle el proyecto, revise el archivo PDF el cual documenta por completo el laboratorio.
