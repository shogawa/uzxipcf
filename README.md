
# UZXIPCF: updated zxipcf -ionized partial covering model-

## Parameters


| Parameter | Description | Range | Units | Grid | Step |
| -------- | -------- | -------- | -------- | -------- | -------- |
| Nh     | Hydrogen column density $N_\mathrm{H}$ | 0.01--100 | 10$^{22}$ cm$^{-2}$ | 17 | 0.25 (log) |
| log(xi)| Logarithmic ionization parameter $\log\xi$ | -1--7 | (erg cm s$^{-1}$) | 33 | 0.25 (log) |
| PhoIndex | Photon index | 1.5--2.5 | | 5 | 0.25 (linear) |
| vturb     | Turbulent velocity $v_\mathrm{turb}$ | 100--10000 | km s$^{-1}$ | 5 | 0.5 (log) |
| CvrFract | Covering fraction | 0--1 |  |
| v        | Radial velosity $v_\mathrm{out}$ | | km s$^{-1}$ |
| redshift | Redshift $z$ | |  |

## Compile
```
chmd 755 compile_uzxipcf.sh
./compile_uzxipcf.sh
```

## Loading uzxipcf
at Xspec
```
lmod uzxipcf path/to/uzxipcf
```
or

write the following in ~/.xspec/Xspec.init:
```
LOCAL_MODEL_DIRECTORY:path/to/uzxipcf
```
For example,
```
LOCAL_MODEL_DIRECTORY: /Users/shoji/work/xspec/model/
```
and then
```
lmod uzxipcf
```

## Table Model

### Table Model Parameters
Table model must have Nh, logxi, photon index, and vturb in this order.
Parameter range can be adjusted by editing uzxipcf_lmodel.dat.

### Download

```
wget http://www.kusastro.kyoto-u.ac.jp/~ogawa/model/xstar/xstar_vpi.tgz
tar zxvf xstar_vpi.tgz
```
### Loading Table Model
```
ln -sf path/to/mtable path/to/workingdir/uzxipcf_mtable.fits
```
or at Xspec,
```
xset UZXIPCF_DIR path/to/uzxipcf_mtable.fits
```
"/" must be at the end of the path. For example,
```
xset UZXIPCF_DIR /Users/shoji/work/xspec/model/xstar_vpi/
```

### For Convenience
The followings should be written in ~/.xspec/xspec.rc:
```
xset UZXIPCF_DIR path/to/uzxipcf_mtable.fits
lmod uzxipcf
```

