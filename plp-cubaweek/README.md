# Apuntes de PLP
Estos apuntes son recopilaciones de las teoricas de 2C2024 y de la bibliografia sugerida.
- [Apunte de cálculo lambda](/pdf/calculolambda.pdf)
- [Apunte para el primer parcial](/pdf/calculolambda.pdf)
- [Apunte para el segundo parcial](/pdf/calculolambda.pdf)

## Modificaciones
Se agradece cualquier tipo de modificación/corrección o aporte. 
Para esto dejo el src code en markdown:
- [Apunte de cálculo lambda](/src/calculolambda.md)
- [Apunte para el primer parcial](/src/calculolambda.md)
- [Apunte para el segundo parcial](/src/calculolambda.md)

### Recompilar
Para recompilar se puede usar cualquier herramienta para convertir de markdown a pdf. Yo usé `md-to-pdf` ([repo](https://github.com/simonhaenisch/md-to-pdf)).

Instalar usando npm
```
npm i -g md-to-pdf
```

Recompilar el mardown modificado a pdf
```
md-to-pdf --basedir . < src/FILE.md > pdf/FILE.pdf
```