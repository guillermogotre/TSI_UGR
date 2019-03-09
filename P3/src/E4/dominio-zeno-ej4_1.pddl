(define (domain zeno-travel)


(:requirements
  :typing
  :fluents
  :derived-predicates
  :negative-preconditions
  :universal-preconditions
  :existential-preconditions
  :disjuntive-preconditions
  :conditional-effects
  :htn-expansion

  ; Requisitos adicionales para el manejo del tiempo
  :durative-actions
  :metatags

  :equality
 )

(:types aircraft person city - object)
(:constants slow fast - object)
(:predicates (at ?x - (either person aircraft) ?c - city)
             (available ?x -person ?c - city)
             (in ?p - person ?a - aircraft)
             (different ?x ?y) (igual ?x ?y)
             (hay-fuel-fast ?a ?c1 ?c2)
             (hay-fuel-slow ?a ?c1 ?c2)
             (llega-fast ?a ?c1 ?c2)
             (llega-slow ?a ?c1 ?c2)
             (destino ?x -person ?c -city)
             (seatsLeft ?a - aircraft)
             (debark-stage-pending ?a - aircraft)
             (board-stage-pending ?a - aircraft)
             (fly-stage-pending ?a - aircraft)
             (max-to ?a -aircraft ?c -city)
             (pending ?p -person)
             )
(:functions (fuel ?a - aircraft)
            (distance ?c1 - city ?c2 - city)
            (slow-speed ?a - aircraft)
            (fast-speed ?a - aircraft)
            (slow-burn ?a - aircraft)
            (fast-burn ?a - aircraft)
            (capacity ?a - aircraft)
            (refuel-rate ?a - aircraft)
            (fuel-limit ?a - aircraft)
            (total-fuel-used ?a - aircraft)
            (boarding-time)
            (debarking-time)
            (board-limit ?a - aircraft)
            (onboard-to ?a -aircraft ?c -city)
            ;(maxtime ?a -aircraft)
            )

;; el consecuente "vac�o" se representa como "()" y significa "siempre verdad"
(:derived
  (igual ?x ?y) ())

(:derived 
  (different ?x ?y) (not (igual ?x ?y)))



;; este literal derivado se utiliza para deducir, a partir de la información en el estado actual, 
;; si hay fuel suficiente para que el avión ?a vuele de la ciudad ?c1 a la ?c2
;; el antecedente de este literal derivado comprueba si el fuel actual de ?a es mayor que 1. 
;; En este caso es una forma de describir que no hay restricciones de fuel. Pueden introducirse una
;; restricción más copleja  si en lugar de 1 se representa una expresión más elaborada (esto es objeto de
;; los siguientes ejercicios).
(:derived 
  (hay-fuel-fast ?a - aircraft ?c1 - city ?c2 - city)
        (>= (fuel ?a) (* (distance ?c1 ?c2)(fast-burn ?a)))
)
(:derived 
  (hay-fuel-slow ?a - aircraft ?c1 - city ?c2 - city)
        (>= (fuel ?a) (* (distance ?c1 ?c2)(slow-burn ?a)))
)

(:derived 
  (llega-fast ?a -aircraft ?c1 - city ?c2 -city)
    (and
      (distance ?c1 ?c2)
      (>= (capacity ?a) (* (distance ?c1 ?c2)(fast-burn ?a)))
      (>= (fuel-limit ?a) (+(total-fuel-used ?a) (* (distance ?c1 ?c2)(fast-burn ?a))))
      ;(>= (maxtime ?a) (+(etime ?a) (*(distance ?c1 ?c2)(fast-speed ?a))))
    )
)

(:derived 
  (llega-slow ?a -aircraft ?c1 - city ?c2 -city)
    (and
      (distance ?c1 ?c2)
      (>= (capacity ?a) (* (distance ?c1 ?c2)(slow-burn ?a)))
      (>= (fuel-limit ?a ) (+(total-fuel-used ?a) (* (distance ?c1 ?c2)(slow-burn ?a))))
      ;(>= (maxtime ?a) (+(etime ?a) (*(distance ?c1 ?c2)(slow-speed ?a))))
    )
)

(:derived
  (seatsLeft ?a -aircraft)
  (> (board-limit ?a) 0)
)

(:derived
  (available ?p - person ?c -city)
  (and (at ?p ?c) (destino ?p ?c2))
)

(:task goal-task
  :parameters ()
  (:method Config
    :precondition ()
    :tasks (
      (add-destination-counter)
      (travel-planner)
    )
  )
)

(:task travel-planner
  :parameters ()
  (:method Case1
    :precondition (and
      (destino ?p - person ?c - city)
    )
    :tasks (
      (board-stage)
      ;(fly-stage)
      ;(debark-stage)
      ;(travel-planner)
    )
  )
  (:method Base
    :precondition ()
    :tasks ()
  )
)

(:task fly-stage
  :parameters ()
  (:method Indirect-flight
    :precondition (and
      (fly-stage-pending ?a)
      (> (board-limit ?a) 0)
      (at ?a -aircraft ?c1 - city)
      (available ?p - person ?c2 - city)
      (not (pending ?p))
      (not (= ?c1 ?c2))
      (destino ?p -person ?c3 - city)
      (> (onboard-to ?a ?c3) 0)
      (llega-slow ?a ?c1 ?c2)
    )
    :tasks (
      (mover-avion ?a ?c1 ?c2)
      (:inline () (and 
        (pending ?p)
        (not (fly-stage-pending ?a))
        (debark-stage-pending ?a)
      ))
      (debark-stage)
    )
  )
  (:method Direct-flight
    :precondition (and
      (fly-stage-pending ?a)
      (in ?tp ?a)
    )
    :tasks(
      (calc-max-destination ?a)
      (fly-max ?a)
    )
  )
  (:method Empty-plane
    :precondition (and
      (fly-stage-pending ?a)
      (at ?a - aircraft ?c1 - city)
      (available ?p - person ?c2 - city)
      (not (pending ?p))
      (not (= ?c1 ?c2))
      (llega-slow ?a ?c1 ?c2)
    )
    :tasks(
      (mover-avion ?a ?c1 ?c2)
      (:inline () (and 
        (pending ?p)
        (not (fly-stage-pending ?a))
        (debark-stage-pending ?a)
      ))
      (debark-stage)
    )
  )
  
)

(:task fly-max
  :parameters (?a - aircraft)
  (:method m1
    :precondition (and 
    (at ?a - aircraft ?c1 - city)
    (max-to ?a - aircraft ?c2 -city)
    (llega-slow ?a ?c1 ?c2)
  )
  :tasks(
    (mover-avion ?a ?c1 ?c2)
    (:inline () (and 
        (not (fly-stage-pending ?a))
        (debark-stage-pending ?a)
      ))
      (debark-stage)
  )
  )
)

(:task calc-max-destination
  :parameters (?a - aircraft)
  (:method m1
    :precondition (and
      (max-to ?a ?c1)
      (destino ?tp ?c2)
      (at ?a ?c3)
      (not (= ?c1 ?c2))
      (or
        (> (onboard-to ?a ?c2) (onboard-to ?a ?c1))
        (= ?c1 ?c3)
      )
    )
    :tasks(
      (:inline () (and
        (max-to ?a ?c2)
        (not (max-to ?a ?c1))
      ))
      (calc-max-destination ?a)
    )
  )
  (:method base
    :precondition ()
    :tasks()
  )
)

(:task debark-stage
  :parameters ()
  (:method At-destination
    :precondition (and
      (debark-stage-pending ?a)
      (in ?p - person ?a - aircraft)
      (at ?a - aircraft ?c - city)
      (destino ?p - person ?c - city)
    )
    :tasks(
      (debark ?p ?a ?c)
      ;(:inline () (not (destino ?p ?c)))
      (destino-done ?p ?c)
      (:inline () (decrease (onboard-to ?a ?c) 1))
      (debark-stage)
    )
  )
  (:method Base
    :precondition (and
      (debark-stage-pending ?a - aircraft)
    )
    :tasks(
      (:inline () (and
        (not (debark-stage-pending ?a))
        (board-stage-pending ?a)
      ))
      (debark-stage)
    )
  )
  (:method continue
    :precondition (destino ?p - person ?c -city)
    :tasks(
      (board-stage)
    )
  )
  (:method finish
    :precondition (not (destino ?p - person ?c -city))
    :tasks ()
  )
)

(:action destino-done
  :parameters (?p - person ?c -city)
  :precondition ()
  :effect (and
    (not (destino ?p ?c))
  )
)

(:task board-stage
  :parameters ()
  (:method Seats-left
    :precondition (and
      (board-stage-pending ?a - aircraft)
      (at ?a -aircraft ?c -city)
      (available ?p -person ?c -city)
      (destino ?p - person ?c2 -city)
      (> (board-limit ?a) 0)
    )
    :tasks(
      (board ?p ?a ?c)
      (:inline () (and 
        (increase (onboard-to ?a ?c2) 1)
        (not (pending ?p))
      ))   
      (board-stage)   
    )
  )
  (:method No-seats-left-priority
    :precondition (and
      (board-stage-pending ?a - aircraft)
      (at ?a -aircraft ?c -city)
      (available ?p -person ?c -city)
      (not (> (board-limit ?a) 0))
      (in ?p2 - person ?a - aircraft)
      (destino ?p - person ?c1 -city)
      (destino ?p2 - person ?c2 -city)
      (not (= ?c1 ?c2))
      (> (onboard-to ?a ?c1) (onboard-to ?a ?c2))
    )
    :tasks(
      (debark ?p2 ?a ?c)
      (:inline () (and 
        (decrease (onboard-to ?a ?c2) 1)
      ))
      (board ?p ?a ?c) 
      (:inline () (and 
        (increase (onboard-to ?a ?c1) 1)
        (not (pending ?p))
      ))      
      (board-stage)  
    )
  )
  (:method base
    :precondition (and
      (board-stage-pending ?a - aircraft)
    )
    :tasks(
      (:inline () (and
        (not (board-stage-pending ?a))
        (fly-stage-pending ?a)
      ))
      (fly-stage)
    )
  )
)

(:task transport-person
	:parameters (?p - person ?c - city)
	
  (:method Case1 ; si la persona est� en la ciudad no se hace nada
	 :precondition (at ?p ?c)
	 :tasks ()
   )
	 
   
   (:method Case2 ;si no est� en la ciudad destino, pero avion y persona est�n en la misma ciudad
	  :precondition (and (at ?p - person ?c1 - city)
			                 (at ?a - aircraft ?c1 - city))
				     
	  :tasks ( 
	  	      (board ?p ?a ?c1)
            (:inline () (decrease (onboard-to ?a ?c) 1))
		        (mover-avion ?a ?c1 ?c)
		        (debark ?p ?a ?c )))
    
    (:method Case3 ;si no está en la ciudad destino, y la persona y avion en distinta ciudad)
    :precondition (and 
                      (at ?p - person ?c1)
                      (and
                        (at ?a - aircraft ?c2 - city)
                        (not (= ?c1 ?c2))
                      )
                  )
    :tasks (
              (mover-avion ?a ?c2 ?c1)
              (transport-person ?p ?c)
            )
    )
	)

