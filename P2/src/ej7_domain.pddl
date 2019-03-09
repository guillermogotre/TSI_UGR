;Header and description

(define (domain BELKAN)

;remove requirements that are not needed
(:requirements :strips :typing :equality :adl :fluents)

(:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
    princesa principe bruja profesor leonardo - character
    oscar manzana rosa algoritmo oro - gift
    zapatilla bikini - wear
    gift wear - takeable
    carrier giver - robot
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
    (carriesHand ?r -robot ?o -takeable)
    (carriesBag ?r -robot ?o -takeable)
    (handFull ?r -robot)
    (bagFull ?r -robot)
    (isSpecial ?l -location)
    (isKind ?l -location ?gk -groundKind)
    (needs ?gk -groundKind ?w -wear)
)


(:functions ;todo: define numeric functions here
    (pathLength ?r -robot)
    (linkLength ?l1 -location ?l2 -location)
    (totalPoints)
    (pointsEarned ?r -robot)
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
        (or
            (carriesHand ?r ?w)
            (carriesBag ?r ?w)
        )
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
    :parameters (?r - carrier ?l -location ?g -takeable)
    :precondition (and 
        (not (handFull ?r))
        (at ?r ?l)
        (at ?g ?l)
    )
    :effect (and 
        (handFull ?r)
        (not (at ?g ?l))
        (carriesHand ?r ?g)
    )
)

(:action DROP
    :parameters (?r -robot ?l -location ?g -takeable)
    :precondition (and 
        (handFull ?r)
        (carriesHand ?r ?g)
        (at ?r ?l)
        (not (isSpecial ?l))
    )
    :effect (and 
        (not (handFull ?r))
        (not (carriesHand ?r ?g))
        (at ?g ?l)
    )
)

(:action DROP-SPECIAL-GIFT
    :parameters (?r -robot ?l -location ?g -gift ?gk -groundKind)
    :precondition (and 
        (handFull ?r)
        (carriesHand ?r ?g)
        (at ?r ?l)
        (isSpecial ?l)
    )
    :effect (and 
        (not (handFull ?r))
        (not (carriesHand ?r ?g))
        (at ?g ?l)
    )
)

(:action DROP-SPECIAL-WEAR
    :parameters (?r -robot ?l -location ?g -wear ?gk -groundKind)
    :precondition (and 
        (handFull ?r)
        (carriesHand ?r ?g)
        (at ?r ?l)
        (isKind ?l ?gk)
        (or
            (carriesBag ?r ?g)
            (not (needs ?gk ?g))
        )
    )
    :effect (and 
        (not (handFull ?r))
        (not (carriesHand ?r ?g))
        (at ?g ?l)
    )
)


(:action GIVE
    :parameters (?r -giver ?l -location ?g -gift ?c -character)
    :precondition (and 
        (at ?r ?l)
        (at ?c ?l)
        (handFull ?r)
        (carriesHand ?r ?g)
        (> (maxGifts ?c) 0)
    )
    :effect (and 
        (not (handFull ?r))
        (not (carriesHand ?r ?g))
        (increase (pointsEarned ?r) (pointsFor ?c ?g))
        (increase (totalPoints) (pointsFor ?c ?g))
        (decrease (maxGifts ?c) 1)
    )
)

(:action GIVE-COOP
    :parameters (?c -carrier ?g -giver ?l -location ?t -takeable)
    :precondition (and 
        (at ?c ?l)
        (at ?g ?l)
        (handFull ?c)
        (carriesHand ?c ?t)
        (not (handFull ?g))
    )
    :effect (and 
        (not (handFull ?c))
        (not (carriesHand ?c ?t))
        (handFull ?g)
        (carriesHand ?g ?t)
    )
)


(:action PUSH-BAG
    :parameters (?r -robot ?o -takeable)
    :precondition (and 
        (handFull ?r)
        (not (bagFull ?r))
        (carriesHand ?r ?o)
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
        (carriesBag ?r ?o)
    )
    :effect (and 
        (handFull ?r)
        (not (bagFull ?r))
        (not (carriesBag ?r ?o))
        (carriesHand ?r ?o)
    )
)





)