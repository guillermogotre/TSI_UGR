(define (problem zeno-0) (:domain zeno-travel)
(:customization
(= :time-format "%d/%m/%Y %H:%M:%S")
(= :time-horizon-relative 2500)
(= :time-start "05/06/2007 08:00:00")
(= :time-unit :hours))

(:objects 
    p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12 p13 p14 p15 p16 p17 p18 p19 p20 - person
    almeria granada madrid sevilla - city
    a1 a2 - aircraft
)
(:init
    (at p1 almeria) 
    (at p2 almeria)
    (at p3 almeria)
    (at p4 almeria)
    (at p5 almeria)
    (at p6 granada)
    (at p7 granada)
    (at p8 granada)
    (at p9 granada)
    (at p10 granada)
    (at p11 madrid)
    (at p12 madrid)
    (at p13 madrid)
    (at p14 madrid)
    (at p15 madrid)
    (at p16 sevilla)
    (at p17 sevilla)
    (at p18 sevilla)
    (at p19 sevilla)
    (at p20 sevilla)
    
    (at a1 sevilla)
    ;(at a2 madrid)

    (= (fuel-limit a1) 100000)
    (= (fuel-limit a2) 100000)
    ;(= (fuel-limit) 900)
    (= (distance almeria granada) 162)
    (= (distance almeria madrid) 547)
    (= (distance almeria sevilla) 410)
    (= (distance granada almeria) 162)
    (= (distance granada madrid) 421)
    (= (distance granada sevilla) 252)
    (= (distance madrid almeria) 547)
    (= (distance madrid granada) 421)
    (= (distance madrid sevilla) 534)
    (= (distance sevilla almeria) 410)
    (= (distance sevilla granada) 252)
    (= (distance sevilla madrid) 534)

    ;a1 config
    (= (fuel a1) 200)
    (= (slow-speed a1) 10)
    (= (fast-speed a1) 20)
    (= (slow-burn a1) 1)
    (= (fast-burn a1) 2)
    (= (capacity a1) 1100)
    (= (refuel-rate a1) 1)
    (= (board-limit a1) 10)
    ;(= (maxtime a1) 10000)

    ;a2 config
    (= (fuel a2) 200)
    (= (slow-speed a2) 10)
    (= (fast-speed a2) 20)
    (= (slow-burn a2) 1)
    (= (fast-burn a2) 2)
    (= (capacity a2) 1100)
    (= (refuel-rate a2) 1)
    (= (board-limit a2) 10)
    ;(= (maxtime a2) 10000)


    (= (total-fuel-used a1) 0)
    (= (total-fuel-used a2) 0)
    (= (boarding-time) 1)
    (= (debarking-time) 1)



    ;destinos
    (destino p1 granada)
    (destino p2 sevilla) 
    (destino p3 sevilla)
    (destino p4 madrid)
    (destino p5 madrid)
    (destino p6 sevilla)
    (destino p7 sevilla)
    (destino p8 sevilla)
    (destino p9 almeria)
    (destino p10 granada)
    (destino p11 granada)
    (destino p12 sevilla) 
    (destino p13 sevilla)
    (destino p14 madrid)
    (destino p15 madrid)
    (destino p16 sevilla)
    (destino p17 sevilla)
    (destino p18 sevilla)
    (destino p19 almeria)
    (destino p20 almeria)
 )


(:tasks-goal
   :tasks(
    (goal-task)
   )
  )
)
   
    
    
    

    
