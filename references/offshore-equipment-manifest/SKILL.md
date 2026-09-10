---
name: offshore-equipment-manifest
description: Break macro equipment categories into line-item CSV tick-off sheets for offshore diving projects.
version: 2.0
---

# Offshore Equipment Manifest / Tick-Off Sheet

## Trigger
User says "break down [category]" or provides a macro equipment list (e.g. "Rigging Full Kit", "Hand tools Full Kit", "PPE", "Under water NDT inspection kit").

## Output Format — CSV ONLY
The user pastes into Excel to split columns. Output must be:

```
Item,Qty,Notes
Endless Sling 20t x 10m,2,
Webbing Sling 10t x 6m,2,
```

- Header row: `Item,Qty,Notes`
- **No spaces after commas** — raw CSV, paste-ready.
- Notes column left blank by default (user fills in inspection results).
- Items grouped by category with a comma-only Category header row (no separator rows that would break Excel import).
- When the user asks for a complete consolidated manifest, add a Category column before Item for cross-referencing: `Category,Item,Qty,Notes`.

## Two Work Modes

### Mode A: Quick Category Breakdown
Trigger: user names a specific category ("Rigging", "PPE", "Consumables") and expects an immediate inline CSV response. Do NOT write to file unless explicitly asked. End with "Next category?".

### Mode B: Project-Specific (SOW-Based) Manifest
Trigger: user provides a formal Scope of Work / contract document (e.g. Chevron Nigeria SOW, IMCA spec, client technical exhibit). Workflow:

1. Read the entire SOW — do not skip sections. Extract equipment requirements from:
   - Explicit "Minimum Equipment" lists
   - Vessel/plant specifications
   - Crew requirements (implies accommodation, PPE, comms)
   - Work description (implies NDT kit, cleaning gear, tooling)
   - Safety requirements (gas detectors, fire extinguishers, first aid)
   - Documentation requirements (implies office, printer, binder, software)
   - Client-specific mandates (e.g. non-spark tools for hydrocarbon environments, specific gas detector makes)
   - Mobilisation/demobilisation requirements (transport, seafastening)
2. Build a complete project-level CSV with ALL categories — not just the explicit list but everything implied by the scope.
3. Save the output to a named CSV file (user will reference it for packing/mobilisation).
4. Include a Certifications & Documentation category for all compliance deliverables (PEP, WMS, ITP, lifting certs, calibration certs, vessel class certs, SIMOP docs, training records).

## Domain Knowledge — Offshore Diving
All items must be oriented for offshore / subsea diving projects:

### Common Categories

