# CNL / Chevron Nigeria SOW Equipment Extraction

## Source
Scope of Work: "Structural Underwater Integrity Inspection Services — Chevron Nigeria Limited"
Type: API RP 2SIM Level II & III survey of offshore production facilities (platforms, well protectors, pipelines, risers)
Location: Escravos / Forcados / Warri River Delta, Nigeria
Water Depth: 2m to 60m

## Extraction Method
This file records the real CSV output built from clause-by-clause extraction of the SOW.
When a future session encounters a similar project-specific SOW, use the categories below as a checklist.

## SOW Extraction Mapping

The following categories were derived from these SOW sections:
- **DSV & Marine**: Section 3.6 — 73 detailed vessel equipment specs
- **Diving Systems**: Sections 3.6 (items 55-61), 3.13.19 — chambers, compressors, SRP, dive control
- **Inspection (Visual/CP/UT/FMD/MPI)**: Sections 1.3 (full work description), 3.13.19 (minimum equipment)
- **Cleaning/Prep**: Section 3.13.19 — HP water jet, grit blaster, LP road compressor
- **NDT Specific (FMD/ACFM)**: Sections 1.3.2.2 (FMD), user correction — FMD ~ UT not MPI
- **Non-Spark Tools**: Section 3.13.6-3.13.7 — metallic tools prohibited at hydrocarbon facilities; brass mandatory
- **Gas Detection**: Section 3.13.11 — MSA Altair 5X explicitly required (Chevron-mandated)
- **Welding/Cutting**: Section 3.6 (item 65-68) — 600amp DC machines, oxy-arc, O/A
- **Safety**: Sections 3.16.6-3.16.7 — fire watches, extinguishers, gas detectors
- **Certs & Documentation**: Sections 3.10 (guarantees), 3.12 (mobilisation reqs), 3.13.10-3.13.12 (calibration), Attachments 1-13

## CSV Output

File: `cnl-structural-inspection-manifest.csv` (saved to the project folder during session)

```csv
Category,Item,Qty,Notes
PROJECT: CNL STRUCTURAL UNDERWATER INTEGRITY INSPECTION,,,
PROJECT: Chevron Nigeria Limited - Escravos Offshore Facilities,,,
PROJECT: API RP 2SIM Level II & III Survey - Offshore Platforms / Pipelines / Risers,,,
PROJECT:Water Depth 2m - 60m / Nigeria Escravos/Forcados/Warri River Delta,,,
DIVE SUPPORT VESSEL (DSV) - MAIN,,,
,DSV Length 55-65m,1,Min 55-65m LOA / Beam 12-16m
,DSV Draft (Working) 2.4m,1,1 vessel capable of reducing to 2.0m
,DSV Classification (ABS/DNV/Lloyds),1,Less than 25 years from build
,DSV Main Propulsion 2500-3500 BHP,1,Diesel marine engines
,DSV Fixed/Variable Pitch Propellers x2,1 set,
... (full file at path above)
```

## Key Distinctions for This Client
- All hand tools in contact zones must be NON-SPARK (brass) — SOW section 3.13.7
- Gas detectors: MSA Altair 5X (section 3.13.11) — not generic
- 4-point mooring with clump weights (not DP) — section 3.6 item 34
- knuckle crane on starboard side aft — section 3.6 item 24
- Two decompression chambers (twin lock, built-in) — section 3.6 item 55
- Host community equipment hire (boats, houseboats) required — section 3.12.11
- Pre-mob inspection per Procedure 20 (Attachment 13) mandatory before any equipment ships
- DGPS must support Minna coordinate corrections — section 3.6 item 12
- All crew require BOSIET before mobilising — section 3.1.14
