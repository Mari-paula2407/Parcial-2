% Use this editor as a MiniZinc scratch book
int: num_disciplinas = 4;
int: num_participantes = 6;
int: num_lugares = 2;

% Duraciones de las disciplinas
array[1..num_disciplinas] of int: duracion_disciplina = [2, 3, 1, 2];

% Capacidad de los lugares
array[1..num_lugares] of int: capacidad_lugar = [5, 6];

% Variables para el lugar asignado a cada disciplina (1..2 porque hay 2 lugares)
array[1..num_disciplinas] of var 1..num_lugares: lugar;

% Variables para el inicio de cada disciplina
array[1..num_disciplinas] of var 0..10: inicio_disciplina;

% Variables para el fin de cada disciplina
array[1..num_disciplinas] of var int: fin_disciplina;

% Variables para asignar participantes (1..6 porque hay 6 participantes)
array[1..num_disciplinas, 1..num_participantes] of var bool: participa;

% Restricción: Cada disciplina tiene que terminar al sumarle su duración
constraint forall(i in 1..num_disciplinas)(
    fin_disciplina[i] = inicio_disciplina[i] + duracion_disciplina[i]
);

% Restricción: Los lugares no pueden ser usados simultáneamente
constraint forall(i, j in 1..num_disciplinas where i != j)(
    lugar[i] = lugar[j] -> fin_disciplina[i] <= inicio_disciplina[j] \/ fin_disciplina[j] <= inicio_disciplina[i]
);

% Restricción: Los participantes no pueden competir en más de una disciplina al mismo tiempo
constraint forall(i, j in 1..num_disciplinas, p in 1..num_participantes where i != j)(
    participa[i, p] + participa[j, p] <= 1 -> fin_disciplina[i] <= inicio_disciplina[j] \/ fin_disciplina[j] <= inicio_disciplina[i]
);

% Restricción: Cada lugar tiene una capacidad máxima
constraint forall(l in 1..num_lugares)(
    sum([duracion_disciplina[i] | i in 1..num_disciplinas where lugar[i] = l]) <= capacidad_lugar[l]
);

% Restricción: Al menos un participante asignado por disciplina
constraint forall(i in 1..num_disciplinas)(
    sum([participa[i, p] | p in 1..num_participantes]) >= 1
);

% Función objetivo: minimizar el makespan (tiempo total del evento)
var int: makespan = max([fin_disciplina[i] | i in 1..num_disciplinas]);
solve minimize makespan;

% Salida
output [
    "Lugar asignado: ", show(lugar), "\n",
    "Inicio de disciplinas: ", show(inicio_disciplina), "\n",
    "Fin de disciplinas: ", show(fin_disciplina), "\n",
    "Makespan (Tiempo total): ", show(makespan), "\n"
];
