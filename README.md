# SGMA — Strong Ground Motion Analysis

A MATLAB toolset for processing and analysing strong-motion earthquake records
obtained from [AFAD](https://tdvms.afad.gov.tr/) (Disaster and Emergency
Management Presidency of Türkiye).

> Written and tested with **MATLAB R2017b**. If you run into errors, please open
> an issue or get in touch and I'll try to fix them.

## Features

- Reads raw AFAD acceleration records (NS / EW / UD components).
- Band-pass filtering, baseline correction and resampling.
- Time-domain products: Arias intensity, velocity and displacement (via
  integration).
- Frequency-domain spectra via **Welch**, **Yule–Walker AR (`pyulear`)** and
  **DFT** methods.
- Absolute spectral response (response spectra).
- Ground-motion attenuation relationships: **Campbell** and **Boore**.
- Spectral matching against a target design spectrum.
- Plotting and figure export helpers.

## Repository layout

```
main_eqanalysis.m      Entry script: filtering, spectra, response, attenuation, plots
main_spectralmatch.m   Entry script: spectral matching against a target design spectrum
library/               Function library (extract*/plot*/readAFAD)
data/                  Input earthquake datasets (one folder per event)
outputs/               Generated figures (created automatically, git-ignored)
```

## Getting started

1. Place your AFAD dataset in a folder under `data/`, e.g.
   `data/20_07_2017_bodrum/` (see the file-naming convention below).
2. Open `main_eqanalysis.m` (or `main_spectralmatch.m`), set `eqFolderName` to
   your dataset folder name, and adjust the settings blocks.
3. Run the script from the repository root so the relative `data/`, `library/`
   and `outputs/` paths resolve:
   ```matlab
   >> main_eqanalysis      % full analysis
   >> main_spectralmatch   % spectral matching
   ```

Figures are written to `outputs/<event>/<event>_<type>_<YYYYMMDDHHMM>.png`, where
the `_YYYYMMDDHHMM` postfix is the run timestamp (so repeated runs do not
overwrite each other).

## Usage

Both scripts share the same first steps — read the raw AFAD data
(`readAFAD`) and pre-process it (`extractAVXdata`: band-pass filter, baseline
correction, resampling, then Arias intensity / velocity / displacement). They
differ in what they compute afterwards.

> **Note on caching.** On first run `readAFAD` parses the `.txt`/`.csv` files and
> caches the result in `data/<event>/<event>.mat`. Later runs reuse the cache
> unless a raw input file is newer, so editing the data automatically triggers a
> rebuild.

### `main_eqanalysis.m`

Full single-record analysis plus event-wide attenuation. Key settings:

| Setting | Meaning |
| --- | --- |
| `eqFolderName` | Dataset folder name under `data/` |
| `extractSettings.filter_order` | Butterworth low-pass order (default `4`) |
| `extractSettings.filter_cutoff` | Low-pass cutoff in Hz (default `20`) |
| `spcSettings.type` | Spectrum method: `'welch'`, `'aryule'` or `'dft'` |
| `spcSettings.windowing` | `1` Hamming window, `0` none |
| `spcSettings.welch_window_dur` | Welch segment length (s); shorter = smoother |
| `spcSettings.welch_overlap_rat` | Welch overlap ratio `[0–1]` |
| `spcSettings.aryule_p` | AR model order (even) for `'aryule'` |
| `asrSettings.zeta` | Damping ratio for response spectra (e.g. `0.05`) |
| `asrSettings.T_min/T_max/T_step` | Natural-period range and step (s) |
| `asrSettings.T_scale` | Period (s) at which the response is scaled to the design spectrum |
| `arlSettings.type` | Attenuation model: `'campbell'` or `'boore'` |
| `arlSettings.boore_site_class` | `'A'`, `'B'` or `'C'` (Boore only) |
| `arlSettings.range` | Map half-extent around the sources (km) |

Pipeline: `readAFAD` → `extractAVXdata` → `extractFRQdata` → `extractASRdata`
→ `extractARLdata` → plots. The `extractFRQdata`/`extractARLdata`/plot lines for
the alternative methods and site classes are present but commented out — uncomment
the ones you want. Outputs (depending on what is enabled):

| File | Content |
| --- | --- |
| `<event>_Waveform_<ts>.png` | Arias intensity, acceleration, velocity, displacement |
| `<event>_welch_<ts>.png` (or `_aryule_` / `_dft_`) | Amplitude spectra |
| `<event>_ASR_<ts>.png` | Absolute spectral response vs design spectrum |
| `<event>_AR_<ts>.png` | Attenuation (PHA) map with station markers |

### `main_spectralmatch.m`

Selects, per natural period, the recorded response closest to the target design
spectrum across all stations in the dataset. Key settings:

| Setting | Meaning |
| --- | --- |
| `eqFolderName` | Dataset folder name under `data/` |
| `smaSettings.zeta` | Damping ratio (e.g. `0.1`) |
| `smaSettings.T_min/T_max/T_step` | Natural-period range and step (s) |

`spcSettings` / `extractSettings` are the same as above. Pipeline: `readAFAD`
→ `extractAVXdata` → `extractSMAdata` → `plotASRdata`. Output:

| File | Content |
| --- | --- |
| `<event>_SMA_<ts>.png` | Spectrally-matched response vs design spectrum |

Run it on a dataset containing **multiple** station records so there is a
selection to make.

## Data and file-naming convention

Assuming the data comes from AFAD, name the files inside each dataset folder
after the event ID (`20170720223109` for the bundled Bodrum event). Each station
record is a separate `.txt`, while the design spectra are shared per event:

| File | Purpose |
| --- | --- |
| `20170720223109_4801.txt` | Acceleration record (one per station) |
| `20170720223109_ds_h.csv` | Horizontal design (target) spectrum |
| `20170720223109_ds_v.csv` | Vertical design (target) spectrum |

The loader matches the design spectra by their `_ds_h` / `_ds_v` suffix within the
dataset folder. If a dataset contains more than one record, response selection is
performed automatically.

## Example dataset

The bundled template uses the **2017-07-20 Bodrum (Gökova Gulf) earthquake**
(Mw 6.5), recorded by AFAD stations across the Muğla region.
