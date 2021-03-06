(define (problem EJ1) (:domain BELKAN)
(:objects 
    loc1 loc2 loc3 loc4 loc5 loc6 loc7 loc8 loc9 loc10 loc11 loc12 loc13 loc14 loc15 loc16 loc17 loc18 loc19 loc20 loc21 loc22 loc23 loc24 loc25 - location
    princesa principe bruja profesor leonardo - character
    manzana rosa algoritmo oro oscar - gift
    robot1 - robot
    norte sur este oeste - orientation
)

(:init
    ;map
    (link loc1 loc2 este)
    (link loc2 loc1 oeste)
    (link loc3 loc4 este)
    (link loc4 loc3 oeste)
    (link loc4 loc5 este)
    (link loc5 loc4 oeste)
    (link loc6 loc7 este)
    (link loc7 loc6 oeste)
    (link loc7 loc8 este)
    (link loc8 loc7 oeste)
    (link loc8 loc9 este)
    (link loc9 loc8 oeste)
    (link loc11 loc12 este)
    (link loc12 loc11 oeste)
    (link loc12 loc13 este)
    (link loc13 loc12 oeste)
    (link loc13 loc14 este)
    (link loc14 loc13 oeste)
    (link loc14 loc15 este)
    (link loc15 loc14 oeste)
    (link loc16 loc17 este)
    (link loc17 loc16 oeste)
    (link loc17 loc18 este)
    (link loc18 loc17 oeste)
    (link loc19 loc20 este)
    (link loc20 loc19 oeste)
    (link loc21 loc22 este)
    (link loc22 loc21 oeste)
    (link loc22 loc23 este)
    (link loc23 loc22 oeste)
    (link loc23 loc24 este)
    (link loc24 loc23 oeste)
    (link loc24 loc25 este)
    (link loc25 loc24 oeste)
    (link loc1 loc6 sur)
    (link loc6 loc1 norte)
    (link loc11 loc16 sur)
    (link loc16 loc11 norte)
    (link loc2 loc7 sur)
    (link loc7 loc2 norte)
    (link loc7 loc12 sur)
    (link loc12 loc7 norte)
    (link loc12 loc17 sur)
    (link loc17 loc12 norte)
    (link loc17 loc22 sur)
    (link loc22 loc17 norte)
    (link loc3 loc8 sur)
    (link loc8 loc3 norte)
    (link loc13 loc18 sur)
    (link loc18 loc13 norte)
    (link loc4 loc9 sur)
    (link loc9 loc4 norte)
    (link loc14 loc19 sur)
    (link loc19 loc14 norte)
    (link loc5 loc10 sur)
    (link loc10 loc5 norte)
    (link loc10 loc15 sur)
    (link loc15 loc10 norte)
    (link loc15 loc20 sur)
    (link loc20 loc15 norte)
    (link loc20 loc25 sur)
    (link loc25 loc20 norte)

    ;position
    (at princesa loc1)
    (at principe loc5)
    (at bruja loc21)
    (at profesor loc25)
    (at leonardo loc13)
    (at oscar loc7)
    (at manzana loc9)
    (at rosa loc17)
    (at algoritmo loc19)
    (at oro loc13)

    ;space
    (right norte este)
    (right este sur)
    (right sur oeste)
    (right oeste norte)

    (left norte oeste)
    (left oeste sur)
    (left sur este)
    (left este norte)

    ;robot
    (at robot1 loc1)
    (facing robot1 norte)
    (handEmpty robot1)
)

(:goal (and
    ;todo: put the goal condition here
        (hasGift princesa)
        (hasGift principe)
        (hasGift bruja)
        (hasGift profesor)
        (hasGift leonardo)
    )
)

;un-comment the following line if metric is needed
;(:metric minimize (???))
)
