# From the Deep

In this problem, you'll write freeform responses to the questions provided in the specification.

## Random Partitioning
Reasons to adopt this approach:
It requires very little thinking and the insertion of observations into the boats happens very quickly due to the random nature
of the insertion.

Reasons not to adopt this approach:
It is evident that running the query on all three boats every time the researcher
wants to have the information of one or more observations is very costly. That happens because all three boats need to be queried
so as the researcher is sure he has not skipped any observations that might be stored in a different boat.

## Partitioning by Hour
Reasons to adopt this approach:
The select queries will be much faster due to the fact that the researcher needs not necessarily scan all boats every time he wants
to have one or more observations

Reasons not to adopt this approach:
If more observations tend to happen in a particular timeframe, then we will have the creation of a hot-spot. One boat might have 1000s of
observation whereas the next one might have none.

## Partitioning by Hash Value
Reason to adopt this approach:
The select queries for a single timestamp will be much faster due to the fact that the hash function always yields the same result for the same timestamp.
We also gain an even distribution and avoid creating hot-spots.

Reasons not to adopt this approach:
It is evident that running the query on all three boats every time the researcher
wants to have the information a range of observations is very costly. That happens because all three boats need to be queried
so as the researcher is sure he has not skipped any observations that might be stored in a different boat. The main issue with
quering for a range of observations is that due to the nature of the hash function, they get stored randomly across all three boats.
