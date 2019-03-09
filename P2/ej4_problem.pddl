(define (problem EJ1) (:domain BELKAN)
(:objects 
    loc1 loc2 loc3 loc4 loc5 loc6 loc7 loc8 loc9 loc10 loc11 loc12 loc13 loc14 loc15 loc16 loc17 loc18 loc19 loc20 loc21 loc22 loc23 loc24 loc25 - location
    princesa principe bruja profesor leonardo - character
    oscar manzana rosa algoritmo oro -gift
    robot1 - robot
    norte sur este oeste - orientation
    bosque agua precipicio arena piedra - groundKind
    zapatilla bikini - wear
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
    (= (linkLength loc1 loc2) 1)
    (= (linkLength loc2 loc1) 1)
    (= (linkLength loc3 loc4) 1)
    (= (linkLength loc4 loc3) 1)
    (= (linkLength loc4 loc5) 1)
    (= (linkLength loc5 loc4) 1)
    (= (linkLength loc6 loc7) 1)
    (= (linkLength loc7 loc6) 1)
    (= (linkLength loc7 loc8) 1)
    (= (linkLength loc8 loc7) 1)
    (= (linkLength loc8 loc9) 1)
    (= (linkLength loc9 loc8) 1)
    (= (linkLength loc11 loc12) 1)
    (= (linkLength loc12 loc11) 1)
    (= (linkLength loc12 loc13) 1)
    (= (linkLength loc13 loc12) 1)
    (= (linkLength loc13 loc14) 1)
    (= (linkLength loc14 loc13) 1)
    (= (linkLength loc14 loc15) 1)
    (= (linkLength loc15 loc14) 1)
    (= (linkLength loc16 loc17) 1)
    (= (linkLength loc17 loc16) 1)
    (= (linkLength loc17 loc18) 1)
    (= (linkLength loc18 loc17) 1)
    (= (linkLength loc19 loc20) 1)
    (= (linkLength loc20 loc19) 1)
    (= (linkLength loc21 loc22) 1)
    (= (linkLength loc22 loc21) 1)
    (= (linkLength loc22 loc23) 1)
    (= (linkLength loc23 loc22) 1)
    (= (linkLength loc23 loc24) 1)
    (= (linkLength loc24 loc23) 1)
    (= (linkLength loc24 loc25) 1)
    (= (linkLength loc25 loc24) 1)
    (= (linkLength loc1 loc6) 1)
    (= (linkLength loc6 loc1) 1)
    (= (linkLength loc11 loc16) 1)
    (= (linkLength loc16 loc11) 1)
    (= (linkLength loc2 loc7) 1)
    (= (linkLength loc7 loc2) 1)
    (= (linkLength loc7 loc12) 1)
    (= (linkLength loc12 loc7) 1)
    (= (linkLength loc12 loc17) 1)
    (= (linkLength loc17 loc12) 1)
    (= (linkLength loc17 loc22) 1)
    (= (linkLength loc22 loc17) 1)
    (= (linkLength loc3 loc8) 1)
    (= (linkLength loc8 loc3) 1)
    (= (linkLength loc13 loc18) 1)
    (= (linkLength loc18 loc13) 1)
    (= (linkLength loc4 loc9) 1)
    (= (linkLength loc9 loc4) 1)
    (= (linkLength loc14 loc19) 1)
    (= (linkLength loc19 loc14) 1)
    (= (linkLength loc5 loc10) 1)
    (= (linkLength loc10 loc5) 1)
    (= (linkLength loc10 loc15) 1)
    (= (linkLength loc15 loc10) 1)
    (= (linkLength loc15 loc20) 1)
    (= (linkLength loc20 loc15) 1)
    (= (linkLength loc20 loc25) 1)
    (= (linkLength loc25 loc20) 1)
    
    ;points For
    (= (pointsFor leonardo oscar) 10)
    (= (pointsFor leonardo rosa) 1)
    (= (pointsFor leonardo manzana) 3)
    (= (pointsFor leonardo algoritmo) 4)
    (= (pointsFor leonardo oro) 5)
    (= (pointsFor princesa oscar) 5)
    (= (pointsFor princesa rosa) 10)
    (= (pointsFor princesa manzana) 1)
    (= (pointsFor princesa algoritmo) 3)
    (= (pointsFor princesa oro) 4)
    (= (pointsFor bruja oscar) 4)
    (= (pointsFor bruja rosa) 5)
    (= (pointsFor bruja manzana) 10)
    (= (pointsFor bruja algoritmo) 1)
    (= (pointsFor bruja oro) 3)
    (= (pointsFor profesor oscar) 3)
    (= (pointsFor profesor rosa) 4)
    (= (pointsFor profesor manzana) 5)
    (= (pointsFor profesor algoritmo) 10)
    (= (pointsFor profesor oro) 1)
    (= (pointsFor principe oscar) 1)
    (= (pointsFor principe rosa) 3)
    (= (pointsFor principe manzana) 4)
    (= (pointsFor principe algoritmo) 5)
    (= (pointsFor principe oro) 10)

    ;special locs
    (isSpecial loc22)
    (isKind loc22 agua)
    (isSpecial loc23)
    (isKind loc23 bosque)

    (isSpecial loc20)
    (isKind loc20 precipicio)

    ;not so special locs
    (isKind loc7 arena)
    (isKind loc2 piedra)

    ;position
        ;chars
    (at princesa loc1)
    (at principe loc5)
    (at bruja loc21)
    (at profesor loc25)
    (at leonardo loc13)
        ;gifts
    (at oscar loc7)
    (at oscar loc9)
    (at oscar loc14)
    (at manzana loc17)
    (at manzana loc23)
    (at manzana loc13)
        ;wears
    (at bikini loc16)
    (at zapatilla loc22)

    ;land conditions
    (needs agua bikini)
    (needs bosque zapatilla)

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
    (= (pathLength robot1) 0)
    (= (pointsEarned robot1) 0)
)

(:goal (and
    ;todo: put the goal condition here
        (hasGift princesa)
        (hasGift principe)
        (hasGift bruja)
        (hasGift profesor)
        (hasGift leonardo)
        (> (pointsEarned robot1) 40)
    )
)
;(:metric minimize (pathLength robot1))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)
