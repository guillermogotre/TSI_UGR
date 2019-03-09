;Header and description

(define (domain BANANAS)

;remove requirements that are not needed
(:requirements :strips :typing :equality)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
    monkey banana box - locatable
    location
)


(:predicates ;todo: define predicates here
    (on-floor ?x - monkey)
    (at ?m - locatable ?x -location)
    (onbox ?x -monkey ?y - location)
    (hasbananas ?x - monkey)
)

;define actions here
(:action GRAB-BANANA
    :parameters (?m - monkey ?y - location)
    :precondition (and (onbox ?m ?y))
    :effect (and (hasbananas ?m))
)

(:action GET-ON-BOX
    :parameters (?m - monkey ?bx - box ?ba - banana ?l - location)
    :precondition (and 
        (at ?m ?l)
        (at ?bx ?l)
        (at ?ba ?l)
    )
    :effect (and 
        (onbox ?m ?l)
    )
)

(:action PUSH-BOX
    :parameters (?m - monkey ?b -box ?l1 - location ?l2 - location)
    :precondition (and 
        (at ?m ?l1)
        (at ?b ?l1)
        (not (at ?m ?l2))

    )
    :effect (and 
        (at ?m ?l2)
        (at ?b ?l2)
    )
)

(:action GO-TO
    :parameters (?m - monkey ?l - location)
    :precondition (and 
        (not (at ?m ?l))
    )
    :effect (and 
        (at ?m ?l)
    )
)


)