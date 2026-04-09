# Tortilla Chip Fracture Study

An experimental investigation into whether moisture loss predicts fracture behaviour in commercially produced tortilla chips. A custom biaxial punch-on-ring apparatus was used to measure fracture force and energy across a range of controlled bake times. Two trials were conducted, plus a brand control.

## Background

Water plasticises the starch-gluten matrix in brittle foods. Below a critical moisture threshold, starchy materials undergo a glass transition from a rubbery to glassy state, substantially altering fracture behaviour. This study tests whether that moisture-fracture relationship is detectable and quantifiable using fracture energy as the primary metric.

## Repository Structure

```
trial1_analysis.ipynb       # Trial 1: hand-cut chips, puffing present
trial2_analysis.ipynb       # Trial 2: 3D-printed chips, puffing suppressed
trialBrand_analysis.ipynb   # Brand control: commercial chips, no bake treatment
fracture_energy_trial1.csv  # Trial 1 raw data
dataProcessing_march25_final.csv  # Trial 2 raw data
dataProcessing_brand.csv    # Brand control raw data
results_summary.csv         # Trial 2 derived quantities (export)
theory.md                   # Derivations and formula reference
Brief.md                    # Project background and fracture mechanics theory
photos/                     # Setup and results photos
```

## Trials

| | Trial 1 | Trial 2 | Brand Control |
|---|---|---|---|
| Chips | Hand-cut tortilla | 3D-printed uniform | Commercial (unmodified) |
| Bake times | 3–7 min (8 groups) | 3–6 min (7 groups) | No baking |
| n | 74 chips | 68 chips | 10 chips |
| Key issue | Puffing dominated signal | Puffing suppressed | No moisture predictor |

## Key Findings

- **Trial 1.** H0 technically rejected (F_max p = 0.007) but the positive slope indicates a puffing artifact, not a real moisture effect. E_f shows no relationship (p = 0.585). CoV 37–68% across metrics. Results not interpretable.
- **Trial 2.** H0 rejected via E_f (R² = 0.145, p = 0.0015). Puffing suppression collapsed the spurious F_max signal and revealed a real, weak moisture-fracture energy relationship. CoV reduced to 19–40%.
- **Key dissociation.** F_peak and F_max are ANOVA-significant by bake time group but not by moisture regression. E_f is the reverse: regression significant, ANOVA not. This identifies moisture loss as the real driver of fracture energy, with force metrics influenced by surface effects independent of moisture.

## Metrics

| Symbol | Meaning |
|---|---|
| F_peak | First-peak force (N). load at initial crack |
| F_max | Maximum force (N) over full test |
| E_f / G_raw | Raw fracture energy (J). area under force-displacement curve |
| G_c | Fracture energy density (J/m²) |
| sigma_c | Biaxial fracture stress (MPa) |
| E | Elastic modulus (MPa) |
| K_Ic | Fracture toughness (Pa.m^0.5) |

## Setup

```bash
pip install -r requirements.txt
jupyter notebook
```

Open `trial1_analysis.ipynb` first. Sample calculations for all derived quantities are in the Appendix of that notebook.

## References

- Braga and Cunha (2002). Water activity and glass transition in starchy foods.
- Roos (1995). Phase Transitions in Foods.
- Atkins and Mai (1985). Elastic and Plastic Fracture.
- Timoshenko and Woinowsky-Krieger (1959). Theory of Plates and Shells.
