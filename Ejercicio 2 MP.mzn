int: num_productos = 5;
int: num_estanterias = 3;

% Volúmenes de los productos
array[1..num_productos] of int: volumen_productos = [4, 3, 5, 2, 1];

% Capacidad máxima de las estanterías
array[1..num_estanterias] of int: capacidad_estanteria = [8, 6, 5];

% Tiempos de entrega de los productos (en días)
array[1..num_productos] of int: tiempo_entrega = [2, 5, 3, 1, 4];

% Prioridades de los productos (valores más bajos representan mayor prioridad)
array[1..num_productos] of int: prioridad = [2, 5, 3, 1, 4];

% Variable para asignar productos a estanterías (1..num_estanterias)
array[1..num_productos] of var 1..num_estanterias: estanteria;

% Restricción de capacidad: la suma de los volúmenes de productos en cada estantería no puede exceder su capacidad
constraint forall(e in 1..num_estanterias)(
    sum([volumen_productos[i] | i in 1..num_productos where estanteria[i] = e]) <= capacidad_estanteria[e]
);

% Restricciones de incompatibilidad entre productos
% Ejemplo: Producto 1 y Producto 3 no pueden estar en la misma estantería
constraint estanteria[1] != estanteria[3];

% Minimizar el espacio total utilizado
% Aquí no se minimiza directamente el espacio, sino que se garantiza que los productos sean asignados respetando las capacidades.
solve satisfy;

% Salida: mostrar la estantería asignada para cada producto
output [
    "Estantería asignada para cada producto: ", show(estanteria), "\n",
    "Tiempo de entrega: ", show(tiempo_entrega), "\n",
    "Prioridad de productos: ", show(prioridad), "\n"
];
