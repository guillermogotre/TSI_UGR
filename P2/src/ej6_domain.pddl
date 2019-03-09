;Header and description

(define (domain BELKAN)

;remove requirements that are not needed
(:requirements :strips :typing :equality :adl :fluents)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
    princesa principe bruja profesor leonardo - character
    oscar manzana rosa algoritmo oro - gift
    zapatilla bikini - wear
    gift wear - takeable
    robot character takeable - locatable
    orientation
    location
    groundKind
)

; un-comment following line if constants are needed
;(:constants )

(:predicates ;todo: define predicates here
    (link ?l1 - location ?l2 - location ?o - orientation)
    (at ?x - locatable ?l - location)
    (facing ?r - robot ?o -orientation)
    (right ?o1 -orientation ?o2 -orientation)
    (left ?o1 -orientation ?o2 -orientation)
    (carries ?r -robot ?o -takeable)
    ;carriesHand -> carries and !carriesBag
    (carriesBag ?r -robot ?o -takeable)
    (handFull ?r -robot)
    (bagFull ?r -robot)
    ;(hasGift ?c -character)
    (isSpecial ?l -location)
    (isKind ?l -location ?gk -groundKind)
    (needs ?gk -groundKind ?w -wear)
)


(:functions ;todo: define numeric functions here
    (pathLength ?r -robot)
    (linkLength ?l1 -location ?l2 -location)
    (pointsEarned ?r -robot)
    (totalPoints)
    (pointsFor ?c -character ?g -gift)
    (maxGifts ?c -character)
)

;we separates goto and goto-special
;because if not the output makes no sense
(:action GOTO-SPECIAL
    :parameters (?r - robot ?o -orientation ?l1 -location ?l2 -location ?gk -groundKind ?w -wear)
    :precondition (and 
        (at ?r ?l1)
        (facing ?r ?o)
        (link ?l1 ?l2 ?o)
        (isSpecial ?l2)
        (isKind ?l2 ?gk)
        (needs ?gk ?w)
        (carries ?r ?w)
    )
    :effect (and 
        (not (at ?r ?l1))
        (at ?r ?l2)
        (increase (pathLength ?r) (linkLength ?l1 ?l2))
    )
)

(:action GOTO
    :parameters (?r - robot ?o -orientation ?l1 -location ?l2 -location)
    :precondition (and
        (at ?r ?l1)
        (facing ?r ?o)
        (link ?l1 ?l2 ?o)
        (not (isSpecial ?l2))
    )
    :effect (and 
        (not (at ?r ?l1))
        (at ?r ?l2)
        (increase (pathLength ?r) (linkLength ?l1 ?l2))
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
    :parameters (?r -robot ?l -location ?g -takeable)
    :precondition (and 
        (not (handFull ?r))
        (at ?r ?l)
        (at ?g ?l)
    )
    :effect (and 
        (handFull ?r)
        (not (at ?g ?l))
        (carries ?r ?g)
    )
)

(:action DROP
    :parameters (?r -robot ?l -location ?g -takeable)
    :precondition (and 
        (handFull ?r)
        (carries ?r ?g)
        (not (carriesBag ?r ?g))
        (at ?r ?l)
        (not (isSpecial ?l))
    )
    :effect (and 
        (not (handFull ?r))
        (not (carries ?r ?g))
        (at ?g ?l)
    )
)

(:action DROP-SPECIAL
    :parameters (?r -robot ?l -location ?g -wear ?gk -groundKind)
    :precondition (and 
        (handFull ?r)
        (carries ?r ?g)
        (not (carriesBag ?r ?g))
        (at ?r ?l)
        (isKind ?l ?gk)
        (not (needs ?gk ?g))
    )
    :effect (and 
        (not (handFull ?r))
        (not (carries ?r ?g))
        (at ?g ?l)
    )
)


(:action GIVE
    :parameters (?r -robot ?l -location ?g -gift ?c -character)
    :precondition (and 
        (at ?r ?l)
        (at ?c ?l)
        (handFull ?r)
        (carries ?r ?g)
        (not (carriesBag ?r ?g))
        (> (maxGifts ?c) 0)
    )
    :effect (and 
        (not (handFull ?r))
        (not (carries ?r ?g))
        ;(hasGift ?c)
        (increase (pointsEarned ?r) (pointsFor ?c ?g))
        (increase (totalPoints) (pointsFor ?c ?g))
        (decrease (maxGifts ?c) 1)
    )
)

(:action PUSH-BAG
    :parameters (?r -robot ?o -takeable)
    :precondition (and 
        (handFull ?r)
        (not (bagFull ?r))
        (carries ?r ?o)
    )
    :effect (and 
        (not (handFull ?r))
        (bagFull ?r)
        (carriesBag ?r ?o)
    )
)

(:action PULL-BAG
    :parameters (?r -robot ?o -takeable)
    :precondition (and 
        (not (handFull ?r))
        (bagFull ?r)
        (carries ?r ?o)
    )
    :effect (and 
        (handFull ?r)
        (not (bagFull ?r))
        (not (carriesBag ?r ?o))
    )
)





)