(:task mover-avion
  :parameters (?a - aircraft ?c1 - city ?c2 -city)
  (:method fuel-suficiente-fast ;; este método se escogerá para usar la acción fly siempre que el avión tenga fuel para
                          ;; volar desde ?c1 a ?c2
			  ;; si no hay fuel suficiente el método no se aplicará y la descomposición de esta tarea
			  ;; se intentará hacer con otro método. Cuando se agotan todos los métodos posibles, la
			  ;; descomponsición de la tarea mover-avión "fallará". 
			  ;; En consecuencia HTNP hará backtracking y escogerá otra posible vía para descomponer
			  ;; la tarea mover-avion (por ejemplo, escogiendo otra instanciación para la variable ?a)
    :precondition (and
        (hay-fuel-fast ?a ?c1 ?c2)
        (llega-fast ?a ?c1 ?c2)
    )
    :tasks (
          (zoom ?a ?c1 ?c2)
         )
  )
  (:method fuel-insuficiente-fast
    :precondition (and
      (llega-fast ?a ?c1 ?c2)
    )
    :tasks (
        (refuel ?a ?c1)
        (mover-avion ?a ?c1 ?c2)
    )
  )
  (:method fuel-suficiente-slow ;; este método se escogerá para usar la acción fly siempre que el avión tenga fuel para
                          ;; volar desde ?c1 a ?c2
			  ;; si no hay fuel suficiente el método no se aplicará y la descomposición de esta tarea
			  ;; se intentará hacer con otro método. Cuando se agotan todos los métodos posibles, la
			  ;; descomponsición de la tarea mover-avión "fallará". 
			  ;; En consecuencia HTNP hará backtracking y escogerá otra posible vía para descomponer
			  ;; la tarea mover-avion (por ejemplo, escogiendo otra instanciación para la variable ?a)
    :precondition (and
        (hay-fuel-slow ?a ?c1 ?c2)
        (llega-slow ?a ?c1 ?c2)
    )
    :tasks (
          (fly ?a ?c1 ?c2)
         )
  )
  (:method fuel-insuficiente
    :precondition (and
      (llega-slow ?a ?c1 ?c2)
    )
    :tasks (
        (refuel ?a ?c1)
        (mover-avion ?a ?c1 ?c2)
    )
  )
)

(:action add-destination-counter
  :parameters ()
  :precondition (destino ?tp ?tc)
  :effect (and
    (forall (?a - aircraft ?c - city)
                (when ()
                  (assign (onboard-to ?a ?c) 0)
                )
        )
    (forall (?a - aircraft)
      (when ()
        (and  
          (board-stage-pending ?a)
          (max-to ?a ?tc)
          ;(assign (etime ?a) 0)
        )
      )
    )
  )
)

(:import "Primitivas-Zenotravel_ej4_1.pddl") 


)
