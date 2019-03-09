;Header and description

(define (domain BELKAN)

;remove requirements that are not needed
(:requirements :strips :typing :equality :adl)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
    character
    oscar manzana rosa algoritmo oro - gift
    robot character gift - locatable
    orientation
    location
)

; un-comment following line if constants are needed
;(:constants )

(:predicates ;todo: define predicates here
    (link ?l1 - location ?l2 - location ?o - orientation)
    (at ?x - locatable ?l - location)
    (facing ?r - robot ?o -orientation)
    (right ?o1 -orientation ?o2 -orientation)
    (left ?o1 -orientation ?o2 -orientation)
    (carries ?r -robot ?o -gift)
    (handEmpty ?r -robot)
    (hasGift ?c -character)
)


(:functions ;todo: define numeric functions here
)

;define actions here
(:action GOTO
    :parameters (?r - robot ?o -orientation ?l1 -location ?l2 -location)
    :precondition (and 
        (at ?r ?l1)
        (facing ?r ?o)
        (link ?l1 ?l2 ?o)
    )
    :effect (and 
        (not (at ?r ?l1))
        (at ?r ?l2)
    )
)

(:action TURN-RIGHT
    :parameters (?r -robot ?o1 -orientation ?o2 -orientation)
    :precondition (and 
        (facing ?r ?o1)
        (right ?o1 ?o2)
    )
    :effect (and 
        (not (facing ?r ?o1))
        (facing ?r ?o2)
    )
)

(:action TURN-LEFT
    :parameters (?r -robot ?o1 -orientation ?o2 -orientation)
    :precondition (and 
        (facing ?r ?o1)
        (left ?o1 ?o2)
    )
    :effect (and 
        (not (facing ?r ?o1))
        (facing ?r ?o2)
    )
)

(:action PICK
    :parameters (?r -robot ?l -location ?g -gift)
    :precondition (and 
        (handEmpty ?r)
        (at ?r ?l)
        (at ?g ?l)
    )
    :effect (and 
        (not (handEmpty ?r))
        (not (at ?g ?l))
        (carries ?r ?g)
    )
)

(:action DROP
    :parameters (?r -robot ?l -location ?g -gift)
    :precondition (and 
        (not (handEmpty ?r))
        (carries ?r ?g)
        (at ?r ?l)
    )
    :effect (and 
        (handEmpty ?r)
        (at ?g ?l)
    )
)

(:action GIVE
    :parameters (?r -robot ?l -location ?g -gift ?c -character)
    :precondition (and 
        (at ?r ?l)
        (at ?c ?l)
        (not (handEmpty ?r))
        (carries ?r ?g)
    )
    :effect (and 
        (handEmpty ?r)
        (hasGift ?c)
    )
)




)