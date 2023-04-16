# Trabajo practico de Algoritmos y Estructuras de Datos con Pascal
Ante la actual situación internacional del coronavirus, se ha considerado oportuno diseñar e 
implementar un sistema de “enfermedades epidemiológicas” a nivel nacional.

Considerando que todo diseño de software parte de un relevamiento, a continuación ofrecemos el 
siguiente detalle.

Se conoce la existencia de varias enfermedades epidemiológicas en el país como dengue, sarampión 
fiebre hemorrágica, hantavirus, etc., pero dicho enunciado no acota a que aparezcan nuevas 
enfermedades como el actual coronavirus ó la gripe A de años anteriores, por tal motivo se recomienda 
asignarle un código a cada nombre de la enfermedad.

Cada enfermedad tiene asignado un conjunto de síntomas (como máximo 6) perfectamente 
identificables, ejemplo: fiebre, dolor de cabeza, mareos, naúseas, diarrea, vómito, tos, resfrío, ojos 
inflamados, etc.

Lo que hay que tener en cuenta es que varias enfermedades pueden tener un mismo síntoma en común, 
ejemplo dengue y coronavirus ambas presentan fiebre. Por tal motivo también se codificarán los 
síntomas para su fácil identificación.

Este sistema nacional tiene como objetivo principal llevar una estadística para el país, la cual pueda ser 
de público conocimiento.

Las estadísticas surgen de analizar los casos presentados en todos los hospitales y sanatorios, quienes 
enviarán los datos y se centralizarán en este sistema.

Los datos que se recibirán están relacionados a los pacientes atendidos en cada efector.

Del paciente se conoce su DNI, edad, letra identificatoria de la provincia en la que fue atendido, la 
cantidad de enfermedades epimediológicas adquiridas, si la persona fue curada (S/N) y si la persona ha 
fallecido (S/N).

De la cantidad de enfermedades que presenta cada paciente, se recibe una historia clínica que establece 
el código de la enfermedad por la que fue atendido, los códigos de los síntomas que presentó (cómo 
máximo 6), fecha de diagnóstico y nombre del efector que envía la historia clínica.

Para agilizar el proceso de identificación de provincias, las mismas estarán codificadas con una letra del 
alfabeto según la [norma ISO](https://es.wikipedia.org/wiki/ISO_3166-2:AR)
