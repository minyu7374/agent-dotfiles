# Architectural coherence

Apply coherence within the confirmed task and established contracts. Introduce
abstractions only when current requirements or contracts need them; coherence
does not require new interfaces, base types, or implementation layers.

For extensions and refactors, choose the design as if the requirement existed
on day one; do not bolt a new path beside the old one. Coherence precedes a
small diff: reshape only the affected design when needed, then apply
`minimal-change`. Use the `architectural-coherence` skill for the full design
and review method.