#### General Offshore Kit
- **Rigging**: endless slings, webbing slings, shackles (various tonnages), lever hoists, tirfors, chain blocks, snatch blocks
- **Hand Tools**: brass/chipping hammers, adjustable spanners, flogging spanners, combination spanners, torque wrenches, pinch bars, pipe wrenches, socket sets, pliers, screwdrivers, hacksaws, bolt cutters, files, tap & die sets
- **Underwater Cleaning**: hand scrapers (stainless), wire brushes (stainless & brass/non-spark), diver's axe, chipping hammers, needle guns, HP water jetter, grit blaster
- **PPE**: hard hats (offshore ratchet type), safety glasses, coveralls, gloves (cut-resist/chem/diver's mitts), safety boots, deck boots, high-vis, harnesses, life jackets/PFDs, ear/eye/respiratory protection
- **NDT Inspection**: visual (UW cameras, slates, rulers, verniers), CP (electrodes, probes, meter), UT (flaw detector, probes, couplant, calibration blocks), FMD (transmitter, receiver probe, calibration block), ACFM (instrument, pencil/paintbrush probes, calibration blocks), MPI (yoke, ink, UV lamp)
- **Office**: desks, chairs, whiteboards, printer, stationery, filing, kettle/break room, first aid, fire extinguisher, shredder
- **Consumables**: insulation tape, duct tape, cable ties, PTFE thread tape, polypropylene rope (1/4", 1/2", 1"), paracord (6mm, 8mm), marine rope, rags, self-amalgamating tape, lashing straps, baling twine
- **Seafastening**: holding dogs (screw/wedge type), base plates, chain binders, transport chain (Grade 80/100), turnbuckles, shackles (bolt-type), dunnage timber, pad eyes, deck sockets, welding machine, angle grinder
- **Sun Protection / Deck Cover**: heavy duty umbrellas + stands, tarpaulins (various sizes), shade net, scaffold tube + clamps + boards, ratchet tie-downs, weighted sand bags

#### Project-Specific / SOW Categories (Mode B)
When building from a formal project SOW, these categories are commonly needed:

- **Dive Support Vessel (DSV)**: length, beam, draft, classification, propulsion, thrusters, radars, GPS/DGPS, mooring system, deck crane, dive control station, chambers, compressors, accommodation, galley, workshop, deck space
- **LARS (Launch & Recovery System)**: LARS frame, HPU, control panel, umbilical winch, tensioner, limit switches
- **Air & Gas Systems**: air quads (50L cylinders), O2 quads (medical), cascade system, LP breathing air compressors, Haskell gas transfer pump
- **Hyperbaric**: twin-lock decompression chambers (built-in), chamber comms, fire suppression, SRP (surface rescue pack)
- **Welding & Cutting**: DC welding machines (600amp), U/W oxy-arc burning rigs, O/A cutting equipment, isolating knife switch
- **Hydraulic Tooling**: HPU, U/W impact wrenches, grinders, chippers, hose sets
- **Communications**: fixed VHF, SSB radio, satellite (voice/email/fax), handheld VHF + UHF (client-compatible), multi-charger units, spare batteries
- **Survey & Positioning**: USBL transceiver/beacon, DGPS, GPS (client co-ordinate compatible), Valport current meter + PC
- **Certs & Documentation**: PEP, WMS, ITP, JSA templates, lifting gear certs, instrument calibration certs, vessel class certs, crane 3rd-party cert, anchor handling compliance, pre-mob checklist, SOPs, PTW system, HSE training records, material inventory tracker
- **Non-Spark Tooling** (hydrocarbon facilities): brass hammers, brass chisels, brass scrapers, brass wire brushes, brass wrenches, non-spark sockets — mandatory where metallic spark-generating tools are prohibited
- **Gas Detection**: MSA Altair 5X or Orion multi-gas detectors per client spec (Chevron requires MSA Altair 5X minimum)
- **Fire Safety**: dry chemical extinguishers (30#), fire monitors (DSV), fire-watcher kit, CO2 extinguishers (DDC/office)

### NDT Technique Distinctions (Important)
- **FMD** (Flooded Member Detection) — similar to UT; uses a signal generator + receiver probe to detect water in hollow members. NOT the same as MPI.
- **ACFM** (Alternating Current Field Measurement) — separate technique for surface crack detection; uses pencil/paintbrush probes + instrument + EDM notch reference blocks.
- **UT** (Ultrasonic Testing) — thickness gauging + flaw detection; uses normal/angle beam probes + couplant + calibration blocks.
- **CP** (Cathodic Protection) — potential measurement; uses reference electrodes + diver-held probe + meter.
- **MPI** (Magnetic Particle Inspection) — crack detection at welds; uses yoke + flux indicators + ink + UV lamp.
These are five distinct kits with separate probes, cables, and calibration blocks. Do not conflate them.

### Item Naming Conventions
- Be specific: "Diver's Axe (Lead Handle)" not just "Axe"
- Include material where relevant: "(Stainless)", "(Non-Spark)", "(Offshore Grade)"
- Include size/rating: "Shackle 25t", "Adjustable Spanner 12"", "Webbing Sling 10t x 6m"
- Quantities should reflect a typical project kit, not a single-user kit (e.g. 4 hard hats, not 1)

## Procedure

### Mode A: Quick Category Breakdown
1. Read the user's macro category and any items they've specified.
2. Use domain knowledge (see `references/example-manifests.md` for prior examples) to generate the full breakdown — include items the user might not have listed but that belong in a complete kit.
3. If the user provides specific items within the category, include them all plus fill in any obvious gaps.
4. Output pure CSV directly in the response — do not write to a file unless the user asks.
5. End with "Next category?" — the user is usually working through a long list.

### Mode B: Project-Specific (SOW-Based) Manifest
1. Read the full SOW document. Extract ALL equipment requirements — not just explicit lists but also implied needs (accommodation from crew count, welding from repair scope, comms from reporting requirements, etc.).
2. Identify client-specific mandates: non-spark tools (hydrocarbon facilities), specific gas detector models (e.g. MSA Altair 5X for Chevron), vessel classification requirements, documentation deliverables.
3. Build a comprehensive project-level CSV file. Save to a project-named file (user will use it for packing/mobilisation).
4. Include a Certifications & Documentation category with all compliance deliverables required by the SOW.
5. Inform the user of the file path.

### Items Naming (Both Modes)
- Be specific: "Diver's Axe (Lead Handle)" not just "Axe"
- Include material where relevant: "(Stainless)", "(Non-Spark)", "(Offshore Grade)"
- Include size/rating: "Shackle 25t", "Adjustable Spanner 12\"", "Webbing Sling 10t x 6m"
- Quantities should reflect a typical project kit, not a single-user kit (e.g. 4 hard hats, not 1)
- For SOW-based manifests, use the SOW's own quantity requirements where specified

## Reference Files
- `references/example-manifests.md` — real CSV outputs from prior sessions covering rigging, hand tools, underwater cleaning, PPE, office, and NDT kits
- `references/cnl-sow-equipment-extraction.md` — real CSV output from a Chevron Nigeria API RP 2SIM structural inspection SOW (vessel, diving, NDT, tooling, safety, survey, communications, documentation)

## Pitfalls
- DO NOT output formatted tables, grid lines, or markdown — the user wants raw CSV for Excel.
- DO NOT write to a file unless explicitly asked.
- DO NOT explain or annotate the CSV — just output it.
- Quantities: ask yourself "how many would a diving project actually need?" — 1-2 chains, 4-8 shackles, 2-4 of most hand tools, 1 set of NDT instruments.
- For NDT categories, know the difference between UT, FMD, ACFM, CP, and MPI — they are separate kits with separate probes/sensors.
