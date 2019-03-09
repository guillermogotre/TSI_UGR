(define (problem monkey-test1) (:domain BANANAS)
(:objects 
    p1 p2 p3 p4 - location
    monkey1 - monkey
    box1 - box 
    bananas1 - banana 
)

(:init
    ;todo: put the initial state's facts and numeric values here
    ;(onbox monkey1 p2)
    (at monkey1 p3)
    (at box1 p1)
    (at bananas1 p2)
)

(:goal (and
    ;todo: put the goal condition here
        (hasbananas monkey1)
    )
)

;un-comment the following line if metric is needed
;(:metric minimize (???))
)
